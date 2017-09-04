//
//  OCJUpdateViewController.h
//  OCJ_RN_APP
//
//  Created by apple on 2017/7/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OCJUpdateType) {
  OCJUpdateTypeSoft,  ///< 软更新
  OCJUpdateTypeHard   ///< 硬更新
};

@interface OCJUpdateViewController : UIViewController

@property (nonatomic) OCJUpdateType ocjEnum_updateType; ///< 更新类型

@property (nonatomic, strong) NSArray *items; ///< 更新信息
@property (nonatomic, copy)   NSString *appstoreUrl; ///< 跳转链接


@end
