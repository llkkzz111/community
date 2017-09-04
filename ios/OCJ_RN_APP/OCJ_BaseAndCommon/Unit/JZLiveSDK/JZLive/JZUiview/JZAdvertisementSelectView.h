//
//  JZAdvertisementSelectView.h
//  JZLiveDemo
//
//  Created by wangcliff on 2017/5/10.
//  Copyright © 2017年 jz. All rights reserved.
//  商品展示view

#import <UIKit/UIKit.h>
@protocol JZAdvertisementSelectViewDelegate <NSObject>
- (void)openAdvertisementWebView:(NSString *)urlString;
@end
@interface JZAdvertisementSelectView : UIView
@property (nonatomic, weak) id<JZAdvertisementSelectViewDelegate> delegate;
@property (nonatomic, strong) NSArray *goodsArray;//商品数据

@end
