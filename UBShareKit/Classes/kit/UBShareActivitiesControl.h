
#import <Foundation/Foundation.h>

#import "UBShareModel.h"

#import "UBShareResources.h"

@interface UBShareActivitiesControl : NSObject


/*
 * handle url
 */
+ (BOOL)shareControlHandleOpenURL:(NSURL *)url;
+ (BOOL)handleUserActivity:(NSUserActivity *)activity;

/*
 * share method
 * shareType:分享到哪里
 */
+ (void)shareWithModel:(UBShareModel *)model
             shareType:(kShareType)type
       completionBlock:(void(^)(BOOL success,NSString *msg))completion;

+ (void)shareImage:(UIImage *)image text:(NSString *)text
         shareType:(kShareType)type
   completionBlock:(void(^)(BOOL success,NSString *msg))completion;

@end
