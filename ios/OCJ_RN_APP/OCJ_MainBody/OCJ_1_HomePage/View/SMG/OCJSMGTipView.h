//
//  OCJSMGTipView.h
//  OCJ
//
//  Created by OCJ on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OCJPopViewHandler) (NSDictionary* dic_address);///< 地址数据回调block

@interface OCJSMGTipView : UIView

+ (void)ocj_popWithRules:(NSString *)rules Completion:(OCJPopViewHandler)handler;

+ (void)ocj_popRewardWithMessage:(NSString *)message srartDate:(NSString *)startDate endDate:(NSString *)endDate Completion:(OCJPopViewHandler)handler;

@end
