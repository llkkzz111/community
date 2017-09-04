//
//  WSHHRegex.m
//  OCJ
//
//  Created by yangyang on 2017/4/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "WSHHRegex.h"

@implementation WSHHRegex
+(BOOL)wshh_isTelPhoneNumber:(NSString*)string{
    
    NSString* regex = @"^1[0-9]{10}";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isTelPhoneNumber = [predicate evaluateWithObject:string];
    
    return isTelPhoneNumber;
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    
//    return [regextestmobile evaluateWithObject:string];
}

+(BOOL)wshh_isChineseWithString:(NSString*)string{
    
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    BOOL isChinese = [predicate evaluateWithObject:string];
    return isChinese;
    
//    NSString* regex = @"^[\u4e00-\u9fa5]";
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isChinese = [predicate evaluateWithObject:string];
    
//    return isChinese;
}

+(BOOL)wshh_isEmail:(NSString *)string{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isEmail =[emailTest evaluateWithObject:string];
    
    return isEmail;
}

+(BOOL)wshh_isIdCard:(NSString*)string{
    NSString *idCardRegex = @"[1-9]\\d{13,16}[a-zA-Z0-9]{1}";
    NSPredicate *idCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCardRegex];
    BOOL isIDCard =[idCardTest evaluateWithObject:string];
    
    return isIDCard;
}

+(BOOL)wshh_isSmsCode:(NSString*)string{
    NSString* regex = @"^[0-9]{6}";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isSmsCode = [predicate evaluateWithObject:string];
    
    return isSmsCode;
}

+(BOOL)wshh_isNumString:(NSString *)string{
  NSString* regex = @"[0-9]*";
  NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
  BOOL isNumStr = [predicate evaluateWithObject:string];
  
  return isNumStr;
}

@end
