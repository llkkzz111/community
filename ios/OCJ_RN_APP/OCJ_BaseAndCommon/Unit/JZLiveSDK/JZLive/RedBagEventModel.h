//
//  RedBagEventModel.h
//  东方购物new
//
//  Created by oms-youmecool on 2017/6/15.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedBagEventModel : NSObject

@property (nonatomic,copy) NSString * code;
@property (nonatomic,copy) NSString * end_batch_flag;
@property (nonatomic,copy) NSString * batch_no;
@property (nonatomic,copy) NSString * second;

+(RedBagEventModel *)parseWithDictionary:(NSDictionary*)dictionary;

@end
