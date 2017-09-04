//
//  OCJSendVerifyCodeTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJSendVerifyCodeTVCell.h"
#import "WSHHRegex.h"
#import "OCJHttp_authAPI.h"

@interface OCJSendVerifyCodeTVCell ()<UITextFieldDelegate>

@end

@implementation OCJSendVerifyCodeTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self ocj_addViews];
  }
  return self;
}

- (void)ocj_addViews {
  [self ocj_addSendCodeBtn];
  [self.ocjBtn_sendCode mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
    make.right.mas_equalTo(self.mas_right).offset(-20);
    make.height.mas_equalTo(32);
    make.width.mas_equalTo(90);
  }];
  
  //tf
  self.ocjTF_code = [[OCJBaseTextField alloc] init];
  self.ocjTF_code.placeholder = @"请输入短信验证码";
  self.ocjTF_code.font = [UIFont systemFontOfSize:15];
  self.ocjTF_code.keyboardType = UIKeyboardTypeNumberPad;
  self.ocjTF_code.tintColor = [UIColor redColor];
  self.ocjTF_code.delegate = self;
  self.ocjTF_code.clearButtonMode = UITextFieldViewModeWhileEditing;
  [self.ocjTF_code addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
  [self addSubview:self.ocjTF_code];
  [self.ocjTF_code mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(@32);
    make.left.mas_equalTo(self.mas_left).offset(20);
    make.right.mas_equalTo(self.ocjBtn_sendCode.mas_left).offset(-10);
    make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
  }];
  //line
  UIView *ocjView_line = [[UIView alloc] init];
  ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
  [self addSubview:ocjView_line];
  [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self.ocjTF_code);
    make.bottom.mas_equalTo(self);
    make.height.mas_equalTo(@0.5);
  }];
}

//添加获取验证码按钮
- (void)ocj_addSendCodeBtn {
  __weak OCJSendVerifyCodeTVCell *weakSelf = self;
  self.ocjBtn_sendCode = [[OCJValidationBtn alloc]init];
  self.ocjBtn_sendCode.ocjBlock_touchUpInside = ^{
    //点击获取验证码按钮
      [weakSelf.ocjBtn_sendCode ocj_startTimer];
    [OCJHttp_authAPI ocjAuth_SendSmscodeWithMobile:weakSelf.ocjStr_account purpose:OCJSMSPurpose_MobileLogin internetID:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
      
    }];
    };
  [self addSubview:self.ocjBtn_sendCode];
}

- (void)ocj_textFieldValueChanged:(UITextField *)tf {
  if (self.ocjTFInputBlock) {
    self.ocjTFInputBlock(tf.text);
  }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
  if (textField == self.ocjTF_code) {
    if (str.length > 6) {
      return NO;
    }else{
      return YES;
    }
  }
  return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
