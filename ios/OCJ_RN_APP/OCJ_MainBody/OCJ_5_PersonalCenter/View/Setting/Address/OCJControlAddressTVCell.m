//
//  OCJControlAddressTVCell.m
//  OCJ
//
//  Created by Ray on 2017/5/31.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJControlAddressTVCell.h"

@interface OCJControlAddressTVCell ()

@property (nonatomic, strong) OCJBaseLabel *ocjLab_name;    ///<收件人
@property (nonatomic, strong) OCJBaseLabel *ocjLab_mobile;  ///<手机号
@property (nonatomic, strong) OCJBaseLabel *ocjLab_address; ///<地址
@property (nonatomic, strong) UIView*ocjView_line;          ///<线

@property (nonatomic, strong) UIButton *ocjBtn_default;     ///<设置默认地址按钮
@property (nonatomic, strong) OCJBaseLabel *ocjLab_default; ///<默认地址/设为默认地址
@property (nonatomic, strong) UIButton *ocjBtn_edit;        ///<编辑按钮
@property (nonatomic, strong) UIButton *ocjBtn_delete;      ///<删除按钮

@property (nonatomic, strong) OCJAddressModel_listDesc *model;

@end

@implementation OCJControlAddressTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ocj_addTopView];
        [self ocj_addBottomiew];
    }
    return self;
}

/**
 上半部分
 */
- (void)ocj_addTopView {
    //收件人
    self.ocjLab_name = [[OCJBaseLabel alloc] init];
    self.ocjLab_name.textColor = OCJ_COLOR_DARK;
    self.ocjLab_name.font = [UIFont systemFontOfSize:14];
    self.ocjLab_name.text = @"收件人：小七";
    self.ocjLab_name.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_name];
    [self.ocjLab_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(14);
        make.height.mas_equalTo(@22);
    }];
    
    //mobile
    self.ocjLab_mobile = [[OCJBaseLabel alloc] init];
    self.ocjLab_mobile.text = @"139987674701";
    self.ocjLab_mobile.textColor = OCJ_COLOR_DARK;
    self.ocjLab_mobile.font = [UIFont systemFontOfSize:14];
    self.ocjLab_mobile.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.ocjLab_mobile];
    [self.ocjLab_mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(14);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(@22);
        make.left.mas_equalTo(self.ocjLab_name.mas_right).offset(0);
    }];
    //address
    self.ocjLab_address = [[OCJBaseLabel alloc] init];
    self.ocjLab_address.text = @"上海市杨浦区隆昌路619号XXX区XXXXXXX街道XX号";
    self.ocjLab_address.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_address.font = [UIFont systemFontOfSize:12];
    self.ocjLab_address.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_address];
    [self.ocjLab_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_name);
        make.right.mas_equalTo(self.ocjLab_mobile);
        make.height.mas_equalTo(@18);
        make.top.mas_equalTo(self.ocjLab_name.mas_bottom).offset(8);
    }];
    //line
    self.ocjView_line = [[UIView alloc] init];
    self.ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"#DDDDDD"];
    [self addSubview:self.ocjView_line];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(@0.5);
        make.top.mas_equalTo(self.ocjLab_address.mas_bottom).offset(10);
    }];
}

/**
 下半部分
 */
- (void)ocj_addBottomiew {
    //设为默认按钮
    self.ocjBtn_default = [[UIButton alloc] init];
    [self.ocjBtn_default setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
    [self.ocjBtn_default addTarget:self action:@selector(ocj_clickedDefaultBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ocjBtn_default];
    [self.ocjBtn_default mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.top.mas_equalTo(self.ocjView_line.mas_bottom);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(@37);
    }];
    //默认label
    self.ocjLab_default = [[OCJBaseLabel alloc] init];
    self.ocjLab_default.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_default.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_default.font = [UIFont systemFontOfSize:12];
    self.ocjLab_default.text = @"设为默认地址";
    [self addSubview:self.ocjLab_default];
    [self.ocjLab_default mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_default.mas_right);
        make.centerY.mas_equalTo(self.ocjBtn_default);
        make.height.mas_equalTo(@18);
    }];
    //删除按钮
    self.ocjBtn_delete = [[UIButton alloc] init];
    [self.ocjBtn_delete addTarget:self action:@selector(ocj_clickedDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjBtn_delete setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    [self.ocjBtn_delete setTitle:@"删除" forState:UIControlStateNormal];
    [self.ocjBtn_delete setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
    self.ocjBtn_delete.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 3);
    self.ocjBtn_delete.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.ocjBtn_delete];
    [self.ocjBtn_delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self.ocjView_line.mas_bottom);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(@60);
    }];
    
    //编辑按钮
    self.ocjBtn_edit = [[UIButton alloc] init];
    [self.ocjBtn_edit addTarget:self action:@selector(ocj_clickedEditBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjBtn_edit setImage:[UIImage imageNamed:@"Icon_edit"] forState:UIControlStateNormal];
    [self.ocjBtn_edit setTitle:@"编辑" forState:UIControlStateNormal];
    [self.ocjBtn_edit setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
    self.ocjBtn_edit.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 3);
    self.ocjBtn_edit.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.ocjBtn_edit];
    [self.ocjBtn_edit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjBtn_delete.mas_left).offset(-15);
        make.top.mas_equalTo(self.ocjView_line.mas_bottom);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(@60);
    }];
}

- (void)setOcjModel_address:(OCJAddressModel_listDesc *)ocjModel_address {
    self.model = ocjModel_address;
    self.ocjLab_name.text = ocjModel_address.ocjStr_receiverName;
    self.ocjLab_mobile.text = [NSString stringWithFormat:@"%@%@%@", ocjModel_address.ocjStr_mobile1, ocjModel_address.ocjStr_mobile2, ocjModel_address.ocjStr_mobile3];
    self.ocjLab_address.text = [NSString stringWithFormat:@"%@%@", ocjModel_address.ocjStr_addrProCity, ocjModel_address.ocjStr_addrDetail];
    if ([ocjModel_address.ocjStr_isDefault isEqualToString:@"1"]) {
        self.ocjLab_default.text = @"默认地址";
        self.ocjLab_default.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
        [self.ocjBtn_default setImage:[UIImage imageNamed:@"Icon_selected"] forState:UIControlStateNormal];
        self.ocjBtn_default.userInteractionEnabled = NO;
    }else {
        self.ocjLab_default.text = @"设为默认地址";
        self.ocjLab_default.textColor = OCJ_COLOR_DARK_GRAY;
        [self.ocjBtn_default setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
        self.ocjBtn_default.userInteractionEnabled = YES;
    }
}

- (void)ocj_clickedDefaultBtn {
    if (self.delegate) {
        [self.delegate ocj_setDefaultAddress:self.model];
    }
}

- (void)ocj_clickedDeleteBtn {
    if (self.delegate) {
        [self.delegate ocj_deleteAddress:self.model];
    }
}

- (void)ocj_clickedEditBtn {
    if (self.delegate) {
        [self.delegate ocj_editAddress:self.model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
