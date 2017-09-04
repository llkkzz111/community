//
//  OCJSuperValueTableViewCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_GlobalShopping.h"

@class OCJSuperValueTableViewCell;
@protocol OCJSuperValueTableViewCellDelegate <NSObject>

- (void)ocj_golbalSuperValuePressed:(OCJGSModel_Package44 *)model At:(OCJSuperValueTableViewCell *)cell;

@end

@interface OCJSuperValueTableViewCell : UITableViewCell

@property (nonatomic ,strong) UILabel* ocjLab_bottomSep; ///< cell底部分割线

@property (nonatomic ,weak) id<OCJSuperValueTableViewCellDelegate> delegate;

- (void)ocj_setShowDataWithArray:(NSArray *)array;

@end
