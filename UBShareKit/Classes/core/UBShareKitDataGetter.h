//
//  UBShareKitDataGetter.h
//  UBShareKit
//
//  Created by qiuyoubo on 2020/2/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UBShareKitDataGetter : NSObject

//获取按钮
- (void)getShareButtons:(void (^)(NSArray *,BOOL success,NSString *msg))completion;
//获取分享内容
/*
    shareContents:{channel:UBShareModel} channel是渠道一般和服务端定义好
 */
- (void)getShareContents:(void(^)(NSDictionary *shareContents))completion;

//分享（一般是点击事件）
- (void)shareWithChannel:(NSString *)channel model:(id)model completion:(void(^)(BOOL success,NSString *msg))completion;


@end

NS_ASSUME_NONNULL_END
