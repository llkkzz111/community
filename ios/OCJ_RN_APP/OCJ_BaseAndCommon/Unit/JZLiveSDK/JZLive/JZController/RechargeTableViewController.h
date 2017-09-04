//
//  RechargeTableViewController.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//  充值view

#import <UIKit/UIKit.h>

@interface RechargeTableViewController : UIViewController
@property (nonatomic,assign) int ownDiamondNum;
@property (nonatomic, copy) void (^redirectBlock)(BOOL flag, NSError *error);//回调
@end
