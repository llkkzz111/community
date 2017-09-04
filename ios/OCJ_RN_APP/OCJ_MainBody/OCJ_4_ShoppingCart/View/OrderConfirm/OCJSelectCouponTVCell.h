//
//  OCJSelectCouponTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_confirmOrder.h"

typedef void (^OCJChooseCouponBlock)(OCJResponceModel_coupon *ocjModel_select);

@interface OCJSelectCouponTVCell : UITableViewCell

@property (nonatomic, copy) OCJChooseCouponBlock ocjChooseCouponBlock;

- (void)ocj_loadDataWithModel:(OCJResponceModel_coupon *)model andCouponNO:(NSString *)couponNo;

@end
