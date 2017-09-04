//
//  WSHHWXLogin.m
//  OCJ
//
//  Created by LZB on 2017/4/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "WSHHWXLogin.h"
#import "AFHTTPSessionManager.h"
#import <objc/runtime.h>

//微信开放应用appID
NSString* const wshhThirdPatryWechat_AppID =  @"wx6013c8f57b63e8f5";///< 正式版（可支付、登录、分享）
NSString* const wshhThirdPatryWechat_AppIDNew =  @"wxd7447c5bcb08a606";///< 抢先版（可登录、分享）

static char wechatHandlerKey;

@interface WSHHWXLogin ()

@property (nonatomic, strong) UIImageView *ocjImgView_ready;///<预加载图片

@end

@implementation WSHHWXLogin
+ (instancetype)sharedInstance {
    static WSHHWXLogin *wshhWXLogin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wshhWXLogin = [[self alloc] init];
    });
    return wshhWXLogin;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)wshhWXLoginCompletionHandler:(WSHHWechatHandler)handler {
    if (![WXApi registerApp:wshhThirdPatryWechat_AppID]) {//先注册微信appID
      return;
    }
  
    if ([WXApi isWXAppInstalled]) {
      
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
        
        objc_setAssociatedObject(self, &wechatHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
      
    }else{
        [WSHHAlert wshh_showHudWithTitle:@"您的设备没有安装微信客户端，请选择其他分享途径" andHideDelay:2];
    }
}

- (void)wshhShareToWXWithText:(NSString *)shareText image:(NSString *)shareImage title:(NSString *)shareTitle url:(NSString *)shareUrl type:(WSHHWXShareType)type resultBlock:(void (^)(BaseResp *resp, enum WXErrCode errCode))resultBlock {
  
    if (![WXApi registerApp:wshhThirdPatryWechat_AppID]) {//先注册微信appID
      return;
    }
  
    _resultBlock = resultBlock;
    if (![WXApi isWXAppInstalled]) {
        [WSHHAlert wshh_showHudWithTitle:@"您的设备没有安装微信客户端，请选择其他分享途径" andHideDelay:2];
        return;
    }
  
    WXMediaMessage *message = [WXMediaMessage message];
    
    SendMessageToWXReq  *req = [[SendMessageToWXReq alloc]init];
    
    if (type == WSHHWXShareTypeTimeline) {
        req.scene = WXSceneTimeline;
        OCJLog(@"11");
    }else if (type == WSHHWXShareTypeSession) {
        req.scene = WXSceneSession;
        OCJLog(@"22");
    }
    
  if (![shareImage isKindOfClass:[NSNull class]] && !(shareImage == nil)) {
    [self ocj_prestrainImageWithStr:shareImage ForShare:^(UIImage *image) {
      //依据不同情况设置分享内容
      //    if (shareText && shareImage) {
      
      //当分享同时有文字和图片时，使用URL分享，缩略图+文本的形式
      WXWebpageObject *webPage = [WXWebpageObject object];
      webPage.webpageUrl = shareUrl;
      message.title = shareTitle;
      message.description = shareText;
      message.mediaObject = webPage;
      
      //图片以缩略图的形式，存放在thumbImage中
      [message setThumbImage:[self wshh_fixImageToThumbSize:image]];
      //    }else {
      //        //不同时有文字和图片的情况。
      //        message.title = shareTitle;
      //        if (shareImage) {
      //            OCJLog(@"33");
      //            //分享图片
      //            WXImageObject *ext = [WXImageObject object];
      //            ext.imageData = UIImageJPEGRepresentation(shareImage, 0.5);
      //            message.mediaObject = ext;
      //
      //            req.bText = NO;
      //        }else if(shareText) {
      //            OCJLog(@"44");
      //            //分享文字
      //            req.bText = YES;
      //            message.description = shareText;
      //        }
      //    }
      
      req.message = message;
      req.bText = NO;//不使用文本信息
      
      [WXApi sendReq:req];
    }];
  }else {
    WXWebpageObject *webPage = [WXWebpageObject object];
    webPage.webpageUrl = shareUrl;
    message.title = shareTitle;
    message.description = shareText;
    message.mediaObject = webPage;
    req.message = message;
    req.bText = NO;//不使用文本信息
    
    [WXApi sendReq:req];
  }
  
  
  
}

//预加载分享预览图片
- (void)ocj_prestrainImageWithStr:(NSString *)str ForShare:(void(^)(UIImage *image))block {
    
    //区分是url链接还是图片
    if ([str hasPrefix:@"http"]) {
      
        [self.ocjImgView_ready ocj_setWebImageWithURLString:str completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
          if (block && !error) {
              block(image);
          }
      }];
    }else {
        UIImage *image = [UIImage imageNamed:str];
        block(image);
    }
}

-(UIImageView *)ocjImgView_ready{
  if (!_ocjImgView_ready) {
      _ocjImgView_ready  = [[UIImageView alloc]init];
  }
  return _ocjImgView_ready;
}

/*将图片转化成指定的小图片*/
- (UIImage *)wshh_fixImageToThumbSize:(UIImage *)inputImage
{
    UIImage *outputImage;
    
    //获得image的实际像素尺寸（出去屏幕scale为 1x 2x 3x的影响）
    CGSize imageSize = CGSizeMake(inputImage.size.width, inputImage.size.height);
    
    //计算适合的 imageSize
    CGFloat zoomScale = 1.0f;
    
    if (imageSize.height * imageSize.width > 8192) {
        //若像素个数大于 8192
        zoomScale = sqrt((imageSize.height * imageSize.width) / 8192);
    }
    
    CGSize outPutImageSize = CGSizeMake(imageSize.width / zoomScale, imageSize.height / zoomScale);
    
    //开启一个绘图背景
    UIGraphicsBeginImageContext(outPutImageSize);
    
    [inputImage drawInRect:CGRectMake(0.0f, 0.0f, outPutImageSize.width, outPutImageSize.height)];
    
    //从当前绘图背景当中获取image
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭当前的绘图背景
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

#pragma mark - 微信回调
- (void)onReq:(BaseReq *)req {
    
    OCJLog(@"req = %@", req);
}

- (void)onResp:(BaseResp *)resp {
    OCJLog(@"resp = %d, %@ %d", resp.errCode, resp.errStr, resp.type);
    /*
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     */
    if ([resp isKindOfClass:[SendAuthResp class]]) {//授权登录的类
        if (resp.errCode == 0) {  //成功
            SendAuthResp *resp2 = (SendAuthResp *)resp;
            WSHHWechatHandler handler = objc_getAssociatedObject(self, &wechatHandlerKey);
            if (handler) {
                handler(resp2.code);
            }
        }else{
            [WSHHAlert wshh_showHudWithTitle:@"微信登录授权失败" andHideDelay:2];
        }
    }
    
    //支付回来
    if ([resp isKindOfClass:[PayResp class]]) {
        OCJLog(@"支付");
        ((void (^)(BaseResp *resp, enum WXErrCode errCode))self.resultBlock)(resp,resp.errCode);
        switch (resp.errCode) {
            case WXSuccess://// 支付成功，向后台发送消息
                
                break;
            case WXErrCodeCommon:////签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                
                break;
            case WXErrCodeUserCancel:{//用户点击取消并返回
                
                return;
            }
                break;
                
            default:
                break;
        }
    }else {
        if (self.resultBlock) {
            
            self.resultBlock(resp,resp.errCode);
            
        }
    }
    self.resultBlock = nil;
}

- (void)wshhWXPayByPoCode:(NSDictionary *)pocode block:(void (^)(BaseResp *, enum WXErrCode, NSString *))block {
    if ([WXApi registerApp:wshhThirdPatryWechat_AppID]) {//先注册微信appID
    
      self.resultBlock = (wshhWXShareManagerBlock)block;
    
      PayReq *request = [[PayReq alloc] init];
      request.partnerId = pocode[@"partnerid"];
      request.prepayId = pocode[@"prepayid"];
      request.package = pocode[@"package"];
      request.nonceStr = pocode[@"noncestr"];
      request.timeStamp = [pocode[@"timeStamp"]unsignedIntValue];
      request.sign = pocode[@"sign"];
  
  
      //签名加密
      [WXApi sendReq:request];
    }
}

@end
