//
//  OCMSMGCVC.h
//  OCJ
//
//  Created by OCJ on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJSMGCollectionView.h"
#import "OCJResponseModel_SMG.h"

typedef void(^OCJRewardHandler) (NSDictionary *ocjDic);///< 抽奖事件

@interface OCMSMGCVC : UICollectionViewCell

@property (nonatomic,copy) OCJRewardHandler ocj_rewardHandler;

@property (nonatomic,strong) OCJResponseModel_SMGListDetail *ocjModel_listDetail; ///< 数据源

@end
