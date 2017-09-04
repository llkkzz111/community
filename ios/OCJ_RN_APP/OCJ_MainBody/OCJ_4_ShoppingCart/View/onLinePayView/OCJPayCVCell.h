//
//  OCJPayCVCell.h
//  OCJ
//
//  Created by OCJ on 2017/5/15.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJHttp_onLinePayAPI.h"

typedef void(^OCJConfirmBlock)(void);

/**
 在线支付列表
 */
@interface OCJPayCVCell : UICollectionViewCell

@property (nonatomic,copy)   OCJConfirmBlock    confirmBlock;          ///< 回调block
@property (nonatomic,copy)   NSString           * ocjStr_page;         ///< 页数
@property (nonatomic,strong) OCJBaseTableView   * ocj_tableView;       ///< tableView
@property (nonatomic,strong) OCJModel_onLinePay * ocjModel_onLine;     ///< 列表请求数据



@end
