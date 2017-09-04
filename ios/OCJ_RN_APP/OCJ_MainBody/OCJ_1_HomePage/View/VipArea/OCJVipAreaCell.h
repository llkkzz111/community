//
//  OCJVipAreaCell.h
//  OCJ
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_VipArea.h"


@class OCJVipAreaCell;
@protocol OCJVIPAreaCellDelegate <NSObject>


/**
 VIP品牌推荐商品点击事件
 */
- (void)ocj_vipAreaCell:(OCJVipAreaCell*)cell clickGoodIndex:(NSInteger)index;

@end

/**
 横向三个商品.
 */
@interface OCJVipAreaCell : UITableViewCell

+ (CGFloat)ocj_getCellHeight;

@property (nonatomic,strong) OCJVIPModel_BrandDetail* ocjModel_brandDetail;

@property (nonatomic,weak) id<OCJVIPAreaCellDelegate> ocjDelegate;

@end
