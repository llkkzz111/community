//
//  UITableView+OCJTableView.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(OCJTableView)

@property (nonatomic,strong) NSDictionary *ocjDic_NoData; ///< 无数据时的展示图片
@property (nonatomic,strong) NSString *ocjStr_tips;  ///<提示文字

@end
