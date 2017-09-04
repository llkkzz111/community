//
//  OCJDataUserInfo+CoreDataProperties.m
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJDataUserInfo+CoreDataProperties.h"

@implementation OCJDataUserInfo (CoreDataProperties)

+ (NSFetchRequest<OCJDataUserInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"OCJDataUserInfo"];
}

@dynamic ocjStr_account;
@dynamic ocjStr_icon;
@dynamic ocjStr_name;
@dynamic ocjStr_nick;

@end
