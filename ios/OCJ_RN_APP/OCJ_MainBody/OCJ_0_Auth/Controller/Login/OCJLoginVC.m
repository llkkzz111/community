//
//  OCJLoginVC.m
//  OCJ
//
//  Created by zhangchengcai on 2017/4/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJLoginVC.h"
#import "OCJSecurityCheckVC.h"
#import "OCJRetrievePwdVC.h"
#import "OCJResetPwdVC.h"
#import "OCJQuickRegisterVC.h"
#import "OCJAcountLoginVC.h"
#import "OCJSetCellPhonePasswordVC.h"
#import "OCJOPMemberLoginVC.h"
#import "OCJBindingModileVC.h"

#import "OCJLoginTypeTVCell.h"
#import "OCJLockSliderTVCell.h"

#import "OCJHttp_authAPI.h"
#import "OCJLoginModel.h"

#import "OCJBaseButton+OCJExtension.h"
#import "TPKeyboardAvoidingTableView.h"
#import "WSHHRegex.h"
#import "WSHHThirdPartyLogin.h"
#import "OCJHomePageVC.h"
#import "OCJ_RN_WebViewVC.h"
#import "WXApi.h"

@interface OCJLoginVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,OCJLockSliderTVCellDelegete>

@property (nonatomic,strong) UIImageView * ocjImg_user; ///< 用户头像
@property (nonatomic,strong) UILabel     * ocjLab_user; ///< 用户名

@property (nonatomic,strong) TPKeyboardAvoidingTableView * tableView;   ///< tableView
@property (nonatomic,strong) OCJLoginTypeTVCell* ocjTVCell_account; //账户输入框所在cell
@property (nonatomic,strong) OCJBaseTextField* ocjTF_account; ///< 账户输入框
@property (nonatomic,strong) OCJBaseTextField* ocjTF_password; ///< 密码输入框
@property (nonatomic,strong) OCJBaseTextField* ocjTF_code; ///< 验证码输入框
@property (nonatomic,strong) OCJBaseTextField* ocjTF_name; ///< 姓名输入框
@property (nonatomic,strong) OCJValidationBtn* ocjBtn_sendSms; ///< 发送验证码按钮

@property (nonatomic) NSInteger ocjInt_errorCount; ///< 密码输入错误次数（三次之后调出滑动验证）
@property (nonatomic) BOOL ocjBool_sliderShow; ///< 滑动验证是否出现，默认为NO（YES-出现 NO-未出现）
@property (nonatomic) BOOL ocjBool_sliderDone; ///< 滑动验证是否通过，默认为NO（YES-通过 NO-未通过）

@property (nonatomic,strong) OCJBaseButton* ocjBtn_main; ///< 页面主按钮

@property (nonatomic,strong) UIView   * ocjView_bottom; //第三方登录底板视图

@property (nonatomic,strong) UIButton * ocjBtn_help; //帮助按钮

@property (nonatomic,copy) NSString* ocjStr_internetID; //用户网络ID
@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;

@end

@implementation OCJLoginVC

#pragma mark - 接口方法实现区域（包括setter、getter方法）
-(void)setLoginType:(OCJLoginType)loginType{
    _loginType = loginType;
    
    if (self.ocjBtn_sendSms) {
        [self.ocjBtn_sendSms ocj_stopTimer];
    }
    
    self.ocjStr_internetID = nil;
    
    self.ocjInt_errorCount = 0;
    self.ocjBool_sliderShow = NO;//关闭滑动验证
    self.ocjBool_sliderDone = NO;
    
    self.tableView.tableFooterView = [self ocj_createTableViewFooterView];
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView reloadData];
    }];
    
}

- (void)setOcjStr_account:(NSString *)ocjStr_account{
    _ocjStr_account = ocjStr_account;
    
    self.ocjTF_account.text = ocjStr_account;
    [self ocj_textFieldValueChange:self.ocjTF_account];
    [self textFieldDidBeginEditing:self.ocjTF_account];
}

#pragma mark - 生命周期方法区域

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];//控制器属性设置
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.ocjStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:self.ocjStatusBarStyle];
    [self.ocjBtn_sendSms ocj_stopTimer];
  
}

#pragma mark - 私有方法区域
-(void)ocj_back{
    [super ocj_back];
  
  if (self.ocjEnum_purposeType == OCJUserPurposeTypeLogin) {
    
    [self ocj_trackEventID:@"AP1706C015C005001C003001" parmas:nil];
  }else if (self.ocjEnum_purposeType == OCJUserPurposeTypeRelevance){
    
    [self ocj_trackEventID:@"AP1706C014D003001C003001" parmas:nil];
  }

}

-(void)ocj_setSelf{
    if (self.ocjEnum_purposeType == OCJUserPurposeTypeLogin) {
        self.ocjStr_trackPageID = @"AP1706C015";
    }else if (self.ocjEnum_purposeType == OCJUserPurposeTypeRelevance){
        self.ocjStr_trackPageID = @"AP1706C014";
    }
  
    self.navigationController.navigationBarHidden = NO;
    self.ocjBlock_backDone = ^{
        [OCJ_NOTICE_CENTER postNotificationName:OCJ_Notice_LoginCancel object:nil];//登录取消
        UIViewController* vc  = [AppDelegate ocj_getTopViewController];
        if ([vc isKindOfClass:[OCJBaseVC class]] && ![vc isKindOfClass:[OCJ_RN_WebViewVC class]]) {
          OCJBaseVC* topVc  = (OCJBaseVC*)vc;
          [topVc ocj_back];
        }
    };
  
    if (self.ocjEnum_purposeType == OCJUserPurposeTypeLogin) { //登录时才有链接注册按钮，关联时无此按钮
        [self ocj_setRightItemTitles:@[@"新会员注册"] selectorNames:@[NSStringFromSelector(@selector(ocj_quickRegisterAction:))]];
    }
    
    if (self.ocjEnum_purposeType == OCJUserPurposeTypeRelevance) {
        self.title = @"关联账号";
    }
    
    [self ocj_initUI];//视图布局
}

- (void)ocj_initUI{
    
    [self.view addSubview:self.tableView];
    [self ocj_setTableView];
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
    
    if (self.ocjEnum_purposeType == OCJUserPurposeTypeLogin) {//登录时才有第三方登录区域，关联时无此区域
        self.ocjView_bottom = [[UIView alloc]init];
        [self.view addSubview:self.ocjView_bottom];
        [self ocj_setBottomView];
        CGFloat  width_ratio = SCREEN_WIDTH/375.0;
        [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(20);
            make.right.mas_equalTo(self.view).offset(-20);
            make.bottom.mas_equalTo(self.ocjBtn_help.mas_top).offset(-25 * width_ratio);
            make.height.mas_equalTo(90 * width_ratio);
        }];
    }
}

static NSString * cellIdentifier1 = @"defalutCell";//普通输入cell
static NSString * cellIdentifier2 = @"sliderCell";//滑动验证cell
static NSString * cellIdentifier3 = @"passwordCell";//密码输入cell
static NSString * cellIdentifier4 = @"codeCell";//验证码输入cell
-(void)ocj_setTableView{
    
    [self.tableView registerClass:[OCJLoginTypeTVCell class] forCellReuseIdentifier:cellIdentifier1];
    [self.tableView registerNib:[UINib nibWithNibName:@"OCJLockSliderTVCell" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [self.tableView registerClass:[OCJLoginTypeSendPwdTVCell class] forCellReuseIdentifier:cellIdentifier3];
    [self.tableView registerClass:[OCJLoginTypeSendCodeTVCell class] forCellReuseIdentifier:cellIdentifier4];
    
    if (self.ocjEnum_purposeType == OCJUserPurposeTypeLogin) {////登录时才有Logo，关联时logo
        self.tableView.tableHeaderView = [self ocj_createTableViewHeaderView];
    }
    
    self.tableView.tableFooterView = [self ocj_createTableViewFooterView];
}


- (UIView * )ocj_createTableViewHeaderView{
    CGFloat ratio = 375 / 140; ///< 头部空间宽高比

    UIView *  headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140 / ratio)];
    
    self.ocjImg_user = [[UIImageView alloc]init];
    [self.ocjImg_user setImage:[UIImage imageNamed:@"Icon_user_"]];
    self.ocjImg_user.layer.masksToBounds = YES;
    self.ocjImg_user.contentMode = UIViewContentModeScaleAspectFit;
    self.ocjImg_user.frame = CGRectMake((SCREEN_WIDTH - 80 * SCREENRATIO_HEIGHT)/2, 26 * SCREENRATIO_HEIGHT , 80 * SCREENRATIO_HEIGHT, 80 * SCREENRATIO_HEIGHT);
    [headerView addSubview:self.ocjImg_user];
    
    self.ocjLab_user = [[UILabel alloc]init];
    self.ocjLab_user.text = @"欢迎登录";
    self.ocjLab_user.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    self.ocjLab_user.font = [UIFont systemFontOfSize:17 * SCREENRATIO_WIDTH ];
    self.ocjLab_user.textAlignment = NSTextAlignmentCenter;
    self.ocjLab_user.frame = CGRectMake((SCREEN_WIDTH - 120)/2, self.ocjImg_user.frame.size.height + self.ocjImg_user.frame.origin.y + 10, 120 , 24 *  SCREENRATIO_HEIGHT);
    [headerView addSubview:self.ocjLab_user];
    
    return headerView;
}

- (UIView *)ocj_createTableViewFooterView{
    UIView *  footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    self.ocjBtn_main = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    self.ocjBtn_main.ocjBool_enable = NO;
    self.ocjBtn_main.frame = CGRectMake(20, 40 , SCREEN_WIDTH - 40, 45);
    [self.ocjBtn_main ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [self.ocjBtn_main addTarget:self action:@selector(ocj_mainBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.ocjBtn_main];

    BOOL isRelevance = (self.ocjEnum_purposeType == OCJUserPurposeTypeRelevance);
    NSString* mainBtnTitle = isRelevance?@"关  联":@"登  录";
    NSString* appendBtnTitle;
    switch (self.loginType) {
        case OCJLoginTypeDefault:{mainBtnTitle = @"确  认";}break;
        case OCJLoginTypeMedia_pwd:{appendBtnTitle = isRelevance?@"使用验证码关联":@"使用验证码登录";}break;
        case OCJLoginTypeMedia_code:{appendBtnTitle = isRelevance?@"使用密码关联":@"使用密码登录";}break;
        default:break;
    }
    [self.ocjBtn_main setTitle:mainBtnTitle forState:UIControlStateNormal];
    
    if (appendBtnTitle.length>0) {//设置新媒体用户手机登录时短信和验证码登录方式切换按钮
        OCJBaseButton * ocjBtn_append = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:ocjBtn_append];
        [ocjBtn_append setTitle:appendBtnTitle forState:UIControlStateNormal];
        ocjBtn_append.ocjFont = [UIFont systemFontOfSize:15];
        [ocjBtn_append setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
        [ocjBtn_append addTarget:self action:@selector(ocj_switchMobileLoginMethod:) forControlEvents:UIControlEventTouchUpInside];
        [ocjBtn_append mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(21);
            make.left.mas_equalTo(self.ocjBtn_main);
            make.right.mas_equalTo(self.ocjBtn_main);
            make.top.mas_equalTo(self.ocjBtn_main.mas_bottom).offset(15);
        }];
    }
    
    return footerView;
}

-(void)ocj_setBottomView{
    CGFloat  width_ratio = SCREEN_WIDTH/375.0;
    
    OCJBaseLabel * titleLabel = [OCJBaseLabel new];
    titleLabel.font = [UIFont systemFontOfSize:15 * width_ratio];
    titleLabel.textColor = OCJ_COLOR_LIGHT_GRAY;
    titleLabel.text = @"第三方登录";
    [self.ocjView_bottom addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjView_bottom.mas_centerX);
        make.top.mas_equalTo(self.ocjView_bottom).offset(IPHONE4?5:0);
        make.height.mas_equalTo(20);
    }];
    
    UIView * ocjView_left = [UIView new];
    ocjView_left.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [self.ocjView_bottom addSubview:ocjView_left];
    [ocjView_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel.mas_centerY);
        make.left.mas_equalTo(self.ocjView_bottom.mas_left);
        make.right.mas_equalTo(titleLabel.mas_left).offset(-10);
        make.height.mas_equalTo(1/2.0);
    }];
    
    UIView * ocjView_right = [UIView new];
    ocjView_right.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [self.ocjView_bottom addSubview:ocjView_right];
    [ocjView_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel.mas_centerY);
        make.left.mas_equalTo(titleLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.ocjView_bottom.mas_right);
        make.height.mas_equalTo(1/2.);
    }];
    
    NSMutableArray * iconArray  = [NSMutableArray arrayWithObjects:@"icon_qq",@"icon_alipay",@"icon_weibo", nil];
    NSMutableArray * titleArray = [NSMutableArray arrayWithObjects:@"QQ",@"支付宝",@"微博", nil];
    if ([WXApi isWXAppSupportApi]) {
      [iconArray insertObject:@"icon_wechat" atIndex:0];
      [titleArray insertObject:@"微信" atIndex:0];
    }
  
    CGFloat itemWidth = 35 * width_ratio;
    CGFloat margin = (SCREEN_WIDTH - 60 -  itemWidth * iconArray.count)/(iconArray.count-1);

    for (int i = 0; i < [iconArray count]; i++) {
        NSString* title = [titleArray objectAtIndex:i];
      
        OCJBaseButton * button = [OCJBaseButton buttonWithType:UIButtonTypeSystem];
        if ([title isEqualToString:@"微信"]) {
        
          button.tag = 1;
        }else if ([title isEqualToString:@"QQ"]){
        
          button.tag = 2;
        }else if ([title isEqualToString:@"支付宝"]){
        
          button.tag = 3;
        }else if ([title isEqualToString:@"微博"]){
        
          button.tag = 4;
        }
      
        [button addTarget:self action:@selector(ocj_thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.ocjView_bottom addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(itemWidth);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(10 + (margin + itemWidth) * i);
        }];
        
        UIImageView  * iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[iconArray objectAtIndex:i]]];
        iconView.layer.masksToBounds = YES;
        iconView.layer.cornerRadius = itemWidth/2;
        [button addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(button);
        }];
        
        OCJBaseLabel * ocjLabel_title = [OCJBaseLabel new];
        ocjLabel_title.font  = [UIFont systemFontOfSize:12 * width_ratio];
        ocjLabel_title.textAlignment = NSTextAlignmentCenter;
        ocjLabel_title.textColor = OCJ_COLOR_LIGHT_GRAY;
        ocjLabel_title.text = [titleArray objectAtIndex:i];
        [button addSubview:ocjLabel_title];
        [ocjLabel_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView).offset(-20);
            make.right.mas_equalTo(iconView).offset(20);
            make.top.mas_equalTo(iconView.mas_bottom).offset(4);
        }];
    }
}


/**
 logo移动动画
 */
- (void)ocj_logoAnimation{
     
     UIWindow * window = [UIApplication sharedApplication].keyWindow;
     CGRect ocjRect_old = [self.view convertRect:self.ocjImg_user.frame toView:window];
     [self.ocjImg_user removeFromSuperview];
     self.ocjImg_user.frame = ocjRect_old;
     [window addSubview:self.ocjImg_user];
     self.ocjLab_user.alpha = 0;

     [UIView animateWithDuration:0.25 animations:^{
         self.tableView.tableHeaderView = nil;
         self.ocjImg_user.frame = CGRectMake((SCREEN_WIDTH - 30)/2, 27, 30, 30);
     } completion:^(BOOL finished) {
         [self.ocjImg_user removeFromSuperview];
         self.navigationItem.titleView = self.ocjImg_user;
     }];
}

/**
 页面主按钮点击事件
 */
-(void)ocj_mainBtnAction{
    self.ocjTF_account.text = [self.ocjTF_account.text stringByReplacingOccurrencesOfString:@" " withString:@""];//清空空格
    
    switch (self.loginType) {
        case OCJLoginTypeDefault:{  [self ocj_checkAccountIDForUserType];}break;
        case OCJLoginTypeEmail:{    [self ocj_emailLogin];}break;
        case OCJLoginTypeMedia_pwd:{    [self ocj_mobileAndPasswordLogin];}break;
        case OCJLoginTypeMedia_code:{   [self ocj_mobileAndCodeLogin];}break;
        case OCJLoginTypeTv_mobile:{    [self ocj_mobileAndCodeAndNameLogin];}break;
        case OCJLoginTypeTv_Telephone:{ [self ocj_telephoneAndNameLogin];}break;
    }
  
  //==============埋点================
  NSString* eventID = @"AP1706C015F008002O008001";
  NSDictionary * parameters;
  switch (self.loginType) {
    case OCJLoginTypeDefault:{
      parameters = @{@"text":self.ocjTF_account.text,@"scene":@"0"};
    }break;
    case OCJLoginTypeEmail:{
      parameters = @{@"scene":@"1"};
    }break;
    case OCJLoginTypeMedia_pwd:{
      parameters = @{@"scene":@"2"};
    }break;
    case OCJLoginTypeMedia_code:{
      parameters = @{@"scene":@"3"};
    }break;
    case OCJLoginTypeTv_mobile:{
      parameters = @{@"scene":@"4"};
    }break;
    case OCJLoginTypeTv_Telephone:{
      parameters = @{@"scene":@"5"};
    }break;
  }
  
  [self ocj_trackEventID:eventID parmas:parameters];
  //================================
}

/**
 检测用户类型
 */
-(void)ocj_checkAccountIDForUserType{
  
  
    [OCJHttp_authAPI ocjAuth_checkUserTypeWithAccount:self.ocjTF_account.text completionHandler:^(OCJBaseResponceModel *responseModel) {
      
        OCJAuthModel_CheckID* model = (OCJAuthModel_CheckID*)responseModel;
        
        NSUInteger index = model.ocjStr_userType.length==1?[model.ocjStr_userType integerValue]:-1;
        ///< 0:不能识别 1：已注册过用户名 2.邮箱的用户 3.已注册过的手机用户 4.添加过手机的电视用户 5.未添加过手机的电视用户
        switch (index) {
            case 0:{
                [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeFailure title:@"您的账号尚未注册" message:nil sureButtonTitle:@"去注册" CancelButtonTitle:@"返回" action:^(NSInteger clickIndex) {
                    if (clickIndex == 1) {
                        BOOL isHaveRegisterPage = NO;
                        for (UIViewController* vc in self.navigationController.viewControllers) {
                          if ([vc isKindOfClass:[OCJQuickRegisterVC class]]) {
                            //返回登录页面并带回账户名
                            OCJQuickRegisterVC* registerVC = (OCJQuickRegisterVC*)vc;
                            registerVC.ocjStr_account = self.ocjTF_account.text;
                            registerVC.ocjStr_thirdPartyInfo = self.ocjStr_thirdPartyInfo;
                            isHaveRegisterPage = YES;
                            [self.navigationController popToViewController:vc animated:YES];
                            break;
                          }
                        }
                      
                        if (!isHaveRegisterPage) {
                            OCJQuickRegisterVC* registerVC = [[OCJQuickRegisterVC alloc]init];
                            registerVC.ocjStr_account = self.ocjTF_account.text;
                            registerVC.ocjStr_thirdPartyInfo = self.ocjStr_thirdPartyInfo;
                            [self ocj_pushVC:registerVC];
                        }
                    }
                }];
            }break;
            case 1:{self.loginType = OCJLoginTypeEmail;};break;
            case 2:{self.loginType = OCJLoginTypeEmail;}break;
            case 3:{self.loginType = OCJLoginTypeMedia_pwd;}break;
            case 4:{self.loginType = OCJLoginTypeTv_mobile;}break;
            case 5:{self.loginType = OCJLoginTypeTv_Telephone;}break;
            default:
                break;
        }
    }];
}


/**
 账户名／邮箱+密码登录
 */
- (void)ocj_emailLogin{
    if (self.ocjTF_account.text.length==0) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入正确的账户名" andHideDelay:2];
        return;
    }
    
    if (self.ocjTF_password.text.length==0) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入正确的密码" andHideDelay:2];
        return;
    }
    
    [OCJHttp_authAPI ocjAuth_loginWithID:self.ocjTF_account.text password:self.ocjTF_password.text thirdPartyInfo:self.ocjStr_thirdPartyInfo completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            if (self.navigationController.presentingViewController) {//进入app
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
                OCJAuthModel_login* model = (OCJAuthModel_login*)responseModel;
                if (model.ocjStr_mobile.length==0) {
                    //邮箱用户如果没绑定手机号，提示用户去绑定
                    __weak OCJBaseVC* vc = (OCJBaseVC*)[AppDelegate ocj_getTopViewController];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [OCJProgressHUD ocj_showAlertByVC:vc withAlertType:OCJAlertTypeSuccessBindTelephone title:@"请留手机号" message:@"让我们能更好的为您服务" sureButtonTitle:@"确定" CancelButtonTitle:@"下次再说" action:^(NSInteger clickIndex) {
                            if (clickIndex==1) {
                                OCJBindingModileVC* bindingVC = [[OCJBindingModileVC alloc]init];
                                bindingVC.ocjStr_internetID = model.ocjStr_internetId;
                                [vc ocj_pushVC:bindingVC];
                            }
                        }];
                    });
                }
            }
        }else if ([responseModel.ocjStr_code isEqualToString:@"1020100902"]){
            self.ocjInt_errorCount++;
            [self ocj_dealWithPasswordError];//密码错误提示
        }
        
        
        
    }];
}

/**
 手机号码+密码登录
 */
- (void)ocj_mobileAndPasswordLogin{
    if (![WSHHRegex wshh_isTelPhoneNumber:self.ocjTF_account.text]) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入有效的手机号码" andHideDelay:2];
        return;
    }
    
    [OCJHttp_authAPI ocjAuth_loginWithID:self.ocjTF_account.text password:self.ocjTF_password.text thirdPartyInfo:self.ocjStr_thirdPartyInfo completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            if (self.navigationController.presentingViewController) {//进入app
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }else if ([responseModel.ocjStr_code isEqualToString:@"1020100902"]){
            self.ocjInt_errorCount++;
            [self ocj_dealWithPasswordError];
        }
        
    }];
}

/**
 手机号码+验证码登录
 */
- (void)ocj_mobileAndCodeLogin{
    if (![WSHHRegex wshh_isTelPhoneNumber:self.ocjTF_account.text]) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入有效的手机号码" andHideDelay:2];
        return;
    }
    
    if (![WSHHRegex wshh_isSmsCode:self.ocjTF_code.text]) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入有效的验证码" andHideDelay:2];
        return;
    }
    
    [OCJHttp_authAPI ocjAuth_smscodeLoginWithMobile:self.ocjTF_account.text verifyCode:self.ocjTF_code.text purpose:OCJSMSPurpose_MobileLogin thirdPartyInfo:self.ocjStr_thirdPartyInfo completionHandler:^(OCJBaseResponceModel *responseModel) {
        if (self.navigationController.presentingViewController) {//进入app
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

/**
 手机号码+验证码+姓名登录
 */
- (void)ocj_mobileAndCodeAndNameLogin{
    if (![WSHHRegex wshh_isTelPhoneNumber:self.ocjTF_account.text]) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入有效的手机号码" andHideDelay:2];
        return;
    }
    
    if (![WSHHRegex wshh_isSmsCode:self.ocjTF_code.text]) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入有效的验证码" andHideDelay:2];
        return;
    }
    
    [OCJHttp_authAPI ocjAuth_loginWithMobileNum:self.ocjTF_account.text verifyCode:self.ocjTF_code.text customName:self.ocjTF_name.text custNo:nil internetID:self.ocjStr_internetID thirdPartyInfo:self.ocjStr_thirdPartyInfo completionHandler:^(OCJBaseResponceModel *responseModel) {
       
        OCJSetCellPhonePasswordVC * vc = [[OCJSetCellPhonePasswordVC alloc] init];
        [self ocj_pushVC:vc];
    }];
}

/**
 固话+姓名登录
 */
- (void)ocj_telephoneAndNameLogin{
    __weak OCJLoginVC* weakSelf = self;
    [OCJHttp_authAPI ocjAuth_verifyTVUserWithTelephone:self.ocjTF_account.text name:self.ocjTF_name.text completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJAuthModel_VerifyTVUser* model = (OCJAuthModel_VerifyTVUser*)responseModel;
        
        if ([model.ocjStr_code isEqualToString:@"200"]) {
            //拿到用户ID走安全校验
            OCJSecurityCheckVC* checkVC = [[OCJSecurityCheckVC alloc]init];
            checkVC.ocjStr_memberID = model.ocjStr_memberID;
            checkVC.ocjStr_custName = self.ocjTF_name.text;
            checkVC.ocjStr_account = self.ocjTF_account.text;
            checkVC.ocjStr_thirdPartyInfo = self.ocjStr_thirdPartyInfo;
            checkVC.ocjStr_mobile = model.ocjStr_mobile;
            [self ocj_pushVC:checkVC];
            
        }else if([model.ocjStr_code isEqualToString:@"1020100201"]){
            //无法锁定用户时
            [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeFailure title:model.ocjStr_message message:nil sureButtonTitle:@"联系客服" CancelButtonTitle:@"取消" action:^(NSInteger clickIndex) {
                if (clickIndex==1) {
                    //联系客服code
                    [weakSelf ocj_helpAction];
                }
            }];
        }
    }];
}

- (void)ocj_dealWithPasswordError{
    
    [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeFailure title:@"密码不正确" message:nil sureButtonTitle:@"取消" CancelButtonTitle:@"找回密码" action:^(NSInteger clickIndex) {
       
        switch (clickIndex) {
            case 0://找回密码
            {
                [self ocj_forgetPasswordAction];
              
            }break;
            case 1://取消
            {
              
            }break;
                
            default:
                break;
        }
    }];
    
}

/**
 切换新媒体手机用户登录方式<密码or验证码>
 */
- (void)ocj_switchMobileLoginMethod:(OCJBaseButton*)sender{
    NSString* methodStr = [sender titleForState:UIControlStateNormal];
    if ([methodStr containsString:@"使用验证码"]) {
        [self ocj_trackEventID:@"AP1706C015F010003A001001" parmas:nil];
        
        self.loginType = OCJLoginTypeMedia_code;
    }else if ([methodStr containsString:@"使用密码"]){
      
        [self ocj_trackEventID:@"AP1706C015F010002A001001" parmas:nil];
        
        self.loginType = OCJLoginTypeMedia_pwd;
    }
}

/**
 “遇到问题？东东帮你”点击事件
 */
- (void)ocj_helpAction{
  
    if (self.ocjEnum_purposeType == OCJUserPurposeTypeLogin) {
      
        [self ocj_trackEventID:@"AP1706C015F010004A001001" parmas:nil];
    }else if (self.ocjEnum_purposeType == OCJUserPurposeTypeRelevance){
      
        [self ocj_trackEventID:@"AP1706C014F010003A001001" parmas:nil];
    }

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://400-889-8000"]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://400-889-8000"]];
    }
    
}

/**
 “忘记密码”点击事件
 */
- (void)ocj_forgetPasswordAction{
    if (self.ocjEnum_purposeType == OCJUserPurposeTypeLogin) {
      
        [self ocj_trackEventID:@"AP1706C015F010001A001001" parmas:@{@"text":self.ocjTF_account.text}];
    }else if (self.ocjEnum_purposeType == OCJUserPurposeTypeRelevance){
      
        [self ocj_trackEventID:@"AP1706C014F010001A001001" parmas:@{@"text":self.ocjTF_account.text}];
    }

    OCJRetrievePwdVC *retrieveVC = [[OCJRetrievePwdVC alloc]init];
    retrieveVC.ocjStr_userName = self.ocjTF_account.text;
    [self ocj_pushVC:retrieveVC];
}

/**
 “获取验证码“点击事件
 */
- (void)ocj_sendSmsCodeAction{
    if (![WSHHRegex wshh_isTelPhoneNumber:self.ocjTF_account.text]) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入有效的手机号码" andHideDelay:2];
        return;
    }
  
  
    [self ocj_trackEventID:@"AP1706C015F008001O008001" parmas:nil];
  
    [self.ocjBtn_sendSms ocj_startTimer];
    
    NSString* smsPurpose = (self.loginType==OCJLoginTypeTv_mobile)?OCJSMSPurpose_TVUserBindingMobile:OCJSMSPurpose_MobileLogin;
    
    [OCJHttp_authAPI ocjAuth_SendSmscodeWithMobile:self.ocjTF_account.text purpose:smsPurpose internetID:nil completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJAuthModel_SendSms* model = (OCJAuthModel_SendSms*)responseModel;
        self.ocjStr_internetID = model.ocjStr_internetID;
    }];
}

/**
 第三方登录点击事件
 */
- (void)ocj_thirdLoginAction:(OCJBaseButton*)sender{
    NSInteger tag = sender.tag;
    
    __weak OCJLoginVC* weakSelf = self;
    
    switch (tag) {
        case 1://微信登录
        {
            [self ocj_trackEventID:@"AP1706C015C002001C002002" parmas:nil];
            
            [WSHHThirdPartyLogin wshh_thirdPartyLoginWithType:WSHHEnumThirdPartyWX andSignStr:nil block:^(id responseData) {
                if ([responseData isKindOfClass:[NSString class]]) {
                    NSString* wechatAccessToken = (NSString*)responseData;
                    if (wechatAccessToken.length>0) {
                        [OCJHttp_authAPI ocjAuth_thirdParty_getWechatOpenIDWithCode:wechatAccessToken completionHandler:^(OCJBaseResponceModel *responseModel) {
                            
                            [weakSelf ocj_checkThirdPartyBindingStatus:responseModel];
                        }];
                    }
                }
            }];
        }break;
        case 2://QQ登录
        {
          
            [self ocj_trackEventID:@"AP1706C015C002001C002003" parmas:nil];
            
            [WSHHThirdPartyLogin wshh_thirdPartyLoginWithType:WSHHEnumThirdPartyQQ andSignStr:nil block:^(id responseData) {
                if ([responseData isKindOfClass:[NSString class]]) {
                    NSString* qqAccessToken = (NSString*)responseData;
                    if (qqAccessToken.length>0) {
                        [OCJHttp_authAPI ocjAuth_thirdParty_getQQOpenIDWithCode:qqAccessToken completionHandler:^(OCJBaseResponceModel *responseModel) {
                            
                            [weakSelf ocj_checkThirdPartyBindingStatus:responseModel];
                            
                        }];
                    }
                }
            }];
        }break;
        case 3://支付宝登录
        {
          
            [self ocj_trackEventID:@"AP1706C015C002001C002004" parmas:nil];
            
            [OCJHttp_authAPI ocjAuth_thirdParty_getAlipaySecertCompletionHandler:^(OCJBaseResponceModel *responseModel) {
                OCJAuthModel_AlipaySecret* model = (OCJAuthModel_AlipaySecret*)responseModel;
                
                [WSHHThirdPartyLogin wshh_thirdPartyLoginWithType:WSHHEnumThirdPartyAlipay andSignStr:model.ocjStr_secret block:^(id responseData) {
                    
                    if ([responseData isKindOfClass:[NSString class]]) {
                        NSString* alipayAccessToken = (NSString*)responseData;
                        if (alipayAccessToken.length>0) {
                            [OCJHttp_authAPI ocjAuth_thirdParty_getAlipayOpenIDWithCode:alipayAccessToken completionHandler:^(OCJBaseResponceModel *responseModel) {
                                [weakSelf ocj_checkThirdPartyBindingStatus:responseModel];
                            }];
                        }
                    }
                    
                }];
            }];
        }break;
        case 4://微博登录
        {
          
            [self ocj_trackEventID:@"AP1706C015C002001C002005" parmas:nil];
          
            [WSHHThirdPartyLogin wshh_thirdPartyLoginWithType:WSHHEnumThirdPartyWeibo andSignStr:nil block:^(id responseData) {
                if ([responseData isKindOfClass:[NSString class]]) {
                    NSString* weiboAccessToken = (NSString*)responseData;
                    if (weiboAccessToken.length>0) {
                        [OCJHttp_authAPI ocjAuth_thirdParty_getWeiboOpenIDWithCode:weiboAccessToken completionHandler:^(OCJBaseResponceModel *responseModel) {
                            [weakSelf ocj_checkThirdPartyBindingStatus:responseModel];
                        }];
                    }
                }
            }];
        }break;
            
        default:
            break;
    }
    
}


/**
 处理第三方登录情况

 @param responseModel 接口响应模型
 */
- (void)ocj_checkThirdPartyBindingStatus:(OCJBaseResponceModel*)responseModel{
    
    OCJAuthModel_thirdPartyLogin* model = (OCJAuthModel_thirdPartyLogin*)responseModel;
    if ([model.ocjStr_associateState isEqualToString:@"0"]) {
        //去关联
        [self ocj_gotoRelevanceVCWithInfo:model.ocjStr_userMessage];
    }else if ([model.ocjStr_associateState isEqualToString:@"1"]){
        //进app
      if (self.navigationController.presentingViewController) {//进入app
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
      }
    }
}


/**
 推出第三方关联界面
 */
- (void)ocj_gotoRelevanceVCWithInfo:(NSString*)info{
    /*
     //本页面直接刷新
    self.ocjEnum_purposeType = OCJUserPurposeTypeRelevance;
    
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.titleView = nil;
    
    self.ocjTVCell_account = nil;
    
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    
    [self.ocjView_bottom removeFromSuperview];
    self.ocjView_bottom = nil;
    
    [self ocj_setSelf];
     */
    
    OCJLoginVC* vc = [[OCJLoginVC alloc]init];
    vc.ocjEnum_purposeType = OCJUserPurposeTypeRelevance;
    vc.ocjStr_thirdPartyInfo = info;
    [self ocj_pushVC:vc];
}


/**
 导航栏“快速注册”点击事件
 */
- (void)ocj_quickRegisterAction:(id)sender{
 
  BOOL isHaveRegisterPage = NO;
  for (UIViewController* vc in self.navigationController.viewControllers) {
    if ([vc isKindOfClass:[OCJQuickRegisterVC class]]) {
      //返回登录页面并带回账户名
      OCJQuickRegisterVC* registerVC = (OCJQuickRegisterVC*)vc;
      registerVC.ocjStr_account = self.ocjTF_account.text;
      registerVC.ocjStr_thirdPartyInfo = self.ocjStr_thirdPartyInfo;
      isHaveRegisterPage = YES;
      [self.navigationController popToViewController:vc animated:YES];
      break;
    }
  }
  
  if (!isHaveRegisterPage) {
    OCJQuickRegisterVC* registerVC = [[OCJQuickRegisterVC alloc]init];
    registerVC.ocjStr_account = self.ocjTF_account.text;
    registerVC.ocjStr_thirdPartyInfo = self.ocjStr_thirdPartyInfo;
    [self ocj_pushVC:registerVC];
  }
  
    [self ocj_trackEventID:@"AP1706C015C005001A001001" parmas:nil];
}

- (void)ocj_textFieldValueChange:(OCJBaseTextField *)sender{
  
    NSString* str = sender.text;
  
    if ([sender isEqual:self.ocjTF_account]) {
      
        if (self.loginType!=OCJLoginTypeDefault &&str.length<=0) {
            //其他情景页退回默认登录页
            self.loginType = OCJLoginTypeDefault;
        }
    }
  
    //登录页主按钮交互状态设置===============
    BOOL isEnable = NO;
    BOOL accountIsExist = (self.ocjTF_account.text.length>0);//账户名是否存在
    BOOL passwordIsExist = (self.ocjTF_password.text.length>0);//密码是否存在
    BOOL codeIsExist = (self.ocjTF_code.text.length>0);//验证码是否存在
    BOOL nameIsExist = (self.ocjTF_name.text.length>0);//姓名是否存在
    switch (self.loginType) {
        case OCJLoginTypeDefault:
        {//默认登录页面
            isEnable = accountIsExist;
        }break;
        case OCJLoginTypeEmail:case OCJLoginTypeMedia_pwd:
        {//邮箱+密码、手机+密码登录页面
            if(self.ocjBool_sliderShow) {
                isEnable = ( accountIsExist && passwordIsExist && self.ocjBool_sliderDone);
            }else{
                isEnable = (accountIsExist && passwordIsExist);
            }
        }break;
        case OCJLoginTypeMedia_code:
        {//手机+验证码登录页面
            isEnable = (accountIsExist && codeIsExist);
        }break;
        case OCJLoginTypeTv_mobile:
        {//手机+验证码+姓名登录页面
            isEnable = (accountIsExist && codeIsExist && nameIsExist);
        }break;
        case OCJLoginTypeTv_Telephone:
        {//固话+姓名登录页面
            isEnable = (accountIsExist && nameIsExist);
        }break;
    }
    self.ocjBtn_main.ocjBool_enable = isEnable;
    //===================================
    
}

#pragma mark - getter
-(OCJLoginTypeTVCell *)ocjTVCell_account{
    if (!_ocjTVCell_account) {
        _ocjTVCell_account = [[OCJLoginTypeTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _ocjTVCell_account.ocjTF_input.placeholder = @"请输入手机号/邮箱/用户名/固定电话";
        _ocjTVCell_account.ocjTF_input.delegate = self;
        [_ocjTVCell_account.ocjTF_input addTarget:self action:@selector(ocj_textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
        self.ocjTF_account = _ocjTVCell_account.ocjTF_input;
    }
    return _ocjTVCell_account;
}
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

- (TPKeyboardAvoidingTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - setter
-(void)setOcjInt_errorCount:(NSInteger)ocjInt_errorCount{
    _ocjInt_errorCount = ocjInt_errorCount;
    
    if (_ocjInt_errorCount>=3) {
        self.ocjBool_sliderShow = YES;
        self.ocjBool_sliderDone = NO;
        self.ocjBtn_main.ocjBool_enable = NO;
        [self.tableView reloadData];
    }
    
}

#pragma mark - 协议方法实现区域
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.loginType) {
        case OCJLoginTypeMedia_pwd:case OCJLoginTypeEmail:{
            if (self.ocjBool_sliderShow) {//滑动验证存在
                return 3;
            }
        }break;
        case OCJLoginTypeDefault:return 1;
        default:break;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:return 1;
        case 1:{
            if (self.loginType == OCJLoginTypeTv_mobile) {//电视会员==手机号
                return 2;
            }else{
                return 1;
            }
        };
        case 2:return 1;
        default:return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return self.ocjTVCell_account;
        }break;
        case 1:
        {
            switch (self.loginType) {
                case OCJLoginTypeEmail:
                {
                    OCJLoginTypeSendPwdTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
                    cell.ocjTF_pwd.text = @"";
                    [cell.ocjTF_pwd addTarget:self action:@selector(ocj_textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
                    self.ocjTF_password = cell.ocjTF_pwd;
                    
                    [cell.ocjBtn_forgetPwd addTarget:self action:@selector(ocj_forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }break;
                case OCJLoginTypeMedia_pwd:{
                    OCJLoginTypeSendPwdTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
                    cell.ocjTF_pwd.text = @"";
                    [cell.ocjTF_pwd addTarget:self action:@selector(ocj_textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
                    self.ocjTF_password = cell.ocjTF_pwd;
                    
                    [cell.ocjBtn_forgetPwd addTarget:self action:@selector(ocj_forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }break;
                case OCJLoginTypeMedia_code:{
                    OCJLoginTypeSendCodeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier4 forIndexPath:indexPath];
                    cell.ocjTF_input.text = @"";
                    [cell.ocjTF_input addTarget:self action:@selector(ocj_textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
                    self.ocjTF_code = cell.ocjTF_input;
                    __weak OCJLoginVC* weakSelf = self;
                    cell.ocjBtn_sendCode.ocjBlock_touchUpInside = ^{
                        [weakSelf ocj_sendSmsCodeAction];
                    };
                    self.ocjBtn_sendSms = cell.ocjBtn_sendCode;
                    return cell;
                }break;
                case OCJLoginTypeTv_mobile:{
                    if(indexPath.row == 0){
                        OCJLoginTypeSendCodeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier4 forIndexPath:indexPath];
                        cell.ocjTF_input.text = @"";
                        [cell.ocjTF_input addTarget:self action:@selector(ocj_textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
                        self.ocjTF_code = cell.ocjTF_input;
                        __weak OCJLoginVC* weakSelf = self;
                        cell.ocjBtn_sendCode.ocjBlock_touchUpInside = ^{
                            [weakSelf ocj_sendSmsCodeAction];
                        };
                        self.ocjBtn_sendSms = cell.ocjBtn_sendCode;
                        return cell;
                    }else{
                        OCJLoginTypeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
                        cell.ocjTF_input.placeholder = @"请输入姓名";
                        cell.ocjTF_input.text = @"";
                        [cell.ocjTF_input addTarget:self action:@selector(ocj_textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
                        self.ocjTF_name = cell.ocjTF_input;
                        return cell;
                    }
                }break;
                case OCJLoginTypeTv_Telephone:{
                    OCJLoginTypeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                    cell.ocjTF_input.placeholder = @"请输入姓名";
                    cell.ocjTF_input.text = @"";
                    [cell.ocjTF_input addTarget:self action:@selector(ocj_textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
                    self.ocjTF_name = cell.ocjTF_input;
                    return cell;
                }break;
                default:return nil;
            }
        }break;
        case 2:
        {
            OCJLockSliderTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
            [cell ocj_resetSlider:OCJLockSliderEnumTips];
            cell.ocjDelegate = self;
            return cell;
        }break;
        default:return nil;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:return 70;
        case 1:{
            if (self.loginType == OCJLoginTypeMedia_pwd || self.loginType == OCJLoginTypeEmail) {//邮箱或手机密码登录时
                return 80;
            }else{
                return 70;
            }
        };
        case 2:return 90;
        default:return 0;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.tableView.tableHeaderView) {
        //当logo处于tableView头视图中的时候，执行logo位移动画
        [self ocj_logoAnimation];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //输入框限制规则书写处
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if ([textField isEqual:self.ocjTF_account]) {
        self.loginType = OCJLoginTypeDefault;
    }
    
    return YES;
}

#pragma mark - OCJLockSliderTVCellDelegete
-(void)ocj_sliderCheckDone{
    //验证完成
    self.ocjBool_sliderDone = YES;
    //登录页主按钮交互状态设置===============
    BOOL accountIsExist = (self.ocjTF_account.text.length>0);//账户名是否存在
    BOOL passwordIsExist = (self.ocjTF_password.text.length>0);//密码是否存在
    self.ocjBtn_main.ocjBool_enable = (accountIsExist && passwordIsExist && self.ocjBool_sliderDone);
    //==================================
}

-(void)ocj_sliderCheckCancel{
    self.ocjBool_sliderDone = NO;
    //登录页主按钮交互状态设置===============
    BOOL accountIsExist = (self.ocjTF_account.text.length>0);//账户名是否存在
    BOOL passwordIsExist = (self.ocjTF_password.text.length>0);//密码是否存在
    self.ocjBtn_main.ocjBool_enable = (accountIsExist && passwordIsExist && self.ocjBool_sliderDone);
}

@end
