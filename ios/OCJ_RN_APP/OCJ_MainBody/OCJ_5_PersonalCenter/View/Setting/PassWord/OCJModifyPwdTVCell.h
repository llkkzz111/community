//
//  OCJModifyPwdTVCell.h
//  OCJ
//
//  Created by Ray on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 修改密码cell
 */
@interface OCJModifyPwdTVCell : UITableViewCell

@property (nonatomic, strong) OCJBaseTextField *ocjTF_input;///<输入框
@property (nonatomic,assign) BOOL           ocjBool_showPwd;

@end
