
#import "UBWeibo.h"
#import "WeiboSDK.h"

static UBWeibo *_shared_weibo;

@interface UBWeibo () <WeiboSDKDelegate,WBHttpRequestDelegate>

@property (copy, nonatomic) weiboNormalCompletion sinaLoginCompletion;
@property (copy, nonatomic) weiboNormalCompletion sinaShareResult;

@end

@implementation UBWeibo
//存到 self.config中
+ (void)registerAppWithConfig:(UBWeiboConfig *)config {    
    [self weibo].config = config;
}

+ (UBWeibo *)weibo {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared_weibo = [[UBWeibo alloc] init];
    });
    return _shared_weibo;
}

+ (BOOL)installed
{
    return [WeiboSDK isWeiboAppInstalled];
}


- (void)setConfig:(UBWeiboConfig *)config
{
    _config = config;
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:config.appKey];
}


#pragma mark - handle open url -

+(BOOL)handleOpenURL:(NSURL *)url {
    UBWeiboConfig *config = [self weibo].config;
    if (!config) {
        return NO;
    }
    NSRange range = [url.absoluteString rangeOfString: [NSString stringWithFormat:@"wb%@",config.appKey] ];
    if (range.location != NSNotFound)
    {
        return [WeiboSDK handleOpenURL: url delegate: [self weibo] ];
    }
    return NO;
}

#pragma mark - start sina login and share -

- (void)loginWithCompletion:(weiboNormalCompletion)completion
{
    _sinaLoginCompletion = completion;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = self.config.redirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)shareWithText:(NSString *)text
                image:(UIImage *)image
           completion:(weiboNormalCompletion)completion
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = text;
    WBImageObject *imageObject = [WBImageObject object];
    [imageObject setImageData:UIImageJPEGRepresentation(image, 1.0)];
    message.imageObject = imageObject;
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:self.accessToken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};

    [WeiboSDK sendRequest:request];
     _sinaShareResult = completion;
}

#pragma mark - wb http request delegate -
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    if (_sinaLoginCompletion) {
        _sinaLoginCompletion(YES);
    }
}
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    if (_sinaLoginCompletion) {
        _sinaLoginCompletion(NO);
    }
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    
}

#pragma mark - sina oauth delegate -
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        WBAuthorizeResponse *authorizeResponse = (WBAuthorizeResponse *)response;
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            _userId = authorizeResponse.userID;
            _expirationDate = authorizeResponse.expirationDate;
            _accessToken = authorizeResponse.accessToken;

            if(_sinaLoginCompletion)
            {
                _sinaLoginCompletion(YES);
            }
        }
        else
        {
            if(_sinaLoginCompletion)
            {
                _sinaLoginCompletion(NO);
            }
        }
    }// share type
    else if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if(response.statusCode == WeiboSDKResponseStatusCodeSuccess)
        {
            if(_sinaShareResult)
            {
                _sinaShareResult(YES);
            }
        }
        else
        {
            if (_sinaShareResult) {
                _sinaShareResult(NO);
            }
            
        }
    }
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}



@end
