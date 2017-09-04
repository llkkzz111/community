//
//  AppDelegate+OCJUmengExtension.m
//  OCJ_RN_APP
//
//  Created by OCJ on 2017/6/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "AppDelegate+OCJUmengExtension.h"
#import <UMMobClick/MobClick.h>

static NSString* OCJUMengAPPKey = @"5153fa9d56240bcd15000904";


@implementation AppDelegate (OCJUmengExtension)

- (void)application:(UIApplication *)application umeng_didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

  UMConfigInstance.appKey = OCJUMengAPPKey;
  UMConfigInstance.channelId = @"AppStore";
  [UMConfigInstance setBCrashReportEnabled:YES];
  
  [MobClick setLogEnabled:YES];
  [MobClick setAppVersion:XcodeAppVersion];
  
  [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
  
  [self umengDeviceid];
}

- (void)umengDeviceid{
  Class cls = NSClassFromString(@"UMANUtil");
  SEL deviceIDSelector = @selector(openUDIDString);
  NSString *deviceID = nil;
  if(cls && [cls respondsToSelector:deviceIDSelector]){
    deviceID = [cls performSelector:deviceIDSelector];
  }
  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:nil];
  
  OCJLog(@"umeng_OID:%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
  
}

@end
