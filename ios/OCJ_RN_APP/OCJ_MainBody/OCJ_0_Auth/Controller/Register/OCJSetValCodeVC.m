//
//  OCJSetValCodeVC.m
//  OCJ
//
//  Created by OCJ on 2017/4/28.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSetValCodeVC.h"
#import "TPKeyboardAvoidingTableView.h"
#import "OCJQuickRegisterTVCell.h"
#import "OCJBaseButton+OCJExtension.h"
#import "OCJQuickRegisterSecurityCheckVC.h"
#import "OCJLoginVC.h"
#import "WSHHRegex.h"
#import "AppDelegate+OCJExtension.h"
#import "OCJHttp_authAPI.h"
#import "OCJ_RN_WebViewVC.h"



@interface OCJSetValCodeVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) TPKeyboardAvoidingTableView * ocjTableView;
@property (nonatomic,strong) NSMutableArray   * ocj_dataArray;
@property (nonatomic,strong) OCJBaseButton         * ocjBtn_help;        ///< 帮助
@property (nonatomic,strong) UIView           * ocjView_shopProtol; ///< 购物条款
@property (nonatomic,strong) OCJBaseLabel          * ocjLab_protocol;     ///< 条款
@property (nonatomic,strong) OCJBaseButton         * ocjBtn_protocol;    ///< 东方购物网络使用条款
@property (nonatomic,strong) OCJBaseButton    * ocjBtn_register;    ///< 注册按钮
@property (nonatomic,strong) OCJBaseTextField      * ocjTF_code;         ///< 验证码
@property (nonatomic,strong) OCJBaseTextField      * ocjTF_securityPwd;  ///< 登录密码
@property (nonatomic,strong) OCJValidationBtn * ocjBtn_sendCode;    ///< 发送验证码
@property (nonatomic,strong) NSString* ocjStr_internetID;///<

@end

@implementation OCJSetValCodeVC

#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad{
    [super viewDidLoad];
  
    [self ocj_setSelf];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.ocjBtn_sendCode ocj_stopTimer];
  
}

- (void)dealloc{
    
    self.ocjBtn_register  = nil;
}

#pragma mark - 私有方法区域

-(void)ocj_back{
    [super ocj_back];
    
    [OcjStoreDataAnalytics trackEvent:@"AP1706C011C005001C003001"];
    [self ocj_trackEventID:@"AP1706C012F010001A001001" parmas:nil];
}

- (void)ocj_setSelf{
  
    self.title  = @"新会员注册";
  
    self.ocjStr_trackPageID = @"AP1706C011";
  
    [self ocj_setRightItemTitles:@[@"登录"] selectorNames:@[@"loginAction:"]];
    [self initUI];
}

- (TPKeyboardAvoidingTableView *)ocj_TV{
    if (!_ocjTableView) {
        _ocjTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _ocjTableView.separatorStyle  = UITableViewCellSelectionStyleNone;
        _ocjTableView.dataSource      = self;
        _ocjTableView.delegate        = self;
        _ocjTableView.tableFooterView = [self createTableViewFooterView];
        _ocjTableView.tableHeaderView = [UIView new];
        _ocjTableView.scrollEnabled = NO;
    }
    return _ocjTableView;
}
- (UIView *)createTableViewFooterView{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    self.ocjBtn_register.frame = CGRectMake(20, 40, self.view.frame.size.width - 40, 45) ;
    [self.ocjBtn_register ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [footerView addSubview:self.ocjBtn_register];
    [footerView addSubview:self.ocjView_shopProtol];
    [self.ocjView_shopProtol addSubview:self.ocjBtn_protocol];
    [self.ocjView_shopProtol addSubview:self.ocjLab_protocol];

    
    [self.ocjView_shopProtol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footerView.mas_centerX);
        make.top.mas_equalTo(self.ocjBtn_register.mas_bottom).offset(15);
        make.width.mas_equalTo(256);
        make.height.mas_equalTo(18);
    }];
    
    [self.ocjLab_protocol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_shopProtol);
        make.top.mas_equalTo(self.ocjView_shopProtol);
        make.bottom.mas_equalTo(self.ocjView_shopProtol);
    }];
    
    [self.ocjBtn_protocol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_protocol.mas_right);
        make.top.mas_equalTo(self.ocjLab_protocol);
        make.bottom.mas_equalTo(self.ocjLab_protocol);
    }];

    return footerView;
}
- (OCJBaseButton *)ocjBtn_help{
    if (!_ocjBtn_help) {
        _ocjBtn_help = [OCJBaseButton buttonWithType:UIButtonTypeCustom ];
        [_ocjBtn_help setTitle:@"遇到问题？东东帮您 >" forState:UIControlStateNormal];
        [_ocjBtn_help setTitleColor:[UIColor colorWSHHFromHexString:@"666666"] forState:UIControlStateNormal];
        _ocjBtn_help.ocjFont = [UIFont systemFontOfSize:13];
        [_ocjBtn_help addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_help;
}

- (OCJBaseButton *)ocjBtn_protocol{
    if (!_ocjBtn_protocol) {
        _ocjBtn_protocol = [OCJBaseButton buttonWithType:UIButtonTypeCustom ];
        [_ocjBtn_protocol setTitle:@"《东方购物网络使用条款》" forState:UIControlStateNormal];
        [_ocjBtn_protocol setTitleColor:OCJ_COLOR_DARK forState:UIControlStateNormal];
        _ocjBtn_protocol.ocjFont = [UIFont systemFontOfSize:12];
        [_ocjBtn_protocol addTarget:self action:@selector(ocj_clickProtocolButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_protocol;
}

- (OCJBaseLabel *)ocjLab_protocol{
    if (!_ocjLab_protocol) {
        _ocjLab_protocol = [OCJBaseLabel new ];
        [_ocjLab_protocol setText:@"注册即表示同意"];
        [_ocjLab_protocol setTextColor:[UIColor colorWSHHFromHexString:@"666666"] ];
        _ocjLab_protocol.font = [UIFont systemFontOfSize:12];
    }
    return _ocjLab_protocol;
}

- (UIView *)ocjView_shopProtol{
    if (!_ocjView_shopProtol) {
        _ocjView_shopProtol = [UIView new ];
    }
    return _ocjView_shopProtol;
}

- (OCJBaseButton *)ocjBtn_register{
    if (!_ocjBtn_register) {
        _ocjBtn_register = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
        _ocjBtn_register.backgroundColor = [UIColor whiteColor];
        [_ocjBtn_register setTitle:@"注 册" forState:UIControlStateNormal];
        _ocjBtn_register.layer.masksToBounds = YES;
        _ocjBtn_register.layer.cornerRadius = 5;
        _ocjBtn_register.userInteractionEnabled = NO;
        _ocjBtn_register.alpha = 0.2;
        [_ocjBtn_register setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ocjBtn_register.ocjFont = [UIFont systemFontOfSize:17];
        [_ocjBtn_register addTarget:self action:@selector(ocj_clickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_register;
}

- (void)initUI{
    [self.view addSubview:self.ocj_TV];
    [self.view addSubview:self.ocjBtn_help];
    [self.ocj_TV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.ocjBtn_help mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(18);
        make.bottom.mas_equalTo(self.view).mas_offset(-15);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
}

- (void)loginAction:(OCJBaseButton *)sender{
    [self ocj_trackEventID:@"AP1706C011C005001A001001" parmas:nil];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)helpAction:(OCJBaseButton *)sender{
    [self ocj_trackEventID:@"AP1706C011C005001A001001" parmas:nil];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://400-889-8000"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://400-889-8000"]];
    }
}

- (void)ocj_clickRegisterButton{
    
    if (self.ocjTF_code.text.length != 6) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入正确的验证码" andHideDelay:2];
        return;
    }
    
    if (self.ocjStr_internetID.length==0) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入正确的验证码" andHideDelay:2];
        return;
    }
    
    if ([self.ocjTF_securityPwd.text isEqualToString:self.ocjStr_userMobile]) {
        [WSHHAlert wshh_showHudWithTitle:@"密码不可以与手机号相同" andHideDelay:2];
        return;
    }
  
    [self ocj_trackEventID:@"AP1706C011F008002O008001" parmas:nil];
    
    __weak OCJSetValCodeVC* weakSelf = self;
    [OCJHttp_authAPI ocjAuth_registerWithMobile:self.ocjStr_userMobile verifyCode:self.ocjTF_code.text newPwd:self.ocjTF_securityPwd.text internetID:self.ocjStr_internetID companyCode:nil thirdPartyInfo:self.ocjStr_thirdPartyInfo completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        [OCJProgressHUD ocj_showAlertByVC:weakSelf withAlertType:OCJAlertTypeSuccessSendEmail title:@"恭喜您注册成功" message:@"" sureButtonTitle:nil CancelButtonTitle:@"我知道了" action:^(NSInteger clickIndex) {
            if (self.navigationController.presentingViewController) {//进入app
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
        
    }];
}

- (void)ocj_clickProtocolButton{
  OCJ_RN_WebViewVC* webView = [[OCJ_RN_WebViewVC alloc]init];
  webView.ocjDic_router = @{@"url":@"http://rm.ocj.com.cn/staticPage/shop/m/register_service.jsp"};
  
  [self ocj_pushVC:webView];
}

//发送验证码
- (void)sendCodeAction:(id)sender{
    [self ocj_trackEventID:@"AP1706C011F008001O008001" parmas:nil];
    
    OCJLog(@"发送验证码");
    [self.ocjBtn_sendCode ocj_startTimer];

    [OCJHttp_authAPI ocjAuth_SendSmscodeWithMobile:self.ocjStr_userMobile purpose:OCJSMSPurpose_QuickSignUp internetID:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJAuthModel_SendSms* model = (OCJAuthModel_SendSms*)responseModel;
        
        self.ocjStr_internetID = model.ocjStr_internetID;
    }];
    
}

- (void)textFieldChange:(id)sender{
    if ( self.ocjTF_code.text.length > 0  && self.ocjTF_securityPwd.text.length >0 ) {
        self.ocjBtn_register.userInteractionEnabled = YES;
        self.ocjBtn_register.alpha = 1;
    }else{
        self.ocjBtn_register.userInteractionEnabled = NO;
        self.ocjBtn_register.alpha = 0.2;
    }
}

#pragma mark - 协议方法实现区域

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   if(indexPath.row == 0){
        static NSString * cellIdentifier = @"OCJCodeTVCellIdentifier";
        OCJCodeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[OCJCodeTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.ocjTF_mobile.placeholder = @"请输入短信验证码";
        self.ocjBtn_sendCode = cell.ocjBtn_sendCode;
        self.ocjTF_code.font = [UIFont systemFontOfSize:15];
        self.ocjTF_code = cell.ocjTF_mobile;
        self.ocjTF_code.delegate = self;
        [self.ocjTF_code addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        [self.ocjBtn_sendCode addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];      
        return cell;
    }else{
        static NSString * cellIdentifier = @"OCJQuickRegisterTVCellIdentifier";
        OCJLQuickRegisteBottomTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[OCJLQuickRegisteBottomTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        self.ocjTF_securityPwd = cell.ocjTF_pwd;
        self.ocjTF_securityPwd.placeholder = @"设置登录密码";
        self.ocjTF_securityPwd.delegate = self;
        self.ocjTF_securityPwd.keyboardType = UIKeyboardTypeDefault;
        [self.ocjTF_securityPwd addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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

@end
