//
//  OCJExchangeGoodsTVCell.h
//  OCJ
//
//  Created by OCJ on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJPlaceholderTextView.h"
#import "OCJUploadImageView.h"

typedef void(^OCJExpandHandler) (NSDictionary * ocjStr_fundReson);///< 列表的折叠
typedef void(^OCJExchangeResonHandler) (NSString * ocjStr_reson);         ///< 换货原因
typedef void(^OCJUseHandler) (NSString * ocjStr_use);         ///< 是否使用
typedef void(^OCJLessHandler) (NSString * ocjStr_damage);     ///< 是否缺少主赠品或包装损坏
typedef void (^OCJChooseGoodSpecBlock)();                     ///< 选择更换的行频规格

/**
 换货Cell
 */
@interface OCJExchangeGoodsTVCell : UITableViewCell

@property (nonatomic,copy)  OCJExpandHandler    handler;
@property (nonatomic,strong) NSMutableArray   * ocjArr_dataSource;
@property (nonatomic,strong) OCJBaseTableView * ocj_tableView;


@end

/**
 申请换货界面 换货原因折叠控件
 */
@interface OCJExchangeGoodsResonTVCell : UITableViewCell
@property (nonatomic,strong) UILabel * ocjLab_tip;
@property (nonatomic,assign) BOOL     ocjBool_isSelected;
@end


/**
 换货原因描述界面Cell
 */
@interface OCJExchangeGoodsDescTVCell : UITableViewCell


@property (nonatomic,strong) OCJExchangeResonHandler handler;

@end


/**
 换货商属性
 */
@interface OCJGoodsDescTVCell : UITableViewCell
@property (nonatomic,strong) UILabel * ocjLab_goodName;   ///< 商品名称
@property (nonatomic,strong) UILabel * ocjLab_goodProp;   ///< 商品属性
@property (nonatomic,strong) UIImageView * ocjImg_goodDes;///< 商品图片
@property (nonatomic,copy) OCJChooseGoodSpecBlock ocjChooseGoodSpecblock;

@end



/**
 收货后是否使用过
 */
@interface OCJExchangeGoodsGoodsUseTVCell : UITableViewCell

@property (nonatomic,copy)  OCJUseHandler handler;

@end

/**
 缺少主赠品或包装损坏
 */
@interface OCJExchangeGoodsDamageTVCell : UITableViewCell

@property (nonatomic,copy)   OCJLessHandler handler;

@end


/**
 底部Cell
 */
@interface OCJExchangeGoodsBottomTVCell : UITableViewCell
@property (nonatomic,strong) OCJUploadImageView * ocjView_bottom; ///< 上传控件

@end
