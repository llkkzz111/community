//
//  OCJGlobalScreenRetrievalButtonViewCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCJGlobalScreenRetrievalButtonViewCell;
@protocol OCJGlobalScreenRetrievalButtonViewCellDelegate <NSObject>

- (void)ocj_golbalScreenRetrievalPressed:(NSInteger)index At:(OCJGlobalScreenRetrievalButtonViewCell *)cell;

@end

@interface OCJGlobalScreenRetrievalButtonViewCell : UITableViewCell
@property (nonatomic ,weak) id<OCJGlobalScreenRetrievalButtonViewCellDelegate> delegate;
/**设置数据方法
 array ：商品字典（接口返回）数组
 */
- (void)ocj_setTitleArray:(NSArray *)array SelectArray:(NSArray *)select;

@end
