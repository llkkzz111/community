//
//  OCJSignInTipVC.h
//  OCJ
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"


typedef NS_ENUM(NSUInteger, OCJSignInTipVCType){
    OCJSignInTipVCTypeNormal = 0, ///<普通天数签到 除 15 20 都会被判断为普通签到.
    OCJSignInTipVCTypeLottery = 15, ///<签到彩票奖励.
    OCJSignInTipVCTypeMember = 20///<签到会员奖励.
};


/**
 首页签到图标
 */
@interface OCJSignInTipVC : OCJBaseVC

@property (nonatomic, assign) OCJSignInTipVCType signVCType;//把天数直接传给signVCType进来即可

@property (nonatomic, copy) void(^agreeReceive)(OCJSignInTipVCType receiveType);

@property (nonatomic, copy) void(^status)(BOOL successOrFail);


@end
