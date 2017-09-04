//
//  OCJImageBrowseVC.h
//  OCJ
//
//  Created by Ray on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

/**
 图片浏览器
 */
@interface OCJImageBrowseVC : OCJBaseVC

/**
 图片数组
 */
@property (nonatomic, strong) NSArray *ocjArr_image;

/**
 当前点击的是第几张图片
 */
@property (nonatomic,assign) NSInteger ocjInt_index;

@end
