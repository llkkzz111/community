//
//  OCJPayWebVC.h
//  OCJ
//
//  Created by wb_yangyang on 2017/6/1.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

typedef void(^OCJWebPayCallback) ();

@interface OCJPayWebVC : OCJBaseVC

@property (nonatomic,copy) NSString* ocjStr_payID;///< 支付编号

@property (nonatomic,copy) NSString* ocjStr_url;  ///< 支付链接

@property (nonatomic,copy) NSDictionary* ocjDic_requestBody;  ///< 请求体

@property (nonatomic,copy) NSString* ocjStr_returnUrl;  ///< 支付回调页

@property (nonatomic,strong) OCJWebPayCallback ocjBlock_paySuccessCallback; ///< 拦截回调页后返回app

@end
