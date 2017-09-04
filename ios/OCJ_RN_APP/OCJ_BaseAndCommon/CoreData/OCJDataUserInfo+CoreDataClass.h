//
//  OCJDataUserInfo+CoreDataClass.h
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCJDataUserInfo : NSManagedObject


/**
 写入用户信息

 @param name 用户姓名
 @param nick 用户昵称
 @param account 用户账户
 @param iconUrl 用户头像路径
 */
+ (void)ocj_insertUserInfoWithName:(NSString*)name nick:(NSString*)nick account:(NSString*)account headIconUrl:(NSString*)iconUrl;


+ (NSArray*)ocj_fetchUserInfo;

@end

NS_ASSUME_NONNULL_END

#import "OCJDataUserInfo+CoreDataProperties.h"
