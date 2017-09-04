//
//  JZPlayerViewController.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//  播放

#import <UIKit/UIKit.h>
#import "DanmuModel.h"
#import "RedBagEventModel.h"
#import "WebViewJavascriptBridge.h"

@class JZCustomer;
@class JZLiveRecord;

@interface JZPlayerViewController : UIViewController

@property (nonatomic,strong) JZCustomer *user;//用户自己信息
@property (nonatomic,strong) JZCustomer* host;//主播信息
@property (nonatomic,strong) JZLiveRecord* record;//活动信息
@property (nonatomic,strong) DanmuModel * danMuModel;//弹幕基本信息
@property (nonatomic,strong) RedBagEventModel * redBagModel;//红包活动信息
//@property (nonatomic,strong) JZLiveInfoModel* infoModel;//活动信息
@property (nonatomic,copy) NSString * shopNo;
@property (nonatomic,strong)WebViewJavascriptBridge * bridge;
//@property (nonatomic,weak)id <OCJShouldLoginDelegate>delegate;
@property (nonatomic,strong) UIView * livingEendView;
@property (nonatomic,strong) NSDictionary * dictionary;


@end
