//
//  OCJSettingCenterVC.m
//  OCJ
//
//  Created by Ray on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSettingCenterVC.h"
#import "OCJSettingConmonCell.h"
#import "OCJPersonalInformationVC.h"
#import "OCJManageAddressVC.h"
#import "OCJEditAddressVC.h"
#import "UIViewController+WSHHExtension.h"
#import "OCJSuggestFeedBackVC.h"
#import "OCJSetFontVC.h"
#import "OCJModifyPwdVC.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "OCJFontView.h"
#import "OCJFontAdapter.h"
#import "OCJResModel_personalInfo.h"
#import "OCJEvaluateVC.h"
#import "OCJScanJumpWebVC.h"
#import "OCJAppointmentOrderVC.h"
#import "OCJVideoComingVC.h"
#import "OCJMySugFeedBackVC.h"
#import "OCJProvincePageVC.h"

#import "UIImageView+WebCache.h"
#import "OCJBaseTableView.h"

#import "OCJHttp_personalInfoAPI.h"
#import "OCJHttp_authAPI.h"

@interface OCJSettingCenterVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_setting;///<tableView

@property (nonatomic, strong) NSArray *ocjArr_dataSource;///<数据源

@property (nonatomic, strong) UIImageView *ocjImgView_portrait;///<头像

@property (nonatomic, strong) UISwitch *ocjBtn_switch;///<开启指纹验证

@property (nonatomic, assign) NSInteger ocjInt_touchIDErrorCode;///<touchIDErrorCode
@property (nonatomic) BOOL ocjBOOL_isOpenTouchID;///<是否开启touchID

@property (nonatomic, strong) OCJPersonalModel_memberInfo *ocjModel_memberInfo;///<会员信息model
@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;             ///<状态栏颜色

@end

@implementation OCJSettingCenterVC

#pragma mark - 接口方法实现区域(包括setter、getter方法)


#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.ocjStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:self.ocjStatusBarStyle];
  
  self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
}

#pragma mark - 私有方法区域
- (void)ocj_loginedAndLoadNetWorkData{
    [self ocj_requestMemberInfo:nil];
}

- (void)ocj_setSelf {
    self.title = @"设置";
    self.ocjStr_trackPageID = @"AP1706C055";
    self.ocjBOOL_isOpenTouchID = NO;
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSystemFont:) name:@"SysetmFontChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocj_reloadMemberInfo:) name:OCJ_Notification_personalCenter object:nil];
    [self ocj_addTableView];
    [self ocj_requestMemberInfo:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 收到通知修改字体大小
 */
- (void)changeSystemFont:(NSNotification *)nostification{
    [self ocj_setSelf];
}

/**
 修改信息回来后重新加载数据
 */
- (void)ocj_reloadMemberInfo:(NSNotification *)noti {
    [self ocj_requestMemberInfo:nil];
}

/**
 请求数据
 */
- (void)ocj_requestMemberInfo:(void(^)())completion {
    [OCJHttp_personalInfoAPI ocjPersonal_checkMenberInfoCompletionHandler:^(OCJBaseResponceModel *responseModel) {
        self.ocjModel_memberInfo = (OCJPersonalModel_memberInfo *)responseModel;
        
        NSString * ocjStr_mobile = [NSString stringWithFormat:@"%@%@%@",self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_mobile,self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_mobile1,self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_mobile2];
        
        NSDictionary * ocjDic_user = @{@"userName":self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_nickName,@"userMobile":ocjStr_mobile,@"userHeader":self.ocjModel_memberInfo.ocjStr_headPortrait,@"userAccount":self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_userName};
        
        [[NSUserDefaults standardUserDefaults] setValue:ocjDic_user forKey:OCJ_USERMODEL_KEY];
        
        [self.ocjTBView_setting reloadData];
    }];
}

/**
 tableView
 */
- (void)ocj_addTableView {
    self.ocjTBView_setting = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.ocjTBView_setting.delegate = self;
    self.ocjTBView_setting.dataSource = self;
    self.ocjTBView_setting.showsVerticalScrollIndicator = NO;
    self.ocjTBView_setting.tableFooterView = [[UIView alloc] init];
    self.ocjTBView_setting.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_setting];
}

/**
 用户信息cell
 */
//SDWebImageManager 160行  if (options & SDWebImageRefreshCached) downloaderOptions &= ~SDWebImageDownloaderUseNSURLCache;
- (void)ocj_addUserMessageCell:(UITableViewCell *)cell {
    //头像
    self.ocjImgView_portrait = [[UIImageView alloc] init];
    [self.ocjImgView_portrait sd_setImageWithURL:[NSURL URLWithString:self.ocjModel_memberInfo.ocjStr_headPortrait] placeholderImage:[UIImage imageNamed:@"Icon_user_"] options:SDWebImageRefreshCached completed:nil];
    self.ocjImgView_portrait.layer.cornerRadius = 30;
    self.ocjImgView_portrait.layer.masksToBounds = YES;
    
    [cell.contentView addSubview:self.ocjImgView_portrait];
    [self.ocjImgView_portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(cell.contentView);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@60);
    }];
    
    //昵称
    OCJBaseLabel *ocjLab_nickName = [[OCJBaseLabel alloc] init];
    ocjLab_nickName.textColor = OCJ_COLOR_DARK;
    ocjLab_nickName.font = [UIFont systemFontOfSize:14];
    ocjLab_nickName.textAlignment = NSTextAlignmentLeft;
    ocjLab_nickName.text = self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_nickName;
    [cell.contentView addSubview:ocjLab_nickName];
    [ocjLab_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImgView_portrait.mas_right).offset(10);
        make.top.mas_equalTo(cell.contentView.mas_top).offset(16);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-38);
        make.height.mas_equalTo(@20);
    }];
    
    //用户名
    OCJBaseLabel *ocjLab_useName = [[OCJBaseLabel alloc] init];
    ocjLab_useName.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_useName.font = [UIFont systemFontOfSize:14];
    ocjLab_useName.textAlignment = NSTextAlignmentLeft;
    ocjLab_useName.text = [NSString stringWithFormat:@"用户名：%@", self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_userName];
    [cell.contentView addSubview:ocjLab_useName];
    [ocjLab_useName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjLab_nickName.mas_left);
        make.top.mas_equalTo(ocjLab_nickName.mas_bottom).offset(3);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@20);
    }];
}


/**
 touchIDcell
 */
- (void)ocj_addOpenTouchIDCell:(UITableViewCell *)cell {
    self.ocjBtn_switch = [[UISwitch alloc] init];
    [self.ocjBtn_switch addTarget:self action:@selector(ocj_clickedTouchIDBtn:) forControlEvents:UIControlEventValueChanged];
  //是否已开启touchID
  NSString *ocjStr_touchID = [[NSUserDefaults standardUserDefaults] valueForKey:@"TOUCHID"];
  if ([ocjStr_touchID isEqualToString:@"TouchIDOK"]) {
    self.ocjBtn_switch.on = YES;
    self.ocjBOOL_isOpenTouchID = YES;
  }else {
    self.ocjBtn_switch.on = NO;
    self.ocjBOOL_isOpenTouchID = NO;
  }
  
    [cell.contentView addSubview:self.ocjBtn_switch];
    [self.ocjBtn_switch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-15);
//        make.width.mas_equalTo(@20);
//        make.height.mas_equalTo(@20);
    }];
    
    OCJBaseLabel *ocjLab_title = [[OCJBaseLabel alloc] init];
    ocjLab_title.textColor = OCJ_COLOR_DARK;
    ocjLab_title.font = [UIFont systemFontOfSize:14];
    ocjLab_title.textAlignment = NSTextAlignmentLeft;
    ocjLab_title.text = @"开启Touch ID指纹解锁";
    [cell.contentView addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(cell.contentView);
        make.right.mas_equalTo(self.ocjBtn_switch.mas_left).offset(-10);
        make.height.mas_equalTo(@22);
    }];
}

/**
 检查设备是否支持touchID
 */
- (BOOL)ocj_checkIsSupportTouchID {
  if ([[self ocj_getSystemVersion] integerValue] > 9.0) {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        OCJLog(@"error = %@", error);
        if (error.code == -7) {
            OCJLog(@"未设置指纹");
            self.ocjInt_touchIDErrorCode = error.code;
            return NO;
        }
    }else {
        return YES;
    }
    
  }
  return NO;
}

/**
 指纹信息变更后需要对比本地指纹信息

 @param newData 新的指纹信息
 */
- (void)ocj_compareTouchIDWithNewData:(NSData *)newData {
    NSData *localData = [[NSUserDefaults standardUserDefaults] valueForKey:@"touchIDData"];
    
    if (localData == nil) {
        self.ocjBOOL_isOpenTouchID = YES;
        self.ocjBtn_switch.on = YES;
        [OCJProgressHUD ocj_showHudWithTitle:@"首次验证成功" andHideDelay:2.0];
      [[NSUserDefaults standardUserDefaults] setValue:@"TouchIDOK" forKey:@"TOUCHID"];
    }else {
        if ([[self ocj_getSystemVersion] integerValue] > 9.0) {
            if ([localData isEqualToData:newData]) {
                self.ocjBOOL_isOpenTouchID = YES;
                self.ocjBtn_switch.on = YES;
                [OCJProgressHUD ocj_showHudWithTitle:@"对比验证成功" andHideDelay:2.0];
              [[NSUserDefaults standardUserDefaults] setValue:@"TouchIDOK" forKey:@"TOUCHID"];
            }else {
                self.ocjBOOL_isOpenTouchID = NO;
                self.ocjBtn_switch.on = NO;
                [OCJProgressHUD ocj_showHudWithTitle:@"指纹信息变更，请重新验证" andHideDelay:2.0];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:newData forKey:@"touchIDData"];
}
/**
 指纹认证
 */
- (void)ocj_loadAuthentication {
    __weak OCJSettingCenterVC *weakSelf = self;
    LAContext *myContext = [[LAContext alloc] init];
    //指纹认证失败（3次认证未通过）弹出框选项
    myContext.localizedFallbackTitle = @"密码验证";
    
    NSString *myLocallizeReasonString = @"请按住Home键完成验证";
    
    [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocallizeReasonString reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            //验证成功，回到主线程，否则会卡顿
            dispatch_sync(dispatch_get_main_queue(), ^{
                //9.0以后才能使用此方法
                if ([[self ocj_getSystemVersion] integerValue] > 9.0) {
                    NSData *data = myContext.evaluatedPolicyDomainState;
                    
                    [self ocj_compareTouchIDWithNewData:data];
                }else {
                    self.ocjBtn_switch.on = YES;
                    [OCJProgressHUD ocj_showHudWithTitle:@"指纹认证成功" andHideDelay:2.0];
                  [[NSUserDefaults standardUserDefaults] setValue:@"TouchIDOK" forKey:@"TOUCHID"];
                }
            });
        }
        if (error) {
            //认证失败，回到主线程
            dispatch_sync(dispatch_get_main_queue(), ^{
                LAError errorCode = error.code;
                self.ocjBtn_switch.on = NO;
                self.ocjBOOL_isOpenTouchID = NO;
                OCJLog(@"123123123123123");
                
                switch (errorCode) {
                    case LAErrorAuthenticationFailed:
                        // -1 连续3次指纹识别错误
                        [OCJProgressHUD ocj_showHudWithTitle:@"授权失败" andHideDelay:2.0];
                        break;
                    case LAErrorUserCancel:
                        NSLog(@"用户取消验证!!!");// -2 点击了取消按钮
                        break;
                    case LAErrorUserFallback:
                        //用户选择密码验证，切换到主线程处理 -3
                        [weakSelf ocj_clickedTouchIDAlertOtherBtn];
                        break;
                    case  LAErrorSystemCancel:
                        //系统取消授权，如其他应用切入 -4
                        NSLog(@"系统取消授权");
                        break;
                    case LAErrorPasscodeNotSet:
                        //设备系统未设置密码 -5
                        NSLog(@"设备系统未设置密码");
                        break;
                    case LAErrorTouchIDNotAvailable:
                        //设备未设置touchID -6
                        NSLog(@"设备未设置touchID");
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        //用户未录入指纹 -7
                        NSLog(@"用户未录入指纹");
                        break;
                    case LAErrorTouchIDLockout:
                        //touchID被锁，需要用户输入密码解锁 -8(连续五次指纹识别错误)
                        NSLog(@"touchID被锁，需要用户输入密码解锁");
                        //弹出输入密码解锁界面(iOS9以后可用)
                        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil]) {
                            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:myLocallizeReasonString reply:^(BOOL success, NSError * _Nullable error) {
                                if (success) {
                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                        //密码解锁成功
                                        
                                    });
                                    
                                }
                            }];
                        }
                        break;
                    case LAErrorInvalidContext:
                        //LAContext传递给这个调用之前已经失效 -10
                        NSLog(@"LAContext传递给这个调用之前已经失效");
                        break;
                        
                    default:
                        break;
                }
            });
        }
    }];
}

/**
 指纹验证失败(第一次、第二次时)点击其他按钮
 */
- (void)ocj_clickedTouchIDAlertOtherBtn {
    OCJLog(@"密码登录");
}

#pragma mark - 点击事件
/**
 点击touchIDBtn
 */
- (void)ocj_clickedTouchIDBtn:(UISwitch *)swich {
  
    self.ocjBOOL_isOpenTouchID = !self.ocjBOOL_isOpenTouchID;
  
    if (![self ocj_checkIsSupportTouchID] && self.ocjInt_touchIDErrorCode == -7) {
        
        self.ocjBtn_switch.on = NO;
        [OCJProgressHUD ocj_showHudWithTitle:@"您的手机未设置指纹" andHideDelay:2.0];
        
    }else if (![self ocj_checkIsSupportTouchID]) {
        
        self.ocjBtn_switch.on = NO;
        [OCJProgressHUD ocj_showHudWithTitle:@"您的手机不支持指纹登录" andHideDelay:2.0];
    }else if ([self ocj_checkIsSupportTouchID]) {//支持指纹认证
        self.ocjBtn_switch.on = NO;
        if (self.ocjBOOL_isOpenTouchID) {//已开启指纹认证
            
            [self ocj_loadAuthentication];
        }else {
          [[NSUserDefaults standardUserDefaults] setValue:@"TouchIDFail" forKey:@"TOUCHID"];
        }
    }
}

- (void)ocj_back {
  [self ocj_trackEventID:@"AP1706C055D003001C003001" parmas:nil];
  [super ocj_back];
}

/**
 点击退出登录按钮
 */
- (void)ocj_clickedLoginOutBtn{
  [self ocj_trackEventID:@"AP1706C055D010009C010001" parmas:nil];
    //退出登录接口
    [OCJHttp_authAPI ocjAuth_LoginOutCompletionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (NSString *)calculateCacheSize{
  
    SDImageCache * cache = [SDImageCache sharedImageCache];
    NSString * cacheSize = @"";
    if ([cache getSize]/1024/2024 < 1) {
        cacheSize = [NSString stringWithFormat:@"%.02fM",[cache getSize]/1024.00/1024.00];;
    }else{
        cacheSize = [NSString stringWithFormat:@"%.02fM",[cache getSize]/1024.00/1024.00];;
    }
    return cacheSize;
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ocjArr_dataSource.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == self.ocjArr_dataSource.count + 1) {
        return 1;
    }
  
    return [[self.ocjArr_dataSource objectAtIndex:section - 1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"OCJSettingConmonCell";
    OCJSettingConmonCell *commonCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (indexPath.section == 0) {
      
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self ocj_addUserMessageCell:cell];
        return cell;
      
    }else if (indexPath.section == self.ocjArr_dataSource.count + 1) {
      
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        OCJBaseButton *ocjBtn_loginOut = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, 45)];
        [ocjBtn_loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
        [ocjBtn_loginOut setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
        [ocjBtn_loginOut ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
        ocjBtn_loginOut.ocjFont = [UIFont systemFontOfSize:17];
        ocjBtn_loginOut.layer.cornerRadius = 2;
        [ocjBtn_loginOut addTarget:self action:@selector(ocj_clickedLoginOutBtn) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        [cell.contentView addSubview:ocjBtn_loginOut];
        return cell;
      
    }else {
      
        if (indexPath.section == 2 && indexPath.row == 2) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self ocj_addOpenTouchIDCell:cell];
            return cell;
        }
      
        NSString *title = [[self.ocjArr_dataSource objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
        commonCell = [[OCJSettingConmonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //最后一个cell隐藏底部横线
        if (indexPath.row == [self.ocjArr_dataSource[indexPath.section - 1] count] - 1) {
            commonCell.ocjView_line.hidden = YES;
        }else {
            commonCell.ocjView_line.hidden = NO;
        }
      
        if ([title isEqualToString:@"关于版本"]) {
            commonCell.accessoryType = UITableViewCellAccessoryNone;
          
            OCJBaseLabel *ocjLab_version = [[OCJBaseLabel alloc] init];
            ocjLab_version.textColor = OCJ_COLOR_DARK_GRAY;
            ocjLab_version.textAlignment = NSTextAlignmentRight;
            ocjLab_version.font = [UIFont systemFontOfSize:14];
            ocjLab_version.text = [NSString stringWithFormat:@"V%@", [self ocj_getAppVersion]];
            [commonCell.contentView addSubview:ocjLab_version];
            [ocjLab_version mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(commonCell.contentView);
                make.right.mas_equalTo(commonCell.contentView.mas_right).offset(-20);
            }];
          
        }else if(indexPath.section ==2 && indexPath.row ==1){//清除缓存
          
            OCJBaseLabel *ocjLab_version = [[OCJBaseLabel alloc] init];
            ocjLab_version.textColor = OCJ_COLOR_DARK_GRAY;
            ocjLab_version.textAlignment = NSTextAlignmentRight;
            ocjLab_version.tag = 10000;
            ocjLab_version.font = [UIFont systemFontOfSize:14];
            if ([[self calculateCacheSize]floatValue] == 0.00) {
                ocjLab_version.text = @"";
            }else{
                ocjLab_version.text = [NSString stringWithFormat:@"%@", [self calculateCacheSize]];
            }
            [commonCell.contentView addSubview:ocjLab_version];
            [ocjLab_version mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerY.mas_equalTo(commonCell.contentView);
              make.right.mas_equalTo(commonCell.contentView.mas_right);
            }];
          
          //设置字体
//          if (indexPath.section == 2 && indexPath.row == 0) {
//            commonCell.accessoryType = UITableViewCellAccessoryNone;
//            commonCell.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
////            commonCell.ocjLab_title.textColor = OCJ_COLOR_LIGHT_GRAY;
//          }
        }
        
        [commonCell ocj_setTitle:title];
        return commonCell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 4) {
        return 65;
    }else if (indexPath.section == 2) {
        if (indexPath.row == 4) {
            return 60;
        }
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    return footView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = @"" ;
    if (indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3) {
        title = [[self.ocjArr_dataSource objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
    }
  
    if (indexPath.section == 0) {
        [self ocj_trackEventID:@"AP1706C055D010001C010001" parmas:nil];
        OCJPersonalInformationVC *personalInfoVC = [[OCJPersonalInformationVC alloc] init];
        personalInfoVC.ocjModel_memberInfo = self.ocjModel_memberInfo;
        [self ocj_pushVC:personalInfoVC];
      
    }else if (indexPath.section == 1) {
      
        if (indexPath.row == 0) {//修改密码
          [self ocj_trackEventID:@"AP1706C055D010002C010001" parmas:nil];
            OCJModifyPwdVC *modifyPWDVC = [[OCJModifyPwdVC alloc] init];
            [self ocj_pushVC:modifyPWDVC];
          
        }else {//地址管理
          [self ocj_trackEventID:@"AP1706C055D010003C010001" parmas:nil];
            OCJManageAddressVC *addressVC = [[OCJManageAddressVC alloc] init];
            [self ocj_pushVC:addressVC];
          
        }
      
    }else if (indexPath.section == 2) {
      
        if ([title isEqualToString:@"微信有礼"]) {//微信有礼

          [self ocj_trackEventID:@"AP1706C055D010005C010001" parmas:nil];
            OCJScanJumpWebVC *webVC = [[OCJScanJumpWebVC alloc] init];
            webVC.ocjEnumWebViewType = OCJEnumWebViewLodingTypeHtmlUrl;
            webVC.ocjStr_title = @"微信有礼";
            webVC.ocjStr_qrcode = @"http://m.ocj.com.cn/image_site/event/2014/10/ocjfw_rule/index.html";
            [self ocj_pushVC:webVC];
          
        }else if ([title isEqualToString:@"清除缓存"]) {//清除缓存

          [self ocj_trackEventID:@"AP1706C055D010006C010001" parmas:nil];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"APPClearCache" object:nil];
            [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
                [WSHHAlert wshh_showHudWithTitle:@"清除缓存成功" andHideDelay:1.0f];
                OCJSettingConmonCell * cell = (OCJSettingConmonCell *)[tableView cellForRowAtIndexPath:indexPath];
                UILabel * ocjLab_title = (OCJBaseLabel *)[cell viewWithTag:10000];
                ocjLab_title.hidden = YES;
            }];
            NSURLCache *urlCache = [NSURLCache sharedURLCache];
            [urlCache removeAllCachedResponses];
        }
      
    }else if (indexPath.section == 3) {
      
        if ([title isEqualToString:@"企业官网"]) {
            [self ocj_trackEventID:@"AP1706C055D010007C010001" parmas:nil];

            OCJScanJumpWebVC *webVC = [[OCJScanJumpWebVC alloc] init];
            webVC.ocjEnumWebViewType = OCJEnumWebViewLodingTypeHtmlUrl;
            webVC.ocjStr_title = @"企业官网";
            webVC.ocjStr_qrcode = @"http://mcompany.ocj.com.cn/";
            [self ocj_pushVC:webVC];
          
        }else if ([title isEqualToString:@"我要给好评"]) {

          NSString * ocjStr_appStoreURLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=524637490"];
          [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ocjStr_appStoreURLString]];
          if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:ocjStr_appStoreURLString]]){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ocjStr_appStoreURLString]];
          }else{
            [WSHHAlert wshh_showHudWithTitle:@"无法打开appStore评论页面" andHideDelay:1];
          }
          
        }else if ([title isEqualToString:@"我要提意见"]) {

          [self ocj_pushVC:[[OCJMySugFeedBackVC alloc]init]];
          
        }else {//关于版本
            
        }
    }else {//退出登录cell
        
    }
}

- (NSString *)ocj_getAppVersion {
    NSDictionary *bundle = [[NSBundle mainBundle] infoDictionary];
    return [bundle objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)ocj_getSystemVersion {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return systemVersion;
}

#pragma mark - getter
-(NSArray *)ocjArr_dataSource{
  if (!_ocjArr_dataSource) {

      NSArray* array = @[@[@"修改密码",@"收货地址管理"],@[@"微信有礼",@"清除缓存",@"开启Touch ID指纹解锁"],@[@"企业官网",@"我要提意见",@"关于版本"]];
    
      BOOL isShowGotoAppstore = [[NSUserDefaults standardUserDefaults]boolForKey:@"ocjIsShowGotoAppstore"];
      if (isShowGotoAppstore) {
          NSMutableArray* mArray = [array[2] mutableCopy];
          [mArray insertObject:@"我要给好评" atIndex:1];
      
          NSMutableArray* dataMArray = [array mutableCopy];
          [dataMArray replaceObjectAtIndex:2 withObject:mArray];
          array = [dataMArray copy];
      }
    
      _ocjArr_dataSource = array;

  }
  
  return _ocjArr_dataSource;
}

@end
