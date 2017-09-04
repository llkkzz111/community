//
//  OCJBindingModileVC.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBindingModileVC.h"
#import "OCJValidationBtn.h"
#import "OCJBaseButton+OCJExtension.h"
#import "WSHHRegex.h"
#import "OCJHttp_authAPI.h"

@interface OCJBindingModileVC ()

@property (nonatomic, strong) UIView *ocjView_phoneNumber;
@property (nonatomic, strong) OCJBaseTextField *ocjTF_phoneNumber;///<输入手机号

@property (nonatomic, strong) UIView *ocjView_code;
@property (nonatomic, strong) OCJBaseTextField *ocjTF_code;///<短信验证码

@property (nonatomic, strong) OCJValidationBtn *ocjBtn_sendCode;///<获取短信验证码

@property (nonatomic, strong) UIImageView *ocjImgView;

@property (nonatomic, strong) OCJBaseButton *ocjBtn_register;///<注册


@end

@implementation OCJBindingModileVC

#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
//    [OcjStoreDataAnalytics trackPageBegin:@""];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.ocjBtn_sendCode ocj_stopTimer];
//    [OcjStoreDataAnalytics trackPageEnd:@""];
}

#pragma mark - 私有方法区域
#pragma mark - 添加视图
- (void)ocj_setSelf{
    
    self.title = @"绑定手机号";

    [self addViews];
}

- (void)addViews {
    [self ocj_addPhoneNumberView];
    [self ocj_addCodeView];
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

//注册按钮
- (void)ocj_addConfirmBtn {
    self.ocjBtn_register = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 64 * 2 + 20 , SCREEN_WIDTH - 40, 45)];
    [self.ocjBtn_register setTitle:@"确 定" forState:UIControlStateNormal];
    self.ocjBtn_register.alpha = 0.2;
    self.ocjBtn_register.userInteractionEnabled = NO;
    [self.ocjBtn_register setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.ocjBtn_register.layer.cornerRadius = 2;
    [self.ocjBtn_register ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6750"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromUpLeftToDownRight];
    [self.ocjBtn_register addTarget:self action:@selector(ocj_confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ocjBtn_register];
}

//添加获取验证码按钮
- (void)ocj_addSendCodeBtn {
    __weak OCJBindingModileVC *weakSelf = self;
    self.ocjBtn_sendCode = [[OCJValidationBtn alloc]init];
    self.ocjBtn_sendCode.ocjBlock_touchUpInside = ^{
        //点击获取验证码按钮
        if ([WSHHRegex wshh_isTelPhoneNumber:weakSelf.ocjTF_phoneNumber.text]) {
            [weakSelf.ocjBtn_sendCode ocj_startTimer];
            [OCJHttp_authAPI ocjAuth_SendSmscodeWithMobile:weakSelf.ocjTF_phoneNumber.text purpose:OCJSMSPurpose_EmailUserBindingMobile internetID:weakSelf.ocjStr_internetID completionHandler:^(OCJBaseResponceModel *responseModel) {
                
            }];
        }else {
            [WSHHAlert wshh_showHudWithTitle:@"请输入有效手机号" andHideDelay:2.0f];
        }
    };
    [self.view addSubview:self.ocjBtn_sendCode];
}

#pragma mark - 实现方法
//点击确认按钮
- (void)ocj_confirmAction {
    
    [OCJHttp_authAPI ocjAuth_bindingMobileWithMobile:self.ocjTF_phoneNumber.text verifyCode:self.ocjTF_code.text completionHandler:^(OCJBaseResponceModel *responseModel) {
        [OCJProgressHUD ocj_showHudWithTitle:@"手机绑定成功" andHideDelay:2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self ocj_back];
        });
    }];
}

- (void)ocj_textFieldValueChanged:(OCJBaseTextField *)currentTF {
    if ([self.ocjTF_phoneNumber.text length] > 0 && [self.ocjTF_code.text length] > 0) {
        self.ocjBtn_register.alpha = 1.0f;
        self.ocjBtn_register.userInteractionEnabled = YES;
    }else {
        self.ocjBtn_register.alpha = 0.2;
        self.ocjBtn_register.userInteractionEnabled = NO;
    }
}


#pragma mark - 协议方法实现区域
#pragma mark - UITextFieldDelegate
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



@end
