//
//  AppDelegate+OCJExtension.m
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "AppDelegate+OCJExtension.h"
#import "OCJLoginVC.h"
#import "OCJBaseNC.h"
#import "OCJHomePageVC.h"
#import "OCJAcountLoginVC.h"
#import "OCJProvincePageVC.h"

#import "OCJHttp_authAPI.h"
#import "OCJDataUserInfo+CoreDataClass.h"


@implementation AppDelegate (OCJExtension)

#pragma mark - 接口方法实现区域（包括setter、getter方法）

+(instancetype)ocj_getShareAppDelegate{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    return appDelegate;
}

- (void)ocj_switchRootViewController{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
  
    UIViewController* rootVC = [[OCJBaseNC alloc]initWithRootViewController:[[OCJHomePageVC alloc]init]];
  
    [self.window setRootViewController:rootVC];
    [self.window makeKeyAndVisible];
}

- (void)ocj_checkGuestOrMemberAccessTokenCompletion:(OCJAutologinBlock)handler{
  
  NSString * memberAccessToken = [[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken];
  
  if (memberAccessToken.length >0) {
    //检测token类型
    [OCJHttp_authAPI ocjAuth_chechToken:memberAccessToken completionHandler:^(OCJBaseResponceModel *responseModel) {
      
      OCJAuthModel_checkToken* model = (OCJAuthModel_checkToken*)responseModel;
      
        if (model.ocjStr_custNo.length>0 && [model.ocjStr_isVisitor isEqualToString:@"0"]) {
          
          //会员自动登录
          [OCJHttp_authAPI ocjAuth_automaticLoginCompletionHandler:^(OCJBaseResponceModel *responseModel) {
            
              if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
                if (handler) {
                   handler(@{@"autoLoginType":@"member",@"loginResult":@"1"});
                }
                
              }else{
                
                if (handler) {
                   handler(@{@"autoLoginType":@"member",@"loginResult":@"0"});
                }
                
              }
          }];
        }
    }];
    
  }else{
    
      [self ocj_regetGuestTokenCompletion:handler];
  }
}


-(void)ocj_regetGuestTokenCompletion:(OCJAutologinBlock)handler{
  NSDictionary* userProvinceDic = [[NSUserDefaults standardUserDefaults] objectForKey:OCJUserInfo_Province];
  if (userProvinceDic){//用户选择过分站信息
    
    //获取游客token
    [OCJHttp_authAPI ocjAuth_guestLoginWithParameters:userProvinceDic completionHandler:^(OCJBaseResponceModel *responseModel) {
      
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        if (handler) {
            handler(@{@"autoLoginType":@"guest",@"loginResult":@"1"});
        }
        
      }else{
        if (handler) {
            handler(@{@"autoLoginType":@"guest",@"loginResult":@"0"});
        }
      }
    }];
    
  }else{
    
    //获取省份信息，成功后调出地区选择页面
    [OCJHttp_authAPI ocjAuth_checkProvniceNameWithCompletionHandler:^(OCJBaseResponceModel *responseModel) {
      
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        OCJAreaProvinceListModel* model = (OCJAreaProvinceListModel*)responseModel;
        
        [self ocj_presentProvincePageWithProvinves:model completionHandler:handler];
      }
      
    }];
  }
}


- (void)ocj_reLogin{
    if (self.ocjBool_isPreLoginPage) {
      return;
    }
  
    self.ocjBool_isPreLoginPage = YES;
  
    UIViewController * vc = [AppDelegate ocj_getTopViewController];
    if ([vc isKindOfClass:[OCJLoginVC class]] || [vc isKindOfClass:[OCJAcountLoginVC class]]) {
        self.ocjBool_isPreLoginPage = NO;
        return;
    }
  
    NSArray* userInfoDatas = [OCJDataUserInfo ocj_fetchUserInfo];
  
    UIViewController* loginVC;
    if (userInfoDatas.count > 0) {
        loginVC = [[OCJAcountLoginVC alloc]init];
    }else{
        loginVC = [[OCJLoginVC alloc]init];
    }
    
    OCJBaseNC* naviVC = [[OCJBaseNC alloc]initWithRootViewController:loginVC];
    [vc presentViewController:naviVC animated:YES completion:^{
          self.ocjBool_isPreLoginPage = NO;
    }];
}


+(UIViewController *)ocj_getTopViewController{
    
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (void)ocj_dismissKeyboard{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


#pragma mark - 私有方法区域
+(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nav = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:nav.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


/**
 推出分站选择页面及选择回调处理
 */
- (void)ocj_presentProvincePageWithProvinves:(OCJAreaProvinceListModel *)provinceModel completionHandler:(OCJAutologinBlock)handler{
  
  UIViewController* vc = [AppDelegate ocj_getTopViewController];
  
  OCJProvincePageVC* proviceVC = [[OCJProvincePageVC alloc]init];
  proviceVC.ocjModel_provinceModel = provinceModel;
  proviceVC.ocjBlock_handler = ^(OCJSinglProvinceModel *provinceModel) {
    
    NSDictionary* provinceDic = [NSDictionary dictionary];
    if ([provinceModel isKindOfClass:[OCJSinglProvinceModel class]]) {
      provinceDic = [self ocj_guestLoginGetPostParametersFromModel:provinceModel];
      [[NSUserDefaults standardUserDefaults] setObject:provinceDic forKey:OCJUserInfo_Province];
      
    }else{
      provinceDic = @{@"area_lgroup":@"10",
                      @"area_lgroup_name":@"上海",
                      @"area_mgroup":@"001",
                      @"district_code":@"",
                      @"region_cd":@"2000",
                      @"sel_region_cd":@"2000",
                      @"substation_code":@"100"};
      [[NSUserDefaults standardUserDefaults] setObject:provinceDic forKey:OCJUserInfo_Province];
    }
    
    //获取游客token
    [OCJHttp_authAPI ocjAuth_guestLoginWithParameters:provinceDic completionHandler:^(OCJBaseResponceModel *responseModel) {
      
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        if (handler) {
          handler(@{@"autoLoginType":@"guest",@"loginResult":@"1"});
        }
        
      }else{
        
        if (handler) {
          handler(@{@"autoLoginType":@"guest",@"loginResult":@"0"});
        }
        
      }
    }];
    
  };
  
  OCJBaseNC* naviC = [[OCJBaseNC alloc]initWithRootViewController:proviceVC];
  [vc presentViewController:naviC animated:YES completion:nil];
}


- (NSDictionary*)ocj_guestLoginGetPostParametersFromModel:(OCJSinglProvinceModel*)model{
  NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
  [mDic setValue:model.ocjStr_regionCd forKey:@"region_cd"];
  [mDic setValue:model.ocjStr_selRegionCd forKey:@"sel_region_cd"];
  [mDic setValue:model.ocjStr_id forKey:@"substation_code"];
  [mDic setValue:model.ocjStr_remark forKey:@"district_code"];
  [mDic setValue:model.ocjStr_remark1_v forKey:@"area_lgroup"];
  [mDic setValue:model.ocjStr_remark2_v forKey:@"area_mgroup"];
  [mDic setValue:model.ocjStr_name forKey:@"area_lgroup_name"];
  
  return [mDic copy];
}

@end
