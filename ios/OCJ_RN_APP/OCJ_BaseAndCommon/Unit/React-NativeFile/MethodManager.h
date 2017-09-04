//
//  MethodManager
//  AwesomeProject
//
//  Created by daihaiyao on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTLog.h>


@interface MethodManager : NSObject <RCTBridgeModule>


/**
 单例对象方法

 */
//+(instancetype)ocj_shareMethodManager;


-(void)VCOpenRN:(NSDictionary *)dictionary;

/**
 注册通知监听
 */
- (void)ocj_addObserver;

@end
