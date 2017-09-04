//
//  OCJAcountLoginVC.m
//  OCJ
//
//  Created by OCJ on 2017/4/27.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJAcountLoginVC.h"
#import "TPKeyboardAvoidingTableView.h"
#import "OCJLoginTypeTVCell.h"
#import "OCJValidationBtn.h"
#import "OCJHttp_authAPI.h"
#import "OCJRetrievePwdVC.h"
#import "OCJLoginModel.h"
#import "OCJHttp_authAPI.h"
#import "UIButton+OCJButton.h"
#import "OCJLoginVC.h"
#import "OCJDataUserInfo+CoreDataClass.h"
#import "OCJLockSliderTVCell.h"
#import "OCJ_RN_WebViewVC.h"

#pragma mark - 固定字符串赋值区域
@interface OCJAcountLoginVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,OCJLockSliderTVCellDelegete>

@property (nonatomic,strong) TPKeyboardAvoidingTableView * tableView;          ///< tableView
@property (nonatomic,strong) OCJBaseButton               * ocjBtn_forgetpwd;   ///< 忘记密码按钮
@property (nonatomic,strong) OCJBaseButton               * ocjBtn_login;       ///< 登录按钮
@property (nonatomic,strong) OCJValidationBtn            * ocjBtn_sendCode;    ///< 发送验证码
@property (nonatomic,strong) OCJBaseTextField            * ocjTF_code;         ///< 验证码
@property (nonatomic,strong) OCJBaseTextField            * ocjTF_pwd;          ///< 密码
@property (nonatomic,strong) UIImageView                 * ocjImgView_icon;        ///< 用户头像
@property (nonatomic,strong) OCJBaseLabel                * ocjLab_welcome;     ///< 欢迎信息

@property (nonatomic,strong) UIButton * ocjBtn_help; //帮助按钮

@property (nonatomic) NSInteger ocjInt_errorCount; ///< 密码输入错误次数（三次之后调出滑动验证）
@property (nonatomic) BOOL ocjBool_sliderShow; ///< 滑动验证是否出现，默认为NO（YES-出现 NO-未出现）
@property (nonatomic) BOOL ocjBool_sliderDone; ///< 滑动验证是否通过，默认为NO（YES-通过 NO-未通过）

@property (nonatomic,strong) OCJDataUserInfo* ocjUserInfo; ///< 用户信息coredata对象
@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;             ///<状态栏颜色

@end

@implementation OCJAcountLoginVC
#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.ocjStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:self.ocjStatusBarStyle];
    [self.ocjBtn_sendCode ocj_stopTimer];
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf{
  self.ocjStr_trackPageID = @"AP1706C005";
  
  self.userType = OCJUserAccountLoginTypePwd;
  [self ocj_setRightItemTitles:@[@"使用验证码登录"] selectorNames:@[@"ocjSwitchSSLAction:"]];
  
  //如果调出登录页面的是原生页面时，当用户选择放弃登录时，pop掉原生页面
  self.ocjBlock_backDone = ^{
    [OCJ_NOTICE_CENTER postNotificationName:OCJ_Notice_LoginCancel object:nil];//登录取消
    UIViewController* vc  = [AppDelegate ocj_getTopViewController];
    if ([vc isKindOfClass:[OCJBaseVC class]] && ![vc isKindOfClass:[OCJ_RN_WebViewVC class]]) {
      OCJBaseVC* topVc  = (OCJBaseVC*)vc;
      [topVc ocj_back];
    }
  };
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
  
  [self.view addSubview:self.ocjBtn_help];
  [self.ocjBtn_help mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(150);
    make.height.mas_equalTo(18);
    make.bottom.mas_equalTo(self.view).mas_offset(-15);
    make.centerX.mas_equalTo(self.view.mas_centerX);
  }];
}

- (void)ocjSwitchSSLAction:(id)sender{
    self.userType = OCJUserAccountLoginTypeSSLCode;
    self.ocjTF_code.text = @"";
    self.ocjBtn_login.userInteractionEnabled = NO;
    self.ocjBtn_login.alpha = 0.2;
    [self ocj_setRightItemTitles:@[@"使用密码登录"] selectorNames:@[@"ocjSwtichCodeLoginAction:"]];
    [self.tableView reloadData];
}

- (void)ocjSwtichCodeLoginAction:(id)sender{
    self.userType = OCJUserAccountLoginTypePwd;
    self.ocjTF_pwd.text = @"";
    self.ocjBtn_login.userInteractionEnabled = NO;
    self.ocjBtn_login.alpha = 0.2;
    [self ocj_setRightItemTitles:@[@"使用验证码登录"] selectorNames:@[@"ocjSwitchSSLAction:"]];
    [self.tableView reloadData];
}

- (void)forgetPwdAction:(id)sender{
    [self ocj_trackEventID:@"AP1706C005F010002A001001" parmas:nil];
  
    [self ocj_pushVC:[[OCJRetrievePwdVC alloc]init]];
}

- (void)ocjSwitchAccountAction:(id)sender{
  
    OCJLoginVC * ocj_loginVC = [[OCJLoginVC alloc]init];
    [self.navigationController pushViewController:ocj_loginVC animated:YES];
  
    [self ocj_trackEventID:@"AP1706C005F010001A001001" parmas:nil];
}

/**
 懒加载客服按钮.
 */
- (UIButton *)ocjBtn_help{
  if (!_ocjBtn_help) {
    _ocjBtn_help = [UIButton buttonWithType:UIButtonTypeCustom ];
    [_ocjBtn_help setTitle:@"遇到问题？东东帮您 >" forState:UIControlStateNormal];
    [_ocjBtn_help setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
    _ocjBtn_help.titleLabel.font = [UIFont systemFontOfSize:13];
    [_ocjBtn_help addTarget:self action:@selector(ocj_helpAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _ocjBtn_help;
}

/**
 “遇到问题？东东帮你”点击事件
 */
- (void)ocj_helpAction{
  
  [self ocj_trackEventID:@"AP1706C005F010003A001001" parmas:nil];
  
  if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://400-889-8000"]]) {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://400-889-8000"]];
  }
  
}


/**
 使用密码登录/验证码登录
 */
- (void)ocjUserLoginActoin:(id)sender{
    if (self.userType == OCJUserAccountLoginTypePwd) {
        [OcjStoreDataAnalytics trackEvent:@"AP1706C005F008001O008001"];
      
        [OCJHttp_authAPI ocjAuth_loginWithID:self.ocjUserInfo.ocjStr_account password:self.ocjTF_pwd.text thirdPartyInfo:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
          if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            if (self.navigationController.presentingViewController) {//进入app
              [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
          }else if ([responseModel.ocjStr_code isEqualToString:@"1020100902"]){
              self.ocjInt_errorCount++;
              [self ocj_dealWithPasswordError];//密码错误提示
          }
        }];
    }else{
      
        [OCJHttp_authAPI ocjAuth_smscodeLoginWithMobile:self.ocjUserInfo.ocjStr_account verifyCode:self.ocjTF_code.text purpose:@"mobile_login_context" thirdPartyInfo:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
            if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
              
                if (self.navigationController.presentingViewController) {//进入app
                  
                  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            }

        }];
    }
}

- (void)ocj_dealWithPasswordError{
  
  [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeFailure title:@"密码不正确" message:nil sureButtonTitle:@"取消" CancelButtonTitle:@"找回密码" action:^(NSInteger clickIndex) {
    
    switch (clickIndex) {
      case 0://找回密码
      {
        [self forgetPwdAction:nil];
      }break;
      case 1://取消
      {
        
      }break;
    }
  }];
  
}



-(void)sendCodeAction:(id)sender{
    OCJLog(@"发送验证码");
    if (self.ocjBtn_sendCode) {
        [self.ocjBtn_sendCode ocj_startTimer];
    }
    
    [OCJHttp_authAPI ocjAuth_SendSmscodeWithMobile:self.ocjUserInfo.ocjStr_account purpose:OCJSMSPurpose_MobileLogin internetID:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
        
    }];
}



- (void)ocj_back{
    [super ocj_back];
  
    [self ocj_trackEventID:@"AP1706C005C005001C003001" parmas:nil];
}

- (UIView *)createTableViewHeaderView{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175)];
    headerView.userInteractionEnabled = YES;
    
    self.ocjImgView_icon = [[UIImageView alloc] init];
    self.ocjImgView_icon.layer.masksToBounds = YES;
    self.ocjImgView_icon.layer.cornerRadius = 40;
  NSString *newStr = [self.ocjUserInfo.ocjStr_icon length] > 0 ? self.ocjUserInfo.ocjStr_icon : @"";
    [headerView addSubview:self.ocjImgView_icon];
  [self.ocjImgView_icon ocj_setWebImageWithURLString:newStr placeHolderImage:[UIImage imageNamed:@"Icon_user_"] hideLoading:YES completion:nil];
    
    self.ocjLab_welcome = [OCJBaseLabel new];
    self.ocjLab_welcome.font = [UIFont systemFontOfSize:17];
    self.ocjLab_welcome.textAlignment = NSTextAlignmentCenter;
    self.ocjLab_welcome.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    self.ocjLab_welcome.text = [NSString stringWithFormat:@"%@,欢迎您",self.ocjUserInfo.ocjStr_name];
    [headerView addSubview:self.ocjLab_welcome];
    
    OCJBaseButton * ocjBtn_switch = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [ocjBtn_switch setTitle:@"切换账号" forState:UIControlStateNormal];
    ocjBtn_switch.ocjFont = [UIFont systemFontOfSize:13];
    [ocjBtn_switch setTitleColor:[UIColor colorWSHHFromHexString:@"666666"] forState:UIControlStateNormal];
    [ocjBtn_switch addTarget:self action:@selector(ocjSwitchAccountAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:ocjBtn_switch];
    
    [self.ocjImgView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(headerView.mas_top).offset(26);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    [self.ocjLab_welcome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(self.ocjImgView_icon.mas_bottom).offset(10);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(24);
    }];
    
    [ocjBtn_switch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(18.5);
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(self.ocjLab_welcome.mas_bottom).offset(15);
    }];
    
    
    return headerView;
}

- (UIView *)createTableViewFooterView{
    UIView *  footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    OCJBaseButton * ocjBtn_Login = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    ocjBtn_Login.frame = CGRectMake(20, 40 , SCREEN_WIDTH - 40, 45);
    [ocjBtn_Login setTitle:@"登录" forState:UIControlStateNormal];
    ocjBtn_Login.layer.masksToBounds = YES;
    ocjBtn_Login.layer.cornerRadius = 2;
    ocjBtn_Login.alpha = 0.2;
    ocjBtn_Login.userInteractionEnabled =NO;
    ocjBtn_Login.ocjFont = [UIFont systemFontOfSize:17];
    [ocjBtn_Login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ocjBtn_Login ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [ocjBtn_Login addTarget:self action:@selector(ocjUserLoginActoin:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:ocjBtn_Login];
    self.ocjBtn_login = ocjBtn_Login;
    return footerView;
}

#pragma mark - setter
-(void)setOcjInt_errorCount:(NSInteger)ocjInt_errorCount{
  _ocjInt_errorCount = ocjInt_errorCount;
  
  if (_ocjInt_errorCount>=3) {
    self.ocjBool_sliderShow = YES;
    self.ocjBool_sliderDone = NO;
    self.ocjBtn_login.ocjBool_enable = NO;
    [self.tableView reloadData];
  }
  
}

#pragma mark - getter
- (OCJDataUserInfo *)ocjUserInfo{
  if (!_ocjUserInfo) {
      _ocjUserInfo = [[OCJDataUserInfo ocj_fetchUserInfo]lastObject];
  }
  
  return _ocjUserInfo;
}
static NSString * cellIdentifier1 = @"OCJLoginTypeSendCodeTVCelllIdentifier11";
static NSString * cellIdentifier2 = @"sliderCell";//滑动验证cell
static NSString * cellIdentifier3 = @"OCJLoginTypeSendPwdTVCellIdentifier111";
- (TPKeyboardAvoidingTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self createTableViewHeaderView];
        _tableView.tableFooterView = [self createTableViewFooterView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"OCJLockSliderTVCell" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
        [_tableView registerClass:[OCJLoginTypeSendCodeTVCell class] forCellReuseIdentifier:cellIdentifier1];
        [_tableView registerClass:[OCJLoginTypeSendPwdTVCell class] forCellReuseIdentifier:cellIdentifier3];
      
    }
    return _tableView;
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  if (self.ocjBool_sliderShow && self.userType == OCJUserAccountLoginTypePwd) {//滑动验证存在
      return 2;
  }
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  switch (indexPath.section) {
    case 0:return 70;
    case 1:return 90;
    default:return 0;
  }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  switch (indexPath.section) {
    case 0:
    {
      if (self.userType == OCJUserAccountLoginTypeSSLCode) {
        
        OCJLoginTypeSendCodeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
        self.ocjTF_code = cell.ocjTF_input;
        [self.ocjTF_code addTarget:self action:@selector(ocj_textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
        self.ocjBtn_sendCode = cell.ocjBtn_sendCode;
        [self.ocjBtn_sendCode addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
      }else{
        
        OCJLoginTypeSendPwdTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
        self.ocjTF_pwd = cell.ocjTF_pwd;
        [self.ocjTF_pwd addTarget:self action:@selector(ocj_textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
        self.ocjBtn_forgetpwd  = cell.ocjBtn_forgetPwd;
        [self.ocjBtn_forgetpwd addTarget:self action:@selector(forgetPwdAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
      }
    }break;
    case 1:{
        if (self.userType == OCJUserAccountLoginTypePwd) {
          OCJLockSliderTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
          [cell ocj_resetSlider:OCJLockSliderEnumTips];
          cell.ocjDelegate = self;
          return cell;
        }
    }
      
    default:return nil;
  }
  

}


- (void)ocj_textFieldValueChange:(OCJBaseTextField *)sender{
  BOOL isEnable = NO;
  BOOL passwordIsExist = (self.ocjTF_pwd.text.length>0);//密码是否存在
  BOOL codeIsExist = (self.ocjTF_code.text.length>0);//验证码是否存在
  
  switch (self.userType) {
    case OCJUserAccountLoginTypePwd:{
        if(self.ocjBool_sliderShow) {
            isEnable = (  passwordIsExist && self.ocjBool_sliderDone);
        }else{
          isEnable = ( passwordIsExist);
        }
    }break;
    case OCJUserAccountLoginTypeSSLCode:{
      isEnable = (codeIsExist);
    }break;
  }
  
  self.ocjBtn_login.ocjBool_enable = isEnable;
}



#pragma mark - OCJLockSliderTVCellDelegete
-(void)ocj_sliderCheckDone{
  //验证完成
  self.ocjBool_sliderDone = YES;
  //登录页主按钮交互状态设置===============
  BOOL passwordIsExist = (self.ocjTF_pwd.text.length>0);//密码是否存在
  self.ocjBtn_login.ocjBool_enable = ( passwordIsExist && self.ocjBool_sliderDone);
  //==================================
}

-(void)ocj_sliderCheckCancel{
  self.ocjBool_sliderDone = NO;
  //登录页主按钮交互状态设置===============
  BOOL passwordIsExist = (self.ocjTF_pwd.text.length>0);//密码是否存在
  self.ocjBtn_login.ocjBool_enable = ( passwordIsExist && self.ocjBool_sliderDone);
}

@end
