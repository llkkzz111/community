//
//  OCJVideoDetailCommonTVCell.m
//  OCJ
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJVideoDetailCommonTVCell.h"

@interface OCJVideoDetailCommonTVCell ()

@property (nonatomic, strong) UIImageView *ocjImgView;              ///<左侧预览图

@property (nonatomic, strong) UILabel *ocjLab_title;           ///<标题
@property (nonatomic, strong) UILabel *ocjLab_sellPrice;       ///<售价
@property (nonatomic, strong) UILabel *ocjLab_marketPrice;     ///<市场价
@property (nonatomic, strong) UILabel *ocjLab_gift;            ///<买一送一
@property (nonatomic, strong) UILabel *ocjLab_buyer;           ///<已购买人数
@property (nonatomic, strong) UIImageView *ocjImgView_score;   ///<积分
@property (nonatomic, strong) UILabel *ocjLab_score;           ///<积分

@property (nonatomic, strong) UILabel *ocjLab_gift2;            ///<赠品
@property (nonatomic, strong) UILabel *ocjLab_giftTips;        ///<赠品提示

@property (nonatomic, strong) UIButton *ocjBtn_cart;                ///<加入购物车
@property (nonatomic, strong) OCJResponceModel_VideoDetailDesc *ocjModel_transmit;///<传递信息model

@end

@implementation OCJVideoDetailCommonTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews {
    UIView *ocjView_topLine = [[UIView alloc] init];
    ocjView_topLine.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self addSubview:ocjView_topLine];
    [ocjView_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
    //预览图
    self.ocjImgView = [[UIImageView alloc] init];
    self.ocjImgView.backgroundColor = [UIColor redColor];
    [self addSubview:self.ocjImgView];
    [self.ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(@120);
    }];
    //title
    self.ocjLab_title = [[UILabel alloc] init];
    self.ocjLab_title.text = @"【团购商品】美的 T3-L326B 电烤箱家用烘焙多功能独立控温21L烧叉烧烤";
    self.ocjLab_title.numberOfLines = 2;
    self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_title.textColor = OCJ_COLOR_DARK;
    self.ocjLab_title.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(@44);
    }];
  //已购买人数
  self.ocjLab_buyer = [[UILabel alloc] init];
  self.ocjLab_buyer.text = @"5947 人已购买";
  self.ocjLab_buyer.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_buyer.numberOfLines = 1;
  self.ocjLab_buyer.font = [UIFont systemFontOfSize:14];
  self.ocjLab_buyer.textAlignment = NSTextAlignmentLeft;
  [self addSubview:self.ocjLab_buyer];
  [self.ocjLab_buyer mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_title);
    make.bottom.mas_equalTo(self.ocjImgView);
  }];
    //价格
    //售价
    self.ocjLab_sellPrice = [[UILabel alloc] init];
    self.ocjLab_sellPrice.text = @"￥ 329";
    self.ocjLab_sellPrice.font = [UIFont systemFontOfSize:17];
    self.ocjLab_sellPrice.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    self.ocjLab_sellPrice.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_sellPrice.numberOfLines = 1;
    [self addSubview:self.ocjLab_sellPrice];
    [self.ocjLab_sellPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_title);
        make.bottom.mas_equalTo(self.ocjLab_buyer.mas_top).offset(-5);
    }];
  //积分
  self.ocjImgView_score = [[UIImageView alloc] init];
  [self.ocjImgView_score setImage:[UIImage imageNamed:@"vip_score"]];
  [self addSubview:self.ocjImgView_score];
  [self.ocjImgView_score mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_sellPrice.mas_right).offset(5);
    make.centerY.mas_equalTo(self.ocjLab_sellPrice);
    make.width.height.mas_equalTo(@15);
  }];
  
  self.ocjLab_score = [[UILabel alloc] init];
  self.ocjLab_score.textColor = [UIColor colorWSHHFromHexString:@"#FA6923"];
  self.ocjLab_score.font = [UIFont systemFontOfSize:13];
  self.ocjLab_score.textAlignment = NSTextAlignmentLeft;
  [self addSubview:self.ocjLab_score];
  [self.ocjLab_score mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjImgView_score.mas_right).offset(5);
    make.centerY.mas_equalTo(self.ocjImgView_score);
  }];
    //市场价
    self.ocjLab_marketPrice = [[UILabel alloc] init];
    self.ocjLab_marketPrice.text = @"￥ 999";
    self.ocjLab_marketPrice.font = [UIFont systemFontOfSize:13];
    self.ocjLab_marketPrice.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_marketPrice.numberOfLines = 1;
    self.ocjLab_marketPrice.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_marketPrice];
    [self.ocjLab_marketPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_sellPrice.mas_right).offset(5);
        make.centerY.mas_equalTo(self.ocjLab_sellPrice.mas_centerY).offset(1);
    }];
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_DARK_GRAY;
    [self addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.ocjLab_marketPrice);
        make.centerY.mas_equalTo(self.ocjLab_marketPrice);
        make.height.mas_equalTo(@1);
    }];
    //买一送一
    self.ocjLab_gift = [[UILabel alloc] init];
    self.ocjLab_gift.text = @"买一送一";
    self.ocjLab_gift.backgroundColor = [UIColor redColor];
    self.ocjLab_gift.layer.masksToBounds = YES;
    self.ocjLab_gift.layer.cornerRadius = 2;
    self.ocjLab_gift.font = [UIFont systemFontOfSize:11];
    self.ocjLab_gift.textAlignment = NSTextAlignmentCenter;
    self.ocjLab_gift.numberOfLines = 1;
    [self addSubview:self.ocjLab_gift];
    [self.ocjLab_gift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_marketPrice.mas_right).offset(5);
        make.centerY.mas_equalTo(self.ocjLab_sellPrice);
        make.height.mas_equalTo(@17);
        make.width.mas_equalTo(@48);
    }];
    
    //加入购物车
    self.ocjBtn_cart = [[UIButton alloc] init];
    [self.ocjBtn_cart setImage:[UIImage imageNamed:@"Icon_cart2_"] forState:UIControlStateNormal];
    self.ocjBtn_cart.layer.cornerRadius = 2;
    [self.ocjBtn_cart addTarget:self action:@selector(ocj_clickedCartBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ocjBtn_cart];
    [self.ocjBtn_cart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.ocjImgView);
        make.width.mas_equalTo(@24);
        make.height.mas_equalTo(@24);
    }];
    
    //加减数量
    UIView *ocjView_add = [[UIView alloc] init];
    ocjView_add.backgroundColor = OCJ_COLOR_BACKGROUND;
    [self addSubview:ocjView_add];
    [ocjView_add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjBtn_cart.mas_left).offset(-3);
        make.bottom.mas_equalTo(self.ocjImgView);
        make.width.mas_equalTo(@68);
        make.height.mas_equalTo(@22);
    }];
  
    //减btn
    UIButton *ocjBtn_minus = [[UIButton alloc] init];
    ocjBtn_minus.backgroundColor = [UIColor colorWSHHFromHexString:@"F7F7F7"];
    [ocjBtn_minus setTitle:@"-" forState:UIControlStateNormal];
    [ocjBtn_minus setTitleColor:OCJ_COLOR_LIGHT_GRAY forState:UIControlStateNormal];
    [ocjBtn_minus addTarget:self action:@selector(ocj_clickedMinusBtn) forControlEvents:UIControlEventTouchUpInside];
    [ocjView_add addSubview:ocjBtn_minus];
    [ocjBtn_minus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(ocjView_add);
        make.width.mas_equalTo(@22);
    }];
    //加btn
    UIButton *ocjBtn_plus = [[UIButton alloc] init];
    ocjBtn_plus.backgroundColor = [UIColor colorWSHHFromHexString:@"EDEDED"];
    [ocjBtn_plus setTitle:@"+" forState:UIControlStateNormal];
    [ocjBtn_plus setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
    [ocjBtn_plus addTarget:self action:@selector(ocj_clickedPlusBtn) forControlEvents:UIControlEventTouchUpInside];
    [ocjView_add addSubview:ocjBtn_plus];
    [ocjBtn_plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(ocjView_add);
        make.width.mas_equalTo(@22);
    }];
    //数量
    self.ocjLab_num = [[UILabel alloc] init];
    self.ocjLab_num.text = @"1";
    self.ocjLab_num.font = [UIFont systemFontOfSize:12];
    self.ocjLab_num.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_num.backgroundColor = [UIColor colorWSHHFromHexString:@"EDEDED"];
    self.ocjLab_num.textAlignment = NSTextAlignmentCenter;
    [ocjView_add addSubview:self.ocjLab_num];
    [self.ocjLab_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjBtn_minus.mas_right).offset(1);
        make.top.bottom.mas_equalTo(ocjView_add);
        make.right.mas_equalTo(ocjBtn_plus.mas_left).offset(-1);
    }];
  
  //赠品
  self.ocjLab_giftTips = [[UILabel alloc] init];
  self.ocjLab_giftTips.text = @"赠品";
  self.ocjLab_giftTips.font = [UIFont systemFontOfSize:11];
  self.ocjLab_giftTips.textColor = [UIColor colorWSHHFromHexString:@"#ED1C41"];
  self.ocjLab_giftTips.textAlignment = NSTextAlignmentCenter;
  self.ocjLab_giftTips.backgroundColor = [UIColor colorWSHHFromHexString:@"#FDE8EC"];
  self.ocjLab_giftTips.layer.cornerRadius = 2;
  self.ocjLab_giftTips.layer.masksToBounds = YES;
  [self addSubview:self.ocjLab_giftTips];
  [self.ocjLab_giftTips mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjImgView.mas_right).offset(10);
    make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(2);
    make.width.mas_equalTo(@28);
    make.height.mas_equalTo(@15);
  }];
  //赠品内容
  self.ocjLab_gift2 = [[UILabel alloc] init];
  self.ocjLab_gift2.font = [UIFont systemFontOfSize:12];
  self.ocjLab_gift2.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_gift2.textAlignment = NSTextAlignmentLeft;
  [self addSubview:self.ocjLab_gift2];
  [self.ocjLab_gift2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_giftTips.mas_right).offset(2);
    make.bottom.mas_equalTo(self.ocjLab_giftTips);
    make.right.mas_lessThanOrEqualTo(self.mas_right).offset(-20);
  }];
  
    ocjView_add.hidden = YES;
    ocjView_line.hidden = YES;
    self.ocjLab_marketPrice.hidden = YES;
    self.ocjLab_gift.hidden = YES;
}

- (void)setOcjModel_desc:(OCJResponceModel_VideoDetailDesc *)ocjModel_desc {
    self.ocjModel_transmit = ocjModel_desc;
    self.ocjLab_title.text = [NSString stringWithFormat:@"%@", ocjModel_desc.ocjStr_title];
    self.ocjLab_marketPrice.text = [NSString stringWithFormat:@"￥%@", ocjModel_desc.ocjStr_marketPrice];
    self.ocjLab_sellPrice.attributedText = [self ocj_changeStringColorWithString:[NSString stringWithFormat:@"￥%@", ocjModel_desc.ocjStr_salePrice]];
  
    self.ocjLab_buyer.text = [NSString stringWithFormat:@"%@ 人已购买", ocjModel_desc.ocjStr_salesNum];
    [self.ocjImgView ocj_setWebImageWithURLString:[NSString stringWithFormat:@"%@", ocjModel_desc.ocjStr_firstImgUrl] completion:nil];
  
  if ([ocjModel_desc.ocjStr_integral isEqualToString:@"0"]) {
    self.ocjLab_score.hidden = YES;
    self.ocjImgView_score.hidden = YES;
  }else {
    self.ocjImgView_score.hidden = NO;
    self.ocjLab_score.hidden = NO;
    self.ocjLab_score.text = [NSString stringWithFormat:@"%@", ocjModel_desc.ocjStr_integral];
  }
  
  if (ocjModel_desc.ocjArr_gifts.count > 0) {
    NSString* ocjStr_gift = [ocjModel_desc.ocjArr_gifts componentsJoinedByString:@"、"];
    self.ocjLab_gift2.text = ocjStr_gift;
  }else {
    self.ocjLab_giftTips.hidden = YES;
    self.ocjLab_gift2.hidden = YES;
  }
}

/**
 改变字符串中特定字符字体大小
 */
- (NSMutableAttributedString *)ocj_changeStringColorWithString:(NSString *)oldStr {
  NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
  for (int i = 0; i < oldStr.length; i++) {
    unichar c = [oldStr characterAtIndex:i];
    if ((c >= 48 && c <= 57)) {
      [newStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(i, 1)];
    }else {
      [newStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(i, 1)];
    }
  }
  return newStr;
}

/**
 加入购物车
 */
- (void)ocj_clickedCartBtn {
    if (self.delegate) {
        [self.delegate ocj_addToCartWithCellModel:self.ocjModel_transmit];
    }
}

/**
 减
 */
- (void)ocj_clickedMinusBtn {
    if (self.delegate) {
        [self.delegate ocj_minusCartNumWithCell:self];
    }
}

/**
 加
 */
- (void)ocj_clickedPlusBtn {
    if (self.delegate) {
        [self.delegate ocj_plusCartNumWithCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
