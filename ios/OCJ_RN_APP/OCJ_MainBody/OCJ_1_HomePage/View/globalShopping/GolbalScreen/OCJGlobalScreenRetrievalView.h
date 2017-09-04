//
//  OCJGlobalScreenRetrievalView.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OCJGlobalScreenRetrievalViewDelegate <NSObject>

- (void)ocj_golbalScreenRetrievalSelectfinish:(NSDictionary *)dictionary;

@end


/**
 全球购列表热门地区、品牌选择视图
 */
@interface OCJGlobalScreenRetrievalView : UIView
@property (nonatomic ,weak) id<OCJGlobalScreenRetrievalViewDelegate> delegate;

- (void)ocj_setChooseArray:(NSArray *)array
          SelectDictionary:(NSDictionary *)dictionary;

/**
 加载完成后，从右侧推出动画
 */
- (void)ocj_showChooseView;

@end
