//
//  OCJTBC.h
//  ProjectName
//
//  Created by DHY on 2017/4/10.
//  Copyright © 2017年 DHY. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 页卡栏控制器
 */
@interface OCJTBC : UITabBarController

/**
 类方法
 各项参数不为空，参数元素个数相等，控制器名称对应的类必须存在，否则抛出异常，程序终止

 @param titles 有序标题数组
 @param names 有序控制器类名数组
 @param images 有序item未选中图片数组
 @param selectedImages 有序item选中图片数组
 @return 初始化的实例对象
 */
+ (instancetype)controllerOCJWithTitles:(NSArray *)titles
                        controllerNames:(NSArray *)names
                                 images:(NSArray *)images
                         selectedImages:(NSArray *)selectedImages;


/**
 实例方法
 各项参数不为空，参数元素个数相等，控制器名称对应的类必须存在，否则抛出异常，程序终止
 
 @param titles 有序标题数组
 @param names 有序控制器类名数组
 @param images 有序item未选中图片数组
 @param selectedImages 有序item选中图片数组
 @return 初始化的实例对象
 */
- (instancetype)initOCJWithTitles:(NSArray *)titles
                        controllerNames:(NSArray *)names
                           images:(NSArray *)images
                   selectedImages:(NSArray *)selectedImages;




@end
