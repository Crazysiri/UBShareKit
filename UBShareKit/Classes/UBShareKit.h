#ifndef UBShareKit_h
#define UBShareKit_h

//kit 分享中间件，一般调用这里的api
#import "UBShareKitCore.h"
#import "UBShareActivitiesControl.h"
#import "UBShareModel.h"

//默认UI 如果需要可以 尊守 UBShareView 协议自定义UI
#import "UBDefaultShareView.h"
#import "UBShareButton.h"

//core 分享组件核心
#import "UBShareViewController.h" //控制器
#import "UBShareKitDataGetter.h"//数据源获取
#import "UBShareResources.h" //分享渠道及资源（icon）注册

#endif /* UBShareKit_h */

/**
 
 一般用法：
 0.pod需要的库，例如微信分享
    现有微信，qq，微博，系统分享支持
    pod 'UBShareActivities/Wechat',:git => 'https://github.com/Crazysiri/UBShareActivities.git'
 1.Appdelegate中设置 key相关
    1）[UBWechat setConfig:@{WECHAT_KEY_APP_ID:@"xxx"}];
    2）注册需要分享的渠道
                CHANNEL_TIMELINE = "timeline" //自定义类型，如果有服务端参与（分享内容服务端返回），需要定义成和服务端一致的
                imageDictArray 图片可根据UBShareKitDataGetter选择不同的图片，详情看demo中的Getter类
        [UBShareResources registerShareChannel:CHANNEL_TIMELINE
                                       type:kShareToWechatTimeLine
                                      title:@"微信朋友圈"
                             imageDictArray:@[
                                              @{@"normal":@"微信好友"},
                                              ]];
    3)      + (BOOL)shareControlHandleOpenURL:(NSURL *)url;
        + (BOOL)handleUserActivity:(NSUserActivity *)activity;

 2.
 采用默认UI：DefaultUI 直接初始化 + (UBShareKit *)kitWithGetter:(UBShareKitDataGetter *)getter;
 采用自定义UI：+ (UBShareKit *)kitWithGetter:(UBShareKitDataGetter *)getter shareView:(UIView <UBShareView> *)view;
3.调用show
 
 
 */
