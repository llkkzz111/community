//
//  OCJExchangeGiftCertificateVC.m
//  OCJ
//
//  Created by Ray on 2017/5/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJExchangeGiftCertificateVC.h"
#import "OCJHttp_myWalletAPI.h"

@interface OCJExchangeGiftCertificateVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *ocjTBView_gift;        ///<tableview

@property (nonatomic, strong) OCJBaseLabel *ocjLab_title;         ///<提示label

@property (nonatomic, strong) OCJBaseTextField *ocjTF_giftNum;    ///<礼券序号

@property (nonatomic, strong) OCJBaseTextField *ocjTF_giftPwd;    ///<礼券密码

@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;      ///<确认按钮

@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;         ///<状态栏颜色

@end

@implementation OCJExchangeGiftCertificateVC

#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
  
  [self ocj_trackEventID:@"AP1706C038D003001C003001" parmas:nil];
}

- (void)ocj_setSelf{
  self.ocjStr_trackPageID = @"AP1706C038";
  
  self.title = @"礼券兑换";
  
  [self ocj_addTableView];
}

- (void)ocj_addTableView {
    self.ocjTBView_gift = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.ocjTBView_gift.delegate = self;
    self.ocjTBView_gift.dataSource = self;
    self.ocjTBView_gift.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_gift];
}

/**
 确认按钮
 */
- (void)ocj_addConfirmBtnWithCell:(UITableViewCell *)cell {
    self.ocjBtn_confirm = [[OCJBaseButton alloc] initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH - 30, 45)];
    [self.ocjBtn_confirm ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    self.ocjBtn_confirm.layer.cornerRadius = 2;
    self.ocjBtn_confirm.alpha = 0.2;
    self.ocjBtn_confirm.userInteractionEnabled = NO;
    [self.ocjBtn_confirm setTitle:@"确认" forState:UIControlStateNormal];
    self.ocjBtn_confirm.ocjFont = [UIFont systemFontOfSize:17];
    [self.ocjBtn_confirm addTarget:self action:@selector(ocj_clickedConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:self.ocjBtn_confirm];
}

/**
 礼券密码
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
    title.text = @"礼券密码";
    title.textColor = OCJ_COLOR_DARK;
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentLeft;
    [giftPwdView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(giftPwdView);
        make.top.mas_equalTo(giftPwdView.mas_top).offset(30);
        make.bottom.mas_equalTo(lineView.mas_top).offset(0);
    }];
    
    self.ocjTF_giftPwd = [[OCJBaseTextField alloc] init];
    self.ocjTF_giftPwd.textAlignment = NSTextAlignmentRight;
    self.ocjTF_giftPwd.keyboardType = UIKeyboardTypeNumberPad;
    self.ocjTF_giftPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ocjTF_giftPwd.tintColor = [UIColor redColor];
    [self.ocjTF_giftPwd addTarget:self action:@selector(ocj_textfieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [giftPwdView addSubview:self.ocjTF_giftPwd];
    [self.ocjTF_giftPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(giftPwdView);
        make.top.mas_equalTo(giftPwdView.mas_top).offset(30);
        make.left.mas_equalTo(title.mas_right).offset(5);
        make.bottom.mas_equalTo(lineView.mas_top).offset(0);
    }];
    
}

/**
 礼券序号
 */
- (void)ocj_addInputGiftNumViewWithCell:(UITableViewCell *)cell {
    UIView *giftNumView = [[UIView alloc] init];
    [cell.contentView addSubview:giftNumView];
    [giftNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-15);
        make.top.bottom.mas_equalTo(cell.contentView);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [giftNumView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(giftNumView);
        make.height.mas_equalTo(@0.5);
    }];
    
    OCJBaseLabel *title = [[OCJBaseLabel alloc] init];
    title.text = @"礼券序号";
    title.textColor = OCJ_COLOR_DARK;
    title.font = [UIFont systemFontOfSize:14];
    title.textAlignment = NSTextAlignmentLeft;
    [giftNumView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(giftNumView);
        make.top.mas_equalTo(giftNumView.mas_top).offset(30);
        make.bottom.mas_equalTo(lineView.mas_top).offset(0);
    }];
    
    self.ocjTF_giftNum = [[OCJBaseTextField alloc] init];
    self.ocjTF_giftNum.textAlignment = NSTextAlignmentRight;
    self.ocjTF_giftNum.keyboardType = UIKeyboardTypeNumberPad;
    self.ocjTF_giftNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ocjTF_giftNum.tintColor = [UIColor redColor];
    [self.ocjTF_giftNum addTarget:self action:@selector(ocj_textfieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [giftNumView addSubview:self.ocjTF_giftNum];
    [self.ocjTF_giftNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(giftNumView);
        make.top.mas_equalTo(giftNumView.mas_top).offset(30);
        make.left.mas_equalTo(title.mas_right).offset(5);
        make.bottom.mas_equalTo(lineView.mas_top).offset(0);
    }];
    
}

/**
 textField内容有改变时调用
 */
- (void)ocj_textfieldValueChanged:(OCJBaseTextField *)currentTF {
    if ([self.ocjTF_giftNum.text length] > 0 && [self.ocjTF_giftPwd.text length] > 0) {
        self.ocjBtn_confirm.alpha = 1.0;
        self.ocjBtn_confirm.userInteractionEnabled = YES;
    }else {
        self.ocjBtn_confirm.alpha = 0.2;
        self.ocjBtn_confirm.userInteractionEnabled = NO;
    }
}

/**
 点击确认按钮
 */
- (void)ocj_clickedConfirmBtn {
    [self.ocjTF_giftNum resignFirstResponder];
    [self.ocjTF_giftPwd resignFirstResponder];
  
    [self ocj_trackEventID:@"AP1706C038F008001O008001" parmas:nil];

    [OCJHttp_myWalletAPI ocjWallet_exchangeGiftTicketsWithGift_no:self.ocjTF_giftNum.text gift_password:self.ocjTF_giftPwd.text completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:1];
          [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notification_personalCenter object:nil userInfo:@{}];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
          });
        }
    }];
}

#pragma mark - 协议方法实现区域
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        self.ocjLab_title = [[OCJBaseLabel alloc] init];
        self.ocjLab_title.font = [UIFont systemFontOfSize:14];
        self.ocjLab_title.textColor = OCJ_COLOR_DARK_GRAY;
        self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
        self.ocjLab_title.text = @"请输入礼券背面的密码，换取积分";
        [cell.contentView addSubview:self.ocjLab_title];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
            make.bottom.right.mas_equalTo(cell.contentView);
            make.top.mas_equalTo(cell.contentView.mas_top).offset(13);
        }];
        return cell;
    }else if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ocj_addInputGiftNumViewWithCell:cell];
        return cell;
    }else if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ocj_addGiftPwdViewWithCell:cell];
        return cell;
    }else if (indexPath.row == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ocj_addConfirmBtnWithCell:cell];
        return cell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 || indexPath.row == 2) {
        return 66;
    }else if (indexPath.row == 3) {
        return 90;
    }
    return 35;
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
