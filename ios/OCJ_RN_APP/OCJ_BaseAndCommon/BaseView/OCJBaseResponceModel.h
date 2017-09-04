//
//  OCJBaseResponceModel.h
//  OCJ
//
//  Created by yangyang on 2017/5/2.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCJBaseResponceModel : NSObject

@property (nonatomic,copy) NSString* ocjStr_code; ///< 响应码 （参照接口文档）

@property (nonatomic,copy) NSString* ocjStr_message; ///< 响应码对应信息

@property (nonatomic,strong) NSDictionary* ocjDic_data; ///< 响应数据体



/**
 网络请求model子类初始化方法

 @param baseModel 网络请求model基类对象
 @return 网络请求model子类对象
 */
- (instancetype)initOCJSubResponceModelSetValuesWithBaseResponceModel:(OCJBaseResponceModel*)baseModel;


@end
