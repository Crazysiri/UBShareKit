//
//  XDJShareControl.h
//  XianDanJiaSales
//
//  Created by Jonathan on 16/1/7.
//  Copyright © 2016年 xiandanjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XDJShareModel.h"

#import "XDJShareResources.h"

@interface XDJShareControl : NSObject


/*
 * handle url
 */
+ (BOOL)shareControlHandleOpenURL:(NSURL *)url;


/*
 * share method
 * shareType:分享到哪里
 */
+ (void)shareWithModel:(XDJShareModel *)model shareType:(XDJShareControlShareType)type completionBlock:(void(^)(BOOL success,NSString *msg))completion;

+ (void)shareImage:(UIImage *)image text:(NSString *)text shareType:(XDJShareControlShareType)type completionBlock:(void(^)(BOOL success,NSString *msg))completion;

@end
