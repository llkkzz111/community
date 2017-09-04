//
//  OCJFontView.h
//  OCJ
//
//  Created by OCJ on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OCJFontState) {
    OCJFontState_Normal = 0, ///< 标准
    OCJFontState_Double = 1  ///< 放大模式
};
typedef void(^OCJFontSelectedHandler) (OCJFontState  fontState);///< 地址数据回调block


/**
 自定义字体大小View
 */
@interface OCJFontView : UIView

@property (nonatomic,assign) OCJFontState ocjState_font;
@property (nonatomic,copy) OCJFontSelectedHandler ocjFontHandler;

@end
