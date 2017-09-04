//
//  OCJRegisterCellTableViewCell.h
//  OCJ
//
//  Created by 董克楠 on 10/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJLotteryModel.h"

@interface OCJRegisterCellTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * ocjLabel_nameLabel;
@property(nonatomic,strong)UILabel * ocjLabel_dateLabel;
@property(nonatomic,strong)UILabel * ocjLabel_isUserLabel;

@property(nonatomic,strong)OCJGiftInfoModel * ocjModel_dataModel;


@end
