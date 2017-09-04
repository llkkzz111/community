//
//  AwardListView.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//  打赏榜

#import <UIKit/UIKit.h>

@interface AwardListView : UIView
@property (nonatomic, strong) NSMutableArray *rankArray;//打赏排行数据
@property (nonatomic, assign) NSInteger      totalMoney;//收益
@property (nonatomic, assign) BOOL           isVertical;//是不是竖屏显示
@end
