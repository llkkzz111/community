//
//  OCJScanJumpWebVC.h
//  OCJ
//
//  Created by Ray on 2017/6/2.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

typedef NS_ENUM(NSInteger, OCJEnumWebViewLodingType) {
  OCJEnumWebViewLodingTypeQRCode = 0,     ///<二维码扫描结果
  OCJEnumWebViewLodingTypeHtmlUrl          ///<html5页面
};

@interface OCJScanJumpWebVC : OCJBaseVC

@property (nonatomic, strong) NSString *ocjStr_qrcode;
@property (nonatomic, strong) NSString *ocjStr_title;
@property (nonatomic) OCJEnumWebViewLodingType ocjEnumWebViewType;

@end
