//
//  RN_OCJ_WebViewVC.h
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/30.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJBaseVC.h"




/**
 RN 调起H5使用的备用webView（现在在使用 OCJ_RN_WebViewVC）
 */
@interface RN_OCJ_WebViewVC : OCJBaseVC

@property (nonatomic,strong) NSDictionary      * ocjDic_router; ///< 路由传值字典

@end
