//
//  OCJBaseNC.h
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OCJJumpRNBlock) (NSDictionary *dic);///< 与RN之间的交互回调

/**
 导航控制器基类
 */
@interface OCJBaseNC : UINavigationController


@property (nonatomic,copy)   OCJJumpRNBlock ocjCallback; ///< 回调属性

@end
