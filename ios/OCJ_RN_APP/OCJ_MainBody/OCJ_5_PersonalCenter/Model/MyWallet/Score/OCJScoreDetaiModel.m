//
//  OCJScoreDetaiModel.m
//  OCJ
//
//  Created by OCJ on 2017/5/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJScoreDetaiModel.h"

@implementation OCJScoreDetaiModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"saveAmtGetDate"]) {
        self.ocjStr_saveAmtGetDate = [value description];
    }else if([key isEqualToString:@"sub"]){
        self.ocjStr_sub = [value description];
    }else if([key isEqualToString:@"saveAmtType"]){
        self.ocjStr_saveAmtType = [value description];

    }else if([key isEqualToString:@"TOTALCNT"]){
        self.ocjStr_TOTALCNT = [value description];

    }else if([key isEqualToString:@"saveAmtName"]){
        self.ocjStr_saveAmtName = [value description];

    }else if([key isEqualToString:@"saveAmt"]){
        self.ocjStr_saveAmt = [value description];

    }else if([key isEqualToString:@"saveAmtExpireDate"]){
        self.ocjStr_saveAmtExpireDate = [value description];
    }
}

@end
