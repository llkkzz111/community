    //
//  OCJPayCVCell.m
//  OCJ
//
//  Created by OCJ on 2017/5/15.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJPayCVCell.h"
#import "OCJSelectedView.h"
#import "OCJOtherPayView.h"
#import "OCJPayTVCell.h"
#import "OCJPayTVCell_Bottom.h"
#import "NSString+WSHHExtension.h"
#import "WSHHThirdPay.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "OCJTouchIDVerifyPopView.h"
#import "OCJPayMethodTVCell.h"

@interface OCJPayCVCell()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UIImageView      * ocjImg_bg;
@property (nonatomic,strong) UITextField      * ocjTF_score;
@property (nonatomic,strong) UITextField      * ocjTF_pre;
@property (nonatomic,strong) UITextField      * ocjTF_record;
@property (nonatomic,strong) UILabel          * ocjLab_discount; ///< 抵扣总金额
@property (nonatomic,strong) UILabel          * ocjLab_real;     ///< 实际支付金额
@property (nonatomic,strong) UILabel          * ocjLab_score;    ///< 抵扣积分
@property (nonatomic,strong) UILabel          * ocjLab_deposit;  ///< 抵用预付款
@property (nonatomic,strong) UILabel          * ocjLab_cardAmt;  ///< 抵用礼包
@property (nonatomic,strong) OCJOtherPayModel * ocjModel_otherPay;///<支付方式model
@property (nonatomic,strong) UILabel          * avaliableScoreL;  ///< 显示剩余可用积分
@property (nonatomic,strong) UILabel          * avaliableDeposit; ///< 显示剩余可用预付款
@property (nonatomic,strong) UILabel          * avaliableCardAmt; ///< 显示剩余可用礼包

@property (nonatomic,strong) NSMutableArray *ocjArr_useScore;     ///< 可用积分、预付款、礼包

@property (nonatomic,strong) UIButton         * ocjBtn_allScore;  ///<一键积分按钮
@property (nonatomic,strong) UIButton         * ocjBtn_allDeposit;///<一键预付款按钮
@property (nonatomic,strong) UIButton         * ocjBtn_allCardAmt;///<一键礼包按钮

@property (nonatomic) BOOL ocjBool_isVerify;                     ///<是否指纹验证失败
@property (nonatomic) BOOL ocjBool_isScore;                      ///<是否使用了积分、预付款、礼包
@property (nonatomic, strong) NSString *ocjStr_touchID;          ///<指纹验证结果

@property (nonatomic) BOOL ocjBool_allScore;                     ///<是否一键积分
@property (nonatomic) BOOL ocjBool_allDeposit;                   ///<是否一键预付款
@property (nonatomic) BOOL ocjBool_allCardAmt;                   ///<是否一键礼包
@property (nonatomic, strong) OCJOtherPayModel *ocjModel_select; ///<选中的支付方式
@property (nonatomic) BOOL ocjBool_hideOnLinePay;                ///<是否隐藏在线支付立减

@property (nonatomic,strong) NSMutableArray* ocjArr_payTest; ///< 测试支付策略

@end

@implementation OCJPayCVCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.userInteractionEnabled=  YES;
        self.ocjBool_isVerify = NO;
        self.ocjBool_isScore = NO;
        self.ocjBool_allScore = NO;
        self.ocjBool_allDeposit = NO;
        self.ocjBool_allCardAmt = NO;
        self.ocjBool_hideOnLinePay = NO;
        self.ocjModel_select = [[OCJOtherPayModel alloc] init];
        [self ocj_addView];     ///< 添加视图
        [self ocj_updateFrame]; ///< 添加约束
    }
    return self;
}

- (void)ocj_addView{
    [self.contentView addSubview:self.ocjImg_bg];
    [self.contentView addSubview:self.ocj_tableView];
    
}

- (void)ocj_updateFrame{
    [self.ocjImg_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).mas_equalTo(UIEdgeInsetsMake(0,-3, 0, -3));
    }];
    
    [self.ocj_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).mas_equalTo(UIEdgeInsetsMake(18, 5, 8, 5));
    }];
    
}

#pragma mark - setter

-(void)setOcjModel_onLine:(OCJModel_onLinePay *)ocjModel_onLine{
  _ocjModel_onLine = ocjModel_onLine;
  
  self.ocjTF_pre = nil;
  self.ocjTF_score = nil;
  self.ocjTF_record = nil;
  self.ocjBool_hideOnLinePay = NO;
  self.ocjBool_isVerify = NO;
  self.ocjBool_isScore = NO;
  
  [self ocj_canUseScoreCardDespositWithModel:ocjModel_onLine];
  
  [self.ocj_tableView reloadData];
}

/**
 判断是否可以使用积分、礼包、预付款
 */
- (void)ocj_canUseScoreCardDespositWithModel:(OCJModel_onLinePay *)model {
  [self.ocjArr_useScore removeAllObjects];
  
  if ([model.ocjStr_useSaveamt isEqualToString:@"yes"] && ![model.ocjStr_useable_saveamt isEqualToString:@"0"]) {
    NSDictionary *dic = @{@"money":model.ocjStr_useable_saveamt,
                          @"title":@"积分"};
    [self.ocjArr_useScore addObject:dic];
  }
  if ([model.ocjStr_useDesposit isEqualToString:@"yes"] && ![model.ocjStr_useable_deposit isEqualToString:@"0"]) {
    NSDictionary *dic = @{@"money":model.ocjStr_useable_deposit,
                          @"title":@"预付款"};
    [self.ocjArr_useScore addObject:dic];
  }
  if ([model.ocjStr_useCardamt isEqualToString:@"yes"] && ![model.ocjStr_useable_cardamt isEqualToString:@"0"]) {
    NSDictionary *dic = @{@"money":model.ocjStr_useable_cardamt,
                          @"title":@"礼包"};
    [self.ocjArr_useScore addObject:dic];
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
 计算可用积分
 */
- (void)ocj_calculateUsingScoreWithType:(NSInteger)type inputNum:(CGFloat)inputNum {

  double preNum = [self.ocjTF_pre.text doubleValue];         //预付款使用数值
  double recordNum = [self.ocjTF_record.text doubleValue];   //礼包使用数值
  
  double goodsPrice = [[self.ocjModel_onLine.ocjStr_realPayAmt stringByReplacingOccurrencesOfString:@"," withString:@""]doubleValue];
  double maxScore = [[self.ocjModel_onLine.ocjStr_double_saveamt stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];   ///< 可用最大积分
  double realPayNum = goodsPrice - preNum - recordNum;///< 实际支付额
  
  double finalInputNum = fmin(realPayNum, maxScore);
  
  if (type == 1) {
    finalInputNum = fmin(inputNum, finalInputNum);
    realPayNum = realPayNum -finalInputNum; ///< 输入后实际支付金额
    if (inputNum > finalInputNum) {
      self.ocjTF_score.text = [NSString stringWithFormat:@"%g", finalInputNum];;
    }
  }else {
    realPayNum = realPayNum -finalInputNum; ///< 输入后实际支付金额
    self.ocjTF_score.text = [NSString stringWithFormat:@"%g", finalInputNum];
  }
  
  if (finalInputNum == 0) {
    self.ocjLab_score.text = [NSString stringWithFormat:@"抵￥%@",@"0"];
  }else {
    self.ocjLab_score.text = [NSString stringWithFormat:@"抵￥%g",finalInputNum];
  }
  
  double deductionNum = goodsPrice - realPayNum;                            ///< 实际抵扣总数
  double scoreDeduction = [self.ocjTF_score.text doubleValue];               ///< 积分抵扣数额
  
  self.ocjLab_discount.text = [NSString stringWithFormat:@"￥ %.2f",deductionNum];
  if (realPayNum >= 6) {
    self.ocjLab_real.text = [NSString stringWithFormat:@"￥%.2f", realPayNum - [self.ocjModel_onLine.ocjStr_onlineReduce floatValue]];
    if (self.ocjBool_hideOnLinePay) {
      self.ocjBool_hideOnLinePay = NO;
      [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
  }else {
    self.ocjLab_real.text  = [NSString stringWithFormat:@"￥ %.2f",realPayNum];
    
    if (!self.ocjBool_hideOnLinePay) {
      self.ocjBool_hideOnLinePay = YES;
      [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
  }

  self.avaliableScoreL.text = [NSString stringWithFormat:@"可用￥%.2f%@", maxScore - scoreDeduction, @"积分"];
}

/**
 计算可用预付款
 */
- (void)ocj_calculateUsingDepositWithType:(NSInteger)type inputNum:(CGFloat)inputNum {
  
  double scoreNum = [self.ocjTF_score.text doubleValue]; //积分使用数值
  double recordNum = [self.ocjTF_record.text doubleValue];   //积分使用数值
  
  double goodsPrice = [[self.ocjModel_onLine.ocjStr_realPayAmt stringByReplacingOccurrencesOfString:@"," withString:@""]doubleValue];
  double maxDeposit = [[self.ocjModel_onLine.ocjStr_useable_deposit stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];   ///< 可用最大预付款金额
  double realPayNum = goodsPrice - scoreNum - recordNum;///< 实际支付额
  double finalInputNum = fmin(realPayNum, maxDeposit);
  
  if (type == 1) {
    finalInputNum = fmin(inputNum, finalInputNum);
    realPayNum = realPayNum -finalInputNum; ///< 输入后实际支付金额
    if (inputNum > finalInputNum) {
      self.ocjTF_pre.text = [NSString stringWithFormat:@"%g", finalInputNum];;
    }
  }else {
    realPayNum = realPayNum -finalInputNum; ///< 输入后实际支付金额
    self.ocjTF_pre.text = [NSString stringWithFormat:@"%g", finalInputNum];
  }
  
  if (finalInputNum == 0) {
    self.ocjLab_deposit.text = [NSString stringWithFormat:@"抵￥%@",@"0"];
  }else {
    self.ocjLab_deposit.text = [NSString stringWithFormat:@"抵￥%g",finalInputNum];
  }
  
  double deductionNum = goodsPrice - realPayNum;                          ///< 实际抵扣总数
  double preDeduction = [self.ocjTF_pre.text doubleValue];                 ///< 预付款抵扣总数
  
  self.ocjLab_discount.text = [NSString stringWithFormat:@"￥ %.2f",deductionNum];
  if (realPayNum >= 6) {
    self.ocjLab_real.text = [NSString stringWithFormat:@"￥%.2f", realPayNum - [self.ocjModel_onLine.ocjStr_onlineReduce floatValue]];
    if (self.ocjBool_hideOnLinePay) {
      self.ocjBool_hideOnLinePay = NO;
      [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
  }else {
    self.ocjLab_real.text  = [NSString stringWithFormat:@"￥ %.2f",realPayNum];
    
    if (!self.ocjBool_hideOnLinePay) {
      self.ocjBool_hideOnLinePay = YES;
      [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
  }

  self.avaliableDeposit.text = [NSString stringWithFormat:@"可用￥%.2f%@", maxDeposit - preDeduction, @"预付款"];
  
}

/**
 计算可用礼包
 */
- (void)ocj_calculateUsingCardAmtWithType:(NSInteger)type inputNum:(CGFloat)inputNum {
  
  double scoreNum = [self.ocjTF_score.text doubleValue]; //积分使用数值
  double preNum = [self.ocjTF_pre.text doubleValue];  //预付款使用数值
  
  double goodsPrice = [[self.ocjModel_onLine.ocjStr_realPayAmt stringByReplacingOccurrencesOfString:@"," withString:@""]doubleValue];
  double maxCardamt = [[self.ocjModel_onLine.ocjStr_useable_cardamt stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];   ///< 可用最大礼包金额
  double realPayNum = goodsPrice - scoreNum - preNum;///< 输入前前实际支付额
  
  double finalInputNum = fmin(realPayNum, maxCardamt);
  
  if (type == 1) {
    finalInputNum = fmin(inputNum, finalInputNum);
    realPayNum = realPayNum -finalInputNum; ///< 输入后实际支付金额
    if (inputNum > finalInputNum) {
      self.ocjTF_record.text = [NSString stringWithFormat:@"%g", finalInputNum];
    }
  }else {
    realPayNum = realPayNum -finalInputNum; ///< 输入后实际支付金额
    self.ocjTF_record.text = [NSString stringWithFormat:@"%g", finalInputNum];
  }
  
  if (finalInputNum == 0) {
    self.ocjLab_cardAmt.text = [NSString stringWithFormat:@"抵￥%@",@"0"];
  }else {
    self.ocjLab_cardAmt.text = [NSString stringWithFormat:@"抵￥%g",finalInputNum];
  }
  
  double deductionNum = goodsPrice - realPayNum;                  ///< 实际抵扣总数
  double recordDeduction = [self.ocjTF_record.text doubleValue];  ///< 礼包抵扣总数
  
  self.ocjLab_discount.text = [NSString stringWithFormat:@"￥ %.2f",deductionNum];
  if (realPayNum >= 6) {
    self.ocjLab_real.text = [NSString stringWithFormat:@"￥%.2f", realPayNum - [self.ocjModel_onLine.ocjStr_onlineReduce floatValue]];
    if (self.ocjBool_hideOnLinePay) {
      self.ocjBool_hideOnLinePay = NO;
      [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
  }else {
    self.ocjLab_real.text  = [NSString stringWithFormat:@"￥ %.2f",realPayNum];
    
    if (!self.ocjBool_hideOnLinePay) {
      self.ocjBool_hideOnLinePay = YES;
      [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
  }
  self.avaliableCardAmt.text = [NSString stringWithFormat:@"可用￥%.2f%@", maxCardamt - recordDeduction, @"礼包"];
  
}

/**
 点击一键积分按钮
 */
- (void)ocj_clickedUseScoreBtnWithTextField:(UITextField *)tf {
  double goodPrice = [[self.ocjModel_onLine.ocjStr_realPayAmt stringByReplacingOccurrencesOfString:@"," withString:@""]doubleValue];
  double scoreNum = [self.ocjTF_score.text doubleValue]; //积分使用数值
  double preNum = [self.ocjTF_pre.text doubleValue];  //预付款使用数值
  double recordNum = [self.ocjTF_record.text doubleValue];   //积分使用数值
  if (tf == self.ocjTF_score) {
    double  maxScore   = [[self.ocjModel_onLine.ocjStr_double_saveamt stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];   ///< 可用最大积分
    double realPayNum = goodPrice - preNum - recordNum;///< 实际支付额
    
    if (self.ocjBool_allScore) {//一键积分
      
      [self ocj_calculateUsingScoreWithType:0 inputNum:0];
    }else {//取消一键积分
      self.avaliableScoreL.text = [NSString stringWithFormat:@"可用￥%.2f积分", maxScore];
      self.ocjLab_score.text = [NSString stringWithFormat:@"抵￥%@",@"0"];
      self.ocjTF_score.text = @"";
      
      double deductionNum = goodPrice - realPayNum;               ///< 实际抵扣总数
      self.ocjLab_discount.text = [NSString stringWithFormat:@"￥ %.2f",deductionNum];
      
      if (realPayNum >= 6) {
        self.ocjLab_real.text = [NSString stringWithFormat:@"￥%.2f", realPayNum - [self.ocjModel_onLine.ocjStr_onlineReduce floatValue]];
        if (self.ocjBool_hideOnLinePay) {
          self.ocjBool_hideOnLinePay = NO;
          [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
      }else {
        self.ocjLab_real.text  = [NSString stringWithFormat:@"￥ %.2f",realPayNum];
        
        if (!self.ocjBool_hideOnLinePay) {
          self.ocjBool_hideOnLinePay = YES;
          [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
      }
      //选中预付款、礼包
      if (self.ocjBool_allDeposit) {
        [self ocj_calculateUsingDepositWithType:0 inputNum:0];
      }
      if (self.ocjBool_allCardAmt) {
        [self ocj_calculateUsingCardAmtWithType:0 inputNum:0];
      }
    }
  }else if (tf == self.ocjTF_pre) {
    double  maxDeposit   = [[self.ocjModel_onLine.ocjStr_useable_deposit stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];   ///< 可用最大预付款金额
    
    double realPayNum = goodPrice - scoreNum - recordNum;///< 实际支付额
    //一键预付款
    if (self.ocjBool_allDeposit) {
      
      [self ocj_calculateUsingDepositWithType:0 inputNum:0];
    }else {//取消一键预付款
      self.avaliableDeposit.text = [NSString stringWithFormat:@"可用￥%.2f预付款", maxDeposit];
      self.ocjLab_deposit.text = [NSString stringWithFormat:@"抵￥%@",@"0"];
      self.ocjTF_pre.text = @"";
      
      double deductionNum = goodPrice - realPayNum;               ///< 实际抵扣总数
      self.ocjLab_discount.text = [NSString stringWithFormat:@"￥ %.2f",deductionNum];
      
      if (realPayNum >= 6) {
        self.ocjLab_real.text = [NSString stringWithFormat:@"￥%.2f", realPayNum - [self.ocjModel_onLine.ocjStr_onlineReduce floatValue]];
        if (self.ocjBool_hideOnLinePay) {
          self.ocjBool_hideOnLinePay = NO;
          [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
      }else {
        self.ocjLab_real.text  = [NSString stringWithFormat:@"￥ %.2f",realPayNum];
        
        if (!self.ocjBool_hideOnLinePay) {
          self.ocjBool_hideOnLinePay = YES;
          [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
      }
      //选中积分、礼包
      if (self.ocjBool_allScore) {
        [self ocj_calculateUsingScoreWithType:0 inputNum:0];
      }
      if (self.ocjBool_allCardAmt) {
        [self ocj_calculateUsingCardAmtWithType:0 inputNum:0];
      }
    }
  }else if (tf == self.ocjTF_record) {
    double  maxCardamt   = [[self.ocjModel_onLine.ocjStr_useable_cardamt stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue];   ///< 可用最大礼包金额
    double realPayNum = goodPrice - scoreNum - preNum;///< 输入前前实际支付额
    
    //一键礼包
    if (self.ocjBool_allCardAmt) {
      
      [self ocj_calculateUsingCardAmtWithType:0 inputNum:0];
    }else {//取消一键礼包
      self.avaliableCardAmt.text = [NSString stringWithFormat:@"可用￥%.2f礼包", maxCardamt];
      self.ocjLab_cardAmt.text = [NSString stringWithFormat:@"抵￥%@",@"0"];
      self.ocjTF_record.text = @"";
      
      double deductionNum = goodPrice - realPayNum;               ///< 实际抵扣总数
      self.ocjLab_discount.text = [NSString stringWithFormat:@"￥ %.2f",deductionNum];
      
      if (realPayNum >= 6) {
        self.ocjLab_real.text = [NSString stringWithFormat:@"￥%.2f", realPayNum - [self.ocjModel_onLine.ocjStr_onlineReduce floatValue]];
        if (self.ocjBool_hideOnLinePay) {
          self.ocjBool_hideOnLinePay = NO;
          [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
      }else {
        self.ocjLab_real.text  = [NSString stringWithFormat:@"￥ %.2f",realPayNum];
        
        if (!self.ocjBool_hideOnLinePay) {
          self.ocjBool_hideOnLinePay = YES;
          [self.ocj_tableView reloadSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
      }
      //选中积分、预付款
      if (self.ocjBool_allScore) {
        [self ocj_calculateUsingScoreWithType:0 inputNum:0];
      }
      if (self.ocjBool_allDeposit) {
        [self ocj_calculateUsingDepositWithType:0 inputNum:0];
      }
    }
  }
  
}

/**
 手动输入使用积分、预付款情况判断
 */
- (void)ocj_textFieldChanged:(UITextField *)textField {
  
  if (textField == self.ocjTF_score) {//积分
    self.ocjBool_allScore = NO;
    self.ocjBtn_allScore.selected = NO;
    [self.ocjBtn_allScore setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
    [self ocj_calculateUsingScoreWithType:1 inputNum:[self.ocjTF_score.text floatValue]];
    //选中预付款、礼包
    if (self.ocjBool_allDeposit) {
      [self ocj_calculateUsingDepositWithType:0 inputNum:0];
    }
    if (self.ocjBool_allCardAmt) {
      [self ocj_calculateUsingCardAmtWithType:0 inputNum:0];
    }
  }else if (textField == self.ocjTF_pre){//预付款
    
    self.ocjBool_allDeposit = NO;
    self.ocjBtn_allDeposit.selected = NO;
    [self.ocjBtn_allDeposit setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
    [self ocj_calculateUsingDepositWithType:1 inputNum:[self.ocjTF_pre.text floatValue]];
    //选中积分、礼包
    if (self.ocjBool_allScore) {
      [self ocj_calculateUsingScoreWithType:0 inputNum:0];
    }
    if (self.ocjBool_allCardAmt) {
      [self ocj_calculateUsingCardAmtWithType:0 inputNum:0];
    }
  }else if (textField == self.ocjTF_record){//礼包
    
    self.ocjBool_allCardAmt = NO;
    self.ocjBtn_allCardAmt.selected = NO;
    [self.ocjBtn_allCardAmt setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
    [self ocj_calculateUsingCardAmtWithType:1 inputNum:[self.ocjTF_record.text floatValue]];
    //选中积分、预付款
    if (self.ocjBool_allScore) {
      [self ocj_calculateUsingScoreWithType:0 inputNum:0];
    }
    if (self.ocjBool_allDeposit) {
      [self ocj_calculateUsingDepositWithType:0 inputNum:0];
    }
  }
}

/**
 手机系统版本
 */
- (NSString *)ocj_getSystemVersion {
  NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
  return systemVersion;
}

/**
 指纹验证失败(第一次、第二次时)点击其他按钮
 */
- (void)ocj_clickedTouchIDAlertOtherBtn {
  OCJLog(@"密码登录");
}

/**
 指纹3次验证失败弹出密码验证
 */
- (void)ocj_verify {
  self.ocjBool_isVerify = YES;
  [[NSUserDefaults standardUserDefaults] setValue:@"FALSE" forKey:@"TOUCHIDPAY"];
  __weak OCJPayCVCell *weakSelf = self;
  [OCJTouchIDVerifyPopView ocj_popTouchIDVerifyViewHandler:^(NSString *ocjStr_result) {
    if ([ocjStr_result isEqualToString:@"success"]) {
      [[NSUserDefaults standardUserDefaults] setValue:@"TRUE" forKey:@"TOUCHIDPAY"];
      [weakSelf ocj_jumpPayWithOrder:weakSelf.ocjModel_otherPay];
    }
  }];
}

/**
 指纹信息变更后需要对比本地指纹信息
  */
- (void)ocj_compareTouchIDWithNewData:(NSData *)newData {
  NSData *localData = [[NSUserDefaults standardUserDefaults] valueForKey:@"touchIDData"];
  
  if ([[self ocj_getSystemVersion] integerValue] > 9.0) {
    if ([localData isEqualToData:newData]) {
//      [OCJProgressHUD ocj_showHudWithTitle:@"指纹验证成功" andHideDelay:2.0];
      [self ocj_jumpPayWithOrder:self.ocjModel_otherPay];
    }else {
      [OCJProgressHUD ocj_showHudWithTitle:@"指纹信息变更，请重新验证" andHideDelay:2.0];
    }
    [[NSUserDefaults standardUserDefaults] setValue:@"TRUE" forKey:@"TOUCHIDPAY"];
  }
}

/**
 开启指纹验证
 */
- (void)ocj_openToucjID {
  __weak OCJPayCVCell *weakSelf = self;
  LAContext *myContext = [[LAContext alloc] init];
  //指纹认证失败（3次认证未通过）弹出框选项
  myContext.localizedFallbackTitle = @"";
  
  NSString *myLocallizeReasonString = @"通过Home键验证已有手机指纹";
  
  [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocallizeReasonString reply:^(BOOL success, NSError * _Nullable error) {
    if (success) {
      //验证成功，回到主线程，否则会卡顿
      dispatch_sync(dispatch_get_main_queue(), ^{
        //9.0以后才能使用此方法
        if ([[weakSelf ocj_getSystemVersion] integerValue] > 9.0) {
          NSData *data = myContext.evaluatedPolicyDomainState;
          
          [weakSelf ocj_compareTouchIDWithNewData:data];
        }else {
//          [OCJProgressHUD ocj_showHudWithTitle:@"指纹认证成功" andHideDelay:2.0];
          [weakSelf ocj_jumpPayWithOrder:weakSelf.ocjModel_otherPay];
          [[NSUserDefaults standardUserDefaults] setValue:@"TRUE" forKey:@"TOUCHIDPAY"];
        }
      });
    }
    if (error) {
      //认证失败，回到主线程
      dispatch_sync(dispatch_get_main_queue(), ^{
        LAError errorCode = error.code;
        OCJLog(@"123123123123123");
        
        switch (errorCode) {
          case LAErrorAuthenticationFailed:
            // -1 连续3次指纹识别错误
            [weakSelf ocj_verify];
            break;
          case LAErrorUserCancel:
            NSLog(@"用户取消验证!!!");// -2 点击了取消按钮
            break;
          case LAErrorUserFallback:
            //用户选择密码验证，切换到主线程处理 -3
            [weakSelf ocj_clickedTouchIDAlertOtherBtn];
            break;
          case  LAErrorSystemCancel:
            //系统取消授权，如其他应用切入 -4
            NSLog(@"系统取消授权");
            break;
          case LAErrorPasscodeNotSet:
            //设备系统未设置密码 -5
            NSLog(@"设备系统未设置密码");
            break;
          case LAErrorTouchIDNotAvailable:
            //设备未设置touchID -6
            NSLog(@"设备未设置touchID");
            break;
          case LAErrorTouchIDNotEnrolled:
            //用户未录入指纹 -7
            NSLog(@"用户未录入指纹");
            break;
          case LAErrorTouchIDLockout:
            //touchID被锁，需要用户输入密码解锁 -8(连续五次指纹识别错误)
            NSLog(@"touchID被锁，需要用户输入密码解锁");
            //弹出输入密码解锁界面(iOS9以后可用)
            if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil]) {
              [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:myLocallizeReasonString reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                  dispatch_sync(dispatch_get_main_queue(), ^{
                    //密码解锁成功
                    
                  });
                  
                }
              }];
            }else {
              [OCJProgressHUD ocj_showHudWithTitle:@"touchID被锁，请输入密码解锁" andHideDelay:2.0];
            }
            break;
          case LAErrorInvalidContext:
            //LAContext传递给这个调用之前已经失效 -10
            NSLog(@"LAContext传递给这个调用之前已经失效");
            break;
            
          default:
            break;
        }
      });
    }
  }];
}

/**
 跳转支付
 */
- (void)ocj_jumpPayWithOrder:(OCJOtherPayModel *)model {
  NSDictionary * userInfo = @{@"orderNo":self.ocjModel_onLine.ocjStr_order_no ? self.ocjModel_onLine.ocjStr_order_no:@"",@"userInfo":model,@"score":self.ocjTF_score?self.ocjTF_score.text :@"",@"pre":self.ocjTF_pre?self.ocjTF_pre.text:@"",@"record":self.ocjTF_record?self.ocjTF_record.text:@"",@"realMoney":self.ocjLab_real.text ? self.ocjLab_real.text : @""};
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"bankCardSelectedNotification" object:nil userInfo:userInfo];
}

#pragma mark - getter
- (NSMutableArray *)ocjArr_useScore {
  if (!_ocjArr_useScore) {
    _ocjArr_useScore = [[NSMutableArray alloc] init];
  }
  return _ocjArr_useScore;
}

- (UIImageView *)ocjImg_bg{
  if (!_ocjImg_bg) {
    _ocjImg_bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_bg"]];
    _ocjImg_bg.userInteractionEnabled = YES;
  }
  return _ocjImg_bg;
}

- (OCJBaseTableView *)ocj_tableView{
  if (!_ocj_tableView) {
    _ocj_tableView = [[OCJBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _ocj_tableView.backgroundColor = OCJ_COLOR_BACKGROUND;
    [_ocj_tableView registerClass:[OCJPayTVCell class]            forCellReuseIdentifier:@"OCJPayTVCellIdentifier"];
    [_ocj_tableView registerClass:[OCJPayTVCell_TF class]         forCellReuseIdentifier:@"OCJPayTVCell_TFIdentifier"];
    [_ocj_tableView registerClass:[OCJPayTVCell_Text class]       forCellReuseIdentifier:@"OCJPayTVCell_TextIdentifier"];
    [_ocj_tableView registerClass:[OCJPayTVCell_Text class]       forCellReuseIdentifier:@"OCJPayTVCellShopMoney_TextIdentifier"];
    [_ocj_tableView registerClass:[OCJPayTVCell_TextSecond class] forCellReuseIdentifier:@"OCJPayTVCell_TextSecondIdentifier"];
    [_ocj_tableView registerClass:[OCJPayTVCell_fact class]       forCellReuseIdentifier:@"OCJPayTVCell_factIdentifier"];
    [_ocj_tableView registerClass:[OCJPayTVCell_Bottom class]     forCellReuseIdentifier:@"OCJPayTVCell_BottomIdentifier"];
    [_ocj_tableView registerClass:[OCJPayTVCell_orderList class]  forCellReuseIdentifier:@"OCJPayTVCell_orderListIdentifier"];
    [_ocj_tableView registerClass:[OCJPayTVCell_onlineReduce class] forCellReuseIdentifier:@"OCJPayTVCell_onlineReduceIdentifier"];
    [_ocj_tableView registerClass:[OCJPayMethodTVCell class] forCellReuseIdentifier:@"OCJPayMethodTVCellIdentifier"];
    _ocj_tableView.separatorColor = [UIColor colorWSHHFromHexString:@"dddddd"];
    _ocj_tableView.dataSource = self;
    _ocj_tableView.delegate = self;
  }
  return _ocj_tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (section == 2) {
    
    return self.ocjArr_useScore.count;
    
  }else if (section == 5) {
    if ([self.ocjModel_onLine.ocjStr_onlineReduce floatValue] > 0 && self.ocjBool_hideOnLinePay == NO) {
      return 1;
    }else {
      return 0;
    }
  }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        return 40;
    }else if(indexPath.section == 1 ){
        return 80;
    }else if(indexPath.section == 2 ){
        return 40;
    }else if(indexPath.section == 3 ){
        return 48.5;
    }else if(indexPath.section == 4 ){
        return 23.5;
    }else if(indexPath.section == 5 || indexPath.section == 6){
        return 35;
    }else {
        return 168;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  __weak OCJPayCVCell *weakSelf = self;
    if (indexPath.section == 0) {
      
        OCJPayTVCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayTVCellIdentifier" forIndexPath:indexPath];
        cell.ocjLab_page.text = self.ocjStr_page;
        cell.ocjLab_order.text = [NSString stringWithFormat:@"订单编号:%@",self.ocjModel_onLine.ocjStr_order_no ? self.ocjModel_onLine.ocjStr_order_no:@""];
        if (self.ocjStr_page.length  == 4) {
            cell.ocjLab_page.font = [UIFont systemFontOfSize:11];
        }else if(self.ocjStr_page.length  == 5){
            cell.ocjLab_page.font = [UIFont systemFontOfSize:9];
        }
        return cell;
      
    }else if(indexPath.section == 1){
      
        OCJPayTVCell_orderList  * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayTVCell_orderListIdentifier" forIndexPath:indexPath];
        [cell ocj_setImgWithArray:self.ocjModel_onLine.ocjArr_imgUrlList];
        return cell;
      
    }else if(indexPath.section == 2 ){
      
      for (int i = 0; i < self.ocjArr_useScore.count; i++) {
        if (indexPath.row == i) {
          NSDictionary *dic = [self.ocjArr_useScore objectAtIndex:i];
          NSString *ocjStr_title = [dic objectForKey:@"title"];
          NSString *ocjStr_money = [dic objectForKey:@"money"];
          
          OCJPayTVCell_TF  * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayTVCell_TFIdentifier" forIndexPath:indexPath];
          cell.ocjLab_tip.text = [NSString stringWithFormat:@"可用￥%@%@",ocjStr_money ? ocjStr_money : @"0", ocjStr_title];
          cell.ocjLab_fact.text = @"抵¥0.00";
          
          if ([ocjStr_title isEqualToString:@"积分"]) {
            self.avaliableScoreL = cell.ocjLab_tip;
            self.ocjTF_score = cell.ocjTF_input;
//            self.ocjTF_score.delegate = self;
            self.ocjLab_score = cell.ocjLab_fact; ///< 抵用积分
            self.ocjBtn_allScore = cell.ocjBtn_select;
            [self.ocjTF_score addTarget:self action:@selector(ocj_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            cell.ocjUseAllScoreBlock = ^{
              weakSelf.ocjBool_allScore = !weakSelf.ocjBool_allScore;
              [weakSelf ocj_clickedUseScoreBtnWithTextField:weakSelf.ocjTF_score];
            };
          }else if ([ocjStr_title isEqualToString:@"预付款"]) {
            self.avaliableDeposit = cell.ocjLab_tip;
            self.ocjTF_pre = cell.ocjTF_input;
            self.ocjLab_deposit = cell.ocjLab_fact; ///< 抵用预付款
            self.ocjBtn_allDeposit = cell.ocjBtn_select;
            [self.ocjTF_pre addTarget:self action:@selector(ocj_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
//            self.ocjTF_pre.delegate = self;
            cell.ocjUseAllScoreBlock = ^{
              weakSelf.ocjBool_allDeposit = !weakSelf.ocjBool_allDeposit;
              [weakSelf ocj_clickedUseScoreBtnWithTextField:weakSelf.ocjTF_pre];
            };
          }else if ([ocjStr_title isEqualToString:@"礼包"]){
            self.avaliableCardAmt = cell.ocjLab_tip;
            self.ocjTF_record = cell.ocjTF_input;
//            self.ocjTF_record.delegate = self;
            self.ocjLab_cardAmt = cell.ocjLab_fact;
            self.ocjBtn_allCardAmt = cell.ocjBtn_select;
            [self.ocjTF_record addTarget:self action:@selector(ocj_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            cell.ocjUseAllScoreBlock = ^{
              weakSelf.ocjBool_allCardAmt = !weakSelf.ocjBool_allCardAmt;
              [weakSelf ocj_clickedUseScoreBtnWithTextField:weakSelf.ocjTF_record];
            };
          }
          
          [cell ocj_resetStatus];
          return cell;
        }
      }
      
    }else if(indexPath.section == 3){
        OCJPayTVCell_Text  * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayTVCellShopMoney_TextIdentifier" forIndexPath:indexPath];
        cell.ocjLab_tip.text = @"应付金额";
        [cell ocj_setshopMoney:self.ocjModel_onLine.ocjStr_realPayAmt];
        return cell;
    }else if(indexPath.section == 4){
        OCJPayTVCell_TextSecond  * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayTVCell_TextSecondIdentifier" forIndexPath:indexPath];
        cell.ocjLab_tip.text = @"抵扣总和";
        cell.ocjLab_fact.text = @"￥0";
        self.ocjLab_discount = cell.ocjLab_fact; ///< 抵扣总金额
        return cell;
    }else if (indexPath.section == 5) {
      OCJPayTVCell_onlineReduce *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayTVCell_onlineReduceIdentifier" forIndexPath:indexPath];
      cell.ocjLab_reduce.text = [NSString stringWithFormat:@"￥%@", self.ocjModel_onLine.ocjStr_onlineReduce];
      return cell;
      
    }
    else if(indexPath.section == 6){
        OCJPayTVCell_fact  * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayTVCell_factIdentifier" forIndexPath:indexPath];
        cell.ocjLab_fact.text = [NSString stringWithFormat:@"%.2f",[self.ocjModel_onLine.ocjStr_realPayAmt floatValue] ? [self.ocjModel_onLine.ocjStr_realPayAmt floatValue] - [self.ocjModel_onLine.ocjStr_onlineReduce floatValue] : 0];
        self.ocjLab_real = cell.ocjLab_fact;
        return cell;
    }else{
      
//      OCJPayMethodTVCell *payCell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayMethodTVCellIdentifier" forIndexPath:indexPath];
//      if ([self.ocjModel_select.ocjStr_title length] > 0) {
//        payCell.ocjModel_selected = self.ocjModel_select;
//      }
//      payCell.ocjModel_selected = nil;
//      payCell.ocjModel_onLine = self.ocjModel_onLine;
//      
//      payCell.ocjPayMethodblock = ^(OCJOtherPayModel *ocjModel_pay, NSString *ocjStr_pay) {
//        [weakSelf.ocjTF_score resignFirstResponder];
//        [weakSelf.ocjTF_pre resignFirstResponder];
//        [weakSelf.ocjTF_record resignFirstResponder];
//        if ([ocjStr_pay isEqualToString:@"YES"]) {//点击确认按钮去支付
//            
//            weakSelf.ocjModel_otherPay = ocjModel_pay;
//            //是否已开启touchID,已开启的情况下需要验证成功才能去支付
//            NSString *ocjStr_touchID = [[NSUserDefaults standardUserDefaults] valueForKey:@"TOUCHID"];
//          NSString *ocjStr_touchIDPay = [[NSUserDefaults standardUserDefaults] valueForKey:@"TOUCHIDPAY"];
//            if ([ocjStr_touchID isEqualToString:@"TouchIDOK"]) {
//              if ([ocjStr_touchIDPay isEqualToString:@"FALSE"]) {
//                weakSelf.ocjBool_isVerify = YES;
//              }
//              if (!weakSelf.ocjBool_isVerify) {//指纹验证失败时调用密码验证
//                [weakSelf ocj_openToucjID];
//              }else {
//                [weakSelf ocj_verify];
//              }
//              
//            }else {
//              [weakSelf ocj_jumpPayWithOrder:ocjModel_pay];
//            }
//        }else {
//          weakSelf.ocjModel_select = ocjModel_pay;
//        }
//        
//      };
//      
//      return payCell;
        OCJPayTVCell_Bottom  * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJPayTVCell_BottomIdentifier" forIndexPath:indexPath];

        cell.ocjModel_onLine    = self.ocjModel_onLine;
      
      //=================支付方式测试
//        [cell ocj_setSelectViewWithTitles:self.ocjModel_onLine.ocjArr_lastPayment];//正式
      [cell ocj_setSelectViewWithTitles:self.ocjArr_payTest];//测试
      
        cell.handler = ^(OCJOtherPayModel *bankCardModel, NSString *ocjStr_hide) {
          [weakSelf.ocjTF_score resignFirstResponder];
          [weakSelf.ocjTF_pre resignFirstResponder];
          [weakSelf.ocjTF_record resignFirstResponder];
          if ([ocjStr_hide isEqualToString:@"YES"]) {//点击确认按钮去支付
            
            weakSelf.ocjModel_otherPay = bankCardModel;
            //是否已开启touchID,已开启的情况下需要验证成功才能去支付
            NSString *ocjStr_touchID = [[NSUserDefaults standardUserDefaults] valueForKey:@"TOUCHID"];
            NSString *ocjStr_touchIDPay = [[NSUserDefaults standardUserDefaults] valueForKey:@"TOUCHIDPAY"];
            if ([ocjStr_touchID isEqualToString:@"TouchIDOK"]) {
              if ([ocjStr_touchIDPay isEqualToString:@"FALSE"]) {
                weakSelf.ocjBool_isVerify = YES;
              }
              if (!weakSelf.ocjBool_isVerify) {//指纹验证失败时调用密码验证
                [weakSelf ocj_openToucjID];
              }else {
                [weakSelf ocj_verify];
              }
              
            }else {
              [weakSelf ocj_jumpPayWithOrder:bankCardModel];
            }
          }else {
            weakSelf.ocjModel_select = bankCardModel;
          }
        };
        return cell;
    }
  return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        if (indexPath.section == 1) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        }else{
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
        }
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        if (indexPath.section == 1) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        }else{
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
        }
    }
}

-(NSMutableArray *)ocjArr_payTest{
  if (!_ocjArr_payTest) {
//    _ocjArr_payTest = [NSMutableArray arrayWithArray:@[@{@"title":@"银联支付",@"id":@"45"},@{@"title":@"浦发银行",@"id":@"46"},@{@"title":@"小浦支付",@"id":@"53"}]];
    _ocjArr_payTest = [NSMutableArray arrayWithArray:@[@{@"title":@"交行信用卡",@"id":@"51"},@{@"title":@"建设银行",@"id":@"8"}]];
  }
  return _ocjArr_payTest;
}

//#pragma mark - UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//  NSString* contentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
//  NSArray* arr = [contentText componentsSeparatedByString:@"."];
//  
//  
//  if ([string isEqualToString:@"."]) {//处理小数点
//    if ([textField.text containsString:@"."]) {
//      return NO;
//    }else{
//      return YES;
//    }
//  }else if (arr.count==2 && [arr[1] intValue]==0){
//    
//    return YES;
//  }else{
//    
//    return YES;
//  }
//}

@end


