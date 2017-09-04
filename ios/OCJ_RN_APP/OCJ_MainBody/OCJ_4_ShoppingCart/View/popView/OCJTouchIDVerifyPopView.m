//
//  OCJTouchIDVerifyPopView.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJTouchIDVerifyPopView.h"
#import "OCJVerifyCodeView.h"
#import "OCJDataUserInfo+CoreDataClass.h"
#import "OCJTouchIDPwdView.h"
#import "OCJHttp_authAPI.h"
#import "OCJRetrievePwdVC.h"

@interface OCJTouchIDVerifyPopView ()

@property (nonatomic, strong) UIView *ocjView_header;             ///<header
@property (nonatomic, strong) UIView *ocjView_container;          ///<底部视图
@property (nonatomic, strong) OCJTouchIDVerifyHandler handler;
@property (nonatomic, strong) UILabel *ocjLab_userName;           ///<用户名
@property (nonatomic, strong) NSString *ocjStr_code;              ///<验证吗
@property (nonatomic, strong) NSString *ocjStr_pwd;               ///<密码

@property (nonatomic, strong) OCJDataUserInfo* ocjUserInfo; ///< 用户信息coredata对象

@end

@implementation OCJTouchIDVerifyPopView

+ (void)ocj_popTouchIDVerifyViewHandler:(OCJTouchIDVerifyHandler)verifyHandler {
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  
  OCJTouchIDVerifyPopView *verifyView = [[OCJTouchIDVerifyPopView alloc] init];
  verifyView.userInteractionEnabled = YES;
  verifyView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
  verifyView.alpha = 1;
  [window addSubview:verifyView];
  [verifyView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.bottom.mas_equalTo(window);
  }];
  
  verifyView.ocjView_container = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
  verifyView.ocjView_container.backgroundColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
  [verifyView addSubview:verifyView.ocjView_container];
  
  [UIView animateWithDuration:0.5 animations:^{
    verifyView.ocjView_container.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
  }];
  
  [verifyView ocj_addHeaderView];
  [verifyView ocj_addUserNameView];
  [verifyView ocj_addVerifyCodeView];
  
  verifyView.handler = verifyHandler;
}

- (void)ocj_addHeaderView {
  self.ocjView_header = [[UIView alloc] init];
  self.ocjView_header.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self.ocjView_container addSubview:self.ocjView_header];
  [self.ocjView_header mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.mas_equalTo(self.ocjView_container);
    make.height.mas_equalTo(@44);
  }];
  //支付安全校验
  UILabel *ocjLab_title = [[UILabel alloc] init];
  ocjLab_title.text = @"支付安全校验";
  ocjLab_title.font = [UIFont systemFontOfSize:17];
  ocjLab_title.textColor = OCJ_COLOR_DARK;
  ocjLab_title.textAlignment = NSTextAlignmentCenter;
  [self.ocjView_header addSubview:ocjLab_title];
  [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.ocjView_header);
    make.centerY.mas_equalTo(self.ocjView_header);
  }];
  //关闭按钮
  UIButton *ocjBtn_close = [[UIButton alloc] init];
  [ocjBtn_close setImage:[UIImage imageNamed:@"icon_clear"] forState:UIControlStateNormal];
  [ocjBtn_close addTarget:self action:@selector(ocj_closeAction) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_header addSubview:ocjBtn_close];
  [ocjBtn_close mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.right.mas_equalTo(self.ocjView_header);
    make.width.height.mas_equalTo(@44);
  }];
}

- (void)ocj_addUserNameView {
  NSString *ocjStr_name;
  if ([self.ocjUserInfo.ocjStr_name length] <= 2) {
    ocjStr_name = [NSString stringWithFormat:@"当前用户 %@", self.ocjUserInfo.ocjStr_name];
  }else {
    NSString *newStr = [self.ocjUserInfo.ocjStr_name stringByReplacingCharactersInRange:NSMakeRange(1, [self.ocjUserInfo.ocjStr_name length] - 2) withString:@"**"];
    ocjStr_name = [NSString stringWithFormat:@"当前用户 %@", newStr];
  }
  
  self.ocjLab_userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 40)];
  self.ocjLab_userName.textColor = OCJ_COLOR_DARK;
  self.ocjLab_userName.text = ocjStr_name;
  self.ocjLab_userName.backgroundColor = OCJ_COLOR_BACKGROUND;
  self.ocjLab_userName.font = [UIFont systemFontOfSize:15];
  self.ocjLab_userName.textAlignment = NSTextAlignmentCenter;
  [self.ocjView_container addSubview:self.ocjLab_userName ];
  [self.ocjLab_userName  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.ocjView_container);
    make.top.mas_equalTo(self.ocjView_header.mas_bottom).offset(0);
    make.height.mas_equalTo(@40);
  }];
}

- (OCJDataUserInfo *)ocjUserInfo{
  if (!_ocjUserInfo) {
    _ocjUserInfo = [[OCJDataUserInfo ocj_fetchUserInfo]lastObject];
  }
  
  return _ocjUserInfo;
}

/**
 验证码页面
 */
- (void)ocj_addVerifyCodeView {
  __weak OCJTouchIDVerifyPopView *weakSelf = self;
  OCJVerifyCodeView *codeView = [[OCJVerifyCodeView alloc] init];
  codeView.ocjStr_account = self.ocjUserInfo.ocjStr_account;
  __weak OCJVerifyCodeView *weakCodeView = codeView;
  
  codeView.ocjPwdLoginBlock = ^(NSString *ocjStr_type, NSString *ocjStr_code) {
    weakSelf.ocjStr_code = ocjStr_code;
    if ([ocjStr_type isEqualToString:@"0"]) {
      [weakCodeView removeFromSuperview];
      [weakSelf ocj_addPasswdView];
    }else {
      [weakSelf ocj_loginActionWithType:@"code"];
    }
  };
  [self.ocjView_container addSubview:codeView];
  [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.mas_equalTo(self.ocjView_container);
    make.top.mas_equalTo(self.ocjLab_userName.mas_bottom).offset(0);
  }];
}

/**
 输入密码页面
 */
- (void)ocj_addPasswdView {
  __weak OCJTouchIDVerifyPopView *weakSelf = self;
  OCJTouchIDPwdView *pwdView = [[OCJTouchIDPwdView alloc] init];
  pwdView.ocjStr_account = self.ocjUserInfo.ocjStr_account;
  __weak OCJTouchIDPwdView *weakPwdView = pwdView;
  
  pwdView.ocjVerifyCodeBlock = ^(NSString *ocjStr_type, NSString *ocJStr_pwd) {
    weakSelf.ocjStr_pwd = ocJStr_pwd;
    if ([ocjStr_type isEqualToString:@"0"]) {
      [weakPwdView removeFromSuperview];
      [weakSelf ocj_addVerifyCodeView];
    }else if ([ocjStr_type isEqualToString:@"1"]) {
      [weakSelf ocj_loginActionWithType:@"pwd"];
    }else {
      OCJRetrievePwdVC *retrieveVC = [[OCJRetrievePwdVC alloc] init];
      [[AppDelegate ocj_getTopViewController].navigationController pushViewController:retrieveVC animated:YES];
      [weakSelf removeFromSuperview];
    }
  };
  [self.ocjView_container addSubview:pwdView];
  [pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.mas_equalTo(self.ocjView_container);
    make.top.mas_equalTo(self.ocjLab_userName.mas_bottom).offset(0);
  }];
}

/**
 登录
 */
- (void)ocj_loginActionWithType:(NSString *)ocjStr {
  __weak OCJTouchIDVerifyPopView *weakSelf = self;
  if ([ocjStr isEqualToString:@"pwd"]) {//密码登录
    [OCJHttp_authAPI ocjAuth_loginWithID:self.ocjUserInfo.ocjStr_account password:self.ocjStr_pwd thirdPartyInfo:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        [weakSelf removeFromSuperview];
        weakSelf.handler(@"success");
      }
    }];
  }else if ([ocjStr isEqualToString:@"code"]) {//验证码登录
    [OCJHttp_authAPI ocjAuth_smscodeLoginWithMobile:self.ocjUserInfo.ocjStr_account verifyCode:self.ocjStr_code purpose:@"mobile_login_context" thirdPartyInfo:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        [weakSelf removeFromSuperview];
        weakSelf.handler(@"success");
      }
    }];
  }
}

/**
 关闭
 */
- (void)ocj_closeAction {
  [UIView animateWithDuration:0.5 animations:^{
    self.ocjView_container.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
  }completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
