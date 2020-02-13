

#import <UIKit/UIKit.h>

#import "UBShareView.h"

#import "UBShareKitDataGetter.h"

#import "UBShareViewControllerDelegate.h"

@interface UBShareViewController : UIViewController

@property (weak, nonatomic) id <UBShareViewControllerDelegate> delegate;

@property (copy, nonatomic) void(^shareBeforeStart)(NSString *channel,id model,void(^modelHandler)(id model)); //分享开始之前 需要修改model的情况用的方法

- (id)initWithGetter:(UBShareKitDataGetter *)getter shareView:(UIView <UBShareView> *)view;

- (void)showInController:(UIViewController *)controller;
- (void)close;



@property (readonly, nonatomic ,weak) UIView *backgroundView;


- (void)shareButtonClick:(NSString *)channel; //用来继承重载的，一般情况不用管这个方法


@end
