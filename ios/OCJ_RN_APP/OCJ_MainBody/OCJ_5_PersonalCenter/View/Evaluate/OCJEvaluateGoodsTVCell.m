//
//  OCJEvaluateGoodsTVCell.m
//  OCJ
//
//  Created by Ray on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJEvaluateGoodsTVCell.h"

@interface OCJEvaluateGoodsTVCell ()

@property (nonatomic, strong) UIImageView *ocjImgView_goods;///<商品预览图
@property (nonatomic, strong) OCJBaseLabel *ocjLab_name;///<商品名称
@property (nonatomic, strong) OCJBaseLabel *ocjLab_color;///<颜色分类
@property (nonatomic, strong) OCJBaseLabel *ocjLab_price;///<价格
@property (nonatomic, strong) OCJBaseLabel *ocjLab_point;///<积分
@property (nonatomic, strong) OCJBaseLabel *ocjLab_pointNum;///<积分数量
@property (nonatomic, strong) UIImageView *ocjImgView_score;///<积分图片
@property (nonatomic, strong) OCJBaseLabel *ocjLab_num;///<购买数量

@end

@implementation OCJEvaluateGoodsTVCell

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
    //imggeView
    self.ocjImgView_goods = [[UIImageView alloc] init];
    self.ocjImgView_goods.backgroundColor = [UIColor colorWSHHFromHexString:@"EDEDED"];
    [self addSubview:self.ocjImgView_goods];
    [self.ocjImgView_goods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(@75);
    }];
    //名称
    self.ocjLab_name = [[OCJBaseLabel alloc] init];
    self.ocjLab_name.text = @"博朗（Braun）HD580家用便携大功率离子电吹风 吹风机";
    self.ocjLab_name.font = [UIFont systemFontOfSize:14];
    self.ocjLab_name.textColor = OCJ_COLOR_DARK;
    self.ocjLab_name.numberOfLines = 2;
    self.ocjLab_name.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_name];
    [self.ocjLab_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImgView_goods.mas_right).offset(10);
        make.top.mas_equalTo(self.ocjImgView_goods);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
    //价格
    self.ocjLab_price = [[OCJBaseLabel alloc] init];
    self.ocjLab_price.text = @"￥500";
    self.ocjLab_price.font = [UIFont systemFontOfSize:12];
    self.ocjLab_price.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    self.ocjLab_price.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_price];
    [self.ocjLab_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_name);
        make.bottom.mas_equalTo(self.ocjImgView_goods);
    }];
  //积分图片
  self.ocjImgView_score = [[UIImageView alloc] init];
  [self.ocjImgView_score setImage:[UIImage imageNamed:@"vip_score"]];
  [self addSubview:self.ocjImgView_score];
  [self.ocjImgView_score mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_price.mas_right).offset(6);
    make.centerY.mas_equalTo(self.ocjLab_price);
  }];
    //积分
    self.ocjLab_point = [[OCJBaseLabel alloc] init];
    self.ocjLab_point.text = @"积分";
    self.ocjLab_point.font = [UIFont systemFontOfSize:11];
    self.ocjLab_point.textColor = [UIColor colorWSHHFromHexString:@"FEFEFE"];
    self.ocjLab_point.backgroundColor = [UIColor colorWSHHFromHexString:@"#FFC033"];
    self.ocjLab_point.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.ocjLab_point];
    [self.ocjLab_point mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_price.mas_right).offset(6);
        make.centerY.mas_equalTo(self.ocjLab_price);
    }];
  self.ocjLab_point.hidden = YES;
    //积分数量
    self.ocjLab_pointNum = [[OCJBaseLabel alloc] init];
    self.ocjLab_pointNum.text = @"5";
    self.ocjLab_pointNum.font = [UIFont systemFontOfSize:12];
    self.ocjLab_pointNum.textColor = [UIColor colorWSHHFromHexString:@"#FFC033"];
    self.ocjLab_pointNum.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_pointNum];
    [self.ocjLab_pointNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImgView_score.mas_right).offset(4);
        make.centerY.mas_equalTo(self.ocjLab_price);
    }];
    //颜色
    self.ocjLab_color = [[OCJBaseLabel alloc] init];
    self.ocjLab_color.text = @"颜色分类：白色";
    self.ocjLab_color.font = [UIFont systemFontOfSize:12];
    self.ocjLab_color.textColor = OCJ_COLOR_LIGHT_GRAY;
    self.ocjLab_color.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_color];
    [self.ocjLab_color mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_name);
        make.bottom.mas_equalTo(self.ocjLab_price.mas_top).offset(-3);
    }];
    //购买数量
    self.ocjLab_num = [[OCJBaseLabel alloc] init];
    self.ocjLab_num.text = @"x1";
    self.ocjLab_num.font = [UIFont systemFontOfSize:12];
    self.ocjLab_num.textColor = OCJ_COLOR_LIGHT_GRAY;
    self.ocjLab_num.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.ocjLab_num];
    [self.ocjLab_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.left.mas_equalTo(self.ocjLab_color.mas_right).offset(0);
        make.centerY.mas_equalTo(self.ocjLab_color);
    }];
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
}

- (void)setOcjDic_order:(NSDictionary *)ocjDic_order {
  self.ocjLab_name.text = [NSString stringWithFormat:@"%@", [ocjDic_order objectForKey:@"item_name"]];
  self.ocjLab_num.text = [NSString stringWithFormat:@"%@", [ocjDic_order objectForKey:@"order_qty"]];
  self.ocjLab_price.text = [NSString stringWithFormat:@"%@", [ocjDic_order objectForKey:@"rsale_amt"]];
  NSString *ocjStr_point = [ocjDic_order objectForKey:@"saveamt"];
  if ([ocjStr_point floatValue] > 0) {
    self.ocjLab_pointNum.hidden = NO;
    self.ocjLab_point.hidden = NO;
    self.ocjImgView_score.hidden = NO;
    self.ocjLab_pointNum.text = [NSString stringWithFormat:@"%.2f", [ocjStr_point floatValue]];
  }else {
    self.ocjLab_point.hidden = YES;
    self.ocjLab_pointNum.hidden = YES;
    self.ocjImgView_score.hidden = YES;
  }
  
  [self.ocjImgView_goods ocj_setWebImageWithURLString:[ocjDic_order objectForKey:@"contentLink"] completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
