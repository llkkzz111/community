//
//  OCJModifyNickNameVC.h
//  OCJ
//
//  Created by Ray on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

typedef void (^OCJModifyNickNameBlock)(NSString *ocjStr_nickName);

/**
 修改昵称
 */
@interface OCJModifyNickNameVC : OCJBaseVC

@property (nonatomic, copy) OCJModifyNickNameBlock ocjModifyNickNameBlock;

@end
