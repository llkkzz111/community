//
//  OCJSelectedView.h
//  OCJ
//
//  Created by OCJ on 2017/5/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OCJSelectedBlock) (UIButton *currentBtn);///< 回调block <index 对应 titleArray下标>

typedef void (^OCJPayBlock)(id data);///< 回调block


/**
 自定义选择控件
 */
@interface OCJSelectedView : UIView

@property (nonatomic,copy) OCJSelectedBlock ocj_handler;
@property (nonatomic,copy) NSMutableArray * titleArray;
@property (nonatomic,strong) UIButton * ocjBtn_selected;

- (instancetype)initWithTitleArray:(NSMutableArray *)title andIndex:(NSInteger)index;

- (instancetype)initWithOnLinePayArray:(NSMutableArray *)title andIndex:(NSInteger)index;

@property (nonatomic,copy) OCJPayBlock handler;

@end
