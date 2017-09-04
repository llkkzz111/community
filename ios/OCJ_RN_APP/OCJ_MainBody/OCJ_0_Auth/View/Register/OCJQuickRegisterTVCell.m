//
//  OCJQuickRegisterTVCell.m
//  OCJ
//
//  Created by zhangchengcai on 2017/4/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJQuickRegisterTVCell.h"

@implementation OCJQuickRegisterTVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView addSubview:self.ocj_mobileTF];
        [self.contentView addSubview:self.ocjBtn_sendCode];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
- (void)setOcjBOOL_show:(BOOL)ocjBOOL_show{
    if (ocjBOOL_show) {
        self.ocjBtn_sendCode.hidden = NO;
    }else{
        self.ocjBtn_sendCode.hidden = YES;
    }
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_equalTo(20);
        make.right.mas_equalTo(self.contentView).mas_equalTo(-20);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.ocj_mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_line.mas_left);
        make.right.mas_equalTo(self.ocjView_line.mas_right);
        make.bottom.mas_equalTo(self.ocjView_line.mas_top).offset(-3);
        make.height.mas_equalTo(24);
    }];
    
    [self.ocjBtn_sendCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.ocjView_line).offset(-5);
        make.right.mas_equalTo(self.ocjView_line);
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

- (OCJBaseTextField *)ocj_mobileTF{
    if (!_ocjTF_mobile) {
        _ocjTF_mobile = [OCJBaseTextField new];
        _ocjTF_mobile.placeholder     = @"请输入手机号";
        _ocjTF_mobile.clearButtonMode = UITextFieldViewModeWhileEditing;
        _ocjTF_mobile
        .keyboardType    = UIKeyboardTypeNumberPad;
        _ocjTF_mobile.tintColor       = [UIColor redColor];
        _ocjTF_mobile.font            = [UIFont systemFontOfSize:15];
    }
    return _ocjTF_mobile;
}
- (OCJValidationBtn *)ocjBtn_sendCode{
    if (!_ocjBtn_sendCode) {
        _ocjBtn_sendCode = [[OCJValidationBtn alloc]init];
    }
    return _ocjBtn_sendCode;
}




@end


@implementation OCJCodeTVCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView addSubview:self.ocj_mobileTF];
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
    
    [self.ocj_mobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (OCJBaseTextField *)ocj_mobileTF{
    if (!_ocjTF_mobile) {
        _ocjTF_mobile = [OCJBaseTextField new];
        _ocjTF_mobile.placeholder     = @"请输入手机号";
        _ocjTF_mobile.clearButtonMode = UITextFieldViewModeWhileEditing;
        _ocjTF_mobile
        .keyboardType    = UIKeyboardTypeNumberPad;
        _ocjTF_mobile.tintColor       = [UIColor redColor];
        _ocjTF_mobile.font            = [UIFont systemFontOfSize:15];
    }
    return _ocjTF_mobile;
}
- (OCJValidationBtn *)ocjBtn_sendCode{
    if (!_ocjBtn_sendCode) {
        _ocjBtn_sendCode = [[OCJValidationBtn alloc]init];
    }
    return _ocjBtn_sendCode;
}
- (void)sendMSg:(OCJBaseButton *)sender{

    
}


@end


@implementation OCJLQuickRegisteBottomTVCell

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
                self.ocjTF_pwd.secureTextEntry = YES;
        [self.ocjImg_bg setImage:[UIImage imageNamed:@"icon_pw_normal"] ];
    }else{
                self.ocjTF_pwd.secureTextEntry = NO;
        [self.ocjImg_bg setImage:[UIImage imageNamed:@"icon_pw_active"] ];
    }
}



@end
