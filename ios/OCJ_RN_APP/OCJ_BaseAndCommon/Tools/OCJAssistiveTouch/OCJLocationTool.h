//
//  OCJLocationTool.h
//  OCJ_RN_APP
//
//  Created by OCJ on 2017/6/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCJLocationTool : NSObject

+ (instancetype)shareInstanceAndStartLocation;

@property (nonatomic, copy) void(^ocjBackAddressAndLocation)(NSDictionary *address, NSDictionary *latAndLong);

@end
