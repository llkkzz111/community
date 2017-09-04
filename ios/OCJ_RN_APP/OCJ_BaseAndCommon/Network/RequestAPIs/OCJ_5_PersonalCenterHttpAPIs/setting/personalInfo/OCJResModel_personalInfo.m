//
//  OCJResModel_personalInfo.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJResModel_personalInfo.h"

@implementation OCJResModel_personalInfo

@end

@implementation OCJPersonalModel_changeMobile

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"result"]) {
            
            self.ocjStr_result = [value description];
        }
    }
}

@end

@implementation OCJPersonalModel_changeEmail

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"result"]) {
            
            self.ocjStr_result = [value description];
        }
    }
}

@end

@implementation OCJPersonalModel_memberInfo

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"customerCommon"] && [value  isKindOfClass:[NSDictionary class]]) {
            self.ocjModel_memberDesc = [[OCJPersonalModel_memberInfoDesc alloc] init];
            [self.ocjModel_memberDesc setValuesForKeysWithDictionary:value];
        }else if ([key isEqualToString:@"custPhoto"]) {
            
            self.ocjStr_headPortrait = [value description];
        }else if ([key isEqualToString:@"addrInfo"] && [value  isKindOfClass:[NSDictionary class]])
        {
            self.ocjModel_AdressDesc = [[OCJPersonalModel_DefaultAdressDesc alloc] init];
            [self.ocjModel_AdressDesc setValuesForKeysWithDictionary:value];
        }
    }
}

@end

@implementation OCJPersonalModel_memberInfoDesc

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"cust_name"]) {
            
            self.ocjStr_nickName = [value description];
        }else if ([key isEqualToString:@"internet_Id"]) {
            
            self.ocjStr_userName = [value description];
        }else if ([key isEqualToString:@"mail1"]) {
            
            self.ocjStr_email1 = [value description];
        }else if ([key isEqualToString:@"mail2"]) {
            
            self.ocjStr_email2 = [value description];
        }else if ([key isEqualToString:@"hpddd"]) {
            
            self.ocjStr_mobile = [value description];
        }else if ([key isEqualToString:@"hptel1"]) {
            
            self.ocjStr_mobile1 = [value description];
        }else if ([key isEqualToString:@"hptel2"]) {
            
            self.ocjStr_mobile2 = [value description];
        }else if ([key isEqualToString:@"hptel3"]) {
            
            self.ocjStr_mobile3 = [value description];
        }else if ([key isEqualToString:@"birth_yyyy"]) {
            
            self.ocjStr_birthYear = [value description];
        }else if ([key isEqualToString:@"birth_mm"]) {
            
            self.ocjStr_birthMonth = [value description];
        }else if ([key isEqualToString:@"birth_dd"]) {
            
            self.ocjStr_birthDay = [value description];
        }
    }
}

@end

@implementation OCJPersonalModel_DefaultAdressDesc

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"place_gb"]) {
      
      self.ocjStr_placeGb = [value description];
    }else if ([key isEqualToString:@"addr"]) {
      
      self.ocjStr_addr = [value description];
    }else if ([key isEqualToString:@"province"]) {
      
      self.ocjStr_province = [value description];
    }else if ([key isEqualToString:@"city"]) {
      
      self.ocjStr_city = [value description];
    }else if ([key isEqualToString:@"area"]) {
      
      self.ocjStr_area = [value description];
    }else if ([key isEqualToString:@"province_name"]) {
      
      self.ocjStr_provinceName = [value description];
    }else if ([key isEqualToString:@"city_name"]) {
      
      self.ocjStr_cityName = [value description];
    }else if ([key isEqualToString:@"area_name"]) {
      
      self.ocjStr_areaName = [value description];
    }
  }
}


@end
