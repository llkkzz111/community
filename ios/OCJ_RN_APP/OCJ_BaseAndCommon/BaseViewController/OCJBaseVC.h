//
//  OCJBaseVC.h
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJBaseNC.h"

typedef void(^OCJBaseVCBackDoneHandler) (); ///< model返回结束回调

@interface OCJBaseVC : UIViewController

@property (nonatomic,copy)  NSString* ocjStr_trackPageVersion; ///< 页面版本（用于埋点时监控页面）<设置此值要前于设置页面ID，CMS页面必须设置，非CMS页面无需设置>
@property (nonatomic,copy)  NSString* ocjStr_trackPageID; ///< 页面ID（用于埋点时监控页面）


/**
 埋点方法
 
 @param eventID 事件ID
 @param parmas 参数
 */
-(void)ocj_trackEventID:(NSString*)eventID parmas:(NSDictionary*)parmas;



@property (nonatomic,weak) OCJBaseNC* ocjNavigationController;///< 导航栏
/**
 push页面

 @param vc 将要push的vc
 */
-(void)ocj_pushVC:(OCJBaseVC*)vc;

/**
 model页面

 @param vc 将要model的页面
 */
-(void)ocj_modelVC:(UIViewController*)vc;

/**
 返回上一页面
 */
-(void)ocj_back;


/**
 回到导航栏的根控制器（此方法关系到跳RN后返回原生页面的加载）
 */
-(void)ocj_popToNavigationRootVC;


@property (nonatomic,strong) OCJBaseVCBackDoneHandler ocjBlock_backDone; ///< 页面退出完成

/**
 设置导航栏右侧按钮集

 @param titles 按钮标题集
 @param selectorNames selector名称集合
 */
-(void)ocj_setRightItemTitles:(NSArray<NSString*> *)titles
                selectorNames:(NSArray<NSString*> *)selectorNames;

/**
 设置导航栏右侧按钮集
 
 @param images 按钮图标名称集
 @param selectorNames selector名称集合
 */
-(void)ocj_setRightItemImageNames:(NSArray<NSString*> *)images
                   selectorNames:(NSArray<NSString*> *)selectorNames;

/**
 设置导航栏左侧按钮集
 
 @param titles 按钮标题集
 @param selectorNames selector名称集合
 */
-(void)ocj_setLeftItemTitles:(NSArray<NSString*> *)titles
                selectorNames:(NSArray<NSString*> *)selectorNames;

/**
 收到登录通知后刷新本页数据
 */
-(void)ocj_loginedAndLoadNetWorkData;




@end


