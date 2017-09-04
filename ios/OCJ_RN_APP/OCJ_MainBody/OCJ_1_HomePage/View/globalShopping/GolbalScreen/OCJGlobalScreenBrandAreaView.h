//
//  OCJGlobalScreenBrandAreaView.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJGlobalScreenModel.h"

typedef NS_ENUM(NSUInteger, OCJGlobalScreenBrandAreaViewType){
  OCJGlobalScreenBrandAreaViewTypeBrand = 0, ///< 品牌
  OCJGlobalScreenBrandAreaViewTypeHotArea  ///< 热门地区
};

@protocol OCJGlobalScreenBrandAreaViewDelegate <NSObject>

- (void)ocj_golbalScreenBrandAreaSelectedArray:(NSArray*)selectedArray type:(OCJGlobalScreenBrandAreaViewType)type;

@end

@interface OCJGlobalScreenBrandAreaView : UIView

@property (nonatomic, copy) void(^backSelResigon)(NSArray *resigons);

@property (nonatomic,assign) NSInteger   intTab_type; //0：地区 1：字母排序

@property (nonatomic ,weak) id<OCJGlobalScreenBrandAreaViewDelegate> delegate;


/**
 初始化筛选视图

 @param type 类型
 @param originalArray 原始数据
 @param selectedarray 选择的内容
 */
- (void)ocj_initType:(OCJGlobalScreenBrandAreaViewType)type originalArray:(NSArray *)originalArray SelectedArrar:(NSArray *)selectedArray;

/**
 加载完成后，从右侧推出动画
 */
- (void)ocj_showChooseView;

@end
