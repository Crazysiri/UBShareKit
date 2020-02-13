
#import "UIView+imageCorner.h"

@implementation UIView (imageCorner)
- (void)share_setCorner:(UIRectCorner)corner size:(CGSize)size inRect:(CGRect)frame {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corner cornerRadii:size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    
    //设置大小
    maskLayer.frame = frame;
    
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
    //    [self.view addSubview:imageView];
    
}
@end
