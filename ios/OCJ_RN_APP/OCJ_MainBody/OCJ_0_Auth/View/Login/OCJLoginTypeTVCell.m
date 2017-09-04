//
//  OCJLoginTypeTVCell.m
//  OCJ
//
//  Created by OCJ on 2017/4/25.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJLoginTypeTVCell.h"

@implementation OCJLoginTypeTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView addSubview:self.ocjTF_input];
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
    [self.ocjTF_input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_line);
        make.right.mas_equalTo(self.ocjView_line);
        make.bottom.mas_equalTo(self.ocjView_line).offset(-5);
        make.height.mas_equalTo(24);
    }];
}
- (OCJBaseTextField *)ocjTF_input{
    if (!_ocjTF_input) {
        _ocjTF_input = [OCJBaseTextField new];
        _ocjTF_input.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjTF_input.font = [UIFont systemFontOfSize:15];
        _ocjTF_input.placeholder = @"请输入手机号";
        _ocjTF_input.tintColor = [UIColor redColor];
        _ocjTF_input.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _ocjTF_input;
}
- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [UIView new];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"999999"];
    }
    return _ocjView_line;
}


@end




@implementation OCJLoginTypeSendCodeTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView addSubview:self.ocjTF_input];
        [self.contentView addSubview:self.ocjBtn_sendCode];
        [self.contentView setNeedsUpdateConstraints];
        
    }
    return self;
}


- (void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_equalTo(20);
        make.right.mas_equalTo(self.contentView).mas_equalTo(-120);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.ocjTF_input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_line.mas_left);
        make.right.mas_equalTo(self.ocjView_line.mas_right);
        make.bottom.mas_equalTo(self.ocjView_line.mas_top).offset(-3);
        make.height.mas_equalTo(24);
    }];
    
    [self.ocjBtn_sendCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(90);
    }];
}
- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [UIView new];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"999999"];
    }
    return _ocjView_line;
}

- (OCJBaseTextField *)ocjTF_input{
    if (!_ocjTF_input) {
        _ocjTF_input = [OCJBaseTextField new];
        _ocjTF_input.placeholder     = @"请输入验证码";
        _ocjTF_input.clearButtonMode = UITextFieldViewModeWhileEditing;
        _ocjTF_input.keyboardType    = UIKeyboardTypeNumberPad;
        _ocjTF_input.tintColor       = [UIColor redColor];
        _ocjTF_input.font            = [UIFont systemFontOfSize:15];
    }
    return _ocjTF_input;
}
- (OCJBaseButton *)ocjBtn_sendCode{
    if (!_ocjBtn_sendCode) {
        _ocjBtn_sendCode = [[OCJValidationBtn alloc]init];
    }
    return _ocjBtn_sendCode;
}


@end


@implementation OCJLoginTypeSendPwdTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView addSubview:self.ocjTF_pwd];
        [self.contentView addSubview:self.ocjBtn_show];
        [self.contentView addSubview:self.ocjImg_bg];
        [self.contentView addSubview:self.ocjBtn_forgetPwd];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.bottom.mas_equalTo(self.contentView).offset(-30);
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
    [self.ocjBtn_forgetPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(21);
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
}
- (OCJBaseButton *)ocjBtn_forgetPwd{
    if (!_ocjBtn_forgetPwd) {
        _ocjBtn_forgetPwd = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
        [_ocjBtn_forgetPwd setTitle:@"忘记密码" forState:UIControlStateNormal];
        _ocjBtn_forgetPwd.ocjFont = [UIFont systemFontOfSize:15];
        [_ocjBtn_forgetPwd setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
    }
    return _ocjBtn_forgetPwd;
}


- (OCJBaseTextField *)ocjTF_pwd{
    if (!_ocjTF_pwd) {
        _ocjTF_pwd = [OCJBaseTextField new];
        _ocjTF_pwd.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _ocjTF_pwd.secureTextEntry = YES;
        _ocjTF_pwd.textColor = OCJ_COLOR_DARK;
        _ocjTF_pwd.font = [UIFont systemFontOfSize:15];
        _ocjTF_pwd.placeholder = @"密码";
        _ocjTF_pwd.tintColor = [UIColor redColor];
    }
    return _ocjTF_pwd;
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
      self.ocjTF_pwd.secureTextEntry = NO;
      [self.ocjImg_bg setImage:[UIImage imageNamed:@"icon_pw_normal"] ];

      
    }else{
      self.ocjTF_pwd.secureTextEntry = YES;
      [self.ocjImg_bg setImage:[UIImage imageNamed:@"icon_pw_active"] ];
    }
}


@end


@implementation OCJLoginTypePwdTVCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView addSubview:self.ocjTF_pwd];
        [self.contentView addSubview:self.ocjBtn_show];
        [self.contentView addSubview:self.ocjImg_bg];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.right.mas_equalTo(self.contentView).offset(-20);
        make.bottom.mas_equalTo(self.contentView).offset(0);
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
        _ocjTF_pwd.placeholder = @"密码";
        _ocjTF_pwd.tintColor = [UIColor redColor];
    }
    return _ocjTF_pwd;
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
        self.ocjTF_pwd.secureTextEntry = NO;
        [self.ocjImg_bg setImage:[UIImage imageNamed:@"icon_pw_normal"] ];
    }else{
        self.ocjTF_pwd.secureTextEntry = YES;
        [self.ocjImg_bg setImage:[UIImage imageNamed:@"icon_pw_active"] ];
    }
}

@end
