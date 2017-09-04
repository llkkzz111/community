//
//  OCJResetPwdTVCell.m
//  OCJ
//
//  Created by zhangchengcai on 2017/4/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJResetPwdTVCell.h"

@implementation OCJResetPwdTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView addSubview:self.ocjTF_pwd];
        [self.contentView addSubview:self.ocjBtn_show];
        [self.ocjBtn_show addSubview:self.ocjImg_bg];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1/2.0);
    }];
    [self.ocjTF_pwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_line);
        make.right.mas_equalTo(self.ocjView_line).offset(-40);
        make.bottom.mas_equalTo(self.ocjView_line).offset(-5);
        make.height.mas_equalTo(24);
    }];
    
    [self.ocjBtn_show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.ocjView_line);
        make.bottom.mas_equalTo(self.ocjView_line).offset(-11);
    }];
    [self.ocjImg_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(12);
        make.right.mas_equalTo(self.ocjBtn_show);
        make.bottom.mas_equalTo(self.ocjBtn_show);
    }];
}
- (OCJBaseTextField *)ocjTF_pwd{
    if (!_ocjTF_pwd) {
        _ocjTF_pwd = [OCJBaseTextField new];
        _ocjTF_pwd.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _ocjTF_pwd.textColor = OCJ_COLOR_DARK;
        _ocjTF_pwd.font = [UIFont systemFontOfSize:15];
        _ocjTF_pwd.tintColor = [UIColor redColor];
        [_ocjTF_pwd addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _ocjTF_pwd;
}
- (void)textFieldChange:(id)sender{
    if (self.ocj_textChangeBlock) {
        self.ocj_textChangeBlock(self.ocjTF_pwd);
    }
}
- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [UIView new];
        _ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    }
    return _ocjView_line;
}

- (OCJBaseButton *)ocjBtn_show{
    if (!_ocjBtn_show) {
        _ocjBtn_show = [[OCJBaseButton alloc]init];
        _ocjBtn_show.ocjFont = [UIFont systemFontOfSize:15];
        [_ocjBtn_show addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_show;
}
- (UIImageView *)ocjImg_bg{
    if (!_ocjImg_bg) {
        _ocjImg_bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_pw_active"]];
    }
    return _ocjImg_bg;
}
- (void)action:(id)sender{
    self.ocjBool_showPwd = !self.ocjBool_showPwd;
    if (self.ocjBool_showPwd) {
        self.ocjTF_pwd.secureTextEntry = YES;
        [self.ocjImg_bg setImage:[UIImage imageNamed:@"icon_pw_normal"]];
    }else{
        self.ocjTF_pwd.secureTextEntry = NO;
        [self.ocjImg_bg setImage:[UIImage imageNamed:@"icon_pw_active"]];
    }
}


@end
