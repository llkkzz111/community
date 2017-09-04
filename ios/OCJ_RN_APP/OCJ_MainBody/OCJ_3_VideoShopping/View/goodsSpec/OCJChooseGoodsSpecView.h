//
//  OCJChooseGoodsSpecView.h
//  OCJ
//
//  Created by Ray on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_videoLive.h"

/**
 选择商品规格情况枚举
 */
typedef NS_ENUM(NSInteger, OCJEnumGoodsSpec) {
    OCJEnumGoodsSpecExchange = 0,       ///<换货时选择商品规格
    OCJEnumGoodsSpecAddToCart           ///<加入购物车时选择商品规格
};

/**
 点击确认按钮
 */
typedef void (^OCJConfirmBlock)(NSString *ocjStr_unitcode, NSString *ocjStr_size, OCJResponceModel_specDetail *ocjModel_specColor);

/**
 选择规格view
 */
@interface OCJChooseGoodsSpecView : UIView

@property (nonatomic, copy) OCJConfirmBlock ocjConfirmBlock;

- (instancetype)initWithEnumType:(OCJEnumGoodsSpec)enumType andItemCode:(NSString *)ocjStr_itemCode;

@end
