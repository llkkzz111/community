//
//  AppDelegate.h
//  OCJ
//
//  Created by yangyang on 17/4/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "OCJProvincePageVC.h"
#import "JPUSHService.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate ,JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@property (nonatomic) BOOL ocjBool_isPreLoginPage; ///< 登录页面是否正在弹出，防止登录页面多次弹出

@property (nonatomic, assign) NSInteger ocjInt_allowRotation;  ///< 是否允许横屏

@property (nonatomic, strong) NSArray* ocjArr_beforeVCsToRN; ///< 跳转RN前的导航栈保留（为了RN界面返回时原封不动的插回导航栈，实现RN返回原生的效果）

@property (nonatomic) BOOL ocjBool_isLogined; ///< 是否登录过,防止登录之前首页使用旧token请求签到数据报错

@end

