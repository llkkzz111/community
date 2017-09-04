//
//  OCJAssistiveBtn.h
//  OCJ
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseButton.h"



@interface OCJAssistiveBtn : OCJBaseButton

@property (nonatomic, copy) void(^responserClickAction)(void);///< 回调单击按钮方法.
@property (nonatomic, copy) void(^dragingAction)(void);///< 回调拖动是移除按钮方法.

@property (nonatomic, assign) NSUInteger superStyleType;

@property (nonatomic, assign) UIEdgeInsets aroundOffset;

@property (nonatomic, assign, getter=isDragble) BOOL dragble;///< 是否可以拖动.

@end
