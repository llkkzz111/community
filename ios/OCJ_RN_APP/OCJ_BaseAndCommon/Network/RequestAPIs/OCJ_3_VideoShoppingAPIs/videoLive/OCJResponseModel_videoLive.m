//
//  OCJResponseModel_videoLive.m
//  OCJ
//
//  Created by Ray on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJResponseModel_videoLive.h"

@implementation OCJResponseModel_videoLive

@end

@implementation OCJResponceModel_VideoLive

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"codeValue"]) {
            self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"id"]) {
            self.ocjStr_id = [value description];
        }else if ([key isEqualToString:@"pageVersionId"]) {
            self.ocjStr_pageVersionId = [value description];
        }else if ([key isEqualToString:@"packageList"] && [value isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in value) {
                OCJResponceModel_VideoDetailList *model = [[OCJResponceModel_VideoDetailList alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_detailList addObject:model];
            }
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

- (NSMutableArray *)ocjArr_detailList {
    if (!_ocjArr_detailList) {
        _ocjArr_detailList = [[NSMutableArray alloc] init];
    }
    return _ocjArr_detailList;
}

@end

@implementation OCJResponceModel_VideoDetailList

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"packageId"]) {
            self.ocjStr_packageid = [value description];
        }else if ([key isEqualToString:@"id"]) {
            self.ocjStr_id = [value description];
        }else if ([key isEqualToString:@"codeValue"]) {
            self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"isPackages"]) {
            self.ocjStr_isPackages = [value description];
        }else if ([key isEqualToString:@"shortNumber"]) {
            self.ocjStr_shortNum = [value description];
        }else if ([key isEqualToString:@"componentList"] && [value isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in value) {
                OCJResponceModel_VideoDetailDesc *model = [[OCJResponceModel_VideoDetailDesc alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_listDesc addObject:model];
            }
            
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

- (NSMutableArray *)ocjArr_listDesc {
    if (!_ocjArr_listDesc) {
        _ocjArr_listDesc = [[NSMutableArray alloc] init];
    }
    return _ocjArr_listDesc;
}

@end

@implementation OCJResponceModel_VideoDetailDesc

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"id"]) {
            self.ocjStr_id = [value description];
        }else if ([key isEqualToString:@"title"]) {
            self.ocjStr_title = [value description];
        }else if ([key isEqualToString:@"subTitle"]) {
            self.ocjStr_subTitle = [value description];
        }else if ([key isEqualToString:@"codeId"]) {
            self.ocjStr_codeId = [value description];
        }else if ([key isEqualToString:@"videoPlayBackUrl"]) {
            self.ocjStr_videoUrl = [value description];
        }else if ([key isEqualToString:@"contentCode"]) {
            self.ocjStr_contentCode = [value description];
        }else if ([key isEqualToString:@"firstImgUrl"]) {
            self.ocjStr_firstImgUrl = [value description];
        }else if ([key isEqualToString:@"secondImgUrl"]) {
            self.ocjStr_secondImgUrl = [value description];
        }else if ([key isEqualToString:@"thirdImgUrl"]) {
            self.ocjStr_thirdImgUrl = [value description];
        }else if ([key isEqualToString:@"shortNumber"]) {
            self.ocjStr_shortNum = [value description];
        }else if ([key isEqualToString:@"componentId"]) {
            self.ocjStr_componentId = [value description];
        }else if ([key isEqualToString:@"isComponents"]) {
            self.ocjStr_isCompontents = [value description];
        }else if ([key isEqualToString:@"watchNumber"]) {
            self.ocjStr_watchNum = [value description];
        }else if ([key isEqualToString:@"codeValue"]) {
            self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"author"]) {
            self.ocjStr_author = [value description];
        }else if ([key isEqualToString:@"videoDate"]) {
            self.ocjStr_videoDate = [value description];
        }else if ([key isEqualToString:@"gifts"] && [value isKindOfClass:[NSArray class]]) {
            self.ocjArr_gifts = value;
        }else if ([key isEqualToString:@"originalPrice"]) {
            self.ocjStr_marketPrice = [value description];
        }else if ([key isEqualToString:@"salePrice"]) {
            self.ocjStr_salePrice = [value description];
        }else if ([key isEqualToString:@"integral"]) {
            self.ocjStr_integral = [value description];
        }else if ([key isEqualToString:@"salesVolume"]) {
            self.ocjStr_salesNum = [value description];
        }else if ([key isEqualToString:@"description"]) {
            self.ocjStr_description = [value description];
        }else if ([key isEqualToString:@"labelName"] && [value isKindOfClass:[NSArray class]]) {
            self.ocjArr_labelName = value;
        }else if ([key isEqualToString:@"discount"]) {
            self.ocjStr_discount = [value description];
        }else if ([key isEqualToString:@"groupBuyTime"]) {
            self.ocjStr_groupBuyTime = [value description];
        }else if ([key isEqualToString:@"groupBuyType"]) {
            self.ocjStr_groupBuyType = [value description];
        }else if ([key isEqualToString:@"remainingTime"]) {
            self.ocjStr_remianTime = [value description];
        }else if ([key isEqualToString:@"inStock"]) {
            self.ocjStr_inStock = [value description];
        }else if ([key isEqualToString:@"curruntDateLong"]) {
            self.ocjStr_currentTime = [value description];
        }else if ([key isEqualToString:@"playDateLong"]) {
            self.ocjStr_playTime = [value description];
        }else if ([key isEqualToString:@"componentList"] && [value isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in value) {
                OCJResponceModel_VideoDetailDesc *model = [[OCJResponceModel_VideoDetailDesc alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_detailDesc addObject:model];
            }
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }else if ([key isEqualToString:@"videoStatus"]) {
          self.ocjStr_videoStatus = [value description];
        }
    }
}

- (NSMutableArray *)ocjArr_detailDesc {
    if (!_ocjArr_detailDesc) {
        _ocjArr_detailDesc = [[NSMutableArray alloc] init];
    }
    return _ocjArr_detailDesc;
}

@end

@implementation OCJResponceModel_MoreVideo

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"nextPage"]) {
            self.ocjStr_nextPage = [value description];
        }else if ([key isEqualToString:@"isFirstPage"]) {
            self.ocjStr_isFirstPage = [value description];
        }else if ([key isEqualToString:@"isLastPage"]) {
            self.ocjStr_isLastPage = [value description];
        }else if ([key isEqualToString:@"hasNextPage"]) {
            self.ocjStr_hasNextPage = [value description];
        }else if ([key isEqualToString:@"list"] && [value isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in value) {
                OCJResponceModel_VideoDetailDesc *model = [[OCJResponceModel_VideoDetailDesc alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_list addObject:model];
            }
            
        }else if ([key isEqualToString:@"codeValue"]) {
          self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

- (NSMutableArray *)ocjArr_list {
    if (!_ocjArr_list) {
        _ocjArr_list = [[NSMutableArray alloc] init];
    }
    return _ocjArr_list;
}

@end

@implementation OCJResponceModel_Spec

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"colorsize"] && [value isKindOfClass:[NSDictionary class]]){
            
            self.ocjModel_goodsSpec = [[OCJResponceModel_GoodsSpec alloc] init];
            [self.ocjModel_goodsSpec setValuesForKeysWithDictionary:value];
        }else if ([key isEqualToString:@"goodsDetail"] && [value isKindOfClass:[NSDictionary class]]) {
            
            self.ocjDic_goodsDetail = value;
        }else if ([key isEqualToString:@"tv_num_controll"]) {
            self.ocjStr_tvNumControll = [value description];
        }else if ([key isEqualToString:@"num_controll"]) {
            self.ocjStr_numControll = [value description];
        }else if ([key isEqualToString:@"codeValue"]) {
          self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

@end

@implementation OCJResponceModel_GoodsSpec

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"sizes"] && [value isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in value) {
                OCJResponceModel_specDetail *model = [[OCJResponceModel_specDetail alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_size addObject:model];
            }
        }else if ([key isEqualToString:@"colors"]) {
            
            for (NSDictionary *dic in value) {
                OCJResponceModel_specDetail *model = [[OCJResponceModel_specDetail alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_color addObject:model];
            }
        }else if ([key isEqualToString:@"colorsizes"]) {
            
            for (NSDictionary *dic in value) {
                OCJResponceModel_specDetail *model = [[OCJResponceModel_specDetail alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_colorSize addObject:model];
            }
        }else if ([key isEqualToString:@"codeValue"]) {
          self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

- (NSMutableArray *)ocjArr_size {
    if (!_ocjArr_size) {
        _ocjArr_size = [[NSMutableArray alloc] init];
    }
    return _ocjArr_size;
}

- (NSMutableArray *)ocjArr_color {
    if (!_ocjArr_color) {
        _ocjArr_color = [[NSMutableArray alloc] init];
    }
    return _ocjArr_color;
}

- (NSMutableArray *)ocjArr_colorSize {
    if (!_ocjArr_colorSize) {
        _ocjArr_colorSize = [[NSMutableArray alloc] init];
    }
    return _ocjArr_colorSize;
}

@end

@implementation OCJResponceModel_specDetail

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"cs_off"]) {
            
            self.ocjStr_csoff = [value description];
        }else if ([key isEqualToString:@"cs_code"]) {
            
            self.ocjStr_cscode = [value description];
        }else if ([key isEqualToString:@"cs_img"]) {
            
            self.ocjStr_imgUrl = [value description];
        }else if ([key isEqualToString:@"hidden_wu"]) {
            
            self.ocjStr_hiddenWu = [value description];
        }else if ([key isEqualToString:@"is_show"]) {
            
            self.ocjStr_isShow = [value description];
        }else if ([key isEqualToString:@"cs_name"]) {
            
            self.ocjStr_name = [value description];
        }else if ([key isEqualToString:@"codeValue"]) {
          self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

@end

@implementation OCJResponceModel_giftList

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"zpMap"]) {
            
            for (NSDictionary *dic in value) {
                OCJResponceModel_giftDesc *model = [[OCJResponceModel_giftDesc alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.ocjArr_list addObject:model];
            }
        }else if ([key isEqualToString:@"codeValue"]) {
          self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

- (NSMutableArray *)ocjArr_list {
    if (!_ocjArr_list) {
        _ocjArr_list = [[NSMutableArray alloc] init];
    }
    return _ocjArr_list;
}

@end

@implementation OCJResponceModel_giftDesc

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]]) {
        if ([key isEqualToString:@"gift_img"]) {
            self.ocjStr_imgUrl = [value description];
        }else if ([key isEqualToString:@"gift_item_code"]) {
            self.ocjStr_itemCode = [value description];
        }else if ([key isEqualToString:@"qty"]) {
            self.ocjStr_quantity = [value description];
        }else if ([key isEqualToString:@"name"]) {
            self.ocjStr_name = [value description];
        }else if ([key isEqualToString:@"gift_gb"]) {
            self.ocjStr_giftGB = [value description];
        }else if ([key isEqualToString:@"gift_item_name"]) {
            self.ocjStr_itemName = [value description];
        }else if ([key isEqualToString:@"id"]) {
            self.ocjStr_id = [value description];
        }else if ([key isEqualToString:@"unit_code"]) {
            self.ocjStr_unitCode = [value description];
        }else if ([key isEqualToString:@"codeValue"]) {
          self.ocjStr_codeValue = [value description];
        }else if ([key isEqualToString:@"pageVersionName"]) {
          self.ocjStr_pageVersionName = [value description];
        }
    }
}

@end
