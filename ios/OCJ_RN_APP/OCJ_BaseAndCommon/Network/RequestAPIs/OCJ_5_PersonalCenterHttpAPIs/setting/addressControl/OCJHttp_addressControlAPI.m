//
//  OCJHttp_addressControlAPI.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJHttp_addressControlAPI.h"
#import "OCJResModel_addressControl.h"

NSString *const OCJURLPath_CheckAddrList = @"/api/members/members/check_address";   ///<会员地址列表查询接口
NSString *const OCJURLPath_AddNewAddress = @"/api/members/members/new_address";     ///<增加地址接口
NSString *const OCJURLPath_SetDefaultAddr = @"/api/members/members/default_address";///<设置默认地址接口
NSString *const OCJURLPath_ChangeAddress = @"/api/members/members/change_address";  ///<修改收货地址接口
NSString *const OCJURLPath_DeleteAddress = @"/api/members/members/delete_address";  ///<删除收货地址接口

NSString* const OCJURLPath_ChangeDefaultAdress = @"/api/members/members/change_new_address"; ///< 修改默认分站信息

@implementation OCJHttp_addressControlAPI

+ (void)ocjAddress_checkMemberAddressListCompletionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_CheckAddrList parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJAddressModel_detailList *model = [[OCJAddressModel_detailList alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
        
    }];
}

+ (void)ocjAddress_addNewAddressWithCustNO:(NSString *)cust_no isDefaultAddr:(NSString *)is_default_addr receiver:(NSString *)receiver phone:(NSString *)phone mobile:(NSString *)mobile province:(NSString *)province city:(NSString *)city strict:(NSString *)strict streetAddr:(NSString *)street_address completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:cust_no forKey:@"cust_no"];
    [mDic setValue:is_default_addr forKey:@"is_default_addr"];
    [mDic setValue:receiver forKey:@"receiver"];
    [mDic setValue:phone forKey:@"phone"];
    [mDic setValue:mobile forKey:@"mobile"];
    [mDic setValue:province forKey:@"province"];
    [mDic setValue:city forKey:@"city"];
    [mDic setValue:strict forKey:@"strict"];
    [mDic setValue:street_address forKey:@"street_address"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_AddNewAddress parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
        
    }];
    
}

+ (void)ocjAddress_setDefaultAddressWithAddressID:(NSString *)address_id completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:address_id forKey:@"address_id"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_SetDefaultAddr parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
        
    }];
}

+ (void)ocjAddress_changeAddressWithAddressID:(NSString *)address_id receiver:(NSString *)receiver phone:(NSString *)phone mobile:(NSString *)mobile province:(NSString *)province city:(NSString *)city strict:(NSString *)strict streetAddr:(NSString *)street_address isDefaultAddr:(NSString *)is_default_addr completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:address_id forKey:@"address_id"];
    [mDic setValue:receiver forKey:@"receiver"];
    [mDic setValue:phone forKey:@"phone"];
    [mDic setValue:mobile forKey:@"mobile"];
    [mDic setValue:province forKey:@"province"];
    [mDic setValue:city forKey:@"city"];
    [mDic setValue:strict forKey:@"strict"];
    [mDic setValue:street_address forKey:@"street_address"];
    [mDic setValue:is_default_addr forKey:@"is_default_addr"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_ChangeAddress parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
    
}

+ (void)ocjAddress_deleteAddressWithAddressID:(NSString *)address_id completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:address_id forKey:@"address_id"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_DeleteAddress parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)ocjAuth_changeDefaultAdressInfoWithProvinceCode:(NSString *)provinceCode
                                               cityCode:(NSString *)cityCode
                                               areaCode:(NSString *)areacode
                                             addrDetail:(NSString *)addr
                                                placeGb:(NSString *)placeGb
                                      completionHandler:(OCJHttpResponseHander)handler{
  
  NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
  [mDic setValue:provinceCode  forKey:@"province"];
  [mDic setValue:cityCode forKey:@"city"];
  [mDic setValue:areacode forKey:@"area"];
  [mDic setValue:addr forKey:@"addr"];
  [mDic setValue:placeGb forKey:@"placeGb"];
  
  [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_ChangeDefaultAdress parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
    
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      
      handler(responseModel);
      
    }
    
  }];
  
}

@end
