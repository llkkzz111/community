//
//  OCJWalletRechargeVC.m
//  OCJ
//
//  Created by Ray on 2017/5/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJWalletRechargeVC.h"
#import "OCJLockSliderTVCell.h"
#import "OCJHttp_myWalletAPI.h"
#import "OCJResponceModel_myWallet.h"
#import "OCJGiftRemindVC.h"

static NSString * cellIdentifier = @"OCJLockSliderTVCell";//滑动验证cell

@interface OCJWalletRechargeVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, OCJLockSliderTVCellDelegete>

@property (nonatomic, strong) UITableView *ocjTBView_gift;        ///<tableview

@property (nonatomic, strong) UIView *ocjView_recharge;           ///<
@property (nonatomic, strong) OCJBaseButton *ocjBtn_recharge;     ///<钱包充值
@property (nonatomic, strong) OCJBaseButton *ocjBtn_checkBalance; ///<余额查询
@property (nonatomic, strong) UIView *ocjView_slider;             ///<红色滑块

@property (nonatomic, strong) OCJBaseLabel *ocjLab_title;         ///<提示label

@property (nonatomic, strong) OCJBaseTextField *ocjTF_giftNum;    ///<礼券序号

@property (nonatomic, strong) OCJBaseTextField *ocjTF_giftPwd;    ///<礼券密码

@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;      ///<确认按钮

@property (nonatomic, strong) NSMutableArray *ocjArr_recharge;    ///<钱包充值数据源
@property (nonatomic, strong) NSMutableArray *ocjArr_balance;     ///<余额数据源

@property (nonatomic, assign) NSInteger ocjInt_rechargeCount;     ///<钱包充值计数
@property (nonatomic, assign) NSInteger ocjInt_balanceCount;      ///<余额查询计数

@property (nonatomic, assign) BOOL isRecharge;                    ///<是否是充值界面

@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;         ///<状态栏颜色

@end

@implementation OCJWalletRechargeVC

#pragma mark - 接口方法实现区域(包括setter、getter方法)
- (NSMutableArray *)ocjArr_recharge {
    if (!_ocjArr_recharge) {
        _ocjArr_recharge = [[NSMutableArray alloc] init];
    }
    return _ocjArr_recharge;
}

- (NSMutableArray *)ocjArr_balance {
    if (!_ocjArr_balance) {
        _ocjArr_balance = [[NSMutableArray alloc] init];
    }
    return _ocjArr_balance;
}

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.ocjStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:self.ocjStatusBarStyle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
}

#pragma mark - 私有方法区域
-(void)ocj_back{
  [super ocj_back];
  
  [self ocj_trackEventID:@"AP1706C044C005001C003001" parmas:nil];
  
}

- (void)ocj_setSelf {
    self.ocjStr_trackPageID = @"AP1706C044";
  
    self.title = @"东方购物心意畅想礼包";
    self.isRecharge = YES;
  
    [self ocj_setRightItemTitles:@[@"使用说明"] selectorNames:@[NSStringFromSelector(@selector(ocj_usringInstructions))]];
  
    self.ocjArr_recharge = [NSMutableArray arrayWithArray:@[@{@"num":@""},@{@"pwd":@""},@{@"lock":@"NO",@"isCheckDone":@"NO"}]];
    self.ocjArr_balance = [NSMutableArray arrayWithArray:@[@{@"num":@""},@{@"pwd":@""},@{@"lock":@"NO",@"isCheckDone":@"NO"}]];
    
    self.ocjInt_rechargeCount = 0;
    self.ocjInt_balanceCount = 0;
    
    [self ocj_addRechargeView];
    [self ocj_addTableView];
}

- (void)ocj_addRechargeView {
    
    CGFloat btnWidth = SCREEN_WIDTH / 2;
    
    self.ocjView_recharge = [[UIView alloc] init];
    self.ocjView_recharge.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ocjView_recharge];
    [self.ocjView_recharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(@44);
    }];
    
    //钱包充值按钮
    self.ocjBtn_recharge = [[OCJBaseButton alloc] init];
    [self.ocjBtn_recharge setTitle:@"钱包充值" forState:UIControlStateNormal];
    [self.ocjBtn_recharge setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
    self.ocjBtn_recharge.ocjFont = [UIFont systemFontOfSize:14];
    [self.ocjBtn_recharge addTarget:self action:@selector(ocj_clickedRechargeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_recharge addSubview:self.ocjBtn_recharge];
    [self.ocjBtn_recharge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.ocjView_recharge);
        make.width.mas_equalTo(btnWidth);
    }];
    //竖线
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self.ocjView_recharge addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_recharge.mas_right).offset(0);
        make.top.mas_equalTo(self.ocjView_recharge.mas_top).offset(10);
        make.bottom.mas_equalTo(self.ocjView_recharge.mas_bottom).offset(-10);
        make.width.mas_equalTo(@0.5);
    }];
    //余额查询按钮
    self.ocjBtn_checkBalance = [[OCJBaseButton alloc] init];
    [self.ocjBtn_checkBalance setTitle:@"余额查询" forState:UIControlStateNormal];
    [self.ocjBtn_checkBalance setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
    self.ocjBtn_checkBalance.ocjFont = [UIFont systemFontOfSize:14];
    [self.ocjBtn_checkBalance addTarget:self action:@selector(ocj_clickedCheckBalanceBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_recharge addSubview:self.ocjBtn_checkBalance];
    [self.ocjBtn_checkBalance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(verticalLine.mas_right).offset(0);
        make.right.top.bottom.mas_equalTo(self.ocjView_recharge);
    }];
    //底部横线
    UIView *horizontalLine = [[UIView alloc] init];
    horizontalLine.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self.ocjView_recharge addSubview:horizontalLine];
    [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.ocjView_recharge);
        make.height.mas_equalTo(@0.5);
    }];
    
    //底部红色滑动线条
    self.ocjView_slider = [[UIView alloc] init];
    self.ocjView_slider.backgroundColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    [self.ocjView_recharge addSubview:self.ocjView_slider];
    [self.ocjView_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.ocjView_recharge);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(@1.5);
    }];
}


/**
 tableview
 */
- (void)ocj_addTableView {
    
    self.ocjTBView_gift = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.ocjTBView_gift.delegate = self;
    self.ocjTBView_gift.dataSource = self;
    self.ocjTBView_gift.scrollEnabled = NO;
    self.ocjTBView_gift.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_gift];
    [self.ocjTBView_gift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjView_recharge.mas_bottom).offset(0);
    }];
}


/**
 确认按钮
 */
- (void)ocj_addConfirmBtnWithCell:(UITableViewCell *)cell {
    self.ocjBtn_confirm = [[OCJBaseButton alloc] initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH - 30, 45)];
    [self.ocjBtn_confirm ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    self.ocjBtn_confirm.layer.cornerRadius = 2;
    
    [self ocj_isConfirmBtnUserInteractionEnabled];
    
    [self.ocjBtn_confirm setTitle:@"确认" forState:UIControlStateNormal];
    self.ocjBtn_confirm.ocjFont = [UIFont systemFontOfSize:17];
    [self.ocjBtn_confirm addTarget:self action:@selector(ocj_clickedConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:self.ocjBtn_confirm];
}

/**
 密码
 */
- (void)ocj_addGiftPwdViewWithCell:(UITableViewCell *)cell {
    UIView *giftPwdView = [[UIView alloc] init];
    [cell.contentView addSubview:giftPwdView];
    [giftPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-15);
        make.top.bottom.mas_equalTo(cell.contentView);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [giftPwdView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(giftPwdView);
        make.height.mas_equalTo(@0.5);
    }];
    
    OCJBaseLabel *title = [[OCJBaseLabel alloc] init];
    title.text = @"密码";
    title.textColor = OCJ_COLOR_DARK;
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentLeft;
    [giftPwdView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(giftPwdView);
        make.top.mas_equalTo(giftPwdView.mas_top).offset(30);
        make.bottom.mas_equalTo(lineView.mas_top).offset(0);
        make.width.mas_equalTo(@30);
    }];
    
    self.ocjTF_giftPwd = [[OCJBaseTextField alloc] init];
    self.ocjTF_giftPwd.textAlignment = NSTextAlignmentRight;
    self.ocjTF_giftPwd.keyboardType = UIKeyboardTypeNumberPad;
    self.ocjTF_giftPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ocjTF_giftPwd.placeholder = @"请输入密码";
    self.ocjTF_giftPwd.delegate = self;
    self.ocjTF_giftPwd.tintColor = [UIColor redColor];
    [self.ocjTF_giftPwd addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    if (self.isRecharge) {
        if ([[[self.ocjArr_recharge objectAtIndex:1] objectForKey:@"pwd"] length] > 0) {
            self.ocjTF_giftPwd.text = [[self.ocjArr_recharge objectAtIndex:1] objectForKey:@"pwd"];
        }
    }else {
        if ([[[self.ocjArr_balance objectAtIndex:1] objectForKey:@"pwd"] length] > 0) {
            self.ocjTF_giftPwd.text = [[self.ocjArr_balance objectAtIndex:1] objectForKey:@"pwd"];
        }
    }
    
    [giftPwdView addSubview:self.ocjTF_giftPwd];
    [self.ocjTF_giftPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(giftPwdView);
        make.top.mas_equalTo(giftPwdView.mas_top).offset(30);
        make.left.mas_equalTo(title.mas_right).offset(5);
        make.bottom.mas_equalTo(lineView.mas_top).offset(0);
    }];
    
}

/**
 卡号
 */
- (void)ocj_addInputGiftNumViewWithCell:(UITableViewCell *)cell {
    UIView *giftNumView = [[UIView alloc] init];
    [cell.contentView addSubview:giftNumView];
    [giftNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-15);
        make.top.bottom.mas_equalTo(cell.contentView);
    }];
    
    if (self.isRecharge) {
        self.ocjLab_title = [[OCJBaseLabel alloc] init];
        self.ocjLab_title.text = @"请输入礼包背面的卡号和密码，将余额转存为东方购物心意畅想礼包账户";
        self.ocjLab_title.textColor = OCJ_COLOR_DARK_GRAY;
        self.ocjLab_title.numberOfLines = 2;
        self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
        self.ocjLab_title.font = [UIFont systemFontOfSize:14];
        [giftNumView addSubview:self.ocjLab_title];
        [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(giftNumView.mas_left).offset(0);
            make.top.mas_equalTo(giftNumView.mas_top).offset(15);
            make.right.mas_equalTo(giftNumView.mas_right).offset(-15);
            make.height.mas_equalTo(@44);
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [giftNumView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(giftNumView);
        make.height.mas_equalTo(@0.5);
    }];
    
    OCJBaseLabel *title = [[OCJBaseLabel alloc] init];
    title.text = @"卡号";
    title.textColor = OCJ_COLOR_DARK;
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentLeft;
    [giftNumView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(giftNumView);
        if (self.isRecharge) {
            make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(32);
        }else {
            make.top.mas_equalTo(giftNumView.mas_top).offset(30);
        }
        make.bottom.mas_equalTo(lineView.mas_top).offset(0);
        make.width.mas_equalTo(@30);
    }];
    
    self.ocjTF_giftNum = [[OCJBaseTextField alloc] init];
    self.ocjTF_giftNum.textAlignment = NSTextAlignmentRight;
    self.ocjTF_giftNum.keyboardType = UIKeyboardTypeNumberPad;
    self.ocjTF_giftNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ocjTF_giftNum.placeholder = @"请输入卡号";
    self.ocjTF_giftNum.tintColor = [UIColor redColor];
    self.ocjTF_giftNum.delegate = self;
    [self.ocjTF_giftNum addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    if (self.isRecharge) {
        if ([[[self.ocjArr_recharge objectAtIndex:0] objectForKey:@"num"] length] > 0) {
            self.ocjTF_giftNum.text = [[self.ocjArr_recharge objectAtIndex:0] objectForKey:@"num"];
        }
    }else {
        if ([[[self.ocjArr_balance objectAtIndex:0] objectForKey:@"num"] length] > 0) {
            self.ocjTF_giftNum.text = [[self.ocjArr_balance objectAtIndex:0] objectForKey:@"num"];
        }
    }
    
    [giftNumView addSubview:self.ocjTF_giftNum];
    [self.ocjTF_giftNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(giftNumView);
        make.left.mas_equalTo(title.mas_right).offset(5);
        make.bottom.mas_equalTo(lineView.mas_top).offset(0);
        if (self.isRecharge) {
            make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(32);
        }else {
            make.top.mas_equalTo(giftNumView.mas_top).offset(30);
        }
    }];
    
}


/**
 判断确认按钮是否允许用户点击
 */
- (void)ocj_isConfirmBtnUserInteractionEnabled {
    if (self.isRecharge) {
        if ([self.ocjTF_giftNum.text length] > 0 && [self.ocjTF_giftPwd.text length] > 0 ) {
            if ([[[self.ocjArr_recharge objectAtIndex:2] objectForKey:@"lock"] isEqualToString:@"YES"]) {
                if ([[[self.ocjArr_recharge objectAtIndex:2] objectForKey:@"isCheckDone"] isEqualToString:@"YES"]) {
                    self.ocjBtn_confirm.alpha = 1.0;
                    self.ocjBtn_confirm.userInteractionEnabled = YES;
                }else {
                    self.ocjBtn_confirm.alpha = 0.2;
                    self.ocjBtn_confirm.userInteractionEnabled = NO;
                }
            }else {
                self.ocjBtn_confirm.alpha = 1.0;
                self.ocjBtn_confirm.userInteractionEnabled = YES;
            }
        }else {
            self.ocjBtn_confirm.alpha = 0.2;
            self.ocjBtn_confirm.userInteractionEnabled = NO;
        }
    }else {
        if ([self.ocjTF_giftNum.text length] > 0 && [self.ocjTF_giftPwd.text length] > 0) {
            if ([[[self.ocjArr_balance objectAtIndex:2] objectForKey:@"lock"] isEqualToString:@"YES"]) {
                if ([[[self.ocjArr_balance objectAtIndex:2] objectForKey:@"isCheckDone"] isEqualToString:@"YES"]) {
                    self.ocjBtn_confirm.alpha = 1.0;
                    self.ocjBtn_confirm.userInteractionEnabled = YES;
                }else {
                    self.ocjBtn_confirm.alpha = 0.2;
                    self.ocjBtn_confirm.userInteractionEnabled = NO;
                }
            }else {
                self.ocjBtn_confirm.alpha = 1.0;
                self.ocjBtn_confirm.userInteractionEnabled = YES;
            }
        }else {
            self.ocjBtn_confirm.alpha = 0.2;
            self.ocjBtn_confirm.userInteractionEnabled = NO;
        }
    }
}


/**
 textfield编辑内容时
 */
- (void)ocj_textFieldValueChanged:(OCJBaseTextField *)currentTF {
    [self ocj_isConfirmBtnUserInteractionEnabled];
}

/**
 确认按钮点击事件
 */
- (void)ocj_clickedConfirmBtn {
    OCJLog(@"确认");
    [self ocj_saveInputMessage];
  
    if (self.isRecharge) {
        [self ocj_trackEventID:@"AP1706C044F008002O008001" parmas:nil];
      
        [OCJHttp_myWalletAPI ocjWallet_rechargeWalletWithCardNO:self.ocjTF_giftNum.text passwd:self.ocjTF_giftPwd.text completionHandler:^(OCJBaseResponceModel *responseModel) {
          if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
            [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notification_personalCenter object:nil userInfo:@{}];
          }
            
        }];
        if (self.ocjInt_rechargeCount < 3) {
            self.ocjInt_rechargeCount ++;
            if (self.ocjInt_rechargeCount == 3) {
                [self.ocjArr_recharge replaceObjectAtIndex:2 withObject:@{@"lock":@"YES"}];
                [self.ocjTBView_gift reloadData];
            }
        }
        
    }else {
        [self ocj_trackEventID:@"AP1706C045F008002O008001" parmas:nil];
      
        [OCJHttp_myWalletAPI ocjWallet_checkBalanceWithCardNO:self.ocjTF_giftNum.text passwd:self.ocjTF_giftPwd.text completionHandler:^(OCJBaseResponceModel *responseModel) {
            OCJWalletModel_checkBalance *model = (OCJWalletModel_checkBalance *)responseModel;
            [WSHHAlert wshh_showHudWithTitle:[NSString stringWithFormat:@"您的余额为%@", model.ocjStr_num] andHideDelay:2];
        }];
        if (self.ocjInt_balanceCount < 3) {
            self.ocjInt_balanceCount ++;
            if (self.ocjInt_balanceCount == 3) {
                [self.ocjArr_balance replaceObjectAtIndex:2 withObject:@{@"lock":@"YES"}];
                [self.ocjTBView_gift reloadData];
            }
        }
    }
}


/**
 使用说明
 */
- (void)ocj_usringInstructions {
  [self ocj_trackEventID:@"AP1706C044C005001A001001" parmas:nil];
  
  OCJGiftRemindVC *remindVC = [[OCJGiftRemindVC alloc] init];
  remindVC.ocjStr_title = @"礼包说明";
  [self ocj_pushVC:remindVC];
}


/**
 钱包充值点击事件
 */
- (void)ocj_clickedRechargeBtn {
    [self ocj_trackEventID:@"AP1706C045F008001O008001" parmas:nil];
  
    if (!self.isRecharge) {
        [self ocj_saveInputMessage];
        if ([[[self.ocjArr_recharge objectAtIndex:2] objectForKey:@"lock"] isEqualToString:@"YES"]) {
            [self.ocjArr_recharge replaceObjectAtIndex:2 withObject:@{@"lock":@"YES",@"isCheckDone":@"NO"}];
        }
        self.isRecharge = YES;
        [self.ocjBtn_recharge setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
        [self.ocjBtn_checkBalance setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            self.ocjView_slider.frame = CGRectMake(0, 42.5, SCREEN_WIDTH/2, 1.5);
        }];
        [self.ocjTBView_gift reloadData];
    }
}


/**
 余额查询点击事件
 */
- (void)ocj_clickedCheckBalanceBtn {
    [self ocj_trackEventID:@"AP1706C044F008001O008001" parmas:nil];
  
    if (self.isRecharge) {
        [self ocj_saveInputMessage];
        if ([[[self.ocjArr_balance objectAtIndex:2] objectForKey:@"lock"] isEqualToString:@"YES"]) {
            [self.ocjArr_balance replaceObjectAtIndex:2 withObject:@{@"lock":@"YES",@"isCheckDone":@"NO"}];
        }
        self.isRecharge = NO;
        [self.ocjBtn_recharge setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
        [self.ocjBtn_checkBalance setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            self.ocjView_slider.frame = CGRectMake(SCREEN_WIDTH/2, 42.5, SCREEN_WIDTH/2, 1.5);
        }];
        [self.ocjTBView_gift reloadData];
    }
}


/**
 保存输入信息
 */
- (void)ocj_saveInputMessage {
    if (self.isRecharge) {
        NSString *numStr = self.ocjTF_giftNum.text;
        [self.ocjArr_recharge replaceObjectAtIndex:0 withObject:@{@"num":numStr}];
        
        NSString *pwdStr = self.ocjTF_giftPwd.text;
        [self.ocjArr_recharge replaceObjectAtIndex:1 withObject:@{@"pwd":pwdStr}];
        
    }else {
        NSString *numStr = self.ocjTF_giftNum.text;
        [self.ocjArr_balance replaceObjectAtIndex:0 withObject:@{@"num":numStr}];
        
        NSString *pwdStr = self.ocjTF_giftPwd.text;
        [self.ocjArr_balance replaceObjectAtIndex:1 withObject:@{@"pwd":pwdStr}];
        
    }
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isRecharge) {
        if ([[[self.ocjArr_recharge objectAtIndex:2] objectForKey:@"lock"] isEqualToString:@"NO"]) {
            return self.ocjArr_recharge.count;
        }else {
            return self.ocjArr_recharge.count + 1;
        }
        
    }else {
        if ([[[self.ocjArr_balance objectAtIndex:2] objectForKey:@"lock"] isEqualToString:@"NO"]) {
            return self.ocjArr_balance.count;
        }else {
            return self.ocjArr_balance.count + 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
        if (indexPath.row == 0) {
            if (!cell) {
                cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self ocj_addInputGiftNumViewWithCell:cell];
                return cell;
            }
        }else if (indexPath.row == 1) {
            if (!cell) {
                cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self ocj_addGiftPwdViewWithCell:cell];
                return cell;
            }
        }
    if (self.isRecharge) {//钱包充值
        if ([[[self.ocjArr_recharge objectAtIndex:2] objectForKey:@"lock"] isEqualToString:@"NO"]) {//
            if (!cell) {
                cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self ocj_addConfirmBtnWithCell:cell];
                return cell;
            }
        }else {//3次密码输入错误
            if (indexPath.row == 2) {
                OCJLockSliderTVCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
                [cell ocj_resetSlider:OCJLockSliderEnumTips];
                cell.ocjDelegate = self;
                return cell;
            }else {
                if (!cell) {
                    cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [self ocj_addConfirmBtnWithCell:cell];
                    return cell;
                }
            }
        }
    }else {//余额查询
        if ([[[self.ocjArr_balance objectAtIndex:2] objectForKey:@"lock"] isEqualToString:@"NO"]) {//
            if (!cell) {
                cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self ocj_addConfirmBtnWithCell:cell];
                return cell;
            }
        }else {//3次密码输入错误
            if (indexPath.row == 2) {
                OCJLockSliderTVCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
                [cell ocj_resetSlider:OCJLockSliderEnumTips];
                cell.ocjDelegate = self;
                return cell;
            }else {
                if (!cell) {
                    cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [self ocj_addConfirmBtnWithCell:cell];
                    return cell;
                }
            }
        }
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isRecharge) {
        if (indexPath.row == 0) {
            return 120;
        }else if (indexPath.row == 1) {
            return 70;
        }else {
            return 90;
        }
    }else {
        if (indexPath.row == 0) {
            return 70;
        }else if (indexPath.row == 1) {
            return 70;
        }else {
            return 90;
        }
    }
}


/**
 滑块验证
 */
- (void)ocj_sliderCheckDone {
    if (self.isRecharge) {
        
        [self.ocjArr_recharge replaceObjectAtIndex:2 withObject:@{@"lock":@"YES",@"isCheckDone":@"YES"}];

    }else {
        
        [self.ocjArr_balance replaceObjectAtIndex:2 withObject:@{@"lock":@"YES",@"isCheckDone":@"YES"}];

    }
    [self ocj_isConfirmBtnUserInteractionEnabled];
}

- (void)ocj_sliderCheckCancel{
    if (self.isRecharge) {
        [self.ocjArr_recharge replaceObjectAtIndex:2 withObject:@{@"lock":@"YES",@"isCheckDone":@"YES"}];
        
    }else {
        [self.ocjArr_balance replaceObjectAtIndex:2 withObject:@{@"lock":@"YES",@"isCheckDone":@"YES"}];
        
    }
    [self ocj_isConfirmBtnUserInteractionEnabled];
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
