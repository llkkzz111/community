//
//  OCJVerifyTitleTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OCJChangeVerifyBlock)();

/**
 切换登录方式cell
 */
@interface OCJVerifyTitleTVCell : UITableViewCell

@property (nonatomic, strong) UIButton *ocjBtn_title;     ///<标题文字
@property (nonatomic,copy) OCJChangeVerifyBlock ocjChangeVerifyBlock;

@end
