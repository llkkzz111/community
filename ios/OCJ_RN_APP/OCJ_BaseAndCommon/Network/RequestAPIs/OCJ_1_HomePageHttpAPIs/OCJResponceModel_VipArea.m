//
//  OCJResponceModel_VipArea.m
//  OCJ
//
//  Created by wb_yangyang on 2017/6/11.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJResponceModel_VipArea.h"

@implementation OCJResponceModel_VipArea

@end

@implementation OCJVIPModel_Detail

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"result"] && [value isKindOfClass:[NSArray class]]) {
            
            NSArray* array = (NSArray*)value;
            for (NSInteger i=0; i<array.count; i++) {
                NSDictionary* dic = array[i];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    NSString* areaCode = [dic[@"seq_temp_corner_num"]description];
                
                    if ([areaCode isEqualToString:@"10911"]) {
                        
                        self.ocjModel_brandDetail = [[OCJVIPModel_BrandDetail alloc]init];
                        [self.ocjModel_brandDetail setValuesForKeysWithDictionary:dic];
                        
                    }else if ([areaCode isEqualToString:@"10912"]){
                        
                        self.ocjModel_vipChoicenessDetail = [[OCJVIPModel_VIPChoicenessDetail alloc]init];
                        [self.ocjModel_vipChoicenessDetail setValuesForKeysWithDictionary:dic];
                        
                    }
                }
            }
        }else if ([key isEqualToString:@"codeValue"]) {
          self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

@end


@implementation OCJVIPModel_BrandDetail

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"setList"] && [value isKindOfClass:[NSArray class]]) {
            NSArray* brandList = (NSArray*)value;
            NSDictionary* dic = [brandList firstObject];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                
                NSArray* brandItemList = dic[@"contentList"];
                if ([brandItemList isKindOfClass:[NSArray class]]) {
                    
                    NSMutableArray* mItemArray = [NSMutableArray array];//品牌推荐商品暂存容器
                    
                    for (NSInteger i=0; i<brandItemList.count; i++) {
                        if (i>3) {
                            //目前品牌推荐界面只有三个商品，多的直接废弃
                            break;
                        }
                    
                        NSDictionary* itemDic = brandItemList[i];
                        if ([itemDic isKindOfClass:[NSDictionary class]]) {
                            switch (i) {
                                case 0:
                                {
                                    self.ocjStr_brandName = [itemDic[@"alt_desc"]description];
                                    self.ocjStr_brandDescription = [itemDic[@"conts_desc"]description];
                                    self.ocjStr_brandIconUrl = [itemDic[@"contentImage"]description];
                                }break;
                                case 1:case 2:case 3:
                                {
                                    
                                    OCJVIPModel_BrandItem * brandItem = [[OCJVIPModel_BrandItem alloc]init];
                                    [brandItem setValuesForKeysWithDictionary:itemDic];
                                    
                                    [mItemArray addObject:brandItem];
                                    
                                }break;
                                default:
                                    break;
                            }
                        }
                        
                    }
                    
                    self.ocjArr_brandItems = [mItemArray copy];
                    
                }
            }
        }else if ([key isEqualToString:@"codeValue"]) {
          self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

@end

@implementation OCJVIPModel_BrandItem

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"brand_name"]) {
            self.ocjStr_title = [value description];
        }else if ([key isEqualToString:@"item_image"]){
            self.ocjStr_imageUrl = [value description];
        }else if ([key isEqualToString:@"sale_price"]){
            self.ocjStr_price = [value description];
        }else if ([key isEqualToString:@"item_name"]){
            self.ocjStr_description = [value description];
        }else if ([key isEqualToString:@"item_code"]){
            self.ocjStr_itemCode = [value description];
        }else if ([key isEqualToString:@"codeValue"]) {
          self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

@end

@implementation OCJVIPModel_VIPChoicenessDetail

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"setList"] && [value isKindOfClass:[NSArray class]]) {
            NSArray* choicenessList = (NSArray*)value;
            NSDictionary* dic = [choicenessList firstObject];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                
                NSArray* choicenessItemList = dic[@"contentList"];
                if ([choicenessItemList isKindOfClass:[NSArray class]]) {
                    NSMutableArray* mItemArray = [NSMutableArray array];//品牌推荐商品暂存容器
                    
                    for (NSInteger i=0; i<choicenessItemList.count; i++) {
                        
                        NSDictionary* itemDic = choicenessItemList[i];
                        if ([itemDic isKindOfClass:[NSDictionary class]]) {
                            OCJVIPModel_VIPChoicenessItem* choicenessItem = [[OCJVIPModel_VIPChoicenessItem alloc]init];
                            [choicenessItem setValuesForKeysWithDictionary:itemDic];
                            
                            [mItemArray addObject:choicenessItem];
                        }
                        
                    }
                    
                    self.ocjArr_vipChoicenessItems = [mItemArray copy];
                    
                }
            }
        }else if ([key isEqualToString:@"codeValue"]) {
          self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

@end


@implementation OCJVIPModel_VIPChoicenessItem

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"item_image"]) {
            self.ocjStr_imageUrl = [value description];
            
        }else if ([key isEqualToString:@"item_name"]){
            self.ocjStr_title = [value description];
            
        }else if ([key isEqualToString:@"save_amt"]){
            self.ocjStr_score = [value description];
            
        }else if ([key isEqualToString:@"sale_price"]){
            self.ocjStr_price = [value description];
            
        }else if ([key isEqualToString:@"item_code"]){
          
          self.ocjStr_itemCode = [value description];
        }else if ([key isEqualToString:@"codeValue"]) {
          
          self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"pageVersionName"]) {
          
          self.ocjStr_pageVersionName = [value description];
        }else if ([key isEqualToString:@"promo_last_name"]) {
          self.ocjStr_giftName = [value description];
        }else if ([key isEqualToString:@"content_nm"]) {
          self.ocjStr_content_nm = [value description];
        }else if ([key isEqualToString:@"cust_price"]) {
          self.ocjStr_sellPrice = [value description];
        }
    }
}

@end

