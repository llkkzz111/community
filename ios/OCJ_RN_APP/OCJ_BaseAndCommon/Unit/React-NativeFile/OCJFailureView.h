//
//  OCJFailureView.h
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/7/3.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OCJFailureType) {
  OCJFailureTypeNetwork = 1, ///< 网络错误空白页面
};

@class OCJFailureView;
@protocol OCJFailureViewDelegate <NSObject>

-(void)ocj_failureView:(OCJFailureView*)failurlView andClickRefreshButton:(UIButton*)refreshButton;

@end

/**
 异常情况的空页面
 */
@interface OCJFailureView : UIView


/**
 初始化错误空白页面

 @param frame
 @param failureType 错误情况枚举
 @param block 回调
 @return
 */
-(instancetype)initWithFrame:(CGRect)frame imageType:(OCJFailureType)failureType delegate:(id<OCJFailureViewDelegate>)delegate;



@end
