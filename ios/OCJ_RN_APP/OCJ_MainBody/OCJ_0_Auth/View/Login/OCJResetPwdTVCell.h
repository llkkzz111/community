//
//  OCJResetPwdTVCell.h
//  OCJ
//
//  Created by zhangchengcai on 2017/4/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OCJTextChangedBlock)(OCJBaseTextField *);


@interface OCJResetPwdTVCell : UITableViewCell

@property (nonatomic,strong) OCJBaseTextField  * ocjTF_pwd;   ///< 密码
@property (nonatomic,strong) OCJBaseButton     * ocjBtn_show; ///< 控制密码是否明文现实按钮
@property (nonatomic,strong) UIView       * ocjView_line; ///< 底部分割线
@property (nonatomic,assign) BOOL         ocjBool_showPwd;
@property (nonatomic,strong) UIImageView  * ocjImg_bg;
@property (nonatomic,copy)   OCJTextChangedBlock ocj_textChangeBlock;


@end
