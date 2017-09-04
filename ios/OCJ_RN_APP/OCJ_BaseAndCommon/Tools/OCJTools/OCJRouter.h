//
//  OCJRouter.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/25.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,OCJRouterOpenType) {
    OCJRouterOpenTypePresent, ///< model打开模式
    OCJRouterOpenTypePush   ///< navigation打开模式
};

@interface OCJRouter : NSObject

/**
 单例

 @return 对象
 */
+ (instancetype)ocj_shareRouter;

/**
 router跳转

 @param type 跳转方法
 @param routerKey 页面对应router标签
 @param parmaters 将跳转页面所需参数集
 */
- (UIViewController*)ocj_openVCWithType:(OCJRouterOpenType)type
                 routerKey:(NSString*)routerKey
                 parmaters:(NSDictionary*)parmaters;


@end
