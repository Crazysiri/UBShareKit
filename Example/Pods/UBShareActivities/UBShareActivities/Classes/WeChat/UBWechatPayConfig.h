
#import <Foundation/Foundation.h>


@interface UBWechatPayConfig : NSObject

@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *partnerId; //商户id
@property (strong, nonatomic) NSString *prepayId; //预支付会话id
@property (strong, nonatomic) NSString *package; //拓展字段 固定值（Sign=WXPay)
@property (strong, nonatomic) NSString *nonceStr; //随机串
@property (strong, nonatomic) NSString *timeStamp; //时间戳
@property (strong, nonatomic) NSString *sign;     //签名

@end

