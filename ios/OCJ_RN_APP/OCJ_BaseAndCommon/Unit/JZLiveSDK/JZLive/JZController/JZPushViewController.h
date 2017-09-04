//
//  JZPushViewController.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//  推流

#import <UIKit/UIKit.h>
@class JZCustomer;
@class JZLiveRecord;
@interface JZPushViewController : UIViewController
@property (nonatomic,strong) JZLiveRecord *record;
@property (nonatomic,strong) JZCustomer *user;
@end
