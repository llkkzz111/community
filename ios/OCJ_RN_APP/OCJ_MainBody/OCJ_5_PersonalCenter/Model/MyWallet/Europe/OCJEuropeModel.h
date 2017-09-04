//
//  OCJEuropeModel.h
//  OCJ
//
//  Created by OCJ on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 欧点详情Model
 */
@interface OCJEuropeModel : NSObject

@property (nonatomic,copy) NSString * ocjStr_insert_date;  ///< 获得日期
@property (nonatomic,copy) NSString * ocjStr_expire_date;  ///< 有效日期
@property (nonatomic,copy) NSString * ocjStr_item_name;    ///< 来源/使用去向
@property (nonatomic,copy) NSString * ocjStr_event_name;   ///< 活动方式
@property (nonatomic,copy) NSString * ocjStr_opoint_num;   ///< 鸥点数：获得(+)/使用(-)



/**
 将字典数组转化成相应的model数组
 
 @param array 服务端返回到字典数组
 @return 对应的model数组
 */
+ (NSArray*)ocj_getPreBargainListModelsFromArray:(NSArray*)array;
@end
