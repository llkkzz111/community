//
//  OCJClassificationTableViewCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_GlobalShopping.h"

@class OCJClassificationTableViewCell;
@protocol OCJClassificationTableViewCellDelegate <NSObject>

- (void)ocj_golbalClassificationPressed:(OCJGSModel_Package4 *)model At:(OCJClassificationTableViewCell *)cell;

@end

@interface OCJClassificationTableViewCell : UITableViewCell
@property (nonatomic ,weak) id<OCJClassificationTableViewCellDelegate> delegate;

- (void)ocj_setShowDataWithArray:(NSArray *)array;

@end

