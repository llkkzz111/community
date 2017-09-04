//
//  OCJBaseCollectionView.h
//  OCJ
//
//  Created by wb_yangyang on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,OCJBaseCollectionRefreshType) {
    OCJBaseCollectionRefreshTypeHeaderAndEnder = 0, ///< 下拉+上拉
    OCJBaseCollectionRefreshTypeOnlyHeader, ///< 单独下拉
    OCJBaseCollectionRefreshTypeOnlyFooter   ///< 单独上拉
};


typedef void(^OCJCollectionFooterRefreshing)();///< 上拉刷新block
typedef void(^OCJCollectionHeaderRefreshing)();///< 下拉刷新block


@interface OCJBaseCollectionView : UICollectionView


#pragma mark - 刷新组件
/**
 *  (1)初始化刷新组件
 
 @param refreshType 刷新组件类型
 */
-(void)ocj_prepareRefreshingType:(OCJBaseCollectionRefreshType)refreshType;

/**
 *  (2)设置刷新回调
 */
@property (nonatomic,copy)OCJCollectionFooterRefreshing ocjBlock_footerRefreshing;//上拉刷新执行block
@property (nonatomic,copy)OCJCollectionHeaderRefreshing ocjBlock_headerRefreshing;//下拉刷新执行block

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
