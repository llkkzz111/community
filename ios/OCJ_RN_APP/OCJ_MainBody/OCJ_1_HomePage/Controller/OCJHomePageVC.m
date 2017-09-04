//
//  OCJHomePageVC.m
//  OCJ
//
//  Created by yangyang on 17/4/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//
#import "OCJHomePageVC.h"
#import "AppDelegate.h"
#import "OCJFontAdapter.h"
#import "OCJAddressSheetView.h" //地址
#import "OCJSharePopView.h"     //分享
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "MethodManager.h"

#import "OCJAssistiveTouch.h"
#import "OCJSignInTipVC.h"
#import "OCJAppStoreViewController.h"
#import "OJCLotteryVC.h"
#import "OCJUpdateViewController.h"

#import "OCJHttp_signInAPI.h"
#import "OCJHttp_authAPI.h"
#import "OCJMySugFeedBackVC.h"
#import <AFNetworking.h>


#if DEBUG
#define SIMULATOR 1
#else
#define SIMULATOR 0
#endif


@interface OCJHomePageVC ()
{
  UIView *rootView;
  NSUInteger _index;
}

@property (nonatomic,strong) OCJAssistiveTouch* ocjView_touch; ///< 小鸟签到按钮

@property (nonatomic,strong) UIButton* ocjBtn_toSuggestion; ///< 去意见反馈界面

@property (nonatomic)  BOOL ocjBool_isHasWaitingSign; ///< 是否有等待中的查询签到情况请求

@end

@implementation OCJHomePageVC
#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self ocj_setSelf];
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
  self.tabBarController.tabBar.hidden = YES;
  
  //e.g 升级
  [self ocj_addUpdateVC];
}

#pragma mark - 私有方法区域

-(void)ocj_setSelf{
  
  NSString * memberToken = [[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken];
  NSString * guestToken  = [[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken_guest];
  
  if (memberToken.length==0 && guestToken.length==0) {
    [self ocj_monitorNetworkStatus];
  }else{
    [self ocj_checkAccessToken];
  }
  
  [self ocj_getCurrentLocation];
  
  [self loadRN];
  
  self.ocjCallback = nil;
}

-(void)loadRN{
  
  NSURL * jsCodeLocation;
  if (SIMULATOR ==1) {


    jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios"];

  }else{
  
    jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
  }

  BOOL type = true;
  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL : jsCodeLocation
                                               moduleName        : @"OCJ_RN_APP"
                                               initialProperties : @{@"type":@(!type)}
                                                launchOptions    : nil];
  self.view = rootView;
  
}

#pragma mark app更新提醒
- (void)ocj_addUpdateVC{
  NSString *ocjStr_remind = [[NSUserDefaults standardUserDefaults] objectForKey:@"noremind"];
  [OCJHttp_authAPI ocjAuth_checkAppVersionCompletionHandler:^(OCJBaseResponceModel *responseModel) {
      OCJAuthModel_checkVersion* model = (OCJAuthModel_checkVersion*)responseModel;

      if ([model.ocjStr_isNeedUpdate isEqualToString:@"1"]) {//强更
      
        OCJUpdateViewController *oCJUpdateViewController = [[OCJUpdateViewController alloc] init];
        oCJUpdateViewController.ocjEnum_updateType = OCJUpdateTypeHard;
        NSArray *items = @[model.ocjStr_updateMessage];
        oCJUpdateViewController.items = items;
        oCJUpdateViewController.appstoreUrl = model.ocjStr_jumpUrl;
        oCJUpdateViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        oCJUpdateViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:oCJUpdateViewController animated:NO completion:nil];
      }else if ([model.ocjStr_isNeedUpdate isEqualToString:@"2"] && ![ocjStr_remind isEqualToString:@"noremind"]){//软更
        
        OCJUpdateViewController *oCJUpdateViewController = [[OCJUpdateViewController alloc] init];
        oCJUpdateViewController.ocjEnum_updateType = OCJUpdateTypeSoft;
        NSArray *items = @[model.ocjStr_updateMessage];
        oCJUpdateViewController.items = items;
        oCJUpdateViewController.appstoreUrl = model.ocjStr_jumpUrl;
        oCJUpdateViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        oCJUpdateViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:oCJUpdateViewController animated:NO completion:nil];
        [[NSUserDefaults standardUserDefaults] setValue:@"noremind" forKey:@"noremind"];
        
      }
    
      if ([model.ocjStr_prompt_comment isEqualToString:@"Y"]) {//开启评分引导
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [self makeAppstoreView];
              [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ocjIsShowGotoAppstore"];//控制设置-《我要给好评》功能开启
          });
      }
      
  }];

}

#pragma mark 每次调用仅返回一次结果
- (void)ocj_getCurrentLocation{
  //获取地址和经纬度
  [OCJAssistiveTouch ocj_classGetLocation:^(NSDictionary *ad, NSDictionary *local) {
    OCJLog(@"地址：%@===坐标：%@", ad, local);
    NSMutableDictionary * mDic = [NSMutableDictionary dictionary];
    [mDic setValue:ad[@"State"] forKey:@"province"];
    [mDic setValue:ad[@"City"] forKey:@"city"];
    [mDic setValue:ad[@"SubLocality"] forKey:@"area"];
    [mDic setValue:ad[@"Street"] forKey:@"street"];
    [mDic setValue:local[@"long"] forKey:@"longitude"];
    [mDic setValue:local[@"lat"] forKey:@"dimension"];
    
    [self ocj_trackEventID:@"AP1706C099D003001C009999" parmas:[mDic copy]];
  }];
}

#pragma mark - 首页签到图标初始化
-(void)ocj_showSignInView{
//    [self ocj_hideSuggestButton];//隐藏意见反馈浮标
  
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken];
    if (token.length==0 || ![AppDelegate ocj_getShareAppDelegate].ocjBool_isLogined) {
        self.ocjBool_isHasWaitingSign = YES;
        return;
    }else{
      self.ocjBool_isHasWaitingSign = NO;
    }
  
    //检测token
    [OCJHttp_authAPI ocjAuth_chechToken:token completionHandler:^(OCJBaseResponceModel *responseModel) {
      OCJAuthModel_checkToken* model = (OCJAuthModel_checkToken*)responseModel;
        if (model.ocjStr_custNo.length>0 && [model.ocjStr_isVisitor isEqualToString:@"0"]) {
        
          //签到详情数据
          [OCJHttp_signInAPI OCJRegister_getRegisterDetailsSign_fctLoadingType:OCJHttpLoadingTypeNone completionHandler:^(OCJBaseResponceModel *responseModel) {
            if (responseModel.ocjStr_code.intValue == 200) {
              OCJRegisterInfoModel *model = (OCJRegisterInfoModel *)responseModel;
              if ([model.ocjStr_signYn isEqualToString:@"todayN"]) {
                [self makesigninview];
              }
            }
          }];
        }
    }];
  
}

- (void)makesigninview{
  if (!self.ocjView_touch) {
    self.view.backgroundColor = [UIColor whiteColor];
    self.ocjView_touch = [OCJAssistiveTouch ocj_appearAssistiveTouchFrame:CGRectZero superView:self.view appearType:OCJAssistiveTouchTypeTabbar];
    
    CGFloat BtnWidth = 161*0.5;
    [self.ocjView_touch mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.view).offset(-49-187*0.5);
      make.right.equalTo(self.view);
      make.width.equalTo(@(BtnWidth));
      make.height.equalTo( @(BtnWidth*107/161) );
    }];
    
    __weak typeof(self) weakSelf = self;
    //签到按钮点击请求网络回调
    [self.ocjView_touch setTouchAction:^(OCJSignInTipVCType daysType){
      UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
      
      UIViewController *vc = nil;
      if (rootVC.presentedViewController) {
        vc = rootVC.presentedViewController;
      }
      
      if (vc) {
        [vc dismissViewControllerAnimated:NO completion:nil];
      }
      
      
      //模态弹出签到成功页面
      OCJSignInTipVC *oCJSignInTipVC = [[OCJSignInTipVC alloc] init];
      oCJSignInTipVC.signVCType = daysType;//签到的类型
      oCJSignInTipVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
      oCJSignInTipVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
      [rootVC presentViewController:oCJSignInTipVC animated:NO completion:nil];
      
      //领取礼包回调
      [oCJSignInTipVC setAgreeReceive:^(OCJSignInTipVCType type){
        if (type == OCJSignInTipVCTypeLottery) {//根据签到天数15跳转指定的页面
          OJCLotteryVC *vc = [[OJCLotteryVC alloc] init];
          vc.status = ^(BOOL successOrFail) {
            if (successOrFail) {
              [OCJProgressHUD ocj_showHudWithTitle:@"领取成功，可以去个人中心->签到中心查看礼包详情" andHideDelay:3];
            }
          };
          vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
          vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
          [weakSelf presentViewController:vc animated:NO completion:nil];
        }else if (type == OCJSignInTipVCTypeMember) {//根据签到天数20跳转指定的页面
          
        }else{//普通签到
          
        }
      }];
    }];
  }else{
    self.ocjView_touch.alpha = 1;
  }
}

-(void)ocj_hideSignInView{
  
    self.ocjView_touch.alpha = 0;
  
//  [self ocj_showSuggestButton];//显示反馈建议按钮
}


/**
 抢先版显示反馈悬浮框
 */
-(void)ocj_showSuggestButton{
  
  if (self.ocjBtn_toSuggestion.alpha==1 && [self.ocjBtn_toSuggestion.superview isEqual:self.view]) {
    return;
  }
  
  if (![self.ocjBtn_toSuggestion.superview isEqual:self.view]) {
    [self.view addSubview:self.ocjBtn_toSuggestion];
    
    CGFloat BtnWidth = 161*0.5;
    [self.ocjBtn_toSuggestion mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.view).offset(-49-187*0.5);
      make.right.equalTo(self.view);
      make.width.equalTo(@(BtnWidth));
      make.height.equalTo( @(BtnWidth*107/161) );
    }];
  }
  
  if (self.ocjBtn_toSuggestion.alpha ==0) {
    self.ocjBtn_toSuggestion.alpha = 1;
  }
}

/**
 隐藏反馈悬浮框
 */
-(void)ocj_hideSuggestButton{
  
  self.ocjBtn_toSuggestion.alpha = 0;
}


/**
 反馈悬浮框点击事件
 */
-(void)ocj_clickGotoSuggestionButton{
  
  OCJMySugFeedBackVC* vc = [[OCJMySugFeedBackVC alloc]init];
  [self ocj_pushVC:vc];
}

- (UIButton *)ocjBtn_toSuggestion{
  if (!_ocjBtn_toSuggestion) {
    _ocjBtn_toSuggestion = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ocjBtn_toSuggestion setImage:[UIImage imageNamed:@"icon_toSuggestion"] forState:UIControlStateNormal];
    [_ocjBtn_toSuggestion addTarget:self action:@selector(ocj_clickGotoSuggestionButton) forControlEvents:UIControlEventTouchUpInside];
  }
  return _ocjBtn_toSuggestion;
}


/**
 appStore评价引导页面
 */
- (void)makeAppstoreView{
  [OCJAppStoreViewController startCheckAppStore];
}

-(void)ocj_checkAccessToken{
  //token续签
  [[AppDelegate ocj_getShareAppDelegate] ocj_checkGuestOrMemberAccessTokenCompletion:^(NSDictionary *autoLoginDic) {
    
    NSString* loginType = autoLoginDic[@"autoLoginType"];
    if (loginType.length>0 && [loginType isEqualToString:@"member"] && self.ocjBool_isHasWaitingSign) {//会员自动登录后，如果有等待中的签到状态请求，登录之后重新请求一次
      
      [self ocj_showSignInView];
    }
    
  }];
}

/**
 监控网络状态
 */
-(void)ocj_monitorNetworkStatus{
  
  [OCJ_NOTICE_CENTER addObserver:self selector:@selector(ocj_MonitoringNetWorkStautes:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

/**
 监测网络状态变化
 
 @param notice 通知
 */
-(void)ocj_MonitoringNetWorkStautes:(NSNotification*)notice{
  NSString * memberToken = [[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken];
  NSString * guestToken  = [[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken_guest];
  
  OCJLog(@"网络状态改变：%@",notice.userInfo);
  NSInteger status = [notice.userInfo[@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
  if ((status==1 || status==2) && memberToken.length==0 && guestToken.length==0) {//当游客token和会员token都为空的时候，网络状态变为Ok时，重新获取游客token一次
    
    [[AppDelegate ocj_getShareAppDelegate]ocj_regetGuestTokenCompletion:^(NSDictionary *autoLoginDic) {
      
    }];
  }
  
}



@end
