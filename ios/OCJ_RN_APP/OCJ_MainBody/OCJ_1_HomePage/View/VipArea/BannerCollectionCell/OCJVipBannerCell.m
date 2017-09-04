//
//  OCJVipBannerCell.m
//  OCJ
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJVipBannerCell.h"

@interface OCJVipBannerCell (){
  
    OCJBaseButton *titleImg;
    OCJBaseButton *titleBtn;
    OCJBaseLabel *lab;
    OCJBaseLabel *lab2;
    OCJBaseLabel *lab3;
}

@end

@implementation OCJVipBannerCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self ocj_setupViews];
    }
    return self;
}

- (void)ocj_setupViews{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:backView];
    backView.backgroundColor = [UIColor colorWSHHFromHexString:@"#565656"];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    backView.layer.cornerRadius = 3;
    backView.clipsToBounds = YES;
    
    UIImageView *backimageV = [[UIImageView alloc] init];
    [backView addSubview:backimageV];
    [backimageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backView);
    }];
    backimageV.image = [UIImage imageNamed:@"icon_vipbg"];
    backimageV.contentMode = UIViewContentModeScaleAspectFill;
    
  
    titleImg = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:titleImg];
    [titleImg setImage:[UIImage imageNamed:@"icon_gifts_"] forState:UIControlStateNormal];
    [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.offset(15);
      
    }];
  
    titleBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:titleBtn];
    [titleBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#DFC99E"] forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleImg.mas_right).offset(5);
        make.top.equalTo(titleImg.mas_top);
        make.height.equalTo(titleImg);
    }];
  
    lab = [[OCJBaseLabel alloc] init];
    lab.textColor = [UIColor colorWSHHFromHexString:@"#FFEED0"];
    lab.font = [UIFont systemFontOfSize:14];
    [backView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(titleBtn.mas_bottom).offset(51*0.5);
    }];
    
    lab2 = [[OCJBaseLabel alloc] init];
    lab2.textColor = [UIColor colorWSHHFromHexString:@"#FFEED0"];
    lab2.font = [UIFont boldSystemFontOfSize:20];
    [backView addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(lab.mas_bottom).offset(4);
    }];
    
    
    lab3 = [[OCJBaseLabel alloc] init];
    lab3.textColor = [UIColor colorWSHHFromHexString:@"#B9B9B9"];
    lab3.font = [UIFont boldSystemFontOfSize:11];
    [backView addSubview:lab3];
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(lab2.mas_bottom).offset(35*0.5);
    }];
    [self setModelData];
}

- (void)setModelData{
    [titleBtn setTitle:@"VIP礼包" forState:UIControlStateNormal];
    lab.text = @"有效期内每月奖励";
    lab2.text = @"200 鸥点";
    lab3.text = @"VIP会员有效期内，每月可三选一鸥券：\n7%OFF券 // 100鸥券VIP会员有效期内，每月可三选一鸥券：\n7%OFF券 // 100鸥券";
}

@end
