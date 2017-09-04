//
//  OCJHttp_evaluateAPI.m
//  OCJ
//
//  Created by Ray on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJHttp_evaluateAPI.h"
#import "OCJResponseModel_evaluate.h"

NSString *const OCJURLPath_EvaluateGoods = @"/api/interactions/comments/add";               ///< 评价写入接口
NSString *const OCJURLPath_GetImageAddr = @"/api/interactions/comments/uploadpicture";      ///< 图片批量上传接口
NSString *const OCJURLPath_Refund = @"/api/customerservice/itemreturn/application";         ///< 申请退换货写入接口
NSString *const OCJURLPath_RefundResonCode = @"/api/customerservice/itemreturn/reason";     ///< 退换货原因接口
NSString *const OCJURLPath_GetOrderDetail = @"/api/orders/orders/orderdetail";              ///<获取订单详情接口

@implementation OCJHttp_evaluateAPI

+ (void)ocjPersonal_RefundGoodsWithOrderNO:(NSDictionary *)orderNo completionHandler:(OCJHttpResponseHander)handler{
  
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_Refund parameters:orderNo andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
      
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}
+ (void)ocj_getRefunndGoodsReasonCodeWithOrderNO:(NSDictionary *)orderNo completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:orderNo forKey:@"orderNo"];
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_RefundResonCode parameters:mDic andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }

    }];

}
+ (void)ocjPersonal_evaluateGoodsWithDictionary:(NSDictionary *)dic completionHandler:(OCJHttpResponseHander)handler {
     //item_code 商品 order_no 订单编号 score1 商品质量 score2 商品价格 score3 配送速度 score4 商品服务 evaluate 评价内容 item_price 商品价格 item_name 商品名称 src 图片地址
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_EvaluateGoods parameters:[dic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)ocjPersonal_getImageAddressWithOrderNo:(NSString *)order_no goodsNo:(NSString *)order_g_seq giftNo:(NSString *)order_d_seq operatonNo:(NSString *)order_w_seq retItemCode:(NSString*)retItemCode retUnitCode:(NSString*)retUnitCode receiverSeq:(NSString*)receiverSeq imageArr:(NSArray *)imageArr completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:order_no forKey:@"orderNo"];
    [mDic setValue:order_g_seq forKey:@"orderGSeq"];
    [mDic setValue:order_d_seq forKey:@"orderDSeq"];
    [mDic setValue:order_w_seq forKey:@"orderWSeq"];
    [mDic setValue:retItemCode forKey:@"ItemCode"];
    [mDic setValue:retUnitCode forKey:@"UnitCode"];
    [mDic setValue:receiverSeq forKey:@"receiverSeq"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_fromData_POSTWithUrlPath:OCJURLPath_GetImageAddr prameters:[mDic copy] files:imageArr andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJResponceModel_imageAddr *model = [[OCJResponceModel_imageAddr alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
         
        handler(model);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)ocjPersonal_getOrderDetailWithOrderNo:(NSString *)order_no orderType:(NSString *)order_type c_code:(NSString *)c_code completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:order_no forKey:@"order_no"];
    [mDic setValue:order_type forKey:@"order_type"];
    [mDic setValue:c_code forKey:@"c_code"];
  
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GetOrderDetail parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
    
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

@end
