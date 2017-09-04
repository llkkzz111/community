//
//  OCJHttp_videoLiveAPI.m
//  OCJ
//
//  Created by Ray on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJHttp_videoLiveAPI.h"
#import "OCJResponseModel_videoLive.h"

NSString *const OCJURLPath_GetVideoDetail = @"/cms/pages/relation/pageV1";    ///<获取正在直播数据接口
NSString *const OCJURLPath_GetMoreVideo = @"/cms/pages/relation/nextPageV1";  ///<查看更多视频分页接口
NSString *const OCJURLPath_GetGoodsDetail = @"/api/items/items/appdetail";  ///<商品详情查询接口
NSString *const OCJURLPath_AddToCart = @"/api/orders/carts/detailItemToCart";///<加入购物车接口
NSString *const OCJURLPath_GetGiftList = @"/api/events/activitys/get_item_events";///<获取赠品列表接口
NSString *const OCJURLPath_GetCartNum = @"/api/orders/carts/getCartsCount";  ///<查询购物车数量接口

@implementation OCJHttp_videoLiveAPI

+ (void)OCJVideoLive_getVideoLiveDetailWithID:(NSString *)Id contentCode:(NSString *)contentCode completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic =[NSMutableDictionary dictionary];
    [mDic setValue:Id forKey:@"id"];
    [mDic setValue:contentCode forKey:@"contentCode"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GetVideoDetail parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJResponceModel_VideoLive *model = [[OCJResponceModel_VideoLive alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        
        handler(model);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)OCJVideoLive_getMoreVideoWithID:(NSString *)Id pageNum:(NSInteger)pageNum pageSize:(NSString *)pageSize completionhandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:Id forKey:@"id"];
    [mDic setValue:@(pageNum) forKey:@"pageNum"];
    [mDic setValue:pageSize forKey:@"pageSize"];
    
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:OCJURLPath_GetMoreVideo parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJResponceModel_MoreVideo *model = [[OCJResponceModel_MoreVideo alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        
        handler(model);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)OCJVideoLive_getGoodsDetailWithItemCode:(NSString *)item_code orderno:(NSString *)orderno dmnid:(NSString *)dmnid isPufa:(NSString *)isPufa isBone:(NSString *)isBone mediaChannel:(NSString *)media_channel sourceUrl:(NSString *)source_obj completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
//    [mDic setValue:item_code forKey:@"item_code"];
    [mDic setValue:media_channel forKey:@"media_channel"];
    [mDic setValue:source_obj forKey:@"source_obj"];
    [mDic setValue:orderno forKey:@"orderno"];
    [mDic setValue:dmnid forKey:@"dmnid"];
    [mDic setValue:isPufa forKey:@"isPufa"];
    [mDic setValue:isBone forKey:@"isBone"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@", OCJURLPath_GetGoodsDetail, item_code];
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:urlStr parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        [[NSUserDefaults standardUserDefaults] setValue:@"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0IiwiaXNzIjoib2NqLXN0YXJza3kiLCJleHAiOjE0OTcwODE1OTQsImlhdCI6MTQ5NDQ4OTU5NH0.-DExP3VwlR4f1uS9Ok6eHqalrVHRoBCTWt910m8r_Lw" forKey:@"OCJAccessToken"];
        OCJResponceModel_Spec *model = [[OCJResponceModel_Spec alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)OCJVideoLive_addToCartWithItemCode:(NSString *)item_code num:(NSString *)num unitCode:(NSString *)unit_code giftItemCode:(NSArray *)gift_item_codes giftUnitCode:(NSArray *)gift_unit_codes giftPromoNos:(NSArray *)gift_nos giftPromoSeqs:(NSArray *)giftPromo_seqs shopNo:(NSString *)Shop_no mediaChannel:(NSString *)media_channel sourceUrl:(NSString *)source_url completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:item_code forKey:@"item_code"];
    [mDic setValue:num forKey:@"qty"];
    [mDic setValue:unit_code forKey:@"unit_code"];
    [mDic setValue:gift_item_codes forKey:@"gift_item_code"];
    [mDic setValue:gift_unit_codes forKey:@"gift_unit_code"];
    [mDic setValue:gift_nos forKey:@"giftPromo_no"];
    [mDic setValue:giftPromo_seqs forKey:@"giftPromo_seq"];
    [mDic setValue:Shop_no forKey:@"Shop_no"];
    [mDic setValue:media_channel forKey:@"media_channel"];
    [mDic setValue:source_url forKey:@"source_url"];
  [mDic setValue:@"" forKey:@"area_lcode"];
  [mDic setValue:@"" forKey:@"area_mcode"];
  [mDic setValue:@"" forKey:@"area_scode"];
  
    [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_AddToCart parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        handler(responseModel);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)OCJVideoLive_getGiftListWithItemCode:(NSString *)item_code completionHandler:(OCJHttpResponseHander)handler {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    [mDic setValue:item_code forKey:@"item_code"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@", OCJURLPath_GetGiftList, item_code];
    [[OCJNetWorkCenter sharedCenter] ocj_GETWithUrlPath:urlStr parameters:[mDic copy] andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJResponceModel_giftList *model = [[OCJResponceModel_giftList alloc] initOCJSubResponceModelSetValuesWithBaseResponceModel:responseModel];
        handler(model);
        if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

+ (void)OCJVideoLive_getCartNumCompletionHandler:(OCJHttpResponseHander)handler {
  NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
  
  [[OCJNetWorkCenter sharedCenter] ocj_POSTWithUrlPath:OCJURLPath_GetCartNum parameters:mDic andLodingType:OCJHttpLoadingTypeBeginAndEnd completionHandler:^(OCJBaseResponceModel *responseModel) {
    
    handler(responseModel);
    if (![responseModel.ocjStr_code isEqualToString:@"200"]) {
      if (![responseModel.ocjStr_message containsString:@"查询购物车失败"]) {
        [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
      }
    }
  }];
}

@end
