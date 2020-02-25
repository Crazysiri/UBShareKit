
#import "UBShareKitCore.h"

#import "UBDefaultShareView.h"

#import "UBShareViewController.h"

#import "UBShareViewControllerDelegate.h"

#import "UBShareActivitiesControl.h"


@interface UBShareKit () <UBShareViewControllerDelegate>

@property (weak, nonatomic) UIView <UBShareView> *shareView;

@end

@implementation UBShareKit

- (void)dealloc {
    NSLog(@"分享销毁");
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

//use default view
+ (UBShareKit *)kitWithGetter:(UBShareKitDataGetter *)getter {
    UBShareKit *kit = [[UBShareKit alloc] init];
    
    NSBundle *bundle = [NSBundle bundleForClass:self];
    UBDefaultShareView *view = [[bundle loadNibNamed:@"UBDefaultShareView" owner:self options:nil]lastObject];

    [kit setupWithGetter:getter shareView:view];
    return kit;
}

//use custom view
+ (UBShareKit *)kitWithGetter:(UBShareKitDataGetter *)getter shareView:(UIView <UBShareView> *)view {
    UBShareKit *kit = [[UBShareKit alloc] init];
    [kit setupWithGetter:getter shareView:view];
    return kit;
}



- (void)setupWithGetter:(UBShareKitDataGetter *)getter shareView:(UIView <UBShareView> *)view {

    self.shareView = view;
        
    UBShareViewController *controller = [[UBShareViewController alloc]initWithGetter:getter shareView:view];
    
    controller.delegate = self;

    _controller = controller;
}

- (void)show {
    [self.controller showInController:UIApplication.sharedApplication.delegate.window.rootViewController];
}

#pragma mark - delegate

//和请求有关，获取数据之前，获取数据之后
- (void)beforeGetShareButtons {
    if (self.beforeGetData) {
        self.beforeGetData();
    }
}

- (void)afterGetShareButtons:(BOOL)success message:(NSString *)message {
    if (self.afterGetData) {
        self.afterGetData(success, message);
    }
    if (!success) {
        [self.controller close];
    }
}

//分享结果
- (void)result:(BOOL)success channel:(NSString *)channel message:(NSString *)message {
    
    if (self.afterShare) {
        self.afterShare(success, message);
    }
    
    if (success) {
        [self.controller close];
    }
}

//点击返回 回调
- (void)back {
    
}


+ (BOOL)shareControlHandleOpenURL:(NSURL *)url {
    return [UBShareActivitiesControl shareControlHandleOpenURL:url];
}

+ (BOOL)handleUserActivity:(NSUserActivity *)activity {
    return [UBShareActivitiesControl handleUserActivity:activity];
}
@end
