//
//  OCJHttp_addressControlAPI.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJNetWorkCenter.h"

/**
 地址管理接口类
 */
@interface OCJHttp_addressControlAPI : NSObject

/**
 会员地址列表查询接口

 @param handler 回调block
 */
+ (void)ocjAddress_checkMemberAddressListCompletionHandler:(OCJHttpResponseHander)handler;


/**
 增加地址接口

 @param cust_no 会员id
 @param is_default_addr 是否默认地址
 @param receiver 收货人
 @param phone 电话号码
 @param mobile 手机
 @param province 省
 @param city 市
 @param strict 区
 @param street_address 地址
 @param handler 回调block
 */
+ (void)ocjAddress_addNewAddressWithCustNO:(NSString *)cust_no
                             isDefaultAddr:(NSString *)is_default_addr
                                  receiver:(NSString *)receiver
                                     phone:(NSString *)phone
                                    mobile:(NSString *)mobile
                                  province:(NSString *)province
                                      city:(NSString *)city
                                    strict:(NSString *)strict
                                streetAddr:(NSString *)street_address
                         completionHandler:(OCJHttpResponseHander)handler;

/**
 设置默认地址

 @param address_id 地址id
 @param handler 回调block
 */
+ (void)ocjAddress_setDefaultAddressWithAddressID:(NSString *)address_id
                                completionHandler:(OCJHttpResponseHander)handler;

/**
 修改收货地址

 @param address_id 地址id
 @param receiver 收货人
 @param phone 电话号码
 @param mobile 手机
 @param province 省
 @param city 市
 @param strict 区
 @param street_address 地址
 @param is_default_addr 是否默认地址
 @param handler 回调block
 */
+ (void)ocjAddress_changeAddressWithAddressID:(NSString *)address_id
                                     receiver:(NSString *)receiver
                                        phone:(NSString *)phone
                                       mobile:(NSString *)mobile
                                     province:(NSString *)province
                                         city:(NSString *)city
                                       strict:(NSString *)strict
                                   streetAddr:(NSString *)street_address
                                isDefaultAddr:(NSString *)is_default_addr
                            completionHandler:(OCJHttpResponseHander)handler;

/**
 删除收货地址

 @param address_id 地址id
 @param handler 回调block
 */
+ (void)ocjAddress_deleteAddressWithAddressID:(NSString *)address_id
                            completionHandler:(OCJHttpResponseHander)handler;

/**
 修改默认分站信息
 
 @param regionCode 分站编号
 @param handler
 */
+ (void)ocjAuth_changeDefaultAdressInfoWithProvinceCode:(NSString *)provinceCode
                                               cityCode:(NSString *)cityCode
                                               areaCode:(NSString *)areacode
                                             addrDetail:(NSString *)addr
                                                placeGb:(NSString *)placeGb
                                      completionHandler:(OCJHttpResponseHander)handler;

@end
