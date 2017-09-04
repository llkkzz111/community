//
//  OCJBindingPhoneNumberVC.m
//  OCJ
//
//  Created by LZB on 2017/4/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBindingPhoneNumberVC.h"
#import "OCJValidationBtn.h"
#import "OCJBaseButton+OCJExtension.h"
#import "WSHHRegex.h"
#import "OCJHttp_authAPI.h"

@interface OCJBindingPhoneNumberVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *ocjView_phoneNumber;
@property (nonatomic, strong) OCJBaseTextField *ocjTF_phoneNumber;///<输入手机号

@property (nonatomic, strong) UIView *ocjView_code;
@property (nonatomic, strong) OCJBaseTextField *ocjTF_code;///<短信验证码

@property (nonatomic, strong) UIView *ocjView_loginPwd;
@property (nonatomic, strong) OCJBaseTextField *ocjTF_password;///<设置登录密码

@property (nonatomic, strong) OCJValidationBtn *ocjBtn_sendCode;///<获取短信验证码

@property (nonatomic, strong) OCJBaseButton *ocjBtn_ciphertextPwd;///<明文密文

@property (nonatomic, assign) BOOL ocj_showPwd;///<是否明文

@property (nonatomic, strong) NSString *ocjStr_password;///<用来记录textfield输入内容

@property (nonatomic, strong) UIImageView *ocjImgView;

@property (nonatomic, strong) OCJBaseButton *ocjBtn_register;///<注册

@end

@implementation OCJBindingPhoneNumberVC

#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.ocjBtn_sendCode ocj_stopTimer];
}

#pragma mark - 私有方法区域
- (void)ocj_back{
    [super ocj_back];
  
    [self ocj_trackEventID:@"AP1706C013D003001C003001" parmas:nil];
}

- (void)ocj_setSelf{
  
  self.title = @"绑定手机号";
  
  self.ocjStr_trackPageID = @"AP1706C013";
  
  self.ocj_showPwd = YES;
  
  [self addViews];
}

#pragma mark - 添加视图
- (void)addViews {
    [self ocj_addPhoneNumberView];
    [self ocj_addCodeView];
    [self ocj_addLoginPasswordView];
    [self ocj_addConfirmBtn];
}

//请输入手机号
- (void)ocj_addPhoneNumberView {
    self.ocjView_phoneNumber = [[UIView alloc] init];
    self.ocjView_phoneNumber.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ocjView_phoneNumber];
    [self.ocjView_phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(self.view.mas_top).offset(34);
        make.height.mas_equalTo(@30);
    }];
    //tf
    self.ocjTF_phoneNumber = [[OCJBaseTextField alloc] init];
    self.ocjTF_phoneNumber.placeholder = @"请输入手机号";
    self.ocjTF_phoneNumber.font = [UIFont systemFontOfSize:15];
    self.ocjTF_phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ocjTF_phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.ocjTF_phoneNumber.tintColor = [UIColor redColor];
    [self.ocjTF_phoneNumber addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.ocjTF_phoneNumber.delegate = self;
    [self.ocjView_phoneNumber addSubview:self.ocjTF_phoneNumber];
    [self.ocjTF_phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.ocjView_phoneNumber);
        make.bottom.mas_equalTo(self.ocjView_phoneNumber.mas_bottom).offset(-1);
    }];
    
    
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [self.ocjView_phoneNumber addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.ocjView_phoneNumber);
        make.height.mas_equalTo(@0.5);
    }];
}

//请输入短信验证码
- (void)ocj_addCodeView {
    //获取短信验证码按钮
    [self ocj_addSendCodeBtn];
    [self.ocjBtn_sendCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjView_phoneNumber.mas_bottom).offset(34);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(90);
    }];
    
    self.ocjView_code = [[UIView alloc] init];
    self.ocjView_code.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ocjView_code];
    [self.ocjView_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.ocjBtn_sendCode.mas_left).offset(-10);
        make.top.mas_equalTo(self.ocjView_phoneNumber.mas_bottom).offset(34);
        make.height.mas_equalTo(@30);
    }];
    
    //tf
    self.ocjTF_code = [[OCJBaseTextField alloc] init];
    self.ocjTF_code.placeholder = @"请输入短信验证码";
    self.ocjTF_code.font = [UIFont systemFontOfSize:15];
    self.ocjTF_code.keyboardType = UIKeyboardTypeNumberPad;
    self.ocjTF_code.tintColor = [UIColor redColor];
    self.ocjTF_code.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.ocjTF_code addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.ocjView_code addSubview:self.ocjTF_code];
    [self.ocjTF_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.ocjView_code);
        make.bottom.mas_equalTo(self.ocjView_code.mas_bottom).offset(-1);
    }];
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [self.ocjView_code addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.ocjView_code);
        make.height.mas_equalTo(@0.5);
    }];
}

//设置登录密码
- (void)ocj_addLoginPasswordView {
    self.ocjView_loginPwd = [[UIView alloc] init];
    self.ocjView_loginPwd.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ocjView_loginPwd];
    [self.ocjView_loginPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(self.ocjView_code.mas_bottom).offset(34);
        make.height.mas_equalTo(@30);
    }];
    //添加显示密码按钮
    [self ocj_addCiphertextBtn];
    
    self.ocjTF_password = [[OCJBaseTextField alloc] init];
    self.ocjTF_password.placeholder = @"设置登录密码";
    self.ocjTF_password.font = [UIFont systemFontOfSize:15];
    self.ocjTF_password.secureTextEntry = NO;
    self.ocjTF_password.keyboardType = UIKeyboardTypeDefault;
    self.ocjTF_password.tintColor = [UIColor redColor];
    self.ocjTF_password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.ocjTF_password setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.ocjTF_password addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
//    self.ocjTF_password.delegate = self;
    [self.view addSubview:self.ocjTF_password];
    [self.ocjTF_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.ocjView_loginPwd);
        make.right.mas_equalTo(self.ocjBtn_ciphertextPwd.mas_left).offset(-3);
        make.bottom.mas_equalTo(self.ocjView_loginPwd.mas_bottom).offset(-1);
    }];
    
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [self.view addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.ocjView_loginPwd);
        make.height.mas_equalTo(@0.5);
    }];
}

//注册按钮
- (void)ocj_addConfirmBtn {
    self.ocjBtn_register = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 64 * 3 + 20 , SCREEN_WIDTH - 40, 45)];
    [self.ocjBtn_register setTitle:@"注册" forState:UIControlStateNormal];
    self.ocjBtn_register.alpha = 0.2;
    self.ocjBtn_register.userInteractionEnabled = NO;
    [self.ocjBtn_register setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.ocjBtn_register.layer.cornerRadius = 2;
    [self.ocjBtn_register ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6750"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromUpLeftToDownRight];
    [self.ocjBtn_register addTarget:self action:@selector(ocj_confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ocjBtn_register];
}

//添加显示(隐藏)密码按钮
- (void)ocj_addCiphertextBtn {
    self.ocjBtn_ciphertextPwd = [[OCJBaseButton alloc] init];
    self.ocjBtn_ciphertextPwd.backgroundColor = [UIColor whiteColor];
    [self.ocjBtn_ciphertextPwd addTarget:self action:@selector(ocj_ciphertextOrEnablePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_loginPwd addSubview:self.ocjBtn_ciphertextPwd];
    [self.ocjBtn_ciphertextPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjView_loginPwd);
        make.top.mas_equalTo(self.ocjView_loginPwd);
        make.width.height.mas_equalTo(@30);
    }];
    self.ocjImgView = [[UIImageView alloc] init];
    self.ocjImgView.image = [UIImage imageNamed:@"icon_pw_active"];
    [self.ocjBtn_ciphertextPwd addSubview:self.ocjImgView];
    [self.ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.ocjBtn_ciphertextPwd);
        make.width.mas_equalTo(@18);
        make.height.mas_equalTo(@12.5);
    }];
}

//添加获取验证码按钮
- (void)ocj_addSendCodeBtn {
    __weak OCJBindingPhoneNumberVC *weakself = self;
    self.ocjBtn_sendCode = [[OCJValidationBtn alloc]init];
    [self.view addSubview:self.ocjBtn_sendCode];
    
    
    self.ocjBtn_sendCode.ocjBlock_touchUpInside = ^{
        //点击获取验证码按钮
        if ([WSHHRegex wshh_isTelPhoneNumber:weakself.ocjTF_phoneNumber.text]) {
            [weakself ocj_trackEventID:@"AP1706C013F008001O008001" parmas:nil];
          
            [weakself.ocjBtn_sendCode ocj_startTimer];
            [OCJHttp_authAPI ocjAuth_SendSmscodeWithMobile:weakself.ocjTF_phoneNumber.text purpose:OCJSMSPurpose_TVUserBindingMobile internetID:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
                OCJAuthModel_SendSms* model = (OCJAuthModel_SendSms*)responseModel;
                weakself.ocjStr_internetID = model.ocjStr_internetID;
            }];
        }else {
            [WSHHAlert wshh_showHudWithTitle:@"请输入有效手机号" andHideDelay:2.0f];
        }
    };
    
}

#pragma mark - 实现方法
//点击显示(隐藏)密码按钮
- (void)ocj_ciphertextOrEnablePassword {
    self.ocj_showPwd = !self.ocj_showPwd;
    self.ocjStr_password = self.ocjTF_password.text;
    if (self.ocj_showPwd) {
//        self.ocjTF_password.text = @"";
        self.ocjTF_password.secureTextEntry = NO;
//        self.ocjTF_password.text = self.ocjStr_password;
        self.ocjImgView.image = [UIImage imageNamed:@"icon_pw_active"];
    }else{
        self.ocjTF_password.secureTextEntry = YES;
        /*
        if ([self.ocjTF_password isFirstResponder]) {
            [self.ocjTF_password insertText:self.ocjStr_password];
        }else {
            self.ocjTF_password.text = self.ocjStr_password;
        }
         */
        
        self.ocjImgView.image = [UIImage imageNamed:@"icon_pw_normal"];
    }
}

//点击确认按钮
- (void)ocj_confirmAction {
    if (![WSHHRegex wshh_isTelPhoneNumber:self.ocjTF_phoneNumber.text]) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入有效的手机号码" andHideDelay:2];
        return;
    }
    
    if (![WSHHRegex wshh_isSmsCode:self.ocjTF_code.text]) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入有效的验证码" andHideDelay:2];
        return;
    }
  
    [self ocj_trackEventID:@"AP1706C013F008002O008001" parmas:nil];
  
    [OCJHttp_authAPI ocjAuth_TVUserBindingMobile:self.ocjTF_phoneNumber.text verifyCode:self.ocjTF_code.text custName:self.ocjStr_custName custNo:self.ocjStr_custNo internetID:self.ocjStr_internetID password:self.ocjTF_password.text completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        if (self.navigationController.presentingViewController) {//进入app
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
}

- (void)ocj_textFieldValueChanged:(OCJBaseTextField *)currentTF {
    if ([self.ocjTF_phoneNumber.text length] > 0 && [self.ocjTF_code.text length] > 0 && [self.ocjTF_password.text length] > 0) {
        self.ocjBtn_register.alpha = 1.0f;
        self.ocjBtn_register.userInteractionEnabled = YES;
    }else {
        self.ocjBtn_register.alpha = 0.2;
        self.ocjBtn_register.userInteractionEnabled = NO;
    }
}


#pragma mark - 协议方法实现区域
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.ocjTF_password) {
        if (self.ocjStr_password.length > 0) {
            if (!self.ocj_showPwd) {
                [self.ocjTF_password insertText:self.ocjStr_password];
            }
        }
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.ocjTF_password) {
        self.ocjStr_password = self.ocjTF_password.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.ocjTF_phoneNumber) {
        if (str.length > 11) {
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
