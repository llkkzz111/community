//
//  OCJOnlinePayVC.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"


typedef void(^OCJOnlinePayBlock) (NSDictionary *dic);///< 支付成功回调页面

@interface OCJOnlinePayVC : OCJBaseVC

@property (nonatomic,strong) NSDictionary      * ocjDic_router; ///< 路由传值字典

@property (nonatomic,copy)   OCJOnlinePayBlock ocjCallback;

@end
