//
//  OCJCouponPopView.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_confirmOrder.h"

typedef void (^OCJSelectedCouponBlock)(OCJResponceModel_coupon *ocjModel_selectCoupon);

/**
 选择优惠券popView
 */
@interface OCJCouponPopView : UIView

@property (nonatomic, copy) OCJSelectedCouponBlock ocjSelectedCouponBlock;

@property (nonatomic, strong) UITextField *ocjTF_coupon;    ///<兑换抵用券

- (instancetype)initWithArray:(NSArray *)ocjArr_coupon;

@end
