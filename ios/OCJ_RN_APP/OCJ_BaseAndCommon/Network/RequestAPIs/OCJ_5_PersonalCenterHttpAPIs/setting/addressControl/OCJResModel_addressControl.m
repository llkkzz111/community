//
//  OCJResModel_addressControl.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJResModel_addressControl.h"

@implementation OCJResModel_addressControl

@end

@implementation OCJAddressModel_detailList

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"receivers"] && [value isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in value) {
                OCJAddressModel_listDesc *model = [[OCJAddressModel_listDesc alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_receivers addObject:model];
            }
        }else if ([key isEqualToString:@"cust_no"]) {
            
            self.ocjStr_cust_no = [value description];
        }
    }
}

- (NSMutableArray *)ocjArr_receivers {
    if (!_ocjArr_receivers) {
        _ocjArr_receivers = [[NSMutableArray alloc] init];
    }
    return _ocjArr_receivers;
}

@end

@implementation OCJAddressModel_listDesc

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"cust_no"]) {
            
            self.ocjStr_cust_no = [value description];
        }else if ([key isEqualToString:@"receiver_name"]) {
            
            self.ocjStr_receiverName = [value description];
        }else if ([key isEqualToString:@"receiver_hp1"]) {
            
            self.ocjStr_mobile1 = [value description];
        }else if ([key isEqualToString:@"receiver_hp2"]) {
            
            self.ocjStr_mobile2 = [value description];
        }else if ([key isEqualToString:@"receiver_hp3"]) {
            
            self.ocjStr_mobile3 = [value description];
        }else if ([key isEqualToString:@"default_yn"]) {
            
            self.ocjStr_isDefault = [value description];
        }else if ([key isEqualToString:@"receiver_addr"]) {
            
            self.ocjStr_addrDetail = [value description];
        }else if ([key isEqualToString:@"addr_m"]) {
            
            self.ocjStr_addrProCity = [value description];
        }else if ([key isEqualToString:@"receivermanage_seq"]) {
            
            self.ocjStr_addressID = [value description];
        }else if ([key isEqualToString:@"area_lgroup"]) {
            
            self.ocjStr_provinceCode = [value description];
        }else if ([key isEqualToString:@"area_mgroup"]) {
            
            self.ocjStr_cityCode = [value description];
        }else if ([key isEqualToString:@"area_sgroup"]) {
            
            self.ocjStr_districtCode = [value description];
            
        }else if ([key isEqualToString:@"receiver_seq"]) {
            self.ocjStr_addressIDRN = [value description];
        }
    }
}

@end
