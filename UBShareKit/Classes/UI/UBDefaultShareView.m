
#import "UBDefaultShareView.h"

#import "UBShareResources.h"

#import "UIView+imageCorner.h"

#import "UBShareButton.h"

#import <objc/runtime.h>

#define HexRGB_ShareManagerView(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface UBDefaultShareView () {
    BOOL _enableAppendView;//是否启用附加view (调用- (void)addIcon:(UIImage *)icon title:(NSString *)title clickCompletion: 就算开启)
    
    void(^_clickBlock)(NSString *channel);
    
    void(^_closeBlock)(void);


}
@property (weak, nonatomic) IBOutlet UIView *itemsView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *appendView;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appendViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation UBDefaultShareView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = @"分享到";
    _appendView.hidden = YES;
    _appendViewHeightConstraint.constant = 0.0;

    
    [self.bgView share_setCorner:UIRectCornerTopLeft|UIRectCornerTopRight size:CGSizeMake(10, 10) inRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.bgView.bounds.size.height)];
    [self.closeButton share_setCorner:UIRectCornerTopLeft |UIRectCornerTopRight size:CGSizeMake(10, 20) inRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.closeButton.bounds.size.height)];
    [self.closeButton setTitle:@"取消" forState:UIControlStateNormal];
    
}


- (void)setClickBlock:(void (^)(NSString *channel))clickBlock {
    _clickBlock = clickBlock;
}

- (void)setCloseBlock:(void(^)(void))closeBlock {
    _closeBlock = closeBlock;
}

- (void)setupItemsViewWithButtons:(NSArray *)buttons itemViewWidth:(CGFloat)viewWidth
{
    CGFloat vSpace = 14.0f;
    CGFloat leadingSpace = 25.0f;
    CGFloat topSpace = 15.0f;
    
    CGFloat   itemWidth    = 50.0f;
    CGFloat   itemHeight   = 50.0f;
    
    CGFloat   itemHSpace   = 38.0f; //竖向间距
    
    //一行最多能容纳几个
    //    NSInteger itemsInLine = (viewWidth - leadingSpace * 2 + vSpace) / (itemWidth + vSpace);
    NSInteger itemsInLine = 4;
    
    //有几行 更新容器高度
    NSInteger linesCount = ((buttons.count/itemsInLine == 0)?1:(buttons.count / itemsInLine)) + (buttons.count <= itemsInLine?0:(buttons.count % itemsInLine?1:0));
    CGFloat height = 0.0f;
    if (_enableAppendView) {
        height = 75.0 + topSpace * 2 + itemHeight * linesCount + itemHSpace *(linesCount - 1) + AppendHeaderHeight + AppendViewHeight;
        self.frame = CGRectMake(0, self.superview.frame.size.height - height, self.superview.frame.size.width, height);
    } else {
        height = 75.0 + topSpace * 2 + itemHeight * linesCount + itemHSpace *(linesCount - 1) + AppendHeaderHeight;
        self.frame = CGRectMake(0, self.superview.frame.size.height - height, self.superview.frame.size.width, height);
    }
    
    
    //重新计算每个之间的间距
    CGFloat   itemVSpace   = vSpace;
//    if (buttons.count < itemsInLine) {
//        itemVSpace   = (viewWidth - leadingSpace * 2 - itemWidth * buttons.count) / (buttons.count == 1?2.0:(CGFloat)buttons.count - 1.0);
//    }
//    else{
//        itemVSpace   = (viewWidth - leadingSpace * 2 - itemWidth * itemsInLine) / ((CGFloat)itemsInLine - 1.0);
//    }
    itemVSpace   = (viewWidth - leadingSpace * 2 - itemWidth * itemsInLine) / ((CGFloat)itemsInLine - 1.0);

    
    for (NSInteger i = 0; i < buttons.count; i++) {
        
        UBShareButton *shareButton = buttons[i];
        CGFloat x = leadingSpace + (i % itemsInLine) * itemVSpace + itemWidth * (i % itemsInLine);
        CGFloat y = topSpace +(i / itemsInLine) * itemHSpace + itemHeight* (i / itemsInLine);
        shareButton.frame = CGRectMake(x, y, itemWidth, itemWidth);
        
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = HexRGB_ShareManagerView(0x999999);
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = [UBShareResources getTitle:shareButton.channel];
        [label sizeToFit];
        
        CGRect labelFrame = label.frame;
        label.frame = CGRectMake(0, y + itemWidth + 8.0f, labelFrame.size.width, labelFrame.size.height);
        //        label.frame = CGRectMake(x, y + itemWidth + 8.0f, itemWidth + 10.0, 14.0f);
        CGPoint center = label.center;
        label.center = CGPointMake(shareButton.center.x, center.y);
        
        [self.itemsView addSubview:shareButton];
        [self.itemsView addSubview:label];
    }
}

- (void)shareButtonClick:(UBShareButton *)sender {
    if (_clickBlock) {
        _clickBlock(sender.channel);
    }
}

- (IBAction)closeButtonClick:(id)sender {
    if (_closeBlock) {
        _closeBlock();
    }
}

- (void)removeAllItemViews {
    while (self.itemsView.subviews.count) {
        UIView *child = self.itemsView.subviews.lastObject;
        [child removeFromSuperview];
    }
    
}


#pragma mark - appendview

static char AppendViewClickBlockKey;

- (NSInteger)buttonTag {
    return 100;
}

- (NSInteger)labelTag {
    return 1000;
}

- (UIButton *)appendIconViewForIndex:(NSInteger)index {
    NSInteger tag = [self buttonTag] + index;
    return [_appendView viewWithTag:tag];
}

- (UILabel *)appendLabelForIndex:(NSInteger)index {
    NSInteger tag = [self labelTag] + index;
    return [_appendView viewWithTag:tag];
}

- (NSInteger)addIcon:(UIImage *)icon title:(NSString *)title clickCompletion:(void(^)(void))completion {
    
    _enableAppendView = YES;
    
    if (_appendView.hidden) {
        _appendView.hidden = NO;
        _appendViewHeightConstraint.constant = 96.0f;
    }
    
    NSInteger buttonTag = [self buttonTag];
    NSInteger labelTag = [self labelTag];
    
    UIView *lastView = [self lastView];
    
    /*逻辑 w = screenWidth; gap = 25; itemWidth = 50; itemGaps = (w - (4 * itemWidth) - 2 * gap) / 3
     |--------                    screen width                  ---------|
     |-gap-item(itemWidth)-(itemGaps)-item(itemWidth)-(itemGaps)....-gap-|
     
     */
    
    
    CGFloat gap = 25,w = [UIScreen mainScreen].bounds.size.width,itemWidth = 50,itemHeight = 50;
    CGFloat itemsGap = (w - (4 * itemWidth) - 2 * gap) / 3;
    CGFloat top = 11.0f;
    
    CGFloat x = gap;
    if (lastView) {
        x = lastView.frame.origin.x + lastView.frame.size.width + itemsGap;
        buttonTag = lastView.tag + 1;
        labelTag = buttonTag * 10;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (completion) {
        objc_setAssociatedObject(button, &AppendViewClickBlockKey, completion, OBJC_ASSOCIATION_COPY);
    }
    button.frame = CGRectMake(x, top, itemWidth, itemHeight);
    [button setImage:icon forState:UIControlStateNormal];
    [button addTarget:self action:@selector(appendIconButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = buttonTag;
    
    UILabel *label = [[UILabel alloc] init];
    label.tag = labelTag;
    label.textColor = HexRGB_ShareManagerView(0x999999);
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    [label sizeToFit];
    CGRect labelFrame = label.frame;
    label.frame = CGRectMake(0, button.frame.origin.y + button.frame.size.height + 8, labelFrame.size.width, labelFrame.size.height);
    CGPoint center = label.center;
    label.center = CGPointMake(button.center.x, center.y);
    
    
    [self.appendView addSubview:button];
    [self.appendView addSubview:label];
    
    return buttonTag - [self buttonTag];
}

- (void)appendIconButtonClick:(UIButton *)sender {
    void(^block)(void) = objc_getAssociatedObject(sender, &AppendViewClickBlockKey);
    if (block) {
        block();
    }
}

- (UIView *)lastView {
    int firstTag = 100;
    UIView *view = [self.appendView viewWithTag:firstTag];
    while (view) {
        firstTag++;
        UIView *temp = [self.appendView viewWithTag:firstTag];
        if (temp) {
            view = temp;
        } else {
            break;
        }
    }
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
