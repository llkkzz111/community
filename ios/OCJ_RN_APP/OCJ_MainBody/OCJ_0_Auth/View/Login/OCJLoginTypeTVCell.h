//
//  OCJLoginTypeTVCell.h
//  OCJ
//
//  Created by OCJ on 2017/4/25.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJBaseButton+OCJExtension.h"
#import "OCJValidationBtn.h"

@interface OCJLoginTypeTVCell : UITableViewCell

@property (nonatomic,strong) OCJBaseTextField * ocjTF_input; ///< 邮箱
@property (nonatomic,strong) UIView * ocjView_line;     ///< 底部分割线

@end


@interface OCJLoginTypeSendCodeTVCell : UITableViewCell

@property (nonatomic,strong) UIView      * ocjView_line;            ///< 底部分割线
@property (nonatomic,strong) OCJBaseTextField * ocjTF_input;             ///< 输入框
@property (nonatomic,strong) OCJBaseTextField * ocjTF_evaluteCode;       ///< 验证码输入框
@property (nonatomic,strong) OCJValidationBtn    * ocjBtn_sendCode; ///< 发送验证码接口

@end


@interface OCJLoginTypeSendPwdTVCell : UITableViewCell

@property (nonatomic,strong) OCJBaseButton     * ocjBtn_show;    ///< 控制密码是否明文现实按钮
@property (nonatomic,strong) OCJBaseTextField  * ocjTF_pwd;      ///< 密码
@property (nonatomic,strong) UIView       * ocjView_line;   ///< 底部分割线
@property (nonatomic,assign) BOOL         ocjBool_showPwd;  ///< 是否明文显示显示密码
@property (nonatomic,strong) UIImageView * ocjImg_bg;       ///< 背景
@property (nonatomic,strong) OCJBaseButton    * ocjBtn_forgetPwd;///< 忘记密码

@end

@interface OCJLoginTypePwdTVCell : UITableViewCell

@property (nonatomic,strong) OCJBaseButton     * ocjBtn_show;    ///< 控制密码是否明文现实按钮
@property (nonatomic,strong) OCJBaseTextField  * ocjTF_pwd;      ///< 密码
@property (nonatomic,strong) UIView       * ocjView_line;   ///< 底部分割线
@property (nonatomic,assign) BOOL         ocjBool_showPwd;  ///< 是否明文显示密码
@property (nonatomic,strong) UIImageView * ocjImg_bg;       ///< 背景

@end
