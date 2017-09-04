//
//  OCJHttp_personalInfoAPI.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJHttp_personalInfoAPI.h"


NSString *const OCJURLPath_ChangeMobile = @"/api/members/members/change_tel";           ///<修改手机号接口
NSString *const OCJURLPath_ChangePortrait = @"/api/members/members/change_portrait";    ///<修改用户头像接口
NSString *const OCJURLPath_ChangeNickName = @"/api/members/members/change_name";        ///<修改用户昵称接口
NSString *const OCJURLPath_ChangeBirthday = @"/api/members/members/change_birthday";    ///<修改用户生日接口
NSString *const OCJURLPath_ChangeEmail = @"/api/members/members/change_email";          ///<修改邮箱接口

NSString *const OCJURLPath_Suggestion = @"/api/members/suggestion/feedback";            ///<意见反馈接口
NSString *const OCJURLPath_CheckMemberInfo = @"/api/members/members/check_member_info"; ///<会员信息查询接口
NSString *const OCJURLPath_GetChangeMobileSms = @"/api/members/smscode/sms_changetel";  ///<修改手机号发送验证码接口

@implementation OCJHttp_personalInfoAPI

+ (void)ocjPersonal_changeMobileWithMobile:(NSString *)mobile smspassword:(NSString *)smspasswd completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:mobile forKey:@"mobile"];
    [mDic setValue:smspasswd forKey:@"smspasswd"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_ChangeMobile parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:@"修改成功" andHideDelay:2];
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
        
    }];
}

+ (void)ocjPersonal_changePortraitWithFile:(NSData *)file completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:file forKey:@"data"];
    [mDic setValue:@"file" forKey:@"key"];
    
    [[OCJNetWorkCenter sharedCenter]ocj_fromData_POSTWithUrlPath:OCJURLPath_ChangePortrait prameters:nil files:@[[mDic copy]] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:@"修改成功" andHideDelay:2];
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)ocjPersonal_changeNickNameWithCustUpstatus:(NSString *)cust_upstatus custName:(NSString *)cust_name completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:cust_upstatus forKey:@"cust_upstatus"];
    [mDic setValue:cust_name forKey:@"cust_name"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_ChangeNickName parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:@"修改成功" andHideDelay:2];
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
        
    }];
}

+ (void)ocjPersonal_changeBirthdayWithDate:(NSString *)birthday completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:birthday forKey:@"birthday"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_ChangeBirthday parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:@"修改成功" andHideDelay:2];
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)ocjPersonal_changeEmailWithNewEmail:(NSString *)email completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:email forKey:@"email"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_ChangeEmail parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)ocjPersonal_suggestionFeedBackWithType:(NSInteger )feedback_type detail:(NSString *)feedback_detail completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:@(feedback_type) forKey:@"feedback_type"];
    [mDic setValue:feedback_detail forKey:@"feedback_detail"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_Suggestion parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
    }];
}

+ (void)ocjPersonal_checkMenberInfoCompletionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_CheckMemberInfo parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeNone completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJPersonalModel_memberInfo *model = [[OCJPersonalModel_memberInfo alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)ocjPersonal_getChangeMobileSmsCodeWith:(NSString *)mobile completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:mobile forKey:@"mobile"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_GetChangeMobileSms parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

@end
