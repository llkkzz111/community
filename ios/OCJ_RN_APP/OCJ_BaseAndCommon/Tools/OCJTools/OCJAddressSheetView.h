//
//  OCJAddressSheetView.h
//  testTwo
//
//  Created by yangyang on 2017/4/20.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OCJAddressSheetHandler) (NSDictionary* dic_address);///< 地址数据回调block

@interface OCJAddressSheetView : UIView

/**
 召唤地址选择器
 
 @param handler 选择地址字典
 *回调数据格式示例：
 ｛@"provenice":@"上海市",@"city":@"上海市",@"district":@"徐汇区",@"proveniceCode":@"15",@"cityCode":@"001",@"districtCode":@"001"｝
 */
+(void)ocj_popAddressSheetCompletion:(OCJAddressSheetHandler)handler;

@end
