//
//  OCJAreaProvinceModel.h
//  OCJ
//
//  Created by 董克楠 on 12/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseResponceModel.h"

@interface OCJAreaProvinceModel : OCJBaseResponceModel

@end

@interface OCJAreaProvinceListModel : OCJBaseResponceModel

@property (nonatomic, copy) NSMutableArray *ocjArr_provinceList;

@end

@interface OCJSinglProvinceModel : OCJBaseResponceModel

@property (nonatomic, copy) NSString *ocjStr_id;            ///<
@property (nonatomic, copy) NSString *ocjStr_name;         //省份名
@property (nonatomic, copy) NSString *ocjStr_sort;
@property (nonatomic, copy) NSString *ocjStr_remark1_v; ///< 省编号
@property (nonatomic, copy) NSString *ocjStr_remark2_v; ///< 市编号
@property (nonatomic, copy) NSString *ocjStr_FirstLetter;   //首字母
@property (nonatomic, copy) NSString *ocjStr_regionCd; ///< 
@property (nonatomic, copy) NSString *ocjStr_selRegionCd; ///<
@property (nonatomic, copy) NSString *ocjStr_remark;    ///< 区编号

@end
