//
//  OCJCouponPopView.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJCouponPopView.h"
#import "OCJShoppingPOPCouponCell.h"
#import "OCJSelectCouponTVCell.h"
#import "OCJHttp_myWalletAPI.h"

@interface OCJCouponPopView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *ocjView_bg;                 ///<背景
@property (nonatomic, strong) UIView *ocjView_container;          ///<底部容器view

@property (nonatomic, strong) UIView *ocjView_top;                ///<顶部view
@property (nonatomic, strong) UIView *ocjView_header;             ///<兑换
@property (nonatomic, strong) OCJBaseTableView *ocjTBView_coupon; ///<tableView
@property (nonatomic, strong) UIView *ocjView_bottom;             ///<底部view
@property (nonatomic, strong) UIButton *ocjBtn_nouse;             ///<不使用抵用券按钮

@property (nonatomic, strong) UIButton *ocjBtn_exchange;          ///<兑换按钮
@property (nonatomic, strong) NSArray *ocjArr_couponList;         ///<可用抵用券列表
@property (nonatomic, strong) OCJResponceModel_coupon *ocjModel_last;///<选中的抵用券

@end

@implementation OCJCouponPopView

- (instancetype)initWithArray:(NSArray *)ocjArr_coupon {
  self = [super init];
  if (self) {
    self.ocjArr_couponList = ocjArr_coupon;
    [self ocj_setSelf];
  }
  return self;
}

- (void)ocj_setSelf {
  CGFloat shareViewHeight = SCREEN_HEIGHT / 3.0 * 2;
  //背景
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_closeAction)];
  
  self.ocjView_bg = [[UIView alloc] init];
  self.ocjView_bg.backgroundColor = [UIColor colorWSHHFromHexString:@"000000"];
  self.ocjView_bg.alpha = 0.4;
  [self.ocjView_bg addGestureRecognizer:tap];
  [self addSubview:self.ocjView_bg];
  [self.ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.bottom.mas_equalTo(self);
  }];
  //底部显示商品信息view
  self.ocjView_container = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, shareViewHeight)];
  self.ocjView_container.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self addSubview:self.ocjView_container];
  
  [UIView animateWithDuration:0.5f animations:^{
    self.ocjView_container.frame = CGRectMake(0, SCREEN_HEIGHT - shareViewHeight, SCREEN_WIDTH, shareViewHeight);
  }];
  [self ocj_addTopView];
  [self ocj_addHeaderView];
  [self ocj_adBottomView];
  [self ocj_addTableView];
  
  [self.ocjTBView_coupon registerClass:[OCJSelectCouponTVCell class] forCellReuseIdentifier:@"OCJSelectCouponTVCellIdentifier"];
}

/**
 顶部导航
 */
- (void)ocj_addTopView {
  self.ocjView_top = [[UIView alloc] init];
  self.ocjView_top.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self.ocjView_container addSubview:self.ocjView_top];
  [self.ocjView_top mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.mas_equalTo(self.ocjView_container);
    make.height.mas_equalTo(@44);
  }];
  //label
  UILabel *ocjLab_title = [[UILabel alloc] init];
  ocjLab_title.text = @"使用抵用券";
  ocjLab_title.font = [UIFont systemFontOfSize:15];
  ocjLab_title.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_title.textAlignment = NSTextAlignmentCenter;
  [self.ocjView_top addSubview:ocjLab_title];
  [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.centerX.mas_equalTo(self.ocjView_top);
  }];
  //关闭按钮
  UIButton *ocjBtn_close = [[UIButton alloc] init];
  [ocjBtn_close setImage:[UIImage imageNamed:@"icon_clear"] forState:UIControlStateNormal];
  [ocjBtn_close addTarget:self action:@selector(ocj_closeAction) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_top addSubview:ocjBtn_close];
  [ocjBtn_close mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.right.mas_equalTo(self.ocjView_top);
    make.width.height.mas_equalTo(@44);
  }];
}

/**
 底部确认按钮
 */
- (void)ocj_adBottomView {
  self.ocjView_bottom = [[UIView alloc] init];
  self.ocjView_bottom.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self.ocjView_container addSubview:self.ocjView_bottom];
  [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.mas_equalTo(self.ocjView_container);
    make.height.mas_equalTo(@88);
  }];
  //确定按钮
  UIButton *ocjBtn_confirm = [[UIButton alloc] init];
  [ocjBtn_confirm setTitle:@"确定" forState:UIControlStateNormal];
  [ocjBtn_confirm setTitleColor:[UIColor colorWSHHFromHexString:@"FEFEFE"] forState:UIControlStateNormal];
  ocjBtn_confirm.titleLabel.font = [UIFont systemFontOfSize:15];
  ocjBtn_confirm.backgroundColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
  [ocjBtn_confirm addTarget:self action:@selector(ocj_clickedConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_container addSubview:ocjBtn_confirm];
  [ocjBtn_confirm mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.mas_equalTo(self.ocjView_bottom);
    make.height.mas_equalTo(@44);
  }];
  //不使用抵用券
  self.ocjBtn_nouse = [[UIButton alloc] init];
  [self.ocjBtn_nouse setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
  [self.ocjBtn_nouse addTarget:self action:@selector(ocj_clickedNouseBtn:) forControlEvents:UIControlEventTouchUpInside];
  self.ocjBtn_nouse.selected = NO;
  [self.ocjView_bottom addSubview:self.ocjBtn_nouse];
  [self.ocjBtn_nouse mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.ocjView_bottom);
    make.left.mas_equalTo(self.ocjView_bottom.mas_left).offset(10);
    make.bottom.mas_equalTo(ocjBtn_confirm.mas_top).offset(0);
    make.width.mas_equalTo(@30);
  }];
  //label
  UILabel *ocjLab_nouse = [[UILabel alloc] init];
  ocjLab_nouse.text = @"不使用抵用券";
  ocjLab_nouse.font = [UIFont systemFontOfSize:14];
  ocjLab_nouse.textColor = OCJ_COLOR_DARK;
  ocjLab_nouse.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_bottom addSubview:ocjLab_nouse];
  [ocjLab_nouse mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjBtn_nouse.mas_right).offset(0);
    make.centerY.mas_equalTo(self.ocjBtn_nouse);
  }];
}

/**
 tableView
 */
- (void)ocj_addTableView {
  self.ocjTBView_coupon = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.ocjTBView_coupon.delegate = self;
  self.ocjTBView_coupon.dataSource = self;
  self.ocjTBView_coupon.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.ocjView_container addSubview:self.ocjTBView_coupon];
  [self.ocjTBView_coupon mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self.ocjView_container);
    make.top.mas_equalTo(self.ocjView_header.mas_bottom).offset(0);
    make.bottom.mas_equalTo(self.ocjView_bottom.mas_top).offset(0);
  }];
}

/**
 tableview headerView
 */
- (void)ocj_addHeaderView {
  self.ocjView_header = [[UIView alloc] init];
  self.ocjView_header.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self.ocjView_container addSubview:self.ocjView_header];
  [self.ocjView_header mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self.ocjView_container);
    make.top.mas_equalTo(self.ocjView_top.mas_bottom).offset(0);
    make.height.mas_equalTo(@60);
  }];
  
  UIView *ocjView_line = [[UIView alloc] init];
  ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
  [self.ocjView_header addSubview:ocjView_line];
  [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_header.mas_left).offset(15);
    make.right.mas_equalTo(self.ocjView_header.mas_right).offset(-15);
    make.bottom.mas_equalTo(self.ocjView_header);
    make.height.mas_equalTo(@0.5);
  }];
  
  UILabel *ocjLab_exchange = [[UILabel alloc] init];
  ocjLab_exchange.text = @"兑换码";
  ocjLab_exchange.font = [UIFont systemFontOfSize:14];
  ocjLab_exchange.textColor = OCJ_COLOR_DARK;
  ocjLab_exchange.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_header addSubview:ocjLab_exchange];
  [ocjLab_exchange mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ocjView_line);
    make.centerY.mas_equalTo(self.ocjView_header);
  }];
  //兑换按钮
  self.ocjBtn_exchange = [[OCJBaseButton alloc] init];
  self.ocjBtn_exchange.backgroundColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
  self.ocjBtn_exchange.layer.cornerRadius = 2;
  [self.ocjBtn_exchange setTitle:@"兑换" forState:UIControlStateNormal];
  self.ocjBtn_exchange.userInteractionEnabled = NO;
  self.ocjBtn_exchange.alpha = 0.2;
  [self.ocjBtn_exchange setTitleColor:OCJ_COLOR_BACKGROUND forState:UIControlStateNormal];
  self.ocjBtn_exchange.titleLabel.font = [UIFont systemFontOfSize:14];
  [self.ocjBtn_exchange addTarget:self action:@selector(ocj_clickedExchangeBtn) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_header addSubview:self.ocjBtn_exchange];
  [self.ocjBtn_exchange mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(ocjView_line.mas_right).offset(0);
    make.centerY.mas_equalTo(ocjLab_exchange);
    make.width.mas_equalTo(40);
    make.height.mas_equalTo(@20);
  }];
  //tf
  self.ocjTF_coupon = [[OCJBaseTextField alloc] init];
  self.ocjTF_coupon.placeholder = @"请输入兑换码";
  self.ocjTF_coupon.keyboardType = UIKeyboardTypeDefault;
  self.ocjTF_coupon.tintColor = [UIColor redColor];
  self.ocjTF_coupon.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.ocjTF_coupon.textAlignment = NSTextAlignmentLeft;
  self.ocjTF_coupon.font = [UIFont systemFontOfSize:14];
  [self.ocjTF_coupon addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
  self.ocjTF_coupon.textColor = OCJ_COLOR_DARK_GRAY;
  [self.ocjView_header addSubview:self.ocjTF_coupon];
  [self.ocjTF_coupon mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjBtn_exchange.mas_left).offset(-10);
    make.left.mas_equalTo(ocjLab_exchange.mas_right).offset(10);
    make.height.mas_equalTo(@20);
    make.centerY.mas_equalTo(ocjLab_exchange);
  }];
}

- (void)ocj_textFieldValueChanged:(UITextField *)currentTF {
  if ([self.ocjTF_coupon.text length] > 0) {
    self.ocjBtn_exchange.userInteractionEnabled = YES;
    self.ocjBtn_exchange.alpha = 1.0;
  }else {
    self.ocjBtn_exchange.userInteractionEnabled = NO;
    self.ocjBtn_exchange.alpha = 0.2;
  }
}

/**
 关闭弹窗
 */
- (void)ocj_closeAction {
  self.ocjView_bg.userInteractionEnabled = NO;
  [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    
    self.ocjView_container.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH / 2.0 - 20);
    
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

/**
 兑换
 */
- (void)ocj_clickedExchangeBtn {
  __weak OCJCouponPopView *weakSelf = self;
  [OCJHttp_myWalletAPI ocjWallet_exchangeTaoCouponWithCouponNO:self.ocjTF_coupon.text completionhandler:^(OCJBaseResponceModel *responseModel) {
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
      [weakSelf.ocjTBView_coupon reloadData];
    }
  }];
}

/**
 确定
 */
- (void)ocj_clickedConfirmBtn {
    if (self.ocjSelectedCouponBlock) {
      self.ocjSelectedCouponBlock(self.ocjModel_last);
    }
  [UIView animateWithDuration:0.5f animations:^{
    self.ocjView_container.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT / 3.0 * 2);
  }completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

/**
 不使用优惠券
 */
- (void)ocj_clickedNouseBtn:(UIButton *)ocjBtn {
  if (!ocjBtn.selected) {
    [ocjBtn setImage:[UIImage imageNamed:@"Icon_selected"] forState:UIControlStateNormal];
  }else {
    [ocjBtn setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
  }
  ocjBtn.selected = !ocjBtn.selected;
  self.ocjModel_last = nil;
  [self.ocjTBView_coupon reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (!(self.ocjArr_couponList.count > 0)) {
    return 0;
  }
  return self.ocjArr_couponList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak OCJCouponPopView *weakSelf = self;
  if (indexPath.row == 0) {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *ocjLab_title = [[UILabel alloc] init];
    ocjLab_title.text = @"可用优惠券";
    ocjLab_title.font = [UIFont systemFontOfSize:14];
    ocjLab_title.textColor = OCJ_COLOR_DARK;
    ocjLab_title.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.mas_equalTo(cell.contentView);
      make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
    }];
    UILabel *ocjLab_tip = [[UILabel alloc] init];
    ocjLab_tip.text = @"（以下是您账户里可用于该商品的优惠券）";
    ocjLab_tip.font = [UIFont systemFontOfSize:12];
    ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"#2A2A2A"];
    ocjLab_tip.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:ocjLab_tip];
    [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.mas_equalTo(cell.contentView);
      make.left.mas_equalTo(ocjLab_title.mas_right).offset(0);
    }];
    [cell.contentView addSubview:ocjLab_tip];
    return cell;
  }
  
  OCJSelectCouponTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJSelectCouponTVCellIdentifier"];
  [cell ocj_loadDataWithModel:self.ocjArr_couponList[indexPath.row - 1] andCouponNO:self.ocjModel_last.ocjStr_couponNo];
  cell.ocjChooseCouponBlock = ^(OCJResponceModel_coupon *ocjModel_select) {
    OCJLog(@"couponno = %@", ocjModel_select.ocjStr_couponNo);
    [weakSelf.ocjBtn_nouse setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
    weakSelf.ocjBtn_nouse.selected = NO;
    weakSelf.ocjModel_last = ocjModel_select;
    [weakSelf.ocjTBView_coupon reloadData];
  };
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    return 40;
  }
  return 112;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
