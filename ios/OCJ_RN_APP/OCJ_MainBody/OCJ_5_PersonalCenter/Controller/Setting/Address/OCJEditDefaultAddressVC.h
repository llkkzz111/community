//
//  OCJEditDefaultAddressVC.h
//  OCJ_RN_APP
//
//  Created by zhangyongbing on 2017/8/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJBaseVC.h"
#import "OCJResModel_personalInfo.h"

/**
 个人中心默认地址修改
 */
@interface OCJEditDefaultAddressVC : OCJBaseVC

- (instancetype)initWithAddressModel:(OCJPersonalModel_DefaultAdressDesc *)adddesc;

@end
