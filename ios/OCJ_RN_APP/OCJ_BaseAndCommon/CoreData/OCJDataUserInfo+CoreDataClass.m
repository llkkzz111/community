//
//  OCJDataUserInfo+CoreDataClass.m
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJDataUserInfo+CoreDataClass.h"
#import "AppDelegate.h"

@implementation OCJDataUserInfo

+ (void)ocj_insertUserInfoWithName:(NSString *)name nick:(NSString *)nick account:(NSString *)account headIconUrl:(nonnull NSString *)iconUrl{
  
    AppDelegate * delegate = [AppDelegate ocj_getShareAppDelegate];
    NSManagedObjectContext * context = delegate.managedObjectContext;

    OCJDataUserInfo * userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"OCJDataUserInfo" inManagedObjectContext:context];
    userInfo.ocjStr_name = name;
    userInfo.ocjStr_nick = nick;
    userInfo.ocjStr_account = account;
    userInfo.ocjStr_icon = iconUrl;
  
    [delegate saveContext];
  
}

+ (NSArray *)ocj_fetchUserInfo{
  
  AppDelegate * delegate = [AppDelegate ocj_getShareAppDelegate];
  NSManagedObjectContext * context = delegate.managedObjectContext;
  NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"OCJDataUserInfo"];
  NSArray * array = [context executeFetchRequest:request error:NULL];
  for (OCJDataUserInfo* info in array) {
    
    OCJLog(@"userInfo%zi,%@,%@,%@,%@",[array indexOfObject:info],info.ocjStr_name,info.ocjStr_icon,info.ocjStr_nick,info.ocjStr_account);
  }
  
  return array;
}
@end
