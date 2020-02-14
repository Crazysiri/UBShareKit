
#import "UBQQ.h"

#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApi.h>
//#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

static UBQQ *_shared_qq;

@interface UBQQ ()<TencentSessionDelegate, QQApiInterfaceDelegate>
{
    normalCompletion _loginCompletion;
    normalCompletion _shareCompletion;
}

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation UBQQ

+ (void)registerConfig:(UBQQConfig *)config {
    [self qq].config = config;
}


+ (UBQQ *)qq
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared_qq = [[UBQQ alloc] init];
    });
    return _shared_qq;
}

- (void)setConfig:(UBQQConfig *)config
{
    _config = config;
    self.tencentOAuth.appId = config.appId;
}

+ (BOOL)installed
{
    return [QQApiInterface isQQInstalled];
}


#pragma mark - handle openURL -
+ (BOOL)handleOpenURL:(NSURL *)url
{
    UBQQ *qq = [UBQQ qq];
    UBQQConfig *config = qq.config;
    if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@://qzapp", config.appId]])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([url.absoluteString hasPrefix:[NSString stringWithFormat:@"tencent%@://",config.appId]])
    {
        return [QQApiInterface handleOpenURL:url delegate:qq];
    }
    return NO;
}


#pragma mark - startQQLogin -
- (void)loginWithCompletion:(normalCompletion)completion
{
    NSArray *apiArray = [NSArray arrayWithObjects:@"get_simple_userinfo",@"get_info",@"add_t",@"add_pic_t",@"add_one_blog",@"add_topic",@"add_share",@"list_album",@"upload_pic",@"add_album",nil];
    
    [self.tencentOAuth authorize:apiArray];
    _loginCompletion = completion;
}

#pragma mark - tencent oauth delegate -
- (void)tencentDidLogin
{
    if (self.tencentOAuth.accessToken &&  [self.tencentOAuth.accessToken length] != 0) {
        _openId = self.tencentOAuth.openId;
        _expirationDate = self.tencentOAuth.expirationDate;
        _accessToken = self.tencentOAuth.accessToken;
        
        _pf = self.tencentOAuth.passData[@"pf"];
        _pfKey = self.tencentOAuth.passData[@"pfkey"];
        
        
        if (_loginCompletion) {
            _loginCompletion(YES);
        }
    }
    else
    {
        if (_loginCompletion) {
            _loginCompletion(NO);
        }
    }
}
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (_loginCompletion) {
        _loginCompletion(NO);
    }
    
}
- (void)tencentDidNotNetWork
{
    if (_loginCompletion) {
        _loginCompletion(NO);
    }
}
- (void)tencentDidLogout
{
    
}
- (BOOL)onTencentReq:(TencentApiReq *)req
{
    return YES;
}
- (BOOL)onTencentResp:(TencentApiResp *)resp
{
    return YES;
}

#pragma mark - share -
- (SendMessageToQQReq *)getMessageReqWithTitle:(NSString *)title
                                   description:(NSString *)description
                                         image:(UIImage *)image {
    //分享图片
    SendMessageToQQReq *req = nil;
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData previewImageData:imgData title:title description:description];
    req  = [SendMessageToQQReq reqWithContent:imgObj];
    return req;
}

- (SendMessageToQQReq *)getMessageReqWithTitle:(NSString *)title
                                   description:(NSString *)description
                                           url:(NSString *)url
                                      imageUrl:(NSString *)imageUrl
{
    SendMessageToQQReq *req = nil;
    
    //分享：预览图片地址、app下载地址、标题、内容
    if (title) {
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:url]
                                    title:title
                                    description:description
                                    previewImageURL:[NSURL URLWithString:imageUrl]];
        
        req = [SendMessageToQQReq reqWithContent:newsObj];
        return req;
    }
    
    
    return req;
}

- (void)shareToQzoneWithTitle:(NSString *)title
                  description:(NSString *)description
                        image:(UIImage *)image
                   compeltion:(normalCompletion)completion {
    _shareCompletion = completion;
    SendMessageToQQReq *req = [self getMessageReqWithTitle:title description:description image:image];
    dispatch_async(dispatch_get_main_queue(), ^{
        [QQApiInterface SendReqToQZone:req];
    });
}

- (void)shareToQzoneWithTitle:(NSString *)title
                  description:(NSString *)description
                          url:(NSString *)url
                     imageUrl:(NSString *)imageUrl
                   compeltion:(normalCompletion)completion
{
    _shareCompletion = completion;
    SendMessageToQQReq *req = [self getMessageReqWithTitle:title description:description url:url imageUrl:imageUrl];
    dispatch_async(dispatch_get_main_queue(), ^{
        [QQApiInterface SendReqToQZone:req];
    });
}
-  (void)shareToQQWithTitle:(NSString *)title
                description:(NSString *)description
                      image:(UIImage *)image
                 compeltion:(normalCompletion)completion
{
    _shareCompletion = completion;
    SendMessageToQQReq *req = [self getMessageReqWithTitle:title description:description image:image];
    dispatch_async(dispatch_get_main_queue(), ^{
        [QQApiInterface sendReq:req];
    });
    
}

-  (void)shareToQQWithTitle:(NSString *)title
                description:(NSString *)description
                        url:(NSString *)url
                   imageUrl:(NSString *)imageUrl
                 compeltion:(normalCompletion)completion
{
    _shareCompletion = completion;
    SendMessageToQQReq *req = [self getMessageReqWithTitle:title description:description url:url imageUrl:imageUrl];
    dispatch_async(dispatch_get_main_queue(), ^{
        [QQApiInterface sendReq:req];
    });
}


/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req
{
    
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp
{
    //return for share
    
    if (!resp.errorDescription) {
        
        if (_shareCompletion) {
            _shareCompletion(YES);
        }
    }
    else
    {
        if (_shareCompletion) {
            _shareCompletion(NO);
        }
    }
}
/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response
{
    
}

#pragma mark - getter

- (TencentOAuth *)tencentOAuth {
    if (!_tencentOAuth) {
        _tencentOAuth = [[TencentOAuth alloc]initWithAppId:self.config.appId andDelegate:self];
    }
    return _tencentOAuth;
}

@end
