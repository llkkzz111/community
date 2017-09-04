//
//  OCJResponseModel_evaluate.m
//  OCJ
//
//  Created by Ray on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJResponseModel_evaluate.h"

@implementation OCJResponseModel_evaluate

@end

@implementation OCJResponceModel_imageAddr

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        
        if ([key isEqualToString:@"result"]) {
            self.ocjStr_result = [value description];
        }else if ([key isEqualToString:@"REPictureList"] && [value isKindOfClass:[NSArray class]]) {
            
            self.ocjArr_imageList = value;
        }
    }
}

@end
