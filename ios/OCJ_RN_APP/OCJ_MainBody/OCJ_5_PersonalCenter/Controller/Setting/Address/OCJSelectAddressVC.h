//
//  OCJSelectAddressVC.h
//  OCJ
//
//  Created by Ray on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"
#import "OCJHttp_addressControlAPI.h"
#import "OCJResModel_addressControl.h"

typedef void (^OCJSelectAddressBlock)(OCJAddressModel_listDesc *listModel);

/**
 选择收货信息
 */
@interface OCJSelectAddressVC : OCJBaseVC

/**
 回调block
 */
@property (nonatomic, copy) OCJSelectAddressBlock ocjSelectedAddrBlock;

@end
