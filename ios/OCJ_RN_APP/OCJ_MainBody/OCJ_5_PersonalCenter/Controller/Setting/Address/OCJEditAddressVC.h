//
//  OCJEditAddressVC.h
//  OCJ
//
//  Created by OCJ on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"
#import "OCJResModel_addressControl.h"

typedef void(^OCJShopAddressHandler) ();///< 地址数据回调block

typedef NS_ENUM(NSInteger, OCJEditType) {  ///< 收货信息编辑类型
    OCJEditType_add  = 0,    ///< 添加收货信息
    OCJEditType_edit = 1,    ///< 修改收货信息
};

@interface OCJEditAddressVC : OCJBaseVC

/**
 初始修改收货信息
 @param editType 收货信息编辑类型
 @param model    正向传值model
 @param handler  正向传值反向回调block
 **/
- (instancetype)initWithEditType:(OCJEditType)editType OCJManageAddressModel:(OCJAddressModel_listDesc *)model OCJShopAddressHandler:(OCJShopAddressHandler )handler;

@property (nonatomic, strong) NSString *ocjStr_custno;///<会员id

@end
