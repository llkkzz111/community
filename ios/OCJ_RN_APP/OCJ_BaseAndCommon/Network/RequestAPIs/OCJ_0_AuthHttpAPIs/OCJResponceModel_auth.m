//
//  OCJResponceModel_auth.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJResponceModel_auth.h"

@implementation OCJResponceModel_auth

@end

@implementation OCJAuthModel_CheckID
-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"user_type"]) {
            
            self.ocjStr_userType  = [value description];
        }else if ([key isEqualToString:@"internet_id"]){
            
            self.ocjStr_internetID = [value description];
        }else if ([key isEqualToString:@"cust_name"]){
            
            self.ocjStr_custName = [value description];
        }
    }
}
@end

@implementation OCJAuthModel_SendSms
-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"internet_id"]) {
            self.ocjStr_internetID  = [value description];
        }
    }
}


@end

@implementation OCJAuthModel_VerifyTVUser

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"cust_no"]) {
            self.ocjStr_memberID  = [value description];
        }else if ([key isEqualToString:@"mobile"]){
            self.ocjStr_mobile = [value description];
        }
    }
}

@end

@implementation OCJAuthModel_login
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"access_token"]) {
            self.ocjStr_accessToken  = [value description];
            
        }else if([key isEqualToString:@"cust_name"]) {
            
            self.ocjStr_custName = [value description];
        }else if([key isEqualToString:@"mobile"]){
            
            self.ocjStr_mobile = [value description];
        }else if([key isEqualToString:@"cust_no"]){
            
            self.ocjStr_custNo = [value description];
        }else if([key isEqualToString:@"internet_id"]){
            
            self.ocjStr_internetId = [value description];
        }
    }
}
@end

@implementation OCJAuthModel_HistoryGoods
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if (value && ![value isKindOfClass:[NSNull class]]) {
        
        if ([key isEqualToString:@"items"] && [value isKindOfClass:[NSArray class]]) {
            self.ocjArr_items = value;
        }
    }
}
@end


@implementation OCJAuthModel_AlipaySecret

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"redirectURL"]) {
            self.ocjStr_secret  = [value description];
        }
    }
}


@end

@implementation OCJAuthModel_thirdPartyLogin

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"associate_state"]) {
            
            self.ocjStr_associateState  = [value description];
            
        }else if ([key isEqualToString:@"result"]){
            
            self.ocjStr_userMessage = [value description];
        }else if ([key isEqualToString:@"access_token"]){
            
            self.ocjStr_accessToken = [value description];
        }
    }
}


@end

@implementation OCJAuthModel_checkToken

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"isVisitor"] && [value isKindOfClass:[NSNumber class]]) {
      NSNumber* isVisitor = (NSNumber*)value;
      self.ocjStr_isVisitor  = [NSString stringWithFormat:@"%d",[isVisitor intValue]];
      
    }else if ([key isEqualToString:@"isLogin"] && [value isKindOfClass:[NSNumber class]]){
      
      NSNumber* isLogin = (NSNumber*)value;
      self.ocjStr_isLogined = [NSString stringWithFormat:@"%d",[isLogin intValue]];
    }else if ([key isEqualToString:@"cust_no"]){
      
      self.ocjStr_custNo = [value description];
    }
  }
}

@end

@implementation OCJAuthModel_checkVersion

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"update_yn"] ) {
      self.ocjStr_isNeedUpdate = [value description];
      
    }else if ([key isEqualToString:@"app_ver_url"] ){
      self.ocjStr_jumpUrl = [value description];
    
    }else if ([key isEqualToString:@"app_ver_tip"]){
      
      self.ocjStr_updateMessage = [value description];
    }else if ([key isEqualToString:@"prompt_comment_app"]){
      
      self.ocjStr_prompt_comment = [value description];
    }
  }
}

@end
