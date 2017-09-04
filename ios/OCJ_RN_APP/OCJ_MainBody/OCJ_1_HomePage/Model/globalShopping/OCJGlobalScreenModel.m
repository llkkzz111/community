//
//  OCJGlobalScreenModel.m
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/7/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJGlobalScreenModel.h"

@implementation OCJGlobalScreenRequestModel


@end


@implementation OCJGSRModel_screenCondition
-(instancetype)init{
  self = [super init];
  if (self) {
    
    [self ocj_resetScreenCondition];
    
  }
  return self;
}

-(void)ocj_resetScreenCondition{
    self.ocjBool_isAll = YES;
  
    self.ocjStr_priceSort = @"";
    self.ocjStr_salesVolumeSort = @"";
  
    self.ocjArr_areaFiltrate = @[];
    self.ocjStr_area = @"";
    self.ocjStr_areaCode = @"";
  
    self.ocjArr_brandFiltrate = @[];
    self.ocjStr_brand = @"";
    self.ocjStr_brandCode = @"";
  
    self.ocjStr_cate = @"";
    self.ocjStr_superValueFiltrate = @"";
}

-(NSDictionary *)ocj_getRequestDicFromSelf{
  NSMutableDictionary* mDic = [[NSMutableDictionary alloc]init];
  [mDic setValue:self.ocjStr_priceSort forKey:@"priceSort"];
  [mDic setValue:self.ocjStr_salesVolumeSort forKey:@"salesSort"];
  [mDic setValue:self.ocjStr_superValueFiltrate forKey:@"singleProductitions"];
  
  [mDic setValue:self.ocjStr_areaCode forKey:@"areaConditions"];
  [mDic setValue:self.ocjStr_brandCode forKey:@"brandConditions"];
  [mDic setValue:self.ocjStr_cate forKey:@"cateConditions"];
  
  return [mDic copy];
}

#pragma mark - setter 
-(void)setOcjStr_priceSort:(NSString *)ocjStr_priceSort{
  _ocjStr_priceSort = ocjStr_priceSort;
  if (ocjStr_priceSort.length>0) {
    
    self.ocjBool_isAll = NO;
    self.ocjStr_salesVolumeSort = @"";
    
  }else if([self.ocjStr_salesVolumeSort isEqualToString:@""]){
    
    self.ocjBool_isAll = YES;
  }
}

-(void)setOcjStr_salesVolumeSort:(NSString *)ocjStr_salesVolumeSort{
  _ocjStr_salesVolumeSort = ocjStr_salesVolumeSort;
  
  if (ocjStr_salesVolumeSort.length>0) {
    self.ocjBool_isAll = NO;
    self.ocjStr_priceSort = @"";
  }else if([self.ocjStr_priceSort isEqualToString:@""]){
    self.ocjBool_isAll = YES;
  }
}

-(void)setOcjStr_superValueFiltrate:(NSString *)ocjStr_superValueFiltrate{
  _ocjStr_superValueFiltrate = ocjStr_superValueFiltrate;
  
  if (ocjStr_superValueFiltrate.length>0) {
    self.ocjBool_isAll = NO;
    self.ocjArr_areaFiltrate = @[];
    self.ocjStr_areaCode = @"";
    self.ocjStr_area = @"";
    
    self.ocjArr_brandFiltrate  = @[];
    self.ocjStr_brandCode = @"";
    self.ocjStr_brand = @"";
  }

}

-(void)setOcjArr_areaFiltrate:(NSArray<OCJGSModel_HotArea *> *)ocjArr_areaFiltrate{
  _ocjArr_areaFiltrate = ocjArr_areaFiltrate;
  
  if (ocjArr_areaFiltrate.count>0) {
    self.ocjBool_isAll = NO;
    self.ocjArr_brandFiltrate = @[];
    self.ocjStr_brand = @"";
    self.ocjStr_brandCode = @"";
    self.ocjStr_superValueFiltrate  = @"";
    
    NSMutableString* codeMString = [NSMutableString string];
    NSMutableString* nameMString = [NSMutableString string];
    for (OCJGSModel_HotArea* hotArea in ocjArr_areaFiltrate) {
      
      [codeMString appendString:hotArea.ocjStr_areaCode];
      [nameMString appendString:hotArea.ocjStr_areaName];
      
      NSInteger index = [self.ocjArr_areaFiltrate indexOfObject:hotArea];
      if (index != self.ocjArr_areaFiltrate.count-1) {
        [codeMString appendString:@","];
        [nameMString appendString:@","];
      }
    }
    self.ocjStr_area = [nameMString copy];
    self.ocjStr_areaCode = [codeMString copy];
  }else{
    self.ocjStr_area = @"";
    self.ocjStr_areaCode = @"";
  }
  
}

-(void)setOcjArr_brandFiltrate:(NSArray<OCJGSModel_Brand *> *)ocjArr_brandFiltrate{
  _ocjArr_brandFiltrate = ocjArr_brandFiltrate;
  
  if (ocjArr_brandFiltrate.count>0) {
    self.ocjBool_isAll = NO;
    self.ocjArr_areaFiltrate = @[];
    self.ocjStr_area = @"";
    self.ocjStr_areaCode = @"";
    self.ocjStr_superValueFiltrate  = @"";
    
    NSMutableString* codeMString = [NSMutableString string];
    NSMutableString* nameMString = [NSMutableString string];
    for (OCJGSModel_Brand* brand in ocjArr_brandFiltrate) {
      
      [codeMString appendString:brand.ocjStr_brandCode];
      [nameMString appendString:brand.ocjStr_brandName];
      
      NSInteger index = [self.ocjArr_brandFiltrate indexOfObject:brand];
      if (index != self.ocjArr_brandFiltrate.count-1) {
        [codeMString appendString:@","];
        [nameMString appendString:@","];
      }
    }
    
    self.ocjStr_brand = [nameMString copy];
    self.ocjStr_brandCode = [codeMString copy];
  }else{
    self.ocjStr_brand = @"";
    self.ocjStr_brandCode = @"";
  }
  
}


@end
