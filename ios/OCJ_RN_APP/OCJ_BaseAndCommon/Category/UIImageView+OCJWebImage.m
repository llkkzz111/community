//
//  UIImageView+OCJWebImage.m
//  OCJ
//
//  Created by wb_yangyang on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "UIImageView+OCJWebImage.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WSHHExtension.h"

@implementation UIImageView (OCJWebImage)

- (void)ocj_setWebImageWithURLString:(NSString *)urlStr completion:(OCJWebImageHander)handler{
    UIImage* placeHolderImage = [UIImage imageWSHHWithColor:[UIColor colorWSHHFromHexString:@"#ededed"]];
  
  [self ocj_setWebImageWithURLString:urlStr placeHolderImage:placeHolderImage hideLoading:YES completion:handler];
}

-(void)ocj_setWebImageWithURLString:(NSString *)urlStr placeHolderImage:(UIImage *)placeHolderImage hideLoading:(BOOL)isHideLoading completion:(OCJWebImageHander)handler{
    OCJProgressHUD * hud;
    if (!isHideLoading) {
        hud = [OCJProgressHUD ocj_showHudWithView:self andHideDelay:0];
    }
  
    if (![urlStr wshh_stringIsValid]) {
        [self setImage:placeHolderImage];
        return;
    }
  
    if (![urlStr hasPrefix:@"http"]) {
        urlStr = [NSString stringWithFormat:@"https://%@",urlStr];
    }
  
    NSURL* url = [NSURL URLWithString:urlStr];
  
    [self sd_setImageWithURL:url placeholderImage:placeHolderImage options:SDWebImageRefreshCached | SDWebImageAllowInvalidSSLCertificates completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    
        if (hud) {
            [hud ocj_hideHud];
        }
    
        if (handler) {
            handler(image,error);
        }
    }];
}

@end
