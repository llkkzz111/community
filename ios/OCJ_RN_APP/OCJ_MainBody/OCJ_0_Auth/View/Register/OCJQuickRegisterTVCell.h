//
//  OCJQuickRegisterTVCell.h
//  OCJ
//
//  Created by zhangchengcai on 2017/4/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJValidationBtn.h"


@interface OCJQuickRegisterTVCell : UITableViewCell

@property (nonatomic,strong) UIView      * ocjView_line;
@property (nonatomic,strong) OCJBaseTextField * ocjTF_mobile;       ///<手机号
@property (nonatomic,strong) OCJBaseTextField * ocjTF_evaluteCode;  ///<验证码
@property (nonatomic,strong) OCJValidationBtn    * ocjBtn_sendCode;
@property (nonatomic,assign) BOOL ocjBOOL_show;

@end

@interface OCJCodeTVCell : UITableViewCell

@property (nonatomic,strong) UIView      * ocjView_line;
@property (nonatomic,strong) OCJBaseTextField * ocjTF_mobile;
@property (nonatomic,strong) OCJBaseTextField * ocjTF_evaluteCode;
@property (nonatomic,strong) OCJValidationBtn    * ocjBtn_sendCode;

@end


@interface OCJLQuickRegisteBottomTVCell : UITableViewCell

@property (nonatomic,strong) OCJBaseButton     * ocjBtn_show; ///< 控制密码是否明文现实按钮
@property (nonatomic,strong) OCJBaseTextField  * ocjTF_pwd;   ///< 密码
@property (nonatomic,strong) UIView       * ocjView_line; ///< 底部分割线
@property (nonatomic,assign) BOOL           ocjBool_showPwd;
@property (nonatomic,strong) UIImageView * ocjImg_bg;


@end
