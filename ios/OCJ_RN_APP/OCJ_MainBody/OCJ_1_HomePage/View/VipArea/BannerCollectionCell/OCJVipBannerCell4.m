//
//  OCJVipBannerCell4.m
//  OCJ
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJVipBannerCell4.h"

@interface OCJVipBannerCell4 (){
    OCJBaseButton *titleImg;
    OCJBaseButton *titleBtn;
    OCJBaseLabel *lab;
    OCJBaseLabel *lab2;
}
@end

@implementation OCJVipBannerCell4

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
    [titleImg setImage:[UIImage imageNamed:@"icon_viptag_"] forState:UIControlStateNormal];
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
        make.top.equalTo(titleBtn.mas_bottom).offset(32);
    }];
    
    lab2 = [[OCJBaseLabel alloc] init];
    lab2.textColor = [UIColor colorWSHHFromHexString:@"#FFEED0"];
    lab2.font = [UIFont boldSystemFontOfSize:20];
    [backView addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(lab.mas_bottom).offset(4);
    }];
    [self setModelData];
}

- (void)setModelData{
    [titleBtn setTitle:@"生日礼物" forState:UIControlStateNormal];
    lab.text = @"低至";
    lab2.text = @"8折";
}

@end
