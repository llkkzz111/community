//
//  OCJGoodsNumTVCell.m
//  OCJ
//
//  Created by Ray on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGoodsNumTVCell.h"

@interface OCJGoodsNumTVCell ()

@property (nonatomic, strong) UILabel *ocjLab_num;      ///<
@property (nonatomic, assign) NSInteger ocjInt_num;     ///<数量
@property (nonatomic, strong) UILabel *ocjLab_limit;    ///<限购
@property (nonatomic, assign) NSInteger ocjInt_limit;   ///<限购数量

@end

@implementation OCJGoodsNumTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.ocjInt_num = 1;
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews {
    UILabel *ocjLab_title = [[UILabel alloc] init];
    ocjLab_title.text = @"数量";
    ocjLab_title.textColor = OCJ_COLOR_DARK;
    ocjLab_title.font = [UIFont systemFontOfSize:14];
    ocjLab_title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self);
    }];
    //限购提示
    self.ocjLab_limit = [[UILabel alloc] init];
    self.ocjLab_limit.font = [UIFont systemFontOfSize:14];
    self.ocjLab_limit.text = [NSString stringWithFormat:@"（每人限购%d件）", 5];
    self.ocjLab_limit.textColor = [UIColor colorWSHHFromHexString:@"#2A2A2A"];
    self.ocjLab_limit.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_limit];
    [self.ocjLab_limit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjLab_title.mas_right).offset(0);
        make.centerY.mas_equalTo(self);
    }];
    //加减数量
    UIView *ocjView_add = [[UIView alloc] init];
    ocjView_add.backgroundColor = OCJ_COLOR_BACKGROUND;
    ocjView_add.layer.borderWidth = 0.5;
    ocjView_add.layer.borderColor = [UIColor colorWSHHFromHexString:@"999999"].CGColor;
    ocjView_add.layer.cornerRadius = 2;
    [self addSubview:ocjView_add];
    [ocjView_add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(@105);
        make.height.mas_equalTo(@25);
    }];
    //减btn
    UIButton *ocjBtn_minus = [[UIButton alloc] init];
    ocjBtn_minus.backgroundColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    [ocjBtn_minus setTitle:@"-" forState:UIControlStateNormal];
    [ocjBtn_minus setTitleColor:OCJ_COLOR_LIGHT_GRAY forState:UIControlStateNormal];
    [ocjBtn_minus addTarget:self action:@selector(ocj_clickedMinusBtn) forControlEvents:UIControlEventTouchUpInside];
    [ocjView_add addSubview:ocjBtn_minus];
    [ocjBtn_minus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(ocjView_add);
        make.width.mas_equalTo(@35);
    }];
    //line
    UIView *ocjView_leftLine = [[UIView alloc] init];
    ocjView_leftLine.backgroundColor = [UIColor colorWSHHFromHexString:@"999999"];
    [ocjView_add addSubview:ocjView_leftLine];
    [ocjView_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjBtn_minus.mas_right).offset(0);
        make.top.bottom.mas_equalTo(ocjView_add);
        make.width.mas_equalTo(@0.5);
    }];
    //加btn
    UIButton *ocjBtn_plus = [[UIButton alloc] init];
    ocjBtn_plus.backgroundColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    [ocjBtn_plus setTitle:@"+" forState:UIControlStateNormal];
    [ocjBtn_plus setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
    [ocjBtn_plus addTarget:self action:@selector(ocj_clickedPlusBtn) forControlEvents:UIControlEventTouchUpInside];
    [ocjView_add addSubview:ocjBtn_plus];
    [ocjBtn_plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(ocjView_add);
        make.width.mas_equalTo(@35);
    }];
    //line
    UIView *ocjView_rightLine = [[UIView alloc] init];
    ocjView_rightLine.backgroundColor = [UIColor colorWSHHFromHexString:@"999999"];
    [ocjView_add addSubview:ocjView_rightLine];
    [ocjView_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ocjBtn_plus.mas_left).offset(0);
        make.top.bottom.mas_equalTo(ocjView_add);
        make.width.mas_equalTo(@0.5);
    }];
    //数量
    self.ocjLab_num = [[OCJBaseLabel alloc] init];
    self.ocjLab_num.text = @"1";
    self.ocjLab_num.font = [UIFont systemFontOfSize:12];
    self.ocjLab_num.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_num.backgroundColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    self.ocjLab_num.textAlignment = NSTextAlignmentCenter;
    [ocjView_add addSubview:self.ocjLab_num];
    [self.ocjLab_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjBtn_minus.mas_right).offset(1);
        make.top.bottom.mas_equalTo(ocjView_add);
        make.right.mas_equalTo(ocjBtn_plus.mas_left).offset(-1);
    }];
}

- (void)setOcjModel_spec:(OCJResponceModel_Spec *)ocjModel_spec {
    NSString *numControll = ocjModel_spec.ocjStr_numControll;
    NSString *tvNumControll = ocjModel_spec.ocjStr_tvNumControll;
    //限购条件判断
    if ([numControll isEqualToString:@"Y"]) {
        self.ocjLab_limit.hidden = NO;
        self.ocjInt_limit = 1;
        self.ocjLab_limit.text = @"（每人限购1件）";
    }else if ([numControll isEqualToString:@"N"]) {
        
        if ([tvNumControll integerValue] > 0) {
            self.ocjLab_limit.hidden = NO;
            self.ocjInt_limit = [tvNumControll integerValue];
            self.ocjLab_limit.text = [NSString stringWithFormat:@"（每人限购%ld件）", [tvNumControll integerValue]];
        }else {
            self.ocjLab_limit.hidden = YES;
            self.ocjInt_limit = 99;
        }
    }self.ocjInt_num = self.ocjInt_buyNum;
    self.ocjLab_num.text = [NSString stringWithFormat:@"%ld", self.ocjInt_buyNum];
}

/**
 减
 */
- (void)ocj_clickedMinusBtn {
    BOOL minNum = NO;
    if (self.ocjInt_num > 1) {
        self.ocjInt_num -= 1;
    }else {
        self.ocjInt_num = 1;
        minNum = YES;
    }
    self.ocjLab_num.text = [NSString stringWithFormat:@"%ld", self.ocjInt_num];
    if (self.delegate) {
        [self.delegate ocj_minusCartNumWithCell:[self.ocjLab_num.text integerValue] andMinNum:minNum];
    }
}

/**
 加
 */
- (void)ocj_clickedPlusBtn {
    self.ocjInt_num += 1;
    BOOL overLimit = NO;
    if (self.ocjInt_limit > 0) {
        if (self.ocjInt_num > self.ocjInt_limit) {
            self.ocjInt_num = self.ocjInt_limit;
            overLimit = YES;
        }
    }
    
    self.ocjLab_num.text = [NSString stringWithFormat:@"%ld", self.ocjInt_num];
    if (self.delegate) {
        [self.delegate ocj_plusCartNumWithCell:[self.ocjLab_num.text integerValue] andOverLimit:overLimit];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
