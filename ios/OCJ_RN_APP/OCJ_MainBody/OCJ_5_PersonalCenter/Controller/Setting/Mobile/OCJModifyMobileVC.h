//
//  OCJModifyMobileVC.h
//  OCJ
//
//  Created by Ray on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

typedef void (^OCJModifyMobileBlock)(NSString *ocjStr_mobile);

/**
 修改手机号
 */
@interface OCJModifyMobileVC : OCJBaseVC

@property (nonatomic, copy) OCJModifyMobileBlock ocjModifyMobileBlock;

@end
