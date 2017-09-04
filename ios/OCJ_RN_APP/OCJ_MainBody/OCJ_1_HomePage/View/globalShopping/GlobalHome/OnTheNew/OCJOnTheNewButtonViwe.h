//
//  OCJOnTheNewButtonViwe.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_GlobalShopping.h"

@protocol OOCJOnTheNewButtonViweDelegate <NSObject>

- (void)ocj_onTheNewButtonPressed:(NSInteger)tag;

@end


@interface OCJOnTheNewButtonViwe : UIView
@property (nonatomic ,weak) id<OOCJOnTheNewButtonViweDelegate> delegate;
@property (nonatomic,assign) NSInteger      ocjInt_btnViewTag;

- (void)ocj_setViewDataWith:(OCJGSModel_Package14 *)model;

@end
