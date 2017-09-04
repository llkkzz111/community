//
//  OCJHttp_signInAPI.m
//  OCJ
//
//  Created by wb_yangyang on 2017/6/11.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJHttp_signInAPI.h"

NSString *const OCJURLPath_GetRegister = @"api/members/opoints/check_in";    ///<签到接口

NSString *const OCJURLPath_GetRegisterDetail = @"/api/members/opoints/sign/mcontent";    ///<签到详情

NSString *const OCJURLPath_GetLottery = @"/api/members/opoints/cust/fct/search";    ///<彩票信息
NSString *const OCJURLPath_GetGiftDetails= @"/api/members/opoints/sign/details";    ///<礼包信息

NSString *const OCJURLPath_Get20Gift = @"/api/members/opoints/full/sign";    ///<领取20天的礼物

NSString *const OCJURLPath_Get15Gift = @"/api/members/opoints/cust/fct/get";    ///<领取15天的礼物

@implementation OCJHttp_signInAPI

+ (void)OCJRegister_getSigningRecordcheck_inCompletionHandler:(OCJHttpResponseHander)handler {
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GetRegister parameters:nil andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
//            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }else{
//            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+(void)OCJRegister_getRegisterDetailsSign_fctLoadingType:(OCJHttpLoadingType)loadType completionHandler:(OCJHttpResponseHander)handler{
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GetRegisterDetail parameters:nil andLodingType:loadType completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            OCJRegisterInfoModel *model = [[OCJRegisterInfoModel alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
            handler(model);
            
        }else if(loadType != OCJHttpLoadingTypeNone){
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

+(void)sign20Gift_inSignInSize:(id)signInSize CompletionHandler:(OCJHttpResponseHander)handler{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setValue:@"sign2" forKey:@"sign_inSize"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_Get20Gift parameters:dictM andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+(void)sign15Gift_inSignFct:(id)sign_fct
                               userName:(NSString *)name
                                 mobile:(NSString *)mobile
                                 cardId:(NSString *)cardId
                      CompletionHandler:(OCJHttpResponseHander)handler{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    [dictM setValue:@"fct" forKey:@"sign_fct"];
    [dictM setValue:name forKey:@"userName"];
    [dictM setValue:mobile forKey:@"mobile"];
    [dictM setValue:cardId forKey:@"cardId"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_Get15Gift parameters:[dictM copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+(void)OCJRegister_getWelfareLotteryInfoCompletionHandler:(OCJHttpResponseHander)handler
{
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GetLottery parameters:nil andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            OCJLotteryListModel * model = [[OCJLotteryListModel alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
            handler(model);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }

    }];
}

+(void)OCJRegister_getWelfareGiftCompletionHandler:(OCJHttpResponseHander)handler
{
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GetGiftDetails parameters:nil andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            OCJGiftListModel * model = [[OCJGiftListModel alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
            handler(model);
            
        }else{
            
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
        
    }];
}

@end
