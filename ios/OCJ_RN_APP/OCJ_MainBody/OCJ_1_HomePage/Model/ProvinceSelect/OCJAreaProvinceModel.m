//
//  OCJAreaProvinceModel.m
//  OCJ
//
//  Created by 董克楠 on 12/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJAreaProvinceModel.h"

@implementation OCJAreaProvinceModel

@end

@implementation OCJAreaProvinceListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"result"] && [value isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in value) {
                OCJSinglProvinceModel *model = [[OCJSinglProvinceModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_provinceList addObject:model];
            }
        }
    }
}

-(NSMutableArray *)ocjArr_provinceList{
    if (_ocjArr_provinceList == nil) {
        _ocjArr_provinceList = [NSMutableArray array];
    }
    return _ocjArr_provinceList;
}
@end

@implementation OCJSinglProvinceModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"code_mgroup"]) {
          
            self.ocjStr_id = [value description];
        }else if ([key isEqualToString:@"code_name"]) {
          
            self.ocjStr_name = [value description];
        }else if ([key isEqualToString:@"code_sort"]) {
          
            self.ocjStr_sort = [value description];
        }else if ([key isEqualToString:@"remark1_v"]) {
          
            self.ocjStr_remark1_v = [value description];
        }else if ([key isEqualToString:@"remark2_v"]) {
          
            self.ocjStr_remark2_v = [value description];
        }else if ([key isEqualToString:@"remark3_v"]) {
          
            self.ocjStr_FirstLetter = [value description];
        }else if ([key isEqualToString:@"region_cd"]) {

          self.ocjStr_regionCd = [value description];
        }
    }
}

@end

