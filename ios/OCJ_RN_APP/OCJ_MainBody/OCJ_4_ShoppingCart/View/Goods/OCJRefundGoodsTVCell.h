//
//  OCJRefundGoodsTVCell.h
//  OCJ
//
//  Created by OCJ on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJPlaceholderTextView.h"
#import "OCJUploadImageView.h"

typedef void(^OCJExpandHandler) (NSDictionary * ocjStr_fundReson);///< 列表的折叠
typedef void(^RefundGoodsUseHandler) (NSString * ocjStr_fundReson);///< 退货后是否使用
typedef void(^OCJRefundGoodsGoodHandler) (NSString * ocjStr_fundReson);///< 商品是否完好
typedef void(^OCJRefundGoodsLessHandler) (NSString * ocjStr_fundReson);///< 缺少主赠品
typedef void(^OCJRefundGoodsDamageHandler)(NSString * ocjStr_fundReson);///< 外包装损坏
typedef void(^OCJRefundGoodsPreTVCellHandler)(NSString * ocjStr_fundReson);///< 转预方式
typedef void(^OCJRefundGoodsOriginalHandler)(NSString * ocjStr_fundReson);///< 原付款方式退回

/**
 申请退货界面 退货原因折叠控件
 */
@interface OCJRefundGoodsTVCell : UITableViewCell
@property (nonatomic, strong) NSArray *ocjArr_dataSource;///<退货原因数组
@property (nonatomic,strong) OCJBaseTableView * ocj_tableView;//tableview
@property (nonatomic,copy) OCJExpandHandler handler;

@end

/**
 退货原因描述界面Cell
 */
@interface OCJRefundGoodsDescTVCell : UITableViewCell
@property (nonatomic,copy) NSString * ocjStr_reson;
@property (nonatomic,strong) OCJPlaceholderTextView * ocjTV_tip;


@end

/**
 收货后是否使用
 */
@interface OCJRefundGoodsUseTVCell : UITableViewCell
@property (nonatomic,copy) RefundGoodsUseHandler handler;
@end


/**
 商品是否完好
 */
@interface OCJRefundGoodsGoodTVCell : UITableViewCell
@property (nonatomic,copy) OCJRefundGoodsGoodHandler handler;
@end



/**
 是否缺少赠品
 */
@interface OCJRefundGoodsLessTVCell : UITableViewCell
@property (nonatomic,copy)OCJRefundGoodsLessHandler handler;
@end


/**
外包装损坏
 */
@interface OCJRefundGoodsDamageTVCell : UITableViewCell
@property (nonatomic,copy)OCJRefundGoodsDamageHandler handler;
@end

/**
 退款方式
 */
@interface OCJRefundGoodsMethodTVCell : UITableViewCell

@end




/**
 转预付款
 */
@interface OCJRefundGoodsPreTVCell : UITableViewCell
@property (nonatomic,copy)OCJRefundGoodsPreTVCellHandler handler;
@end


/**
 原支付方式退回
 */
@interface OCJRefundGoodsOriginalTVCell : UITableViewCell
@property (nonatomic,assign)BOOL ocjBool_sel;
@property (nonatomic,strong) UIButton * ocjBtn_unUse;
@property (nonatomic,copy) OCJRefundGoodsOriginalHandler handler;
@end


/**
 底部上传控件提示信息
 */
@interface OCJRefundUpLoadImgTipTVCell : UITableViewCell

@end
/**
 底部控件
 */
@interface OCJRefundGoodsBottomTVCell : UITableViewCell
@property (nonatomic,strong) OCJUploadImageView * ocjView_bottom; ///< 上传控件

@end







@interface OCJRefundResonTVCell : UITableViewCell
@property (nonatomic,strong) UILabel * ocjLab_tip;
@property (nonatomic,assign) BOOL     ocjBool_isSelected;
@end


