//
//  OCJNetWorkCenter.h
//  OCJ
//
//  Created by yangyang on 2017/4/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJBaseResponceModel.h"

typedef void(^OCJHttpResponseHander) (OCJBaseResponceModel* responseModel);///< 回调block

typedef NS_ENUM(NSInteger, OCJHttpLoadingType) {
    OCJHttpLoadingTypeNone = 1, ///< 无loading
    OCJHttpLoadingTypeBegin,    ///< 请求开始时启动loading，一定时间后loading自动关闭（默认 2s）
    OCJHttpLoadingTypeBeginAndEnd   ///< 请求开始时启动loading,请求收到响应后关闭loading
};

@interface OCJNetWorkCenter : NSObject

/**
 网络中心（单例模式）

 @return 网络中心对象
 */
+ (instancetype)sharedCenter;


/**
 HTTP POST

 @param urlPath     子域名路径
 @param parameters  参数
 @param handler     回调block
 */
-(void)ocj_POSTWithUrlPath:(NSString *)urlPath
                parameters:(NSDictionary *)parameters
             andLodingType:(OCJHttpLoadingType)loadingType
         completionHandler:(OCJHttpResponseHander)handler;


/**
 HTTP GET

 @param urlPath     子域名路径
 @param parameters  参数
 @param handler     回调block
 */
-(void)ocj_GETWithUrlPath:(NSString *)urlPath
               parameters:(NSDictionary *)parameters
            andLodingType:(OCJHttpLoadingType)loadingType
        completionHandler:(OCJHttpResponseHander)handler;




/**
 formData 上传文件

 @param urlPath 子域名路径
 @param files 图片
 @param loadingType loading类型
 @param handler 回调block
 */
-(void)ocj_fromData_POSTWithUrlPath:(NSString *)urlPath
                          prameters:(NSDictionary*)parmeters
                              files:(NSArray<NSDictionary*> *)files
                      andLodingType:(OCJHttpLoadingType)loadingType
                  completionHandler:(OCJHttpResponseHander)handler;

@end
