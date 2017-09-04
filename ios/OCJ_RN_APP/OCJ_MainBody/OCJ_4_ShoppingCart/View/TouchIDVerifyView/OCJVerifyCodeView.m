//
//  OCJVerifyCodeView.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJVerifyCodeView.h"
#import "OCJVerifyTitleTVCell.h"
#import "OCJSendVerifyCodeTVCell.h"
#import "OCJConfirmBtnTVCell.h"

@interface OCJVerifyCodeView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_code;   ///<tableView
@property (nonatomic, strong) OCJBaseButton *ocjBtn_login;        ///<登录按钮
@property (nonatomic, strong) UITextField *ocjTF_code;            ///<输入框

@end

@implementation OCJVerifyCodeView

- (instancetype)init {
  self = [super init];
  if (self) {
    [self ocj_addTableView];
  }
  return self;
}

- (void)ocj_addTableView {
  self.ocjTBView_code = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.ocjTBView_code.delegate = self;
  self.ocjTBView_code.dataSource = self;
  self.ocjTBView_code.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self addSubview:self.ocjTBView_code];
  [self.ocjTBView_code mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.mas_equalTo(self);
    make.top.mas_equalTo(self.mas_top).offset(0);
  }];
}

#pragma mark - 点击事件

/**
 登录
 */
- (void)ocj_clickedConfirmBtn {
  __weak OCJVerifyCodeView *weakSelf = self;
  if (self.ocjPwdLoginBlock) {
    self.ocjPwdLoginBlock(@"1", weakSelf.ocjTF_code.text);
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
  __weak OCJVerifyCodeView *weakSelf = self;
  if (indexPath.row == 0) {
    OCJSendVerifyCodeTVCell *cell = [[OCJSendVerifyCodeTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJSendVerifyCodeTVCell"];
    cell.ocjStr_account = self.ocjStr_account;
    self.ocjTF_code = cell.ocjTF_code;
    cell.ocjTFInputBlock = ^(NSString *ocjStr_code) {
      if ([ocjStr_code length] > 0) {
        weakSelf.ocjBtn_login.userInteractionEnabled = YES;
        weakSelf.ocjBtn_login.alpha = 1.0;
      }else {
        weakSelf.ocjBtn_login.userInteractionEnabled = NO;
        weakSelf.ocjBtn_login.alpha = 0.2;
      }
    };
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
    [cell.ocjBtn_title setTitle:@"使用登录密码验证" forState:UIControlStateNormal];
    cell.ocjChangeVerifyBlock = ^{
      if (weakSelf.ocjPwdLoginBlock) {
        weakSelf.ocjPwdLoginBlock(@"0", @"");
      }
    };
    return cell;
  }
  
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    return 65;
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
