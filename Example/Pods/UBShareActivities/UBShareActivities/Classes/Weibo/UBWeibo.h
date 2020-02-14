
#import <UIKit/UIKit.h>

#import "UBWeiboConfig.h"

typedef void(^weiboNormalCompletion)(BOOL success);

@interface UBWeibo : NSObject

@property (strong, readonly, nonatomic) NSString *accessToken;
@property (strong, readonly, nonatomic) NSString *userId;
@property (strong, readonly, nonatomic) NSDate   *expirationDate;

@property (strong, nonatomic) UBWeiboConfig *config;


+ (void)registerAppWithConfig:(UBWeiboConfig *)config;

/*
 * shared
 */
+ (UBWeibo *)weibo;



+ (BOOL)installed;

/*
 * handle openURL
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

/*
 * sina Login
 */
- (void)loginWithCompletion:(weiboNormalCompletion)completion;

/*
 * sina share
 message.text = model.shareDescription;
 [imageObject setImageData:UIImageJPEGRepresentation(model.shareImage, 1.0)];

 */
- (void)shareWithText:(NSString *)text
                image:(UIImage *)image
           completion:(weiboNormalCompletion)completion;

@end
