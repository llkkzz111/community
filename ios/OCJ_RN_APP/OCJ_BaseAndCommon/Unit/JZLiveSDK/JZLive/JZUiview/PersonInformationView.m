//
//  PersonInformationView.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "PersonInformationView.h"

#import <JZLiveSDK/JZLiveSDK.h>
@interface PersonInformationView ()
@property (nonatomic, weak) UIView  *personInfoView;
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UILabel *personName;
@end
@implementation PersonInformationView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *personCoverBtn = [[UIButton alloc] init];
        personCoverBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        personCoverBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        UITapGestureRecognizer* clickBtn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewBtn)];
        [personCoverBtn addGestureRecognizer:clickBtn];
        [self addSubview:personCoverBtn];
        
        UIView *personInfoView = [[UIView alloc] init];
        personInfoView.frame = CGRectMake((SCREEN_WIDTH-SCREEN_HEIGHT)/2, 0, SCREEN_HEIGHT, SCREEN_HEIGHT);
        personInfoView.backgroundColor = [UIColor whiteColor];
        personInfoView.layer.cornerRadius = 10;
        personInfoView.clipsToBounds = YES;
        [self addSubview:personInfoView];
        self.personInfoView = personInfoView;
        
        UIButton *backBtn = [[UIButton alloc] init];
        backBtn.frame = CGRectMake(20, 20, 30, 30);
        [backBtn setImage:[UIImage imageNamed:@"JZ_Btn_close"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backViewBtn) forControlEvents:UIControlEventTouchUpInside];
        [personInfoView addSubview:backBtn];
        self.backBtn = backBtn;
        
        UIButton *accusationBtn = [[UIButton alloc] init];
        accusationBtn.frame = CGRectMake(CGRectGetMaxX(backBtn.frame)+20, 20, 60, 30);
        [accusationBtn setTitle:@"举报" forState:UIControlStateNormal];
        [accusationBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        accusationBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        accusationBtn.contentMode = UIViewContentModeCenter;
        accusationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        //    [self.accusationBtn addTarget:self action:@selector(onAccusationBtn) forControlEvents:UIControlEventTouchUpInside];
        [personInfoView addSubview: accusationBtn];
        _accusationBtn = accusationBtn;
        
        UILabel *personName = [[UILabel alloc] init];
        personName.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, SCREEN_HEIGHT, 100);
        personName.font = [UIFont systemFontOfSize:FONTSIZE38];
        personName.textAlignment = NSTextAlignmentCenter;
        [personInfoView addSubview:personName];
        self.personName = personName;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isVertical) {//竖屏显示frame
        self.personInfoView.frame = CGRectMake(30, (self.frame.size.height-self.frame.size.width)/2, self.frame.size.width-60, self.frame.size.width);
        self.personName.frame = CGRectMake(0, self.frame.size.width/2-50, self.frame.size.width-60, 100);
    }
    NSString *nameString = [NSString stringWithFormat:@"%@:%@",@"用户昵称",_user.nickname];
    self.personName.text = nameString;
    
    if ([JZGeneralApi getLoginStatus]) {
        JZCustomer *usercustomer = [JZCustomer getUserdataInstance];
        NSInteger otherid = _user.id;
        if (usercustomer.id == otherid) {
            [self.accusationBtn setHidden:YES];
        }else {
            [self.accusationBtn addTarget:self action:@selector(onAccusationBtn) forControlEvents:UIControlEventTouchUpInside];
            NSDictionary *params;
            if (_isHostLive) {
                [self.accusationBtn setTitle:@"禁言" forState:UIControlStateNormal];
                params = @{@"hostID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id], @"userID":[NSString stringWithFormat:@"%lu",(long)otherid], @"accountType":@"ios", @"start":@"0",@"offset":@"50",@"isTester":[NSString stringWithFormat:@"%ld",(long)[JZCustomer getUserdataInstance].isTester]};
            }else {
                params = @{@"hostID":[NSString stringWithFormat:@"%lu",(long)otherid],@"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"accountType":@"ios",@"start":@"0",@"offset":@"50",@"isTester":[NSString stringWithFormat:@"%ld",(long)[JZCustomer getUserdataInstance].isTester]};
            }
            __weak typeof(self) block = self;
            [JZGeneralApi getDetailUserBlock:params getDetailBlock:^(JZCustomer *user, NSArray *records, NSInteger allcounts, NSError *error) {
                if (_isHostLive) {
                    if (user.isInBlackList == 1) {
                        [block.accusationBtn setTitle:@"已禁言" forState:UIControlStateNormal];
                    }else {
                        [block.accusationBtn setTitle:@"禁言" forState:UIControlStateNormal];
                    }
                    
                }
            }];
        }
    }else {
        [self.accusationBtn addTarget:self action:@selector(loginedAccount) forControlEvents:UIControlEventTouchUpInside];
    }
}

//返回
-(void)backViewBtn{
    [self removeFromSuperview];
}

//举报
- (void)onAccusationBtn {
    if (_delegate!=nil) {
        if (_isHostLive) {
            [_delegate clickPersonInformationViewShutUpBtn];
        }else {
            [_delegate clickPersonInformationViewAccusationBtn];
        }
    }
}
//登录账号
-(void)loginedAccount {
    if (_delegate!= nil) {
        [_delegate loginAccount];
    }
}
@end
