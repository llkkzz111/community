//
//  OJCSuperValueButtonView.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_GlobalShopping.h"

@protocol OJCSuperValueButtonViewDelegate <NSObject>

- (void)ocj_onSuperValueButtonPressedWithGoodInfoModel:(OCJGSModel_Package44 *)model;

@end

@interface OJCSuperValueButtonView : UIView
@property (nonatomic ,weak) id<OJCSuperValueButtonViewDelegate> delegate;

@property (nonatomic ,strong) OCJGSModel_Package44* ocjModel_goodInfo;


@end
