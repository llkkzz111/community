//
//  OCJGlobaShoppingTableViewHeadView.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobaShoppingTableViewHeadView.h"

@interface OCJGlobaShoppingTableViewHeadView()
@property (nonatomic,strong) NSString           *ocjStr_title;
@property (nonatomic,strong) NSString           *ocjStr_subTitle;
@property (nonatomic,strong) UILabel             *ocjLab_title;
@property (nonatomic,strong) UILabel             *ocjLab_subTitle;
@property (nonatomic,strong) UIView              *ocjView_gap;
@property (nonatomic,strong) UIView              *ocjView_backGroud;

@end

@implementation OCJGlobaShoppingTableViewHeadView

- (instancetype)initWithFrame:(CGRect)frame TitleText:(NSString *)title SubTitleText:(NSString *)subtitle isShowLine:(BOOL)isShowLine;
{
    if (self = [super initWithFrame:frame]) {
        self.ocjStr_title = title;
        self.ocjStr_subTitle = subtitle;
        [self ocj_addViews:isShowLine];
    }
    return self;
}

- (void)ocj_addViews:(BOOL)isShowLine
{
//    [self setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColor:[UIColor colorWSHHFromHexString:@"#EDEDED"]];
  
    
    [self addSubview:self.ocjView_backGroud];
    [self.ocjView_backGroud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(20);
    }];
    
    [self addSubview:self.ocjLab_subTitle];
    [self.ocjLab_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.ocjLab_title);
        make.right.mas_equalTo(self.mas_right).offset(-5);
    }];
  
    if(isShowLine){
      [self addSubview:self.ocjView_gap];
      [self.ocjView_gap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
      }];
    }
}

- (UILabel *)ocjLab_title
{
    if (!_ocjLab_title) {
        _ocjLab_title = [[UILabel alloc] init];
        _ocjLab_title.font = [UIFont systemFontOfSize:16];
        _ocjLab_title.textColor = [UIColor colorWithRed:167/255.0 green:42/255.0 blue:255/255.0 alpha:1/1.0];
        if (self.ocjStr_title) {
            _ocjLab_title.text = self.ocjStr_title;
        }
        else
        {
            _ocjLab_title.text = @"";
        }
    }
    return _ocjLab_title;
}

- (UILabel *)ocjLab_subTitle
{
    if (!_ocjLab_subTitle) {
        _ocjLab_subTitle = [[UILabel alloc] init];
        _ocjLab_subTitle.font = [UIFont systemFontOfSize:13];
        _ocjLab_subTitle.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        if (self.ocjStr_subTitle) {
            _ocjLab_subTitle.text = self.ocjStr_subTitle;
        }
        else
        {
            _ocjLab_subTitle.text = @"";
        }
    }
    return _ocjLab_subTitle;
}

- (UIView *)ocjView_gap
{
    if (!_ocjView_gap) {
        _ocjView_gap = [[UIView alloc] init];
        [_ocjView_gap setBackgroundColor:[UIColor colorWSHHFromHexString:@"DDDDDD"]];
    }
    return _ocjView_gap;
}

- (UIView *)ocjView_backGroud
{
    if (!_ocjView_backGroud) {
        _ocjView_backGroud = [[UIView alloc] init];
        [_ocjView_backGroud setBackgroundColor:[UIColor whiteColor]];
    }
    return _ocjView_backGroud;
}

@end
