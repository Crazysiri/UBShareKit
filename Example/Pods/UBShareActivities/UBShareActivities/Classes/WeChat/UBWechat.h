/*
 需要lib：libc++.tbd libbz.tbd SystemConfiguration.framework libsqlite3.tbd
 */

#import <Foundation/Foundation.h>

#import "WXApi.h"

#import "UBWechatPayConfig.h"

#define WECHAT_KEY_APP_ID @"id" //app id
#define WECHAT_KEY_OPEN_ID @"open" //open id
#define WECHAT_KEY_LINK @"link" //univeralLink

// https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html

typedef enum WeiXinScene
{
    WeiXinSceneSession   = 0,   // 会话
    WeiXinSceneTimeline = 1,    // 朋友圈
}WeiXinScene;

typedef void(^wechatNormalCompletion)(BOOL success,NSString *message);
typedef void(^wechatLoginCompletion)(BOOL success,NSString *code);


@interface UBWechat : NSObject 

#pragma mark - config / get instance
/**
 config  :  id link
 {
    WECHAT_KEY_APP_ID:"",
    WECHAT_KEY_SECRET:""
 }
 该方法尽量只设置一次
 每次调用 + wechat 时会用该设置
 */
+ (void)setConfig:(NSDictionary *)config;

+ (UBWechat *)wechat;

/**
 调用该方法 不会覆盖 setConfig 设置的配置信息
 场景：分享登录用一个appid secrect 使用setConfig方法。支付使用另一个appid secret 使用 wechatWithConfig
 */
+ (UBWechat *)wechatWithConfig:(NSDictionary *)config;


//是否安装
+ (BOOL)installed;

#pragma mark - for app delegatte

/**
 *  微信handle
 *  需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 *  @param url url
 *
 *  @return BOOL
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

/**
 *  微信handle
 *  需要在 application:continueUserActivity:restorationHandler:中调用
 *  @param activity activity
 *
 *  @return BOOL
 */
+ (BOOL)handleUserActivity:(NSUserActivity *)activity;


#pragma mark - functions
#pragma mark 登录

/**
 *  微信登陆
 *
 *  @param completionBlock completion
 */
- (void)loginWithCompletionBlock:(wechatLoginCompletion)completionBlock;

/**
 *  微信登陆成功返回码
 *
 *  @return BOOL
 */
- (NSString *)wechatLoginCode;


#pragma mark 分享


/**
 * 分享图像消息，不带文本 到朋友圈 或者 分享到会话
 *  Share image message without text
 **/
- (void)shareImageToWeiXin:(UIImage *)image
               weiXinScene:(WeiXinScene)wxScene
           completionBlock:(wechatNormalCompletion)completionBlock;


/**
 * 分享文字图片到朋友圈 或者 分享到会话
 *  分享Url类消息,标题，url,小图片
 *  Share Url Message,title,url,thumbnail
 **/
- (void)shareApplinkToWeiXinWithImage:(UIImage *)image
                                title:(NSString *)title
                          description:(NSString *)description
                                 link:(NSString *)linkUrl
                          weiXinscene:(WeiXinScene)wxScene
                      completionBlock:(wechatNormalCompletion)completionBlock;


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
                               completionBlock:(wechatNormalCompletion)completionBlock;


//唤起微信小程序 到某个页面
- (void)launchMiniProgramWith:(NSString *)userName
                         path:(NSString *)path
              miniProgramType:(WXMiniProgramType)miniProgramType
              completionBlock:(wechatNormalCompletion)completionBlock;


#pragma mark 支付


/**
 *  发起支付
 *
 *  @param model      支付model(XDJWechatPayModel)
 *  @param completion completion
 */
- (void)wechatPayWithPayModel:(UBWechatPayConfig *)model
              completionBlock:(wechatNormalCompletion)completion;

@end








@interface UBWechat (userInfo)

/**
 *  获取用户信息
 *  userInfo =
 *  {
 *  city = Haidian;
 *  country = CN;
 *  headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
 *  language = "zh_CN";
 *  nickname = "xxx";
 *  openid = oyAaTjsDx7pl4xxxxxxx;
 *  privilege =     (
 *  );
 *  province = Beijing;
 *  sex = 1;
 *  unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
 *  }
 *
 *  tokenInfos =
 *  {
 *  "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
 *  "expires_in" = 7200;
 *  openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
 *   "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
 *  scope = "snsapi_userinfo,snsapi_base";
 *  }
 */
- (void)getUserInfo:(void(^)(NSDictionary *userInfo,NSDictionary *tokenInfos))completion;
@end
