//
//  OCJDataUserInfo+CoreDataProperties.h
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJDataUserInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface OCJDataUserInfo (CoreDataProperties)

+ (NSFetchRequest<OCJDataUserInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *ocjStr_account;
@property (nullable, nonatomic, copy) NSString *ocjStr_icon;
@property (nullable, nonatomic, copy) NSString *ocjStr_name;
@property (nullable, nonatomic, copy) NSString *ocjStr_nick;

@end

NS_ASSUME_NONNULL_END
