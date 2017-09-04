//
//  OCJPersonalInfoCell.h
//  OCJ
//
//  Created by Ray on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 个人信息通用cell
 */
@interface OCJPersonalInfoCell : UITableViewCell

@property (nonatomic, strong) OCJBaseLabel *ocjLab_info;///<信息
@property (nonatomic, strong) UIView *ocjView_line;

- (void)ocj_setInformationWithTitle:(NSString *)title;

@end
