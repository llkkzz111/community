//
//  OCJPayMethodTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/8/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJPayMethodTVCell.h"

@interface OCJPayMethodTVCell ()

@property (nonatomic, strong) UILabel *ocjLab_title;        ///<标题

@property (nonatomic, strong) UIView *ocjView_payMethod;    ///<支付方式
@property (nonatomic, strong) UIImageView *ocjImgView_pay;  ///<缩略图
@property (nonatomic, strong) UILabel *ocjLab_pay;          ///<支付方式
@property (nonatomic, strong) UILabel *ocjLab_activity;     ///<活动
@property (nonatomic, strong) UIImageView *ocjImgView_arrow;///<

@property (nonatomic, strong) UIButton *ocjBtn_selectMethod; ///<选择支付方式
@property (nonatomic, strong) UILabel *ocjLab_select;       ///<
@property (nonatomic, strong) UIImageView *ocjImgView;      ///<箭头

@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;///<确认按钮

@property (nonatomic, strong) NSMutableArray *ocjArr_bank;  ///<银行数组
@property (nonatomic, strong) NSString *ocjStr_title;       ///<在线支付、货到付款

@property (nonatomic) BOOL ocjBool_isSelect;                ///<是否选中支付方式

@end

@implementation OCJPayMethodTVCell

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
  self.ocjLab_title = [[UILabel alloc] init];
  self.ocjLab_title.font = [UIFont systemFontOfSize:14];
  self.ocjLab_title.textColor = OCJ_COLOR_DARK;
  self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
  [self addSubview:self.ocjLab_title];
  [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self).offset(10);
    make.top.mas_equalTo(self).offset(15);
    make.height.mas_equalTo(20);
    make.width.mas_equalTo(100);
  }];
  self.ocjBool_isSelect = NO;
  [self ocj_addPayMethodView];
  [self ocj_addSelectPayMethodView];
}

- (void)ocj_addPayMethodView {
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_clickedSelectPayMethodBtn)];
  
  self.ocjView_payMethod = [[UIView alloc] init];
  self.ocjView_payMethod.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self.ocjView_payMethod addGestureRecognizer:tap];
  [self addSubview:self.ocjView_payMethod];
  [self.ocjView_payMethod mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self);
    make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(15);
    make.height.mas_equalTo(@44);
  }];
  //支付方式缩略图
  self.ocjImgView_pay = [[UIImageView alloc] init];
  [self.ocjView_payMethod addSubview:self.ocjImgView_pay];
  [self.ocjImgView_pay mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_payMethod.mas_left).offset(10);
    make.centerY.mas_equalTo(self.ocjView_payMethod);
    make.width.height.mas_equalTo(@20);
  }];
  //支付方式
  self.ocjLab_pay = [[UILabel alloc] init];
  self.ocjLab_pay.font = [UIFont systemFontOfSize:13];
  self.ocjLab_pay.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_pay.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_payMethod addSubview:self.ocjLab_pay];
  [self.ocjLab_pay mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjImgView_pay.mas_right).offset(6);
    make.centerY.mas_equalTo(self.ocjView_payMethod);
  }];
  //按钮
  self.ocjBtn_select = [[UIButton alloc] init];
  [self.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
  self.ocjBtn_select.selected = NO;
  [self.ocjBtn_select addTarget:self action:@selector(ocj_clickedSelectBtn) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_payMethod addSubview:self.ocjBtn_select];
  [self.ocjBtn_select mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.bottom.right.mas_equalTo(self.ocjView_payMethod);
    make.width.mas_equalTo(@44);
  }];
  //活动
  self.ocjLab_activity = [[UILabel alloc] init];
  self.ocjLab_activity.font = [UIFont systemFontOfSize:13];
  self.ocjLab_activity.textColor = [UIColor colorWSHHFromHexString:@"#EA543D"];
  self.ocjLab_activity.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_payMethod addSubview:self.ocjLab_activity];
  [self.ocjLab_activity mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_pay.mas_right).offset(10);
    make.centerY.mas_equalTo(self.ocjView_payMethod);
    make.right.mas_equalTo(self.ocjBtn_select.mas_left).offset(10);
  }];
  //
  UIView *ocjView_line = [[UIView alloc] init];
  ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
  [self.ocjView_payMethod addSubview:ocjView_line];
  [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_payMethod.mas_left).offset(10);
    make.right.mas_equalTo(self.ocjView_payMethod.mas_right).offset(-10);
    make.bottom.mas_equalTo(self.ocjView_payMethod);
    make.height.mas_equalTo(@0.5);
  }];
  //
  self.ocjImgView_arrow = [[UIImageView alloc] init];
  [self.ocjImgView_arrow setImage:[UIImage imageNamed:@"arrow"]];
  [self.ocjView_payMethod addSubview:self.ocjImgView_arrow];
  [self.ocjImgView_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(self.ocjView_payMethod);
    make.right.mas_equalTo(self.ocjView_payMethod.mas_right).offset(-10);
    make.width.mas_equalTo(@9);
    make.height.mas_equalTo(@13);
  }];
  self.ocjBtn_select.hidden = YES;
}

- (void)ocj_addSelectPayMethodView {
  self.ocjBtn_selectMethod = [[UIButton alloc] init];
  [self.ocjBtn_selectMethod addTarget:self action:@selector(ocj_clickedSelectPayMethodBtn) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.ocjBtn_selectMethod];
  [self.ocjBtn_selectMethod mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self);
    make.top.mas_equalTo(self.ocjView_payMethod.mas_bottom).offset(0);
    make.height.mas_equalTo(@44);
  }];
  //
  self.ocjLab_select = [[UILabel alloc] init];
  self.ocjLab_select.font = [UIFont systemFontOfSize:13];
  self.ocjLab_select.textColor = OCJ_COLOR_DARK_GRAY;
  self.ocjLab_select.textAlignment = NSTextAlignmentLeft;
  self.ocjLab_select.text = @"选择其他支付方式";
  [self.ocjBtn_selectMethod addSubview:self.ocjLab_select];
  [self.ocjLab_select mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjBtn_selectMethod.mas_left).offset(10);
    make.centerY.mas_equalTo(self.ocjBtn_selectMethod);
  }];
  //
  self.ocjImgView = [[UIImageView alloc] init];
  [self.ocjImgView setImage:[UIImage imageNamed:@"arrow"]];
  [self.ocjBtn_selectMethod addSubview:self.ocjImgView];
  [self.ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjBtn_selectMethod.mas_right).offset(-10);
    make.centerY.mas_equalTo(self.ocjBtn_selectMethod);
    make.width.mas_equalTo(@9);
    make.height.mas_equalTo(@13);
  }];
  //确认按钮
  self.ocjBtn_confirm = [[OCJBaseButton alloc] init];
  [self.ocjBtn_confirm setTitle:@"确认" forState:UIControlStateNormal];
  self.ocjBtn_confirm.titleLabel.font = [UIFont systemFontOfSize:15];
  [self.ocjBtn_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.ocjBtn_confirm.layer.masksToBounds = YES;
  self.ocjBtn_confirm.layer.cornerRadius = 2;
  self.ocjBtn_confirm.backgroundColor = [UIColor colorWSHHFromHexString:@"E5290D"];
  [self.ocjBtn_confirm addTarget:self action:@selector(ocj_clickedConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.ocjBtn_confirm];
  [self.ocjBtn_confirm mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.ocjBtn_selectMethod.mas_bottom).offset(10);
    make.centerX.mas_equalTo(self);
    make.width.mas_equalTo(SCREEN_WIDTH -  40 * 2);
    make.height.mas_equalTo(40);
  }];
}

- (NSMutableArray *)ocjArr_bank {
  if (!_ocjArr_bank) {
    _ocjArr_bank = [NSMutableArray array];
  }
  return _ocjArr_bank;
}

#pragma mark - 点击事件
/**
 点击选择按钮
 */
- (void)ocj_clickedSelectBtn {
  self.ocjBool_isSelect = !self.ocjBool_isSelect;
  if (self.ocjBool_isSelect) {
    [self.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_selected"] forState:UIControlStateNormal];
  }else {
    [self.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
  }
}

/**
 选择支付方式
 */
- (void)ocj_clickedSelectPayMethodBtn {
  __weak OCJPayMethodTVCell *weakSelf = self;
  if (weakSelf.ocjPayMethodblock) {
    weakSelf.ocjPayMethodblock(weakSelf.ocjModel_selected, @"NO");
  }
  if ([self.ocjStr_title isEqualToString:@"onlinePay"]) {
    [OCJOtherPayView ocj_popPayViewWithTitle:@"选择在线支付方式" bankCardArrays:self.ocjArr_bank completion:^(OCJOtherPayModel *ocjModel_selected) {
      if (ocjModel_selected != nil) {
        weakSelf.ocjModel_selected = ocjModel_selected;
        //默认选中第一个
        weakSelf.ocjBool_isSelect = YES;
        [weakSelf.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_selected"] forState:UIControlStateNormal];
        weakSelf.ocjLab_pay.text = weakSelf.ocjModel_selected.ocjStr_title;
        weakSelf.ocjLab_activity.text = weakSelf.ocjModel_selected.ocjStr_activity;
        [weakSelf.ocjImgView_pay ocj_setWebImageWithURLString:weakSelf.ocjModel_selected.ocjStr_imageUrl completion:nil];
        if (weakSelf.ocjPayMethodblock) {
          weakSelf.ocjPayMethodblock(weakSelf.ocjModel_selected, @"NO");
        }
      }
    }];
  }else {
    [OCJOtherPayView ocj_popPayViewWithTitle:@"选择货到支付方式" bankCardArrays:self.ocjArr_bank completion:^(OCJOtherPayModel *ocjModel_selected) {
      if (ocjModel_selected != nil) {
        weakSelf.ocjModel_selected = [[OCJOtherPayModel alloc] init];
        weakSelf.ocjModel_selected = ocjModel_selected;
        [weakSelf.ocjView_payMethod mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(@44);
        }];
        weakSelf.ocjBool_isSelect = YES;
        [weakSelf.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_selected"] forState:UIControlStateNormal];
        weakSelf.ocjLab_pay.text = weakSelf.ocjModel_selected.ocjStr_title;
        weakSelf.ocjLab_activity.text = weakSelf.ocjModel_selected.ocjStr_activity;
        [weakSelf.ocjImgView_pay ocj_setWebImageWithURLString:weakSelf.ocjModel_selected.ocjStr_imageUrl completion:nil];
        if (weakSelf.ocjPayMethodblock) {
          weakSelf.ocjPayMethodblock(weakSelf.ocjModel_selected, @"NO");
        }
      }
    }];
  }
  
}

/**
 点击确认按钮
 */
- (void)ocj_clickedConfirmBtn {
  __weak OCJPayMethodTVCell *weakSelf = self;
//  if (self.ocjBool_isSelect) {
    if (self.ocjPayMethodblock) {
      self.ocjPayMethodblock(weakSelf.ocjModel_selected, @"YES");
    }
//  }
//  else {
//    [OCJProgressHUD ocj_showHudWithTitle:@"请先选择支付方式" andHideDelay:2.0];
//  }
}

- (void)setOcjModel_onLine:(OCJModel_onLinePay *)ocjModel_onLine {
  self.ocjArr_bank = ocjModel_onLine.ocjArr_lastPayment;
  self.ocjStr_title = ocjModel_onLine.ocjStr_payStyle;
  if ([self.ocjStr_title isEqualToString:@"onlinePay"]) {
    self.ocjLab_title.text = @"在线支付:";
    [self.ocjBtn_confirm setTitle:@"确认支付" forState:UIControlStateNormal];
    //
    self.ocjBtn_selectMethod.hidden = YES;
    [self.ocjBtn_selectMethod mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(@0);
    }];
    
  }else{
    self.ocjLab_title.text = @"货到付款:";
    [self.ocjBtn_confirm setTitle:@"确认" forState:UIControlStateNormal];
    //
    self.ocjBtn_selectMethod.hidden = YES;
    [self.ocjBtn_selectMethod mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(@0);
    }];
  }
  if ([self.ocjModel_selected.ocjStr_title length] > 0) {
    self.ocjLab_pay.text = self.ocjModel_selected.ocjStr_title;
    self.ocjLab_activity.text = self.ocjModel_selected.ocjStr_activity;
    [self.ocjImgView_pay ocj_setWebImageWithURLString:self.ocjModel_selected.ocjStr_imageUrl completion:nil];
  }else {
    //默认选中第一个
    NSDictionary *dic = self.ocjArr_bank[0];
    self.ocjLab_pay.text = [dic objectForKey:@"title"];
    self.ocjLab_activity.text = [dic objectForKey:@"eventContent"];
    [self.ocjImgView_pay ocj_setWebImageWithURLString:[dic objectForKey:@"iocnUrl"] completion:nil];
    
    self.ocjModel_selected = [[OCJOtherPayModel alloc] init];
    self.ocjModel_selected.ocjStr_id = [dic objectForKey:@"id"];
    self.ocjModel_selected.ocjStr_title = [dic objectForKey:@"title"];
    self.ocjModel_selected.ocjStr_activity = [dic objectForKey:@"eventContent"];
    self.ocjModel_selected.ocjStr_imageUrl = [dic objectForKey:@"iocnUrl"];
  }
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
