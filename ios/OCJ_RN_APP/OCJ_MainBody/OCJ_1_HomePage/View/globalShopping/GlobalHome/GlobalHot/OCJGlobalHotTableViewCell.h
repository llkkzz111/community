//
//  OCJGlobalHotTableViewCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_GlobalShopping.h"

@class OCJGlobalHotTableViewCell;
@protocol OCJGlobalHotTableViewCellDelegate <NSObject>

- (void)ocj_golbalHotPressed:(OCJGSModel_Package14 *)model At:(OCJGlobalHotTableViewCell *)cell;

@end

@interface OCJGlobalHotTableViewCell : UITableViewCell
@property (nonatomic ,weak) id<OCJGlobalHotTableViewCellDelegate> delegate;
- (void)ocj_setShowDataWithArray:(NSArray *)array;

@end
