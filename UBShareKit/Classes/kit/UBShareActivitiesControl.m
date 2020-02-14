
#import "UBShareActivitiesControl.h"

#if __has_include("UBWechat.h")
#define UB_SUPPORT_WECHAT 1
#import "UBWechat.h"
#elif __has_include(<UBWechat.h>)
#define UB_SUPPORT_WECHAT 1
#import <UBWechat.h>
#else
#define UB_SUPPORT_WECHAT 0
#endif

#if __has_include("UBWeibo.h")
#define UB_SUPPORT_WEIBO 1
#import "UBWeibo.h"
#elif __has_include(<UBWeibo.h>)
#define UB_SUPPORT_WEIBO 1
#import <UBWeibo.h>
#else
#define UB_SUPPORT_WEIBO 0
#endif

#if __has_include("UBQQ.h")
#define UB_SUPPORT_QQ 1
#import "UBQQ.h"
#elif __has_include(<UBQQ.h>)
#define UB_SUPPORT_QQ 1
#import <UBQQ.h>
#else
#define UB_SUPPORT_QQ 0
#endif

@implementation UBShareActivitiesControl

+ (NSString *)shareCompletionMsg:(BOOL)success {
    return success ? @"分享成功" : @"分享失败";
}

+ (BOOL)shareControlHandleOpenURL:(NSURL *)url
{
#if UB_SUPPORT_WECHAT
    return [UBWechat handleOpenURL:url];
#endif

    return NO;
}

+ (void)shareWithModel:(UBShareModel *)model
             shareType:(kShareType)type
       completionBlock:(void (^)(BOOL,NSString *))completion
{
    switch (type) {
#if UB_SUPPORT_WECHAT

        case kShareToWechatFriend:
            
        {
            [[UBWechat wechat] shareApplinkToWeiXinWithImage:model.shareImage title:model.title description:model.content link:model.url weiXinscene:WeiXinSceneSession completionBlock:^(BOOL success, NSString *message) {
                if (completion) {
                    completion(success,message);
                }
            }];

            
            break;
        }
        case kShareToWechatTimeLine:
        {
            [[UBWechat wechat] shareApplinkToWeiXinWithImage:model.shareImage title:model.title description:model.content link:model.url weiXinscene:WeiXinSceneTimeline completionBlock:^(BOOL success, NSString *message) {
                if (completion) {
                    completion(success,message);
                }
            }];

            break;
        }
        case kShareToWechatProgram:
        {
            [[UBWechat wechat] shareToMiniProgramTimelineWithUserName:model.wxProgramOrginalIdb path:model.wxProgramPath hdImageData:model.hdImageData miniProgramType:WXMiniProgramTypeRelease webpageUrl:model.url title:model.title description:model.content completionBlock:^(BOOL success, NSString *message) {
                if (completion) {
                    completion(success,message);
                }
            }];
           
            break;
        }
#endif
#if UB_SUPPORT_QQ

        case kShareToQQ:
        {
            [[UBQQ qq] shareToQQWithTitle:model.title description:model.content url:model.url imageUrl:model.previewImageURL compeltion:^(BOOL success) {
                if (completion) {
                      completion(success,[self shareCompletionMsg:success] );
                  }
            }];
            
            break;
        }
        case kShareToQQzone:
        {
            [[UBQQ qq] shareToQzoneWithTitle:model.title description:model.content url:model.url imageUrl:model.previewImageURL compeltion:^(BOOL success) {
                if (completion) {
                      completion(success,[self shareCompletionMsg:success] );
                  }
            }];
            break;
        }
#endif
            
#if UB_SUPPORT_WEIBO
        case kShareToSinaWeibo:
        {
            UBWeibo *weibo = [UBWeibo weibo];
             
            [weibo shareWithText:model.title image:model.shareImage completion:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
            break;
        }
#endif
        default: {
            if (completion) {
                completion(NO,@"渠道不支持");
            }
        }
            break;
    }

}


+ (void)shareImage:(UIImage *)image
              text:(NSString *)text
         shareType:(kShareType)type
   completionBlock:(void(^)(BOOL success,NSString *msg))completion {
    switch (type) {
#if UB_SUPPORT_WECHAT

        case kShareToWechatFriend:
            
        {
            [[UBWechat wechat] shareImageToWeiXin:image weiXinScene:WeiXinSceneSession completionBlock:^(BOOL success, NSString *message) {
                if (completion) {
                    completion(success,message);
                }
            }];

            
            break;
        }
        case kShareToWechatTimeLine:
        {
            [[UBWechat wechat] shareImageToWeiXin:image weiXinScene:WeiXinSceneTimeline completionBlock:^(BOOL success, NSString *message) {
                if (completion) {
                    completion(success,message);
                }
            }];

            break;
        }

#endif
#if UB_SUPPORT_QQ

        case kShareToQQ:
        {
            [[UBQQ qq] shareToQQWithTitle:nil description:text image:image compeltion:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];

            break;
        }
        case kShareToQQzone:
        {
            [[UBQQ qq] shareToQzoneWithTitle:nil description:text image:image compeltion:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
            break;
        }
#endif
            
#if UB_SUPPORT_WEIBO
        case kShareToSinaWeibo:
        {
            UBWeibo *weibo = [UBWeibo weibo];
             
            [weibo shareWithText:text image:image completion:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
            break;
        }
#endif
        default: {
            if (completion) {
                completion(NO,@"渠道不支持");
            }
        }
            break;
    }
}
@end
