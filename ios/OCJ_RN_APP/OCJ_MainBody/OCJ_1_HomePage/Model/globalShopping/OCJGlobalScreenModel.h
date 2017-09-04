//
//  OCJGlobalScreenModel.h
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/7/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJBaseRequestModel.h"
#import "OCJResponceModel_GlobalShopping.h"

@interface OCJGlobalScreenRequestModel : NSObject

@end

@interface OCJGSRModel_screenCondition : OCJBaseRequestModel

@property (nonatomic) BOOL ocjBool_isAll; ///< 是否是全部状态（yes-全部 no-非全部）

@property (nonatomic,copy)  NSString* ocjStr_salesVolumeSort; ///< 销量排序条件（1-降序）

@property (nonatomic,copy)  NSString* ocjStr_priceSort; ///< 价格排序条件（1-升序 2-降序）

@property (nonatomic,strong)  NSArray<OCJGSModel_HotArea*>* ocjArr_areaFiltrate; ///< 热门地区筛选条件
@property (nonatomic,copy)  NSString* ocjStr_area; ///< 选中的地区名称（请求时多品牌以逗号隔开封成字符串）
@property (nonatomic,copy)  NSString* ocjStr_areaCode; ///< 选中的地区code（请求时多品牌以逗号隔开封成字符串）

@property (nonatomic,strong)  NSArray<OCJGSModel_Brand*>* ocjArr_brandFiltrate; ///< 品牌筛选条件
@property (nonatomic,copy)  NSString* ocjStr_brand; ///< 选中的品牌名称（请求时多品牌以逗号隔开封成字符串）
@property (nonatomic,copy)  NSString* ocjStr_brandCode; ///< 选中的品牌code（请求时多品牌以逗号隔开封成字符串）

@property (nonatomic,copy) NSString* ocjStr_cate; ///< 分类筛选条件

@property (nonatomic,copy)  NSString* ocjStr_superValueFiltrate; ///< 超值单品筛选条件（1-是 0-否）

/**
 重置筛选排序条件
 */
-(void)ocj_resetScreenCondition;

@end
