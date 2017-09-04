//
//  OCJAppointmentOrderVC.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJAppointmentOrderVC.h"
#import "OCJManageAddressCell.h"
#import "OCJAppointmentGoodsTVCell.h"
#import "OCJContactMeTVCell.h"
#import "OCJPaymentModeTVCell.h"
#import "OCJDistributionTimeTVCell.h"
#import "OCJSelectCouponTVCell.h"
#import "OCJPayTVCell.h"
#import "OCJAccountTVCell.h"
#import "OCJSelectAddressVC.h"
#import "OCJResModel_addressControl.h"
#import "OCJCouponPopView.h"
#import "OCJAppointmentCouponTVCell.h"
#import "OCJNoAddressTVCell.h"
#import "OCJEditAddressVC.h"
#import "OCJLoginVC.h"
#import "OCJHttp_orderConfirmAPI.h"
#import "OCJResponseModel_confirmOrder.h"
#import "OCJPaySuccessVC.h"
#import "OCJ_RN_WebViewVC.h"

@interface OCJAppointmentOrderVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_appointment;      ///<预约订单

@property (nonatomic,strong) UIImage* ocjImage_frontNaviBG;                 ///<titleBG颜色
@property (nonatomic,strong) UIColor* ocjColor_frontNaviTint;               ///<返回按钮颜色
@property (nonatomic, assign) BOOL ocjBool_isAppointment;                   ///<是否可预约

@property (nonatomic, strong) UILabel *ocjLab_money;                        ///<应付金额
@property (nonatomic, strong) UIButton *ocjBtn_appointment;                 ///<预约按钮

@property (nonatomic, strong) UIView *ocjView_bottom;                       ///<底部view
@property (nonatomic, strong) UIView *ocjView_address;                      ///<
@property (nonatomic, strong) UILabel *ocjLab_address;                      ///<地址
@property (nonatomic, strong) NSString *ocjStr_address;                     ///<选中地址
@property (nonatomic, assign) CGFloat ocjFloat_address;                     ///<地址label高度

@property (nonatomic, strong) UITextField *ocjTF_score;                     ///<积分
@property (nonatomic, strong) UITextField *ocjTF_prePay;                    ///<预付款
@property (nonatomic, strong) UITextField *ocjTF_record;                    ///<礼包

@property (nonatomic, strong) NSString *ocjStr_score;                       ///<可用积分
@property (nonatomic, strong) NSString *ocjStr_prePay;                      ///<可用预付款
@property (nonatomic, strong) NSString *ocjStr_record;                      ///<可用礼包

@property (nonatomic, strong) UILabel *ocjLab_score;                        ///<抵用积分
@property (nonatomic, strong) UILabel *ocjLab_prePay;                       ///<抵用预付款
@property (nonatomic, strong) UILabel *ocjLab_record;                       ///<抵用礼包
@property (nonatomic, strong) UILabel *ocjLab_scoreTip;                     ///<剩余积分
@property (nonatomic, strong) UILabel *ocjLab_prePayTip;                    ///<剩余预付款
@property (nonatomic, strong) UILabel *ocjLab_recordTip;                    ///<剩余礼包

@property (nonatomic, strong) OCJResponceModel_confirmOrder *ocjModel_order;///<生成预约订单model
@property (nonatomic, strong) OCJAddressModel_listDesc *ocjModel_address;   ///<选择地址返回数据
@property (nonatomic, strong) OCJResponceModel_GoodsDetail *ocjModel_goods; ///<商品信息model
@property (nonatomic, strong) OCJResponceModel_orderDetail *ocjModel_orderDetail;///<订单详情model
@property (nonatomic, strong) NSArray *ocjArr_couponList;                   ///<可用抵用券列表
@property (nonatomic, assign) CGFloat ocjFloat_giftViewHeight;              ///<赠品信息viewHeight
@property (nonatomic, strong) NSString *ocjStr_payAmount;                   ///<应付金额
@property (nonatomic, strong) NSString *ocjStr_couponName;                  ///<抵用券名称
@property (nonatomic, assign) double ocjFloat_couponReduce;                 ///<抵用券减免金额

@property (nonatomic, strong) NSString *ocJStr_accessToken;                 ///<登录token
@property (nonatomic, strong) NSMutableDictionary *ocjDic_orderConfirm;     ///<填写预约订单信息记录
@end

@implementation OCJAppointmentOrderVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)
- (NSMutableDictionary *)ocjDic_orderConfirm {
  if (!_ocjDic_orderConfirm) {
    _ocjDic_orderConfirm = [[NSMutableDictionary alloc] init];
  }
  return _ocjDic_orderConfirm;
}

/**
 请求预约订单信息
 */
- (void)ocj_requestOrderDetail {
  [OCJHttp_orderConfirmAPI ocjShoppingCart_createAppointmentOrderWithDictionary:self.ocjDic_orderConfirm completionHandler:^(OCJBaseResponceModel *responseModel) {
    self.ocjModel_order = (OCJResponceModel_confirmOrder *)responseModel;
    if ([self.ocjModel_order.ocjStr_code isEqualToString:@"200"]) {
      self.ocjBool_isAppointment = YES;
      [self.ocjDic_orderConfirm setValue:@"2" forKey:@"pay_mthd"];
      [self ocj_setDatas];
      
      [self.ocjTBView_appointment reloadData];
    }else {
      [self.navigationController popViewControllerAnimated:YES];
    }
  }];
}

/**
 点击我要预约按钮
 */
- (void)ocj_clickedAppoinmentBtnAction {
  [OCJHttp_orderConfirmAPI ocjShoppingCart_confirmAppointmentOrderWithItemcode:[self.ocjDic_orderConfirm objectForKey:@"item_code"] unitcode:[self.ocjDic_orderConfirm objectForKey:@"unit_code"] payMethod:[self.ocjDic_orderConfirm objectForKey:@"pay_mthd"] saveamt:self.ocjTF_score.text deposit:self.ocjTF_prePay.text savebouns:self.ocjTF_record.text receiverSeq:[self.ocjDic_orderConfirm objectForKey:@"receiver_seq"] itemCodeCoupon:[self.ocjDic_orderConfirm objectForKey:@"itemCodeCoupon"] dccouponAmt:[self.ocjDic_orderConfirm objectForKey:@"dccoupon_amt"] contactMe:[self.ocjDic_orderConfirm objectForKey:@"pay_flg"] completionhandler:^(OCJBaseResponceModel *responseModel) {
    
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      
      NSMutableArray *arr = [[NSMutableArray alloc] init];
      if ([responseModel.ocjDic_data isKindOfClass:[NSDictionary class]]) {
        NSString *ocjStr_orderno = [responseModel.ocjDic_data objectForKey:@"order_no"];
        [arr addObject:ocjStr_orderno];
        OCJPaySuccessVC *paySuccess = [[OCJPaySuccessVC alloc] initWithOrderNums:arr];
        [self ocj_pushVC:paySuccess];
      }
    }
  }];
}

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  [self ocj_setCustomNav];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  [self ocj_setDefaultNav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  [self ocj_setSelf];
  [self ocj_requestOrderDetail];
    // Do any additional setup after loading the view.
}

#pragma mark - 私有方法区域
-(void)ocj_loginedAndLoadNetWorkData{
  [self ocj_requestOrderDetail];
}

- (void)ocj_setDatas {
  self.ocjStr_score = self.ocjModel_order.ocjStr_score;//积分
  self.ocjStr_prePay = self.ocjModel_order.ocjStr_deposit;//预付款
  self.ocjStr_record = self.ocjModel_order.ocjStr_record;//礼包
  //商品信息
  OCJResponceModel_orders *ordersModel = self.ocjModel_order.ocjArr_orders[0];
  self.ocjModel_orderDetail = ordersModel.ocjArr_carts[0];
  self.ocjArr_couponList = ordersModel.ocjArr_coupon;
  self.ocjModel_goods = self.ocjModel_orderDetail.ocjModel_goods;
  //应付金额
  self.ocjStr_payAmount = self.ocjModel_goods.ocjStr_lastSellPrice;
  self.ocjLab_money.text = [NSString stringWithFormat:@"%.2f", [self.ocjStr_payAmount floatValue]];
  //收货地址
  self.ocjModel_address = self.ocjModel_order.ocjModel_receiver;
  self.ocjLab_address.text = [NSString stringWithFormat:@"%@%@", self.ocjModel_address.ocjStr_addrProCity, self.ocjModel_address.ocjStr_addrDetail];
  self.ocjFloat_address = [self ocj_calculateLabelHeightWithString:self.ocjLab_address.text];
  [self.ocjView_address mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(self.ocjFloat_address);
  }];
  //设置收货人序列号
  NSString *addressID = self.ocjModel_address.ocjStr_addressIDRN;
  [self.ocjDic_orderConfirm setValue:addressID forKey:@"receiver_seq"];
}

- (void)ocj_setSelf {
  self.ocJStr_accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:OCJAccessToken];
  
  self.ocjFloat_giftViewHeight = 0;
  self.ocjFloat_couponReduce = 0;
  self.ocjBool_isAppointment = NO;
  
  
  if ([self.ocjDic_router isKindOfClass:[NSDictionary class]]) {
    NSString *ocjStr_itemCode = [self.ocjDic_router objectForKey:@"item_code"];
    NSString *ocjStr_unitCode = [self.ocjDic_router objectForKey:@"unit_code"];
    NSString *ocjStr_qty = [self.ocjDic_router objectForKey:@"qty"];
    NSString *ocjStr_shopNo = [self.ocjDic_router objectForKey:@"shop_no"];
    NSString *ocjStr_giftItemCode = [self.ocjDic_router objectForKey:@"gift_item_code"];
    NSString *ocjStr_giftUnitCode = [self.ocjDic_router objectForKey:@"gift_unit_code"];
    NSString *ocjStr_giftPromoNo = [self.ocjDic_router objectForKey:@"giftPromo_no"];
    //填写订单信息
    [self.ocjDic_orderConfirm setValue:ocjStr_itemCode forKey:@"item_code"];
    [self.ocjDic_orderConfirm setValue:ocjStr_unitCode forKey:@"unit_code"];
    [self.ocjDic_orderConfirm setValue:ocjStr_qty forKey:@"qty"];
    [self.ocjDic_orderConfirm setValue:ocjStr_shopNo forKey:@"shop_no"];
    [self.ocjDic_orderConfirm setValue:ocjStr_giftItemCode forKey:@"gift_item_code"];
    [self.ocjDic_orderConfirm setValue:ocjStr_giftUnitCode forKey:@"gift_unit_code"];
    [self.ocjDic_orderConfirm setValue:ocjStr_giftPromoNo forKey:@"giftPromo_no"];
  }

  self.title = @"填写订单";
  
  [self ocj_addBottomView];
  [self ocj_addAddressLab];
  [self ocj_addTableView];
  
  [self.ocjTBView_appointment registerClass:[OCJManageAddressCell class] forCellReuseIdentifier:@"OCJManageAddressCellIdentifier"];
  [self.ocjTBView_appointment registerClass:[OCJAppointmentGoodsTVCell class] forCellReuseIdentifier:@"OCJAppointmentGoodsTVCellIdentifier"];
  [self.ocjTBView_appointment registerClass:[OCJContactMeTVCell class] forCellReuseIdentifier:@"OCJContactMeTVCellIdentifier"];
  [self.ocjTBView_appointment registerClass:[OCJPaymentModeTVCell class] forCellReuseIdentifier:@"OCJPaymentModeTVCellIdentifier"];
  [self.ocjTBView_appointment registerClass:[OCJDistributionTimeTVCell class] forCellReuseIdentifier:@"OCJDistributionTimeTVCellIdentifier"];
  [self.ocjTBView_appointment registerClass:[OCJAppointmentCouponTVCell class] forCellReuseIdentifier:@"OCJAppointmentCouponTVCellIdentifier"];
  [self.ocjTBView_appointment registerClass:[OCJPayTVCell_TF class] forCellReuseIdentifier:@"OCJPayTVCell_TFIdentifier"];
  [self.ocjTBView_appointment registerClass:[OCJAccountTVCell class] forCellReuseIdentifier:@"OCJAccountTVCellIdentifier"];
  [self.ocjTBView_appointment registerClass:[OCJNoAddressTVCell class] forCellReuseIdentifier:@"OCJNoAddressTVCellIdentifier"];
}

/**
 底部view
 */
- (void)ocj_addBottomView {
  self.ocjView_bottom = [[UIView alloc] init];
  self.ocjView_bottom.backgroundColor = OCJ_COLOR_BACKGROUND;
  [self.view addSubview:self.ocjView_bottom];
  [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.mas_equalTo(self.view);
    make.height.mas_equalTo(@44);
  }];
  //应付金额
  UILabel *ocjLab_pay = [[UILabel alloc] init];
  ocjLab_pay.text = @"应付金额：";
  ocjLab_pay.font = [UIFont systemFontOfSize:14];
  ocjLab_pay.textColor = OCJ_COLOR_DARK;
  ocjLab_pay.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_bottom addSubview:ocjLab_pay];
  [ocjLab_pay mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_bottom.mas_left).offset(15);
    make.centerY.mas_equalTo(self.ocjView_bottom);
  }];
  //￥
  UILabel *ocjLab_symbol = [[UILabel alloc] init];
  ocjLab_symbol.text = @"￥";
  ocjLab_symbol.font = [UIFont systemFontOfSize:12];
  ocjLab_symbol.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
  ocjLab_symbol.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_bottom addSubview:ocjLab_symbol];
  [ocjLab_symbol mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ocjLab_pay.mas_right).offset(0);
    make.bottom.mas_equalTo(ocjLab_pay);
  }];
  //金额
  self.ocjLab_money = [[UILabel alloc] init];
  self.ocjLab_money.font = [UIFont systemFontOfSize:18];
  self.ocjLab_money.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
  self.ocjLab_money.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_bottom addSubview:self.ocjLab_money];
  [self.ocjLab_money mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ocjLab_symbol.mas_right).offset(0);
    make.centerY.mas_equalTo(self.ocjView_bottom);
  }];
  //预约按钮
  self.ocjBtn_appointment = [[UIButton alloc] init];
  self.ocjBtn_appointment.backgroundColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
//  [self.ocjBtn_appointment setTitle:@"我要预约" forState:UIControlStateNormal];
//  [self.ocjBtn_appointment setTitleColor:[UIColor colorWSHHFromHexString:@"FEFEFE"] forState:UIControlStateNormal];
//  self.ocjBtn_appointment.titleLabel.font = [UIFont systemFontOfSize:15];
  [self.ocjBtn_appointment addTarget:self action:@selector(ocj_clickedAppoinmentBtnAction) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_bottom addSubview:self.ocjBtn_appointment];
  [self.ocjBtn_appointment mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.top.bottom.mas_equalTo(self.ocjView_bottom);
    make.width.mas_equalTo(@150);
  }];
  //
  UILabel *ocjLab_appointment = [[UILabel alloc] init];
  ocjLab_appointment.text = @"我要预约";
  ocjLab_appointment.font = [UIFont systemFontOfSize:12];
  ocjLab_appointment.textColor = [UIColor colorWSHHFromHexString:@"FEFEFE"];
  [self.ocjBtn_appointment addSubview:ocjLab_appointment];
  [ocjLab_appointment mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.ocjBtn_appointment.mas_top).offset(5);
    make.centerX.mas_equalTo(self.ocjBtn_appointment);
  }];
  //
  UIImageView *ocjImgView = [[UIImageView alloc] init];
  [ocjImgView setImage:[UIImage imageNamed:@"agreement"]];
  [self.ocjBtn_appointment addSubview:ocjImgView];
  [ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjBtn_appointment.mas_left).offset(5);
    make.bottom.mas_equalTo(self.ocjBtn_appointment.mas_bottom).offset(-5);
    make.width.height.mas_equalTo(@10);
  }];
  //
  UILabel *ocjLab_appointment2 = [[UILabel alloc] init];
  ocjLab_appointment2.text = @"我已阅读并接受东方购物退换货条款";
  ocjLab_appointment2.font = [UIFont systemFontOfSize:8];
  ocjLab_appointment2.textColor = [UIColor colorWSHHFromHexString:@"FEFEFE"];
  [self.ocjBtn_appointment addSubview:ocjLab_appointment2];
  [ocjLab_appointment2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(ocjImgView.mas_right).offset(2);
    make.right.mas_equalTo(self.ocjBtn_appointment.mas_right).offset(-2);
    make.centerY.mas_equalTo(ocjImgView);
  }];
  //line
  UIView *ocjView_line = [[UIView alloc] init];
  ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
  [self.ocjView_bottom addSubview:ocjView_line];
  [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.mas_equalTo(self.ocjView_bottom);
    make.height.mas_equalTo(@0.5);
  }];
  
}

/**
 地址
 */
- (void)ocj_addAddressLab {
  self.ocjView_address = [[UIView alloc] init];
  self.ocjView_address.backgroundColor = [UIColor colorWSHHFromHexString:@"#FCE9E6"];
  [self.view addSubview:self.ocjView_address];
  [self.ocjView_address mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self.view);
    make.bottom.mas_equalTo(self.ocjView_bottom.mas_top).offset(0);
    make.height.mas_equalTo(self.ocjFloat_address);
  }];
  
  self.ocjLab_address = [[UILabel alloc] init];
  self.ocjLab_address.backgroundColor = [UIColor colorWSHHFromHexString:@"#FCE9E6"];
  self.ocjLab_address.font = [UIFont systemFontOfSize:12];
  self.ocjLab_address.textColor = OCJ_COLOR_DARK;
  self.ocjLab_address.text = self.ocjStr_address;
  self.ocjLab_address.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_address addSubview:self.ocjLab_address];
  [self.ocjLab_address mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_address.mas_left).offset(15);
    make.right.mas_equalTo(self.ocjView_address.mas_right).offset(-15);
    make.bottom.top.mas_equalTo(self.ocjView_address);
  }];
}

/**
 tableView
 */
- (void)ocj_addTableView {
  self.ocjTBView_appointment = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  self.ocjTBView_appointment.delegate = self;
  self.ocjTBView_appointment.dataSource = self;
  self.ocjTBView_appointment.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:self.ocjTBView_appointment];
  [self.ocjTBView_appointment mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(self.view);
    make.top.mas_equalTo(self.mas_topLayoutGuide);
    make.bottom.mas_equalTo(self.ocjLab_address.mas_top).offset(0);
  }];
}

/**
 返回
 */
-(void)ocj_back{
  [super ocj_back];
  [self ocj_setDefaultNav];
}

/**
 设置自定义导航栏
 */
- (void)ocj_setCustomNav {
  UIImage *image = [UIImage imageNamed:@"icon_topbar_"];
  NSInteger leftCapWidth = image.size.width * 0.5;
  NSInteger topCapHeight = image.size.height * 0.5;
  UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
  
  self.ocjImage_frontNaviBG = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
  self.ocjColor_frontNaviTint =  self.navigationController.navigationBar.tintColor;
  [self.navigationController.navigationBar setBackgroundImage:newImage forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]};
}

/**
 设置导航栏为默认样式
 */
- (void)ocj_setDefaultNav {
  [self.navigationController.navigationBar setBackgroundImage:self.ocjImage_frontNaviBG forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.tintColor= self.ocjColor_frontNaviTint;
  self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17]};
}

/**
 改变字符串中特定字符字体大小
 */
- (NSMutableAttributedString *)ocj_changeStringColorWithString:(NSString *)oldStr andTitleFont:(NSInteger)font {
  NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
  for (int i = 0; i < oldStr.length; i++) {
    unichar c = [oldStr characterAtIndex:i];
    if ((c >= 48 && c <= 57)) {
      [newStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(i, 1)];
    }else {
      [newStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font-6] range:NSMakeRange(i, 1)];

    }
  }
  return newStr;
}

/**
 计算展示赠品view的高度
 */
- (CGFloat)ocj_calculateGiftViewHeightWithArray:(OCJResponceModel_orderDetail *)model {
  CGFloat viewHeight = 18 * model.ocjArr_gift.count + (model.ocjArr_gift.count - 1) * 4 + 21;
  if (model.ocjModel_goods.ocjArr_sxGifts.count > 0) {
    NSString *ocjStr_sxGift = [model.ocjModel_goods.ocjArr_sxGifts objectAtIndex:0];
    NSArray *tempArr = [ocjStr_sxGift componentsSeparatedByString:@"\r\n"];
    viewHeight += 18 * tempArr.count + 4 * (tempArr.count - 1);
  }
  return viewHeight;
}

/**
 根据字符串计算label高度
 */
- (CGFloat)ocj_calculateLabelHeightWithString:(NSString *)ocjStr {
  CGFloat labHeight;
  if (!([self.ocjModel_address.ocjStr_receiverName length] > 0)) {
    return 0;
  }else {
    CGRect rect = [ocjStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    labHeight = ceilf(rect.size.height) + 14;
  }
  
  return labHeight;
}

/**
 使用积分、预付款情况判断
 */
- (void)ocj_textFieldChanged:(UITextField *)textFiled {
  NSString *newScore = [self ocj_deleteCharactersINstring:self.ocjStr_score];
  NSString *newPrePay = [self ocj_deleteCharactersINstring:self.ocjStr_prePay];
  NSString *newRecord = [self ocj_deleteCharactersINstring:self.ocjStr_record];
  if (textFiled == self.ocjTF_score) {
    //计算最大可用积分
    double scoreMin = fminf([newScore doubleValue], [self.ocjStr_payAmount doubleValue] - [self.ocjTF_prePay.text doubleValue] - [self.ocjTF_record.text doubleValue] - self.ocjFloat_couponReduce);
    if ([self.ocjTF_score.text doubleValue] > scoreMin) {
      self.ocjTF_score.text = [NSString stringWithFormat:@"%.1f", scoreMin];
    }else {
      scoreMin = [self.ocjTF_score.text doubleValue];
    }
    self.ocjLab_score.text = [NSString stringWithFormat:@"抵￥%.f", scoreMin];
    self.ocjLab_scoreTip.text = [NSString stringWithFormat:@"可用%.2f积分", [newScore doubleValue] - scoreMin];
    //接口返回应付金额-积分-预付款-抵用券
    double payAmount = [self.ocjStr_payAmount doubleValue] - scoreMin - [self.ocjTF_prePay.text doubleValue] - [self.ocjTF_record.text doubleValue] - self.ocjFloat_couponReduce;
    self.ocjLab_money.text = [NSString stringWithFormat:@"%.2f", payAmount];
  }else if (textFiled == self.ocjTF_prePay) {
    //计算最大可用预付款
    double prePayMin = fminf([newPrePay doubleValue], [self.ocjStr_payAmount doubleValue] - [self.ocjTF_score.text doubleValue] - [self.ocjTF_record.text doubleValue] - self.ocjFloat_couponReduce);
    if ([self.ocjTF_prePay.text doubleValue] > prePayMin) {
      self.ocjTF_prePay.text = [NSString stringWithFormat:@"%.1f", prePayMin];
    }else {
      prePayMin = [self.ocjTF_prePay.text doubleValue];
    }
    self.ocjLab_prePay.text = [NSString stringWithFormat:@"抵￥%.f", prePayMin];
    self.ocjLab_prePayTip.text = [NSString stringWithFormat:@"可用%.2f预付款", [newPrePay doubleValue] - prePayMin];
    //接口返回应付金额-积分-预付款-抵用券
    double payAmount = [self.ocjStr_payAmount doubleValue] - prePayMin - [self.ocjTF_score.text doubleValue] - [self.ocjTF_record.text doubleValue] - self.ocjFloat_couponReduce;
    self.ocjLab_money.text = [NSString stringWithFormat:@"%.2f", payAmount];
  }else if (textFiled == self.ocjTF_record) {
    //计算最大可用礼包
    double recordMin = fminf([newRecord doubleValue], [self.ocjStr_payAmount doubleValue] - [self.ocjTF_score.text doubleValue] - [self.ocjTF_prePay.text doubleValue] - self.ocjFloat_couponReduce);
    if ([self.ocjTF_record.text doubleValue] > recordMin) {
      self.ocjTF_record.text = [NSString stringWithFormat:@"%.1f", recordMin];
    }else {
      recordMin = [self.ocjTF_record.text doubleValue];
    }
    self.ocjLab_record.text = [NSString stringWithFormat:@"抵￥%.f", recordMin];
    self.ocjLab_recordTip.text = [NSString stringWithFormat:@"可用%.2f礼包", [newRecord doubleValue] - recordMin];
    //接口返回应付金额-积分-预付款-抵用券
    double payAmount = [self.ocjStr_payAmount doubleValue] - recordMin - [self.ocjTF_score.text doubleValue] - [self.ocjTF_prePay.text doubleValue] - self.ocjFloat_couponReduce;
    self.ocjLab_money.text = [NSString stringWithFormat:@"%.2f", payAmount];
  }
}

/**
 指定字符取代字符串中指定字符
 */
- (NSString *)ocj_deleteCharactersINstring:(NSString *)ocjStr {
  NSString *newStr = [ocjStr stringByReplacingOccurrencesOfString:@"," withString:@""];
  return newStr;
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.ocjBool_isAppointment) {
    return 7;
  }
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if (section == 3) {
    return 2;
  }else if (section == 5) {
    return 3;
  }
  
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak OCJAppointmentOrderVC *weakSelf = self;
  if (indexPath.section == 0) {
    if ([self.ocJStr_accessToken length] > 0) {//已登录
      if (!([self.ocjModel_address.ocjStr_receiverName length] > 0)) {//已登录但是没有收货地址
        OCJNoAddressTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJNoAddressTVCellIdentifier"];
        cell.ocjView_notLogin.hidden = YES;
        
        return cell;
      }else {
        OCJManageAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJManageAddressCellIdentifier"];
        cell.ocjView_modify.hidden = NO;
        [cell loadData:self.ocjModel_address canEdit:NO];
        return cell;
      }
    }else {//未登录
      OCJNoAddressTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJNoAddressTVCellIdentifier"];
      cell.ocjOrderLoginBlock = ^{
        OCJLog(@"login");
        OCJLoginVC *loginVC = [[OCJLoginVC alloc] init];
        [weakSelf.navigationController pushViewController:loginVC animated:YES];
      };
      
      return cell;
    }
    
  }else if (indexPath.section == 1) {
    OCJAppointmentGoodsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJAppointmentGoodsTVCellIdentifier"];
    
    [cell ocj_loadDataWithDictionary:self.ocjModel_orderDetail giftViewHeight:self.ocjFloat_giftViewHeight];
    
    return cell;
  }else if (indexPath.section == 2) {
    OCJContactMeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJContactMeTVCellIdentifier"];
    cell.ocjContactMeBlock = ^(NSString *ocjStr_contact) {
      OCJLog(@"联系我 = %@", ocjStr_contact);
      [weakSelf.ocjDic_orderConfirm setValue:ocjStr_contact forKey:@"pay_flg"];
    };
    return cell;
  }else if (indexPath.section == 3) {
    if (indexPath.row == 0) {
      OCJPaymentModeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPaymentModeTVCellIdentifier"];
      cell.ocjChoosePaymentModeBlock = ^(NSString *ocjStr_payment) {
        OCJLog(@"支付方式 = %@", ocjStr_payment);
        [weakSelf.ocjDic_orderConfirm setValue:ocjStr_payment forKey:@"pay_mthd"];
      };
      return cell;
    }else {
      OCJDistributionTimeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJDistributionTimeTVCellIdentifier"];
      
      return cell;
    }
  }else if (indexPath.section == 4) {
    OCJAppointmentCouponTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJAppointmentCouponTVCellIdentifier"];
    if ([self.ocjStr_couponName length] > 0) {
      cell.ocjLab_coupon.text = self.ocjStr_couponName;
    }
    return cell;
  }else if (indexPath.section == 5) {
    if (indexPath.row == 0) {
      OCJPayTVCell_TF *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayTVCell_TFIdentifier"];
      cell.ocjLab_tip.text = [NSString stringWithFormat:@"可用%@积分", self.ocjStr_score];
      cell.ocjView_line.hidden = NO;
      cell.ocjStr_canScore = @"NO";
      self.ocjTF_score = cell.ocjTF_input;
      self.ocjLab_scoreTip = cell.ocjLab_tip;
      self.ocjLab_score = cell.ocjLab_fact;
      [self.ocjTF_score addTarget:self action:@selector(ocj_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
      
      return cell;
    }else if (indexPath.row == 1) {
      OCJPayTVCell_TF *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayTVCell_TFIdentifier"];
      cell.ocjLab_tip.text = [NSString stringWithFormat:@"可用%@预付款", self.ocjStr_prePay];
      cell.ocjView_line.hidden = NO;
      cell.ocjStr_canScore = @"NO";
      self.ocjTF_prePay = cell.ocjTF_input;
      self.ocjLab_prePayTip = cell.ocjLab_tip;
      self.ocjLab_prePay = cell.ocjLab_fact;
      [self.ocjTF_prePay addTarget:self action:@selector(ocj_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
      
      return cell;
    }else {
      OCJPayTVCell_TF *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayTVCell_TFIdentifier"];
      cell.ocjLab_tip.text = [NSString stringWithFormat:@"可用%@礼包", self.ocjStr_record];
      cell.ocjStr_canScore = @"NO";
      self.ocjTF_record = cell.ocjTF_input;
      self.ocjLab_recordTip = cell.ocjLab_tip;
      self.ocjLab_record = cell.ocjLab_fact;
      [self.ocjTF_record addTarget:self action:@selector(ocj_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
      
      return cell;
    }
  }else if (indexPath.section == 6) {
    OCJAccountTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJAccountTVCellIdentifier"];
    cell.ocjLab_totalPrice.text = [NSString stringWithFormat:@"￥%.1f", [self.ocjModel_order.ocjStr_totalPrice floatValue]];
    cell.ocjLab_reduce.text = [NSString stringWithFormat:@"-￥%.1f", [self.ocjModel_goods.ocjStr_reduce floatValue]];
    CGFloat couponReduce = [[weakSelf.ocjDic_orderConfirm objectForKey:@"dccoupon_amt"] floatValue];
    cell.ocjLab_coupon.text = [NSString stringWithFormat:@"-￥%.1f", couponReduce];
    cell.ocjPurchaseNotesBlock = ^{
      OCJ_RN_WebViewVC *webVC = [[OCJ_RN_WebViewVC alloc] init];
      webVC.ocjDic_router = @{@"url":@"http://m.ocj.com.cn/other/thh.jsp"};
      [weakSelf ocj_pushVC:webVC];
    };
    
    return cell;
  }
  
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 100;
  }else if (indexPath.section == 1) {
    self.ocjFloat_giftViewHeight = [self ocj_calculateGiftViewHeightWithArray:self.ocjModel_orderDetail];
    return 125 + self.ocjFloat_giftViewHeight;
  }else if (indexPath.section == 2) {
    return 58;
  }else if (indexPath.section == 3 || indexPath.section == 4) {
    return 52;
  }else if (indexPath.section == 5) {
    return 54;
  }
  return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (!(section == 0)) {
    UIView *ocjView_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    ocjView_header.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    return ocjView_header;
  }
  return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (!(section == 0)) {
    return 10;
  }
  return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak OCJAppointmentOrderVC *weakSelf = self;
  if (indexPath.section == 0) {
    if ([self.ocJStr_accessToken length] > 0) {
      OCJSelectAddressVC *addressVC = [[OCJSelectAddressVC alloc] init];
      addressVC.ocjSelectedAddrBlock = ^(OCJAddressModel_listDesc *listModel) {
        weakSelf.ocjModel_address = listModel;
        weakSelf.ocjLab_address.text = [NSString stringWithFormat:@"%@%@", listModel.ocjStr_addrProCity, listModel.ocjStr_addrDetail];
        [weakSelf.ocjDic_orderConfirm setValue:listModel.ocjStr_addressIDRN forKey:@"receiver_seq"];
        [weakSelf.ocjTBView_appointment reloadData];
      };
      [self ocj_setDefaultNav];
      [self ocj_pushVC:addressVC];
    }else {
      OCJEditAddressVC *editVC = [[OCJEditAddressVC alloc] initWithEditType:OCJEditType_add OCJManageAddressModel:nil OCJShopAddressHandler:^{
        [weakSelf.ocjTBView_appointment reloadData];
      }];
      [self ocj_setDefaultNav];
      [self ocj_pushVC:editVC];
    }
    
  }else if (indexPath.section == 4) {
    OCJCouponPopView *view = [[OCJCouponPopView alloc] initWithArray:self.ocjArr_couponList];
    view.ocjSelectedCouponBlock = ^(OCJResponceModel_coupon *ocjModel_selectCoupon) {
      [weakSelf.ocjDic_orderConfirm setValue:ocjModel_selectCoupon.ocjStr_couponAmt forKey:@"dccoupon_amt"];
      //TODO:字段拼接规则
      [weakSelf.ocjDic_orderConfirm setValue:ocjModel_selectCoupon.ocjStr_couponNo forKey:@"itemCodeCoupon"];
      if ([ocjModel_selectCoupon.ocjStr_couponName length] > 0) {
        weakSelf.ocjStr_couponName = ocjModel_selectCoupon.ocjStr_couponName;
      }else {
        weakSelf.ocjStr_couponName = @"不使用抵用券";
      }
      
      weakSelf.ocjFloat_couponReduce = [ocjModel_selectCoupon.ocjStr_couponAmt doubleValue];
      double payAmount = [weakSelf.ocjStr_payAmount doubleValue] - [weakSelf.ocjTF_score.text doubleValue] - [weakSelf.ocjTF_prePay.text doubleValue] - weakSelf.ocjFloat_couponReduce;
      if (payAmount < 0) {
        weakSelf.ocjLab_money.text = @"0.00";
      }else {
        weakSelf.ocjLab_money.text = [NSString stringWithFormat:@"%.2f", payAmount];
      }
      
      [weakSelf.ocjTBView_appointment reloadData];
    };
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.right.bottom.mas_equalTo(window);
    }];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
