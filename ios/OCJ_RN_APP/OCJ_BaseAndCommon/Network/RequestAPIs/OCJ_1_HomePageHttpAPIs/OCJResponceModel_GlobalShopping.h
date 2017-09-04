//
//  OCJResponceModel_GlobalShopping.h
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCJResponceModel_GlobalShopping : NSObject

@end

//************************************全球购首页************************************

/**
 全球购首页model
 */
@interface OCJGSModel_Detail : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_codeValue; ///<  埋点编号

@property (nonatomic,strong) NSArray* ocjArr_packages;  ///< 橱窗位数组
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end


/**
 橱窗位2
 */
@interface OCJGSModel_Package2 : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_imageUrl; ///< 图片地址
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///< 埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///< 版本号
@property (nonatomic, copy) NSString * ocjStr_destinationUrl; ///< 跳转H5地址

@end

/**
 橱窗位4
 */
@interface OCJGSModel_Package4 : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_imageUrl; ///< 图片地址
@property (nonatomic,copy) NSString* ocjStr_title;  ///< 标题
@property (nonatomic,copy) NSString* ocjStr_lGroup; ///< 跳列表关键字1
@property (nonatomic,copy) NSString* ocjStr_contentType; ///< 跳列表关键字2
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end

/**
 橱窗位42
 */
@interface OCJGSModel_Package42 : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_itemCode; ///< 商品编码
@property (nonatomic,copy) NSString* ocjStr_imageUrl; ///< 图片地址
@property (nonatomic,copy) NSString* ocjStr_title;  ///< 标题
@property (nonatomic,copy) NSString* ocjStr_price;  ///< 价格
@property (nonatomic,copy) NSString* ocjStr_country;  ///< 国家
@property (nonatomic,copy) NSString* ocjStr_countryImageUrl;  ///< 国旗图片地址
@property (nonatomic,copy) NSString* ocjStr_countryCode;  ///< 国旗编码
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号
@property (nonatomic,copy) NSString* ocjStr_lGroup; ///< 跳列表关键字1
@property (nonatomic,copy) NSString* ocjStr_contentType; ///< 跳列表关键字2

@end

/**
 橱窗位43
 */
@interface OCJGSModel_Package43 : OCJBaseResponceModel
@property (nonatomic,copy) NSString* ocjStr_itemCode; ///< 商品编码
@property (nonatomic,copy) NSString* ocjStr_imageUrl; ///< 图片地址
@property (nonatomic,copy) NSString* ocjStr_title;  ///< 标题
@property (nonatomic,copy) NSString* ocjStr_subTitle;  ///< 副标题
@property (nonatomic,copy) NSString* ocjStr_price;  ///< 价格
@property (nonatomic,copy) NSString* ocjStr_country;  ///< 国家
@property (nonatomic,copy) NSString* ocjStr_countryImageUrl;  ///< 国旗图片地址
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end

/**
 橱窗位14
 */
@interface OCJGSModel_Package14 : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_imageUrl; ///< 图片地址
@property (nonatomic,copy) NSString* ocjStr_title;  ///< 标题
@property (nonatomic,copy) NSString* ocjStr_subTitle;  ///< 副标题
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号
@property (nonatomic, copy) NSString * ocjStr_destinationUrl; ///< 跳转H5地址
@property (nonatomic, copy) NSString* ocjStr_lGroup; ///< 列表搜索关键字1
@property (nonatomic, copy) NSString* ocjStr_contentType; ///< 列表搜索关键字2
@property (nonatomic, copy) NSString* ocjStr_status; ///< 商品标签（0-无 1-新 2-促）
@end

/**
 橱窗位10
 */
@interface OCJGSModel_Package10 : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_imageUrl; ///< 图片地址
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号
@property (nonatomic, copy) NSString * ocjStr_destinationUrl; ///< 跳转H5地址

@end

/**
 橱窗位44
 */
@interface OCJGSModel_Package44 : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_id; ///< 商品橱窗位
@property (nonatomic,copy) NSString* ocjStr_itemCode; ///< 商品编码
@property (nonatomic,copy) NSString* ocjStr_imageUrl; ///< 图片地址
@property (nonatomic,copy) NSString* ocjStr_title;  ///< 标题
@property (nonatomic,copy) NSString* ocjStr_subTitle;  ///< 副标题
@property (nonatomic,copy) NSString* ocjStr_price;  ///< 价格
@property (nonatomic,copy) NSString* ocjStr_country;  ///< 国家
@property (nonatomic,copy) NSString* ocjStr_countryImageUrl;  ///< 国旗图片地址
@property (nonatomic,copy) NSString* ocjStr_discount;  ///< 折扣
@property (nonatomic,copy) NSString* ocjStr_isInStock;  ///< 是否库存紧张 1-紧张 0-不紧张
@property (nonatomic,copy) NSString* ocjStr_giftContent; ///< 赠品信息
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end


/**
 全球购热门推荐分页model
 */
@interface OCJGSModel_MorePageList : OCJBaseResponceModel

@property (nonatomic,strong) NSArray<OCJGSModel_Package44*>* ocjArr_moreItems;
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end


//************************************全球购列表************************************

/**
 全球购列表model
 */
@interface OCJGSModel_listDetail : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_codeValue; ///<  埋点编号
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号
@property (nonatomic, copy) NSString *ocjStr_goodsID; ///< 商品类目ID（分页接口需要使用）

@property (nonatomic,strong) NSArray<OCJGSModel_Package44*>* ocjArr_listItem; ///< 全球购列表商品model集合

@end

@interface OCJGSModel_moreListDetail : OCJBaseResponceModel

@property (nonatomic,strong) NSArray<OCJGSModel_Package44*>* ocjArr_listItem; ///< 全球购列表分页商品model集合

@end


@class OCJGSModel_HotArea;
@class OCJGSModel_Brand;
/**
 全球购列表筛选条件model
 */
@interface OCJGSModel_ScreeningCondition: OCJBaseResponceModel

@property (nonatomic,strong) NSArray<OCJGSModel_HotArea*>* ocjArr_hotAreas;
@property (nonatomic,strong) NSArray<OCJGSModel_Brand*>* ocjArr_Brands;

@end


/**
 热门地区
 */
@interface OCJGSModel_HotArea : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_areaName; ///< 地名
@property (nonatomic, copy) NSString *ocjStr_areaCode; ///< 地区编码

@end


/**
 品牌
 */
@interface OCJGSModel_Brand : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_brandName; ///< 品牌名
@property (nonatomic, copy) NSString *ocjStr_brandCode; ///< 品牌编码

@end






