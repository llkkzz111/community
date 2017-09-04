//
//  JZPersonalViewController.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//  登录选择和个人信息

#import <UIKit/UIKit.h>

@interface JZPersonalViewController : UIViewController
@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, copy) void (^redirect1Block)(BOOL flag, NSError *error);//回调
@end
