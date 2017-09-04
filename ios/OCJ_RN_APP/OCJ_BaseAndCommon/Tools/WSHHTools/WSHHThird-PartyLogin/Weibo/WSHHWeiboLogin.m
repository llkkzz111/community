//
//  WSHHWeiboLogin.m
//  OCJ
//
//  Created by LZB on 2017/4/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "WSHHWeiboLogin.h"
#import <objc/runtime.h>

@interface WSHHWeiboLogin ()<WBHttpRequestDelegate>

@property (nonatomic, strong) UIImageView *ocjImgView_ready;///<预加载图片

@property (nonatomic, strong) NSString* wbtoken;

@property (nonatomic, strong) NSString* wbCurrentUserID;

@property (nonatomic, strong) NSString *wbRefreshToken;

@end

static char weiboHandlerKey;

@implementation WSHHWeiboLogin

+ (instancetype)sharedInstance {
    static WSHHWeiboLogin *wshhWeiboLogin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wshhWeiboLogin = [[self alloc] init];
    });
    return wshhWeiboLogin;
}

- (void)wshhWeiboLoginWithRedirectURL:(NSString*)redirectUrl scope:(NSString*)scope completionHandler:(WSHHWeiboHandler)handler{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    //必须保证和在微博开放平台应用管理界面配置的“授权回调页”地址一致
    request.redirectURI = redirectUrl;
    request.scope = scope;
    request.shouldShowWebViewForAuthIfCannotSSO = YES;
    //自定义信息,
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
    
    objc_setAssociatedObject(self, &weiboHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)wshhShareSinaWeiboWithText:(NSString *)shareText {
    WBMessageObject *message = [WBMessageObject message];
    message.text = shareText;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
}

- (void)wshhShareSinaWeiboWithText:(NSString *)shareText image:(NSString *)shareImage webUrl:(NSString *)shareWebUrl {
    
    if (![WeiboSDK isWeiboAppInstalled]) {
        [WSHHAlert wshh_showHudWithTitle:@"您的设备没有安装微博客户端，请选择其他分享途径" andHideDelay:2];
        return;
    }
    
    WBMessageObject *message = [WBMessageObject message];
    
    if (shareWebUrl.length > 0) {//有分享链接
        //分享文字：内容 + url地址
        NSString *newShareText = [NSString stringWithFormat:@"%@, %@", shareText, shareWebUrl];
        message.text = newShareText;
    }else {//没有分享链接
        message.text = shareText;
    }
    
    if (shareImage.length > 0) {//有分享图片
    
        [self ocj_prestrainImageWithStr:shareImage ForShare:^(UIImage *image) {
            //消息的图片内容中，图片数据不能为空且大小不能超过10M
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = UIImageJPEGRepresentation(image, 1.0);
            message.imageObject = imageObject;
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
            [WeiboSDK sendRequest:request];
        }];
    }else {//没有分享图片
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:request];
    }
    
}

//使用此方法分享的url不会被删除(只显示内容 + 分享url)
- (void)wshhShareWeiboWithText:(NSString *)shareText title:(NSString *)shareTitle description:(NSString *)shareDescription thumbImage:(NSString *)shareImage webUrl:(NSString *)shareWebUrl {
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://www.ocj.com.cn/main/index.jsp";
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    //    message.text = shareText;
    
    
    [self ocj_prestrainImageWithStr:shareImage ForShare:^(UIImage *image) {
        OCJLog(@"shareshare");
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"sc.com.OCJ.wzw";
        webpage.title = shareTitle;
        webpage.description = shareDescription;
        //图片不能超过32k
        webpage.thumbnailData = UIImageJPEGRepresentation(image, 1.0f);
        webpage.webpageUrl = shareWebUrl;
        message.mediaObject = webpage;
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
        [WeiboSDK sendRequest:request];
    }];
    
}

//预加载分享预览图片
- (void)ocj_prestrainImageWithStr:(NSString *)str ForShare:(void(^)(UIImage *image))block {
    
    //区分是url链接还是图片
    if ([str hasPrefix:@"http"]) {
        //已存在不需要再次加载可以直接分享
        if (self.ocjImgView_ready && self.ocjImgView_ready.image) {
            
            block(self.ocjImgView_ready.image);
        }else {
            if (!self.ocjImgView_ready) {
                self.ocjImgView_ready = [[UIImageView alloc] init];
            }
            
            [self.ocjImgView_ready ocj_setWebImageWithURLString:str completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
              
              if (block && !error) {
                block(image);
              }
              
            }];
        }
    }else {
        UIImage *image = [UIImage imageNamed:str];
        block(image);
    }
}


/*
//预加载分享预览图片
- (void)ocj_prestrainImageWithStr:(NSString *)str ForShare:(void(^)(UIImage *image))block {
    
    //区分是url链接还是图片
    if ([str hasPrefix:@"http://"]) {
        //已存在不需要再次加载可以直接分享
        if (self.ocjImgView_ready && self.ocjImgView_ready.image) {
            
            [self compressedImageFiles:self.ocjImgView_ready.image imageKB:20 imageBlock:^(UIImage *newImage) {
                block(newImage);
            }];
        }else {
            if (!self.ocjImgView_ready) {
                self.ocjImgView_ready = [[UIImageView alloc] init];
            }
            
            [self.ocjImgView_ready sd_setImageWithURL:[NSURL URLWithString:str] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [self compressedImageFiles:image imageKB:20 imageBlock:^(UIImage *newImage) {
                    block(newImage);
                }];
            }];
        }
    }else {
        UIImage *image = [UIImage imageNamed:str];
        block(image);
    }
}

//压缩图片大小
- (void)compressedImageFiles:(UIImage *)image
                     imageKB:(CGFloat)fImageKBytes
                  imageBlock:(void(^)(UIImage *newImage))block {
    
    __block UIImage *imageCope = image;
    CGFloat fImageBytes = fImageKBytes * 1024;//需要压缩的字节Byte
    
    __block NSData *uploadImageData = nil;
    
    uploadImageData = UIImagePNGRepresentation(imageCope);
    NSLog(@"图片压前缩成 %fKB",uploadImageData.length/1024.0);
    CGSize size = imageCope.size;
    CGFloat imageWidth = size.width;
    CGFloat imageHeight = size.height;
    
    if (uploadImageData.length > fImageBytes && fImageBytes >0) {
        
        dispatch_async(dispatch_queue_create("CompressedImage", DISPATCH_QUEUE_SERIAL), ^{
            
            //宽高的比例
            CGFloat ratioOfWH = imageWidth/imageHeight;
            //压缩率
            CGFloat compressionRatio = fImageBytes/uploadImageData.length;
            //宽度或者高度的压缩率
            CGFloat widthOrHeightCompressionRatio = sqrt(compressionRatio);
            
            CGFloat dWidth   = imageWidth *widthOrHeightCompressionRatio;
            CGFloat dHeight  = imageHeight*widthOrHeightCompressionRatio;
            if (ratioOfWH >0) { // 宽 > 高,说明宽度的压缩相对来说更大些
                dHeight = dWidth/ratioOfWH;
            }else {
                dWidth  = dHeight*ratioOfWH;
            }
            
            imageCope = [self drawWithWithImage:imageCope width:dWidth height:dHeight];
            uploadImageData = UIImagePNGRepresentation(imageCope);
            
            NSLog(@"当前的图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            //微调
            NSInteger compressCount = 0;
            // 控制在 1M 以内
            while (fabs(uploadImageData.length - fImageBytes) > 1024) {
                // 再次压缩的比例
                CGFloat nextCompressionRatio = 0.9;
                
                if (uploadImageData.length > fImageBytes) 
                    dWidth = dWidth*nextCompressionRatio;
                    dHeight= dHeight*nextCompressionRatio;
                }else {
                    dWidth = dWidth/nextCompressionRatio;
                    dHeight= dHeight/nextCompressionRatio;
                }
                
                imageCope = [self drawWithWithImage:imageCope width:dWidth height:dHeight];
                uploadImageData = UIImagePNGRepresentation(imageCope);
                
                //防止进入死循环
                compressCount ++;
                if (compressCount == 10) {
                    break;
                }
                
            }
            
            NSLog(@"图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            imageCope = [[UIImage alloc] initWithData:uploadImageData];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                block(imageCope);
            });
        });
    }
    else
    {
        block(imageCope);
    }
}
- (UIImage *)drawWithWithImage:(UIImage *)imageCope width:(CGFloat)dWidth height:(CGFloat)dHeight{
    
    UIGraphicsBeginImageContext(CGSizeMake(dWidth, dHeight));
    [imageCope drawInRect:CGRectMake(0, 0, dWidth, dHeight)];
    imageCope = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCope;
    
}
*/

#pragma mark - WBHttpRequestDelegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error; {
    
}

#pragma mark - 微博回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        
        OCJLog(@"accessToken:%@",self.wbtoken);
        OCJLog(@"refreshToken:%@",self.wbRefreshToken);
        if (self.wbtoken.length) {
            WSHHWeiboHandler handler = objc_getAssociatedObject(self, &weiboHandlerKey);
            if (handler) {
                handler(self.wbtoken);
            }
        }
        
        
    }else if([response isKindOfClass:WBShareMessageToContactResponse.class])
    {
        WBShareMessageToContactResponse* shareMessageToContactResponse = (WBShareMessageToContactResponse*)response;
        NSString* accessToken = [shareMessageToContactResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [shareMessageToContactResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
        if (self.weibogotoOCJLinkVCBlock) {
            self.weibogotoOCJLinkVCBlock(response);
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}


@end
