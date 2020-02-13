
#import "UBShareResources.h"

@implementation UBShareResources

+ (UBShareResources *)shared {
    static dispatch_once_t onceToken;
    static UBShareResources *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UBShareResources alloc] init];
    });
    return sharedInstance;
}

static NSMutableDictionary *_channel_dict_static;

+ (void)registerShareChannel:(NSString *)channel type:(kShareType)type title:(NSString *)title imageDictArray:(NSArray *)dictArray {
    if (!_channel_dict_static) {
        _channel_dict_static = [NSMutableDictionary dictionary];
    }
    
    NSMutableDictionary *channelDict = _channel_dict_static[channel];
    
    if (!channelDict) {
        channelDict = [NSMutableDictionary dictionary];
        _channel_dict_static[channel] = channelDict;
        channelDict[@"type"] = @(type);
    }
    
    if (title)
        [channelDict setObject:title forKey:@"title"];
    
    for (NSDictionary *dict in dictArray) {
        for (NSString *key in dict.allKeys) {
            [channelDict setObject:dict[key] forKey:key];
        }
    }
    
}

+ (NSDictionary *)channelDict:(NSString *)channel {
    return _channel_dict_static[channel];
}

+ (NSString *)getTitle:(NSString *)channel {
    NSDictionary *channelDict = [self channelDict:channel];
    return channelDict[@"title"];
}

+ (NSString *)getImage:(NSString *)channel key:(NSString *)key {
    NSDictionary *channelDict = [self channelDict:channel];
    return channelDict[key];
}

+ (kShareType)getShareType:(NSString *)channel {
    NSDictionary *channelDict = [self channelDict:channel];
    return [channelDict[@"type"] intValue];
}

@end
