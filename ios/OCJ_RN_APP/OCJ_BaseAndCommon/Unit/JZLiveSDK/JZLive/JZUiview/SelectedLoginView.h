//
//  SelectedLoginView.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//  选择登录方式

#import <UIKit/UIKit.h>
//@class UMSocialMessageObject;
@protocol SelectedLoginViewDelegate <NSObject>
- (void)enterPhoneLoginView:(UIButton *)sender;
- (void)enterWeixinView:(UIButton *)sender;
- (void)enterthirdPartyLoginView:(UIButton *)sender;
@end
@interface SelectedLoginView : UIView
@property (nonatomic, weak) id<SelectedLoginViewDelegate> delegate;
@end
