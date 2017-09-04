//
//  OCJRegisterDetailsModel.h
//  OCJ
//
//  Created by 董克楠 on 12/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseResponceModel.h"

@interface OCJRegisterDetailsModel : OCJBaseResponceModel

@end

@interface OCJRegisterInfoModel : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_fctYn;         //表示没有领取彩票 --fctY表示已经领取彩票
@property (nonatomic, copy) NSString *ocjStr_monthDay;      //签到天数
@property (nonatomic, copy) NSString *ocjStr_liBaoYn;       //liBaoN 表示未领取礼包 --liBaoY表示已经领取礼包
@property (nonatomic, copy) NSString *ocjStr_fctG;          //当月是否领取彩票  --fctN表示未领取，fctY表示已领取
@property (nonatomic, copy) NSString *ocjStr_signYn;   //今天是否签到
@property (nonatomic, copy) NSString *ocjStr_isApp;   //是否是APP
@property (nonatomic, copy) NSString *ocjStr_opoint_money;   //鸥点
@end
