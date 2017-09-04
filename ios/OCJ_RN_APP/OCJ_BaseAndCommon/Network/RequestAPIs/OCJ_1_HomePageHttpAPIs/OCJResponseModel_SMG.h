//
//  OCJResponseModel_SMG.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJBaseResponceModel.h"

@class OCJResponseModel_SMGListDetail;

/**
 SMG详情信息model
 */
@interface OCJResponseModel_SMG : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///<埋点ID
@property (nonatomic, copy) NSString *ocjStr_id;              ///<id
@property (nonatomic, copy) NSString *ocjStr_pageVersionName; ///<版本号
@property (nonatomic, copy) NSArray<OCJResponseModel_SMGListDetail*> * ocjArr_smgList;   ///<数据列表

@end


@interface OCJResponseModel_SMGListDetail : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_id;              ///< 编码ID
@property (nonatomic, copy) NSString *ocjStr_subTitle;        ///< 时间
@property (nonatomic, copy) NSString *ocjStr_title;           ///< 星期(数字对应星期，多天用逗号隔开)
@property (nonatomic, copy) NSString *ocjStr_shortNum;        ///< 排序号
@property (nonatomic, copy) NSString *ocjStr_codeValue;       ///< 埋点ID
@property (nonatomic, copy) NSString *ocjStr_codeID;          ///<
@property (nonatomic, copy) NSString *ocjStr_imageUrl;        ///< 图片地址
@property (nonatomic, copy) NSString *ocjStr_isNew;           ///<
@property (nonatomic, copy) NSString *ocjStr_isComponents;    ///< 是否是列表 0：否 1：是
@property (nonatomic, copy) NSString *ocjStr_componentID;     ///< 元件ID
@property (nonatomic, copy) NSString *ocjStr_destinationUrl;  ///< 目标URL(抢红包unitNO)
@property (nonatomic, copy) NSString *ocjStr_rules;           ///< 活动规则

@property (nonatomic) BOOL ocjBool_isIntime; ///< 是否在活动时间 （非接口返回，自己算出）

@end

