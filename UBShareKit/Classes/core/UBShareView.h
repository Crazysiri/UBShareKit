
#ifndef UBShareView_h
#define UBShareView_h

@protocol UBShareView <NSObject>

@property (nonatomic,assign) BOOL headerHidden; //是否隐藏标题

@property (nonatomic,assign) CGFloat leftAndRightCornerRadius; //左右圆角 默认 0

//根据controller得到的 buttons 添加到view上
- (void)setupItemsViewWithButtons:(NSArray *)buttons itemViewWidth:(CGFloat)viewWidth;
- (void)removeAllItemViews;
- (void)setClickBlock:(void(^)(NSString *channel))clickBlock;
- (void)setCloseBlock:(void(^)(void))closeBlock;
@end

#endif /* UBShareView_h */
