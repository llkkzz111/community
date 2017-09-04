//
//  AppDelegate.m
//  OCJ
//
//  Created by yangyang on 17/4/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+OCJExtension.h"
#import "AppDelegate+OCJUmengExtension.h"
#import "WSHHThirdPartyLogin.h"
#import "OCJNetWorkCenter.h"
#import "WSHHThirdPay.h"
#import "OCJBaseVC.h"
#import "OcjStoreDataAnalytics.h"
#import "APOpenAPI.h"
#import "OCJSharePopView.h"
#import "OpenUDID.h"
#import "OCJRouter.h"
#import "OCJ_RN_WebViewVC.h"

#import <JZLiveSDK/JZLiveSDK.h>
#import "OCJStartView.h"
#import "MF_Base64Additions.h"
#import "OCJ_GlobalShoppingHttpAPI.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"

// iOS10注册APNs所需头文件
#ifdef OCJ_AppVersion_iOS10x
#import <UserNotifications/UserNotifications.h>
#endif

#if defined(DEBUG) || defined(_DEBUG)
#import "FHHFPSIndicator.h"
#endif

#define JPushAPPKey  @"00eda49906354dd3e7742ccd" //正式线上项目
//#define JPushAPPKey  @"71540c5b90825220bd92f2fc"  //抢先版

#define JZKEY @"jz2017025016" ///< 网络直播key
#define JZSECRETKEY @"eaff11e6bb24fe536cc660d10390dd8c73b86dda8153e6c1fa6b3c688f823dee" ///< 网络直播secretKey

@interface AppDelegate ()<APOpenAPIDelegate>

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    //第三方SDK相关设置
    [WSHHThirdPartyLogin wshh_settingThirdParty];//对第三方登录相关设置
  
    [self application:application umeng_didFinishLaunchingWithOptions:launchOptions];//注册友盟
  
    [self ocj_JPushRegisterWith:application launchOptions:launchOptions];//注册极光推送
  
    [JZGeneralApi registerApp:JZKEY secretKey:JZSECRETKEY];
  
    [OcjStoreDataAnalytics init:DataAnalyticsTalkingdata | DataAnalyticsOcj]; ///< 注册埋点（正式环境需要去类中设置TD appKey，和更改东购本身埋点上传接口地址）
  
  
    //App相关设置
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:OCJ_FONT_SETTING_KEY]; //设置使用默认字体大小
  
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];//开启网络监控
  
    self.ocjInt_allowRotation = 1;
  
    [OCJ_NOTICE_CENTER addObserver:self selector:@selector(ocj_reLogin) name:OCJNotice_NeedLogin object:nil];//监听用户重新登录通知
  
    [self ocj_switchRootViewController];//设置根视图
  
    #if defined(DEBUG) || defined(_DEBUG)
      [[FHHFPSIndicator sharedFPSIndicator] showWithView:self.window];//显示页面帧率
    #endif

    //引导页
    [OCJStartView ocj_StartViewCompletionHandler:^(OCJStartView *startView) {
      [startView removeFromSuperview];
    }];
  
    [OCJ_RN_WebViewVC ocj_setUserAgentForApp];//为UIWebView的request设置自定义User-Agent
  
    [[SDWebImageManager sharedManager]imageCache].maxMemoryCost = 50;
  
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
  if (self.ocjInt_allowRotation == 0) {
    
    return UIInterfaceOrientationMaskLandscapeLeft;
  }else if (self.ocjInt_allowRotation == 1) {
    
    return UIInterfaceOrientationMaskPortrait;
  }else {
    
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
  }
}

-(void)ocj_JPushRegisterWith:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
  //Required
  //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
  JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
  entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
  
  [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

  [JPUSHService setupWithOption:launchOptions appKey:JPushAPPKey
                        channel:@"App Store"
               apsForProduction:YES
          advertisingIdentifier:nil];
  
  [OCJ_NOTICE_CENTER addObserver:self selector:@selector(ocj_receiveJPushNotice:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
  OCJLog(@"openID:%@",[OpenUDID value]);
  
  [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
    OCJLog(@"JG_ID:%@",registrationID);
      if (registrationID && [registrationID wshh_stringIsValid]) {
          [JPUSHService setAlias:registrationID callbackSelector:nil object:nil];
          [[NSUserDefaults standardUserDefaults]setValue:registrationID forKey:OCJDeviceID];
      }
  }];
}

-(void)ocj_receiveJPushNotice:(NSNotification*)notice{
  
  OCJLog(@"收到通知：%@",notice.userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark 推送相关方法
// 获取apple的推送token 回传给Jpush
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  
  /// Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
  
}

//实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//接受通知协议方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  
  OCJLog(@"收到通知1：%@",userInfo);
  [self ocj_dealWithNoticeUserInfo:userInfo];
  // Required, iOS 7 Support
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}


#pragma mark- JPUSHRegisterDelegate    添加处理APNs通知回调方法

// iOS 10 Support  获取到通知信息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
  // Required
  NSDictionary * userInfo = notification.request.content.userInfo;
  
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  
  completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  
  // Required
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  [self ocj_dealWithNoticeUserInfo:userInfo];
  OCJLog(@"收到通知2：%@",userInfo);
  
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  
  completionHandler();  // 系统要求执行这个方法
}

- (void)ocj_dealWithNoticeUserInfo:(NSDictionary*)userInfo{
  if (![userInfo isKindOfClass:[NSDictionary class]]) {
//    [OCJProgressHUD ocj_showHudWithTitle:@"通知不对哦" andHideDelay:2];
    return;
  }
  
  NSString* extrasKey = userInfo[@"extrasKey"];
  if (extrasKey.length>0) {
    extrasKey = [NSString stringFromBase64String:extrasKey];
    if (extrasKey.length==0) {
//      [OCJProgressHUD ocj_showHudWithTitle:@"通知-消息体为空" andHideDelay:2];
      return;
    }
    
    NSData* extrasData = [extrasKey dataUsingEncoding:NSUTF8StringEncoding];
    if (![extrasData isKindOfClass:[NSData class]]) {
      return;
    }
    
    NSDictionary* extrasDic = [NSJSONSerialization JSONObjectWithData:extrasData options:0 error:nil];
    if (![extrasDic isKindOfClass:[NSDictionary class]]) {
//      [OCJProgressHUD ocj_showHudWithTitle:@"通知-消息体不符合约定的json格式" andHideDelay:2];
      return;
    }
    
    NSString* toPage = extrasDic[@"toPage"];
    if (!toPage || toPage.length==0) {
      //      [OCJProgressHUD ocj_showHudWithTitle:@"无目的页面" andHideDelay:2];
      return;
    }
    
    NSDictionary* params = extrasDic[@"params"];
    if (params && ![params isKindOfClass:[NSDictionary class]]) {
      //      [OCJProgressHUD ocj_showHudWithTitle:@"页面参数格式不对" andHideDelay:2];
      return;
    }
    
    if (!params) {
      params = @{};
    }
    
    [OCJ_NOTICE_CENTER postNotificationName:OCJ_Notification_DealPushMessage object:nil userInfo:@{@"page":toPage,@"param":params}];
  }
  
}


#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
  // The directory the application uses to store the Core Data store file. This code uses a directory named "fx.com.threeEyes" in the application's documents directory.
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
  // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OCJ" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  // Create the coordinator and store
  
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"OCJ.sqlite"];
  NSError *error = nil;
  NSString *failureReason = @"There was an error creating or loading the application's saved data.";
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
    // Report any error we got.
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    // Replace this with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    
    abort();
  }
  
  return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
  // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (!coordinator) {
    return nil;
  }
  _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    NSError *error = nil;
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      OCJLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}



#pragma mark - 第三方登录
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"] || [url.host isEqualToString:@"uppayresult"]) {
        [[WSHHThirdPay sharedInstance] wshh_thirdPartyCompletionHandlerWithUrl:url];
    }
  
    return [WXApi handleOpenURL:url delegate:[WSHHWXLogin sharedInstance]] || [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:[WSHHWeiboLogin sharedInstance]] || [APOpenAPI handleOpenURL:url delegate:[OCJSharePopView sharedInstance]];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[WSHHWXLogin sharedInstance]] || [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:[WSHHWeiboLogin sharedInstance]] || [APOpenAPI handleOpenURL:url delegate:[OCJSharePopView sharedInstance]];
}


/**
 9.0以后使用新API接口
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
  
    OCJLog(@"urlHost:%@",url.host);
    if ([url.host isEqualToString:@"safepay"] || [url.host isEqualToString:@"uppayresult"]) {
        [[WSHHThirdPay sharedInstance] wshh_thirdPartyCompletionHandlerWithUrl:url];
    }
  
  return [WXApi handleOpenURL:url delegate:[WSHHWXLogin sharedInstance]] || [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:[WSHHWeiboLogin sharedInstance]] || [APOpenAPI handleOpenURL:url delegate:[OCJSharePopView sharedInstance]];
}

- (void)onReq:(APBaseReq *)req {
    OCJLog(@"req = %@", req);
}

- (void)onResp:(APBaseResp *)resp {
    OCJLog(@"resp = %@ %d", resp.errStr ,resp.errCode);
}

@end
