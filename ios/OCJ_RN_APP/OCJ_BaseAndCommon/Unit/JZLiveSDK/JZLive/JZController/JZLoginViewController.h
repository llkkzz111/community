//
//  JZLoginViewController.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//  登录账号

#import <UIKit/UIKit.h>

@interface JZLoginViewController : UIViewController
@property (nonatomic ,assign) NSInteger backType;//返回到哪个页面
@property (nonatomic, copy) void (^redirectBlock)(BOOL flag, NSError *error);//回调
@end
