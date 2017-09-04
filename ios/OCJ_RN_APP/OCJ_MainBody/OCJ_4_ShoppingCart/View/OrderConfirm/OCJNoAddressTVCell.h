//
//  OCJNoAddressTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OCJOrderLoginBlock)();

/**
 没有选择收获地址cell
 */
@interface OCJNoAddressTVCell : UITableViewCell

@property (nonatomic, strong) UILabel *ocjLab_notlogin; ///<label
@property (nonatomic, strong) UIView *ocjView_notLogin; ///<未登录

@property (nonatomic, copy) OCJOrderLoginBlock ocjOrderLoginBlock;

@end
