//
//  OCJReturnMoneyTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OCJChooseReturnMoneyBlock)(NSString *ocjStr_return);

@interface OCJReturnMoneyTVCell : UITableViewCell

@property (nonatomic, copy) OCJChooseReturnMoneyBlock ocjChooseReturnMomeyBlock;

@end
