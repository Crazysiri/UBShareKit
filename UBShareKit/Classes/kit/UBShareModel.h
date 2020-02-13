
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
@interface UBShareModel : NSObject

/*
 shareImage
 hdImageData
 如果分享时如果需要，但又没有值 会优先 从这里sharePreviewUrl下载图片
 */

@property (strong,nonatomic) NSString *title;      //标题
@property (strong,nonatomic) NSString *content;//内容
@property (strong,nonatomic) NSString *previewImageURL; //远程图片(一般微博)
@property (strong,nonatomic) NSString *url;     //点击的链接

@property (strong,nonatomic) UIImage  *shareImage;      //图片

@property  (strong, nonatomic) NSString *wxProgramPath;//小程序path
@property  (strong, nonatomic) NSString *wxProgramOrginalIdb;//小程序原始id
@property  (strong, nonatomic) NSData *hdImageData;//高清图data（不是服务器反的自己生成的）
@property  (strong, nonatomic) NSString *download_url;//小程序path


//外部可设置
//分享类型 1 文本 2 图片 默认为1
@property (nonatomic, assign) int type;

+ (id)model;

@end
