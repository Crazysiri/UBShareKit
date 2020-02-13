
#ifndef UBShareViewControllerDelegate_h
#define UBShareViewControllerDelegate_h


@protocol UBShareViewControllerDelegate <NSObject>

//和请求有关，获取数据之前，获取数据之后
- (void)beforeGetShareButtons;
- (void)afterGetShareButtons;

//分享结果
- (void)result:(BOOL)success channel:(NSString *)channel message:(NSString *)message;

//点击返回 回调
- (void)back;


@end

#endif /* UBShareViewControllerDelegate_h */
