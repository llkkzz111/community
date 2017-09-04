//
//  OCJSMGLifeCVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_SMG.h"
#import "OCJSMGCollectionView.h"

typedef void(^OCJLifeRewardHandler) (NSDictionary *ocjDic);///< 抽奖

@interface OCJSMGLifeCVCell : UICollectionViewCell

@property (nonatomic,copy) OCJLifeRewardHandler ocj_rewardHandler;

@property (nonatomic, strong) OCJResponseModel_SMGListDetail *ocjModel_listModel; ///< 数据源


@end
