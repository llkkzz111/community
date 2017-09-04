//
//  OCJModifyMobileVC.m
//  OCJ
//
//  Created by Ray on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJModifyMobileVC.h"
#import "OCJValidationBtn.h"
#import "OCJLockSliderTVCell.h"
#import "OCJConfirmBtnTVCell.h"
#import "OCJHttp_personalInfoAPI.h"
#import "OCJResModel_personalInfo.h"

static NSString * cellIdentifier = @"OCJLockSliderTVCell";//滑动验证cell

@interface OCJModifyMobileVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, OCJLockSliderTVCellDelegete>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_mobile;///<tableView

@property (nonatomic, strong) OCJValidationBtn *ocjBtn_sendCode;///<发送验证码按钮

@property (nonatomic, strong) OCJBaseTextField *ocjTF_mobile;///<手机号
@property (nonatomic, strong) OCJBaseTextField *ocjTF_code;///<验证码
@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;///<确认按钮

@property (nonatomic) BOOL isCheckDone;///<滑动验证是否完成


@end

@implementation OCJModifyMobileVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    [self.ocjBtn_sendCode ocj_stopTimer];
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf {
  self.title = @"修改手机号";
  self.ocjStr_trackPageID = @"AP1706C059";
    [self ocj_addTableView];
}

/**
 tableView
 */
- (void)ocj_addTableView {
    self.ocjTBView_mobile = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.ocjTBView_mobile.delegate = self;
    self.ocjTBView_mobile.dataSource = self;
    self.ocjTBView_mobile.scrollEnabled = NO;
    self.ocjTBView_mobile.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_mobile];
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
    self.ocjTF_mobile = [[OCJBaseTextField alloc] init];
    self.ocjTF_mobile.placeholder = @"请输入新手机号";
    self.ocjTF_mobile.font = [UIFont systemFontOfSize:15];
    self.ocjTF_mobile.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ocjTF_mobile.keyboardType = UIKeyboardTypeNumberPad;
    self.ocjTF_mobile.tintColor = [UIColor redColor];
    [self.ocjTF_mobile addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.ocjTF_mobile.delegate = self;
    [cell.contentView addSubview:self.ocjTF_mobile];
    [self.ocjTF_mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ocjView_line);
        make.height.mas_equalTo(@30);
        make.bottom.mas_equalTo(ocjView_line.mas_top).offset(0);
    }];
}

//添加获取验证码按钮
- (void)ocj_addSendCodeCell:(UITableViewCell *)cell {
    __weak OCJModifyMobileVC *wself = self;
    self.ocjBtn_sendCode = [[OCJValidationBtn alloc]init];
    self.ocjBtn_sendCode.ocjBlock_touchUpInside = ^{
      [wself ocj_trackEventID:@"AP1706C059F008001O008001" parmas:nil];
        //点击获取验证码按钮
        if ([WSHHRegex wshh_isTelPhoneNumber:wself.ocjTF_mobile.text]) {
            [wself.ocjBtn_sendCode ocj_startTimer];
            [OCJHttp_personalInfoAPI ocjPersonal_getChangeMobileSmsCodeWith:wself.ocjTF_mobile.text completionHandler:^(OCJBaseResponceModel *responseModel) {
                
            }];
        }else {
            [WSHHAlert wshh_showHudWithTitle:@"请输入有效手机号" andHideDelay:2.0f];
        }
    };
  
    [cell.contentView addSubview:self.ocjBtn_sendCode];
    [self.ocjBtn_sendCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.contentView.mas_top).offset(33);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(90);
    }];
  
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [cell.contentView addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
        make.right.mas_equalTo(self.ocjBtn_sendCode.mas_left).offset(-10);
        make.bottom.mas_equalTo(cell.contentView);
        make.height.mas_equalTo(@0.5);
    }];
  
    //tf
    self.ocjTF_code = [[OCJBaseTextField alloc] init];
    self.ocjTF_code.placeholder = @"请输入短信验证码";
    self.ocjTF_code.font = [UIFont systemFontOfSize:15];
    self.ocjTF_code.keyboardType = UIKeyboardTypeNumberPad;
    self.ocjTF_code.tintColor = [UIColor redColor];
    self.ocjTF_code.delegate = self;
    [self.ocjTF_code addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.ocjTF_code.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell.contentView addSubview:self.ocjTF_code];
    [self.ocjTF_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ocjView_line);
        make.height.mas_equalTo(@30);
        make.bottom.mas_equalTo(ocjView_line.mas_top).offset(0);
    }];
}

- (void)ocj_textFieldValueChanged:(UITextField *)currentTF {
    if ([self.ocjTF_code.text length] > 0 && [self.ocjTF_mobile.text length] > 0 && self.isCheckDone) {
        self.ocjBtn_confirm.alpha = 1.0;
        self.ocjBtn_confirm.userInteractionEnabled = YES;
    }else {
        self.ocjBtn_confirm.alpha = 0.2;
        self.ocjBtn_confirm.userInteractionEnabled = NO;
    }
}

- (void)ocj_back {
  [self ocj_trackEventID:@"AP1706C059D003001C003001" parmas:nil];
  [super ocj_back];
}

/**
 确认
 */
- (void)ocj_clickedConfirmBtn {
    __weak OCJModifyMobileVC *weakSelf = self;
  [self ocj_trackEventID:@"AP1706C059F008002O008001" parmas:nil];
    if (![WSHHRegex wshh_isTelPhoneNumber:self.ocjTF_mobile.text]) {
        [OCJProgressHUD ocj_showHudWithTitle:@"请输入正确的手机号" andHideDelay:2.0];
    }else {
        [OCJHttp_personalInfoAPI ocjPersonal_changeMobileWithMobile:self.ocjTF_mobile.text smspassword:self.ocjTF_code.text completionHandler:^(OCJBaseResponceModel *responseModel) {
            
            if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
                
                [OCJProgressHUD ocj_showHudWithTitle:@"修改成功" andHideDelay:2.0];
                
                if (self.ocjModifyMobileBlock) {
                    self.ocjModifyMobileBlock(weakSelf.ocjTF_mobile.text);
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
                
            }
        }];
    }
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [self ocj_addMobileCell:cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [self ocj_addSendCodeCell:cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 3) {
        __weak OCJModifyMobileVC *weakSelf = self;
        OCJConfirmBtnTVCell *cell = [[OCJConfirmBtnTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJConfirmBtnTVCell"];
        cell.ocjConfirmBtnBlock = ^{
            [weakSelf ocj_clickedConfirmBtn];
        };
        self.ocjBtn_confirm = cell.ocjBtn_confirm;
        return cell;
    }else if (indexPath.row == 2) {
        OCJLockSliderTVCell * cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
        [cell ocj_resetSlider:OCJLockSliderEnumSlider];
        cell.ocjDelegate = self;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 75;
    }else if (indexPath.row == 3) {
        return 85;
    }
    return 65;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.ocjTF_mobile) {
        if (str.length > 11) {
            return NO;
        }else{
            return YES;
        }
    }else if (textField == self.ocjTF_code) {
        if (str.length > 6) {
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

#pragma mark - OCJLockSliderTVCellDelegete
- (void)ocj_sliderCheckDone {
    self.isCheckDone = YES;
    [self ocj_textFieldValueChanged:nil];
}

- (void)ocj_sliderCheckCancel {
    self.isCheckDone = NO;
    [self ocj_textFieldValueChanged:nil];
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
