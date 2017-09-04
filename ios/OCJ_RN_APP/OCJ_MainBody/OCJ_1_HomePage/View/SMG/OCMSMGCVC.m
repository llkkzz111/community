//
//  OCMSMGCVC.m
//  OCJ
//
//  Created by OCJ on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCMSMGCVC.h"
#import "UIColor+WSHHExtension.h"
#import "OCJSMGTipView.h"
#import "OCJResponseModel_SMG.h"

@interface OCMSMGCVC ()<UITextFieldDelegate>

@property (nonatomic,strong) UIImageView      * ocjImgView_bg;  ///< 背景图片
@property (nonatomic,strong) UIView      * ocjView_bottom;      ///< 下文本
@property (nonatomic,strong) UITextField * ocjTF_code;          ///< 幸运码
@property (nonatomic,strong) OCJBaseButton * ocjbtn_reward;       ///< 抽奖按钮

@end

@implementation OCMSMGCVC

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

      UIView * ocjView_bg = [[UIView alloc]init];
        self.backgroundColor = [UIColor clearColor];
      
        [self addSubview:ocjView_bg];
        [ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(245);
            make.height.mas_equalTo(360);
            make.center.mas_equalTo(self);
        }];
        
        self.ocjImgView_bg  = [[UIImageView alloc]init];
        self.ocjImgView_bg.userInteractionEnabled = YES;
        [ocjView_bg addSubview:self.ocjImgView_bg];
        [self.ocjImgView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ocjView_bg);
            make.right.mas_equalTo(ocjView_bg);
            make.top.mas_equalTo(ocjView_bg);
            make.height.mas_equalTo(215);
        }];
      
        //底部点击按钮
        self.ocjView_bottom  = [[UIView alloc]init];
        self.ocjView_bottom.backgroundColor = [UIColor whiteColor];
        [ocjView_bg addSubview:self.ocjView_bottom];
        [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ocjView_bg).offset(0);
            make.right.mas_equalTo(ocjView_bg).offset(0);
            make.top.mas_equalTo(self.ocjImgView_bg.mas_bottom);
            make.bottom.mas_equalTo(ocjView_bg);
        }];
        
        self.ocjTF_code = [[UITextField alloc]init];
        self.ocjTF_code.placeholder = @"请输入幸运码";
        self.ocjTF_code.delegate = self;
        self.ocjTF_code.font = [UIFont systemFontOfSize:15];
        self.ocjTF_code.layer.cornerRadius = 2;
        self.ocjTF_code.layer.masksToBounds = YES;
        self.ocjTF_code.textColor = [UIColor colorWSHHFromHexString:@"666666"];
        self.ocjTF_code.returnKeyType = UIReturnKeyDone;
        self.ocjTF_code.textAlignment = NSTextAlignmentCenter;
        [self.ocjTF_code addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
        [self.ocjView_bottom addSubview:self.ocjTF_code];
        [self.ocjTF_code mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.ocjView_bottom).offset(15);
            make.right.mas_equalTo(self.ocjView_bottom).offset(-15);
            make.top.mas_equalTo(self.ocjView_bottom.mas_top).offset(10);
            make.height.mas_equalTo(45);
        }];
        
        self.ocjbtn_reward = [[OCJBaseButton alloc] initWithFrame:CGRectMake(15, 75, 215, 45)];
        [self.ocjbtn_reward ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
        [self.ocjbtn_reward addTarget:self action:@selector(ocj_clickRewardButton) forControlEvents:UIControlEventTouchUpInside];
        self.ocjbtn_reward.layer.masksToBounds = YES;
        self.ocjbtn_reward.layer.cornerRadius = 2;
        [self.ocjView_bottom addSubview:self.ocjbtn_reward];
        
    }
    return self;
}

- (void)setOcjModel_listDetail:(OCJResponseModel_SMGListDetail *)ocjModel_listDetail {
  _ocjModel_listDetail = ocjModel_listDetail;
  
  [self.ocjImgView_bg ocj_setWebImageWithURLString:ocjModel_listDetail.ocjStr_imageUrl completion:nil];
  
  if (ocjModel_listDetail.ocjBool_isIntime) {
      self.ocjTF_code.backgroundColor = [UIColor colorWSHHFromHexString:@"#FFF0CF"];
      self.ocjTF_code.text = @"";
      self.ocjTF_code.userInteractionEnabled = YES;
    
      [self.ocjbtn_reward setTitle:@"立即抽奖" forState:UIControlStateNormal];
      self.ocjbtn_reward.userInteractionEnabled = YES;
      self.ocjbtn_reward.alpha = 1;
  }else{
    self.ocjTF_code.backgroundColor = [UIColor colorWSHHFromHexString:@"dddddd"];
    self.ocjTF_code.text = @"";
    self.ocjTF_code.userInteractionEnabled = NO;
    
    [self.ocjbtn_reward setTitle:@"活动尚未开始" forState:UIControlStateNormal];
    self.ocjbtn_reward.userInteractionEnabled = NO;
    self.ocjbtn_reward.alpha = 0.5;
  }
  
}


/**
 去掉字符串中非数字字符
 */
- (NSString *)ocj_changeStringWithString:(NSString *)oldStr {
  NSString *newStr = [[NSString alloc] init];
  for (int i = 0; i < oldStr.length; i++) {
    unichar c = [oldStr characterAtIndex:i];
    if (!(c >= 48 && c <= 57)) {
      newStr = [oldStr stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@""];
      oldStr = newStr;
    }
    
  }
  return newStr;
}

- (void)textFieldDidChange{
    if (self.ocjTF_code.text.length > 0 && [self.ocjbtn_reward.titleLabel.text isEqualToString:@"活动尚未开始"]) {
        self.ocjbtn_reward.userInteractionEnabled = NO;
        self.ocjbtn_reward.alpha = 0.5;
    }else if (self.ocjTF_code.text.length > 0 && [self.ocjbtn_reward.titleLabel.text isEqualToString:@"立即抽奖"]) {
        self.ocjbtn_reward.userInteractionEnabled = YES;
        self.ocjbtn_reward.alpha = 1.0;
    }else {
        self.ocjbtn_reward.userInteractionEnabled = NO;
        self.ocjbtn_reward.alpha = 0.5;
    }
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}


- (void)ocj_clickRewardButton{
    if (self.ocjTF_code.text.length==0) {
        [OCJProgressHUD ocj_showHudWithTitle:@"请输入幸运码" andHideDelay:2];
        return;
    }
  NSString* unitRD = @"0.";
  NSInteger x = arc4random() % 100000000000;
  unitRD = [unitRD stringByAppendingString:[NSString stringWithFormat:@"%ld",x]];
  
    NSDictionary* dic = @{@"unitPwd":self.ocjTF_code.text,@"unitNO":self.ocjModel_listDetail.ocjStr_destinationUrl,@"unitRD":unitRD};
    if (self.ocj_rewardHandler) {
        self.ocj_rewardHandler(dic);
    }
}


@end
