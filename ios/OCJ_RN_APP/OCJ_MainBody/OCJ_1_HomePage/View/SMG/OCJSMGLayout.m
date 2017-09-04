//
//  OCJSMGLayout.m
//  OCJ
//
//  Created by OCJ on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSMGLayout.h"

@implementation OCJSMGLayout
-(id)init{
    self = [super init];
    if (self) {
        
        self.scrollDirection    = UICollectionViewScrollDirectionHorizontal;
        
        CGFloat itemWidth = 250; //item宽度
        CGFloat extendWidth = 25; //item漏出的宽度
        self.itemSize = CGSizeMake(itemWidth , SCREEN_HEIGHT);
        
        CGFloat minimumLineSpacing = (SCREEN_WIDTH - itemWidth - extendWidth*2)/2.0;
        self.minimumLineSpacing = minimumLineSpacing;
        
        CGFloat maginSapcing = SCREEN_WIDTH - minimumLineSpacing -itemWidth - extendWidth;
        self.sectionInset = UIEdgeInsetsMake(0,maginSapcing,0,maginSapcing);
    }
    return self;
}

@end
