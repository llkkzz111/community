//
//  OCJResponseModel_videoLive.h
//  OCJ
//
//  Created by Ray on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseResponceModel.h"

@interface OCJResponseModel_videoLive : OCJBaseResponceModel

@end


/**
 直播model(一级)
 */
@interface OCJResponceModel_VideoLive : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_id;            ///<组件
@property (nonatomic, copy) NSString *ocjStr_pageVersionId; ///<版本id
@property (nonatomic, copy) NSMutableArray *ocjArr_detailList;     ///<详情列表数组
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end

/**
 直播model(二级)
 */
@interface OCJResponceModel_VideoDetailList : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_packageid;     ///<组件id
@property (nonatomic, copy) NSString *ocjStr_id;            ///<组件
@property (nonatomic, copy) NSString *ocjStr_isPackages;    ///<是否是组件集合  0：否 1：是
@property (nonatomic, copy) NSString *ocjStr_shortNum;      ///<排序号
@property (nonatomic, copy) NSMutableArray *ocjArr_listDesc;   ///<list详细描述model
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end

/**
 直播model(三级、四级)
 */
@interface OCJResponceModel_VideoDetailDesc : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_id;            ///<
@property (nonatomic, copy) NSString *ocjStr_title;         ///<标题
@property (nonatomic, copy) NSString *ocjStr_subTitle;      ///<二级标题
@property (nonatomic, copy) NSString *ocjStr_codeId;        ///<编码id
@property (nonatomic, copy) NSString *ocjStr_videoUrl;      ///<视频地址
@property (nonatomic, copy) NSString *ocjStr_contentCode;   ///<商品编号
@property (nonatomic, copy) NSString *ocjStr_firstImgUrl;   ///<首帧图片源地址
@property (nonatomic, copy) NSString *ocjStr_secondImgUrl;  ///<
@property (nonatomic, copy) NSString *ocjStr_thirdImgUrl;   ///<
@property (nonatomic, copy) NSString *ocjStr_shortNum;      ///<排序号
@property (nonatomic, copy) NSString *ocjStr_isCompontents; ///<是否是列表  0：否 1：是
@property (nonatomic, copy) NSString *ocjStr_componentId;   ///<列表数量
@property (nonatomic, copy) NSString *ocjStr_watchNum;      ///<观看人数
@property (nonatomic, copy) NSString *ocjStr_author;        ///<作者
@property (nonatomic, copy) NSString *ocjStr_videoDate;     ///<视频日期
@property (nonatomic, copy) NSArray *ocjArr_gifts;         ///<赠品
@property (nonatomic, copy) NSString *ocjStr_marketPrice;   ///<原价
@property (nonatomic, copy) NSString *ocjStr_salePrice;     ///<售价
@property (nonatomic, copy) NSString *ocjStr_integral;      ///<积分
@property (nonatomic, copy) NSString *ocjStr_salesNum;      ///<销售量
@property (nonatomic, copy) NSString *ocjStr_description;   ///<描述
@property (nonatomic, copy) NSString *ocjStr_inStock;       ///<库存
@property (nonatomic, copy) NSString *ocjStr_discount;      ///<折扣
@property (nonatomic, copy) NSString *ocjStr_groupBuyType;  ///<团购
@property (nonatomic, copy) NSString *ocjStr_groupBuyTime;  ///<
@property (nonatomic, copy) NSString *ocjStr_remianTime;    ///<停留时间
@property (nonatomic, copy) NSString *ocjStr_currentTime;   ///<当前时间
@property (nonatomic, copy) NSString *ocjStr_playTime;      ///<视频播出时间
@property (nonatomic, copy) NSArray *ocjArr_labelName;      ///<标签数组
@property (nonatomic, copy) NSString *ocjStr_videoStatus;   ///<视频状态 1：正在直播 2：即将播出 3：精彩回放 
@property (nonatomic, copy) NSMutableArray *ocjArr_detailDesc;     ///<model

@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end

/**
 更多视频model
 */
@interface OCJResponceModel_MoreVideo : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_nextPage;      ///<
@property (nonatomic, copy) NSString *ocjStr_isFirstPage;   ///<
@property (nonatomic, copy) NSString *ocjStr_isLastPage;    ///<
@property (nonatomic, copy) NSString *ocjStr_hasNextPage;   ///<
@property (nonatomic, copy) NSMutableArray *ocjArr_list;    ///<

@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end

/**
 商品规格model
 */
@class OCJResponceModel_GoodsSpec;
@interface OCJResponceModel_Spec : OCJBaseResponceModel

@property (nonatomic, strong) OCJResponceModel_GoodsSpec *ocjModel_goodsSpec; ///<规格字典
@property (nonatomic, strong) NSDictionary *ocjDic_goodsDetail;               ///<详情字典
@property (nonatomic, copy) NSString *ocjStr_numControll;                     ///<控制限购数量
@property (nonatomic, copy) NSString *ocjStr_tvNumControll;                   ///<限购数量

@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end

@interface OCJResponceModel_GoodsSpec : OCJBaseResponceModel

@property (nonatomic, copy) NSMutableArray *ocjArr_size;     ///<尺寸数组
@property (nonatomic, copy) NSMutableArray *ocjArr_color;    ///<颜色数组
@property (nonatomic, copy) NSMutableArray *ocjArr_colorSize;///<颜色尺寸数组

@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end

@interface OCJResponceModel_specDetail : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_csoff;          ///<无存货编号
@property (nonatomic, copy) NSString *ocjStr_cscode;         ///<编号
@property (nonatomic, copy) NSString *ocjStr_imgUrl;         ///<图片地址
@property (nonatomic, copy) NSString *ocjStr_hiddenWu;       ///<是否显示此栏
@property (nonatomic, copy) NSString *ocjStr_isShow;         ///<该商品是否可点击
@property (nonatomic, copy) NSString *ocjStr_name;           ///<名称
@property (nonatomic, copy) NSString *ocjStr_unitCode;       ///<unitCode

@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end

/**
 赠品列表model
 */
@interface OCJResponceModel_giftList : OCJBaseResponceModel

@property (nonatomic, copy) NSMutableArray *ocjArr_list;     ///<赠品列表
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end

@interface OCJResponceModel_giftDesc : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_imgUrl;        ///<图片地址
@property (nonatomic, copy) NSString *ocjStr_itemCode;      ///<编号
@property (nonatomic, copy) NSString *ocjStr_quantity;      ///<数量
@property (nonatomic, copy) NSString *ocjStr_name;          ///<赠品
@property (nonatomic, copy) NSString *ocjStr_itemName;      ///<赠品名称
@property (nonatomic, copy) NSString *ocjStr_id;            ///<id
@property (nonatomic, copy) NSString *ocjStr_giftGB;        ///<
@property (nonatomic, copy) NSString *ocjStr_unitCode;      ///<赠品规格编号

@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号

@end
