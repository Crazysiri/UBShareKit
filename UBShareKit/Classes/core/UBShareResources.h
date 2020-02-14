

#import <Foundation/Foundation.h>

typedef NS_ENUM(int,kShareType) {
    kShareToWechatFriend = 0,
    kShareToWechatTimeLine,
    kShareToWechatProgram, //小程序
    kShareToQQ,
    kShareToQQzone,
    kShareToQQWeibo,
    kShareToSinaWeibo,
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
 
 channel 一般是和服务端定义好的类型
 type 和 channel对应的本地类型
 title 一般是按钮上显示的名字
 dictArray 是分享按钮图片，因为每个页面分享可能图片不一样，就用key区分
 
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

+ (NSString *)getImage:(NSString *)channel
                   key:(NSString *)key;

+ (kShareType)getShareType:(NSString *)channel;

@end
