//
//  OCJScreenAlphabeticSorting.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJResponceModel_GlobalShopping.h"

typedef NS_ENUM(NSInteger,OCJScreenSortType) {
  OCJScreenSortTypeBrand,  ///< 品牌
  OCJScreenSortTypeHotArea ///< 热门地区
};

/**
 汉语拼音按部首归类
 */
@interface OCJScreenAlphabeticSorting : NSObject

+(NSDictionary *)ocj_screnAlphabeticSortingWithServicesArray:(NSArray *)array type:(OCJScreenSortType)sortType;

+(NSString *)ocj_chChangePin:(NSString *)sourceString;

@end
