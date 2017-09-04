//
//  OCJOverseasRecommendTableViewCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_GlobalShopping.h"

@class OCJOverseasRecommendTableViewCell;
@protocol OCJOverseasRecommendTableViewCellDelegate <NSObject>


/**
 海外大牌推荐-商品点击事件
 */
- (void)ocj_golbalOverSeasPressed:(OCJGSModel_Package14 *)model At:(OCJOverseasRecommendTableViewCell *)cell;

@end

@interface OCJOverseasRecommendTableViewCell : UITableViewCell

@property (nonatomic ,weak) id<OCJOverseasRecommendTableViewCellDelegate> delegate;

- (void)ocj_setShowDataWithArray:(NSArray *)array;

@end
