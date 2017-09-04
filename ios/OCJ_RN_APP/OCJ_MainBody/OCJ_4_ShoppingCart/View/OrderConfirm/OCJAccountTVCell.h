//
//  OCJAccountTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 购买须知block
 */
typedef void (^OCJPurchaseNotesBlock)();

/**
 结算信息cell
 */
@interface OCJAccountTVCell : UITableViewCell

@property (nonatomic, strong) UILabel *ocjLab_totalPrice; ///<商品总额
@property (nonatomic, strong) UILabel *ocjLab_reduce;     ///<优惠价格
@property (nonatomic, strong) UILabel *ocjLab_coupon;     ///<抵用券减免

@property (nonatomic, copy) OCJPurchaseNotesBlock ocjPurchaseNotesBlock;

@end
