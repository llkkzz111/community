//
//  OCJResponseModel_evaluate.h
//  OCJ
//
//  Created by Ray on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseResponceModel.h"

@interface OCJResponseModel_evaluate : OCJBaseResponceModel

@end

@interface OCJResponceModel_imageAddr : OCJBaseResponceModel

@property (nonatomic, copy) NSArray *ocjArr_imageList;      ///<图片列表
@property (nonatomic, copy) NSString *ocjStr_result;        ///<返回结果

@end
