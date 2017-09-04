//
//  OCJWelfareCell.h
//  OCJ
//
//  Created by 董克楠 on 10/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJLotteryModel.h"

@interface OCJWelfareCell : UITableViewCell
@property(nonatomic,strong)UILabel * ocjLabel_nameLabel;
@property(nonatomic,strong)UILabel * ocjLabel_openAwardLabel;

@property(nonatomic,strong)UILabel * ocjLabel_oneNumberLabel;
@property(nonatomic,strong)UILabel * ocjLabel_twoNumberLabel;
@property(nonatomic,strong)UILabel * ocjLabel_threeNumberLabel;
@property(nonatomic,strong)UILabel * ocjLabel_fourNumberLabel;
@property(nonatomic,strong)UILabel * ocjLabel_fiveNumberLabel;
@property(nonatomic,strong)UILabel * ocjLabel_sixNumberLabel;
@property(nonatomic,strong)UILabel * ocjLabel_sevenNumberLabel;

@property(nonatomic,strong)OCJLotteryInfoModel * ocjModel_dataModel;
@end
