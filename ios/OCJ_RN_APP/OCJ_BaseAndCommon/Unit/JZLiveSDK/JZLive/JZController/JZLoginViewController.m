//
//  JZLoginViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "JZLoginViewController.h"

#import "AFNetworking.h"
#import "JZFindPasswordViewController.h"
#import "JZRegisterViewController.h"
#import <JZLiveSDK/JZLiveSDK.h>
#import "JZTools.h"
@interface JZLoginViewController () <UITextFieldDelegate>
@property (nonatomic, weak) UITextField *phoneNumberField;//手机号
@property (nonatomic, weak) UITextField *passwordField;//密码
@property (nonatomic, strong) JZCustomer *customer;
@end
@implementation JZLoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"JZ_Btn_back@2x"] forState:0];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITextField *phoneNumberField = [[UITextField alloc] init];
    phoneNumberField.frame = CGRectMake(10, 50, SCREEN_WIDTH-20, 40);
    //uitextfeild左边添加空白区域
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(phoneNumberField.frame.origin.x,phoneNumberField.frame.origin.y,5.0, phoneNumberField.frame.size.height)];
    phoneNumberField.leftView = blankView;
    phoneNumberField.leftViewMode =UITextFieldViewModeAlways;
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.layer.cornerRadius = 5;
    phoneNumberField.clipsToBounds = YES;
    phoneNumberField.backgroundColor = [UIColor whiteColor];
    phoneNumberField.placeholder = @"请输入手机号";
    phoneNumberField.font = [UIFont systemFontOfSize:15];
    //输入框中输入登陆的上次手机号
    NSString* dir = [JZTools createDirectory:@"userinfo_mobile"];
    NSString* filename = @"mobile";
    NSString* content=[JZTools getUserInfo:dir fileName:filename];
    if (![content isEqualToString:@""]){
        phoneNumberField.text = content;
    }
    [self.view addSubview:phoneNumberField];
    _phoneNumberField = phoneNumberField;
    
    UITextField *passwordField = [[UITextField alloc] init];
    passwordField.secureTextEntry = YES;
    passwordField.frame = CGRectMake(10, CGRectGetMaxY(phoneNumberField.frame)+20, SCREEN_WIDTH-20, 40);
    //uitextfeild左边添加空白区域
    UIView *blankView2 = [[UIView alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x,passwordField.frame.origin.y,5.0, passwordField.frame.size.height)];
    passwordField.leftView = blankView2;
    passwordField.leftViewMode =UITextFieldViewModeAlways;
    passwordField.layer.cornerRadius = 5;
    passwordField.clipsToBounds = YES;
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.placeholder = @"请输入密码";
    passwordField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:passwordField];
    _passwordField = passwordField;
    //设置代理
    _phoneNumberField.delegate = self;
    _passwordField.delegate = self;
    
    UIButton *forgetWordBtn = [[UIButton alloc] init];
    forgetWordBtn.frame = CGRectMake(SCREEN_WIDTH-120, CGRectGetMaxY(passwordField.frame)+10, 110, 30);
    [forgetWordBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetWordBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [forgetWordBtn setTitleColor:RGB(255, 55, 243, 1) forState:UIControlStateNormal];
    [forgetWordBtn addTarget:self action:@selector(forgetWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetWordBtn];
    
    UIButton *registerBtn = [[UIButton alloc] init];
    registerBtn.frame = CGRectMake(10, CGRectGetMaxY(passwordField.frame)+60, (SCREEN_WIDTH-70)/2, 50);
    registerBtn.backgroundColor = RGB(107,223,60,1);
    registerBtn.layer.cornerRadius = 5;
    registerBtn.clipsToBounds = YES;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE52]];
    [registerBtn setTintColor:[UIColor whiteColor]];
    [registerBtn addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.frame = CGRectMake(CGRectGetMaxX(registerBtn.frame)+50, CGRectGetMaxY(passwordField.frame)+60, (SCREEN_WIDTH-70)/2, 50);
    loginBtn.backgroundColor = MAINCOLOR;
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE52]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
//返回
-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
//点击view空白处取消键盘
- (void)keyboardHide {
    [self.view endEditing:YES];
}
//忘记密码
- (void)forgetWord {
    JZFindPasswordViewController *vc = [[JZFindPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//注册账号
- (void)registerAccount {
    JZRegisterViewController *vc = [[JZRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//登陆
- (void)loginAccount:(UIButton *)sender {
    sender.enabled = NO;
    if ([[JZTools convertNull:_phoneNumberField.text]isEqualToString:@""]) {
        [JZTools showSimpleAlert:@"请填写手机号" content:@"" curView:self];
        sender.enabled = YES;
    }else if ([JZTools isMobileNumber:_phoneNumberField.text] == NO) {
        [JZTools showSimpleAlert:@"请正确填写手机号" content:@"" curView:self];
        sender.enabled = YES;
    }else if ([[JZTools convertNull:_passwordField.text]isEqualToString:@""]) {
        [JZTools showSimpleAlert:@"请填写密码" content:@"" curView:self];
        sender.enabled = YES;
    }else{
        [[AFNetworkReachabilityManager sharedManager]startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                [JZTools showMessage:@"请检查网络链接"];
                sender.enabled = YES;
            } else {
                _customer = [[JZCustomer alloc]init];
                _customer.mobile = _phoneNumberField.text;
                _customer.password = _passwordField.text;
                _customer.iosEid = @"";
                //NSLog(@" 登录 %@ %@ %@",_customer.mobile,_customer.password,_customer.iosEid);
                [JZGeneralApi loginWithBlock:_customer getDetailBlock:^(NSObject *user, NSError *error) {
                    if (error) {
                        [JZTools showMessage:@"密码或用户名不正确"];
                        //NSLog(@"error %@ user = %@",error,user);
                        if (_redirectBlock) {
                            _redirectBlock(NO, error);
                        }
                    } else {
                        [JZGeneralApi setLoginStatus:1];
                        NSNotification *notification =[NSNotification notificationWithName:@"LoginAccount" object:nil userInfo:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        //更新用户信息到数据库中
                        NSString* dir1 = [JZTools createDirectory:@"userinfo_cache"];
                        NSString* filename1 = @"myinfo";
                        NSString *accountCategory = @"phone";
                        NSString* content1 = [NSString stringWithFormat:@"%@;%@;%@", _customer.mobile,_customer.password,accountCategory];
                        [JZTools saveUserInfo:dir1 userInfo:content1 fileName:filename1];
                        
                        //清除上次记录的手机号
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSString* dir = [JZTools createDirectory:@"userinfo_mobile"];
                        NSString* filename = @"mobile";
                        NSString *fileFullPath = [NSString stringWithFormat:@"%@/%@", dir, filename];
                        NSError *err;
                        [fileManager removeItemAtPath:fileFullPath error:&err];
                        
                        //存入当前登陆成功的手机号
                        NSString* content = [NSString stringWithFormat:@"%@",_customer.mobile];
                        [JZTools saveUserInfo:dir userInfo:content fileName:filename];
                        [JZTools getUserInfo:dir fileName:filename];
                        
                        if (_redirectBlock) {
                            _redirectBlock(YES, nil);
                        }
                    }
                    sender.enabled = YES;
                }];
            }
        }];
    }
}

//当用户按下return键或者按回车键，keyboard消失
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
