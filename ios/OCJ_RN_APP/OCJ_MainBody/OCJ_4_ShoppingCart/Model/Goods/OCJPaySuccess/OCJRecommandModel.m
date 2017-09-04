//
//  OCJRecommandModel.m
//  OCJ
//
//  Created by OCJ on 2017/6/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRecommandModel.h"

@implementation OCJRecommandModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"SALE_PRICE"]) {
        self.ocjStr_price = [value description];
    }else if([key isEqualToString:@"CUST_PRICE"]){
        self.ocjStr_custPrice = [value description];
    }else if([key isEqualToString:@"SALES_VOLUME"]){
        self.ocjStr_volume = [value description];
    }else if([key isEqualToString:@"ITEM_CODE"]){
        self.ocjStr_itemCode = [value description];
    }else if([key isEqualToString:@"url"]){
        self.ocjStr_url = [value description];
    }else if([key isEqualToString:@"ITEM_NAME"]){
        self.ocjStr_itemName = [value description];
    }else if([key isEqualToString:@"dc"]){
        self.ocjStr_dc = [value description];
    }
}

@end
