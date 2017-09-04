//
//  OCJRecommandModel.h
//  OCJ
//
//  Created by OCJ on 2017/6/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCJRecommandModel : NSObject

@property (nonatomic,strong) NSString * ocjStr_price; ///< 价格
@property (nonatomic,strong) NSString * ocjStr_custPrice; ///<
@property (nonatomic,strong) NSString * ocjStr_volume;  ///< 折扣
@property (nonatomic,strong) NSString * ocjStr_itemCode;  ///< 商品ID
@property (nonatomic,strong) NSString * ocjStr_url;  ///<
@property (nonatomic,strong) NSString * ocjStr_itemName;  ///< 商品名称
@property (nonatomic,strong) NSString * ocjStr_dc;  ///< 积分

@end
