//
//  XDJShareControl.m
//  XianDanJiaSales
//
//  Created by Jonathan on 16/1/7.
//  Copyright © 2016年 xiandanjia.com. All rights reserved.
//

#import "XDJShareControl.h"

#import "XDJShareConfig.h"

#import "UIImage+ImageMaker.h"

#import <UBSharePlaces.h>
#import <UBCategories.h>

@implementation XDJShareControl

+ (NSString *)shareCompletionMsg:(BOOL)success {
    return success ? @"分享成功" : @"分享失败";
}

+ (BOOL)shareControlHandleOpenURL:(NSURL *)url
{
    if ([[XDJWechat shareWechat] wechatHandleOpenURL:url]) {
        return YES;
    }
    
    if ([[XDJSina shareSina] sinaHandleOpenURL:url]) {
        return YES;
    }
    
    if([[XDJTencent shareTencent] tencentHandleOpenURL:url]){
        return YES;
    }
    
    return NO;
}

+ (void)shareWithModel:(XDJShareModel *)model shareType:(XDJShareControlShareType)type completionBlock:(void (^)(BOOL,NSString *))completion
{
    switch (type) {
        case XDJShareControlShareToSinaWeibo:
        {
            XDJSina *sina = [XDJSina shareSina];
            
            [sina shareToSinaWeiboWithText:model.shareTitle image:model.shareImage completion:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
            break;
        }
        case XDJShareControlShareToWechatFriend:
            
        {
            XDJWechat *wechat = [XDJWechat shareWechat];
            
            [wechat shareApplinkToWeiXinWithImage: model.shareImage title: model.shareTitle description: model.shareDescription link:model.shareAppUrl weiXinscene: WeiXinSceneSession completionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];

            
            break;
        }
        case XDJShareControlShareToWechatTimeLine:
        {
            XDJWechat *wechat = [XDJWechat shareWechat];
            [wechat shareApplinkToWeiXinWithImage: model.shareImage title: model.shareTitle description: model.shareDescription link:model.shareAppUrl  weiXinscene: WeiXinSceneTimeline completionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];

            break;
        }
        case XDJShareControlShareToWechatProgram:
        {
            XDJWechat *wechat = [XDJWechat shareWechat];
            [wechat shareToMiniProgramTimelineWithUserName:model.wxProgramOrginalIdb path:model.wxProgramPath hdImageData:model.hdImageData miniProgramType: WXMiniProgramTypeRelease webpageUrl:model.shareAppUrl title:model.shareTitle description:model.shareDescription completionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
           
            break;
        }
        case XDJShareControlShareToQQ:
        {
            [[XDJTencent shareTencent] shareToQQWithTitle:model.shareTitle description:model.shareDescription url:model.shareAppUrl imageUrl:model.sharePreviewUrl compeltionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
            break;
        }
        case XDJShareControlShareToQzone:
        {
            [[XDJTencent shareTencent] shareToQzoneWithTitle:model.shareTitle description:model.shareDescription url:model.shareAppUrl imageUrl:model.sharePreviewUrl compeltionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];

            break;
        }
        case XDJShareControlShareToFacebook:
        {
            [XDJFacebook  shareToFacebookWithQuote:model.shareDescription contentURL:model.shareAppUrl to:0 compeltionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
        }
            break;
        case XDJShareControlShareToTwitter:
        {
            [XDJTwitter shareToTwitterWithText:model.shareDescription image:model.shareImage url:model.shareAppUrl compeltionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];

        }
            break;
        case XDJShareControlShareToCopy:
        {
            [XDJSystemShare shareToSystemCopyWithText:model.shareAppUrl];
            if (completion) {
                completion(YES,@"已复制到剪切板" );
            }
        }
            break;
        case XDJShareControlShareToMessage:
        {
            NSString *string = [NSString stringWithFormat:@"%@ %@",model.shareDescription,model.shareAppUrl];
            [XDJSystemShare shareToMessageWithMessage:string completion:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
        }
            break;
        case XDJShareControlShareToMessenger:
        {
            [XDJFacebook  shareToMessengerWithQuote:model.shareDescription contentURL:model.shareAppUrl completionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
            break;
        }
        case XDJShareControlShareToLine:
        {
//            XDJShareCopyAlert *alert = [XDJShareCopyAlert showInView:XDJ_APP.window];
//            NSString *string = [NSString stringWithFormat:@"%@ %@",model.shareDescription,model.shareAppUrl];
//            [alert.titleLabel setText:[NSString stringWithFormat:kLang(@"分享到 %@"),@"LINE"]];
//            [alert.contentLabel setText:string];
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            pasteboard.string = string;
//            [alert receiveConfirmBlock:^{
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"line://"]];
//            }];
        }
            break;
        case XDJShareControlShareToSnapchat:
        {
//            XDJShareCopyAlert *alert = [XDJShareCopyAlert showInView:XDJ_APP.window];
//            NSString *string = [NSString stringWithFormat:@"%@ %@",model.shareDescription,model.shareAppUrl];
//            [alert.titleLabel setText:[NSString stringWithFormat:kLang(@"分享到 %@"),@"Snapchat"]];
//            [alert.contentLabel setText:string];
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            pasteboard.string = string;
//            [alert receiveConfirmBlock:^{
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"snapchat://"]];
//            }];
        }
            break;
        case XDJShareControlShareToWhatsApp:
        {
//            XDJShareCopyAlert *alert = [XDJShareCopyAlert showInView:XDJ_APP.window];
//            NSString *string = [NSString stringWithFormat:@"%@ %@",model.shareDescription,model.shareAppUrl];
//            [alert.titleLabel setText:[NSString stringWithFormat:kLang(@"分享到 %@"),@"WhatsApp"]];
//            [alert.contentLabel setText:string];
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            pasteboard.string = string;
//            [alert receiveConfirmBlock:^{
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"whatsapp://"]];
//
//            }];
            
        }
            break;
        default:
            break;
    }

}


+ (void)shareImage:(UIImage *)image text:(NSString *)text shareType:(XDJShareControlShareType)type completionBlock:(void(^)(BOOL success,NSString *msg))completion {
    switch (type) {
        case XDJShareControlShareToSinaWeibo:
        {
            XDJSina *sina = [XDJSina shareSina];
            
            [sina shareToSinaWeiboWithText:text image:image completion:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
            break;
        }
        case XDJShareControlShareToWechatFriend:
            
        {
            XDJWechat *wechat = [XDJWechat shareWechat];
            
            [wechat shareImageToWeiXin:image weiXinScene:WeiXinSceneSession completionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
            break;
        }
        case XDJShareControlShareToWechatTimeLine:
        {
            XDJWechat *wechat = [XDJWechat shareWechat];
            
            
            [wechat shareImageToWeiXin:image weiXinScene:WeiXinSceneTimeline completionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
            break;
        }
        case XDJShareControlShareToFacebook:
        {
            [XDJFacebook shareImageTofacebook:image compeltionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
        }
            break;
        case XDJShareControlShareToTwitter:
        {

            [XDJTwitter shareToTwitterWithText:text image:image url:nil compeltionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
        }
            break;
        case XDJShareControlShareToMessenger:
        {
            [XDJFacebook shareImageToMessenger:image compeltionBlock:^(BOOL success) {
                if (completion) {
                    completion(success,[self shareCompletionMsg:success] );
                }
            }];
            break;
        }
        case XDJShareControlShareToQQ:
        case XDJShareControlShareToQzone:
        case XDJShareControlShareToMessage:
        case XDJShareControlShareToLine:
        case XDJShareControlShareToSnapchat:
        case XDJShareControlShareToWhatsApp:
        case XDJShareControlShareToWechatProgram:
        default:
//            [MBProgressHUD showAlertWithMessage:@"not support" inView:nil complete:nil];
            break;
    }
}
@end
