//
//  OCJGoodsCaulateView.m
//  OCJ
//
//  Created by OCJ on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGoodsCaulateView.h"

@interface OCJGoodsCaulateView ()
@property (nonatomic,strong) UILabel  * ocjLab_value;///< value
@property (nonatomic,strong) UIButton * ocjBtn_div;  ///< -
@property (nonatomic,strong) UIButton * ocjBtn_plus; ///< +
@end
@implementation OCJGoodsCaulateView

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self ocj_initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self ocj_initUI];
    }
    return self;
}

- (void)ocj_initUI{
    self.backgroundColor = [UIColor colorWSHHFromHexString:@"ffffff"];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    self.layer.borderColor = [UIColor colorWSHHFromHexString:@"dddddd"].CGColor;
    self.layer.borderWidth = 0.5;
    
    self.ocjBtn_div = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ocjBtn_div setTitle:@"-" forState:UIControlStateNormal];
    [self.ocjBtn_div setTitleColor:[UIColor colorWSHHFromHexString:@"999999"] forState:UIControlStateNormal];
    [self.ocjBtn_div addTarget:self action:@selector(ocj_minus) forControlEvents:UIControlEventTouchUpInside];
    self.ocjBtn_div.userInteractionEnabled = NO;
    [self addSubview:self.ocjBtn_div];
    [self.ocjBtn_div mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    
    self.ocjBtn_plus = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ocjBtn_plus setTitle:@"+" forState:UIControlStateNormal];
    [self.ocjBtn_plus setTitleColor:[UIColor colorWSHHFromHexString:@"999999"] forState:UIControlStateNormal];
    [self.ocjBtn_plus addTarget:self action:@selector(ocj_plus) forControlEvents:UIControlEventTouchUpInside];
    self.ocjBtn_plus.userInteractionEnabled = NO;
    [self addSubview:self.ocjBtn_plus];
    [self.ocjBtn_plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    
    self.ocjLab_value = [[UILabel alloc]init];
    self.ocjLab_value.font = [UIFont systemFontOfSize:14];
    self.ocjLab_value.textColor = [UIColor colorWSHHFromHexString:@"999999"];
    self.ocjLab_value.layer.borderColor = [UIColor colorWSHHFromHexString:@"dddddd"].CGColor;
    self.ocjLab_value.layer.borderWidth = 0.5;
    self.ocjLab_value.textAlignment = NSTextAlignmentCenter;
    self.ocjLab_value.text = @"1";
    [self addSubview:self.ocjLab_value];
    [self.ocjLab_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjBtn_plus.mas_left);
        make.top.mas_equalTo(self.ocjBtn_plus);
        make.bottom.mas_equalTo(self.ocjBtn_plus);
        make.left.mas_equalTo(self.ocjBtn_div.mas_right);
    }];
}

- (void)ocj_plus{
    CGFloat ocjFloat_current = [self.ocjLab_value.text floatValue];
    ocjFloat_current += 1;
    self.ocjLab_value.text = [NSString stringWithFormat:@"%.0f",ocjFloat_current];
    self.ocjStr_current = self.ocjLab_value.text;
    OCJLog(@"当前值:%@",self.ocjStr_current);
}
- (void)ocj_minus{
    CGFloat ocjFloat_current = [self.ocjLab_value.text floatValue];
    if (ocjFloat_current <= 0) {
        self.ocjLab_value.text = [NSString stringWithFormat:@"0"];
        return;
    }
    ocjFloat_current -= 1;
    self.ocjLab_value.text = [NSString stringWithFormat:@"%.0f",ocjFloat_current];
    self.ocjStr_current = self.ocjLab_value.text;
    OCJLog(@"当前值:%@",self.ocjStr_current);
}





@end
