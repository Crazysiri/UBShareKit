

#import "UBWechat.h"

#import "UIImage+maker.h"

static UBWechat *_shared_wechat;

static NSDictionary *_wechat_config;

static NSString *_current_app_id; //记录当前app id

#define ONE_KB 1024.0

@interface UBWechat () <WXApiDelegate>

#pragma mark  - 参数
@property (nonatomic,copy) NSString *appid;
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *openid;


@property (strong, nonatomic) wechatNormalCompletion shareCompletion;
@property (strong, nonatomic) wechatLoginCompletion loginCompletion;
@property (strong, nonatomic) wechatNormalCompletion payCompletion;

@property (strong, nonatomic) NSString *wechatLoginCode; //登录后的返回码
@end


@implementation UBWechat

+ (void)setConfig:(NSDictionary *)config {
    
    _wechat_config = config;
    
    [WXApi registerApp:config[WECHAT_KEY_APP_ID] universalLink:config[WECHAT_KEY_LINK]];

    _current_app_id = config[WECHAT_KEY_APP_ID];
}



+ (UBWechat *)wechat
{
    return [UBWechat wechatWithConfig:_wechat_config];
}

+ (UBWechat *)currentWechat {
    return _shared_wechat;
}

+ (UBWechat *)wechatWithConfig:(NSDictionary *)config {
    
    if (!config || !config[WECHAT_KEY_APP_ID] || !config[WECHAT_KEY_LINK] || !config[WECHAT_KEY_OPEN_ID]) {
        
        NSException *exception = [NSException exceptionWithName:@"参数设置错误" reason:@"请先调用 setConfig 设置 @{\"id\":\"\",\"link\":\"\",\"open\":\"\"}" userInfo:nil];
        [exception raise];
        return nil;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shared_wechat) {
            _shared_wechat = [[UBWechat alloc] init];
        }
    });
    _shared_wechat.appid = config[WECHAT_KEY_APP_ID];
    _shared_wechat.link = config[WECHAT_KEY_LINK];
    _shared_wechat.openid = config[WECHAT_KEY_OPEN_ID];
    
    
    if (_current_app_id != _shared_wechat.appid) { //如果不一样 才注册
        [WXApi registerApp:_shared_wechat.appid universalLink:_shared_wechat.link];
        _current_app_id = _shared_wechat.appid;
    }

    return _shared_wechat;
}

+ (BOOL)installed
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        return YES;
    }
    return [WXApi isWXAppInstalled];
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}



+ (BOOL)handleOpenURL:(NSURL *)url;
{
    
    NSRange range = [url.absoluteString rangeOfString: [self currentWechat].appid];
    if (range.location != NSNotFound) {
        return [WXApi handleOpenURL:url delegate:[self currentWechat]];
    }
    return NO;
}


+ (BOOL)handleUserActivity:(NSUserActivity *)activity;
{
    return [WXApi handleOpenUniversalLink:activity delegate:[self currentWechat]];
}




- (void)loginWithCompletionBlock:(wechatLoginCompletion)completionBlock
{
    self.loginCompletion = completionBlock;
    
    _wechatLoginCode = nil;
    //构造SendAuthReq结构体
    
    SendAuthReq* req = [[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact" ;
    req.state = @"xxx"; //TODO: 这块也需要外部设置
    req.openID = self.openid;
    
    UIViewController *root = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    
    __weak typeof(self) weakself = self;
    
    [WXApi sendAuthReq:req
        viewController:root
              delegate:self
            completion:^(BOOL success) {
        if (completionBlock) {//TODO:该逻辑有待考证什么时候调用
            completionBlock(success,weakself.wechatLoginCode);
        }
    }];

}



- (NSData *)imageData:(UIImage *)image
{
    return [image wechat_imageDataForCompressedToSizeKB:64];
}


/**
 *  分享图像消息，不带文本
 *  Share image message without text
 **/
- (void)shareImageToWeiXin:(UIImage *)image
               weiXinScene:(WeiXinScene)wxScene
           completionBlock:(wechatNormalCompletion)completionBlock
{
    
    if (![UBWechat installed])
    {
        if (completionBlock) {
            completionBlock(NO,@"微信未安装！");
        }
        return;
    }
    
    self.shareCompletion = completionBlock;
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = data;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = ext;
    message.thumbData = [self imageData:image]; //设置缩略图，大小不能超过64k，超过不再连接到微信
//    message.mediaTagName = @"WECHAT_TAG_JUMP_APP";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;//yes代表纯文本 no代表多媒体
    req.message = message;
    req.scene = wxScene;//发送的目标场景， 可以选择发送到会话(WXSceneSession)或者朋友圈(WXSceneTimeline)。
    
    [WXApi sendReq:req completion:nil];
}


/**
 *  分享Url类消息,标题，url,小图片
 *  Share Url Message,title,url,thumbnail
 **/
- (void)shareApplinkToWeiXinWithImage:(UIImage *)image
                                title:(NSString *)title
                          description:(NSString *)description
                                 link:(NSString *)linkUrl
                          weiXinscene:(WeiXinScene)wxScene
                      completionBlock:(wechatNormalCompletion)completionBlock
{
    if (![UBWechat installed])
    {
        if (completionBlock) {
            completionBlock(NO,@"微信未安装！");
        }
        return;
    }
    
    self.shareCompletion = completionBlock;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.thumbData = [self imageData:image];//设置缩略图，大小不能超过64k，超过不再连接到微信
    message.title = [NSString stringWithFormat: @"%@",title];//设置标题
    message.description = description;
//    message.mediaTagName = @"WECHAT_TAG_JUMP_APP";

    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = linkUrl;//设置点击链接
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;  //yes代表纯文本 no代表多媒体
    req.message = message;
    req.scene = wxScene;  //发送的目标场景， 可以选择发送到会话(WXSceneSession)或者朋友圈(WXSceneTimeline)。
    [WXApi sendReq:req completion:nil];
}




/**
 *  分享到小程序
 *  Share to friend circle
 *  userName://小程序的原始id
 *  path : //小程序页面路径
 *  hdImageData : ////小程序节点高清大图 小于128k
 *  miniProgramType //小程序版本
 *  webpageUrl //兼容低版本的网页链接
 *  title //分享到会话时的标题
 *  description //分享到会话时的描述
 **/
- (void)shareToMiniProgramTimelineWithUserName:(NSString *)userName
                                          path:(NSString *)path
                                   hdImageData:(NSData *)hdImageData
                               miniProgramType:(WXMiniProgramType)miniProgramType
                                    webpageUrl:(NSString *)webpageUrl
                                         title:(NSString *)title
                                   description:(NSString *)description
                               completionBlock:(wechatNormalCompletion)completionBlock {
        
    if (![UBWechat installed])
    {
        if (completionBlock) {
            completionBlock(NO,@"微信未安装！");
        }
        return;
    }
    
    self.shareCompletion = completionBlock;
    
    WXMiniProgramObject *wxMiniObject = [WXMiniProgramObject object];
    wxMiniObject.webpageUrl = webpageUrl; //兼容低版本的网页链接
    wxMiniObject.userName = userName; //小程序的原始id
    wxMiniObject.path = path; //小程序页面路径
    wxMiniObject.hdImageData = hdImageData; //小程序节点高清大图 小于128k
    wxMiniObject.miniProgramType =  miniProgramType;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = wxMiniObject;
    //    message.thumbData = nil;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req completion:nil];
    
}

- (void)launchMiniProgramWith:(NSString *)userName
                         path:(NSString *)path
              miniProgramType:(WXMiniProgramType)miniProgramType
              completionBlock:(wechatNormalCompletion)completionBlock {
    
    if (![UBWechat installed])
    {
        if (completionBlock) {
            completionBlock(NO,@"微信未安装！");
        }
        return;
    }
    
    self.shareCompletion = completionBlock;

    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = userName;  //拉起的小程序的username
    launchMiniProgramReq.path = path;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
    launchMiniProgramReq.miniProgramType = miniProgramType; //拉起小程序的类型

    [WXApi sendReq:launchMiniProgramReq completion:nil];

}






/**
 *  支付
 */
- (void)wechatPayWithPayModel:(UBWechatPayConfig *)model
              completionBlock:(wechatNormalCompletion)completion
{
    self.payCompletion = completion;
    PayReq *request = [[PayReq alloc] init];
    request.openID = model.appId;
    request.partnerId = model.partnerId;
    request.prepayId= model.prepayId;
    request.package = model.package;
    request.nonceStr= model.nonceStr;
    request.timeStamp= [model.timeStamp intValue];
    request.sign= model.sign;
    [WXApi sendReq:request completion:nil];
}


#pragma mark - WechatDelegate

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        //        [self onRequestAppMessage];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        //        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        //        [self onShowMediaMessage:temp.message];
    }
}

-(void) onResp:(BaseResp*)resp
{
    //分享
    if([resp isKindOfClass:[SendMessageToWXResp class]] || [resp isKindOfClass:[WXLaunchMiniProgramResp class]])
    {
        //        NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%d", resp.errCode];
        if (self.shareCompletion)
        {
            self.shareCompletion(resp.errCode == WXSuccess ? YES : NO, resp.errStr);
        }

    }
    //授权
    else if([resp isKindOfClass:[SendAuthResp class]]){
        
        if (resp.errCode == WXSuccess )
        {
            _wechatLoginCode = ((SendAuthResp *)resp).code;
            
            if (self.loginCompletion)
            {
                self.loginCompletion(YES,_wechatLoginCode);
            }
            
        }
        else
        {
            if (self.loginCompletion)
            {
                self.loginCompletion(NO,nil);
            }
        }
    }
    else  if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        if (self.payCompletion) {
            //服务器端查询支付通知或查询API返回的结果再提示成功
            self.payCompletion(response.errCode == WXSuccess ? YES : NO ,response.errStr);
        }
    }
}

@end



@implementation UBWechat(userInfo)

-(void)getAccess_token:(void(^)(NSDictionary *tokenInfos))completion
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    /*appId,secret是从微信公众平台获取
     wechatLoginCode是登录授权成功回调获取的，具体看onResp方法
     */
    
    NSString *secret = @"";
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",self.appid,secret,self.wechatLoginCode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                completion(dic);
                
            } else {
                completion(nil);
            }
        });
    });
}

- (void)getUserInfo:(void(^)(NSDictionary *userInfo,NSDictionary *tokenInfos))completion {
    [self getAccess_token:^(NSDictionary *tokenInfos) {
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",tokenInfos[@"access_token"],tokenInfos[@"openid"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *zoneUrl = [NSURL URLWithString:url];
            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    completion(dic,tokenInfos);
                    
                }
                else {
                    completion(nil,nil);
                }
            });
            
        });
    }];
    
}

@end

