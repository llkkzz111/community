//
//  JZFindPasswordViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "JZFindPasswordViewController.h"
//#import "JZConstants.h"
#import "AFNetworking.h"
#import <JZLiveSDK/JZLiveSDK.h>
#import "JZTools.h"
#import "JZCountDownButton.h"
@interface JZFindPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UITextField *phoneField;
@property (nonatomic, weak) UITextField *codeField;
@property (nonatomic, weak) UITextField *newlyPWField;
@property (nonatomic, weak) UITextField *againPwField;
@property (nonatomic, weak) JZCountDownButton *getCodeBtn;//获取验证码
@end

@implementation JZFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"JZ_Btn_back@2x"] forState:0];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    //背景view
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [bgView addGestureRecognizer:tapGestureRecognizer];
    [self.view addSubview:bgView];
    self.bgView = bgView;
    //手机号view
    UIView *phoneBg = [[UIView alloc] init];
    phoneBg.frame = CGRectMake(10, 20, SCREEN_WIDTH-20, 40);
    phoneBg.backgroundColor =  [UIColor whiteColor];
    phoneBg.layer.cornerRadius = 5;
    phoneBg.layer.masksToBounds = YES;
    [bgView addSubview:phoneBg];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(0, 0, 100, 40);
    phoneLabel.backgroundColor = [UIColor clearColor];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.textColor = [UIColor blackColor];
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.text = @"手机号";
    [phoneBg addSubview:phoneLabel];
    
    UITextField *phoneField = [[UITextField alloc] init];
    phoneField.frame = CGRectMake(CGRectGetMaxX(phoneLabel.frame), 0, SCREEN_WIDTH-210, 40);
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    phoneField.backgroundColor = [UIColor clearColor];
    phoneField.placeholder = @"输入手机号";
    phoneField.font = [UIFont systemFontOfSize:15];
    [phoneBg addSubview:phoneField];
    _phoneField = phoneField;
    
    JZCountDownButton *getCodeBtn = [[JZCountDownButton alloc] init];
    getCodeBtn.frame = CGRectMake(SCREEN_WIDTH-110, 5, 90, 30);
    getCodeBtn.backgroundColor = MAINCOLOR;
    getCodeBtn.layer.cornerRadius = 3;
    getCodeBtn.clipsToBounds = YES;
    getCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [getCodeBtn.titleLabel setFont: [UIFont systemFontOfSize:16]];
    [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBg addSubview:getCodeBtn];
    _getCodeBtn = getCodeBtn;
    //验证码view
    UIView *codeView = [[UIView alloc] init];
    codeView.frame = CGRectMake(10, CGRectGetMaxY(phoneBg.frame)+20, SCREEN_WIDTH-20, 40);
    codeView.backgroundColor =  [UIColor whiteColor];
    codeView.layer.cornerRadius = 5;
    codeView.layer.masksToBounds = YES;
    [bgView addSubview:codeView];
    
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.frame = CGRectMake(0, 0, 100, 40);
    codeLabel.backgroundColor = [UIColor clearColor];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.textColor = [UIColor blackColor];
    codeLabel.font = [UIFont systemFontOfSize:15];
    codeLabel.text = @"验证码";
    [codeView addSubview:codeLabel];
    
    UITextField *codeField = [[UITextField alloc] init];
    codeField.frame = CGRectMake(CGRectGetMaxX(phoneLabel.frame), 0, SCREEN_WIDTH-220, 40);
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    codeField.backgroundColor = [UIColor clearColor];
    codeField.placeholder = @"输入验证码";
    codeField.font = [UIFont systemFontOfSize:15];
    [codeView addSubview:codeField];
    _codeField = codeField;
    
    //新密码view
    UIView *newlyPWView = [[UIView alloc] init];
    newlyPWView.frame = CGRectMake(10, CGRectGetMaxY(codeView.frame)+20, SCREEN_WIDTH-20, 40);
    newlyPWView.backgroundColor =  [UIColor whiteColor];
    newlyPWView.layer.cornerRadius = 5;
    newlyPWView.layer.masksToBounds = YES;
    [bgView addSubview:newlyPWView];
    
    UILabel *newlyPWLabel = [[UILabel alloc] init];
    newlyPWLabel.frame = CGRectMake(0, 0, 100, 40);
    newlyPWLabel.backgroundColor = [UIColor clearColor];
    newlyPWLabel.textAlignment = NSTextAlignmentCenter;
    newlyPWLabel.textColor = [UIColor blackColor];
    newlyPWLabel.font = [UIFont systemFontOfSize:15];
    newlyPWLabel.text = @"新密码";
    [newlyPWView addSubview:newlyPWLabel];
    
    UITextField *newlyPWField = [[UITextField alloc] init];
    newlyPWField.frame = CGRectMake(CGRectGetMaxX(newlyPWLabel.frame), 0, SCREEN_WIDTH-120, 40);
    newlyPWField.secureTextEntry = YES;
    newlyPWField.backgroundColor = [UIColor clearColor];
    newlyPWField.placeholder = @"输入新密码";
    newlyPWField.font = [UIFont systemFontOfSize:15];
    [newlyPWView addSubview:newlyPWField];
    _newlyPWField = newlyPWField;
    
    //确认新密码view
    UIView *againPwView = [[UIView alloc] init];
    againPwView.frame = CGRectMake(10, CGRectGetMaxY(newlyPWView.frame)+20, SCREEN_WIDTH-20, 40);
    againPwView.backgroundColor =  [UIColor whiteColor];
    againPwView.layer.cornerRadius = 5;
    againPwView.layer.masksToBounds = YES;
    [bgView addSubview:againPwView];
    
    UILabel *againPwLabel = [[UILabel alloc] init];
    againPwLabel.frame = CGRectMake(0, 0, 100, 40);
    againPwLabel.backgroundColor = [UIColor clearColor];
    againPwLabel.textAlignment = NSTextAlignmentCenter;
    againPwLabel.textColor = [UIColor blackColor];
    againPwLabel.font = [UIFont systemFontOfSize:15];
    againPwLabel.text = @"确认新密码";
    [againPwView addSubview:againPwLabel];
    
    UITextField *againPwField = [[UITextField alloc] init];
    againPwField.frame = CGRectMake(CGRectGetMaxX(againPwLabel.frame), 0, SCREEN_WIDTH-120, 40);
    againPwField.secureTextEntry = YES;
    againPwField.backgroundColor = [UIColor clearColor];
    againPwField.placeholder = @"再一次输入新密码";
    againPwField.font = [UIFont systemFontOfSize:15];
    [againPwView addSubview:againPwField];
    _againPwField = againPwField;
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.frame = CGRectMake(10, CGRectGetMaxY(againPwView.frame)+10, SCREEN_WIDTH-20, 20);
    promptLabel.text = @"6~16位字符(字母加数字),区分大小写";
    promptLabel.textColor = RGB(255, 55, 243, 1);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:promptLabel];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    confirmBtn.frame = CGRectMake(10, CGRectGetMaxY(promptLabel.frame)+20, SCREEN_WIDTH-20, 40);
    confirmBtn.backgroundColor = MAINCOLOR;
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.clipsToBounds = YES;
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmBtn.titleLabel setFont: [UIFont systemFontOfSize:FONTSIZE52]];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:confirmBtn];
    //设置代理
    _phoneField.delegate = self;
    _codeField.delegate = self;
    _newlyPWField.delegate = self;
    _againPwField.delegate = self;
    NSString* deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) {
        //添加键盘通知中心
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [_newlyPWField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingDidBegin];
        [_againPwField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingDidBegin];
    }else{
        nil;
    }
}
//返回
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
//获取验证码
- (void)getCode:(UIButton *)sender {
    sender.enabled = NO;
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [JZTools showMessage:@"请检查网络链接"];
        }else if ([JZTools isMobileNumber:_phoneField.text] == NO) {
            [JZTools showMessage:@"请正确输入手机号"];
        }else if (![[JZTools convertNull:_phoneField.text]isEqualToString:@""] && [JZTools isMobileNumber:_phoneField.text] == YES) {
            __weak typeof(self) block = self;
            [JZGeneralApi getVerifiedCodeBlock:_phoneField.text getDetailBlock:^(BOOL flag, NSString *msg, NSError *error) {
                //  NSLog(@"msg = %@ flag %d",msg ,flag);
                if (flag) {
                    [block.getCodeBtn startWithTime:59 title:@"重新获取" countDownTitle:@" s" mainColor:MAINCOLOR countColor:[UIColor colorWithRed:0.7258 green:0.7181 blue:0.7335 alpha:1.0]];
                    [JZTools showMessage:@"短信已发出"];
                    //NSLog(@"验证码  %@ ",[Customer getCode]);
                }else {
                    [JZTools showSimpleAlert:msg content:@"" curView:self];
                }
                sender.enabled = YES;
            }];
        }
        if (!sender.enabled) {
            sender.enabled = YES;
        }
    }];
}
//确认
- (void)confirm:(UIButton *)sender {
    sender.enabled = NO;
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [JZTools showSimpleAlert:@"请检查网络链接" content:@"" curView:self];
            return ;
        }else if ([[JZTools convertNull:_phoneField.text]isEqualToString:@""]){
            [JZTools showSimpleAlert:@"请填写手机号" content:@"" curView:self];
        }else if ([JZTools isMobileNumber:_phoneField.text] == NO){
            [JZTools showSimpleAlert:@"请填写正确的手机号" content:@"" curView:self];
        }else if ([[JZTools convertNull:_codeField.text]isEqualToString:@""]){
            [JZTools showSimpleAlert:@"请填写正确的验证码" content:@"" curView:self];
        }else if (![_codeField.text isEqualToString:[JZCustomer getCode]]){
            [JZTools showSimpleAlert:@"请填写正确的验证码" content:@"" curView:self];
        }else if ([[JZTools convertNull:_newlyPWField.text]isEqualToString:@""]){
            [JZTools showSimpleAlert:@"请填写新密码" content:@"" curView:self];
        }else if (![JZTools checkPassword:_newlyPWField.text]){
            [JZTools showSimpleAlert:@"密码格式不正确" content:@"" curView:self];
        }else if ([[JZTools convertNull:_againPwField.text]isEqualToString:@""]){
            [JZTools showSimpleAlert:@"请填写确认新密码" content:@"" curView:self];
        }else if (![JZTools checkPassword:_againPwField.text]){
            [JZTools showSimpleAlert:@"确认新密码格式不正确" content:@"" curView:self];
        }else if (![_newlyPWField.text isEqualToString:_againPwField.text]) {
            [JZTools showSimpleAlert:@"两次输入的密码不相同" content:@"" curView:self];
        }else if (![[JZTools convertNull:_phoneField.text]isEqualToString:@""] && ![_codeField.text isEqualToString:@""] && [_codeField.text isEqualToString:[JZCustomer getCode]] && [_newlyPWField.text isEqualToString:_againPwField.text] && ![[JZTools convertNull:_againPwField.text] isEqualToString:@""]&& ![[JZTools convertNull:_newlyPWField.text] isEqualToString:@""]&& [JZTools checkPassword:_newlyPWField.text]) {
            JZCustomer *user = [[JZCustomer alloc] init];
            user.mobile = _phoneField.text;
            user.password = _newlyPWField.text;
            user.iosEid = @"";
            __weak typeof(self) block = self;
            [JZGeneralApi resetPwdBlock:user getDetailBlock:^(BOOL flag, NSString *msg, NSError *error) {
                if (flag) {
                    [block.navigationController popViewControllerAnimated:YES];
                    [JZTools showMessage:@"重置密码成功"];
                }else {
                    [JZTools showMessage:msg];
                }
                sender.enabled = YES;
            }];
        }
        else {
            [JZTools showMessage:@"请正确填写信息"];
        }
        if (!sender.enabled) {
            sender.enabled = YES;
        }
    }];
}
/**
 *  当用户按下return键或者按回车键，keyboard消失
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
/**
 *  点击view空白处取消键盘
 */
- (void)keyboardHide:(UITapGestureRecognizer*)tap {
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
/**
 *  开始编辑输入框的时候，软键盘出现，执行此事件
 */
- (void)textFiledDidChange:(UITextField *)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -132);
        self.bgView.transform = transform;
    }];
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
