//
//  OCJRegisterDetailsModel.m
//  OCJ
//
//  Created by 董克楠 on 12/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRegisterDetailsModel.h"

@implementation OCJRegisterDetailsModel

@end

@implementation OCJRegisterInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"fctYn"]) {
            self.ocjStr_fctYn = [value description];
        }else if ([key isEqualToString:@"monthDay"]) {
            self.ocjStr_monthDay = [value description];
        }else if ([key isEqualToString:@"liBaoYn"]) {
            self.ocjStr_liBaoYn = [value description];
        }else if ([key isEqualToString:@"fctG"]) {
            self.ocjStr_fctG = [value description];
        }else if ([key isEqualToString:@"signYn"]) {
            self.ocjStr_signYn = [value description];
        }else if ([key isEqualToString:@"isApp"]) {
            self.ocjStr_isApp = [value description];
        }else if ([key isEqualToString:@"opoint_money"]) {
            self.ocjStr_opoint_money = [value description];
        }
    }
}

@end
