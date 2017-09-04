//
//  OCJBaseButton.m
//  OCJ
//
//  Created by zhangchengcai on 2017/4/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseButton.h"
#import "OCJFontAdapter.h"

@implementation OCJBaseButton


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleLabel.font = [OCJFontAdapter ocj_adapteFont:self.titleLabel.font];
}


-(void)setOcjFont:(UIFont *)ocjFont{
    self.titleLabel.font = [OCJFontAdapter ocj_adapteFont:ocjFont];
}

-(UIFont *)ocjFont{
    
    return self.titleLabel.font;
}

@end
