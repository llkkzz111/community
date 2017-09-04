//
//  OCJResponceModel_VipArea.h
//  OCJ
//
//  Created by wb_yangyang on 2017/6/11.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseResponceModel.h"

/**
 VIP首页接口model
 */
@interface OCJResponceModel_VipArea : OCJBaseResponceModel
//不用
@end


@class OCJVIPModel_BrandDetail;
@class OCJVIPModel_BrandItem;
@class OCJVIPModel_VIPChoicenessDetail;
@class OCJVIPModel_VIPChoicenessItem;


/**
 VIP首页详情接口-接口响应model
 */
@interface  OCJVIPModel_Detail: OCJBaseResponceModel

@property (nonatomic,strong) OCJVIPModel_BrandDetail* ocjModel_brandDetail;
@property (nonatomic,strong) OCJVIPModel_VIPChoicenessDetail* ocjModel_vipChoicenessDetail;
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end


//====================================================================
/**
 品牌推荐详情
 */
@interface OCJVIPModel_BrandDetail : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_brandIconUrl; ///< 品牌icon
@property (nonatomic,copy) NSString* ocjStr_brandName;    ///< 品牌名称
@property (nonatomic,copy) NSString* ocjStr_brandDescription; ///< 品牌描述
@property (nonatomic,strong) NSArray<OCJVIPModel_BrandItem*>* ocjArr_brandItems; ///< 品牌推荐商品列表
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end


/**
 品牌推荐商品
 */
@interface OCJVIPModel_BrandItem : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_itemCode; ///< 商品编码
@property (nonatomic,copy) NSString* ocjStr_imageUrl; ///< 商品图片
@property (nonatomic,copy) NSString* ocjStr_title; ///< 商品名称
@property (nonatomic,copy) NSString* ocjStr_description; ///< 商品描述
@property (nonatomic,copy) NSString* ocjStr_price; ///< 商品价格
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end


/**
 VIP精选详情
 */
@interface OCJVIPModel_VIPChoicenessDetail : OCJBaseResponceModel

@property (nonatomic,strong) NSArray<OCJVIPModel_VIPChoicenessItem*>* ocjArr_vipChoicenessItems; ///< VIP精选商品列表
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end

/**
 VIP精选商品
 */
@interface OCJVIPModel_VIPChoicenessItem : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_itemCode; ///< 商品编码
@property (nonatomic,copy) NSString* ocjStr_imageUrl; ///< 商品图片
@property (nonatomic,copy) NSString* ocjStr_title; ///< 商品名称
@property (nonatomic,copy) NSString* ocjStr_price; ///< 商品价格(会员价)
@property (nonatomic,copy) NSString* ocjStr_score; ///< 商品积分
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号
@property (nonatomic, copy) NSString* ocjStr_giftName;    ///< 赠品名称
@property (nonatomic, copy) NSString* ocjStr_content_nm; ///< 主播推荐
@property (nonatomic, copy) NSString *ocjStr_sellPrice;  ///<正常售价


@end
