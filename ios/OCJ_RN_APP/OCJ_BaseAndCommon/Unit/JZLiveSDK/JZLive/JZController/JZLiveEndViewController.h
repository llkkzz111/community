//
//  JZLiveEndViewController.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//  推拉流结束

#import <UIKit/UIKit.h>
@class JZCustomer;
@class JZLiveRecord;
@interface JZLiveEndViewController : UIViewController
@property (nonatomic, assign)NSInteger onlineNum;//在线人数
@property (nonatomic, strong) JZCustomer *host;//主播信息
@property (nonatomic, strong) JZLiveRecord *record;//活动信息
@end
