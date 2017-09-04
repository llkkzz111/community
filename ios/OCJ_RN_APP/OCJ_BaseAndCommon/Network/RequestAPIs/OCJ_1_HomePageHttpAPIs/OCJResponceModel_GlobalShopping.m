//
//  OCJResponceModel_GlobalShopping.m
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJResponceModel_GlobalShopping.h"

@implementation OCJResponceModel_GlobalShopping

@end

@implementation OCJGSModel_Detail

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"packageList"] && [value isKindOfClass:[NSArray class]]) {
        NSArray* globalArray = (NSArray*)value;//单元列表
        NSMutableArray* packageArray = [NSMutableArray arrayWithObjects:@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[],@[], nil];
      
        for (NSInteger i=0; i<globalArray.count; i++) {//==============
          
            NSDictionary * packageDic = globalArray[i];
          
            if ([packageDic isKindOfClass:[NSDictionary class]]) {
                NSArray* itemArr = packageDic[@"componentList"];//元素列表
                NSString* shortNumStr = [packageDic[@"shortNumber"]description];//package 下标
                NSInteger shortNum = 500;//占位，数值无用
                if (!shortNumStr && ![shortNumStr isKindOfClass:[NSNull class]]) {
                    continue;
                }
              
                if ([itemArr isKindOfClass:[NSArray class]] && itemArr.count>0) {
                    NSMutableArray* newItemMArr = [NSMutableArray array];
                    for (NSDictionary* itemDic in itemArr) {//=============
                  
                        if ([itemDic isKindOfClass:[NSDictionary class]]) {
                            if ([shortNumStr isEqualToString:@"0"]) {
                                OCJGSModel_Package2* model = [[OCJGSModel_Package2 alloc]init];
                                [model setValuesForKeysWithDictionary:itemDic];
                                [newItemMArr addObject:model];
                                shortNum  = [shortNumStr integerValue];
                      
                            }else if ([shortNumStr isEqualToString:@"1"]){
                                OCJGSModel_Package4* model = [[OCJGSModel_Package4 alloc]init];
                                [model setValuesForKeysWithDictionary:itemDic];
                                [newItemMArr addObject:model];
                                shortNum  = [shortNumStr integerValue];
                            }else if ([shortNumStr isEqualToString:@"2"] || [shortNumStr isEqualToString:@"6"] || [shortNumStr isEqualToString:@"8"]){
                              
                                NSArray* subItemArr = itemDic[@"componentList"];
                                NSString* subShortNumStr = [itemDic[@"shortNumber"]description];//此类型只取itemArr的第一个元素的数组来展示
                                if ([subItemArr isKindOfClass:[NSArray class]] && [subShortNumStr isEqualToString:@"0"]) {
                                    for (NSDictionary* subItemDic in subItemArr) {
                                        if ([subItemDic isKindOfClass:[NSDictionary class]]) {
                                            OCJGSModel_Package42* model = [[OCJGSModel_Package42 alloc]init];
                                            [model setValuesForKeysWithDictionary:subItemDic];
                                            [newItemMArr addObject:model];
                                        }
                                    }
                                }
                              
                                shortNum  = [shortNumStr integerValue];
                              
                            }else if ([shortNumStr isEqualToString:@"3"]){
                              
                                NSArray* subItemArr = itemDic[@"componentList"];
                                NSString* subShortNumStr = [itemDic[@"shortNumber"]description];//此类型只取itemArr的第一个元素的数组来展示
                                if ([subItemArr isKindOfClass:[NSArray class]] && [subShortNumStr isEqualToString:@"0"]) {
                                  for (NSDictionary* subItemDic in subItemArr) {
                                      if ([subItemDic isKindOfClass:[NSDictionary class]]) {
                                          OCJGSModel_Package43* model = [[OCJGSModel_Package43 alloc]init];
                                          [model setValuesForKeysWithDictionary:subItemDic];
                                          [newItemMArr addObject:model];
                                      }
                                  }
                                }
                              
                              shortNum  = [shortNumStr integerValue];
                              
                            }else if ([shortNumStr isEqualToString:@"4"] || [shortNumStr isEqualToString:@"9"] || [shortNumStr isEqualToString:@"10"] || [shortNumStr isEqualToString:@"11"] || [shortNumStr isEqualToString:@"12"]){
                                OCJGSModel_Package14* model = [[OCJGSModel_Package14 alloc]init];
                                [model setValuesForKeysWithDictionary:itemDic];
                                [newItemMArr addObject:model];
                                shortNum  = [shortNumStr integerValue];
                              
                            }else if ([shortNumStr isEqualToString:@"5"] || [shortNumStr isEqualToString:@"7"]){
                                OCJGSModel_Package10* model = [[OCJGSModel_Package10 alloc]init];
                                [model setValuesForKeysWithDictionary:itemDic];
                                [newItemMArr addObject:model];
                                shortNum  = [shortNumStr integerValue];
                              
                            }else if ([shortNumStr isEqualToString:@"13"]){
                                NSArray* subItemArr = itemDic[@"componentList"];
                                NSString* subShortNumStr = [itemDic[@"shortNumber"]description];//此类型只取itemArr的第一个元素的数组来展示
                                if ([subItemArr isKindOfClass:[NSArray class]] && [subShortNumStr isEqualToString:@"0"]) {
                                    for (NSDictionary* subItemDic in subItemArr) {
                                        if ([subItemDic isKindOfClass:[NSDictionary class]]) {
                                            OCJGSModel_Package44* model = [[OCJGSModel_Package44 alloc]init];
                                            [model setValuesForKeysWithDictionary:subItemDic];
                                            [newItemMArr addObject:model];
                                        }
                                    }
                                }
                              
                              shortNum  = [shortNumStr integerValue];
                            }
                    
                        }
                    }
                  
                    if (shortNum != 500 && shortNum < packageArray.count) {
                        [packageArray replaceObjectAtIndex:shortNum withObject:[newItemMArr copy]];
                    }
                  
                }
            }
          
        }
      
        self.ocjArr_packages = [packageArray copy]; 
    }else if ([key isEqualToString:@"codeValue"]) {
      self.ocjStr_codeValue = [value description];
    }else if ([key isEqualToString:@"pageVersionName"]) {
      self.ocjStr_pageVersionName = [value description];
    }
  }
}

@end

@implementation OCJGSModel_Package2

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"firstImgUrl"]) {
        self.ocjStr_imageUrl = [value description];
      
    }else if ([key isEqualToString:@"destinationUrl"]){
      self.ocjStr_destinationUrl = [value description];
      
    }else if ([key isEqualToString:@"id"]){
      
      
    }else if ([key isEqualToString:@"isNew"]){
      
      
    }else if ([key isEqualToString:@"codeValue"]) {
      self.ocjStr_codeValue = [value description];
    }else if ([key isEqualToString:@"pageVersionName"]) {
      self.ocjStr_pageVersionName = [value description];
    }
  }
}

@end

@implementation OCJGSModel_Package4

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"firstImgUrl"]) {
      self.ocjStr_imageUrl = [value description];
      
    }else if ([key isEqualToString:@"destinationUrl"]){
      
      
    }else if ([key isEqualToString:@"id"]){
      
      
    }else if ([key isEqualToString:@"isNew"]){
      
      
    }else if ([key isEqualToString:@"title"]){
      
        self.ocjStr_title = [value description];
    }else if ([key isEqualToString:@"lgroup"]){
      
      self.ocjStr_lGroup = [value description];
    }else if ([key isEqualToString:@"codeValue"]) {
      self.ocjStr_codeValue = [value description];
    }else if ([key isEqualToString:@"pageVersionName"]) {
      self.ocjStr_pageVersionName = [value description];
    }else if ([key isEqualToString:@"contentType"]){
      self.ocjStr_contentType = [value description];
      
    }
  }
}

@end

@implementation OCJGSModel_Package42

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"firstImgUrl"]) {
      self.ocjStr_imageUrl = [value description];
      
    }else if ([key isEqualToString:@"destinationUrl"]){
      
      
    }else if ([key isEqualToString:@"id"]){
      
      
    }else if ([key isEqualToString:@"isNew"]){
      
      
    }else if ([key isEqualToString:@"title"]){
      
      self.ocjStr_title = [value description];
    }else if ([key isEqualToString:@"salePrice"]){
      
      self.ocjStr_price = [value description];
    }else if ([key isEqualToString:@"contentCode"]){
      
      self.ocjStr_itemCode = [value description];
    }else if ([key isEqualToString:@"codeValue"]) {
      
      self.ocjStr_codeValue = [value description];
    }else if ([key isEqualToString:@"pageVersionName"]) {
      
      self.ocjStr_pageVersionName = [value description];
    }else if ([key isEqualToString:@"countryName"]){
      
      self.ocjStr_country = [value description];
    }else if ([key isEqualToString:@"countryImgUrl"]){
      
      self.ocjStr_countryImageUrl = [value description];
    }else if ([key isEqualToString:@"countryCode"]){
      
      self.ocjStr_countryCode = [value description];
    }else if ([key isEqualToString:@"lgroup"]){
      
      self.ocjStr_lGroup = [value description];
    }else if ([key isEqualToString:@"contentType"]){
      
      self.ocjStr_contentType = [value description];
    }
    
  }
}

@end

@implementation OCJGSModel_Package43

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"firstImgUrl"]) {
      self.ocjStr_imageUrl = [value description];
      
    }else if ([key isEqualToString:@"codeValue"]){
      self.ocjStr_codeValue = [value description];
      
    }else if ([key isEqualToString:@"destinationUrl"]){
      
      
    }else if ([key isEqualToString:@"countryImgUrl"]){
      
      self.ocjStr_countryImageUrl = [value description];
    }else if ([key isEqualToString:@"id"]){
      
      
    }else if ([key isEqualToString:@"isNew"]){
      
      
    }else if ([key isEqualToString:@"title"]){
      
      self.ocjStr_title = [value description];
    }else if ([key isEqualToString:@"salePrice"]){
      
      self.ocjStr_price = [value description];
    }else if ([key isEqualToString:@"subtitle"]){
      
      self.ocjStr_subTitle = [value description];
    }else if ([key isEqualToString:@"contentCode"]){
      
      self.ocjStr_itemCode = [value description];
    }
  }
}

@end

@implementation OCJGSModel_Package14

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"firstImgUrl"]) {
      self.ocjStr_imageUrl = [value description];
      
    }else if ([key isEqualToString:@"destinationUrl"]){
      
      self.ocjStr_destinationUrl = [value description];
    }else if ([key isEqualToString:@"id"]){
      
      
    }else if ([key isEqualToString:@"isNew"]){
      self.ocjStr_status = [value description];
      
    }else if ([key isEqualToString:@"title"]){
      
      self.ocjStr_title = [value description];
    }else if ([key isEqualToString:@"subtitle"]){
      
      self.ocjStr_subTitle = [value description];
    }else if ([key isEqualToString:@"codeValue"]) {
      
      self.ocjStr_codeValue = [value description];
    }else if ([key isEqualToString:@"pageVersionName"]) {
      
      self.ocjStr_pageVersionName = [value description];
    }else if ([key isEqualToString:@"lgroup"]){
      
      self.ocjStr_lGroup = [value description];
    }else if ([key isEqualToString:@"contentType"]){
      
      self.ocjStr_contentType = [value description];
    }
  }
}

@end

@implementation OCJGSModel_Package10

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"firstImgUrl"]) {
      self.ocjStr_imageUrl = [value description];
      
    }else if ([key isEqualToString:@"destinationUrl"]){
      
      self.ocjStr_destinationUrl = [value description];
    }else if ([key isEqualToString:@"id"]){
      
      
    }else if ([key isEqualToString:@"codeValue"]) {
      self.ocjStr_codeValue = [value description];
    }else if ([key isEqualToString:@"pageVersionName"]) {
      self.ocjStr_pageVersionName = [value description];
    }
  }
}

@end

@implementation OCJGSModel_Package44

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"firstImgUrl"]) {
      self.ocjStr_imageUrl = [value description];
      
    }else if ([key isEqualToString:@"countryName"]) {
      
      self.ocjStr_country = [value description];
    }else if ([key isEqualToString:@"countryImgUrl"]){
      
      self.ocjStr_countryImageUrl = [value description];
    }else if ([key isEqualToString:@"id"]){
      self.ocjStr_id = [value description];
      
    }else if ([key isEqualToString:@"isInStock"]){
      
      self.ocjStr_isInStock = [value description];
    }else if ([key isEqualToString:@"title"]){
      
      self.ocjStr_title = [value description];
    }else if ([key isEqualToString:@"subtitle"]){
      
      self.ocjStr_subTitle = [value description];
    }else if ([key isEqualToString:@"salePrice"]){
      
      self.ocjStr_price = [value description];
    }else if ([key isEqualToString:@"contentCode"]){
      
      self.ocjStr_itemCode = [value description];
    }else if ([key isEqualToString:@"codeValue"]) {
      
      self.ocjStr_codeValue = [value description];
    }else if ([key isEqualToString:@"pageVersionName"]) {
      
      self.ocjStr_pageVersionName = [value description];
    }else if ([key isEqualToString:@"discount"]) {
      
      self.ocjStr_discount = [value description];
    }else if ([key isEqualToString:@"gifts"]) {
      
      self.ocjStr_giftContent = [value description];
    }
  }
}



@end

@implementation OCJGSModel_MorePageList

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
      if ([key isEqualToString:@"list"] && [value isKindOfClass:[NSArray class]]) {
          NSArray* items = (NSArray*)value;
          NSMutableArray* mArray = [NSMutableArray array];
          for (NSDictionary* itemDic in items) {
              if ([itemDic isKindOfClass:[NSDictionary class]]) {
                  OCJGSModel_Package44* model = [[OCJGSModel_Package44 alloc]init];
                  [model setValuesForKeysWithDictionary:itemDic];
                  [mArray addObject:model];
              }
          }
          self.ocjArr_moreItems = [mArray copy];
      }else if ([key isEqualToString:@"codeValue"]) {
        self.ocjStr_codeValue = [value description];
      }else if ([key isEqualToString:@"pageVersionName"]) {
        self.ocjStr_pageVersionName = [value description];
      }
  }
}

@end


@implementation OCJGSModel_ScreeningCondition

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"regionlist"] && [value isKindOfClass:[NSArray class]]) {
      NSArray* items = (NSArray*)value;
      NSMutableArray* mArray = [NSMutableArray array];
      
      for (NSDictionary* itemDic in items) {
        if ([itemDic isKindOfClass:[NSDictionary class]]) {
          
          OCJGSModel_HotArea* model = [[OCJGSModel_HotArea alloc]init];
          [model setValuesForKeysWithDictionary:itemDic];
          [mArray addObject:model];
          
        }
      }
      self.ocjArr_hotAreas = [mArray copy];
      
    }else if ([key isEqualToString:@"globalbrandinfo"] && [value isKindOfClass:[NSArray class]]) {
      NSArray* items = (NSArray*)value;
      NSMutableArray* mArray = [NSMutableArray array];
      
      for (NSDictionary* itemDic in items) {
        if ([itemDic isKindOfClass:[NSDictionary class]]) {
          
          OCJGSModel_Brand* model = [[OCJGSModel_Brand alloc]init];
          [model setValuesForKeysWithDictionary:itemDic];
          [mArray addObject:model];
          
        }
      }
      
      self.ocjArr_Brands = [mArray copy];
    }
  }
}

@end

@implementation OCJGSModel_HotArea

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    
    if ([key isEqualToString:@"region_code"]) {
      
        self.ocjStr_areaCode = [value description];
    }else if ([key isEqualToString:@"region_name"]) {
      
        self.ocjStr_areaName = [value description];
    }
    
  }
}

@end

@implementation OCJGSModel_Brand

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    
    if ([key isEqualToString:@"propertyName"]) {
      
      self.ocjStr_brandCode = [value description];
    }else if ([key isEqualToString:@"propertyValue"] && [value isKindOfClass:[NSArray class]]) {
      
      NSArray* brandNames = (NSArray*)value;
      if (brandNames.count>0) {
        self.ocjStr_brandName = [brandNames[0] description];
      }
      
    }
    
  }
}

@end

@implementation OCJGSModel_listDetail

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
      
    if ([key isEqualToString:@"codeValue"]) {
      
      self.ocjStr_codeValue = [value description];
    }else if ([key isEqualToString:@"pageVersionName"]) {
      
      self.ocjStr_pageVersionName = [value description];
    }else if ([key isEqualToString:@"packageList"] && [value isKindOfClass:[NSArray class]]){
      
      NSArray* packageList = (NSArray*)value;
      if ([packageList isKindOfClass:[NSArray class]] && packageList.count>0) {
        
        id component = [packageList objectAtIndex:0];
        if ([component isKindOfClass:[NSDictionary class]]) {
          
          NSArray* goodpackageList = [component objectForKey:@"componentList"];
          if ([goodpackageList isKindOfClass:[NSArray class]] && goodpackageList.count>0){
            
            id goodpackage = [goodpackageList objectAtIndex:0];
            if ( [goodpackage isKindOfClass:[NSDictionary class]]) {
              
              self.ocjStr_goodsID = [goodpackage objectForKey:@"id"];
              NSArray* goodlist = [goodpackage objectForKey:@"componentList"];
              if ([goodlist isKindOfClass:[NSArray class]]){
                NSMutableArray* mArray = [NSMutableArray array];
                for (NSDictionary* good in goodlist) {
                  if ([good isKindOfClass:[NSDictionary class]]) {
                    
                    OCJGSModel_Package44* model = [[OCJGSModel_Package44 alloc]init];
                    [model setValuesForKeysWithDictionary:good];
                    [mArray addObject:model];
                    
                  }
                }
                
                self.ocjArr_listItem = [mArray copy];
              }
            }
          }
        }
      }
    }
  }
}

@end


@implementation OCJGSModel_moreListDetail

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
  
  if (value && ![value isKindOfClass:[NSNull class]]) {
    
    if ([key isEqualToString:@"list"] && [value isKindOfClass:[NSArray class]]) {
      NSArray* goodList = (NSArray*)value;
      
      NSMutableArray* mArray = [NSMutableArray array];
      for (NSDictionary* goodDic in goodList) {
        
        if ([goodDic isKindOfClass:[NSDictionary class]]) {
          
          OCJGSModel_Package44* model = [[OCJGSModel_Package44 alloc]init];
          [model setValuesForKeysWithDictionary:goodDic];
          [mArray addObject:model];
        }
        
      }
      
      self.ocjArr_listItem = [mArray copy];
    }
  }
}

@end
