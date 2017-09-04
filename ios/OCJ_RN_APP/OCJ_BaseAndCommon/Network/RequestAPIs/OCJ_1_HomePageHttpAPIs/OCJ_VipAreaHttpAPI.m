//
//  OCJ_VipAreaHttpAPI.m
//  OCJ
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJ_VipAreaHttpAPI.h"
#import "OCJResponseModel_SMG.h"

NSString *const OCJURLPath_VIPAreaHome = @"/api/items/item/viphomepage";           ///<VIP专区首页
NSString *const OCJURLPath_SMG_lotto = @"/api/events/smg/redpackets";           ///< SMG 抽奖接口
NSString *const OCJURLPath_SMG_detail = @"/cms/pages/relation/pageV1";            ///< SMG 信息获取接口

@implementation OCJ_VipAreaHttpAPI

+ (void)ocjVipArea_checkHomeHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_VIPAreaHome parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            OCJVIPModel_Detail* model = [[OCJVIPModel_Detail alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
            
            handler(model);
        }else{
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}


+ (void)ocj_SMG_lottoWithUintNo:(NSString*)unitNo unitPassword:(NSString*)unitPassword lifeStyle:(NSString *)rd completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:unitNo forKey:@"event_no"];
    [mDic setValue:unitPassword forKey:@"pwd"];
    [mDic setValue:rd forKey:@"rd"];
  
    [[OCJNetWorkCenter sharedCenter]ocj_POSTWithUrlPath:OCJURLPath_SMG_lotto parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
      
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        
        handler(responseModel);
      }else{
        [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
      }
      
    }];
}

+ (void)ocj_SMG_getDetailInfoCompletionHandler:(OCJHttpResponseHander)handler{
  NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
  [mDic setValue:@"AP1706A002" forKey:@"id"];
  
  [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_SMG_detail parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
    
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      
      OCJResponseModel_SMG *model = [[OCJResponseModel_SMG alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
      handler(model);
    }else{
      [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
    }
  }];
  
}

@end
