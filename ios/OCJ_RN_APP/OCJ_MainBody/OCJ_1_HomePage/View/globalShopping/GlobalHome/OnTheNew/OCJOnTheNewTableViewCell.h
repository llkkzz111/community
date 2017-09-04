//
//  OCJOnTheNewTableViewCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_GlobalShopping.h"

@class OCJOnTheNewTableViewCell;
@protocol OCJOnTheNewTableViewCellCellDelegate <NSObject>


/**
 周五上新商品点击事件
 */
- (void)ocj_golbaltheNewPressed:(OCJGSModel_Package43*)model At:(OCJOnTheNewTableViewCell *)cell;


/**
 补货专场点击事件
 */
- (void)ocj_globalReplenishmentItemPressed:(OCJGSModel_Package14*)model;

@end


@interface OCJOnTheNewTableViewCell : UITableViewCell
@property (nonatomic ,weak) id<OCJOnTheNewTableViewCellCellDelegate> delegate;
- (void)ocj_setShowCollectionDataWithArray:(NSArray *)array;
- (void)ocj_setShowSubDataWithArray:(NSArray *)array;

@end
