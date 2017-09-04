//
//  JZGetCodeViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "JZGetCodeViewController.h"

#import <JZLiveSDK/JZLiveSDK.h>
#import "AFNetworking.h"
#import "JZTools.h"
@interface JZGetCodeViewController ()<UITextFieldDelegate>
@property (nonatomic, weak) UITextField *codeField;
@property (nonatomic, weak) UILabel *getCodeTimeLabel;//获取时间
@property (nonatomic, strong) JZCustomer *customer;
@property (nonatomic, assign) NSInteger surplusSecond;//间隔时间
@end

@implementation JZGetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"获取验证码";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"JZ_Btn_back@2x"] forState:0];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UILabel *phoneNumLabel = [[UILabel alloc] init];
    phoneNumLabel.frame = CGRectMake(10, 20, SCREEN_WIDTH-20, 20);
    phoneNumLabel.backgroundColor = [UIColor clearColor];
    phoneNumLabel.textAlignment = NSTextAlignmentCenter;
    phoneNumLabel.textColor = RGB(255, 55, 243, 1);
    phoneNumLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:phoneNumLabel];
    
    UITextField *codeField = [[UITextField alloc] init];
    codeField.frame = CGRectMake(10, CGRectGetMaxY(phoneNumLabel.frame)+20, SCREEN_WIDTH-20, 50);
    //uitextfeild左边添加空白区域
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(codeField.frame.origin.x,codeField.frame.origin.y,5.0, codeField.frame.size.height)];
    codeField.leftView = blankView;
    codeField.leftViewMode =UITextFieldViewModeAlways;
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    codeField.backgroundColor = [UIColor whiteColor];
    codeField.placeholder = @"输入验证码";
    codeField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:codeField];
    _codeField = codeField;
    
    UILabel *getCodeTimeLabel = [[UILabel alloc] init];
    getCodeTimeLabel.frame = CGRectMake(10, CGRectGetMaxY(codeField.frame)+5, SCREEN_WIDTH-20, 20);
    getCodeTimeLabel.backgroundColor = [UIColor clearColor];
    getCodeTimeLabel.textAlignment = NSTextAlignmentCenter;
    getCodeTimeLabel.textColor = background01GRAY;
    getCodeTimeLabel.font = [UIFont systemFontOfSize:15];
    getCodeTimeLabel.text = @"大约60秒收到验证码";
    [self.view addSubview:getCodeTimeLabel];
    _getCodeTimeLabel = getCodeTimeLabel;
    
    UIButton *completeResigerBtn = [[UIButton alloc] init];
    completeResigerBtn.frame = CGRectMake(10, CGRectGetMaxY(getCodeTimeLabel.frame)+10, SCREEN_WIDTH-20, 50);
    completeResigerBtn.backgroundColor = MAINCOLOR;
    completeResigerBtn.layer.cornerRadius = 5;
    completeResigerBtn.clipsToBounds = YES;
    completeResigerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [completeResigerBtn.titleLabel setFont: [UIFont systemFontOfSize:FONTSIZE52]];
    [completeResigerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeResigerBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    [completeResigerBtn addTarget:self action:@selector(completeRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeResigerBtn];
    
    _customer = [JZCustomer getUserdataInstance];
    NSString *str = @"验证码将发送至手机:";
    phoneNumLabel.text = [str stringByAppendingString:_customer.mobile];
    _surplusSecond = 60;
    [self countDown];
    _codeField.delegate = self;
}
//返回
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//倒计时label
- (void)countDown {
    //全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //主队列；属于串行队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{ //计时器事件处理器
        NSLog(@"Event Handler");
        if (_surplusSecond <= 0) {
            dispatch_source_cancel(timer); //取消定时循环计时器；使得句柄被调用，即事件被执行
            dispatch_async(mainQueue, ^{
                
                _getCodeTimeLabel.text = @"您的信息填写不正确,请返回上一页重新填写";
                _surplusSecond = 60;
            });
        } else {
            _surplusSecond--;
            dispatch_async(mainQueue, ^{
                NSString *btnInfo = [NSString stringWithFormat:@"%ld秒", (long)(_surplusSecond + 1)];
                
                _getCodeTimeLabel.text = [[@"大约" stringByAppendingString:btnInfo] stringByAppendingString:@"后收到验证码"];
            });
        }
    });
    dispatch_source_set_cancel_handler(timer, ^{ //计时器取消处理器；调用 dispatch_source_cancel 时执行
        NSLog(@"Cancel Handler");
    });
    dispatch_resume(timer);  //恢复定时循环计时器；Dispatch Source 创建完后默认状态是挂起的，需要主动恢复，否则事件不会被传递，也不会被执行
}

//完成注册
- (void)completeRegister:(UIButton *)sender {
    sender.enabled = NO;
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [JZTools showMessage:@"请检查网络链接"];
            sender.enabled = YES;
        } else {
            if (![_code isEqualToString:_codeField.text]) {
                [JZTools showMessage:@"验证码不正确"];
                sender.enabled = YES;
            } else {
                JZCustomer *cust = [JZCustomer getUserdataInstance];
                __weak typeof(self) block = self;
                [JZGeneralApi regWithBlock:cust getDetailBlock:^(JZCustomer *user, NSError *error) {
                    if (error|| user == nil) {
                        [JZTools showMessage:@"验证码不正确"];
                    }
                    else {
                        [JZGeneralApi setLoginStatus:1];
                        [JZTools showMessage:@"注册成功"];
                        [[NSUserDefaults standardUserDefaults]setObject:_customer.nickname forKey:@"nickname"];
                        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
                        [block.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
                        //[block.navigationController popToRootViewControllerAnimated:YES];
                    }
                    sender.enabled = YES;
                }];
            }
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

@end
