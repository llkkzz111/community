//
//  OCJDatePickerView.h
//  OCJ
//
//  Created by Ray on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OCJDatePickerHandler)(NSString *dateStr);

@interface OCJDatePickerView : UIView


/**
 弹出日期选择器

 @param handler 返回选中的日期
 */
+ (void)ocj_popDatePickerCompletionHandler:(OCJDatePickerHandler)handler;

@end
