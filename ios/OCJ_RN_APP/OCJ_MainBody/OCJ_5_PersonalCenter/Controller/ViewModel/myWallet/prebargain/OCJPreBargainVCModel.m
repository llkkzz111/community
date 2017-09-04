//
//  OCJPreBargainVCModel.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJPreBargainVCModel.h"
#import "OCJPreBarginModel.h"

@implementation OCJPreBargainVCModel

+ (NSArray *)ocj_getPreBargainListModelsFromArray:(NSArray *)array{
    
    NSMutableArray* mArray = [NSMutableArray array];
    for (NSDictionary * dic in array) {
        OCJPreBarginModel * detailModel = [[OCJPreBarginModel alloc]init];
        detailModel.ocjStr_deposit_note= [[dic objectForKey:@"deposit_note"]description];
        detailModel.ocjStr_depositamt = [[dic objectForKey:@"depositamt"]description];
        detailModel.ocjStr_proc_date = [[dic objectForKey:@"proc_date"]description];
        detailModel.ocjStr_depositamt_gb = [[dic objectForKey:@"depositamt_gb"]description];
        detailModel.ocjStr_order_no = [[dic objectForKey:@"order_no"]description];
        detailModel.ocjStr_totalcnt = [[dic objectForKey:@"totalcnt"]description];
        detailModel.ocjStr_sub = [[dic objectForKey:@"sub"]description];

        
        [mArray addObject:detailModel];
    }
    
    return [mArray copy];
}
@end
