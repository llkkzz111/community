//
//  CropImageView.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/15.
//  Copyright © 2017年 jz. All rights reserved.
// 剪切图片设置头像用到

#import <UIKit/UIKit.h>

@protocol CropImageViewDelegate <NSObject>
@optional
-(void)confirmClickWithImage:(UIImage *)image;
@end
@interface CropImageView : UIView
@property (nonatomic, assign) NSInteger imageType;
@property (nonatomic,weak) id <CropImageViewDelegate> delegate;
-(instancetype)initWithImage:(UIImage *)image;
-(void)initImage:(UIImage *)image;
@end
