//
//  OCJBaseTableView.h
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingTableView.h"

typedef void(^OCJTableFooterRefreshing)();///< 上拉刷新block
typedef void(^OCJTableHeaderRefreshing)();///< 下拉刷新block

@interface OCJBaseTableView : TPKeyboardAvoidingTableView

#pragma mark - 刷新组件
/**
 *  (1)初始化刷新组件
 */
-(void)ocj_prepareRefreshing;

/**
 *  (2)设置刷新回调
 */
@property (nonatomic,copy)OCJTableFooterRefreshing ocjBlock_footerRefreshing;//上拉刷新执行block
@property (nonatomic,copy)OCJTableHeaderRefreshing ocjBlock_headerRefreshing;//下拉刷新执行block

/**
 *  (3)关闭下拉刷新动画
 */
-(void)ocj_endHeaderRefreshing;

/**
 *  (4)关闭上拉刷新动画
 *  @param isHaveMoreData yes-仍有数据待刷新 no-无待刷新数据
 */
-(void)ocj_endFooterRefreshingWithIsHaveMoreData:(BOOL)isHaveMoreData;

/**
 *  (5)只有底部刷新
 */
- (void)ocj_footRefreshing;


@end
