//
//  OCJHttp_myWalletAPI.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJHttp_myWalletAPI.h"
#import "OCJTestDataSource.h"

NSString *const OCJURLPath_ExchangeGiftTickets  = @"/api/finances/gifttickets/exchange";            ///< 礼券兑换接口
NSString *const OCJURLPath_RechargeWallet       = @"/api/finances/giftcards/exchange";              ///< 钱包充值接口
NSString *const OCJURLPath_CheckBalance         = @"/api/finances/giftcards/left_exchange_amt";     ///< 余额查询接口

NSString *const OCJURLPath_CheckCouponDetail    = @"/api/finances/coupons/details";                 ///< 抵用券详情查询接口
NSString *const OCJURLPath_CheckCouponNum       = @"/api/finances/coupons/leftCustCoupon";          ///< 抵用券计数查询接口
NSString *const OCJURLPath_ExchangeCoupon       = @"/api/finances/coupons/drawcoupon";              ///< 抵用券兑换接口（淘券领取）

NSString *const OCJURLPath_ScoreDetail           = @"/api/finances/saveamts/details";                ///< 积分详情接口
NSString *const OCJURLPath_ScoreCheckBalance     = @"/api/finances/saveamts/leftsaveamt";            ///< 积分余额查询
NSString *const OCJURLPath_PreMoneyDetail        = @"/api/finances/deposits/details";                ///< 预付款详情接口
NSString *const OCJURLPath_PreMoneyCheckBalance  = @"/api/finances/deposits/leftdeposit";            ///< 预付款余额查询
NSString *const OCJURLPath_RewardDetail          = @"/api/finances/giftcards/details";               ///< 礼包详情接口
NSString *const OCJURLPath_RewardCheckBalance    = @"/api/finances/giftcards/leftgiftcard";          ///< 礼包余额查询

NSString *const OCJURLPath_TaoCouponDetail       = @"/api/finances/taocoupons/details";              ///< 淘券明细查询接口
NSString *const OCJURLPath_ExchangeTaoCoupon     = @"/api/finances/taocoupons/exchange";             ///< 淘券兑换接口
NSString *const OCJURLPath_GetTaoCoupon          = @"/api/finances/taocoupons/drawcoupon";           ///< 淘券领取接口

NSString *const OCJURLPath_EuropeDetail          = @"/api/members/opoints/details";                  ///< 欧点详情
NSString *const OCJURLPath_EuropeCheckBalance    = @"/api/members/opoints/leftsaveamt";              ///< 欧点余额查询

@implementation OCJHttp_myWalletAPI

+ (void)ocjWallet_scoreDetailWithType:(NSString *)type page:(NSInteger)page completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:type forKey:@"type"];
    [mDic setValue:@(page) forKey:@"page"];
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_ScoreDetail parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJWalletModel_ScoreDetail *model = [[OCJWalletModel_ScoreDetail alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {

            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_scoreQueryCompletionHandler:(OCJHttpResponseHander)handler{
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_ScoreCheckBalance parameters:nil andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJWalletModel_ScorecheckBalance * model = [[OCJWalletModel_ScorecheckBalance alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {

             [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}
+ (void)ocjWallet_PreMoneyQueryCompletionHandler:(OCJHttpResponseHander)handler{
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_PreMoneyCheckBalance parameters:nil andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJWalletModel_ScorecheckBalance * model = [[OCJWalletModel_ScorecheckBalance alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}
+ (void)ocjWallet_PreMoneyWithType:(NSString *)type page:(NSInteger)page completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:type forKey:@"type"];
    [mDic setValue:@(page) forKey:@"page"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_PreMoneyDetail parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {      
        OCJWalletModel_PreDetail *model = [[OCJWalletModel_PreDetail alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_RewardWithType:(NSString *)type page:(NSInteger)page completionHandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:type forKey:@"type"];
    [mDic setValue:@(page) forKey:@"page"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_RewardDetail parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJWalletModel_RewardDetail *model = [[OCJWalletModel_RewardDetail alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}
+ (void)ocjWallet_RewardQueryCompletionHandler:(OCJHttpResponseHander)handler{
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_RewardCheckBalance parameters:nil andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJWalletModel_RewardcheckBalance * model = [[OCJWalletModel_RewardcheckBalance alloc]initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}
+ (void)ocjWallet_exchangeGiftTicketsWithGift_no:(NSString *)gift_no gift_password:(NSString *)gift_password completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:gift_no forKey:@"gift_no"];
    [mDic setValue:gift_password forKey:@"gift_password"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_ExchangeGiftTickets parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel* responseModel) {
        
        handler(responseModel);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_rechargeWalletWithCardNO:(NSString *)card_no passwd:(NSString *)passwd completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:card_no forKey:@"card_no"];
    [mDic setValue:passwd forKey:@"passwd"];
//    [mDic setValue:@"500" forKey:@"txnAmt"];
//    [mDic setValue:@"100" forKey:@"amtStr"];
  
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_RechargeWallet parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_checkBalanceWithCardNO:(NSString *)card_no passwd:(NSString *)passwd completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:card_no forKey:@"card_no"];
    [mDic setValue:passwd forKey:@"passwd"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_CheckBalance parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJWalletModel_checkBalance *model = [[OCJWalletModel_checkBalance alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_checkCouponDetailWithStatusType:(NSString *)statusType page:(NSInteger)page completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:statusType forKey:@"statusType"];
    [mDic setValue:@(page) forKey:@"page"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_CheckCouponDetail parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJWalletModel_CouponList *model = [[OCJWalletModel_CouponList alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_checkCouponNumCompletionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_CheckCouponNum parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJWalletModel_CouponNum *model = [[OCJWalletModel_CouponNum alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        
        handler(model);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_exchangeCouponWithCouponNo:(NSString *)coupon_no completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:coupon_no forKey:@"coupon_no"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_ExchangeCoupon parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_checkTaoCouponDetailWithPage:(NSInteger)page completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:@(page) forKey:@"page"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_TaoCouponDetail parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJWalletModel_TaoCouponList *model = [[OCJWalletModel_TaoCouponList alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
        
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_exchangeTaoCouponWithCouponNO:(NSString *)coupon_no completionhandler:(OCJHttpResponseHander)handler{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:coupon_no forKey:@"coupon_no"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_ExchangeTaoCoupon parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
             [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_europeDetailWithType:(NSString*)type page:(NSInteger)page completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:@(page) forKey:@"curr_page_no"];
    [mDic setValue:type forKey:@"month"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_EuropeDetail parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJWalletModel_EuropseDetail * model = [[OCJWalletModel_EuropseDetail alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_checkEuropeNumCompletionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_EuropeCheckBalance parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+ (void)ocjWallet_getTaoCouponWithCouponNo:(NSString *)coupon_no completionHandler:(OCJHttpResponseHander)handler {
  NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
  [mDic setValue:coupon_no forKey:@"coupon_no"];
  
  [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_GetTaoCoupon parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
    
    handler(responseModel);
    if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
      [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
    }
  }];
}

@end


