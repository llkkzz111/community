//
//  OCJSendVerifyCodeTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJValidationBtn.h"

typedef void (^OCJTFInputBlock)(NSString *ocjStr_code);

@interface OCJSendVerifyCodeTVCell : UITableViewCell

@property (nonatomic, strong) NSString *ocjStr_account;                ///<
@property (nonatomic, strong) OCJValidationBtn *ocjBtn_sendCode;       ////<发送验证码按钮
@property (nonatomic, strong) UITextField *ocjTF_code;                 ///<输入框

@property (nonatomic, copy) OCJTFInputBlock ocjTFInputBlock;

@end
