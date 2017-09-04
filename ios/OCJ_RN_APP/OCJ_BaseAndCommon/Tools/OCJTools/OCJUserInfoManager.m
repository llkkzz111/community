//
//  OCJUserInfoManager.m
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJUserInfoManager.h"
#import "OCJHttp_personalInfoAPI.h"
#import "OCJHomePageVC.h"
#import "OCJDataUserInfo+CoreDataClass.h"
#import <AFNetworking.h>

@implementation OCJUserInfoManager

+ (void)ocj_loginAndSaveAccessToken:(NSDictionary *)loginInfoDic userType:(OCJUserTokenType )userType{
  NSString* accessToken = [loginInfoDic[@"access_token"]description].length>0?[loginInfoDic[@"access_token"]description]:@"";
  NSString* custNO = [loginInfoDic[@"cust_no"]description].length>0?[loginInfoDic[@"cust_no"]description]:@"";
  
  switch (userType) {
    case OCJUserTokenTypeMember:{
      [[NSUserDefaults standardUserDefaults]removeObjectForKey:OCJAccessToken_guest];
      [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:OCJAccessToken];
      [[NSUserDefaults standardUserDefaults] setValue:custNO forKey:OCJCustNo];
      [self ocj_getUserInfoAndSave];
      [AppDelegate ocj_getShareAppDelegate].ocjBool_isLogined = YES;
      
    }break;
    case OCJUserTokenTypeVisitor:{
      [[NSUserDefaults standardUserDefaults]removeObjectForKey:OCJAccessToken];
      [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:OCJAccessToken_guest];
      
    }break;
  }
	
	[OCJ_NOTICE_CENTER postNotificationName:OCJ_Notice_Logined object:nil];
}

+ (void)ocj_loginOutAndSaveGuestAccessToken:(NSString*)accessToken{
  
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:OCJAccessToken];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:OCJCustNo];
  [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:OCJAccessToken_guest];
  [AppDelegate ocj_getShareAppDelegate].ocjBool_isLogined = NO;
  
  [OCJ_NOTICE_CENTER postNotificationName:OCJ_Notice_LoginOut object:nil];
}

+ (void)ocj_getUserInfoAndSave{
  [OCJHttp_personalInfoAPI ocjPersonal_checkMenberInfoCompletionHandler:^(OCJBaseResponceModel *responseModel) {
    OCJPersonalModel_memberInfo* model  = (OCJPersonalModel_memberInfo *)responseModel;
    
    NSString * ocjStr_mobile = [NSString stringWithFormat:@"%@%@%@",model.ocjModel_memberDesc.ocjStr_mobile,model.ocjModel_memberDesc.ocjStr_mobile1,model.ocjModel_memberDesc.ocjStr_mobile2];
    NSString * nickName = model.ocjModel_memberDesc.ocjStr_nickName;
    NSString * userHeader = model.ocjStr_headPortrait;
    NSString * userName = model.ocjModel_memberDesc.ocjStr_userName;
    
    [OCJDataUserInfo ocj_insertUserInfoWithName:nickName nick:userName account:ocjStr_mobile headIconUrl:userHeader];
  
  }];
  
}

+ (NSDictionary *)ocj_getTokenForRN{
  NSMutableDictionary* mDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"token",@"",@"tokenType", nil];
  NSString * memberToken = [[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken];
  NSString * guestToken  = [[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken_guest];
  NSString * custNo = [[NSUserDefaults standardUserDefaults]objectForKey:OCJCustNo];
  
  NSString* tokenType = @"";
  NSString* token = @"";
  
  if (guestToken.length>0) {
    tokenType = @"guest";
    token = guestToken;
  }
  
  if (memberToken.length>0) {
    tokenType = @"self";
    token = memberToken;
  }
  
  
  
  [mDic setValue:tokenType forKey:@"tokenType"];
  [mDic setValue:token forKey:@"token"];
  
  NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  NSString* deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:OCJDeviceID];
  NSDictionary* userProvinceDic = [[NSUserDefaults standardUserDefaults] objectForKey:OCJUserInfo_Province];
  NSString* netType = @"OTHER";
  if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
    netType = @"WIFI";
  }else if ([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN){
    netType = @"4G";
  }
  [mDic setValue:@"IOS" forKey:@"X-msale-way"];
  [mDic setValue:appVersion forKey:@"X-version-info"];
  [mDic setValue:@"TM" forKey:@"X-msale-code"];
  [mDic setValue:deviceID forKey:@"X-device-id"];
  [mDic setValue:deviceID forKey:@"X-jiguang-id"];
  [mDic setValue:netType forKey:@"X-net-type"];
  [mDic setValue:custNo forKey:@"UserId"];
  if ([userProvinceDic isKindOfClass:[NSDictionary class]]) {
    [mDic setValue:userProvinceDic[@"region_cd"] forKey:@"X-region-cd"];
    [mDic setValue:userProvinceDic[@"sel_region_cd"] forKey:@"X-sel-region-cd"];
    [mDic setValue:userProvinceDic[@"substation_code"] forKey:@"X-substation-code"];
  }
  
  return [mDic copy];
}

@end
