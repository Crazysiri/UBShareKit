
#import <UIKit/UIKit.h>

#import "UBShareView.h"

@interface UBDefaultShareView : UIView <UBShareView>

@property (nonatomic,assign) BOOL headerHidden; //是否隐藏标题

@property (nonatomic,assign) CGFloat leftAndRightCornerRadius; //左右圆角 默认 0

#pragma mark - appendview

#define AppendHeaderHeight 45.0f
#define AppendViewHeight 96.0f

//return 当前index
- (NSInteger)addIcon:(UIImage *)icon title:(NSString *)title clickCompletion:(void(^)(void))completion;

- (UIButton *)appendIconViewForIndex:(NSInteger)index;
- (UILabel *)appendLabelForIndex:(NSInteger)index;
@end
