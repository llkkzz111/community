//
//  OCJSecurityGoodsView.m
//  OCJ
//
//  Created by LZB on 2017/4/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSecurityGoodsView.h"

@implementation OCJSecurityGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self ocj_addViews];
        self.ocj_isSelected = NO;
    }
    return self;
}

- (void)ocj_loadData:(id)data {
    self.ocjImgView_goods.image = [UIImage imageNamed:@""];
    self.ocjImgView_goods.backgroundColor = [UIColor colorWSHHFromHexString:@"ededed"];
    self.ocjLab_name.text = @"";
    [self bringSubviewToFront:self.ocjImgView_goods];
    [self bringSubviewToFront:self.ocjLab_name];
}

- (void)ocj_addViews {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tapGesture:)];
    [self addGestureRecognizer:tap];
    
    self.ocjImgView_goods = [[UIImageView alloc] init];
    self.ocjImgView_goods.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ocjImgView_goods];
    [self.ocjImgView_goods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(self.frame.size.width);
    }];
    
    self.ocjLab_name = [[OCJBaseLabel alloc] init];
    self.ocjLab_name.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_name.numberOfLines = 1;
    self.ocjLab_name.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_name.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.ocjLab_name];
    [self.ocjLab_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.top.mas_equalTo(self.ocjImgView_goods.mas_bottom).offset(5);
    }];
    
    self.ocjImgView_selected = [[UIImageView alloc] init];
    self.ocjImgView_selected.backgroundColor = [UIColor clearColor];
    self.ocjImgView_selected.image = [UIImage imageNamed:@"icon_selected2_"];
    self.ocjImgView_selected.hidden = YES;
    [self addSubview:self.ocjImgView_selected];
    [self.ocjImgView_selected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.ocjLab_name.mas_top).offset(-5);
        make.width.height.mas_equalTo(@25);
    }];
}

- (void)ocj_tapGesture:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(ocj_tappedImageView:)]) {
        [self.delegate ocj_tappedImageView:(OCJSecurityGoodsView *)tap.view];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
