//
//  OCJModifyEmailPwdVC.m
//  OCJ
//
//  Created by Ray on 2017/5/25.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJModifyEmailPwdVC.h"
#import "OCJLockSliderTVCell.h"
#import "OCJConfirmBtnTVCell.h"
#import "OCJHttp_personalInfoAPI.h"
#import "OCJResModel_personalInfo.h"
#import "OCJRetrieveEmailPwdVC.h"

static NSString * cellIdentifier = @"OCJLockSliderTVCell";//滑动验证cell

@interface OCJModifyEmailPwdVC ()<UITableViewDelegate, UITableViewDataSource, OCJLockSliderTVCellDelegete>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_email;

@property (nonatomic, strong) UITextField *ocjTF_email;///<邮箱
@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;///<确认按钮

@property (nonatomic) BOOL isCheckDone;///<滑动验证是否完成

@end

@implementation OCJModifyEmailPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
    
    // Do any additional setup after loading the view.
}

- (void)ocj_setSelf {
  self.title = @"修改邮箱";
  self.ocjStr_trackPageID = @"AP1706C060";
    [self ocj_addTableView];
}

- (void)ocj_addTableView {
    self.ocjTBView_email = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.ocjTBView_email.delegate = self;
    self.ocjTBView_email.dataSource = self;
    self.ocjTBView_email.scrollEnabled = NO;
    self.ocjTBView_email.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_email];
}

//请输入手机号
- (void)ocj_addMobileCell:(UITableViewCell *)cell {
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [cell.contentView addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-20);
        make.bottom.mas_equalTo(cell.contentView);
        make.height.mas_equalTo(@0.5);
    }];
    //tf
    self.ocjTF_email = [[OCJBaseTextField alloc] init];
    self.ocjTF_email.placeholder = @"请输入新邮箱";
    self.ocjTF_email.font = [UIFont systemFontOfSize:15];
    self.ocjTF_email.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ocjTF_email.keyboardType = UIKeyboardTypeDefault;
    self.ocjTF_email.tintColor = [UIColor redColor];
    [self.ocjTF_email addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [cell.contentView addSubview:self.ocjTF_email];
    [self.ocjTF_email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ocjView_line);
        make.height.mas_equalTo(@30);
        make.bottom.mas_equalTo(ocjView_line.mas_top).offset(0);
    }];
}

- (void)ocj_textFieldValueChanged:(UITextField *)currentTF {
    if ([self.ocjTF_email.text length] > 0 && self.isCheckDone) {
        self.ocjBtn_confirm.alpha = 1.0;
        self.ocjBtn_confirm.userInteractionEnabled = YES;
    }else {
        self.ocjBtn_confirm.alpha = 0.2;
        self.ocjBtn_confirm.userInteractionEnabled = NO;
    }
}

- (void)ocj_back {
  [self ocj_trackEventID:@"AP1706C060D003001C003001" parmas:nil];
  [super ocj_back];
}

/**
 点击确认按钮
 */
- (void)ocj_clickedConfirmBtn {
  [self ocj_trackEventID:@"AP1706C060F008001O008001" parmas:nil];
    if (![WSHHRegex wshh_isEmail:self.ocjTF_email.text]) {
        [OCJProgressHUD ocj_showHudWithTitle:@"请输入正确的邮箱" andHideDelay:2.0];
    }else {
      
      [OCJHttp_personalInfoAPI ocjPersonal_changeEmailWithNewEmail:self.ocjTF_email.text completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
//          [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeSuccessSendEmail title:@"邮件发送成功" message:@"验证邮件将在1小时后过期" sureButtonTitle:nil CancelButtonTitle:@"确定" action:^(NSInteger clickIndex) {
//
//          }];
          OCJRetrieveEmailPwdVC *emailVC = [[OCJRetrieveEmailPwdVC alloc] init];
          emailVC.ocjSendEmailype = OCJSendEmailTypeModifyMail;
          emailVC.ocjStr_userName = self.ocjStr_nickName;
          emailVC.ocjStr_email = self.ocjTF_email.text;
          [self ocj_pushVC:emailVC];
        }
      }];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ocj_addMobileCell:cell];
        return cell;
    }else if (indexPath.row == 1) {
        OCJLockSliderTVCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
        [cell ocj_resetSlider:OCJLockSliderEnumSlider];
        cell.ocjDelegate = self;
        return cell;
    }else {
        __weak OCJModifyEmailPwdVC *weakSelf = self;
        OCJConfirmBtnTVCell *cell = [[OCJConfirmBtnTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJConfirmBtnTVCell"];
        cell.ocjConfirmBtnBlock = ^{
            [weakSelf ocj_clickedConfirmBtn];
        };
        self.ocjBtn_confirm = cell.ocjBtn_confirm;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    }
    return 85;
}

#pragma mark - OCJLockSliderTVCellDelegete
- (void)ocj_sliderCheckDone {
    self.isCheckDone = YES;
    [self ocj_textFieldValueChanged:nil];
    OCJLog(@"1233123123");
}

- (void)ocj_sliderCheckCancel {
    self.isCheckDone = NO;
    [self ocj_textFieldValueChanged:nil];
    OCJLog(@"dasdasdasdasd");
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
