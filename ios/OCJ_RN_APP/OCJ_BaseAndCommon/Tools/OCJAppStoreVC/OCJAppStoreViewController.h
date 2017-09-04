//
//  OCJAppStoreViewController.h
//  OCJ_RN_APP
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJBaseVC.h"

FOUNDATION_EXPORT NSString * const ThreeStartTimesKey;
FOUNDATION_EXPORT NSString * const OpenAppstoreKey;
FOUNDATION_EXPORT NSString * const IgnoreTimesKey;


@interface OCJAppStoreViewController : OCJBaseVC

+ (void)startCheckAppStore;

@end
