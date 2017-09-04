//
//  UIViewController+WSHHExtension.h
//  OCJ
//
//  Created by OCJ on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIEdgeInsets(^OCJEdge)(NSIndexPath *indexPath);

@interface UIViewController (WSHHExtension)

@property (nonatomic, copy) OCJEdge ocjEdge;

@end
