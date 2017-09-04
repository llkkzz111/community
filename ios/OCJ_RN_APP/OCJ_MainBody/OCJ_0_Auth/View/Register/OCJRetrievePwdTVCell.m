//
//  OCJRetrievePwdTVCell.m
//  OCJ
//
//  Created by zhangchengcai on 2017/4/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRetrievePwdTVCell.h"

@implementation OCJRetrievePwdTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView addSubview:self.ocjTF_Email];
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
    [self.ocjTF_Email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_line);
        make.right.mas_equalTo(self.ocjView_line);
        make.bottom.mas_equalTo(self.ocjView_line).offset(-5);
        make.height.mas_equalTo(24);
    }];
}
- (OCJBaseTextField *)ocjTF_Email{
    if (!_ocjTF_Email) {
        _ocjTF_Email = [OCJBaseTextField new];
        _ocjTF_Email.tintColor       = [UIColor redColor];
        _ocjTF_Email.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjTF_Email.keyboardType = UIKeyboardTypeDefault;
        _ocjTF_Email.tintColor = [UIColor redColor];
        _ocjTF_Email.font = [UIFont systemFontOfSize:15];
    }
    return _ocjTF_Email;
}
- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [UIView new];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"999999"];
    }
    return _ocjView_line;
}


@end

@implementation OCJRetrieveCodeTVCell

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
        _ocjTF_mobile.tintColor       = [UIColor redColor];
        _ocjTF_mobile.font            = [UIFont systemFontOfSize:15];
    }
    return _ocjTF_mobile;
}
- (OCJBaseButton *)ocjBtn_sendCode{
    if (!_ocjBtn_sendCode) {
        _ocjBtn_sendCode = [[OCJValidationBtn alloc]init];
    }
    return _ocjBtn_sendCode;
}



@end
