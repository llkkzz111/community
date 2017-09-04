//
//  OCJRetrieveMobilePwdVC.m
//  OCJ
//
//  Created by Ray on 2017/4/28.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRetrieveMobilePwdVC.h"
#import "OCJValidationBtn.h"
#import "OCJResetPwdVC.h"
#import "OCJHttp_authAPI.h"

#define SMS_PURPOSE_RETRIEVE_PASSWORD @"retrieve_password_context"

@interface OCJRetrieveMobilePwdVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *ocjView_inputCode;

@property (nonatomic, strong) OCJValidationBtn *ocjBtn_sendCode;///<发送验证码按钮

@property (nonatomic, strong) OCJBaseTextField *ocjTF_code;///<输入验证码

@property (nonatomic, strong) OCJBaseButton *ocjBtn_next;///<下一步

@end

@implementation OCJRetrieveMobilePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.ocjBtn_sendCode ocj_stopTimer];
}

#pragma mark - 私有方法区域
-(void)ocj_back{
  
  [super ocj_back];
  
  [self ocj_trackEventID:@"AP1706C008D003001C003001" parmas:nil];
}

- (void)ocj_setSelf{
  
    self.title = @"输入验证码";
  
    self.ocjStr_trackPageID = @"AP1706C008";
  
    [self ocj_addViews];
}

- (void)ocj_addViews {
    [self ocj_addViewInputCode];
    [self ocj_addBtnNext];
}

//添加输入框和发送验证码按钮
- (void)ocj_addViewInputCode {
    self.ocjView_inputCode = [[UIView alloc] init];
    self.ocjView_inputCode.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ocjView_inputCode];
    [self.ocjView_inputCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
      if (self.topLayoutGuide) {
        make.top.mas_equalTo(self.view).offset(40 + self.topLayoutGuide.length);
      }else {
        make.top.mas_equalTo(self.view.mas_top).offset(40 + 64);
      }
        make.height.mas_equalTo(@32);
    }];
    
    //发送验证码按钮
    [self ocj_addSendCodeBtn];
    [self.ocjBtn_sendCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.ocjView_inputCode);
        make.right.mas_equalTo(self.ocjView_inputCode.mas_right).offset(0);
        make.width.mas_equalTo(90);
    }];
    
    //输入框
    self.ocjTF_code = [[OCJBaseTextField alloc] init];
    self.ocjTF_code.placeholder = @"请输入短信验证码";
    self.ocjTF_code.font = [UIFont systemFontOfSize:15];
    self.ocjTF_code.keyboardType = UIKeyboardTypeNumberPad;
    self.ocjTF_code.tintColor = [UIColor redColor];
    self.ocjTF_code.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ocjTF_code.delegate = self;
    [self.ocjTF_code addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.ocjView_inputCode addSubview:self.ocjTF_code];
    [self.ocjTF_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.ocjView_inputCode);
        make.bottom.mas_equalTo(self.ocjView_inputCode.mas_bottom).offset(-1);
        make.right.mas_equalTo(self.ocjBtn_sendCode.mas_left).offset(-10);
    }];
    
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [self.ocjView_inputCode addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.ocjView_inputCode);
        make.right.mas_equalTo(self.ocjTF_code);
        make.height.mas_equalTo(@0.5);
    }];
}

//添加下一步按钮
- (void)ocj_addBtnNext {
  CGFloat topDistance;
  if (self.topLayoutGuide) {
    topDistance =  40 + 32 + 38 + self.topLayoutGuide.length;
  }else {
   topDistance = 40 + 32 + 38 + 64;
  }
    self.ocjBtn_next = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, topDistance, SCREEN_WIDTH - 40, 45)];
    [self.ocjBtn_next setTitle:@"下一步" forState:UIControlStateNormal];
    self.ocjBtn_next.alpha = 0.2;
    self.ocjBtn_next.userInteractionEnabled = NO;
    [self.ocjBtn_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.ocjBtn_next.layer.cornerRadius = 2;
    [self.ocjBtn_next ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6750"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromUpLeftToDownRight];
    [self.ocjBtn_next addTarget:self action:@selector(ocj_nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ocjBtn_next];
}

//添加获取验证码按钮
- (void)ocj_addSendCodeBtn {
  
    [self ocj_trackEventID:@"AP1706C008F008001O008001" parmas:nil];
  
    __weak OCJRetrieveMobilePwdVC *wself = self;
    self.ocjBtn_sendCode = [[OCJValidationBtn alloc]init];
    self.ocjBtn_sendCode.ocjBlock_touchUpInside = ^{
        //点击获取验证码按钮
        [wself.ocjBtn_sendCode ocj_startTimer];
        [OCJHttp_authAPI ocjAuth_SendSmscodeWithMobile:wself.ocjStr_mobile purpose:SMS_PURPOSE_RETRIEVE_PASSWORD internetID:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
            
        }];
    };
    [self.ocjView_inputCode addSubview:self.ocjBtn_sendCode];
}

/**
 点击下一步按钮
 */
- (void)ocj_nextAction {
    
    if (self.ocjTF_code.text.length != 6) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入正确的验证码" andHideDelay:2];
        return;
    }
  
    [self ocj_trackEventID:@"AP1706C008F008002O008001" parmas:nil];
  
    //使用手机号验证码登录获取token(下一步重置密码)
    [OCJHttp_authAPI ocjAuth_smscodeLoginWithMobile:self.ocjStr_mobile verifyCode:self.ocjTF_code.text purpose:OCJSMSPurpose_SetPassword thirdPartyInfo:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJResetPwdVC *resetPwdVC = [[OCJResetPwdVC alloc] init];
        resetPwdVC.ocjStr_mobile = self.ocjStr_mobile;
        [self ocj_pushVC:resetPwdVC];
    }];
    
}

//输入框内容有改变
- (void)ocj_textFieldValueChanged:(OCJBaseTextField *)codeTF {
    if (codeTF.text.length > 0) {
        self.ocjBtn_next.userInteractionEnabled = YES;
        self.ocjBtn_next.alpha = 1.0f;
    }else {
        self.ocjBtn_next.userInteractionEnabled = NO;
        self.ocjBtn_next.alpha = 0.2;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
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
