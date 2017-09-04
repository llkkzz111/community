//
//  OCJResetPwdVC.m
//  OCJ
//
//  Created by zhangchengcai on 2017/4/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJResetPwdVC.h"
#import "OCJQuickRegisterVC.h"
#import "TPKeyboardAvoidingTableView.h"
#import "OCJResetPwdTVCell.h"
#import "OCJBaseButton+OCJExtension.h"
#import "MBProgressHUD.h"
#import "OCJQuickRegisterSecurityCheckVC.h"
#import "OCJLoginVC.h"
#import "OCJBaseButton+OCJExtension.h"
#import "OCJHttp_authAPI.h"
#import "AppDelegate+OCJExtension.h"


@interface OCJResetPwdVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) TPKeyboardAvoidingTableView * ocjTableView;
@property (nonatomic,strong) OCJBaseTextField    * ocjTF_pwd;                ///< 密码
@property (nonatomic,strong) OCJBaseTextField    * ocjTF_confirmPwd;         ///< 确认密码
@property (nonatomic,strong) OCJBaseButton       * ocjBtn_confirmPwd;        ///< 确认按钮
@property (nonatomic,strong) NSString * ocjStr_pwd;
@property (nonatomic,strong) NSString * ocjStr_confirmPwd;

@end

@implementation OCJResetPwdVC

#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad{
    [super viewDidLoad];
  
    [self ocj_setSelf];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
}

#pragma mark - 私有方法区域
-(void)ocj_back{
  [super ocj_back];
  
  [self ocj_trackEventID:@"AP1706C007D003001C003001" parmas:nil];
}

- (void)ocj_setSelf{
  
    self.title  = @"设置新密码";
  
    self.ocjStr_trackPageID = @"AP1706C007";
  
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
    
    OCJBaseButton * ocjBtn_confirm = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    ocjBtn_confirm.frame = CGRectMake(20, 40, SCREEN_WIDTH - 40, 45);
    [ocjBtn_confirm setTitle:@"确定" forState:UIControlStateNormal];
    ocjBtn_confirm.layer.masksToBounds = YES;
    ocjBtn_confirm.layer.cornerRadius = 2;
    ocjBtn_confirm.alpha = 0.2;
    ocjBtn_confirm.ocjFont = [UIFont systemFontOfSize:17];
    ocjBtn_confirm.userInteractionEnabled = NO;
    [ocjBtn_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ocjBtn_confirm addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:ocjBtn_confirm];
    [ocjBtn_confirm ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    self.ocjBtn_confirmPwd = ocjBtn_confirm;
    
    return footerView;
}


- (void)loginAction:(id)sender{
    
    if (self.ocjTF_pwd.text.length <= 0 || self.ocjTF_confirmPwd.text.length <= 0 || ![self.ocjTF_pwd.text isEqualToString:self.ocjTF_confirmPwd.text]) {
        [WSHHAlert wshh_showHudWithTitle:@"两次密码输入不一致" andHideDelay:2.0f];
        return;
    }
  
    [self ocj_trackEventID:@"AP1706C007F008001O008001" parmas:nil];
  
    [OCJHttp_authAPI ocjAuth_setPasswordNewPassword:self.ocjTF_pwd.text oldPassword:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
      [OCJProgressHUD ocj_showHudWithTitle:@"密码修改成功" andHideDelay:2];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.navigationController.presentingViewController) {//进入app
          [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
      });
      
    }];
}

- (void)initUI{
    [self.view addSubview:self.ocj_TV];
}

- (void)textFieldChange:(OCJBaseTextField *)sender{
    if (self.ocjTF_confirmPwd.text.length > 0 && self.ocjTF_confirmPwd.text.length > 0) {
        self.ocjBtn_confirmPwd.userInteractionEnabled = YES;
        self.ocjBtn_confirmPwd.alpha = 1;
        
    }else{
        self.ocjBtn_confirmPwd.userInteractionEnabled = NO;
        self.ocjBtn_confirmPwd.alpha = 0.2;
    }
}

#pragma mark - 协议方法实现区域
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString * cellIdentifier = @"OCJResetPwdVCIdentifier";
        OCJResetPwdTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[OCJResetPwdTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.ocjTF_pwd.placeholder = @"请输入密码";
        self.ocjTF_pwd = cell.ocjTF_pwd;
        self.ocjTF_pwd.delegate = self;
        [self.ocjTF_pwd addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }else{
        static NSString * cellIdentifier = @"OCJResetConfirmPwdVCIdentifier";
        OCJResetPwdTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[OCJResetPwdTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.ocjTF_pwd.placeholder = @"请再次输入密码";
        self.ocjTF_confirmPwd = cell.ocjTF_pwd;
        self.ocjTF_confirmPwd.delegate = self;
        [self.ocjTF_confirmPwd addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];

        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 56;
    }else{
        return 82;
    }
}



@end
