//
//  UIImage+WSHHExtension.h
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface UIImage (WSHHExtension)
/**
 *  生成纯色图片
 *
 *  @param color 颜色
 *
 *  @return 返回图片
 */
+(UIImage*)imageWSHHWithColor:(UIColor*)color;

/**
 *  压缩图片到规定尺寸
 *
 *  @param newSize 规定尺寸
 *
 *  @return 压缩后的图片
 */
-(UIImage*)wshh_scaledToSize:(CGSize)newSize;

/**
 *  从相册中取出图片并更正方向
 *
 *  @param asset   asset对象
 *
 *  @return 更正方向的图片
 */
+(UIImage*)imageWSHHFromAsset:(ALAsset*)asset;
@end
