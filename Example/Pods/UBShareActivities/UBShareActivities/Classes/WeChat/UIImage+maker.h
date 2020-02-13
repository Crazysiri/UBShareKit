//
//  UIImage+maker.h
//  UBShareActivities
//
//  Created by qiuyoubo on 2020/2/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (maker)

-(NSData *)wechat_imageDataForCompressedToSizeKB:(NSUInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
