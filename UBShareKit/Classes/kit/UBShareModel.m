
#import "UBShareModel.h"

@implementation UBShareModel

+ (id)model {
    return [[self alloc]init];
}

- (id)init {
    self = [super init];
    if (self) {
        _type = 1;
    }
    return self;
}

@end
