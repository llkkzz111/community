//
//  OCJHttp_orderConfirmAPI.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJHttp_orderConfirmAPI.h"
#import "OCJResponseModel_confirmOrder.h"

NSString *const OCJURLPath_AppointmentOrder = @"/api/orders/advanceorders/provide_advance_order_info";      ///<预约订单生成接口
NSString *const OCJURLPath_ConfirmAppointmentOrder = @"/api/orders/advanceorders/create_advance_order";     ///<预约订单信息接口

@implementation OCJHttp_orderConfirmAPI

+ (void)ocjShoppingCart_createAppointmentOrderWithDictionary:(NSDictionary *)dic completionHandler:(OCJHttpResponseHander)handler {
  
  [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_AppointmentOrder parameters:[dic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
    
    OCJResponceModel_confirmOrder *model = [[OCJResponceModel_confirmOrder alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
    handler(model);
    if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
      [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
    }
  }];
}

+ (void)ocjShoppingCart_confirmAppointmentOrderWithItemcode:(NSString *)item_code unitcode:(NSString *)unit_code payMethod:(NSString *)pay_methd saveamt:(NSString *)saveamt deposit:(NSString *)deposit savebouns:(NSString *)savebouns receiverSeq:(NSString *)receiver_seq itemCodeCoupon:(NSString *)itemCodeCoupon dccouponAmt:(NSString *)dccounpon_amt contactMe:(NSString *)pay_flg completionhandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:item_code forKey:@"item_code"];
    [mDic setValue:unit_code forKey:@"unit_code"];
    [mDic setValue:pay_methd forKey:@"pay_mthd"];
    [mDic setValue:saveamt forKey:@"saveamt"];
    [mDic setValue:deposit forKey:@"deposit"];
    [mDic setValue:savebouns forKey:@"savebouns"];
    [mDic setValue:receiver_seq forKey:@"receiver_seq"];
    [mDic setValue:itemCodeCoupon forKey:@"itemCodeCoupon"];
    [mDic setValue:dccounpon_amt forKey:@"dccounpon_amt"];
    [mDic setValue:pay_flg forKey:@"pay_flg"];
  
  [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_ConfirmAppointmentOrder parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
    
    handler(responseModel);
    if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
      [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
    }
  }];
}

@end
