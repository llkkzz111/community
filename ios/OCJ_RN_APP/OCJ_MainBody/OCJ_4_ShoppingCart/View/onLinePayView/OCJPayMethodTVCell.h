//
//  OCJPayMethodTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/8/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJHttp_onLinePayAPI.h"
#import "OCJOtherPayView.h"

typedef void (^OCJPayMethodBlock)(OCJOtherPayModel *ocjModel_pay, NSString *ocjStr_pay);

/**
 支付方式选择cell
 */
@interface OCJPayMethodTVCell : UITableViewCell

@property (nonatomic, strong) OCJModel_onLinePay * ocjModel_onLine;
@property (nonatomic, strong) OCJOtherPayModel *ocjModel_selected;    ///<选中的支付方式model
@property (nonatomic, strong) UIButton *ocjBtn_select;      ///<
@property (nonatomic, copy) OCJPayMethodBlock ocjPayMethodblock;

@end
