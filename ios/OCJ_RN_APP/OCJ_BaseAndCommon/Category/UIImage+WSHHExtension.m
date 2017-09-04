//
//  UIImage+WSHHExtension.m
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "UIImage+WSHHExtension.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
@implementation UIImage (WSHHExtension)

+(UIImage*)imageWSHHWithColor:(UIColor*)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIImage*)wshh_scaledToSize:(CGSize)newSize
{
    
    CGFloat widthScale = newSize.width/self.size.width;
    CGFloat heightScale = newSize.height/self.size.height;
    CGFloat targetWidth;
    CGFloat targetHeight;
    if (widthScale<1.0 && heightScale<1.0) {
        CGFloat minScale = MIN(widthScale, heightScale);
        targetWidth = self.size.width*minScale;
        targetHeight = self.size.height*minScale;
    }else{
        return self;
    }
    CGImageRef imageRef = [self CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = (uint32_t)kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    if (self.imageOrientation == UIImageOrientationUp ||self.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    }
    if (self.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, DEGREES_TO_RADIANS(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
    } else if (self.imageOrientation ==UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, DEGREES_TO_RADIANS(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
    } else if (self.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (self.imageOrientation == UIImageOrientationDown){
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, DEGREES_TO_RADIANS(-180));
    }
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth,targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
    
}

+(UIImage*)imageWSHHFromAsset:(ALAsset*)asset{
    UIImage* image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
    ALAssetOrientation orientation = asset.defaultRepresentation.orientation;
    CGFloat targetWidth = image.size.width;
    CGFloat targetHeight = image.size.height;
    
    
    CGImageRef imageRef = asset.defaultRepresentation.fullResolutionImage;
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = (uint32_t)kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    if (orientation == ALAssetOrientationUp ||orientation == ALAssetOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth,CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    }
    if (orientation == ALAssetOrientationLeft) {
        CGContextRotateCTM (bitmap, DEGREES_TO_RADIANS(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
    } else if (orientation ==ALAssetOrientationRight) {
        CGContextRotateCTM (bitmap, DEGREES_TO_RADIANS(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
    } else if (orientation == ALAssetOrientationUp) {
        // NOTHING
    } else if (orientation == ALAssetOrientationDown){
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, DEGREES_TO_RADIANS(-180));
    }
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth,targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

@end
