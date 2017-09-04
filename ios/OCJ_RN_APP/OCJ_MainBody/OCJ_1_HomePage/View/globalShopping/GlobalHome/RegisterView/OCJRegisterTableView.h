//
//  OCJRegisterTableView.h
//  OCJ
//
//  Created by 董克楠 on 10/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJLotteryModel.h"


@class OCJRegisterTableView;
@protocol OCJRegisterTableViewDelegate <NSObject>

-(void)ocj_clickTitleIndex:(NSInteger)index;

@end


@interface OCJRegisterTableView : UIView

@property (nonatomic ,strong) OCJBaseTableView * ocjTable_dataTableView;///< 数据展示窗

@property(nonatomic,assign) NSInteger index;  ///< 按钮

@property(nonatomic,strong) OCJGiftListModel * ocjModel_giftModel; ///< 礼包数据源

@property(nonatomic,strong) OCJLotteryListModel * ocjModel_lotteryModel;  ///< 彩票数据源

@property (nonatomic,weak) id<OCJRegisterTableViewDelegate> ocjDelegate;  

@end
