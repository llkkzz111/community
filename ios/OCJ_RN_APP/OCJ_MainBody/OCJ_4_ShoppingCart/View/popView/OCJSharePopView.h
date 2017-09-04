//
//  OCJSharePopView.h
//  OCJ
//
//  Created by Ray on 2017/6/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APOpenAPI.h"

/**
 分享popView
 */
@interface OCJSharePopView : UIView<APOpenAPIDelegate>


/**
 单例对象

 */
+ (instancetype)sharedInstance;


/**
 调出分享popView

 @param shareDic @{@"title":@"标题",@"text":@"文本内容",@"image":@"预览图",@"url":@"跳转链接"}
 */
- (void)ocj_setShareContent:(NSDictionary *)shareDic;

@end
