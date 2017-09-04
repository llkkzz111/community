//
//  OCJSetCellPhonePasswordVC.m
//  OCJ
//
//  Created by LZB on 2017/4/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSetCellPhonePasswordVC.h"
#import "OCJBaseButton+OCJExtension.h"
#import "OCJHttp_authAPI.h"

@interface OCJSetCellPhonePasswordVC ()<UITextFieldDelegate>

@property (nonatomic, strong) OCJBaseTextField *ocjTF_password;///<设置密码

@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;///<登录

@property (nonatomic, strong) OCJBaseButton *ocjBtn_ciphertextPwd;///<明文密文

@property (nonatomic, assign) BOOL ocj_showPwd;///<是否明文

@property (nonatomic, strong) NSString *ocjStr_password;///<用来记录textfield输入内容

@property (nonatomic, strong) UIImageView *ocjImgView;

@end

@implementation OCJSetCellPhonePasswordVC

#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
    
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf {
    self.title  = @"设置登录密码";
    
    self.ocj_showPwd = YES;
    
    [self ocj_addCiphertextBtn];
    [self ocj_addTextField];
    [self ocj_addLoginButton];
}

//添加显示(隐藏)密码按钮
- (void)ocj_addCiphertextBtn {
    self.ocjBtn_ciphertextPwd = [[OCJBaseButton alloc] init];
    self.ocjBtn_ciphertextPwd.backgroundColor = [UIColor whiteColor];
    [self.ocjBtn_ciphertextPwd addTarget:self action:@selector(ocj_ciphertextOrEnablePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ocjBtn_ciphertextPwd];
    [self.ocjBtn_ciphertextPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(self.view.mas_top).offset(30);
        make.width.height.mas_equalTo(@30);
    }];
    self.ocjImgView = [[UIImageView alloc] init];
    self.ocjImgView.image = [UIImage imageNamed:@"icon_pw_active"];
    [self.ocjBtn_ciphertextPwd addSubview:self.ocjImgView];
    [self.ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjBtn_ciphertextPwd);
        make.bottom.mas_equalTo(self.ocjBtn_ciphertextPwd.mas_bottom).offset(-4);
        make.width.mas_equalTo(@18);
        make.height.mas_equalTo(@12.5);
    }];
}

//添加密码输入框
- (void)ocj_addTextField {
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
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.ocjBtn_ciphertextPwd.mas_left).offset(-3);
        make.top.mas_equalTo(self.view.mas_top).offset(34);
        make.height.mas_equalTo(@30);
    }];
    
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [self.view addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(self.ocjTF_password.mas_bottom).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
}

//添加确认按钮
- (void)ocj_addLoginButton {
    self.ocjBtn_confirm = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 64 + 20, SCREEN_WIDTH - 40, 45)];
    [self.ocjBtn_confirm setTitle:@"确认" forState:UIControlStateNormal];
    [self.ocjBtn_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.ocjBtn_confirm.alpha = 0.2;
    self.ocjBtn_confirm.userInteractionEnabled = NO;
    self.ocjBtn_confirm.layer.cornerRadius = 2;
    [self.ocjBtn_confirm ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6750"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [self.ocjBtn_confirm addTarget:self action:@selector(ocj_confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ocjBtn_confirm];
}

//点击确认按钮
- (void)ocj_confirmAction {
    if (self.ocjTF_password.text.length==0) {
        [WSHHAlert wshh_showHudWithTitle:@"请设置您的登录密码" andHideDelay:2];
        return;
    }
    
    [OCJHttp_authAPI ocjAuth_setPasswordNewPassword:self.ocjTF_password.text oldPassword:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
      if (self.navigationController.presentingViewController) {//进入app
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
      }
    }];
}

//点击显示(隐藏)密码
- (void)ocj_ciphertextOrEnablePassword {
    self.ocj_showPwd = !self.ocj_showPwd;
    self.ocjStr_password = self.ocjTF_password.text;
    if (self.ocj_showPwd) {
        self.ocjTF_password.secureTextEntry = NO;
        self.ocjImgView.image = [UIImage imageNamed:@"icon_pw_active"];
    }else{
        self.ocjTF_password.secureTextEntry = YES;
        self.ocjImgView.image = [UIImage imageNamed:@"icon_pw_normal"];
    }
}

- (void)ocj_textFieldValueChanged:(OCJBaseTextField *)currentTF {
    if ([self.ocjTF_password.text length] > 0) {
        self.ocjBtn_confirm.alpha = 1.0f;
        self.ocjBtn_confirm.userInteractionEnabled = YES;
    }else {
        self.ocjBtn_confirm.alpha = 0.2;
        self.ocjBtn_confirm.userInteractionEnabled = NO;
    }
}

#pragma mark - 协议方法实现区域

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
