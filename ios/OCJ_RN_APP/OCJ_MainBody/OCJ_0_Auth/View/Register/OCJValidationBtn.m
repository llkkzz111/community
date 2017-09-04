//
//  OCJValidationBtn.m
//  OCJ
//
//  Created by zhangchengcai on 2017/4/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJValidationBtn.h"

static NSInteger count = 120;  ///< 倒计时秒数
static NSString* normolBGColor = @"#FCE9E6";  ///< 正常背景颜色
static NSString* normolTitleColor = @"#E5290D";  ///< 正常标题颜色
static NSString* disableBGColor = @"#EEEEEE"; ///< 不可选背景颜色
static NSString* disableTitleColor = @"#666666"; ///< 不可选标题颜色

@interface OCJValidationBtn ()

@property (nonatomic,strong) NSTimer * ocjTimer;    ///< 计时器

@property (nonatomic) NSInteger leaveCount; ///< 当前剩余秒数

@end

@implementation OCJValidationBtn

#pragma mark - 初始化方法重写区域

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    OCJValidationBtn* btn = [OCJValidationBtn buttonWithType:UIButtonTypeCustom];
    [btn ocj_setting];
    
    return btn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self ocj_setting];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self ocj_setting];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self ocj_setting];
}

#pragma mark - 私有方法区域
- (void)ocj_setting{
    [self ocj_enableStates];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.layer.cornerRadius = 2.0;
    
    [self addTarget:self action:@selector(ocj_click) forControlEvents:UIControlEventTouchUpInside];
}

-(void)ocj_click{
    if (self.ocjBlock_touchUpInside) {
        self.ocjBlock_touchUpInside();
    }
}

- (void)ocj_startTimer {
    [self ocj_disableStates];
    
    self.leaveCount = count;
    self.ocjTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(ocj_changeTitle) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.ocjTimer forMode:NSRunLoopCommonModes];
}

-(void)ocj_changeTitle{
    self.leaveCount--;
    if (self.leaveCount==0) {
        [self ocj_stopTimer];
        return;
    }
    
    [self setTitle:[NSString stringWithFormat:@"%zi 重新发送",self.leaveCount] forState:UIControlStateNormal];
}

- (void)ocj_enableStates{
    self.userInteractionEnabled = YES;
    [self setBackgroundColor:[UIColor colorWSHHFromHexString:normolBGColor]];
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWSHHFromHexString:normolTitleColor] forState:UIControlStateNormal];
}

- (void)ocj_disableStates{
    self.userInteractionEnabled = NO;
    [self setBackgroundColor:[UIColor colorWSHHFromHexString:disableBGColor]];
    [self setTitleColor:[UIColor colorWSHHFromHexString:disableTitleColor] forState:UIControlStateNormal];
    [self setTitle:[NSString stringWithFormat:@"%zi 重新发送",count] forState:UIControlStateNormal];
}

- (void)ocj_stopTimer {
    if (self.ocjTimer) {
        [self.ocjTimer invalidate];
        self.ocjTimer = nil;
    }
    [self ocj_enableStates];
}



@end
