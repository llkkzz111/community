//
//  OCJResponceModel_myWallet.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseResponceModel.h"

@interface OCJResponceModel_myWallet : OCJBaseResponceModel

@end

/**
 抵用券详情list
 */
@interface OCJWalletModel_CouponList : OCJBaseResponceModel

@property (nonatomic, copy) NSMutableArray *ocjArr_coupon;     ///<抵用券数组信息
@property (nonatomic, copy) NSString *ocjStr_usecnt;    ///<已使用数量
@property (nonatomic, copy) NSString *ocjStr_unusecnt;  ///<未使用数量

@end


/**
 单张抵用券信息model
 */
@interface OCJWalletModel_CouponListDesc : NSObject

@property (nonatomic, copy) NSString *ocjStr_startDate;  ///<抵用券有效期开始时间
@property (nonatomic, copy) NSString *ocjStr_endDate;  ///<抵用券有效期结束时间
@property (nonatomic, copy) NSString *ocjStr_couponName; ///<抵用券名称
@property (nonatomic, copy) NSString *ocjStr_couponNote;   ///<抵用券说明
@property (nonatomic, copy) NSString *ocjStr_couponAmt;    ///<抵用券金额
@property (nonatomic, copy) NSString *ocjStr_isUsed;        ///<是否使用

@end

/**
 抵用券计数查询model
 */
@interface OCJWalletModel_CouponNum : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_couponNum; ///<抵用券数量

@end

/**
  (礼包兑换)余额查询model
 */
@interface OCJWalletModel_checkBalance : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_num;       ///<礼品卡余额

@end



/**
 积分详情界面 Model
 */
@interface OCJWalletModel_ScoreDetail : OCJBaseResponceModel

@property (nonatomic, copy) NSArray  *ocjArr_amtList;         ///< 积分数组
@property (nonatomic, copy) NSString *ocjStr_isLogin;         ///< 是否登录
@property (nonatomic, copy) NSString *ocjStr_usable_saveamt;  ///< 可用积分额
@property (nonatomic, copy) NSString *ocjStr_maxPage;         ///< 总页数


@end

/**
 礼品卡余额查询model
 */
@interface OCJWalletModel_ScorecheckBalance : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_num;       ///<礼品卡余额

@end

/**
 预付款详情界面 Model
 */
@interface OCJWalletModel_PreDetail : OCJBaseResponceModel

@property (nonatomic, copy) NSArray  *ocjArr_myPrepayList;         ///< 积分数组
@property (nonatomic, copy) NSString *ocjStr_use_pb_deposit;         ///< 是否登录
@property (nonatomic, copy) NSString *ocjStr_hasLogin;  ///<
@property (nonatomic, copy) NSString *ocjStr_maxPage;         ///<


@end

/**
 淘券列表model
 */
@interface OCJWalletModel_TaoCouponList : OCJBaseResponceModel

@property (nonatomic, copy) NSMutableArray *ocjArr_taoList;    ///<淘券列表
@property (nonatomic, copy) NSString *ocjStr_custno;    ///<顾客编号
@property (nonatomic, copy) NSString *ocjStr_type;      ///<类型
@property (nonatomic, copy) NSString *ocjStr_maxPage;   ///<最大页数

@end

@interface OCJWalletModel_TaoCouponListDesc : NSObject

@property (nonatomic, copy) NSString *ocjStr_DCCOUPONCONTENT;       ///<淘券说明
@property (nonatomic, copy) NSString *ocjStr_DCCOUPONNAME;          ///<淘券名称
@property (nonatomic, copy) NSString *ocjStr_DCBDATE;               ///<淘券有效期开始时间
@property (nonatomic, copy) NSString *ocjStr_COUPONNO;              ///<淘券编号
@property (nonatomic, copy) NSString *ocjStr_DCAMT;                 ///<淘券金额
@property (nonatomic, copy) NSString *ocjStr_DCEDATE;               ///<淘券有效期结束时间
@property (nonatomic, copy) NSString *ocjStr_TOTALSIZE;             ///<淘券数量
@property (nonatomic, copy) NSString *ocjStr_MIN_ORDER_AMT;         ///<最小订购金额

@end

@interface OCJWalletModel_PrecheckBalance : OCJBaseResponceModel
@property (nonatomic, copy) NSString *ocjStr_num;       ///<礼品卡余额

@end


/**
 礼包详情界面 Model
 */
@interface OCJWalletModel_RewardDetail : OCJBaseResponceModel

@property (nonatomic, copy) NSArray  *ocjArr_myEGiftCardList;         ///< 积分数组
@property (nonatomic, copy) NSString *ocjStr_hasLogin;                ///< 是否登录
@property (nonatomic, copy) NSString *ocjStr_maxPage;                 ///<

@end

/**
 欧点详情界面 Model
 */
@interface OCJWalletModel_EuropseDetail : OCJBaseResponceModel

@property (nonatomic, copy) NSString * ocjStr_getOpoint;             ///< 
@property (nonatomic, copy) NSArray  * ocjArr_eventNameList;         ///<
@property (nonatomic, copy) NSString * ocjArr_itemNameList;          ///<
@property (nonatomic, copy) NSArray  * ocjArr_opointList;            ///<
@property (nonatomic, copy) NSString * ocjStr_maxPage;               ///<
@property (nonatomic, copy) NSArray  * ocjArr_myOPointList;          ///<
@property (nonatomic, copy) NSString * ocjStr_month_size  ;          ///<

@end

@interface OCJWalletModel_RewardcheckBalance : OCJBaseResponceModel
@property (nonatomic, copy) NSString *ocjStr_num;       ///<礼品卡余额

@end
