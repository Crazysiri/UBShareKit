//
//  Getter.m
//  UBShareKit_Example
//
//  Created by qiuyoubo on 2020/2/13.
//  Copyright © 2020 crazysiri. All rights reserved.
//

#import "Getter.h"

#import <UBShareButton.h>

#import <UBShareModel.h>

#import <UBShareResources.h>

#import <UBShareActivitiesControl.h>

@implementation Getter
//获取按钮
- (void)getShareButtons:(void (^)(NSArray *,BOOL success,NSString *msg))completion {
    
    
    UBShareButton *button = [UBShareButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:[UBShareResources getImage:CHANNEL_TIMELINE key:@"normal"]] forState:UIControlStateNormal];
    button.channel = CHANNEL_TIMELINE;
    
    UBShareButton *link = [UBShareButton buttonWithType:UIButtonTypeCustom];
    [link setImage:[UIImage imageNamed:[UBShareResources getImage:CHANNEL_COPYLINK key:@"normal"]] forState:UIControlStateNormal];
    link.channel = CHANNEL_COPYLINK;
    completion(@[button,link],YES,@"成功");
    
}

//获取分享内容
- (void)getShareContents:(void(^)(NSDictionary *shareContents))completion {
    UBShareModel *model = [UBShareModel model];
    UBShareModel *link = [UBShareModel model];
    completion(@{CHANNEL_TIMELINE:model,CHANNEL_COPYLINK:link});
}

//分享（一般是点击事件）
- (void)shareWithChannel:(NSString *)channel model:(UBShareModel *)model completion:(void(^)(BOOL success,NSString *msg))completion {
        
    kShareType type = [UBShareResources getShareType:channel];
    
    if (model.type == 1) {
        [UBShareActivitiesControl shareWithModel:model shareType:type completionBlock:^(BOOL success,NSString *msg) {
            completion(success,msg);
        }];
    } else if (model.type == 2) {
        [UBShareActivitiesControl shareImage:model.shareImage text:model.title shareType:type completionBlock:^(BOOL success,NSString *msg) {
            completion(success,msg);
            
        }];
    }
}
@end
