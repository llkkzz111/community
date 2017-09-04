//
//  OCJTouchIDVerifyPopView.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OCJTouchIDVerifyHandler)(NSString *ocjStr_result);

@interface OCJTouchIDVerifyPopView : UIView

+ (void)ocj_popTouchIDVerifyViewHandler:(OCJTouchIDVerifyHandler)verifyHandler;

@end
