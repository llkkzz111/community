//
//  OCJEuropeModel.m
//  OCJ
//
//  Created by OCJ on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJEuropeModel.h"

@implementation OCJEuropeModel

+ (NSArray*)ocj_getPreBargainListModelsFromArray:(NSArray*)array{
    NSMutableArray* mArray = [NSMutableArray array];
    for (NSDictionary * dic in array) {
        OCJEuropeModel * detailModel     = [[OCJEuropeModel alloc]init];
        detailModel.ocjStr_insert_date   = [[dic objectForKey:@"insert_date"] description];
        detailModel.ocjStr_expire_date   = [[dic objectForKey:@"expire_date"] description];
        detailModel.ocjStr_item_name     = [[dic objectForKey:@"item_name"  ] description];
        detailModel.ocjStr_event_name    = [[dic objectForKey:@"event_name" ] description];
        detailModel.ocjStr_opoint_num    = [[dic objectForKey:@"opoint_num" ] description];
        [mArray addObject:detailModel];
    }
    return mArray;
}

@end
