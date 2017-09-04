//
//  OCJSecurityGoodsView.h
//  OCJ
//
//  Created by LZB on 2017/4/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCJSecurityGoodsView;

@protocol OCJSOCJSecurityGoodsViewDelegate <NSObject>

/**
 点击选择图片

 @param view 当前点击的视图
 */
- (void)ocj_tappedImageView:(OCJSecurityGoodsView *)view;

@end

@interface OCJSecurityGoodsView : UIView

//商品图片
@property (nonatomic, strong) UIImageView *ocjImgView_goods;

//商品名称
@property (nonatomic, strong) OCJBaseLabel *ocjLab_name;

//选中图片
@property (nonatomic, strong) UIImageView *ocjImgView_selected;

@property (nonatomic, weak) id<OCJSOCJSecurityGoodsViewDelegate>delegate;

@property (nonatomic, assign) BOOL ocj_isSelected;

- (void)ocj_loadData:(id)data;

@end
