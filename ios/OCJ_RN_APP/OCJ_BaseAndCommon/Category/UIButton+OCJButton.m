//
//  UIButton+OCJButton.m
//  OCJ
//
//  Created by OCJ on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "UIButton+OCJButton.h"
#import "UIButton+WebCache.h"

@implementation UIButton (OCJButton)

- (void)ocj_setButtonWithURLString:(NSString *)urlStr forState:(UIControlState)state{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:state placeholderImage:nil];
}

- (void)ocj_setButtonWithURLString:(NSString *)urlStr forState:(UIControlState)state placeholderImage:(UIImage *)placeholder{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:state placeholderImage:placeholder];
}
@end
