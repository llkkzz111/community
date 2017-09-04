//
//  OCJScanVC.h
//  OCJ
//
//  Created by Ray on 2017/6/2.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

typedef void(^OCJScanCallback) (NSDictionary* dict);///< 回调block 返回类型{@"qrUrl":@"通过白名单的url"}

/**
 扫码
 */
@interface OCJScanVC : OCJBaseVC

@property (nonatomic, assign) BOOL isShowNav;///<是否显示系统导航栏

@property (nonatomic, strong) OCJScanCallback ocjCallback; ///< 扫描成功回调

@end
