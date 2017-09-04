//
//  UIImageView+OCJWebImage.h
//  OCJ
//
//  Created by wb_yangyang on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OCJWebImageHander) (UIImage* _Nullable image, NSError * _Nullable error);

@interface UIImageView (OCJWebImage)


/**
 给imageView设置网络图片（具体功能由SDWebImage实现）

 @param urlStr 网络图片路径
 @param handler 图片下载完成回调
 */
- (void)ocj_setWebImageWithURLString:(NSString *)urlStr
                          completion:(OCJWebImageHander)handler;


/**
 给imageView设置网络图片（具体功能由SDWebImage实现）

 @param urlStr 网络图片路径
 @param image 缺省图
 @param isHideLoading 默认会有菊花转（yes-关闭  no-保持）
 @param handler 图片下载完成回调
 */
-(void)ocj_setWebImageWithURLString:(NSString *_Nullable)urlStr
                   placeHolderImage:(UIImage*_Nullable)placeHolderImage
                        hideLoading:(BOOL)isHideLoading
                         completion:(OCJWebImageHander _Nullable )handler;;


@end
