//
//  OCJManageAddressVC.h
//  OCJ
//
//  Created by Ray on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"
#import "OCJResModel_addressControl.h"

typedef void (^OCJDefaultAddressBlock)(OCJAddressModel_listDesc *ocjModel_default);

/**
 管理收货信息
 */
@interface OCJManageAddressVC : OCJBaseVC

@property (nonatomic, copy) OCJDefaultAddressBlock ocjDefaultAddressBlock;///<返回默认地址

@end
