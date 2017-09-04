//
//  OCJGlobalScreenHeadView.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJRightImageButton.h"
#import "OCJGlobalScreenModel.h"


@protocol OCJGlobalScreenHeadViewDelegate <NSObject>


/**
 点击筛选条件按钮

 @param tag 按钮标签
 */
- (void)ocj_golbalHeadButtonPressed:(NSInteger)tag;

@end


/**
 全球购列表筛选视图
 */
@interface OCJGlobalScreenHeadView : UIView

@property (nonatomic ,weak) id<OCJGlobalScreenHeadViewDelegate> delegate;

@property (nonatomic,strong) OCJGSRModel_screenCondition* ocjModel_condition;

@end
