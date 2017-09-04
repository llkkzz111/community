//
//  OCJHttp_onLinePayAPI.m
//  OCJ
//
//  Created by OCJ on 2017/5/26.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJHttp_onLinePayAPI.h"
#import "OCJTestDataSource.h"

NSString *const OCJURLPath_payForMoney     =  @"/api/orders/orders/ordersuccess";              ///< 在线支付接口
NSString *const OCJURLPath_Evidence        =  @"/api/pay/pay_center";                          ///< 支付凭证接口获取
NSString *const OCJURLPath_queryOrderState =  @"/api/pay/check_orderpaystatus";                ///< 订单状态查询
NSString *const OCJURLPath_ProRecommand    =  @"/api/items/other-items";                       ///< 商品同品推荐
NSString *const OCJURLPath_reson           =  @"/api/customerservice/itemreturn/reason";       ///< 获取退换货原因接口


@implementation OCJHttp_onLinePayAPI


+ (void)ocj_getReChangeResonComplationHandler:(OCJHttpResponseHander)handler{
  [[OCJNetWorkCenter sharedCenter]ocj_GETWithUrlPath:OCJURLPath_reson parameters:[NSMutableDictionary dictionary] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
    handler(responseModel);
    
    if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
      [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
    }
  }];
}

+ (void)ocj_getAllRecommandComplationHandler:(OCJHttpResponseHander)handler{
    [[OCJNetWorkCenter sharedCenter]ocj_GETWithUrlPath:OCJURLPath_ProRecommand parameters:[NSDictionary dictionary] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjPayMoneyWithOrderNO:(NSString *)orderNO complationHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary * mDic = [NSMutableDictionary dictionary];
    [mDic setValue:orderNO forKey:@"order_no"];
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_payForMoney parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJModel_onLinePay * model = [[OCJModel_onLinePay alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjPayGetEvidenceWithOrderNo:(NSString *)order_no paymthod:(NSString *)paymthod saveamt:(NSString *)saveamt deposit:(NSString *)deposit gistcard:(NSString *)giftcard complationHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary * mDic = [NSMutableDictionary dictionary];
    [mDic setValue:order_no forKey:@"order_no"];
    [mDic setValue:paymthod forKey:@"paymthd"];
    [mDic setValue:saveamt forKey:@"saveamt"];
    [mDic setValue:deposit forKey:@"deposit"];
    [mDic setValue:giftcard forKey:@"giftcard"];
    [[OCJNetWorkCenter sharedCenter]ocj_GETWithUrlPath:OCJURLPath_Evidence parameters:mDic andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
      
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          
            handler(responseModel);
          
        }else if (![responseModel.ocjStr_code isEqualToString:@"1040100104"]) {
          
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}


+ (void)ocjQueryOrderSateWithOrderNO:(NSString *)order_no complationHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary * mDic = [NSMutableDictionary dictionary];
    [mDic setValue:order_no forKey:@"order_no"];
    [[OCJNetWorkCenter sharedCenter]ocj_POSTWithUrlPath:OCJURLPath_queryOrderState parameters:mDic andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        handler(responseModel);
    }];
}


@end

@implementation OCJModel_onLinePay

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"imgUrlList"] && [value isKindOfClass:[NSArray class]]) {
            self.ocjArr_imgUrlList = value  ;     ;
        }else if([key isEqualToString:@"lastPayment"] && [value isKindOfClass:[NSArray class]]){
            self.ocjArr_lastPayment = [NSMutableArray arrayWithArray:value];
        }else if([key isEqualToString:@"order_no"]){
            self.ocjStr_order_no = value;
        }else if([key isEqualToString:@"c_code"]){
            self.ocjStr_c_code = [value description];
        }else if ([key isEqualToString:@"double_deposit"]) {
            self.ocjStr_double_deposit = [value description];
        }else if ([key isEqualToString:@"double_cardamt"]) {
            self.ocjStr_double_cardamt = [value description];
        }else if ([key isEqualToString:@"double_saveamt"]) {
            self.ocjStr_double_saveamt = [value description];
        }else if ([key isEqualToString:@"cust_no"]) {//
            self.ocjStr_cust_no = [value description];
        }else if ([key isEqualToString:@"realPayAmt"]) {//
            self.ocjStr_realPayAmt = [value description];
        }else if ([key isEqualToString:@"useable_deposit"]) {
            self.ocjStr_useable_deposit = [value description];
        }else if ([key isEqualToString:@"useable_cardamt"]) {
            self.ocjStr_useable_cardamt = [value description];
        }else if ([key isEqualToString:@"useable_saveamt"]) {
            self.ocjStr_useable_saveamt = [value description];
        }else if([key isEqualToString:@"payStyle"]){
            self.ocjStr_payStyle = [value description];
        }else if ([key isEqualToString:@"saveamt_yn"]) {
          self.ocjStr_useSaveamt = [value description];
        }else if ([key isEqualToString:@"cardamt_yn"]) {
          self.ocjStr_useCardamt = [value description];
        }else if ([key isEqualToString:@"deposit_yn"]) {
          self.ocjStr_useDesposit = [value description];
        }else if ([key isEqualToString:@"online_redu_5"]) {
          self.ocjStr_onlineReduce = [value description];
        }
    }
}

@end
