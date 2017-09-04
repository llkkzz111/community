//
//  OCJTestDataSource.m
//  OCJ
//
//  Created by Ray on 2017/5/22.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJTestDataSource.h"

@implementation OCJTestDataSource

+ (OCJBaseResponceModel *)ocj_getRewardBalanceDataSource {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjDic_data = @{@"num":@200};
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getPreMoneyDataSource {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjDic_data = @{@"num":@200};
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getScoreListBalanceDataSource {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjDic_data = @{@"num":@2000};
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getExchangeTaoCouponDataSource {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjStr_message = @"领取成功";
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getExchangeGiftTicketsDataSource {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjStr_message = @"兑换成功";
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getRechargeWalletDataSource {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjStr_message = @"充值成功";
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getCheckBalanceDataSource {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjStr_message = @"查询成功";
    responseModel.ocjDic_data = @{@"num":@500000};
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getExchangeCouponDataSource {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjStr_message = @"兑换成功";
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getTaoCouponDetailVCDataSourceWithPage:(NSInteger)page {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjStr_message = @"获取淘券列表成功";
    if (page == 1) {
        responseModel.ocjDic_data = @{@"result":@{@"taolist":@[@{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"电视剧哈市茪啥接电话",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满199减100 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@500,
                                                                 @"DCAMT":@100,
                                                                 @"COUPONNO":@"2017081500000358",
                                                                 @"TOTALSIZE": @9,
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"打击哦啊是的骄傲的架势",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满100减30 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@200,
                                                                 @"DCAMT":@30,
                                                                 @"COUPONNO":@"2017081500000358",
                                                                 @"TOTALSIZE": @9,
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"大家发哦是的骄傲i的骄傲",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满50减10 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@100,
                                                                 @"TOTALSIZE": @9,
                                                                 @"DCAMT":@10,
                                                                 @"COUPONNO":@"201708154324311",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"爱神的箭奥is大姐嗷is点击",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满1000减299 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@1000,
                                                                 @"DCAMT":@299,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"20170815123123",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"点击爱神的箭拉上来看",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满2000减199 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@2000,
                                                                 @"DCAMT":@199,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"2017081500000358",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"给你您发的是的覅偶积分",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满1000减99 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@1000,
                                                                 @"DCAMT":@99,
                                                                 @"COUPONNO":@"2017081500000358",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"的骄傲了圣诞节哦爱睡觉",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满199减100 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@100,
                                                                 @"DCAMT":@100,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"2017081500000358",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"女来看待佛ID反倒是卡佛",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满199减100 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@100,
                                                                 @"DCAMT":@50,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"201708154324234",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"大数据大皮带扣扣婆婆",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满199减200 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@1000,
                                                                 @"DCAMT":@200,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"2017081521312312",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"东方购物东方购物",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满399减200 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@1000,
                                                                 @"DCAMT":@200,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"2017081521312312",
                                                                 @"DCBDATE":@"2017-05-21"}],
                                                  @"cust_no":@"201112005589",
                                                  @"type":@"no",
                                                  @"maxPage":@1}};
    }else if (page == 2) {
        responseModel.ocjDic_data = @{@"result":@{@"taolist":@[@{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"电视剧哈市茪啥接电话",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满199减100 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@500,
                                                                 @"DCAMT":@100,
                                                                 @"COUPONNO":@"2017081500000358",
                                                                 @"TOTALSIZE": @9,
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"打击哦啊是的骄傲的架势",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满100减30 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@200,
                                                                 @"DCAMT":@30,
                                                                 @"COUPONNO":@"2017081500000358",
                                                                 @"TOTALSIZE": @9,
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"大家发哦是的骄傲i的骄傲",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满50减10 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@100,
                                                                 @"TOTALSIZE": @9,
                                                                 @"DCAMT":@10,
                                                                 @"COUPONNO":@"201708154324311",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"爱神的箭奥is大姐嗷is点击",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满1000减299 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@1000,
                                                                 @"DCAMT":@299,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"20170815123123",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"点击爱神的箭拉上来看",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满2000减199 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@2000,
                                                                 @"DCAMT":@199,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"2017081500000358",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"给你您发的是的覅偶积分",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满1000减99 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@1000,
                                                                 @"DCAMT":@99,
                                                                 @"COUPONNO":@"2017081500000358",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"的骄傲了圣诞节哦爱睡觉",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满199减100 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@100,
                                                                 @"DCAMT":@100,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"2017081500000358",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"女来看待佛ID反倒是卡佛",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满199减100 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@100,
                                                                 @"DCAMT":@50,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"201708154324234",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"大数据大皮带扣扣婆婆",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满199减200 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@1000,
                                                                 @"DCAMT":@200,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"2017081521312312",
                                                                 @"DCBDATE":@"2017-05-21"},
                                                               @{@"DCEDATE":@"2017-11-25",
                                                                 @"DCCOUPONNAME":@"东方购物东方购物",
                                                                 @"DCCOUPONCONTENT":@"店铺购物金额满399减200 团购商品除外",
                                                                 @"MIN_ORDER_AMT":@1000,
                                                                 @"DCAMT":@200,
                                                                 @"TOTALSIZE": @9,
                                                                 @"COUPONNO":@"2017081521312312",
                                                                 @"DCBDATE":@"2017-05-21"}],
                                                  @"cust_no":@"201112005589",
                                                  @"type":@"no",
                                                  @"maxPage":@1}};
    }else {
        
    }
    
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getScoreDetailVCDataSource {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjDic_data = @{@"amtList":@[@{@"saveAmtType":@"2017-11-25",      ///< 积分过期时间
                                                             @"sub":@"false",                   ///< 正负标志
                                                             @"saveAmtType":@"订购获得",         ///< 积分类型
                                                             @"saveAmtGetDate":@"2017-11-25",   ///< 积分获取时间
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",///< 事件
                                                             @"TOTALCNT":@"244",               ///< 总记录条数
                                                             @"saveAmt":@"1.1"},               ///< 获取使用积分
                                                           @{@"saveAmtType":@"2017-11-25",
                                                             @"sub":@"false",
                                                             @"saveAmtType":@"订购获得",
                                                             @"saveAmtGetDate":@"2017-11-25",
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                             @"TOTALCNT":@"244",
                                                             @"saveAmt":@"1.1"},
                                                           @{@"saveAmtType":@"2017-11-25",
                                                             @"sub":@"false",
                                                             @"saveAmtType":@"订购获得",
                                                             @"saveAmtGetDate":@"2017-11-25",
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                             @"TOTALCNT":@"244",
                                                             @"saveAmt":@"1.1"},
                                                           @{@"saveAmtType":@"2017-11-25",      ///< 积分过期时间
                                                             @"sub":@"false",                   ///< 正负标志
                                                             @"saveAmtType":@"订购获得",         ///< 积分类型
                                                             @"saveAmtGetDate":@"2017-11-25",   ///< 积分获取时间
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",///< 事件
                                                             @"TOTALCNT":@"244",               ///< 总记录条数
                                                             @"saveAmt":@"1.1"},               ///< 获取使用积分
                                                           @{@"saveAmtType":@"2017-11-25",
                                                             @"sub":@"false",
                                                             @"saveAmtType":@"订购获得",
                                                             @"saveAmtGetDate":@"2017-11-25",
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                             @"TOTALCNT":@"244",
                                                             @"saveAmt":@"1.1"},
                                                           @{@"saveAmtType":@"2017-11-25",
                                                             @"sub":@"false",
                                                             @"saveAmtType":@"订购获得",
                                                             @"saveAmtGetDate":@"2017-11-25",
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                             @"TOTALCNT":@"244",
                                                             @"saveAmt":@"1.1"},
                                                           @{@"saveAmtType":@"2017-11-25",      ///< 积分过期时间
                                                             @"sub":@"false",                   ///< 正负标志
                                                             @"saveAmtType":@"订购获得",         ///< 积分类型
                                                             @"saveAmtGetDate":@"2017-11-25",   ///< 积分获取时间
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",///< 事件
                                                             @"TOTALCNT":@"244",               ///< 总记录条数
                                                             @"saveAmt":@"1.1"},               ///< 获取使用积分
                                                           @{@"saveAmtType":@"2017-11-25",
                                                             @"sub":@"false",
                                                             @"saveAmtType":@"订购获得",
                                                             @"saveAmtGetDate":@"2017-11-25",
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                             @"TOTALCNT":@"244",
                                                             @"saveAmt":@"1.1"},
                                                           @{@"saveAmtType":@"2017-11-25",
                                                             @"sub":@"false",
                                                             @"saveAmtType":@"订购获得",
                                                             @"saveAmtGetDate":@"2017-11-25",
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                             @"TOTALCNT":@"244",
                                                             @"saveAmt":@"1.1"},
                                                           @{@"saveAmtType":@"2017-11-25",      ///< 积分过期时间
                                                             @"sub":@"false",                   ///< 正负标志
                                                             @"saveAmtType":@"订购获得",         ///< 积分类型
                                                             @"saveAmtGetDate":@"2017-11-25",   ///< 积分获取时间
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",///< 事件
                                                             @"TOTALCNT":@"244",               ///< 总记录条数
                                                             @"saveAmt":@"1.1"},               ///< 获取使用积分
                                                           @{@"saveAmtType":@"2017-11-25",
                                                             @"sub":@"false",
                                                             @"saveAmtType":@"订购获得",
                                                             @"saveAmtGetDate":@"2017-11-25",
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                             @"TOTALCNT":@"244",
                                                             @"saveAmt":@"1.1"},
                                                           @{@"saveAmtType":@"2017-11-25",
                                                             @"sub":@"false",
                                                             @"saveAmtType":@"订购获得",
                                                             @"saveAmtGetDate":@"2017-11-25",
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                             @"TOTALCNT":@"244",
                                                             @"saveAmt":@"1.1"},
                                                           @{@"saveAmtType":@"2017-11-25",      ///< 积分过期时间
                                                             @"sub":@"false",                   ///< 正负标志
                                                             @"saveAmtType":@"订购获得",         ///< 积分类型
                                                             @"saveAmtGetDate":@"2017-11-25",   ///< 积分获取时间
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",///< 事件
                                                             @"TOTALCNT":@"244",               ///< 总记录条数
                                                             @"saveAmt":@"1.1"},               ///< 获取使用积分
                                                           @{@"saveAmtType":@"2017-11-25",
                                                             @"sub":@"false",
                                                             @"saveAmtType":@"订购获得",
                                                             @"saveAmtGetDate":@"2017-11-25",
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                             @"TOTALCNT":@"244",
                                                             @"saveAmt":@"1.1"},
                                                           @{@"saveAmtType":@"2017-11-25",
                                                             @"sub":@"false",
                                                             @"saveAmtType":@"订购获得",
                                                             @"saveAmtGetDate":@"2017-11-25",
                                                             @"saveAmtName":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                             @"TOTALCNT":@"244",
                                                             @"saveAmt":@"1.1"},
                                                           ],
                                              @"isLogin":@"true",
                                              @"maxPage":@"25",
                                              @"usable_saveamt":@18};
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getCouponDetailVCDataSourceWithPage:(NSInteger)page {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjStr_message = @"获取抵用券列表成功";
    if (page == 1) {
        responseModel.ocjDic_data = @{@"result":@{@"myTicketList":@[@{@"EXP_DC_EDATE":@"2017-11-25",
                                                                      @"DCCOUPON_NAME":@"电视剧哈市茪啥接电话",
                                                                      @"COUPON_NOTE":@"店铺购物金额满199减100 团购商品除外",
                                                                      @"COUPON_AMT":@100},
                                                                    @{@"EXP_DC_EDATE":@"2027-1-13",
                                                                      @"DCCOUPON_NAME":@"asdjasodjioajsd",
                                                                      @"COUPON_NOTE":@"店铺购物金额满299减150 团购商品除外",
                                                                      @"COUPON_AMT":@150},
                                                                    @{@"EXP_DC_EDATE":@"2017-12-29",
                                                                      @"DCCOUPON_NAME":@"达斯柯达拉克丝达克赛德",
                                                                      @"COUPON_NOTE":@"店铺购物金额满99减50 团购商品除外",
                                                                      @"COUPON_AMT":@50},
                                                                    @{@"EXP_DC_EDATE":@"2017-11-25",
                                                                      @"DCCOUPON_NAME":@"电视剧哈市茪啥接电话",
                                                                      @"COUPON_NOTE":@"店铺购物金额满199减100 团购商品除外",
                                                                      @"COUPON_AMT":@100},
                                                                    @{@"EXP_DC_EDATE":@"2020-11-25",
                                                                      @"DCCOUPON_NAME":@"爱神的箭埃及山东哪记得",
                                                                      @"COUPON_NOTE":@"店铺购物金额满399减200 团购商品除外",
                                                                      @"COUPON_AMT":@200},
                                                                    @{@"EXP_DC_EDATE":@"2019-4-25",
                                                                      @"DCCOUPON_NAME":@"甄选生活专营店店铺券",
                                                                      @"COUPON_NOTE":@"店铺购物金额满199减100 团购商品除外",
                                                                      @"COUPON_AMT":@100},
                                                                    @{@"EXP_DC_EDATE":@"2017-4-25",
                                                                      @"DCCOUPON_NAME":@"电视剧哈市茪啥接电话",
                                                                      @"COUPON_NOTE":@"店铺购物金额满199减100 团购商品除外",
                                                                      @"COUPON_AMT":@100},
                                                                    @{@"EXP_DC_EDATE":@"2017-11-25",
                                                                      @"DCCOUPON_NAME":@"电视剧哈市茪啥接电话",
                                                                      @"COUPON_NOTE":@"店铺购物金额满199减100 团购商品除外",
                                                                      @"COUPON_AMT":@12},
                                                                    @{@"EXP_DC_EDATE":@"2017-11-25",
                                                                      @"DCCOUPON_NAME":@"电视剧哈市茪啥接电话",
                                                                      @"COUPON_NOTE":@"店铺购物金额满199减100 团购商品除外",
                                                                      @"COUPON_AMT":@12},
                                                                    @{@"EXP_DC_EDATE":@"2017-11-25",
                                                                      @"DCCOUPON_NAME":@"的哈USD还胡埭苏会滴啊会打死uashdu",
                                                                      @"COUPON_NOTE":@"店铺购物金额满199减100 团购商品除外",
                                                                      @"COUPON_AMT":@99}],
                                                  @"usecnt":@49,
                                                  @"unusecnt":@18}};
    }else if (page == 2) {
        responseModel.ocjDic_data = @{@"result":@{@"myTicketList":@[@{@"EXP_DC_EDATE":@"2018-01-25",
                                                                      @"DCCOUPON_NAME":@"我哈UI是的哈US好读书兑换",
                                                                      @"COUPON_NOTE":@"店铺购物金额满1999减500 团购商品除外",
                                                                      @"COUPON_AMT":@500},
                                                                    @{@"EXP_DC_EDATE":@"2027-1-13",
                                                                      @"DCCOUPON_NAME":@"的教案设计的考拉圣诞节啦看到",
                                                                      @"COUPON_NOTE":@"店铺购物金额满299减150 团购商品除外",
                                                                      @"COUPON_AMT":@150},
                                                                    @{@"EXP_DC_EDATE":@"2017-12-29",
                                                                      @"DCCOUPON_NAME":@"东方购物东方购物",
                                                                      @"COUPON_NOTE":@"店铺购物金额满199减100 团购商品除外",
                                                                      @"COUPON_AMT":@100}],
                                                  @"usecnt":@49,
                                                  @"unusecnt":@18}};
    }else {
        
    }
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getRewardListDataSource {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjDic_data = @{@"myEGiftCardList":@[@{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   
                                                                   @{@"DEPOSIT_GB":@"2",
                                                                     @"STATUS":@"支付结束",
                                                                     @"DEPOSIT_NOTE_APP":@"礼品卡充值",
                                                                     @"DEPOSIT_GB_APP":@"充值",
                                                                     @"REFUND_YN":@"1",
                                                                     @"USE_AMT_APP":@"+500.00",
                                                                     @"DEPOSIT_NOTE":@"500元",
                                                                     @"CNT":@"2017-05-03",
                                                                     @"PROC_DATE":@"1",
                                                                     @"PAGE":@"true",
                                                                     @"DEPOSIT_AMT":@"592",
                                                                     @"TOTAL_CNT":@"92"},
                                                                   ],
                                              @"hasLogin":@"true",
                                              @"maxPage":@"25",
                                              };
    
    return responseModel;
}

+ (OCJBaseResponceModel *)ocj_getPreMoneyListDataSource {
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code = @"200";
    responseModel.ocjDic_data = @{@"myPrepayList":@[@{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                @{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                @{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                
                                                                @{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                @{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                @{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                @{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                
                                                                @{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                @{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                @{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                @{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                
                                                                @{@"order_no":@"20170425180026",
                                                                  @"deposit_note":@"[今日特卖]文曲星(Where) 新品预售_入库自停(a,b,c,d,e)[新春旧机换新机]",
                                                                  @"sub":@"true",
                                                                  @"totalcnt":@"592",
                                                                  @"depositamt_gb":@"订购使用",
                                                                  @"proc_date":@"244",
                                                                  @"depositamt":@"-20"},
                                                                ],
                                              @"hasLogin":@"true",
                                              @"maxPage":@"25",
                                              };
    
    return responseModel;
}
+ (OCJBaseResponceModel *)ocj_getOnLineDataSource{
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code     = @"200";
    responseModel.ocjStr_message  = @"数据请求成功";
    responseModel.ocjDic_data     = @{@"lastPayment":@[@{@"title":@"浦发银行",
                                                      @"id":@"46"},
                                                    @{@"title":@"建设银行",
                                                      @"id":@"8"},
                                                    @{@"title":@"支付宝钱包",
                                                      @"id":@"38"},
                                                    ],
                                  @"order_no":@"20170524195932",
                                  @"c_code":@"0.12",
                                  @"double_deposit":@"2000",
                                  @"double_cardamt":@"2074.01",
                                  @"double_saveamt":@"7838.59",
                                  @"cust_no":@"201112005589",
                                  @"realPayAmt":@"1256",
                                  @"useable_deposit":@"0.12",
                                  @"useable_cardamt":@"2,074.01",
                                  @"useable_saveamt":@"7,838.59",
                                  @"c_code":@"2000",
                                  @"imgUrlList":@[@"http://image1.ocj.com.cn/item_images/item/40/01/57/400157P.jpg"]
                                  };
    
    return responseModel;
}
+ (OCJBaseResponceModel *)ocj_getEurposeDataSource{
    OCJBaseResponceModel *responseModel = [[OCJBaseResponceModel alloc] init];
    responseModel.ocjStr_code     = @"200";
    responseModel.ocjStr_message  = @"数据请求成功";
    responseModel.ocjDic_data     = @{@"opointList":@[@{ @"insert_date":@"2014-11-25",
                                                         @"expire_date":@"2014-11-25",
                                                         @"item_name":@"鸥点数据",
                                                         @"event_name":@"鸥点event_name",
                                                         @"opoint_num":@"100",
                                                        },
                                                      @{ @"insert_date":@"2014-11-25",
                                                         @"expire_date":@"2014-11-25",
                                                         @"item_name":@"鸥点数据",
                                                         @"event_name":@"鸥点event_name",
                                                         @"opoint_num":@"100",
                                                         },
                                                      @{ @"insert_date":@"2014-11-25",
                                                         @"expire_date":@"2014-11-25",
                                                         @"item_name":@"鸥点数据",
                                                         @"event_name":@"鸥点event_name",
                                                         @"opoint_num":@"199",
                                                         },
                                                      @{ @"insert_date":@"2014-11-25",
                                                         @"expire_date":@"2014-11-25",
                                                         @"item_name":@"鸥点数据",
                                                         @"event_name":@"鸥点event_name",
                                                         @"opoint_num":@"200",
                                                         },
                                                      @{ @"insert_date":@"2014-11-25",
                                                         @"expire_date":@"2014-11-25",
                                                         @"item_name":@"鸥点数据",
                                                         @"event_name":@"鸥点event_name",
                                                         @"opoint_num":@"200",
                                                         },

                                                       ],
                                      };
    
    return responseModel;
}


@end
