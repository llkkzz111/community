//
//  OCJPayViewLayout.m
//  OCJ
//
//  Created by OCJ on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJPayViewLayout.h"


@implementation OCJPayViewLayout

-(id)init{
    self = [super init];
    if (self) {
    
        self.scrollDirection    = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 5;
        self.minimumInteritemSpacing = 0;
        self.sectionInset       = UIEdgeInsetsMake(0,20,0,20);
    }
    return self;
}




@end
