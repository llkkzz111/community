//
//  OCJDatePickerView.m
//  OCJ
//
//  Created by Ray on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJDatePickerView.h"

@interface OCJDatePickerView ()

@property (nonatomic, strong) UIView *ocjView_bg;///<背景视图

@property (nonatomic, strong) UIView *ocjView_container;///<
@property (nonatomic, strong) UIDatePicker *ocjDatePicker;///<日期选择器
@property (nonatomic, strong) UIToolbar *ocjTool;///<工具栏

@property (nonatomic, strong) OCJDatePickerHandler completionHandler;

@end

@implementation OCJDatePickerView

+ (void)ocj_popDatePickerCompletionHandler:(OCJDatePickerHandler)handler {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    OCJDatePickerView *datePicker = [[OCJDatePickerView alloc] initWithFrame:window.bounds];
    datePicker.userInteractionEnabled = YES;
    datePicker.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    datePicker.alpha = 1;
    [window addSubview:datePicker];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:datePicker action:@selector(ocj_dismissDatePicker)];
    [datePicker addGestureRecognizer:tap];
    
    datePicker.ocjView_container = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216 + 44)];
    datePicker.ocjView_container.backgroundColor =OCJ_COLOR_BACKGROUND;
    [datePicker addSubview:datePicker.ocjView_container];
    
    UIView *toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    toolsView.backgroundColor = [UIColor colorWSHHFromHexString:@"#EAF0FD"];
    [datePicker.ocjView_container addSubview:toolsView];
    
    OCJBaseButton *cancelBtn = [OCJBaseButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(16, 0, 60, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.ocjFont = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
    [cancelBtn addTarget:datePicker action:@selector(ocj_dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [toolsView addSubview:cancelBtn];
    
    OCJBaseButton *sureBtn = [OCJBaseButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(SCREEN_WIDTH-76, 0, 60, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.ocjFont = [UIFont systemFontOfSize:14];
    [sureBtn addTarget:datePicker action:@selector(ocj_getDate) forControlEvents:UIControlEventTouchUpInside];
    [toolsView addSubview:sureBtn];
    //今天
    /*
    OCJBaseButton *todayBtn = [OCJBaseButton buttonWithType:UIButtonTypeSystem];
    todayBtn.frame = CGRectMake(SCREEN_WIDTH - 76 - 60, 0, 60, 44);
    [todayBtn setTitle:@"今天" forState:UIControlStateNormal];
    todayBtn.ocjFont = [UIFont systemFontOfSize:14];
    [todayBtn addTarget:datePicker action:@selector(ocj_todayDate) forControlEvents:UIControlEventTouchUpInside];
    [toolsView addSubview:todayBtn];
     */
    
    datePicker.ocjDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 216)];
    datePicker.ocjDatePicker.date = [NSDate date];//设置初始时间
    datePicker.ocjDatePicker.maximumDate = [NSDate date];//
    datePicker.ocjDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];
    datePicker.ocjDatePicker.datePickerMode = UIDatePickerModeDate;//设置样式
    datePicker.ocjDatePicker.backgroundColor = OCJ_COLOR_BACKGROUND;
    [datePicker.ocjView_container addSubview:datePicker.ocjDatePicker];
    [UIView animateWithDuration:0.5 animations:^{
        datePicker.ocjView_container.frame = CGRectMake(0, SCREEN_HEIGHT - 216 - 44, SCREEN_WIDTH, 216);
    }];
    
    datePicker.completionHandler = handler;
}

- (void)ocj_dismissDatePicker {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.alpha = 0;
        self.ocjView_container.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216 + 44);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)ocj_getDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [formatter stringFromDate:self.ocjDatePicker.date];
    
    self.completionHandler(dateString);
    
    [self ocj_dismissDatePicker];
}


/**
 今天
 */
- (void)ocj_todayDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    self.completionHandler(dateString);
    
    [self ocj_dismissDatePicker];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
