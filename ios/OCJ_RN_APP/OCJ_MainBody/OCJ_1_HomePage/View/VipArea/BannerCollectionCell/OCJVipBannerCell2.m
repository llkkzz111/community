//
//  OCJVipBannerCell2.m
//  OCJ
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJVipBannerCell2.h"

@interface OCJVipBannerCell2 (){
    OCJBaseButton *titleImg;
    OCJBaseButton *titleBtn;
    OCJBaseLabel *lab;
    OCJBaseLabel *lab2;
    OCJBaseLabel *lab3;
}

@end

@implementation OCJVipBannerCell2

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
    backimageV.contentMode = UIViewContentModeScaleAspectFill;
    backimageV.image = [UIImage imageNamed:@"icon_vipbg"];
  
    titleImg = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:titleImg];
    [titleImg setImage:[UIImage imageNamed:@"icon_count_"] forState:UIControlStateNormal];
    [titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.offset(15);
      
    }];
  
    titleBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:titleBtn];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#DFC99E"] forState:UIControlStateNormal];
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
        make.top.equalTo(titleBtn.mas_bottom).offset(22*0.5);
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
        make.top.equalTo(lab2.mas_bottom).offset(27*0.5);
    }];
    [self setModelData];
}

- (void)setModelData{
    [titleBtn setTitle:@"双倍积分" forState:UIControlStateNormal];
    lab.text = @"订购商品获得双倍积分\n最高可获得商品售价的";
    lab2.text = @"7%";
    lab3.text = @"网站订购 + 1% 积分\n网站支付 + 2% 积分";
}

@end