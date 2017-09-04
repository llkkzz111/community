//
//  OCJPreBarginModel.h
//  OCJ
//
//  Created by OCJ on 2017/5/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 预付款Model
 */
@interface OCJPreBarginModel : NSObject

@property (nonatomic,copy) NSString * ocjStr_deposit_note;
@property (nonatomic,copy) NSString * ocjStr_depositamt;
@property (nonatomic,copy) NSString * ocjStr_proc_date;
@property (nonatomic,copy) NSString * ocjStr_depositamt_gb;
@property (nonatomic,copy) NSString * ocjStr_totalcnt;
@property (nonatomic,copy) NSString * ocjStr_sub;
@property (nonatomic,copy) NSString * ocjStr_order_no;


@end
