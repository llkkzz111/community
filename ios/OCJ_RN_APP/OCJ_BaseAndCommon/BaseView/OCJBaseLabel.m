//
//  OCJBaseLabel.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/15.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseLabel.h"
#import "OCJFontAdapter.h"

@implementation OCJBaseLabel

- (void)awakeFromNib{
    [super awakeFromNib];
    
    super.font = [OCJFontAdapter ocj_adapteFont:self.font];
}

- (void)setFont:(UIFont *)font{
    [super setFont:[OCJFontAdapter ocj_adapteFont:font]];
    
}

@end
