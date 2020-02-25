
#import <Foundation/Foundation.h>

@interface UBSystemShare : NSObject
//发短信
+ (void)shareToMessageWithMessage:(NSString *)msg completion:(void(^)(BOOL success))completion;
//拷贝链接
+ (void)shareToSystemCopyWithText:(NSString *)text;
@end
