//
//  OCJGlobalScreenRetrievalPriceTableViewCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCJGlobalScreenRetrievalPriceTableViewCell;
@protocol OCJGlobalScreenRetrievalPriceTableViewCellDelegate <NSObject>

- (void)ocj_golbalScreenRetrievalPriceChangeed:(NSString *)price At:(BOOL)isMax;

@end

@interface OCJGlobalScreenRetrievalPriceTableViewCell : UITableViewCell
@property (nonatomic ,weak) id<OCJGlobalScreenRetrievalPriceTableViewCellDelegate> delegate;

@end
