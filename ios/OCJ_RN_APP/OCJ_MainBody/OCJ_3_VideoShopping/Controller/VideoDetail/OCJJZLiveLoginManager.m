//
//  OCJJZLiveLoginManager.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/10.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJJZLiveLoginManager.h"
#import <JZLiveSDK/JZLiveSDK.h>
#import "OCJHttp_authAPI.h"
#import "OCJDataUserInfo+CoreDataClass.h"
#import <objc/runtime.h>
#import "JZPlayerViewController.h"
#import "OCJLoginVC.h"
#import "JZTools.h"
#import "HDUtil.h"

static char actionKey; ///< handler暂存地址
static char actionStr; ///< shopNo

@interface OCJJZLiveLoginManager ()

@end

@implementation OCJJZLiveLoginManager

+ (void)ocj_jzliveManagerWithString:(NSString *)ocjStr {
  NSString *shopNo = [HDUtil ocj_getShopNO:ocjStr];
  objc_setAssociatedObject(self, &actionStr, shopNo, OBJC_ASSOCIATION_COPY_NONATOMIC);
  [self ocj_requestUserLogin];
}

+ (void)ocj_requestUserLogin {
  NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken];
  if (token.length==0) {
    [OCJProgressHUD ocj_showAlertByVC:[AppDelegate ocj_getTopViewController] withAlertType:OCJAlertTypeNone title:nil message:@"您尚未登录东方购物账号" sureButtonTitle:@"登录" CancelButtonTitle:@"取消" action:^(NSInteger clickIndex) {
      [[AppDelegate ocj_getTopViewController].navigationController popToRootViewControllerAnimated:NO];
      if (clickIndex == 1) {
        [[AppDelegate ocj_getShareAppDelegate] ocj_reLogin];
      }
    }];
  }
  
  //检测token
  [OCJHttp_authAPI ocjAuth_chechToken:token completionHandler:^(OCJBaseResponceModel *responseModel) {
    OCJAuthModel_checkToken* model = (OCJAuthModel_checkToken*)responseModel;
    if (model.ocjStr_custNo.length>0 && [model.ocjStr_isVisitor isEqualToString:@"0"]) {
      
      [self ocj_SDKThirdLogin:model];
    }else {
      [OCJProgressHUD ocj_showAlertByVC:[AppDelegate ocj_getTopViewController] withAlertType:OCJAlertTypeNone title:nil message:@"您尚未登录东方购物账号" sureButtonTitle:@"登录" CancelButtonTitle:@"取消" action:^(NSInteger clickIndex) {
        [[AppDelegate ocj_getTopViewController].navigationController popToRootViewControllerAnimated:NO];
        if (clickIndex == 1) {
          [[AppDelegate ocj_getShareAppDelegate] ocj_reLogin];
        }
      }];
    }
  }];
  
}

+ (void)ocj_SDKThirdLogin:(OCJAuthModel_checkToken *)model {
  OCJDataUserInfo *userInfo = [[OCJDataUserInfo ocj_fetchUserInfo]lastObject];
  
  NSString *cust_name = userInfo.ocjStr_name;
  NSString *cust_no = model.ocjStr_custNo;
  //先访问第三方应用等第三方应用授权后将第三方服务器返回的值传入下面接口(与微信类似)
  
  /*!
   * param uid   个人id必须是唯一值(必传参数)
   * param loginType  使用SDK的公司名(必传参数)
   * param nickname  昵称(必传参数)
   * param city  所在城市(不是必传参数)
   * param pic1  头像(不是必传参数)
   * param sex   性别(不是必传参数)
   */
  NSDictionary * params = @{
                            @"uid" : cust_no,
                            @"loginType" : @"dongfanggouwu",
                            @"nickname" : cust_name,
                            @"city" : @"",
                            @"pic1" : @"",
                            @"sex":@""
                            };
  OCJProgressHUD *hud = [OCJProgressHUD ocj_showHudWithView:[AppDelegate ocj_getTopViewController].view andHideDelay:2];
  [JZGeneralApi thirdPrtyLoginWithBlock:(NSDictionary *)params getDetailBlock:^(JZCustomer *user, NSError *error)
   {
     [hud ocj_hideHud];
     if (error||[JZTools isInvalid:[NSString stringWithFormat:@"%ld",(long)user.id]])
     {
       [[AppDelegate ocj_getTopViewController].navigationController popViewControllerAnimated:YES];
       [OCJProgressHUD ocj_showHudWithTitle:@"登录失败" andHideDelay:2.0];
       
     }
     else
     {// SDK第三方登录成功
       [JZGeneralApi setLoginStatus:1];//置登录状态
       [self getActivitiesArray];
       
       
     }
     
   }];
}

+ (void)getActivitiesArray
{
  JZCustomer *user = [JZCustomer getUserdataInstance];
  NSDictionary *userRecord = @{
                               @"orderType":@"user",
                               @"uid":@"15",
                               @"start":@"0",
                               @"offset":@"50",
                               @"isTester":[NSString stringWithFormat:@"%ld",(long)[JZCustomer getUserdataInstance].isTester]
                               };
  __weak typeof(self) block = self;
  OCJProgressHUD *hud = [OCJProgressHUD ocj_showHudWithView:[AppDelegate ocj_getTopViewController].view andHideDelay:2];
  [JZGeneralApi getKindsRecordsWithBlock:userRecord returnBlock:^(NSArray *records, NSInteger allcounts, NSError *error) {
    [hud ocj_hideHud];
    if (error) {
//      self.LiveShouldRequest = YES;
      NSLog(@"%@", error);
    }else {
      
      NSMutableArray *activitiesArray = [NSMutableArray arrayWithArray:records];
      objc_setAssociatedObject(self, &actionKey, activitiesArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
//      block.allcounts = (int)allcounts;
      [block getLiveInfo];
      
    }
  }];
}

+ (void)getLiveInfo
{
  /*! @brief 获取用户详细信息
   * @discusstion 获取用户的详细信息
   * @param hostID 想获取的用户ID
   * @param userID 这个userID是用于判断用户是否已经关注上面这个hostID
   * @param accountType 账户类型,ios端为@"ios",为了与安卓和web区别
   * @param start 活动起始页码,一般为@"0"。
   * @param offset 每页的活动数量。
   * @param isTester 0为普通用户，1为测试用户。
   * @return 成功返回:想要的用户信息(JZCustomer *)user, (NSArray *)records用户活动, (NSInteger)allcounts用户活动总条数，失败返回error。
   */
  NSArray *activitiesArray = objc_getAssociatedObject(self, &actionKey);
  JZLiveRecord *record =(JZLiveRecord*)[activitiesArray firstObject];
  NSInteger living = (record.publish||record.publishDone);
  NSDictionary * params = @{
                            @"hostID":[NSString stringWithFormat:@"%lu",(long)record.userID],
                            @"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],
                            @"accountType":@"ios",
                            @"start":@"0",
                            @"offset":@"50",
                            @"isTester":[NSString stringWithFormat:@"%ld",(long)[JZCustomer getUserdataInstance].isTester]
                            };
  __weak typeof(self) block = self;
  OCJProgressHUD *hud = [OCJProgressHUD ocj_showHudWithView:[AppDelegate ocj_getTopViewController].view andHideDelay:2];
  [JZGeneralApi getDetailUserBlock:params getDetailBlock:^(JZCustomer *user, NSArray *records, NSInteger allcounts, NSError *error) {
    [hud ocj_hideHud];
    if (error)
    {
//      self.LiveShouldRequest = YES;
    }else{
      if (living)
      {
        NSString *str = objc_getAssociatedObject(self, &actionStr);
        JZPlayerViewController *pushVc = [[JZPlayerViewController alloc] init];
        pushVc.record = record;
        pushVc.host = user;
        pushVc.user = [JZCustomer getUserdataInstance];
        pushVc.shopNo = str;
        pushVc.hidesBottomBarWhenPushed = YES;
//        pushVc.dictionary = _resposeDictionay;
//        [[AppDelegate ocj_getTopViewController] presentViewController:pushVc animated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
        [[AppDelegate ocj_getTopViewController].navigationController pushViewController:pushVc animated:YES];
      }
      else
      {
        
        
      }
      
    }
    
  }];
  
}

@end
