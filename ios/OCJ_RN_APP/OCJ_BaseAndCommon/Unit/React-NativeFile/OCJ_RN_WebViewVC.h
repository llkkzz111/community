//
//  OCJ_RN_WebViewVC.h
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJBaseVC.h"

/**
 RN 调起H5使用的webView
 */
@interface OCJ_RN_WebViewVC : OCJBaseVC

@property (nonatomic,strong) NSDictionary      * ocjDic_router; ///< 路由传值字典


/**
 为UIWebView的request设置自定义User-Agent
 */
+(void)ocj_setUserAgentForApp;
@end
