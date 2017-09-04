//
//  JZRegisterViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "JZRegisterViewController.h"

#import "AFNetworking.h"
#import <JZLiveSDK/JZLiveSDK.h>
#import "JZGetCodeViewController.h"
#import "JZTools.h"
@interface JZRegisterViewController ()<UITextFieldDelegate>
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UITextField *nameField;//用户名
@property (nonatomic, weak) UITextField *telphoneField;//电话
@property (nonatomic, weak) UITextField *passwordField;//密码
@property (nonatomic, weak) UITextField *againPwField;//重复密码
@property (nonatomic, assign) BOOL isSuccessLog;//是否进行获取验证码
@end

@implementation JZRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"JZ_Btn_back@2x"] forState:0];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.bgView addGestureRecognizer:tapGestureRecognizer];
    
    UITextField *nameField = [[UITextField alloc] init];
    nameField.frame = CGRectMake(10, 20, SCREEN_WIDTH-20, 40);
    //uitextfeild左边添加空白区域
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(nameField.frame.origin.x,nameField.frame.origin.y,5.0, nameField.frame.size.height)];
    nameField.leftView = blankView;
    nameField.leftViewMode =UITextFieldViewModeAlways;
    nameField.layer.cornerRadius = 5;
    nameField.clipsToBounds = YES;
    nameField.backgroundColor = [UIColor whiteColor];
    nameField.placeholder = @"企业简称或对外宣传的名称";
    nameField.font = [UIFont systemFontOfSize:15];
    [self.bgView addSubview:nameField];
    _nameField = nameField;
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.frame = CGRectMake(10, CGRectGetMaxY(nameField.frame)+5, SCREEN_WIDTH-20, 20);
    promptLabel.font = [UIFont systemFontOfSize:15];
    promptLabel.text = @"2~20个字符,可以为字母,数字下划线和中文";
    promptLabel.textColor = RGB(255, 55, 243, 1);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:promptLabel];
    
    UITextField *telphoneField = [[UITextField alloc] init];
    telphoneField.keyboardType = UIKeyboardTypeNumberPad;
    telphoneField.frame = CGRectMake(10, CGRectGetMaxY(promptLabel.frame)+10, SCREEN_WIDTH-20, 40);
    //uitextfeild左边添加空白区域
    UIView *blankView2 = [[UIView alloc] initWithFrame:CGRectMake(telphoneField.frame.origin.x,telphoneField.frame.origin.y,5.0, telphoneField.frame.size.height)];
    telphoneField.leftView = blankView2;
    telphoneField.leftViewMode =UITextFieldViewModeAlways;
    telphoneField.layer.cornerRadius = 5;
    telphoneField.clipsToBounds = YES;
    telphoneField.backgroundColor = [UIColor whiteColor];
    telphoneField.placeholder = @"请输入手机号";
    telphoneField.font = [UIFont systemFontOfSize:15];
    [self.bgView addSubview:telphoneField];
    _telphoneField = telphoneField;
    
    UITextField *passwordField = [[UITextField alloc] init];
    passwordField.secureTextEntry = YES;
    passwordField.frame = CGRectMake(10, CGRectGetMaxY(telphoneField.frame)+20, SCREEN_WIDTH-20, 40);
    //uitextfeild左边添加空白区域
    UIView *blankView3 = [[UIView alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x,passwordField.frame.origin.y,5.0, passwordField.frame.size.height)];
    passwordField.leftView = blankView3;
    passwordField.leftViewMode =UITextFieldViewModeAlways;
    passwordField.layer.cornerRadius = 5;
    passwordField.clipsToBounds = YES;
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.placeholder = @"(6~16位字符(字母加数字),区分大小写)";
    passwordField.font = [UIFont systemFontOfSize:15];
    [self.bgView addSubview:passwordField];
    _passwordField = passwordField;
    
    UITextField *againPwField = [[UITextField alloc] init];
    againPwField.secureTextEntry = YES;
    againPwField.frame = CGRectMake(10, CGRectGetMaxY(passwordField.frame)+20, SCREEN_WIDTH-20, 40);
    //uitextfeild左边添加空白区域
    UIView *blankView4 = [[UIView alloc] initWithFrame:CGRectMake(againPwField.frame.origin.x,againPwField.frame.origin.y,5.0, againPwField.frame.size.height)];
    againPwField.leftView = blankView4;
    againPwField.leftViewMode =UITextFieldViewModeAlways;
    againPwField.layer.cornerRadius = 5;
    againPwField.clipsToBounds = YES;
    againPwField.backgroundColor = [UIColor whiteColor];
    againPwField.placeholder = @"重复输入密码";
    againPwField.font = [UIFont systemFontOfSize:15];
    [self.bgView addSubview:againPwField];
    _againPwField = againPwField;
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.frame = CGRectMake(SCREEN_WIDTH/6, CGRectGetMaxY(againPwField.frame)+50, SCREEN_WIDTH*2/3, 40);
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    [loginBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE52]];
    [loginBtn setTintColor:[UIColor whiteColor]];
    [loginBtn setBackgroundColor:MAINCOLOR];
    [loginBtn addTarget:self action:@selector(getCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:loginBtn];
    
    //设置代理
    _passwordField.delegate = self;
    _againPwField.delegate = self;
    _telphoneField.delegate = self;
    _nameField.delegate = self;
    NSString* deviceType = [UIDevice currentDevice].model;
    //NSLog(@"deviceType = %@", deviceType);
    if ([deviceType isEqualToString:@"iPad"]) {
        //添加键盘通知中心
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [_passwordField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingDidBegin];
        [_againPwField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingDidBegin];
    }else{
        nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _telphoneField.text=@"";
    _nameField.text= @"";
    _passwordField.text= @"";
    _againPwField.text= @"";
}
//返回
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCodeBtn:(UIButton *)sender {
    sender.enabled = NO;
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [JZTools showSimpleAlert:@"请检查网络链接" content:@"" curView:self];
            return ;
        }else if ([[JZTools convertNull:_nameField.text]isEqualToString:@""]) {
            [JZTools showSimpleAlert:@"请填写用户名" content:@"" curView:self];
        }else if ([[JZTools convertNull:_telphoneField.text]isEqualToString:@""]) {
            [JZTools showSimpleAlert:@"请填写手机号" content:@"" curView:self];
        }else if ([[JZTools convertNull:_passwordField.text]isEqualToString:@""]) {
            [JZTools showSimpleAlert:@"请填写密码" content:@"" curView:self];
        }else if ([[JZTools convertNull:_againPwField.text]isEqualToString:@""]) {
            [JZTools showSimpleAlert:@"请再次填写密码" content:@"" curView:self];
        }else if(![JZTools checkUserName:_nameField.text]){
            [JZTools showSimpleAlert:@"用户名格式不正确" content:@"" curView:self];
            _isSuccessLog = NO;
        }else if ([JZTools isMobileNumber:_telphoneField.text] == NO) {
            [JZTools showSimpleAlert:@"请正确填写手机号" content:@"" curView:self];
            _isSuccessLog = NO;
        }else if(![JZTools checkPassword:_passwordField.text]){
            [JZTools showSimpleAlert:@"密码格式不正确" content:@"" curView:self];
            _isSuccessLog = NO;
        }else if(![JZTools checkPassword:_againPwField.text]){
            [JZTools showSimpleAlert:@"再次填写的密码格式不正确" content:@"" curView:self];
            _isSuccessLog = NO;
        }else if (![_againPwField.text isEqualToString:_passwordField.text]) {
            [JZTools showSimpleAlert:@"两次密码不相同" content:@"" curView:self];
            _isSuccessLog = NO;
        }else if ( [_passwordField.text isEqualToString:_againPwField.text ] && ([JZTools isMobileNumber:_telphoneField.text]== YES )&& [JZTools checkUserName:_nameField.text] &&  [JZTools checkPassword:_passwordField.text] ) {
            JZCustomer *customer = [JZCustomer getUserdataInstance];
            customer.password = _passwordField.text;
            customer.mobile = _telphoneField.text;
            customer.nickname = _nameField.text;
            customer.iosEid = @"";
            NSLog(@"手机号 %@",customer.mobile);
            _isSuccessLog = YES;
        }
        if (_isSuccessLog == YES) {
            __weak typeof(self) block = self;
            [JZGeneralApi bindWithBlock:block.telphoneField.text getDetailBlock:^(BOOL flag, NSString *msg, NSError *error) {
                if (!flag  || error) {
                    [JZTools showMessage:msg];
                }else {
                    NSString *code = [JZCustomer getCode];
                    JZGetCodeViewController *vc =[[JZGetCodeViewController alloc]init];
                    vc.code = code;
                    [block.navigationController pushViewController:vc animated:YES];
                }
                sender.enabled = YES;
            }];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
//点击view空白处取消键盘
- (void)keyboardHide {
    [self.view endEditing:YES];
}

/**
 *  隐藏键盘通知的响应事件
 */
- (void)keyboardWillHide:(NSNotification *)info {
    
    NSDictionary *dict = info.userInfo;
    double duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [dict[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.bgView.transform = CGAffineTransformIdentity;
    } completion:nil];
}
//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textFiledDidChange:(UITextField *)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -150);
        self.bgView.transform = transform;
    }];
}

@end
