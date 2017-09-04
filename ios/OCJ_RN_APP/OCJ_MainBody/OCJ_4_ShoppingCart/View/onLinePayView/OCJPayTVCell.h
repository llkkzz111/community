//
//  OCJPayTVCell.h
//  OCJ
//
//  Created by OCJ on 2017/5/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 自定义Cell
 */
@interface OCJPayTVCell : UITableViewCell

@property (nonatomic,strong)UILabel  * ocjLab_page;      ///< 页数下标
@property (nonatomic,strong)UILabel  * ocjLab_order;     ///< 商品订单

@end

typedef void (^OCJUseAllScoreBlock)();

@interface OCJPayTVCell_TF : UITableViewCell

@property (nonatomic,strong) UILabel     * ocjLab_tip;
@property (nonatomic,strong) UITextField * ocjTF_input;
@property (nonatomic,strong) UILabel * ocjLab_fact;
@property (nonatomic, strong) UIView * ocjView_line;///<底部横线

@property (nonatomic, strong) NSString *ocjStr_canScore;///<是否可选一键积分

@property (nonatomic, strong) UIButton *ocjBtn_select;///<一键积分/预付款/礼包按钮
@property (nonatomic, copy) OCJUseAllScoreBlock ocjUseAllScoreBlock;


/**
 重置cell状态
 */
-(void)ocj_resetStatus;

@end

@interface OCJPayTVCell_Text : UITableViewCell

@property (nonatomic,strong)   NSString * ocjStr_shopMoney;  ///< 商品价格
@property (nonatomic,strong)   UILabel  * ocjLab_tip;
- (void)ocj_setshopMoney:(NSString *)money;

@end

@interface OCJPayTVCell_TextSecond : UITableViewCell

@property (nonatomic,strong) UILabel  * ocjLab_tip;
@property (nonatomic,copy)   NSString * ocjStr_shopMoney;  ///< 抵扣金额
@property (nonatomic,strong) UILabel * ocjLab_fact;

- (void)ocj_setShopMoney:(NSString *)money;

@end

@interface OCJPayTVCell_fact : UITableViewCell
@property (nonatomic,strong) UILabel * ocjLab_fact;
@property (nonatomic,copy)   NSString * ocjStr_shopMoney;  ///< 商品价格
- (void)ocj_setShopMoney:(NSString *)money;

@end


@interface OCJPayTVCell_orderList : UITableViewCell

- (void)ocj_setImgWithArray:(NSArray *)imgArr;
@end

@interface OCJPayTVCell_onlineReduce : UITableViewCell

@property (nonatomic, strong) UILabel *ocjLab_reduce; ///<立减

@end
