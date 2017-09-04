//
//  OCJShoppingGlobalTableViewCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_GlobalShopping.h"

@class OCJShoppingGlobalTableViewCell;

@protocol OCJShoppingGlobalTableViewCellDelegate <NSObject>



/**
 200元购遍全球商品点击事件
 */
- (void)ocj_golbalShoppingPressed:(OCJGSModel_Package42*)model At:(OCJShoppingGlobalTableViewCell *)cell;


/**
 200元购遍全球-查看更多

 */
- (void)ocj_200ShoppingAllOverWorld:(OCJGSModel_Package42*)model;


@end


@interface OCJShoppingGlobalTableViewCell : UITableViewCell

@property (nonatomic ,weak) id<OCJShoppingGlobalTableViewCellDelegate> delegate;

- (void)ocj_setShowDataWithArray:(NSArray *)array;

@end

@interface OCJShoppingGlobalTableViewFooterView : UICollectionReusableView

@property (nonatomic ,strong) UIButton * ocjBtn_more;

@end
