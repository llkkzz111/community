//
//  OCJManageAddressCell.m
//  OCJ
//
//  Created by Ray on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJManageAddressCell.h"

@interface OCJManageAddressCell ()

@property (nonatomic, strong) UIView *ocjView_left;///<左半边背景view
@property (nonatomic, strong) UIImageView *ocjImgView_left;///<左侧imageView
@property (nonatomic, strong) OCJBaseLabel *ocjLab_receiver;///<收货人
@property (nonatomic, strong) UIImageView *ocjImgView_address;///<地址imageView

@property (nonatomic, strong) OCJBaseLabel *ocjLab_name;///<收货人姓名
@property (nonatomic, strong) OCJBaseLabel *ocjLab_phone;///<收货人电话
@property (nonatomic, strong) OCJBaseLabel *ocjLab_address;///<收货人地址
@property (nonatomic, strong) OCJBaseLabel *ocjLab_default;///<默认

@property (nonatomic, strong) UILabel *ocjLab_edit;         ///<修改
@property (nonatomic, strong) UIImageView *ocjImgView_arrow;///<箭头

@property (nonatomic, strong) OCJAddressModel_listDesc *ocjModel_listDesc;///<model

@end

@implementation OCJManageAddressCell

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
    [self ocj_addLeft];
    [self ocj_addRight];
}

/**
 左半边
 */
- (void)ocj_addLeft {
    
    self.ocjView_left = [[UIView alloc] init];
    self.ocjView_left.backgroundColor = OCJ_COLOR_BACKGROUND;
    [self addSubview:self.ocjView_left];
    [self.ocjView_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(@79);
    }];
    
    self.ocjImgView_left = [[UIImageView alloc] init];
    [self.ocjImgView_left setImage:[UIImage imageNamed:@"Icon_colorside_"]];
    [self.ocjView_left addSubview:self.ocjImgView_left];
    [self.ocjImgView_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.ocjView_left);
        make.width.mas_equalTo(@4);
    }];
    //收货人
    self.ocjLab_receiver = [[OCJBaseLabel alloc] init];
    self.ocjLab_address.font = [UIFont systemFontOfSize:15];
    self.ocjLab_address.textColor = OCJ_COLOR_DARK;
    self.ocjLab_address.textAlignment = NSTextAlignmentCenter;
    self.ocjLab_receiver.numberOfLines = 1;
    self.ocjLab_receiver.text = @"收货人";
    [self.ocjView_left addSubview:self.ocjLab_receiver];
    [self.ocjLab_receiver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImgView_left.mas_right).offset(4);
        make.right.mas_equalTo(self.ocjView_left.mas_right).offset(0);
        make.top.mas_equalTo(self.ocjView_left.mas_top).offset(15);
    }];
    
    self.ocjImgView_address = [[UIImageView alloc] init];
    [self.ocjImgView_address setImage:[UIImage imageNamed:@"Icon_combinedshape_"]];
    [self.ocjView_left addSubview:self.ocjImgView_address];
    [self.ocjImgView_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjView_left);
        make.top.mas_equalTo(self.ocjLab_receiver.mas_bottom).offset(13);
        make.width.mas_equalTo(@12);
        make.height.mas_equalTo(@17);
    }];
}

/**
 右半边
 */
- (void)ocj_addRight {
    self.ocjbtn_modify = [[UIButton alloc] init];
    [self.ocjbtn_modify setImage:[UIImage imageNamed:@"Icon_edit_"] forState:UIControlStateNormal];
    [self.ocjbtn_modify addTarget:self action:@selector(ocj_clickedModifyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ocjbtn_modify];
    [self.ocjbtn_modify mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(@0.01);
    }];
    
    //姓名
    self.ocjLab_name = [[OCJBaseLabel alloc] init];
    self.ocjLab_name.font = [UIFont systemFontOfSize:16];
    self.ocjLab_name.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_name.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_name.numberOfLines = 1;
    self.ocjLab_name.text = @"张大明";
    [self addSubview:self.ocjLab_name];
    [self.ocjLab_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_left.mas_right).offset(0);
        make.centerY.mas_equalTo(self.ocjLab_receiver);
//        make.width.mas_equalTo(@54);
    }];
    //手机号
    self.ocjLab_phone = [[OCJBaseLabel alloc] init];
    self.ocjLab_phone.font = [UIFont systemFontOfSize:13];
    self.ocjLab_phone.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_phone.textAlignment = NSTextAlignmentLeft;
    NSString *phone = [self ocj_mixPhoneWithNum:@"13856787477"];
    self.ocjLab_phone.text = phone;
    self.ocjLab_phone.numberOfLines = 1;
    [self addSubview:self.ocjLab_phone];
    [self.ocjLab_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_name.mas_right).offset(8);
        make.centerY.mas_equalTo(self.ocjLab_name);
    }];
    //默认
    self.ocjLab_default = [[OCJBaseLabel alloc] init];
    self.ocjLab_default.backgroundColor = [UIColor colorWSHHFromHexString:@"#EA543D"];
    self.ocjLab_default.layer.cornerRadius = 2;
    self.ocjLab_default.layer.masksToBounds = YES;
    self.ocjLab_default.text = @"默认";
    self.ocjLab_default.font = [UIFont systemFontOfSize:12];
    self.ocjLab_default.textColor = OCJ_COLOR_BACKGROUND;
    self.ocjLab_default.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.ocjLab_default];
    [self.ocjLab_default mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_phone.mas_right).offset(8);
        make.right.mas_lessThanOrEqualTo(self.ocjbtn_modify.mas_left).offset(47);
        make.centerY.mas_equalTo(self.ocjLab_name);
        make.width.mas_equalTo(@36);
        make.height.mas_equalTo(@22);
    }];
    //地址
    self.ocjLab_address = [[OCJBaseLabel alloc] init];
    self.ocjLab_address.font = [UIFont systemFontOfSize:13];
    self.ocjLab_address.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_address.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_address.text = @"上海市闵行区浦江镇V领地青年公寓芦恒路社区店林恒路18号";
    self.ocjLab_address.numberOfLines = 2;
    [self addSubview:self.ocjLab_address];
    [self.ocjLab_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_name.mas_left);
        make.top.mas_equalTo(self.ocjImgView_address.mas_top).offset(-2);
        make.right.mas_equalTo(self.ocjbtn_modify.mas_left).offset(-15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-13);
    }];
  //修改
  self.ocjView_modify = [[UIView alloc] init];
  self.ocjView_modify.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self addSubview:self.ocjView_modify];
  [self.ocjView_modify mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.mas_right).offset(-15);
    make.centerY.mas_equalTo(self.ocjLab_receiver);
    make.width.mas_equalTo(@37);
    make.height.mas_equalTo(@20);
  }];
  self.ocjImgView_arrow = [[UIImageView alloc] init];
  [self.ocjImgView_arrow setImage:[UIImage imageNamed:@"arrow"]];
  [self.ocjView_modify addSubview:self.ocjImgView_arrow];
  [self.ocjImgView_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjView_modify.mas_right).offset(0);
    make.centerY.mas_equalTo(self.ocjView_modify);
    make.width.mas_equalTo(@12);
    make.height.mas_equalTo(@13);
  }];
  
  self.ocjLab_edit = [[UILabel alloc] init];
  self.ocjLab_edit.text = @"修改";
  self.ocjLab_edit.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_edit.font = [UIFont systemFontOfSize:12];
  self.ocjLab_edit.textAlignment = NSTextAlignmentRight;
  [self.ocjView_modify addSubview:self.ocjLab_edit];
  [self.ocjLab_edit mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjImgView_arrow.mas_left).offset(-3);
    make.centerY.mas_equalTo(self.ocjView_modify);
  }];
  self.ocjView_modify.hidden = YES;
}

/**
 设置cell内容
 */
- (void)loadData:(OCJAddressModel_listDesc *)model canEdit:(BOOL)edit {
    self.ocjModel_listDesc = model;
    if (edit) {
        self.ocjbtn_modify.hidden = NO;
    }else {
        self.ocjbtn_modify.hidden = YES;
    }
    self.ocjLab_name.text = model.ocjStr_receiverName;
    self.ocjLab_phone.text = [NSString stringWithFormat:@"%@%@%@", model.ocjStr_mobile1, model.ocjStr_mobile2, model.ocjStr_mobile3];
    self.ocjLab_address.text = [NSString stringWithFormat:@"%@%@", model.ocjStr_addrProCity, model.ocjStr_addrDetail];
    if ([model.ocjStr_isDefault isEqualToString:@"1"]) {
        self.ocjLab_default.hidden = NO;
    }else {
        self.ocjLab_default.hidden = YES;
    }
}

/**
 点击修改地址按钮
 */
- (void)ocj_clickedModifyBtn {
    if (self.delegate) {
        [self.delegate ocj_editAddress:self.ocjModel_listDesc];
    }
}

- (NSString *)ocj_mixPhoneWithNum:(NSString *)phone {
    NSString *newStr;
    if (phone.length > 0) {
        newStr = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@" **** "];
    }else {
        newStr = @"";
    }
    return newStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
