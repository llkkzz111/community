//
//  OCJPaymentModeTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OCJChoosePaymentModeBlock)(NSString *ocjStr_payment);

/**
 选择支付方式cell
 */
@interface OCJPaymentModeTVCell : UITableViewCell

@property (nonatomic, copy) OCJChoosePaymentModeBlock ocjChoosePaymentModeBlock;

@end
