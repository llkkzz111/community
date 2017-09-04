//
//  OCJ_GlobalShoppingHttpAPI.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJ_GlobalShoppingHttpAPI.h"
NSString *const OCJURLPath_GlobalShoppingHome = @"/cms/pages/relation/pageV1";           ///<全球购首页
NSString *const OCJURLPath_GlobalShoppingHomeNextPage = @"/cms/pages/relation/nextPageV1";           ///<全球购首页更多

NSString *const OCJURLPath_GlobalShoppingGoodList = @"/cms/pages/relation/pageV1";           ///<全球购商品列表

NSString *const OCJURLPath_GlobalShoppingGoodListNextPage = @"/cms/pages/relation/nextPageV1";           ///<全球购商品列表更多

NSString *const OCJURLPath_GlobalShoppingScreeningCondition = @"/api/items/items/globaldistrictbrand";           ///<全球购商品筛选条件


NSString *const OCJURLPath_StartImageHome = @"/cms/pages/relation/page"; ///<广告页


@implementation OCJ_GlobalShoppingHttpAPI

+ (void)ocjGlobalShopping_checkHomeHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
  [mDic setValue:@"AP1706A004" forKey:@"id"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GlobalShoppingHome parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJGSModel_Detail * model = [[OCJGSModel_Detail alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)ocjGlobalShopping_checkHomeNext:(NSString *)componentid
                                PageNum:(NSString *)pagenum
                               PageSize:(NSString *)pagesize
                      complationHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setObject:componentid forKey:@"id"];
    [mDic setObject:pagenum forKey:@"pageNum"];
    [mDic setObject:pagesize forKey:@"pageSize"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GlobalShoppingHomeNextPage parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
      OCJLog(@"%@", responseModel);
      OCJGSModel_MorePageList* model = [[OCJGSModel_MorePageList alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)ocjGlobalShopping_checkGoodList:(NSString *)lGroup
                            contentType:(NSString*)contentType
                      ComplationHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:@"AP1706A007" forKey:@"id"];
    [mDic setValue:lGroup forKey:@"lgroup"];
    [mDic setValue:contentType forKey:@"contentType"];
  
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GlobalShoppingGoodList parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJGSModel_listDetail* model = [[OCJGSModel_listDetail alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
      
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)ocjGlobalShopping_checkGoodListNext:(NSString *)componentid
                                    PageNum:(NSString *)pagenum
                         ScreeningCondition:(NSDictionary *)dictionary
                                ContentCode:(NSString *)contenCode
                          complationHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setObject:componentid forKey:@"id"];
    [mDic setObject:pagenum forKey:@"pageNum"];
    [mDic addEntriesFromDictionary:dictionary];
  
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GlobalShoppingGoodListNextPage parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
      
        OCJGSModel_moreListDetail* model = [[OCJGSModel_moreListDetail alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)ocjGlobalShopping_getScreeningConditionComplationHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
  
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GlobalShoppingScreeningCondition parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
      
      
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        OCJGSModel_ScreeningCondition* model = [[OCJGSModel_ScreeningCondition alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        
        handler(model);
      }
      
    }];
}

+ (void)ocjGlobalShopping_checkOCJURLPath_StartImageHomeComplationHandler:(OCJHttpResponseHander)handler {
  NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
  [mDic setObject:@"AP1706A050" forKey:@"id"];
  
  [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_StartImageHome parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeNone completionHandler:^(OCJBaseResponceModel *responseModel) {
    
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      handler(responseModel);
    }
  }];
}


@end
