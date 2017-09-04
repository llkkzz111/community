//
//  OCJSettingConmonCell.h
//  OCJ
//
//  Created by Ray on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 设置中心通用cell
 */
@interface OCJSettingConmonCell : UITableViewCell

@property (nonatomic, strong) UIView *ocjView_line;
@property (nonatomic, strong) OCJBaseLabel *ocjLab_title;///<title

- (void)ocj_setTitle:(NSString *)ocjStr_title;

@end
