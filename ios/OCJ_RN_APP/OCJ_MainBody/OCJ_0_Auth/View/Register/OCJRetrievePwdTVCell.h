//
//  OCJRetrievePwdTVCell.h
//  OCJ
//
//  Created by zhangchengcai on 2017/4/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJValidationBtn.h"

@interface OCJRetrievePwdTVCell : UITableViewCell

@property (nonatomic,strong) OCJBaseTextField * ocjTF_Email; ///< 邮箱
@property (nonatomic,strong) UIView * ocjView_line;     ///< 底部分割线

@end

@interface OCJRetrieveCodeTVCell : UITableViewCell

@property (nonatomic,strong) UIView      * ocjView_line;
@property (nonatomic,strong) OCJBaseTextField * ocjTF_mobile;
@property (nonatomic,strong) OCJBaseTextField * ocjTF_evaluteCode;
@property (nonatomic,strong) OCJValidationBtn    * ocjBtn_sendCode;

@end
