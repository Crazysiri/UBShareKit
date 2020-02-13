
#import <Foundation/Foundation.h>

@interface UBWeakQueue : NSObject
- (void)addExeBlock:(void(^)(void))block;
@end
