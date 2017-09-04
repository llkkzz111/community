//
//  OCJMoreRecommendView.m
//  OCJ
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJMoreRecommendView.h"

@interface OCJMoreRecommendView ()

@end

@implementation OCJMoreRecommendView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews {
    self.ocjImgView = [[UIImageView alloc] init];
    self.ocjImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.ocjImgView];
    [self.ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(@90);
    }];
  
    //折扣
    self.ocjLab_discount = [[UILabel alloc] init];
    self.ocjLab_discount.attributedText = [self ocj_changeStringColorWithString:@"4.5折" andTitleFont:13];
    self.ocjLab_discount.backgroundColor = [UIColor colorWSHHFromHexString:@"#ED1C41"];
    self.ocjLab_discount.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    self.ocjLab_discount.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.ocjLab_discount];
    [self.ocjLab_discount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.ocjImgView);
    }];
  
    //名称
    self.ocjLab_name = [[UILabel alloc] init];
    self.ocjLab_name.textColor = OCJ_COLOR_DARK;
    self.ocjLab_name.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_name.numberOfLines = 2;
    self.ocjLab_name.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.ocjLab_name];
    [self.ocjLab_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImgView);
        make.top.mas_equalTo(self.ocjImgView.mas_bottom).offset(5);
        make.right.mas_equalTo(self.ocjImgView);
    }];
  
    //售价
    self.ocjLab_sellPrice = [[UILabel alloc] init];
    self.ocjLab_sellPrice.attributedText = [self ocj_changeStringColorWithString:@"￥389.8" andTitleFont:15];
    self.ocjLab_sellPrice.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    [self addSubview:self.ocjLab_sellPrice];
    [self.ocjLab_sellPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_name.mas_left).offset(0);
        make.top.mas_equalTo(self.ocjLab_name.mas_bottom).offset(5);
    }];
  
    //市场价
    self.ocjLab_marketPrice = [[UILabel alloc] init];
    self.ocjLab_marketPrice.text = @"￥888";
    self.ocjLab_marketPrice.textColor = OCJ_COLOR_LIGHT_GRAY;
    self.ocjLab_marketPrice.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.ocjLab_marketPrice];
    [self.ocjLab_marketPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_sellPrice.mas_right).offset(3);
        make.centerY.mas_equalTo(self.ocjLab_sellPrice.mas_centerY).offset(1);
    }];
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [self addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.ocjLab_marketPrice);
        make.centerY.mas_equalTo(self.ocjLab_marketPrice);
        make.height.mas_equalTo(@1);
    }];
    
    //已售数量
    self.ocjLab_buyer = [[UILabel alloc] init];
    self.ocjLab_buyer.text = @"90 件已售";
    self.ocjLab_buyer.textColor = [UIColor colorWSHHFromHexString:@"151515"];
    self.ocjLab_buyer.font = [UIFont systemFontOfSize:11];
    [self addSubview:self.ocjLab_buyer];
    [self.ocjLab_buyer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImgView);
        make.top.mas_equalTo(self.ocjLab_sellPrice.mas_bottom).offset(3);
    }];
    self.ocjLab_discount.hidden = YES;
    self.ocjLab_marketPrice.hidden = YES;
    self.ocjLab_buyer.hidden = YES;
    ocjView_line.hidden = YES;
}

/**
 改变字符串中特定字符字体大小
 */
- (NSMutableAttributedString *)ocj_changeStringColorWithString:(NSString *)oldStr andTitleFont:(NSInteger)font {
    NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
    for (int i = 0; i < oldStr.length; i++) {
        unichar c = [oldStr characterAtIndex:i];
        if ((c >= 48 && c <= 57)) {
            [newStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(i, 1)];
        }else {
            [newStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font-3] range:NSMakeRange(i, 1)];
        }
    }
    return newStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
