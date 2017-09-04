//
//  OCJLotteryModel.h
//  OCJ
//
//  Created by 董克楠 on 14/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseResponceModel.h"

@interface OCJLotteryModel : OCJBaseResponceModel

@end

/*
    彩票
 */
@interface OCJLotteryListModel : OCJBaseResponceModel

@property (nonatomic, copy) NSMutableArray *ocjArr_lotteryList;

@end

@interface OCJLotteryInfoModel : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_drawYN;            ///开奖情况
@property (nonatomic, copy) NSString *ocjStr_ball;         //彩票号码
@property (nonatomic, copy) NSString *ocjStr_drawNo;       //日期

@end

/*
    礼包
 */
@interface OCJGiftListModel : OCJBaseResponceModel

@property (nonatomic, copy) NSMutableArray *ocjArr_GiftList;

@end

@interface OCJGiftInfoModel : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_insert_date;       //
@property (nonatomic, copy) NSString *ocjStr_coupon_no;         //
@property (nonatomic, copy) NSString *ocjStr_coupon_note;       //礼卷名
@property (nonatomic, copy) NSString *ocjStr_user_YN;       //是否使用

@end

