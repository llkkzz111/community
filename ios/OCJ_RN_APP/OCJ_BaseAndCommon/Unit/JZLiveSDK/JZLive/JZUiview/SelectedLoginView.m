//
//  SelectedLoginView.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "SelectedLoginView.h"

#import <JZLiveSDK/JZLiveSDK.h>
@implementation SelectedLoginView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *coverView = [[UIButton alloc] init];
        coverView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        coverView.backgroundColor = background01GRAY;
        [coverView addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coverView];
        
        UIView *shareView = [[UIView alloc] init];
        shareView.backgroundColor = tableViewBackColor;
        shareView.frame = CGRectMake(10, frame.size.height-70-60, frame.size.width-20, 70);
        shareView.layer.cornerRadius = 3;
        shareView.clipsToBounds = YES;
        [self addSubview:shareView];
        
        UIButton *concalView = [[UIButton alloc] init];
        concalView.frame = CGRectMake(10, frame.size.height-50, frame.size.width-20, 40);
        concalView.backgroundColor = [UIColor whiteColor];
        [concalView.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE38]];
        [concalView setTitle:@"取消" forState:UIControlStateNormal];
        [concalView setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        concalView.titleLabel.contentMode = UIViewContentModeCenter;
        [concalView addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        concalView.layer.cornerRadius = 3;
        concalView.clipsToBounds = YES;
        [self addSubview:concalView];
        
        
        UIButton *weixin = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-170)/4, 10, 50, 50)];
        weixin.backgroundColor = [UIColor greenColor];
        weixin.layer.cornerRadius = 25;
        weixin.clipsToBounds = YES;
        weixin.tag = 11471;
        [weixin setImage:[UIImage imageNamed:@"JZ_Btn_wechat_p"] forState:UIControlStateNormal];
        [weixin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:weixin];
        
        UIButton *phone = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weixin.frame)+(frame.size.width-170)/4, 10, 50, 50)];
        phone.backgroundColor = [UIColor purpleColor];
        phone.layer.cornerRadius = 25;
        phone.clipsToBounds = YES;
        phone.tag = 11472;
        [phone setImage:[UIImage imageNamed:@"JZ_Btn_phone@2x"] forState:UIControlStateNormal];
        [phone addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:phone];
        
        UIButton *thirdParty = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phone.frame)+(frame.size.width-170)/4, 10, 50, 50)];
        thirdParty.backgroundColor = MAINCOLOR;
        thirdParty.layer.cornerRadius = 25;
        thirdParty.clipsToBounds = YES;
        thirdParty.tag = 11473;
        [thirdParty setTitle:@"三方" forState:UIControlStateNormal];
        [thirdParty setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[thirdParty setImage:[UIImage imageNamed:@"JZ_Btn_phone@2x"] forState:UIControlStateNormal];
        [thirdParty addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        thirdParty.adjustsImageWhenHighlighted = NO;
        [shareView addSubview:thirdParty];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
//移除自己
-(void)removeSelf{
    [self removeFromSuperview];
}
//分享
- (void)login:(UIButton *)button{
    [self removeFromSuperview];
    switch (button.tag) {
        case 11471:[self.delegate enterWeixinView:button];
            break;
        case 11472:[self.delegate enterPhoneLoginView:button];
            break;
        case 11473:[self.delegate enterthirdPartyLoginView:button];
            break;
            break;
    }
}


@end
