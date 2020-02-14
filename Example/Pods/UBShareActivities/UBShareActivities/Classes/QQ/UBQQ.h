
#import <Foundation/Foundation.h>

#import "UBQQConfig.h"

#import <UIKit/UIKit.h>

// https://www.jianshu.com/p/6043d5c4be80

/*
 * block
 */
typedef void(^normalCompletion)(BOOL success);

@interface UBQQ : NSObject

@property (retain,nonatomic) NSString *accessToken;
@property (retain,nonatomic) NSString *openId;
@property (strong, nonatomic) NSString *pf;
@property (strong, nonatomic) NSString *pfKey;
@property (retain,nonatomic) NSDate   *expirationDate;

@property (strong, nonatomic) UBQQConfig *config;

+ (void)registerConfig:(UBQQConfig *)config;

/*
 * shared
 */
+ (UBQQ *)qq;


+ (BOOL)installed;


/*
 *handle url
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

/*
 *QQ login
 */
- (void)loginWithCompletion:(normalCompletion)completion;

/*
 * 分享到QQ空间
 */
- (void)shareToQzoneWithTitle:(NSString *)title
                  description:(NSString *)description
                        image:(UIImage *)image
                   compeltion:(normalCompletion)completion;

- (void)shareToQzoneWithTitle:(NSString *)title
                  description:(NSString *)description
                          url:(NSString *)url
                     imageUrl:(NSString *)imageUrl
                   compeltion:(normalCompletion)completion;

/*
 * 分享到QQ好友
 title: model.shareTitle
 description:model.shareDescription
 url:model.shareAppUrl
 imageUrl:model.sharePreviewUrl
 image:bmodel.shareImage
 */
-  (void)shareToQQWithTitle:(NSString *)title
                description:(NSString *)description
                      image:(UIImage *)image
                 compeltion:(normalCompletion)completion;


-  (void)shareToQQWithTitle:(NSString *)title
                description:(NSString *)description
                        url:(NSString *)url
                   imageUrl:(NSString *)imageUrl
                 compeltion:(normalCompletion)completion;



@end
