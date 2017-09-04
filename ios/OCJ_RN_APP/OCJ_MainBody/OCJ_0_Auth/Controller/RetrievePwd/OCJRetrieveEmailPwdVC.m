//
//  OCJRetrieveEmailPwdVC.m
//  OCJ
//
//  Created by Ray on 2017/4/28.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRetrieveEmailPwdVC.h"
#import "OCJHttp_personalInfoAPI.h"
#import "OCJResModel_personalInfo.h"
#import "OCJHttp_authAPI.h"

#define SMS_PURPOSE_RETRIEVE_PASSWORD @"retrieve_password_context"

#import "OCJPersonalInformationVC.h"

@interface OCJRetrieveEmailPwdVC ()

@property (nonatomic, strong) UIView *ocjView_userInformation;
@property (nonatomic, strong) OCJBaseLabel *ocjLab_name;///<用户名
@property (nonatomic, strong) OCJBaseLabel *ocjLab_remind;///<提示label
@property (nonatomic, strong) OCJBaseLabel *ocjLab_email;///<显示邮箱

@property (nonatomic, strong) OCJBaseButton *ocjBtn_sendEmail;//发送邮件按钮

@end

@implementation OCJRetrieveEmailPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf{
  
    if (self.ocjSendEmailype == OCJSendEmailTypeFindPwd) {
      self.title = @"找回密码";
      self.ocjStr_trackPageID = @"AP1706C009";
    }else if (self.ocjSendEmailype == OCJSendEmailTypeModifyMail) {
      self.title = @"修改邮箱";
    }
  
    [self ocj_addViews];
}


- (void)ocj_addViews {
    [self ocj_addViewUserInformation];
    [self ocj_addBtnSendEmail];
}

//展示信息
- (void)ocj_addViewUserInformation {
    self.ocjView_userInformation = [[UIView alloc] init];
    self.ocjView_userInformation.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ocjView_userInformation];
    [self.ocjView_userInformation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(@150);
    }];
    
    //name
    self.ocjLab_name = [[OCJBaseLabel alloc] init];
    self.ocjLab_name.numberOfLines = 1;
    self.ocjLab_name.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_name.font = [UIFont systemFontOfSize:17];
    self.ocjLab_name.textColor = OCJ_COLOR_DARK;
    NSString *newStr = [self.ocjStr_userName substringToIndex:1];
    self.ocjLab_name.text = [NSString stringWithFormat:@"%@***您好，", newStr];
    [self.ocjView_userInformation addSubview:self.ocjLab_name];
    [self.ocjLab_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_userInformation.mas_left).offset(20);
        make.top.mas_equalTo(self.ocjView_userInformation.mas_top).offset(20);
        make.height.mas_equalTo(@25);
        make.right.mas_equalTo(self.ocjView_userInformation.mas_right).offset(-80);
    }];
    
    //remind
    self.ocjLab_remind = [[OCJBaseLabel alloc] init];
    self.ocjLab_remind.numberOfLines = 1;
    self.ocjLab_remind.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_remind.font = [UIFont systemFontOfSize:17];
    self.ocjLab_remind.textColor = OCJ_COLOR_DARK;
  
  if (self.ocjSendEmailype == OCJSendEmailTypeModifyMail) {
    self.ocjLab_remind.text = @"我们已发送邮件至：";
  }else{
    self.ocjLab_remind.text = @"我们将发送邮件至：";
  }
  
    [self.ocjView_userInformation addSubview:self.ocjLab_remind];
    [self.ocjLab_remind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_userInformation.mas_left).offset(20);
        make.top.mas_equalTo(self.ocjLab_name.mas_bottom).offset(15);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@250);
    }];
    
    //email
    self.ocjLab_email = [[OCJBaseLabel alloc] init];
    self.ocjLab_email.numberOfLines = 1;
    self.ocjLab_email.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_email.font = [UIFont systemFontOfSize:17];
    self.ocjLab_email.textColor = OCJ_COLOR_DARK;
    /* 模糊邮件地址方法
    NSInteger index = 0;
    for (int i = 0; i < self.ocjStr_email.length; i++) {
        unichar c = [self.ocjStr_email characterAtIndex:i];
        if (c == 64) {
            index = i;
        }
    }
    if (index>3) {
        self.ocjLab_email.text = [NSString stringWithFormat:@"%@", [self.ocjStr_email stringByReplacingCharactersInRange:NSMakeRange(index - 3, 1) withString:@"***"]];
    }else{
        self.ocjLab_email.text = self.ocjStr_email;
    }
     */
  if (self.ocjSendEmailype == OCJSendEmailTypeModifyMail) {
    self.ocjLab_email.numberOfLines = 3;
    self.ocjLab_email.text = [self.ocjStr_email stringByAppendingString:@"\n\n验证邮件将在发出1小时后过期"];
  }else{
    self.ocjLab_email.text = self.ocjStr_email;
  }
  
    [self.ocjView_userInformation addSubview:self.ocjLab_email];
    [self.ocjLab_email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_userInformation.mas_left).offset(20);
        make.top.mas_equalTo(self.ocjLab_remind.mas_bottom).offset(8);
      
//        make.height.mas_equalTo(@25);
      
        make.right.mas_equalTo(self.ocjView_userInformation.mas_right).offset(-20);
    }];
}

//发送邮件按钮
- (void)ocj_addBtnSendEmail {
  if (self.ocjSendEmailype == OCJSendEmailTypeModifyMail) {
    self.ocjBtn_sendEmail = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 150 + 20, SCREEN_WIDTH - 40, 45)];
    [self.ocjBtn_sendEmail setTitle:@"我知道了" forState:UIControlStateNormal];
    self.ocjBtn_sendEmail.ocjFont = [UIFont systemFontOfSize:17];
    [self.ocjBtn_sendEmail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.ocjBtn_sendEmail.layer.cornerRadius = 2;
    [self.ocjBtn_sendEmail ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [self.ocjBtn_sendEmail addTarget:self action:@selector(ocj_sendEmailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ocjBtn_sendEmail];
  }else{
    self.ocjBtn_sendEmail = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 150 + 20, SCREEN_WIDTH - 40, 45)];
    [self.ocjBtn_sendEmail setTitle:@"发送验证邮件" forState:UIControlStateNormal];
    self.ocjBtn_sendEmail.ocjFont = [UIFont systemFontOfSize:17];
    [self.ocjBtn_sendEmail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.ocjBtn_sendEmail.layer.cornerRadius = 2;
    [self.ocjBtn_sendEmail ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [self.ocjBtn_sendEmail addTarget:self action:@selector(ocj_sendEmailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ocjBtn_sendEmail];
  }
}

//点击发送邮件按钮
- (void)ocj_sendEmailAction {
    switch (self.ocjSendEmailype) {
        case 0:{
            [OCJHttp_authAPI ocjAuth_sendEmailCodeWithEmail:self.ocjStr_email completionHandler:^(OCJBaseResponceModel *responseModel) {
              if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
                [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeSuccessSendEmail title:@"邮件发送成功" message:@"验证邮件将在1小时后过期" sureButtonTitle:nil CancelButtonTitle:@"确定" action:^(NSInteger clickIndex) {
                  
                    [self ocj_trackEventID:@"AP1706C009F008001O008001" parmas:nil];
                }];
              }
            }];
        }
            break;
        case 1:{
//            [OCJHttp_personalInfoAPI ocjPersonal_changeEmailWithNewEmail:self.ocjStr_email completionHandler:^(OCJBaseResponceModel *responseModel) {
//
//                if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
//                    [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeSuccessSendEmail title:@"邮件发送成功" message:@"验证邮件将在1小时后过期" sureButtonTitle:nil CancelButtonTitle:@"确定" action:^(NSInteger clickIndex) {
//
//                    }];
//                }
//            }];
          __weak __typeof(self) weakSelf = self;
          [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isMemberOfClass:[OCJPersonalInformationVC class]]) {
              [weakSelf.navigationController popToViewController:obj animated:NO];
            }
          }];
        }
          break;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
