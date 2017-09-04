//
//  OCJShoppingPOPCouponCell.h
//  OCJ
//
//  Created by Ray on 2017/5/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_myWallet.h"

@class OCJShoppingPOPCouponCell;
@protocol OCJShoppingPOPCouponCellDelegate <NSObject>

- (void)ocj_clickedCouponCellWithCell:(OCJShoppingPOPCouponCell *)cell andCouponNo:(NSString *)couponNo;

@end

/**
 抵用券、淘券cell
 */
@interface OCJShoppingPOPCouponCell : UITableViewCell

@property (nonatomic, weak) id<OCJShoppingPOPCouponCellDelegate>cellDelegate;

/**
 淘券model
 */
@property (nonatomic, strong) OCJWalletModel_TaoCouponListDesc *ocjModel_taoListDesc;

/**
 抵用券model
 */
@property (nonatomic, strong) OCJWalletModel_CouponListDesc *ocjModel_couponListDesc;

/**
 已领取提示
 */
@property (nonatomic, strong) UIImageView *ocjImgView_getAlready;

@property (nonatomic, strong) UIButton *ocjBtn_getCoupon;///<领取优惠券按钮
@property (nonatomic, strong) UILabel *ocjLab_leftTitle;///<左半边底部label

@end
