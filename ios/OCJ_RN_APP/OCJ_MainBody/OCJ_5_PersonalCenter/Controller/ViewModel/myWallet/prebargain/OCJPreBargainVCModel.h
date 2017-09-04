//
//  OCJPreBargainVCModel.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 预付款Model
 */
@interface OCJPreBargainVCModel : NSObject

/**
 将字典数组转化成相应的model数组
 
 @param array 服务端返回到字典数组
 @return 对应的model数组
 */
+ (NSArray*)ocj_getPreBargainListModelsFromArray:(NSArray*)array;

@end
