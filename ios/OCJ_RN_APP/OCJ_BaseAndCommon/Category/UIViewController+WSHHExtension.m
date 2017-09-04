//
//  UIViewController+WSHHExtension.m
//  OCJ
//
//  Created by OCJ on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "UIViewController+WSHHExtension.h"
#import <objc/runtime.h>
const NSString *edgeName;

@implementation UIViewController (WSHHExtension)

- (void)setOcjEdge:(OCJEdge)ocjEdge{
    objc_setAssociatedObject(self, &edgeName, ocjEdge, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (OCJEdge)ocjEdge{
    return objc_getAssociatedObject(self, &edgeName);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIEdgeInsets edge ;
    if (self.ocjEdge) {
        edge = self.ocjEdge(indexPath);
    }else{
        return;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:edge];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:edge];
    }
}

@end
