
//  OCJHttp_authAPI.m
//  OCJ
//
//  Created by yangyang on 2017/4/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJHttp_authAPI.h"

 NSString* const OCJURLPath_CheckID = @"/api/members/members/check_loginid"; ///< 登录ID判断接口
 NSString* const OCJURLPath_VerifyTVUser = @"/api/members/members/verify_tvuser";///<TV用户信息验证接口
 NSString* const OCJURLPath_RegisterWithMobileAndCode = @"/api/members/members/verify_code_register";///<手机号加验证码注册接口
 NSString* const OCJURLPath_SetPassword = @"/api/members/members/set_password";///<设置密码接口
 NSString* const OCJURLPath_CheckHistoryGoods = @"/api/members/members/hist_items";///<会员最近购买过的商品、收货人、收货地址混淆列表接口
 NSString* const OCJURLPath_SecurityCheck = @"/api/members/members/login_by_qa";///<固话会员登录安全校验接口
 NSString* const OCJURLPath_BindingMobile = @"/api/members/members/binding_mobile";///<绑定手机号接口
 NSString* const OCJURLPath_LoginWithPassword = @"/api/members/members/password_login";///<普通登录接口
 NSString* const OCJURLPath_TVUserBindingMobile = @"/api/members/members/tv_login";///< 电视用户固话首次登录绑定手机
 NSString* const OCJURLPath_LoginWithTVMobile = @"/api/members/members/tel_phone_login";///< 电视用户手机登录
 NSString* const OCJURLPath_SendVerifyCode = @"/members/verifycode";///<发送图片验证码接口
 NSString* const OCJURLPath_CheckVerifyCode = @"/members/verifycode/check";///<图片验证码准确性检查接口
 NSString* const OCJURLPath_SendSmsCode = @"/api/members/smscode/send_verify_code_mobile";///<发送手机验证码接口
 NSString* const OCJURLPath_CheckSmscode = @"/api/members/smscode/check_verify_code_mobile";///<手机验证码准确性检查接口
 NSString* const OCJURLPath_SmscodeLogin = @"/api/members/smscode/sms_login";///<手机验证码快速登录接口
 NSString* const OCJURLPath_SendEmailcode = @"/api/members/emailcode/find_password";///< 向邮箱发送找回密码链接接口
 NSString* const OCJURLPath_AutomaticLogin = @"/api/members/loginrules/login_by_access_code";///< 自动登录(token登录)接口
 NSString* const OCJURLPath_GuestLogin = @"/api/members/loginrules/login_by_visit";///< 访客登录接口
 NSString* const OCJURLPath_CheckToken = @"/api/members/checking/token";///< 检测token有效性接口

 NSString* const OCJURLPath_LoginOut = @"/api/members/members/logout";///< 退出登录接口
 NSString* const OCJURLPath_CheckAppVersion = @"/api/members/app/ver/check";///< 检测app版本号

//==========第三方登录模块
 NSString* const OCJURLPath_thirdPartyLogin_getAlipaySecret = @"/api/members/thirdaccounts/alipay_auth_login"; ///< 获取支付宝秘钥
 NSString* const OCJURLPath_thirdPartyLogin_getAlipayOpenID = @"/api/members/thirdaccounts/alipay_callback"; ///< 获取支付宝登录授权信息
 NSString* const OCJURLPath_thirdPartyLogin_getQQOpenID = @"/api/members/thirdaccounts/qq_login"; ///< 获取QQ登录授权信息
 NSString* const OCJURLPath_thirdPartyLogin_getWechatOpenID = @"/api/members/thirdaccounts/wechat_login"; ///< 获取微信登录授权信息
 NSString* const OCJURLPath_thirdPartyLogin_getWeiboOpenID = @"/api/members/thirdaccounts/weibo_login"; ///< 获取微博登录授权信息

//========地区展示模块
NSString* const OCJURLPath_ProvinceNameInfo = @"/api/members/sites/substations"; ///< 获取省份名称信息



@implementation OCJHttp_authAPI

+(void)ocjAuth_checkUserTypeWithAccount:(NSString *)account completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
    [mDic setValue:account forKey:@"login_id"];
    
    [[OCJNetWorkCenter sharedCenter]ocj_GETWithUrlPath:OCJURLPath_CheckID parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            OCJAuthModel_CheckID* model = [[OCJAuthModel_CheckID alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
            handler(model);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_verifyTVUserWithTelephone:(NSString *)telephone name:(NSString *)name completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:telephone forKey:@"telephone"];
    [mDic setValue:name forKey:@"cust_name"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_VerifyTVUser parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"] || [responseModel.ocjStr_code isEqualToString:@"1020100201"]) {
            
            OCJAuthModel_VerifyTVUser* model = [[OCJAuthModel_VerifyTVUser alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
            handler(model);
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_registerWithMobile:(NSString *)mobile verifyCode:(NSString *)verifyCode newPwd:(NSString *)New_pwd internetID:(NSString*)internetID companyCode:(NSString*)companyCode thirdPartyInfo:(NSString*)info completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:mobile forKey:@"mobile"];
    [mDic setValue:verifyCode forKey:@"verify_code"];
    [mDic setValue:New_pwd forKey:@"new_pwd"];
    [mDic setValue:internetID forKey:@"internet_id"];
    NSString* bindingType = info.length?@"0":@"1";
    [mDic setValue:bindingType forKey:@"associate_state"];
    [mDic setValue:info forKey:@"result"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_RegisterWithMobileAndCode parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
    
            [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
          
            handler(responseModel);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_setPasswordNewPassword:(NSString *)new_pwd oldPassword:(NSString*)old_pwd completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:new_pwd forKey:@"new_pwd"];
    [mDic setValue:old_pwd forKey:@"old_pwd"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_SetPassword parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            
          
            [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
            
            handler(responseModel);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_checkHistoryGoodsWithMemberID:(NSString *)memberID  completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:memberID forKey:@"cust_no"];
    [mDic setValue:@"S" forKey:@"image_type"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_CheckHistoryGoods parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"] ||[responseModel.ocjStr_code isEqualToString:@"1020100501"] || [responseModel.ocjStr_code isEqualToString:@"1020100502"]) {
            OCJAuthModel_HistoryGoods* model = [[OCJAuthModel_HistoryGoods alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
            handler(model);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_securityCheckWithMemberID:(NSString *)memberID custName:(NSString*)custName telPhone:(NSString*)telPhone historyReceivers:(NSString *)hist_receivers historyAddress:(NSString *)hist_address historyItems:(NSString *)hist_items thirdPartyInfo:(NSString*)info completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:memberID forKey:@"cust_no"];
    [mDic setValue:custName forKey:@"cust_name"];
    [mDic setValue:hist_receivers forKey:@"hist_receivers"];
    [mDic setValue:hist_address forKey:@"hist_address"];
    [mDic setValue:hist_items forKey:@"hist_items"];
    [mDic setValue:telPhone forKey:@"hist_phone"];
    NSString* bindingType = info.length?@"0":@"1";
    [mDic setValue:bindingType forKey:@"associate_state"];
    [mDic setValue:info forKey:@"result"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_SecurityCheck parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            handler(responseModel);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_TVUserBindingMobile:(NSString *)mobile verifyCode:(NSString *)verifyCode custName:(NSString *)custName custNo:(NSString *)custNo internetID:(NSString *)internetID password:(NSString *)password completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:mobile forKey:@"mobile"];
    [mDic setValue:verifyCode forKey:@"verify_code"];
    [mDic setValue:custNo forKey:@"cust_no"];
    [mDic setValue:custName forKey:@"cust_name"];
    [mDic setValue:internetID forKey:@"internet_id"];
    [mDic setValue:password forKey:@"new_pwd"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_TVUserBindingMobile parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          
            [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
            
            handler(responseModel);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
    
}

+ (void)ocjAuth_loginWithMobileNum:(NSString *)mobileNum verifyCode:(NSString *)verifyCode customName:(NSString *)customName custNo:(NSString*)custNo internetID:(NSString *)internetID thirdPartyInfo:(NSString*)info completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:mobileNum forKey:@"mobile"];
    [mDic setValue:verifyCode forKey:@"verify_code"];
    [mDic setValue:customName forKey:@"cust_name"];
    [mDic setValue:custNo forKey:@"cust_no"];
    [mDic setValue:internetID forKey:@"internet_id"];
    NSString* bindingType = info.length?@"0":@"1";
    [mDic setValue:bindingType forKey:@"associate_state"];
    [mDic setValue:info forKey:@"result"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_LoginWithTVMobile parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          
            [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
            
            handler(responseModel);
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_bindingMobileWithMobile:(NSString *)mobile verifyCode:(NSString *)verify_code completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:mobile forKey:@"mobile"];
    [mDic setValue:verify_code forKey:@"verify_code"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_BindingMobile parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          
            [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
            
            handler(responseModel);
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_loginWithID:(NSString *)login_id password:(NSString *)password thirdPartyInfo:(NSString*)info completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:login_id forKey:@"login_id"];
    [mDic setValue:password forKey:@"password"];
    NSString* bindingType = info.length?@"0":@"1";
    [mDic setValue:bindingType forKey:@"associate_state"];
    [mDic setValue:info forKey:@"result"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_LoginWithPassword parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
      
      if ([responseModel.ocjStr_code isEqualToString:@"200"] ) {
        
          [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
        
          OCJAuthModel_login* model = [[OCJAuthModel_login alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
          handler(model);
      }else if([responseModel.ocjStr_code isEqualToString:@"1020100902"]) {
          OCJAuthModel_login* model = [[OCJAuthModel_login alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
          handler(model);
      }else{
        
        [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
      }
        
    }];
  
}

+ (void)ocjAuth_SendSmscodeWithMobile:(NSString *)mobile purpose:(NSString *)purpose internetID:(NSString*)internetID completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:mobile forKey:@"mobile"];
    [mDic setValue:purpose forKey:@"purpose"];
    [mDic setValue:internetID forKey:@"internet_id"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_SendSmsCode parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            OCJAuthModel_SendSms* model = [[OCJAuthModel_SendSms alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
            handler(model);
        
        }else{
          [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
        
    }];
}

+ (void)ocjAuth_checkSmscodeWithMobile:(NSString *)mobile verifyCode:(NSString *)verify_code purpose:(NSString *)purpose completionhandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:mobile forKey:@"cellphone"];
    [mDic setValue:verify_code forKey:@"smspasswd"];
    [mDic setValue:purpose forKey:@"purpose"];
        
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_CheckSmscode parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
       
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            handler(responseModel);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_smscodeLoginWithMobile:(NSString *)mobile verifyCode:(NSString *)verify_code purpose:(NSString *)purpose thirdPartyInfo:(NSString*)info completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:mobile forKey:@"mobile"];
    [mDic setValue:verify_code forKey:@"verify_code"];
    [mDic setValue:purpose forKey:@"purpose"];
    NSString* bindingType = info.length?@"0":@"1";
    [mDic setValue:bindingType forKey:@"associate_state"];
    [mDic setValue:info forKey:@"result"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_SmscodeLogin parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          
            [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
            
            handler(responseModel);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_sendEmailCodeWithEmail:(NSString *)email completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:email forKey:@"email_addr"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_SendEmailcode parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            handler(responseModel);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_chechToken:(NSString *)accessToken completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken] forKey:@"token"];
  
    [[OCJNetWorkCenter sharedCenter]ocj_GETWithUrlPath:OCJURLPath_CheckToken parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeNone completionHandler:^(OCJBaseResponceModel *responseModel) {
      
        OCJAuthModel_checkToken* model = [[OCJAuthModel_checkToken alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
      
    }];
  
}

+ (void)ocjAuth_automaticLoginCompletionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_AutomaticLogin parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeNone completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
          
        }
      
        handler(responseModel);
    }];
}

+ (void)ocjAuth_guestLoginWithParameters:(NSDictionary*)params completionHandler:(OCJHttpResponseHander)handler{
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString* appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [mDic setValue:appVersion forKey:@"version_info"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_GuestLogin parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeNone completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            
           [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeVisitor];
        }
      
        handler(responseModel);
    }];
}

+ (void)ocjAuth_LoginOutCompletionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_LoginOut parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            NSString* accessToken = responseModel.ocjDic_data[@"result"];
            [OCJUserInfoManager ocj_loginOutAndSaveGuestAccessToken:accessToken];
          
            handler(responseModel);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+(void)ocjAuth_checkAppVersionCompletionHandler:(OCJHttpResponseHander)handler{
  NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
  NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  [mDic setValue:appVersion forKey:@"app_ver"];
  [mDic setValue:@"IOS" forKey:@"platform"];
  
  [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_CheckAppVersion parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeNone completionHandler:^(OCJBaseResponceModel *responseModel) {
    
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      
      OCJAuthModel_checkVersion* model = [[OCJAuthModel_checkVersion alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
      handler(model);
      
    }
  }];
}

#pragma mark - 第三方登录模块
+ (void)ocjAuth_thirdParty_getAlipaySecertCompletionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
  [mDic setValue:@"IOS" forKey:@"msale_way"];
  
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_thirdPartyLogin_getAlipaySecret parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            OCJAuthModel_AlipaySecret* model = [[OCJAuthModel_AlipaySecret alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
            
            handler(model);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_thirdParty_getAlipayOpenIDWithCode:(NSString*)code completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:code forKey:@"code"];
    [mDic setValue:@"123" forKey:@"device_id"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_thirdPartyLogin_getAlipayOpenID parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
          
            OCJAuthModel_thirdPartyLogin* model = [[OCJAuthModel_thirdPartyLogin alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
          
            handler(model);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_thirdParty_getWechatOpenIDWithCode:(NSString*)code completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:code forKey:@"code"];
    [mDic setValue:@"123" forKey:@"device_id"];

    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_thirdPartyLogin_getWechatOpenID parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
          
              OCJAuthModel_thirdPartyLogin* model = [[OCJAuthModel_thirdPartyLogin alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
              handler(model);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_thirdParty_getWeiboOpenIDWithCode:(NSString*)code completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:code forKey:@"code"];
    [mDic setValue:@"123" forKey:@"device_id"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_thirdPartyLogin_getWeiboOpenID parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
          
            OCJAuthModel_thirdPartyLogin* model = [[OCJAuthModel_thirdPartyLogin alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
          
            handler(model);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjAuth_thirdParty_getQQOpenIDWithCode:(NSString*)code completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:code forKey:@"code"];
    [mDic setValue:@"123" forKey:@"device_id"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_thirdPartyLogin_getQQOpenID parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJUserInfoManager ocj_loginAndSaveAccessToken:responseModel.ocjDic_data userType:OCJUserTokenTypeMember];
          
            OCJAuthModel_thirdPartyLogin* model = [[OCJAuthModel_thirdPartyLogin alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
          
            handler(model);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}


#pragma mark - 分站信息
+ (void)ocjAuth_checkProvniceNameWithCompletionHandler:(OCJHttpResponseHander)handler{
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_ProvinceNameInfo parameters:nil andLodingType:OCJHttpLoadingTypeNone completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            OCJAreaProvinceListModel *model = [[OCJAreaProvinceListModel alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
            
            handler(model);
            
        }
    }];
}





@end
