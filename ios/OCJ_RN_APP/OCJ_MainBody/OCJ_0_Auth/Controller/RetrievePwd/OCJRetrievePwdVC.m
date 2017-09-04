//
//  OCJRetrievePwdVC.m
//  OCJ
//
//  Created by zhangchengcai on 2017/4/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRetrievePwdVC.h"
#import "OCJQuickRegisterVC.h"
#import "TPKeyboardAvoidingTableView.h"
#import "OCJQuickRegisterTVCell.h"
#import "OCJBaseButton+OCJExtension.h"
#import "MBProgressHUD.h"
#import "OCJQuickRegisterSecurityCheckVC.h"
#import "OCJLoginVC.h"
#import "OCJRetrievePwdTVCell.h"
#import "OCJBaseButton+OCJExtension.h"
#import "OCJResetPwdVC.h"
#import "OCJRetrieveMobilePwdVC.h"
#import "OCJRetrieveEmailPwdVC.h"
#import "OCJLoginModel.h"
#import "OCJHttp_authAPI.h"

#pragma mark - 固定字符串赋值区域
@interface OCJRetrievePwdVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) TPKeyboardAvoidingTableView * ocjTableView;
@property (nonatomic,strong) OCJBaseTextField    * ocjTF_mobile;       ///< 手机号
@property (nonatomic,strong) OCJBaseTextField    * ocjTF_code;         ///< 验证码
@property (nonatomic,strong) OCJBaseButton  * ocjBtn_next;        ///< 下一步按钮
//@property (nonatomic,strong) OCJValidationBtn *ocjBtn_sendCode;///<发送验证码

@end

@implementation OCJRetrievePwdVC


#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad{
    [super viewDidLoad];
  
    [self ocj_setSelf];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - 私有方法区域
-(void)ocj_back{
  [super ocj_back];
  
  [self ocj_trackEventID:@"AP1706C006D003001C003001" parmas:nil];
}

-(void)ocj_setSelf{
  
    self.title  = @"找回密码";
  
    self.ocjStr_trackPageID = @"AP1706C006";
  
    [self initUI];
}

- (TPKeyboardAvoidingTableView *)ocj_TV{
    if (!_ocjTableView) {
        _ocjTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _ocjTableView.separatorStyle  = UITableViewCellSelectionStyleNone;
        _ocjTableView.dataSource      = self;
        _ocjTableView.delegate        = self;
        _ocjTableView.tableHeaderView = [UIView new];
        _ocjTableView.tableFooterView = [self setTableViewFooter];
        _ocjTableView.scrollEnabled = NO;
    }
    return _ocjTableView;
}
- (UIView *)setTableViewFooter{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];

    OCJBaseButton * ocjBtn_sslLogin = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    ocjBtn_sslLogin.frame = CGRectMake(20, 40, SCREEN_WIDTH - 40, 45);
    [ocjBtn_sslLogin setTitle:@"下一步" forState:UIControlStateNormal];
    ocjBtn_sslLogin.layer.masksToBounds = YES;
    ocjBtn_sslLogin.layer.cornerRadius = 2;
    
    ocjBtn_sslLogin.ocjFont = [UIFont systemFontOfSize:17];
    
    [ocjBtn_sslLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:ocjBtn_sslLogin];
    [ocjBtn_sslLogin ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    
    if (self.ocjStr_userName.length > 0) {
        ocjBtn_sslLogin.alpha = 1.0;
        ocjBtn_sslLogin.userInteractionEnabled = YES;
    }else {
        ocjBtn_sslLogin.alpha = 0.2;
        ocjBtn_sslLogin.userInteractionEnabled = NO;
    }
    
    self.ocjBtn_next = ocjBtn_sslLogin;
    [ocjBtn_sslLogin addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return footerView;
}

//点击'下一步'按钮
- (void)nextAction:(id)sender{
    [self.ocjTF_mobile resignFirstResponder];
    if (self.ocjTF_mobile.text.length==0) {
      [OCJProgressHUD ocj_showHudWithTitle:@"请输入正确的账号" andHideDelay:2];
      return;
    }
  
    [self ocj_trackEventID:@"AP1706C006F008001O008001" parmas:@{@"text":self.ocjTF_mobile.text}];

    //根据login_id判断用户类型
    [OCJHttp_authAPI ocjAuth_checkUserTypeWithAccount:self.ocjTF_mobile.text completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJAuthModel_CheckID* model = (OCJAuthModel_CheckID*)responseModel;
        
        if ([model.ocjStr_userType isEqualToString:@"0"]) {//不能识别
            
            [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeFailure title:[NSString stringWithFormat:@"%@尚未成为会员", self.ocjTF_mobile.text] message:@"" sureButtonTitle:@"去注册" CancelButtonTitle:@"取消" action:^(NSInteger clickIndex) {
                if (clickIndex == 1) {
                    OCJQuickRegisterVC *registerVC = [[OCJQuickRegisterVC alloc] init];
                    registerVC.ocjStr_account = self.ocjTF_mobile.text;
                    
                    [self ocj_pushVC:registerVC];
                }
            }];
            
        }else {//已注册过的用户
            if ([WSHHRegex wshh_isTelPhoneNumber:self.ocjTF_mobile.text]) {//手机号找回密码
                
                OCJRetrieveMobilePwdVC *mobileVC = [[OCJRetrieveMobilePwdVC alloc] init];
                mobileVC.ocjStr_mobile = self.ocjTF_mobile.text;
                [self ocj_pushVC:mobileVC];
            }else if ([WSHHRegex wshh_isEmail:self.ocjTF_mobile.text]) {//邮箱找回密码
                
                OCJRetrieveEmailPwdVC *emailVC = [[OCJRetrieveEmailPwdVC alloc] init];
                emailVC.ocjSendEmailype = OCJSendEmailTypeFindPwd;
                emailVC.ocjStr_email = self.ocjTF_mobile.text;
                emailVC.ocjStr_userName = model.ocjStr_custName;
                [self ocj_pushVC:emailVC];
            }else {
                [OCJProgressHUD ocj_showHudWithTitle:@"您输入的手机号或邮箱不正确" andHideDelay:2.0f];
            }
        }
    }];
    
}

- (void)initUI{
    [self.view addSubview:self.ocj_TV];
    [self.ocj_TV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

//更改后未使用
/*
- (void)sendCode{
    
    if (![WSHHRegex wshh_isTelPhoneNumber:self.ocjTF_mobile.text]) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入正确的手机号码" andHideDelay:2];
        return;
    }
    
    
    [self.ocjBtn_sendCode ocj_startTimer];
    [OCJHttp_authAPI ocjAuth_SendSmscodeWithMobile:self.ocjTF_mobile.text purpose:@"" completionHandler:^(OCJBaseResponceModel *responseModel) {
        
    }];
}
 */

- (void)textFieldChange:(OCJBaseTextField *)sender{
    if (self.ocjTF_mobile.text.length > 0) {
        self.ocjBtn_next.userInteractionEnabled = YES;
        self.ocjBtn_next.alpha = 1;
    }else{
        self.ocjBtn_next.userInteractionEnabled = NO;
        self.ocjBtn_next.alpha = 0.2;
    }
}

#pragma mark - 协议方法实现区域

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    __weak OCJRetrievePwdVC *wself = self;
//    if (indexPath.row == 0) {
        static NSString * cellIdentifeir = @"Identifier";
        OCJRetrievePwdTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifeir];
        if (!cell) {
            cell = [[OCJRetrievePwdTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifeir];
        }
        cell.ocjTF_Email.placeholder = @"请输入手机号或邮箱";
        self.ocjTF_mobile = cell.ocjTF_Email;
    
    if (self.ocjStr_userName.length > 0) {
        self.ocjTF_mobile.text = self.ocjStr_userName;
    }
    
//        self.ocjTF_mobile.delegate = self;
        [self.ocjTF_mobile addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    /*
    }else{
        static NSString * cellIdentifier = @"CellIdentifier";
        OCJRetrieveCodeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[OCJRetrieveCodeTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.ocjTF_mobile.placeholder = @"请输入验证码";
        self.ocjBtn_sendCode = cell.ocjBtn_sendCode;
        self.ocjBtn_sendCode.ocjBlock_touchUpInside = ^{
            [wself sendCode];
        };
        self.ocjTF_code.font = [UIFont systemFontOfSize:15];
        self.ocjTF_code = cell.ocjTF_mobile;
        self.ocjTF_code.delegate = self;
        [self.ocjTF_code addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
     */

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (str.length > 11) {
        return NO;
    }else{
        return YES;
    }
}

@end
