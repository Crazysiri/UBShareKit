
#import "UBSystemShare.h"
#import <MessageUI/MessageUI.h>
typedef void(^SystemShareCompletion)(BOOL success);

@interface UBSystemShare () <MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) SystemShareCompletion completion;
@end

@implementation UBSystemShare
static UBSystemShare *_shared_XDJSystemShare;

+ (UBSystemShare *)sharedInstance
{
    if (!_shared_XDJSystemShare) {
        _shared_XDJSystemShare = [[UBSystemShare alloc] init];
    }
    return _shared_XDJSystemShare;
}



+ (void)shareToSystemCopyWithText:(NSString *)text {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;
}


+ (void)shareToMessageWithMessage:(NSString *)msg completion:(void(^)(BOOL success))completion {
    UBSystemShare *share = [UBSystemShare sharedInstance];
    [share shareToMessageWithMessage:msg completion:completion];
}

- (void)shareToMessageWithMessage:(NSString *)msg completion:(void(^)(BOOL success))completion {
    
    self.completion = completion;
    
    //显示发短信的控制器
    
    
    MFMessageComposeViewController *vc =[[MFMessageComposeViewController alloc] init];
    
    // 设置短信内容
    
    vc.body = msg;
    
    // 设置收件人列表
    
//    vc.recipients = @[@"10086", @"13838383838"];
    
    // 设置代理
    
    vc.messageComposeDelegate = self;
    
    // 显示控制器
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;

    
    [root  presentViewController:vc animated:YES completion:nil];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result   {
    
    // 关闭短信界面
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled) {
        if (self.completion) {
            self.completion(NO);
        }
    } else if (result == MessageComposeResultSent) {
        if (self.completion) {
            self.completion(YES);
        }
    } else {
        if (self.completion) {
            self.completion(NO);
        }
    }
}
@end
