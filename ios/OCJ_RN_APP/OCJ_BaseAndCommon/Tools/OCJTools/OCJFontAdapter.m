//
//  OCJFontAdapter.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/15.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJFontAdapter.h"

@implementation OCJFontAdapter

+(UIFont *)ocj_adapteFont:(UIFont *)font{
    UIFont* newFont;
    
    if (OCJ_FONT_SETTING_TYPE == 2) {//如果用户选择大号字体
        newFont = [UIFont systemFontOfSize:font.pointSize+2];
    }else{
        newFont = font;
    }

    return newFont;
}

+ (NSInteger)ocj_getFontStatues{
    
    return OCJ_FONT_SETTING_TYPE;
}

@end
