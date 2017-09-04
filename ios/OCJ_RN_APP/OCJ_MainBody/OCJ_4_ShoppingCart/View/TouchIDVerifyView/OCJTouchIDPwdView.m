//
//  OCJTouchIDPwdView.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJTouchIDPwdView.h"
#import "OCJLoginTypeTVCell.h"
#import "OCJConfirmBtnTVCell.h"
#import "OCJVerifyTitleTVCell.h"

@interface OCJTouchIDPwdView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_pwd;            ///<
@property (nonatomic, strong) UITextField *ocjTF_pwd;                     ///<输入框
@property (nonatomic, strong) UIButton *ocjBtn_login;                     ///<登录按钮

@end

@implementation OCJTouchIDPwdView

- (instancetype)init {
  self = [super init];
  if (self) {
    [self ocj_addTableView];
  }
  return self;
}

- (void)ocj_addTableView {
  self.ocjTBView_pwd = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.ocjTBView_pwd.delegate = self;
  self.ocjTBView_pwd.dataSource = self;
  self.ocjTBView_pwd.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self addSubview:self.ocjTBView_pwd];
  [self.ocjTBView_pwd mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.mas_equalTo(self);
    make.top.mas_equalTo(self.mas_top).offset(0);
  }];
}

- (void)ocj_textFieldValueChange:(UITextField *)tf {
  if ([tf.text length] > 0) {
    self.ocjBtn_login.userInteractionEnabled = YES;
    self.ocjBtn_login.alpha = 1.0;
  }else {
    self.ocjBtn_login.userInteractionEnabled = NO;
    self.ocjBtn_login.alpha = 0.2;
  }
}

#pragma mark - 点击事件
/**
 登录
 */
- (void)ocj_clickedConfirmBtn {
  __weak OCJTouchIDPwdView *weakSelf = self;
  if (self.ocjVerifyCodeBlock) {
    self.ocjVerifyCodeBlock(@"1", weakSelf.ocjTF_pwd.text);
  }
}

/**
 忘记密码
 */
- (void)ocj_forgetPasswordAction {
  __weak OCJTouchIDPwdView *weakSelf = self;
  if (self.ocjVerifyCodeBlock) {
    self.ocjVerifyCodeBlock(@"2", weakSelf.ocjTF_pwd.text);
  }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak OCJTouchIDPwdView *weakSelf = self;
  if (indexPath.row == 0) {
    OCJLoginTypeSendPwdTVCell * cell = [[OCJLoginTypeSendPwdTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJLoginTypeSendPwdTVCell"];
    cell.ocjTF_pwd.text = @"";
    cell.ocjTF_pwd.placeholder = @"请输入登录密码";
    [cell.ocjTF_pwd addTarget:self action:@selector(ocj_textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    self.ocjTF_pwd = cell.ocjTF_pwd;
    
    [cell.ocjBtn_forgetPwd addTarget:self action:@selector(ocj_forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    return cell;
  }else if (indexPath.row == 1) {
    OCJConfirmBtnTVCell *cell = [[OCJConfirmBtnTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJConfirmBtnTVCell"];
    cell.ocjConfirmBtnBlock = ^{
      [weakSelf ocj_clickedConfirmBtn];
    };
    self.ocjBtn_login = cell.ocjBtn_confirm;
    return cell;
  }else if (indexPath.row == 2) {
    OCJVerifyTitleTVCell *cell = [[OCJVerifyTitleTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJVerifyTitleTVCell"];
    [cell.ocjBtn_title setTitle:@"使用验证码校验" forState:UIControlStateNormal];
    cell.ocjChangeVerifyBlock = ^{
      if (weakSelf.ocjVerifyCodeBlock) {
        weakSelf.ocjVerifyCodeBlock(@"0",@"");
      }
    };
    return cell;
  }
  
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    return 85;
  }else if (indexPath.row == 1) {
    return 85;
  }
  return 60;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
