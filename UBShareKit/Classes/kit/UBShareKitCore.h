
/*
 
 1.注册appId 和 添加需要显示的分享渠道
 注册appId需要分别调用渠道自己的方法，例如封装好的UBWechat 的setConfig
 添加分享渠道 调用 UBShareResources registerShareChannel方法

 */

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "UBShareView.h"

#import "UBShareKitDataGetter.h"

#import "UBShareViewController.h"

@interface UBShareKit : NSObject

@property (readonly,weak, nonatomic) UIView <UBShareView> *shareView;

@property (readonly ,nonatomic) UBShareViewController *controller;

//如果UBShareKitDataGetter是网络请求 这块可能需要弹窗等待
@property (copy,nonatomic) void(^beforeGetData)(void);
//如果UBShareKitDataGetter是网络请求 这块可能需要处理一下返回弹窗
@property (copy,nonatomic) void(^afterGetData)(BOOL sucess,NSString *message);
//分享之后的回调
@property (copy,nonatomic) void(^afterShare)(BOOL sucess,NSString *message);


//use default view
+ (UBShareKit *)kitWithGetter:(UBShareKitDataGetter *)getter;

//use custom view
+ (UBShareKit *)kitWithGetter:(UBShareKitDataGetter *)getter shareView:(UIView <UBShareView> *)view;

- (void)show;



+ (BOOL)shareControlHandleOpenURL:(NSURL *)url;
+ (BOOL)handleUserActivity:(NSUserActivity *)activity;

@end
