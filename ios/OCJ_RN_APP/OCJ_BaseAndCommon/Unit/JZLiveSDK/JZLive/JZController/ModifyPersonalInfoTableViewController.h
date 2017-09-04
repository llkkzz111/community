//
//  ModifyPersonalInfoTableViewController.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/15.
//  Copyright © 2017年 jz. All rights reserved.
//  修改个人信息

#import <UIKit/UIKit.h>
@class JZCustomer;
@interface ModifyPersonalInfoTableViewController : UITableViewController
@property (nonatomic,strong) JZCustomer *user;//用户自己信息
@end
