

#import <Foundation/Foundation.h>

typedef NS_ENUM(int,kShareType) {
    kShareToWechatFriend = 0,
    kShareToWechatTimeLine,
    kShareToWechatProgram, //小程序
    kShareToQQ,
    kShareToQzone,
    kShareToSinaWeibo,
    kShareToTencentWeibo,
    kShareToContacts, //通讯录
    kShareToFacebook,
    kShareToTwitter,
    kShareToInstagram,
    kShareToCopy, //复制到剪切板
    kShareToMessage, //发短信
    kShareToMessenger, //facebook的messenger
    kShareToLine, //line
    kShareToWhatsApp, //whatsapp
    kShareToSnapchat, //snapchat
};

@class kShareButton;
@interface UBShareResources : NSObject

/*
 dictArray [
 @{
 channel1:@{key1:imageName1,
           key2:imageName2,
          };
 },
 @{
 channel2:@{key1:imageName1,
           key2:imageName2,
          };
 }];
 */
+ (void)registerShareChannel:(NSString *)channel
                        type:(kShareType)type
                       title:(NSString *)title
              imageDictArray:(NSArray *)dictArray;

+ (NSString *)getTitle:(NSString *)channel;
+ (NSString *)getImage:(NSString *)channel key:(NSString *)key;
+ (kShareType)getShareType:(NSString *)channel;

@end
