

#import "UBShareViewController.h"

#import "UBWeakQueue.h"

@interface UBShareViewController () {
    
}
@property (strong, nonatomic) UBWeakQueue *weakQueue;

//@property (strong, nonatomic) dispatch_queue_t shareQueue;

@property (strong, nonatomic) NSDictionary *itemsDic;

@property (strong, nonatomic) NSArray *buttons;    

@property (strong, nonatomic) UIView <UBShareView> *shareView;

@property (nonatomic,strong) UBShareKitDataGetter *getter;

@end

@implementation UBShareViewController

- (id)initWithGetter:(UBShareKitDataGetter *)getter shareView:(UIView<UBShareView> *)view {
    if (self = [super init]) {
        self.getter = getter;
        self.shareView = view;
    }
    return self;
}


- (void)dealloc {
    self.delegate = nil;
}

- (void)showInController:(UIViewController *)controller
{
    [controller addChildViewController:self];
    [controller.view addSubview:self.view];
    self.view.frame = controller.view.bounds;
}

- (void)add {
    [_shareView setFrame:CGRectMake(0,-self.view.bounds.size.height  , self.view.bounds.size.width, 320)];//320默认高度，shareView要能自适应高度
    [self.view addSubview:_shareView];
    __weak typeof(self) weakSelf = self;

    [_shareView setClickBlock:^(NSString *channel) {
        [weakSelf shareButtonClick:channel];
    }];
    [_shareView setCloseBlock:^{
        [weakSelf close];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *bg = [UIButton buttonWithType:UIButtonTypeCustom];
    [bg addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bg];
    
    [bg setFrame:self.view.bounds];
    
    [self add];
    
    _backgroundView = bg;
    
    // Do any additional setup after loading the view from its nib.
    __weak typeof(self) weakSelf = self;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(beforeGetShareButtons)]) {
        [self.delegate beforeGetShareButtons];
    }
    
    [self.getter getShareContents:^(NSDictionary *shareContents) {
        weakSelf.itemsDic = shareContents;
    }];

    [self.getter getShareButtons:^(NSArray * buttons, BOOL success, NSString * _Nonnull msg) {
        weakSelf.buttons = buttons;
        [weakSelf.shareView setupItemsViewWithButtons:buttons itemViewWidth:weakSelf.shareView.bounds.size.width];

        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(afterGetShareButtons:message:)]) {
            [weakSelf.delegate afterGetShareButtons:success message:msg];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UBWeakQueue *)weakQueue {
    if (!_weakQueue) {
        UBWeakQueue *queue = [[UBWeakQueue alloc]init];
        _weakQueue = queue;
    }
    return _weakQueue;
}


- (void)close
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (self.delegate && [self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate back];
    }
}

- (void)shareButtonClick:(NSString *)channel
{

    if (self.itemsDic) {
        [self startShare:channel];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.getter getShareContents:^(NSDictionary *shareContents) {
        weakSelf.itemsDic = shareContents;
        [weakSelf startShare:channel];
    }];

}

- (void)startShare:(NSString *)channel
{
    id model = self.itemsDic[channel];
    if (!model) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(result:channel:message:)]) {
            [self.delegate result:NO channel:channel message:@"获取分享内容失败"];
        }
        return ;
    }
    
    __weak typeof(self) weakSelf = self;

    
    void (^shareBlock)(id) = ^(id model_new) {
        [weakSelf.weakQueue addExeBlock:^{
            [weakSelf.getter shareWithChannel:channel model:model_new completion:^(BOOL success, NSString * _Nonnull msg) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(result:channel:message:)]) {
                    if (success) {
                        if (!msg)
                            msg = @"分享成功";
                    } else {
                        if (!msg)
                            msg = @"分享失败";
                    }
                    [weakSelf.delegate result:success channel:channel message:msg];
                }
            }];
        }];
    };
    
    if (self.shareBeforeStart) {
        self.shareBeforeStart(channel, model, ^(id model_new) {
            shareBlock(model_new);
        });
    }

}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.shareView removeAllItemViews];
    [self.shareView setupItemsViewWithButtons:self.buttons itemViewWidth:size.width];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
