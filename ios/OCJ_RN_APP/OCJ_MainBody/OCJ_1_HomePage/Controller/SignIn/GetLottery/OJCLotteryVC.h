//
//  OJCLotteryVC.h
//  OCJ
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"


/**
 彩票领取
 */
@interface OJCLotteryVC : OCJBaseVC

@property (nonatomic, copy) void(^status)(BOOL successOrFail);

@end
