//
//  OCJGlobalScreenRetrievalButtonView.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobalScreenRetrievalButtonView.h"

@interface OCJGlobalScreenRetrievalButtonView()
@property (nonatomic,strong) UIImageView     *ocjImageView_icon;
@property (nonatomic,strong) UIImageView     *ocjImageView_righIcon;
@property (nonatomic,strong) UIButton        *ocjBtn_Mian;
@property (nonatomic,strong) UILabel         *ocjLab_title;
@property (nonatomic,strong) NSString        *ocjStr_title;

@end

@implementation OCJGlobalScreenRetrievalButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews
{
    [self setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1/1.0]];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width*71/92, 12));
        
    }];

    
    [self addSubview:self.ocjImageView_icon];
    [self.ocjImageView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.height/2, self.bounds.size.height/2));
    }];
    
    [self addSubview:self.ocjImageView_righIcon];
    [self.ocjImageView_righIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-7);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(6, 12));
    }];
    
    [self addSubview:self.ocjBtn_Mian];
    [self.ocjBtn_Mian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];

}

- (void)ocj_setTitl:(NSString *)title
{
    self.ocjStr_title = title;
    [self.ocjLab_title setText:title];
    if ([title isEqualToString:@"查看全部"]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.ocjImageView_righIcon setHidden:NO];
    }
}

- (void)ocj_setButtonSelected:(BOOL)selected
{
    if (selected) {
        [self.ocjImageView_icon setHidden:NO];
        [self setBackgroundColor: [UIColor colorWithRed:255/255.0 green:235/255.0 blue:232/255.0 alpha:1/1.0]];
        [self.ocjLab_title setTextColor:[UIColor colorWithRed:243/255.0 green:25/255.0 blue:24/255.0 alpha:1/1.0]];
    }
    else
    {
        [self.ocjImageView_icon setHidden:YES];
        if ([self.ocjStr_title isEqualToString:@"查看全部"]) {
            [self setBackgroundColor:[UIColor clearColor]];
        }
        else
        {
            [self setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1/1.0]];
            [self.ocjLab_title setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0]];
        }
    }
}

- (void)ocj_mianButtonPressed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_onScreenRetrievalButtonPressed:)]) {
        [self.delegate ocj_onScreenRetrievalButtonPressed:self.ocjInt_btnViewTag];
    }
}

#pragma mark - getter
- (UIImageView *)ocjImageView_icon
{
    if (!_ocjImageView_icon) {
        _ocjImageView_icon = [[UIImageView alloc] init];
        [_ocjImageView_icon setBackgroundColor:[UIColor clearColor]];
        [_ocjImageView_icon setImage:[UIImage imageNamed:@"icon_confirm"]];
    }
    return _ocjImageView_icon;
}

- (UIButton *)ocjBtn_Mian
{
    if (!_ocjBtn_Mian) {
        _ocjBtn_Mian = [[UIButton alloc] init];
        [_ocjBtn_Mian setBackgroundColor:[UIColor clearColor]];
        [_ocjBtn_Mian setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_ocjBtn_Mian addTarget:self action:@selector(ocj_mianButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_Mian;
}

- (UILabel *)ocjLab_title
{
    if (!_ocjLab_title) {
        _ocjLab_title = [[UILabel alloc] init];
        [_ocjLab_title setBackgroundColor:[UIColor clearColor]];
        _ocjLab_title.font = [UIFont systemFontOfSize:12];
        _ocjLab_title.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _ocjLab_title.textAlignment = NSTextAlignmentCenter;
    }
    return _ocjLab_title;
}

- (UIImageView *)ocjImageView_righIcon
{
    if (!_ocjImageView_righIcon) {
        _ocjImageView_righIcon = [[UIImageView alloc] init];
        [_ocjImageView_righIcon setBackgroundColor:[UIColor clearColor]];
        [_ocjImageView_righIcon setImage:[UIImage imageNamed:@"indicator_right"]];
        [_ocjImageView_righIcon setHidden:YES];
    }
    return _ocjImageView_righIcon;
}

@end
