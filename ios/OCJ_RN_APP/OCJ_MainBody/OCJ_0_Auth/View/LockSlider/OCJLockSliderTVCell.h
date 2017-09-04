//
//  OCJLockSliderTVCell.h
//  OCJ
//
//  Created by wb_yangyang on 2017/4/28.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OCJLockSliderEnum) {
    OCJLockSliderEnumTips = 0,      ///<含有提示
    OCJLockSliderEnumSlider         ///<不含提示，只有滑块
};

@class OCJLockSliderTVCell;
@protocol OCJLockSliderTVCellDelegete <NSObject>
/**
 滑动验证取消
 */
-(void)ocj_sliderCheckCancel;


/**
 滑动校验完成
 */
-(void)ocj_sliderCheckDone;



@end


/**
 验证码三次错误后附加校验Cell
 注：必须设置cell rowHeight 为 104px
 */
@interface OCJLockSliderTVCell : UITableViewCell

@property (nonatomic,weak) id<OCJLockSliderTVCellDelegete> ocjDelegate;


/**
 重置滑动卡
 */
-(void)ocj_resetSlider:(OCJLockSliderEnum)status;

@end
