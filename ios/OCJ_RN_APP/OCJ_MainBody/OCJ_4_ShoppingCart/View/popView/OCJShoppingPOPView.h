//
//  OCJShoppingPOPView.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 购物车弹出框类型枚举
 */
typedef NS_ENUM(NSInteger, OCJShoppingPOPViewType) {
    OCJShoppingPOPViewTypeFirstBuy = 1,     ///<首购优惠说明
    OCJShoppingPOPViewTypeCrossTax,         ///<跨境综合税
    OCJShoppingPOPViewTypeCoupon            ///<抵用券
};

/**
 购物流程弹出框结合类
 */
@interface OCJShoppingPOPView : UIView

+ (instancetype)sharedInstance;

- (void)ocj_addPOPViewWithType:(OCJShoppingPOPViewType)popType andDictionary:(NSDictionary *)dic;

@end
