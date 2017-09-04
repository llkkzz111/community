//
//  OCJResModel_addressControl.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseResponceModel.h"

@interface OCJResModel_addressControl : OCJBaseResponceModel

@end

/**
 收货地址列表model
 */
@interface OCJAddressModel_detailList : OCJBaseResponceModel

@property (nonatomic, copy) NSMutableArray *ocjArr_receivers;   ///<收货人信息数组
@property (nonatomic, copy) NSString *ocjStr_cust_no;           ///<顾客编号

@end

/**
 单条收货地址详细信息model
 */
@interface OCJAddressModel_listDesc : NSObject

@property (nonatomic, copy) NSString *ocjStr_cust_no;           ///<顾客编号
@property (nonatomic, copy) NSString *ocjStr_receiverName;      ///<收货人
@property (nonatomic, copy) NSString *ocjStr_mobile1;           ///<手机号第一段
@property (nonatomic, copy) NSString *ocjStr_mobile2;           ///<手机号第二段
@property (nonatomic, copy) NSString *ocjStr_mobile3;           ///<手机号第三段
@property (nonatomic, copy) NSString *ocjStr_isDefault;         ///<是否是默认地址
@property (nonatomic, copy) NSString *ocjStr_addrProCity;       ///<收货地址省市信息
@property (nonatomic, copy) NSString *ocjStr_addrDetail;        ///<收货地址详细信息
@property (nonatomic, copy) NSString *ocjStr_addressID;         ///<地址id
@property (nonatomic, copy) NSString *ocjStr_addressIDRN;       ///<地址id2（给RN用）
@property (nonatomic, copy) NSString *ocjStr_provinceCode;      ///<省对应code
@property (nonatomic, copy) NSString *ocjStr_cityCode;          ///<市对应code
@property (nonatomic, copy) NSString *ocjStr_districtCode;      ///<区对应code

@end
