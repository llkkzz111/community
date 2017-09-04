//
//  PersonInformationView.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//  个人信息view(点击用户头像显示个人信息)

#import <UIKit/UIKit.h>
@class JZCustomer;
@protocol PersonInformationViewDelegate <NSObject>
@optional
- (void)clickPersonInformationViewShutUpBtn;//禁言
- (void)clickPersonInformationViewAccusationBtn;//举报
- (void)loginAccount;//登陆
@end
@interface PersonInformationView : UIView
@property (nonatomic, strong) JZCustomer *user;//用户信息
@property (nonatomic, assign) BOOL isVertical;//是不是竖屏显示
@property (nonatomic, strong) UIButton *accusationBtn;//举报或禁言按钮
@property (nonatomic, assign) BOOL isHostLive;//是不是主播端
@property (nonatomic, weak) id<PersonInformationViewDelegate> delegate;
@end
