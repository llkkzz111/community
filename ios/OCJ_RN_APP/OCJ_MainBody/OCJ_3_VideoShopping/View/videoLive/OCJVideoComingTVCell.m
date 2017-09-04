//
//  OCJVideoComingTVCell.m
//  OCJ
//
//  Created by Ray on 2017/6/11.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJVideoComingTVCell.h"

@interface OCJVideoComingTVCell ()

@property (nonatomic, strong) UIImageView *ocjImgView;         ///<左侧预览图

@property (nonatomic, strong) UILabel *ocjLab_title;           ///<标题
@property (nonatomic, strong) UILabel *ocjLab_sellPrice;       ///<售价
@property (nonatomic, strong) UILabel *ocjLab_marketPrice;     ///<市场价
@property (nonatomic, strong) UIView *ocjView_line;            ///<横线
@property (nonatomic, strong) UILabel *ocjLab_reduce;          ///<优惠多少
@property (nonatomic, strong) UILabel *ocjLab_gift;            ///<赠品
@property (nonatomic, strong) UILabel *ocjLab_giftTips;        ///<赠品提示

@property (nonatomic, strong) UIButton *ocjBtn_cart;           ///<加入购物车
@property (nonatomic, strong) OCJResponceModel_VideoDetailDesc *ocjModel_transmit;///<传递信息model

@end

@implementation OCJVideoComingTVCell

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
    self.ocjImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.ocjImgView];
    [self.ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(@100);
    }];
  
    //title
    self.ocjLab_title = [[UILabel alloc] init];
//    self.ocjLab_title.text = @"【团购商品】美的 T3-L326B 电烤箱家用烘焙多功能独立控温21L烧叉烧烤";
    self.ocjLab_title.numberOfLines = 2;
    self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_title.textColor = OCJ_COLOR_DARK;
    self.ocjLab_title.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
  
    //已购买人数
    self.ocjLab_reduce = [[UILabel alloc] init];
//    self.ocjLab_reduce.text = @"比直播便宜￥500";
    self.ocjLab_reduce.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_reduce.numberOfLines = 1;
    self.ocjLab_reduce.font = [UIFont systemFontOfSize:12];
    self.ocjLab_reduce.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_reduce];
    [self.ocjLab_reduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_title);
        make.bottom.mas_equalTo(self.ocjImgView);
    }];
    
    //价格
    //抢先价提示label
    UILabel *ocjLab_forestall = [[UILabel alloc] init];
    ocjLab_forestall.text = @"抢先价";
    ocjLab_forestall.font = [UIFont systemFontOfSize:13];
    ocjLab_forestall.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    ocjLab_forestall.textAlignment = NSTextAlignmentLeft;
    [self addSubview:ocjLab_forestall];
    [ocjLab_forestall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_title);
        make.bottom.mas_equalTo(self.ocjLab_reduce.mas_top).offset(-2);
    }];
    
    //售价
    self.ocjLab_sellPrice = [[UILabel alloc] init];
//    self.ocjLab_sellPrice.text = @"￥ 329";
    self.ocjLab_sellPrice.font = [UIFont systemFontOfSize:17];
    self.ocjLab_sellPrice.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    self.ocjLab_sellPrice.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_sellPrice.numberOfLines = 1;
    [self addSubview:self.ocjLab_sellPrice];
    [self.ocjLab_sellPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjLab_forestall.mas_right).offset(1);
        make.bottom.mas_equalTo(ocjLab_forestall);
    }];
    //市场价
    self.ocjLab_marketPrice = [[UILabel alloc] init];
//    self.ocjLab_marketPrice.text = @"￥ 999";
    self.ocjLab_marketPrice.font = [UIFont systemFontOfSize:11];
    self.ocjLab_marketPrice.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_marketPrice.numberOfLines = 1;
    self.ocjLab_marketPrice.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_marketPrice];
    [self.ocjLab_marketPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_sellPrice.mas_right).offset(5);
        make.centerY.mas_equalTo(self.ocjLab_sellPrice.mas_centerY).offset(1);
    }];
    //line
    self.ocjView_line = [[UIView alloc] init];
    self.ocjView_line.backgroundColor = OCJ_COLOR_DARK_GRAY;
    [self addSubview:self.ocjView_line];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.ocjLab_marketPrice);
        make.centerY.mas_equalTo(self.ocjLab_marketPrice);
        make.height.mas_equalTo(@1);
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
        make.left.mas_equalTo(self.ocjLab_title);
        make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(2);
        make.width.mas_equalTo(@28);
        make.height.mas_equalTo(@15);
    }];
    //赠品内容
    self.ocjLab_gift = [[UILabel alloc] init];
    self.ocjLab_gift.font = [UIFont systemFontOfSize:12];
    self.ocjLab_gift.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_gift.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_gift];
    [self.ocjLab_gift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_giftTips.mas_right).offset(2);
        make.centerY.mas_equalTo(self.ocjLab_giftTips);
        make.right.mas_equalTo(self.ocjBtn_cart.mas_left).offset(15);
    }];
}

- (void)setOcjModel_desc:(OCJResponceModel_VideoDetailDesc *)ocjModel_desc {
    self.ocjModel_transmit = ocjModel_desc;
    
    NSString *ocjStr_sellPrice = [self ocj_deleteFloatValueString:[ocjModel_desc.ocjStr_salePrice floatValue]];
    NSAttributedString *newStr = [self ocj_changeStringColorWithString:[NSString stringWithFormat:@"￥%@", ocjStr_sellPrice] andLabel:self.ocjLab_sellPrice];
    
    NSString *ocjStr_marketPrice = [self ocj_deleteFloatValueString:[ocjModel_desc.ocjStr_marketPrice floatValue]];
    CGFloat ocjFloat_reduce = [ocjStr_marketPrice floatValue] - [ocjStr_sellPrice floatValue];
    if (ocjModel_desc.ocjArr_gifts.count > 0) {
        NSString* ocjStr_gift = [ocjModel_desc.ocjArr_gifts componentsJoinedByString:@"、"];
        self.ocjLab_gift.text = ocjStr_gift;
    }else {
        self.ocjLab_giftTips.hidden = YES;
        self.ocjLab_gift.hidden = YES;
    }
    
    self.ocjLab_title.text = [NSString stringWithFormat:@"%@", ocjModel_desc.ocjStr_title];
  if ([ocjStr_marketPrice floatValue] > 0) {
    self.ocjLab_marketPrice.hidden = NO;
    self.ocjLab_reduce.hidden = NO;
    self.ocjView_line.hidden = NO;
    self.ocjLab_marketPrice.text = [NSString stringWithFormat:@"￥%@", ocjStr_marketPrice];
    self.ocjLab_reduce.text = [NSString stringWithFormat:@"比直播便宜￥%@", [self ocj_deleteFloatValueString:ocjFloat_reduce]];
  }else {
    self.ocjLab_marketPrice.hidden = YES;
    self.ocjLab_reduce.hidden = YES;
    self.ocjView_line.hidden = YES;
  }
  
    self.ocjLab_sellPrice.attributedText = newStr;
    
  
    [self.ocjImgView ocj_setWebImageWithURLString:[NSString stringWithFormat:@"%@", ocjModel_desc.ocjStr_firstImgUrl] completion:nil];
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
 去掉floatValue小数点后面的00
 */
- (NSString *)ocj_deleteFloatValueString:(CGFloat)floatValue {
    NSString *ocjStr_float = [NSString stringWithFormat:@"%f", floatValue];
    NSString *ocjStr_new = [NSString stringWithFormat:@"%@", @(ocjStr_float.floatValue)];
    
    return ocjStr_new;
}

/**
 改变字符串中特定字符字体大小
 */
- (NSAttributedString *)ocj_changeStringColorWithString:(NSString *)oldStr andLabel:(UILabel *)label {
    
    NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
    for (int i = 0; i < oldStr.length; i++) {
        unichar c = [oldStr characterAtIndex:i];
        if ((c >= 48 && c <= 57)) {
            [newStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(i, 1)];
        }else {
            [newStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(i, 1)];
        }
    }
//    label.font.pointSize
    return newStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
