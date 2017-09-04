//
//  OCJQuickRegisterVC.m
//  OCJ
//
//  Created by zhangchengcai on 2017/4/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJQuickRegisterVC.h"
#import "TPKeyboardAvoidingTableView.h"
#import "OCJLoginTypeTVCell.h"
#import "OCJBaseButton+OCJExtension.h"
#import "OCJSetValCodeVC.h"
#import "WSHHRegex.h"
#import "OCJLoginModel.h"
#import "OCJLoginVC.h"
#import "OCJHttp_authAPI.h"

#pragma mark - 固定字符串赋值区域

@interface OCJQuickRegisterVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) TPKeyboardAvoidingTableView * ocjTableView;
@property (nonatomic,strong) OCJBaseTextField   * ocjTF_mobile;   ///< 用户手机号
@property (nonatomic,strong) OCJBaseButton * ocjBtn_cofirm;  ///< 确认按钮
@property (nonatomic,strong) OCJBaseButton      * ocjBtn_help;    ///< 帮助

@end


@implementation OCJQuickRegisterVC

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
  
    [self ocj_trackEventID:@"AP1706C010C005001C003001" parmas:nil];
}

- (void)ocj_setSelf{
  
    self.title  = @"新会员注册";
  
    self.ocjStr_trackPageID = @"AP1706C010";
  
//    [self ocj_setRightItemTitles:@[@"登录"] selectorNames:@[@"loginAction:"]];
    [self initUI];
}

- (TPKeyboardAvoidingTableView *)ocjTableView{
    if (!_ocjTableView) {
        _ocjTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _ocjTableView.separatorStyle  = UITableViewCellSelectionStyleNone;
        _ocjTableView.dataSource      = self;
        _ocjTableView.delegate        = self;
        _ocjTableView.tableFooterView = [self ocjCreateTableViewFooter];
        _ocjTableView.tableHeaderView = [UIView new];
        _ocjTableView.scrollEnabled = NO;
    }
    return _ocjTableView;
}
- (UIView *)ocjCreateTableViewFooter{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    OCJBaseButton * ocjBtn_Login = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    ocjBtn_Login.frame = CGRectMake(20, 40 , SCREEN_WIDTH - 40, 45);
    [ocjBtn_Login setTitle:@"确认" forState:UIControlStateNormal];
    ocjBtn_Login.layer.masksToBounds = YES;
    ocjBtn_Login.layer.cornerRadius = 2;
    
    ocjBtn_Login.ocjFont = [UIFont systemFontOfSize:17];
    [ocjBtn_Login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ocjBtn_Login ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    
    if (self.ocjStr_account.length > 0) {
        ocjBtn_Login.userInteractionEnabled = YES;
        ocjBtn_Login.alpha = 1.0;
    }else {
        ocjBtn_Login.userInteractionEnabled = NO;
        ocjBtn_Login.alpha = 0.2;
    }
    
    [footerView addSubview:ocjBtn_Login];
    self.ocjBtn_cofirm = ocjBtn_Login;
    [self.ocjBtn_cofirm addTarget:self action:@selector(ocjCorfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}
- (void)ocjCorfirmAction:(id)sender{
  
    [self ocj_trackEventID:@"AP1706C010F008001O008001" parmas:nil];
    
    [OCJHttp_authAPI ocjAuth_checkUserTypeWithAccount:self.ocjTF_mobile.text completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJAuthModel_CheckID* model = (OCJAuthModel_CheckID*)responseModel;
        
        if ([model.ocjStr_userType isEqualToString:@"0"]) {//非注册会员
            if (![WSHHRegex wshh_isTelPhoneNumber:self.ocjTF_mobile.text]) {
                [WSHHAlert wshh_showHudWithTitle:@"请输入有效的手机号" andHideDelay:2];
                return ;
            }
            
            OCJSetValCodeVC * ocjSetCodeVC = [[OCJSetValCodeVC alloc]init];
            ocjSetCodeVC.ocjStr_userMobile = self.ocjTF_mobile.text;
            ocjSetCodeVC.ocjStr_thirdPartyInfo = self.ocjStr_thirdPartyInfo;
            [self ocj_pushVC:ocjSetCodeVC];
            
        }else {//已注册会员
            [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeFailure title:[NSString stringWithFormat:@"%@账号已存在", self.ocjTF_mobile.text] message:@"请直接登录" sureButtonTitle:@"登录" CancelButtonTitle:@"返回" action:^(NSInteger clickIndex) {
                if (clickIndex == 1) {
                    BOOL isHaveLoginPage = NO;//导航栈中是否存在登录页面
                    for (UIViewController* vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[OCJLoginVC class]]) {
                            //返回登录页面并带回账户名
                            OCJLoginVC* loginVC = (OCJLoginVC*)vc;
                            if ([WSHHRegex wshh_isTelPhoneNumber:self.ocjTF_mobile.text]) {
                                loginVC.loginType = OCJLoginTypeMedia_pwd;
                            }else {
                                loginVC.loginType = OCJLoginTypeDefault;
                            }
                            loginVC.ocjStr_account = self.ocjTF_mobile.text;
                            isHaveLoginPage = YES;
                            [self.navigationController popToViewController:vc animated:YES];
                            break;
                        }
                    }
                  
                    if (!isHaveLoginPage) {
                      OCJLoginVC* loginVC = [[OCJLoginVC alloc]init];
                      loginVC.ocjStr_account = self.ocjTF_mobile.text;
                      [self ocj_pushVC:loginVC];
                    }
                }
            }];
        }
    }];
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


- (void)initUI{
    [self.view addSubview:self.ocjTableView];
    [self.view addSubview:self.ocjBtn_help];
    [self.ocjTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [self.navigationController popToRootViewControllerAnimated:YES];
  
    [self ocj_trackEventID:@"AP1706C010C005001A001001" parmas:nil];
}

- (void)helpAction:(OCJBaseButton *)sender{
    [self ocj_trackEventID:@"AP1706C010F010001A001001" parmas:nil];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://400-889-8000"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://400-889-8000"]];
    }
}

#pragma mark - 协议方法实现区域
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"OCJQuickRegisterTVCellIdentifier";
    OCJLoginTypeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OCJLoginTypeTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    self.ocjTF_mobile = cell.ocjTF_input;
    self.ocjTF_mobile.keyboardType = UIKeyboardTypeDefault;
    self.ocjTF_mobile.delegate = self;
    
    if (self.ocjStr_account.length > 0) {
        self.ocjTF_mobile.text = self.ocjStr_account;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.ocjTF_mobile) {
        if (str.length > 0) {
            self.ocjBtn_cofirm.alpha = 1;
            self.ocjBtn_cofirm.userInteractionEnabled = YES;
        }else{
            self.ocjBtn_cofirm.alpha = 0.2;
            self.ocjBtn_cofirm.userInteractionEnabled = NO;
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField == self.ocjTF_mobile) {
        self.ocjBtn_cofirm.alpha = 0.2;
        self.ocjBtn_cofirm.userInteractionEnabled = NO;
    }
    return YES;
}

@end
