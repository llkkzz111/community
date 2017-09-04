//
//  OCJValidationBtn.h
//  OCJ
//
//  Created by zhangchengcai on 2017/4/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJBaseButton.h"

typedef void(^ValidationBtnTouchAction) ();

@interface OCJValidationBtn : OCJBaseButton

@property (nonatomic,copy) ValidationBtnTouchAction ocjBlock_touchUpInside; //按钮点击事件


/**
 开始倒计时动画
 */
- (void)ocj_startTimer;


/**
 重置成开始状态
 */
- (void)ocj_enableStates;


/**
 结束倒计时
 */
- (void)ocj_stopTimer;

@end
