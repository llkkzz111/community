//
//  OCJResponseModel_confirmOrder.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJBaseResponceModel.h"
#import "OCJResModel_addressControl.h"

@interface OCJResponseModel_confirmOrder : OCJBaseResponceModel

@end

/**
 预约订单model
 */
@interface OCJResponceModel_confirmOrder : OCJBaseResponceModel

@property (nonatomic, strong) OCJAddressModel_listDesc *ocjModel_receiver;      ///<收货人信息
@property (nonatomic, copy) NSString *ocjStr_deposit;           ///<预付款信息
@property (nonatomic, copy) NSString *ocjStr_score;             ///<积分信息
@property (nonatomic, copy) NSString *ocjStr_record;            ///<礼包信息
@property (nonatomic, copy) NSString *ocjStr_totalPrice;        ///<商品总金额
@property (nonatomic, copy) NSString *ocjStr_couponPrice;       ///<抵用券金额
@property (nonatomic, copy) NSMutableArray *ocjArr_orders;      ///<订单信息

@end

@interface OCJResponceModel_orders : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_canUseCoupon;      ///<是否可用抵用券
@property (nonatomic, copy) NSMutableArray *ocjArr_carts;       ///<商品信息
@property (nonatomic, copy) NSMutableArray *ocjArr_coupon;      ///<可用抵用券列表


@end

@class OCJResponceModel_GoodsDetail;
@interface OCJResponceModel_orderDetail : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_custID;                               ///<用户id
@property (nonatomic, strong) OCJResponceModel_GoodsDetail *ocjModel_goods;        ///<商品信息
@property (nonatomic, copy) NSString *ocjStr_memberPromo;                          ///<是否familyDay商品
@property (nonatomic, copy) NSMutableArray *ocjArr_gift;                           ///<赠品信息

@end

/**
 预约商品信息model
 */
@interface OCJResponceModel_GoodsDetail : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_itemCode;           ///<商品编号
@property (nonatomic, copy) NSString *ocjStr_unitCode;           ///<商品规格号
@property (nonatomic, copy) NSString *ocjStr_msaleCode;          ///<渠道
@property (nonatomic, copy) NSString *ocjStr_count;              ///<数量
@property (nonatomic, copy) NSString *ocjStr_name;               ///<商品名称
@property (nonatomic, copy) NSString *ocjStr_imageUrl;           ///<图片url
@property (nonatomic, copy) NSString *ocjStr_sellPrice;          ///<商品原价
@property (nonatomic, copy) NSString *ocjStr_lastSellPrice;      ///<最终售价
@property (nonatomic, copy) NSString *ocjStr_reduce;             ///<优惠价
@property (nonatomic, copy) NSString *ocjStr_isRecommend;        ///<是否是推荐
@property (nonatomic, copy) NSArray *ocjArr_sxGifts;             ///<随箱赠品

@end

/**
 预约订单抵用券信息
 */
@interface OCJResponceModel_coupon : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_couponNo;            ///<抵用券编号
@property (nonatomic, copy) NSString *ocjStr_couponName;          ///<抵用券名称
@property (nonatomic, copy) NSString *ocjStr_couponAmt;           ///<抵用券金额
@property (nonatomic, copy) NSString *ocjStr_couponGB;            ///<10：按金额优惠 20：按比例优惠
@property (nonatomic, copy) NSString *ocjStr_couponSeq;           ///<抵用券序号
@property (nonatomic, copy) NSString *ocjStr_endDate;             ///<结束日期

@end

/**
 预约订单赠品model
 */
@interface OCJResponceModel_gift : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_giftSeq;             ///<赠品序列号
@property (nonatomic, copy) NSString *ocjStr_giftItemcode;        ///<赠品编号
@property (nonatomic, copy) NSString *ocjStr_giftUnitcode;        ///<赠品规格号
@property (nonatomic, copy) NSString *ocjStr_giftPromoNo;         ///<促销编号
@property (nonatomic, copy) NSString *ocjStr_giftPromoSeq;        ///<促销序列号
@property (nonatomic, copy) NSString *ocjStr_giftItemName;        ///<赠品名称
@property (nonatomic, copy) NSString *ocjStr_imageUrl;            ///<图片地址

@end
