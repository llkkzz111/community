//
//  OCJResponseModel_confirmOrder.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJResponseModel_confirmOrder.h"

@implementation OCJResponseModel_confirmOrder

@end

@implementation OCJResponceModel_confirmOrder

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"receivers"] && [value isKindOfClass:[NSDictionary class]]) {
      
      self.ocjModel_receiver = [[OCJAddressModel_listDesc alloc] init];
      [self.ocjModel_receiver setValuesForKeysWithDictionary:value];
    }else if ([key isEqualToString:@"useable_deposit"]) {
      self.ocjStr_deposit = [value description];
    }else if ([key isEqualToString:@"useable_saveamt"]) {
      self.ocjStr_score = [value description];
    }else if ([key isEqualToString:@"total_price"]) {
      self.ocjStr_totalPrice = [value description];
    }else if ([key isEqualToString:@"coupon_price"]) {
      self.ocjStr_couponPrice = [value description];
    }else if ([key isEqualToString:@"orders"] && [value isKindOfClass:[NSArray class]]) {
      
      for (NSDictionary *dic in value) {
        OCJResponceModel_orders *model = [[OCJResponceModel_orders alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.ocjArr_orders addObject:model];
      }
    }else if ([key isEqualToString:@"useable_cardamt"]) {
      self.ocjStr_record = [value description];
    }
  }
}

- (NSMutableArray *)ocjArr_orders {
  if (!_ocjArr_orders) {
    _ocjArr_orders = [[NSMutableArray alloc] init];
  }
  return _ocjArr_orders;
}

@end

@implementation OCJResponceModel_orders

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"isCouponUsable"]) {
      self.ocjStr_canUseCoupon = [value description];
    }else if ([key isEqualToString:@"carts"] && [value isKindOfClass:[NSArray class]]) {
      
      for (NSDictionary *dic in value) {
        OCJResponceModel_orderDetail *model = [[OCJResponceModel_orderDetail alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.ocjArr_carts addObject:model];
      }
    
    }else if ([key isEqualToString:@"couponList"] && [value isKindOfClass:[NSArray class]]) {
      
      for (NSDictionary *dic in value) {
        OCJResponceModel_coupon *model = [[OCJResponceModel_coupon alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.ocjArr_coupon addObject:model];
      }
    }
  }
}

- (NSMutableArray *)ocjArr_carts {
  if (!_ocjArr_carts) {
    _ocjArr_carts = [[NSMutableArray alloc] init];
  }
  return _ocjArr_carts;
}

- (NSMutableArray *)ocjArr_coupon {
  if (!_ocjArr_coupon) {
    _ocjArr_coupon = [[NSMutableArray alloc] init];
  }
  return _ocjArr_coupon;
}

@end

@implementation OCJResponceModel_orderDetail

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"internet_id"]) {
      self.ocjStr_custID = [value description];
    }else if ([key isEqualToString:@"memberPromo"]) {
      self.ocjStr_memberPromo = [value description];
    }else if ([key isEqualToString:@"item"] && [value isKindOfClass:[NSDictionary class]]) {
        self.ocjModel_goods = [[OCJResponceModel_GoodsDetail alloc] init];
        [self.ocjModel_goods setValuesForKeysWithDictionary:value];
      }
    }else if ([key isEqualToString:@"twgiftcartVO"] && [value isKindOfClass:[NSArray class]]) {
      
      self.ocjArr_gift = value;
    }
}

- (NSMutableArray *)ocjArr_gift {
  if (!_ocjArr_gift) {
    _ocjArr_gift = [[NSMutableArray alloc] init];
  }
  return _ocjArr_gift;
}

@end

@implementation OCJResponceModel_GoodsDetail

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"item_code"]) {
      self.ocjStr_itemCode = [value description];
    }else if ([key isEqualToString:@"unit_code"]) {
      self.ocjStr_unitCode = [value description];
    }else if ([key isEqualToString:@"msale_code"]) {
      self.ocjStr_msaleCode = [value description];
    }else if ([key isEqualToString:@"count"]) {
      self.ocjStr_count = [value description];
    }else if ([key isEqualToString:@"item_name"]) {
      self.ocjStr_name = [value description];
    }else if ([key isEqualToString:@"path"]) {
      self.ocjStr_imageUrl = [value description];
    }else if ([key isEqualToString:@"last_sale_price"]) {
      self.ocjStr_lastSellPrice = [value description];
    }else if ([key isEqualToString:@"sale_price"]) {
      self.ocjStr_sellPrice = [value description];
    }else if ([key isEqualToString:@"dc_amt"]) {
      self.ocjStr_reduce = [value description];
    }else if ([key isEqualToString:@"content_nm"]) {
      self.ocjStr_isRecommend = [value description];
    }else if ([key isEqualToString:@"sx_gifts"]) {
      self.ocjArr_sxGifts = value;
    }
  }
}

@end

@implementation OCJResponceModel_coupon

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"coupon_no"]) {
      self.ocjStr_couponNo = [value description];
    }else if ([key isEqualToString:@"coupon_note"]) {
      self.ocjStr_couponName = [value description];
    }else if ([key isEqualToString:@"real_coupon_amt"]) {
      self.ocjStr_couponAmt = [value description];
    }else if ([key isEqualToString:@"dc_gb"]) {
      self.ocjStr_couponGB = [value description];
    }else if ([key isEqualToString:@"coupon_seq"]) {
      self.ocjStr_couponSeq = [value description];
    }else if ([key isEqualToString:@"dc_endDate"]) {
      self.ocjStr_endDate = [value description];
    }
  }
}

@end

@implementation OCJResponceModel_gift

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@""]) {
      self.ocjStr_giftSeq = [value description];
    }else if ([key isEqualToString:@"gift_item_code"]) {
      self.ocjStr_giftItemcode = [value description];
    }else if ([key isEqualToString:@"gift_unit_code"]) {
      self.ocjStr_giftUnitcode = [value description];
    }else if ([key isEqualToString:@"giftpromo_no"]) {
      self.ocjStr_giftPromoNo = [value description];
    }else if ([key isEqualToString:@"giftpromo_seq"]) {
      self.ocjStr_giftPromoSeq = [value description];
    }else if ([key isEqualToString:@"item_name"]) {
      self.ocjStr_giftItemName = [value description];
    }else if ([key isEqualToString:@"path"]) {
      self.ocjStr_imageUrl = [value description];
    }
  }
}

@end
