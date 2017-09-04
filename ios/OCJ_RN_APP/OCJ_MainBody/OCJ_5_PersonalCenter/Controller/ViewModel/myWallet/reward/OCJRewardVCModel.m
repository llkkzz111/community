//
//  OCJRewardVCModel.m
//  OCJ
//
//  Created by yangyang on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRewardVCModel.h"
#import "OCJRewardModel.h"

@implementation OCJRewardVCModel

+(NSArray *)ocj_getRewardListModelsFromArray:(NSArray *)array{
    NSMutableArray* mArray = [NSMutableArray array];
    for (NSDictionary * dic in array) {
        OCJRewardModel * detailModel = [[OCJRewardModel alloc]init];
        detailModel.ocjStr_DEPOSIT_NOTE_APP = [[dic objectForKey:@"DEPOSIT_NOTE_APP"]description];
        detailModel.ocjStr_USE_AMT_APP = [[dic objectForKey:@"USE_AMT_APP"]description];
        detailModel.ocjStr_PROC_DATE = [[dic objectForKey:@"PROC_DATE"]description];
        detailModel.ocjStr_CNT = [[dic objectForKey:@"CNT"]description];
        detailModel.ocjStr_PAGE = [[dic objectForKey:@"PAGE"]description];
        detailModel.ocjStr_STATUS = [[dic objectForKey:@"STATUS"]description];
        detailModel.ocjStr_REFUND_YN = [[dic objectForKey:@"REFUND_YN"]description];
        detailModel.ocjStr_TOTAL_CNT = [[dic objectForKey:@"TOTAL_CNT"]description];
        detailModel.ocjStr_sub = [[dic objectForKey:@"sub"] description];


        
        [mArray addObject:detailModel];
    }
    
    return [mArray copy];
}
@end
