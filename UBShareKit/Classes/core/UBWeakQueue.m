
#import "UBWeakQueue.h"
@interface UBWeakQueue ()
@property (strong, nonatomic) dispatch_queue_t shareQueue;
@end


@implementation UBWeakQueue

- (void)dealloc {
    
}

- (void)addExeBlock:(void(^)(void))block {
    dispatch_async(self.shareQueue, ^{
        if (block) {
            block();
        }
    });
}

- (dispatch_queue_t)shareQueue
{
    if (!_shareQueue) {
        _shareQueue = dispatch_queue_create("ub_share_queue", DISPATCH_QUEUE_SERIAL);
    }
    return _shareQueue;
}

@end
