//
//  OCJGlobalScreenVC.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

/**
 全球购列表
 */
@interface OCJGlobalScreenVC : OCJBaseVC


/**
 初始化全球购列表数据

 @param lGroup 筛选条件1
 @param contentType 筛选条件2
 @param keyword 关键字
 @return 
 */
- (instancetype)initWithContentLGroup:(NSString *)lGroup contentType:(NSString*)contentType keyword:(NSString*)keyword;


@end
