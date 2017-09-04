//
//  OCJResponseModel_SMG.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJResponseModel_SMG.h"

@implementation OCJResponseModel_SMG

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  if (value && ![value isKindOfClass:[NSNull class]]) {
    
    if ([key isEqualToString:@"codeValue"]) {
      
      self.ocjStr_codeValue = [value description];
      
    }else if ([key isEqualToString:@"id"]) {
      
      self.ocjStr_id = [value description];
      
    }else if ([key isEqualToString:@"pageVersionName"]) {
      
      self.ocjStr_pageVersionName = [value description];
      
    }else if ([key isEqualToString:@"packageList"] && [value isKindOfClass:[NSArray class]]) {
      
      NSMutableArray* mArray = [NSMutableArray array];
      for (NSDictionary *dic in value) {
        
          if ([dic isKindOfClass:[NSDictionary class]]) {
              NSArray* itemComponentList = dic[@"componentList"];
              if ([itemComponentList isKindOfClass:[NSArray class]] && itemComponentList.count>0) {
                  NSDictionary* itemDic = [itemComponentList firstObject];
                  OCJResponseModel_SMGListDetail* smgItemDetail = [[OCJResponseModel_SMGListDetail alloc]init];
                  [smgItemDetail setValuesForKeysWithDictionary:itemDic];
                  [mArray addObject:smgItemDetail];
              }
          }
      }
      self.ocjArr_smgList = [mArray copy];
    }
  }
}



@end

@implementation OCJResponseModel_SMGListDetail

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  if (value && ![value isKindOfClass:[NSNull class]]) {
    if ([key isEqualToString:@"id"]) {
      self.ocjStr_id = [value description];
    }else if ([key isEqualToString:@"subtitle"]) {
      self.ocjStr_subTitle = [value description];
    }else if ([key isEqualToString:@"shortnumber"]) {
      self.ocjStr_shortNum = [value description];
    }else if ([key isEqualToString:@"codeValue"]) {
      self.ocjStr_codeValue = [value description];
    }else if ([key isEqualToString:@"codeId"]) {
      self.ocjStr_codeID = [value description];
    }else if ([key isEqualToString:@"firstImgUrl"]) {
      self.ocjStr_imageUrl = [value description];
    }else if ([key isEqualToString:@"componentId"]) {
      self.ocjStr_componentID = [value description];
    }else if ([key isEqualToString:@"isNew"]) {
      self.ocjStr_isNew = [value description];
    }else if ([key isEqualToString:@"isComponents"]) {
      self.ocjStr_isComponents = [value description];
    }else if ([key isEqualToString:@"destinationUrl"]) {
      self.ocjStr_destinationUrl = [value description];
    }else if ([key isEqualToString:@"title"]) {
      self.ocjStr_title = [value description];
    }else if ([key isEqualToString:@"graphicText"]) {
      self.ocjStr_rules = [value description];
    }
  }
}

@end
