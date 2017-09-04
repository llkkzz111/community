//
//  OCJShoppingPOPCouponCell.m
//  OCJ
//
//  Created by Ray on 2017/5/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJShoppingPOPCouponCell.h"

@interface OCJShoppingPOPCouponCell ()

@property (nonatomic, strong) UIView *ocjView_bg;///<背景view

@property (nonatomic, strong) UIView *ocjView_meetCondition;///<是否满足条件
@property (nonatomic, strong) OCJBaseLabel *ocjLab_condition;///<条件
@property (nonatomic, strong) UIImageView *ocjImgView_arrow;///<箭头

@property (nonatomic, strong) UIView *ocjView_discount;///折扣
@property (nonatomic, strong) OCJBaseLabel *ocjLab_left;///<左半边显示折扣或'￥'
@property (nonatomic, strong) OCJBaseLabel *ocjLab_right;///<右半边显示减免数额或'折'

@property (nonatomic, strong) UIButton *ocjBtn_right;///右半边view
@property (nonatomic, strong) OCJBaseLabel *ocjLab_title;///<适用店铺
@property (nonatomic, strong) OCJBaseLabel *ocjLab_rules;///<适用规则
@property (nonatomic, strong) OCJBaseLabel *ocjLab_validity;///<有效期

@property (nonatomic, strong) NSString *ocjStr_couponNo;///<券号

@end

@implementation OCJShoppingPOPCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self ocj_addMeetConditionView];
        [self ocj_addBgView];
        [self ocj_addLeftBtn];
        [self ocj_addRightView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


/**
 顶部是否满足条件视图
 */
- (void)ocj_addMeetConditionView {
    self.ocjView_meetCondition = [[UIView alloc] init];
    self.ocjView_meetCondition.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.ocjView_meetCondition];
    [self.ocjView_meetCondition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@200);
    }];
    
    self.ocjImgView_arrow = [[UIImageView alloc] init];
    self.ocjImgView_arrow.backgroundColor = [UIColor greenColor];
    [self.ocjView_meetCondition addSubview:self.ocjImgView_arrow];
    [self.ocjImgView_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.ocjView_meetCondition);
        make.width.mas_equalTo(@20);
    }];
    
    self.ocjLab_condition = [[OCJBaseLabel alloc] init];
    self.ocjLab_condition.text = @"还差￥20   去瞧瞧";
    self.ocjLab_condition.font = [UIFont systemFontOfSize:13];
    self.ocjLab_condition.textAlignment = NSTextAlignmentRight;
    self.ocjLab_condition.textColor = OCJ_COLOR_DARK;
    
    NSMutableAttributedString *newStr = [self ocj_changeStringColorWithString:self.ocjLab_condition.text];
    self.ocjLab_condition.attributedText = newStr;
    
    [self.ocjView_meetCondition addSubview:self.ocjLab_condition];
    [self.ocjLab_condition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.ocjView_meetCondition);
        make.right.mas_equalTo(self.ocjImgView_arrow.mas_left).offset(0);
    }];
}


/**
 底部视图
 */
- (void)ocj_addBgView {
    
    self.ocjView_bg = [[UIView alloc] init];
    self.ocjView_bg.backgroundColor = OCJ_COLOR_BACKGROUND;
    [self addSubview:self.ocjView_bg];
    [self.ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        if (self.ocjView_meetCondition) {
            make.top.mas_equalTo(self.ocjView_meetCondition.mas_bottom).offset(0);
        }else {
            make.top.mas_equalTo(self.mas_top).offset(15);
        }
        
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
}


/**
 左半边视图
 */
- (void)ocj_addLeftBtn {
    self.ocjBtn_getCoupon = [[UIButton alloc] init];
    self.ocjBtn_getCoupon.adjustsImageWhenHighlighted = NO;
    
    UIImage *image = [UIImage imageNamed:@"Icon_couponleft_"];
    NSInteger leftCapWidth = image.size.width * 0.5;
    NSInteger topCapHeight = image.size.height * 0.5;
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    [self.ocjBtn_getCoupon setBackgroundImage:newImage forState:UIControlStateNormal];
    
    [self.ocjBtn_getCoupon addTarget:self action:@selector(ocj_clickedGetCouponBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_bg addSubview:self.ocjBtn_getCoupon];
    [self.ocjBtn_getCoupon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.ocjView_bg);
        make.width.mas_equalTo(@90);
    }];
    
    self.ocjView_discount = [[UIView alloc] init];
    [self.ocjBtn_getCoupon addSubview:self.ocjView_discount];
    [self.ocjView_discount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjBtn_getCoupon.mas_top).offset(23);
        make.centerX.mas_equalTo(self.ocjBtn_getCoupon);
        make.width.mas_equalTo(@90);
        make.height.mas_equalTo(@40);
    }];
    
    //TODO:根据类型设置文字
//    [self ocj_addDiscountView];
//    [self ocj_addMinusView];
    
    self.ocjLab_leftTitle = [[UILabel alloc] init];
    self.ocjLab_leftTitle.text = @"立即领取";
    self.ocjLab_leftTitle.layer.borderWidth = 0.5;
    self.ocjLab_leftTitle.layer.borderColor = [UIColor whiteColor].CGColor;
    self.ocjLab_leftTitle.layer.cornerRadius = 4;
    self.ocjLab_leftTitle.font = [UIFont systemFontOfSize:13];
    self.ocjLab_leftTitle.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    self.ocjLab_leftTitle.textAlignment = NSTextAlignmentCenter;
    [self.ocjBtn_getCoupon addSubview:self.ocjLab_leftTitle];
    [self.ocjLab_leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjBtn_getCoupon);
        make.top.mas_equalTo(self.ocjView_discount.mas_bottom).offset(5);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@60);
    }];
  self.ocjLab_leftTitle.hidden = YES;
}


/**
 右半边视图
 */
- (void)ocj_addRightView {
    self.ocjBtn_right = [[UIButton alloc] init];
    self.ocjBtn_right.adjustsImageWhenHighlighted = NO;
    //部分拉伸图片
     UIImage *image = [UIImage imageNamed:@"Icon_couponright_"];
     NSInteger leftCapWidth = image.size.width * 0.5;
     NSInteger topCapHeight = image.size.height * 0.5;
     UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    [self.ocjBtn_right setBackgroundImage:newImage forState:UIControlStateNormal];
    
    [self.ocjView_bg addSubview:self.ocjBtn_right];
    [self.ocjBtn_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.ocjView_bg);
        make.left.mas_equalTo(self.ocjBtn_getCoupon.mas_right).offset(0);
    }];
    //名称
    self.ocjLab_title = [[OCJBaseLabel alloc] init];
    self.ocjLab_title.text = @"甄选生活专营店店铺券";
    self.ocjLab_title.font = [UIFont systemFontOfSize:14];
    self.ocjLab_title.textColor = OCJ_COLOR_DARK;
    [self.ocjBtn_right addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_right.mas_left).offset(15);
        make.top.mas_equalTo(self.ocjBtn_right.mas_top).offset(14);
        make.right.mas_equalTo(self.ocjBtn_right);
        make.height.mas_equalTo(@22);
    }];
    //使用规则
    self.ocjLab_rules = [[OCJBaseLabel alloc] init];
    self.ocjLab_rules.text = @"店铺购物金额满￥500减￥20 团购商品除外";
    self.ocjLab_rules.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_rules.font = [UIFont systemFontOfSize:11];
    [self.ocjBtn_right addSubview:self.ocjLab_rules];
    [self.ocjLab_rules mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_title.mas_left);
        make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(11);
        make.right.mas_equalTo(self.ocjBtn_right);
        make.height.mas_equalTo(@12);
    }];
    //有效期
    self.ocjLab_validity = [[OCJBaseLabel alloc] init];
    self.ocjLab_validity.text = @"有效期至2018年4月18日";
    self.ocjLab_validity.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_validity.font = [UIFont systemFontOfSize:11];
    [self.ocjBtn_right addSubview:self.ocjLab_validity];
    [self.ocjLab_validity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_title.mas_left);
        make.top.mas_equalTo(self.ocjLab_rules.mas_bottom).offset(6);
        make.right.mas_equalTo(self.ocjBtn_right);
        make.height.mas_equalTo(@12);
    }];
    //已领取提示图片
    self.ocjImgView_getAlready = [[UIImageView alloc] init];
    [self.ocjImgView_getAlready setImage:[UIImage imageNamed:@"Icon_coupon_"]];
    [self.ocjBtn_right addSubview:self.ocjImgView_getAlready];
    self.ocjImgView_getAlready.hidden = YES;
    [self.ocjImgView_getAlready mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjBtn_right.mas_right).offset(-3);
        make.bottom.mas_equalTo(self.ocjBtn_right).offset(-5);
        make.width.height.mas_equalTo(@80);
    }];
}


/**
 折扣
 */
- (void)ocj_addDiscountView {
    self.ocjLab_left = [[OCJBaseLabel alloc] init];
    self.ocjLab_left.text = @"8";
    self.ocjLab_left.font = [UIFont systemFontOfSize:30];
    self.ocjLab_left.textAlignment = NSTextAlignmentRight;
    self.ocjLab_left.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    [self.ocjView_discount addSubview:self.ocjLab_left];
    [self.ocjLab_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_discount);
        make.bottom.mas_equalTo(self.ocjView_discount);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@31);
    }];
    
    self.ocjLab_right = [[OCJBaseLabel alloc] init];
    self.ocjLab_right.text = @"折";
    self.ocjLab_right.font = [UIFont systemFontOfSize:15];
    self.ocjLab_right.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    [self.ocjView_discount addSubview:self.ocjLab_right];
    [self.ocjLab_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjView_discount);
        make.left.mas_equalTo(self.ocjLab_left.mas_right).offset(0);
        make.height.mas_equalTo(@16);
        make.bottom.mas_equalTo(self.ocjView_discount.mas_bottom).offset(-3);
    }];
}


/**
 减免
 */
- (void)ocj_addMinusView {
    self.ocjLab_left = [[OCJBaseLabel alloc] init];
    self.ocjLab_left.text = @"￥";
    self.ocjLab_left.font = [UIFont systemFontOfSize:15];
    self.ocjLab_left.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    [self.ocjView_discount addSubview:self.ocjLab_left];
    [self.ocjLab_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_lessThanOrEqualTo(self.ocjView_discount.mas_left).offset(18);
        make.bottom.mas_equalTo(self.ocjView_discount.mas_bottom).offset(-3);
        make.height.mas_equalTo(@16);
        make.width.mas_equalTo(@16);
    }];
    
    self.ocjLab_right = [[OCJBaseLabel alloc] init];
    self.ocjLab_right.text = @"20";
    self.ocjLab_right.font = [UIFont systemFontOfSize:28];
    self.ocjLab_right.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_right.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    [self.ocjView_discount addSubview:self.ocjLab_right];
    [self.ocjLab_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.ocjView_discount);
        make.right.mas_lessThanOrEqualTo(self.ocjView_discount.mas_right).offset(-15);
        make.left.mas_equalTo(self.ocjLab_left.mas_right).offset(0);
        make.height.mas_equalTo(@29);
    }];
}


/**
 点击领取优惠券事件
 */
- (void)ocj_clickedGetCouponBtn {
    if (self.cellDelegate) {
        [self.cellDelegate ocj_clickedCouponCellWithCell:self andCouponNo:self.ocjStr_couponNo];
    }
}

/**
 改变字符串中特定字符颜色
 */
- (NSMutableAttributedString *)ocj_changeStringColorWithString:(NSString *)oldStr {
    NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
    for (int i = 0; i < oldStr.length; i++) {
        unichar c = [oldStr characterAtIndex:i];
        if ((c >= 48 && c <= 57)) {
            [newStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, 1)];
        }
        NSString *string = [NSString stringWithCharacters:&c length:1];
        if ([string isEqualToString:@"￥"]) {
            [newStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, 1)];
        }
    }
    return newStr;
}

/**
 加载淘券数据类型
 */
- (void)setOcjModel_taoListDesc:(OCJWalletModel_TaoCouponListDesc *)ocjModel_taoListDesc {
    if (!self.ocjLab_left) {
        [self ocj_addMinusView];
    }
  self.ocjLab_leftTitle.hidden = NO;
  [self.ocjView_discount mas_updateConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.ocjBtn_getCoupon.mas_top).offset(13);
  }];
  NSString *ocjStr_amt = ocjModel_taoListDesc.ocjStr_DCAMT;
  if ([ocjStr_amt containsString:@"%"]) {
    self.ocjLab_left.hidden = YES;
    [self.ocjLab_left mas_updateConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(0);
    }];
  }else {
    self.ocjLab_left.hidden = NO;
    [self.ocjLab_left mas_updateConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(16);
    }];
  }
    self.ocjLab_right.text = ocjModel_taoListDesc.ocjStr_DCAMT;
    self.ocjLab_title.text = ocjModel_taoListDesc.ocjStr_DCCOUPONNAME;
    self.ocjLab_rules.text = ocjModel_taoListDesc.ocjStr_DCCOUPONCONTENT;
    self.ocjLab_validity.text = [NSString stringWithFormat:@"有效期至%@", ocjModel_taoListDesc.ocjStr_DCEDATE];
    self.ocjStr_couponNo = ocjModel_taoListDesc.ocjStr_COUPONNO;
}

/**
 加载抵用券数据类型
 */
- (void)setOcjModel_couponListDesc:(OCJWalletModel_CouponListDesc *)ocjModel_couponListDesc {
    if (!self.ocjLab_left) {
        [self ocj_addMinusView];
    }
  /*
  if ([ocjModel_couponListDesc.ocjStr_isUsed isEqualToString:@"未使用"]) {
    self.ocjLab_leftTitle.text = @"立即使用";
    self.ocjLab_leftTitle.layer.borderWidth = 0.5;
    self.ocjLab_leftTitle.layer.borderColor = [UIColor whiteColor].CGColor;
    self.ocjLab_leftTitle.layer.cornerRadius = 4;
    self.ocjBtn_getCoupon.userInteractionEnabled = YES;
  }else {
    self.ocjLab_leftTitle.text = @"已使用";
    self.ocjLab_leftTitle.layer.borderWidth = 0;
    self.ocjBtn_getCoupon.userInteractionEnabled = NO;
  }
   */
  NSString *ocjStr_amt = ocjModel_couponListDesc.ocjStr_couponAmt;
  if ([ocjStr_amt containsString:@"%"]) {
    self.ocjLab_left.hidden = YES;
    [self.ocjLab_left mas_updateConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(0);
    }];
  }else {
    self.ocjLab_left.hidden = NO;
    [self.ocjLab_left mas_updateConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(16);
    }];
  }
    self.ocjLab_right.text = ocjModel_couponListDesc.ocjStr_couponAmt;
    self.ocjLab_title.text = ocjModel_couponListDesc.ocjStr_couponName;
    self.ocjLab_rules.text = ocjModel_couponListDesc.ocjStr_couponNote;
    self.ocjLab_validity.text = [NSString stringWithFormat:@"有效期至%@", ocjModel_couponListDesc.ocjStr_endDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
