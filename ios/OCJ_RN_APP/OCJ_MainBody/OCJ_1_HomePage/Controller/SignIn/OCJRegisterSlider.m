//
//  OCJRegisterSlider.m
//  OCJ
//
//  Created by 董克楠 on 9/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRegisterSlider.h"

@implementation OCJRegisterSlider

/*
    重写此方法才可改变滑动条的高度
*/
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end
