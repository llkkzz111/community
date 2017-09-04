//
//  OCJResponceModel_myWallet.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJResponceModel_myWallet.h"

@implementation OCJResponceModel_myWallet

@end

@implementation OCJWalletModel_CouponList

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        
        if ([key isEqualToString:@"myTicketList"] && [value isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in value) {
                OCJWalletModel_CouponListDesc *model = [[OCJWalletModel_CouponListDesc alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_coupon addObject:model];
            }
            
        }else if ([key isEqualToString:@"usecnt"]) {
            
            self.ocjStr_usecnt = [value description];
        }else if ([key isEqualToString:@"unusecnt"]) {
            
            self.ocjStr_unusecnt = [value description];
        }
    }
}

- (NSMutableArray *)ocjArr_coupon {
    if (!_ocjArr_coupon) {
        _ocjArr_coupon = [[NSMutableArray alloc] init];
    }
    return _ocjArr_coupon;
}

@end

@implementation OCJWalletModel_CouponListDesc

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        
        if ([key isEqualToString:@"dccoupon_name"]) {
            
            self.ocjStr_couponName = [value description];
            
        }else if ([key isEqualToString:@"coupon_note"]) {
            self.ocjStr_couponNote = [value description];
            
        }else if ([key isEqualToString:@"exp_dc_bdate"]) {
            self.ocjStr_startDate = [value description];
            
        }else if ([key isEqualToString:@"exp_dc_edate"]) {
            self.ocjStr_endDate = [value description];
            
        }else if ([key isEqualToString:@"coupon_amt"]) {
            self.ocjStr_couponAmt = [value description];
            
        }else if ([key isEqualToString:@"expired"]) {
            
            self.ocjStr_isUsed = [value description];
        }
    }
}

@end

@implementation OCJWalletModel_CouponNum

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"num"]) {
            
            self.ocjStr_couponNum = [value description];
        }
    }
}

@end

@implementation OCJWalletModel_checkBalance

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"num"]) {
            
            self.ocjStr_num = [value description];
        }
    }
}

@end


@implementation OCJWalletModel_ScoreDetail

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"amtList"] && [value isKindOfClass:[NSArray class]]) {
            self.ocjArr_amtList = value       ;
        }else if ([key isEqualToString:@"isLogin"]) {
            self.ocjStr_isLogin = [value description];
        }else if ([key isEqualToString:@"usable_saveamt"]) {
            self.ocjStr_usable_saveamt = [value description];
        }else if ([key isEqualToString:@"maxPage"]) {
            self.ocjStr_maxPage = [value description];
        }
    }
}
@end


@implementation OCJWalletModel_ScorecheckBalance

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"num"]) {
            
            self.ocjStr_num = [value description];
        }
    }
}

@end

@implementation OCJWalletModel_TaoCouponList

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"taolist"] && [value isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in value) {
                OCJWalletModel_TaoCouponListDesc *model = [[OCJWalletModel_TaoCouponListDesc alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_taoList addObject:model];
            }
            
        }else if ([key isEqualToString:@"cust_no"]) {
            
            self.ocjStr_custno = [value description];
        }else if ([key isEqualToString:@"type"]) {
            
            self.ocjStr_type = [value description];
        }else if ([key isEqualToString:@"maxPage"]) {
            
        }
    }
}

- (NSMutableArray *)ocjArr_taoList {
    if (!_ocjArr_taoList) {
        _ocjArr_taoList = [[NSMutableArray alloc] init];
    }
    return _ocjArr_taoList;
}

@end

@implementation OCJWalletModel_TaoCouponListDesc

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"DCCOUPONCONTENT"]) {
            
            self.ocjStr_DCCOUPONCONTENT = [value description];
            
        }else if ([key isEqualToString:@"DCCOUPONNAME"]) {
            
            self.ocjStr_DCCOUPONNAME = [value description];
            
        }else if ([key isEqualToString:@"DCBDATE"]) {
            
            self.ocjStr_DCBDATE = [value description];
            
        }else if ([key isEqualToString:@"COUPONNO"]) {
            
            self.ocjStr_COUPONNO = [value description];
            
        }else if ([key isEqualToString:@"DCAMT"]) {
            
            self.ocjStr_DCAMT = [value description];
            
        }else if ([key isEqualToString:@"TOTALSIZE"]) {
            
            self.ocjStr_TOTALSIZE = [value description];
            
        }else if ([key isEqualToString:@"DCEDATE"]) {
            
            self.ocjStr_DCEDATE = [value description];
            
        }else if ([key isEqualToString:@"MIN_ORDER_AMT"]) {
            
            self.ocjStr_MIN_ORDER_AMT = [value description];
        }
    }
}
@end

@implementation OCJWalletModel_PreDetail
- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"myPrepayList"] && [value isKindOfClass:[NSArray class]]) {
            self.ocjArr_myPrepayList = value  ;     ;
        }else if ([key isEqualToString:@"hasLogin"]) {
            self.ocjStr_hasLogin = [value description];
        }else if ([key isEqualToString:@"use_pb_deposit"]) {
            self.ocjStr_use_pb_deposit = [value description];
        }else if ([key isEqualToString:@"maxPage"]) {
            self.ocjStr_maxPage = [value description];
        }
    }
}
@end

@implementation OCJWalletModel_PrecheckBalance

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"num"]) {
            
            self.ocjStr_num = [value description];
        }
    }
}

@end

@implementation OCJWalletModel_RewardDetail

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"myEGiftCardList"] && [value isKindOfClass:[NSArray class]]) {
            self.ocjArr_myEGiftCardList = value  ;     ;
        }else if ([key isEqualToString:@"hasLogin"]) {
            self.ocjStr_hasLogin = [value description];
        }else if ([key isEqualToString:@"maxPage"]) {
            self.ocjStr_maxPage = [value description];
        }
    }
}
@end


@implementation OCJWalletModel_RewardcheckBalance

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"num"]) {
            
            self.ocjStr_num = [value description];
        }
    }
}
@end

@implementation OCJWalletModel_EuropseDetail

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"eventNameList"] && [value isKindOfClass:[NSArray class]]) {
            self.ocjArr_eventNameList = value  ;     ;
        }else if([key isEqualToString:@"itemNameList"] && [value isKindOfClass:[NSArray class]]){
            self.ocjArr_itemNameList = value;
        }else if([key isEqualToString:@"opointList"] && [value isKindOfClass:[NSArray class]]){
            self.ocjArr_opointList = value;
        }else if([key isEqualToString:@"myOPointList"] && [value isKindOfClass:[NSArray class]]){
            self.ocjArr_myOPointList = value;
        }else if ([key isEqualToString:@"month_size"]) {
            self.ocjStr_month_size = [value description];
        }else if ([key isEqualToString:@"maxPage"]) {
            self.ocjStr_maxPage = [value description];
        }else if ([key isEqualToString:@"getOpoint"]){
            self.ocjStr_getOpoint =[value description];
        }
        
    }
}
@end
