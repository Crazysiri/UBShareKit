
#import "UBShareKit.h"

#import "UBDefaultShareView.h"

#import "UBShareViewController.h"

#import "UBShareViewControllerDelegate.h"


@interface UBShareKit () <UBShareViewControllerDelegate>

@property (weak, nonatomic) UIView <UBShareView> *shareView;

@end

@implementation UBShareKit

- (void)dealloc {
    
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

#pragma mark - delegate

//和请求有关，获取数据之前，获取数据之后
- (void)beforeGetShareButtons {
//    [MBProgressHUD showPersistentAlert:@"加载中..." inView:weakObjectcontroller.view];
}

- (void)afterGetShareButtons:(BOOL)success message:(NSString *)message {
//    [MBProgressHUD hideHUDForView:weakObjectcontroller.view animated:NO];
//    if (!success) {
//        [MBProgressHUD showAlertWithMessage:msg inView:weakObjectcontroller.view complete:^{
//            [weakObjectcontroller close];
//        }];
//    }
}

//分享结果
- (void)result:(BOOL)success channel:(NSString *)channel message:(NSString *)message {
    
}

//点击返回 回调
- (void)back {
    
}

@end
