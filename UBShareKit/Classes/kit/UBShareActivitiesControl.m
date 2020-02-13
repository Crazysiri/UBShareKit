
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

            break;
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
        default: {
            if (completion) {
                completion(NO,@"渠道不支持");
            }
        }
            break;
    }
}
@end
