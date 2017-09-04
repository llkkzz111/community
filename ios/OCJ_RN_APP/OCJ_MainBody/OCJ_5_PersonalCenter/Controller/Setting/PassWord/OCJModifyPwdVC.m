//
//  OCJModifyPwdVC.m
//  OCJ
//
//  Created by Ray on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJModifyPwdVC.h"
#import "OCJModifyPwdTVCell.h"
#import "OCJConfirmBtnTVCell.h"
#import "OCJHttp_authAPI.h"

@interface OCJModifyPwdVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_modifyPWD;///<tableView

@property (nonatomic, strong) OCJBaseTextField *ocjTF_currentPwd;   ///<当前密码
@property (nonatomic, strong) OCJBaseTextField *ocjTF_newPwd;       ///<新密码
@property (nonatomic, strong) OCJBaseTextField *ocjTF_newPwdAgain;  ///<再次输入新密码
@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;        ///<确认按钮

@property (nonatomic, strong) NSArray *ocjArr_placeHolder;          ///<textField占位文字

@end

@implementation OCJModifyPwdVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf {
  self.title = @"修改密码";
  self.ocjStr_trackPageID = @"AP1706C058";
    self.ocjArr_placeHolder = @[@"请输入当前密码",@"请输入新密码",@"请再次输入密码"];
    [self ocj_addTableView];
}

/**
 tableView
 */
- (void)ocj_addTableView {
    self.ocjTBView_modifyPWD = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.ocjTBView_modifyPWD.delegate = self;
    self.ocjTBView_modifyPWD.dataSource = self;
    self.ocjTBView_modifyPWD.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_modifyPWD];
}

- (void)ocj_back {
  [self ocj_trackEventID:@"AP1706C058D003001C003001" parmas:nil];
  [super ocj_back];
}

/**
 确认
 */
- (void)ocj_clickedConfirmBtn {
    if ([self.ocjTF_currentPwd.text isEqualToString:self.ocjTF_newPwd.text]) {
        [OCJProgressHUD ocj_showHudWithTitle:@"新密码与旧密码不能一样" andHideDelay:2.0];
        return;
    }
    if (![self.ocjTF_newPwd.text isEqualToString:self.ocjTF_newPwdAgain.text]) {
        [OCJProgressHUD ocj_showHudWithTitle:@"新密码前后两次输入不一致" andHideDelay:2.0];
        return;
    }
  [self ocj_trackEventID:@"AP1706C058" parmas:nil];
    [OCJHttp_authAPI ocjAuth_setPasswordNewPassword:self.ocjTF_newPwd.text oldPassword:self.ocjTF_currentPwd.text completionHandler:^(OCJBaseResponceModel *responseModel) {
        [OCJProgressHUD ocj_showHudWithTitle:@"修改密码成功" andHideDelay:2.0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)ocj_textFieldValueChanged:(UITextField *)tf {
    if ([self.ocjTF_currentPwd.text length] > 0 && [self.ocjTF_newPwd.text length] > 0 && [self.ocjTF_newPwdAgain.text length] > 0) {
        self.ocjBtn_confirm.alpha = 1.0;
        self.ocjBtn_confirm.userInteractionEnabled = YES;
    }else {
        self.ocjBtn_confirm.alpha = 0.2;
        self.ocjBtn_confirm.userInteractionEnabled = NO;
    }
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ocjArr_placeHolder.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            OCJModifyPwdTVCell *cell = [[OCJModifyPwdTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJModifyPwdTVCell"];
            self.ocjTF_currentPwd = cell.ocjTF_input;
            cell.ocjTF_input.placeholder = self.ocjArr_placeHolder[indexPath.row];
            [cell.ocjTF_input addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
            return cell;
        }
            break;
        case 1:{
            OCJModifyPwdTVCell *cell = [[OCJModifyPwdTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJModifyPwdTVCell"];
            self.ocjTF_newPwd = cell.ocjTF_input;
            cell.ocjTF_input.placeholder = self.ocjArr_placeHolder[indexPath.row];
            [cell.ocjTF_input addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
            return cell;
        }
            break;
        case 2:{
            OCJModifyPwdTVCell *cell = [[OCJModifyPwdTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJModifyPwdTVCell"];
            self.ocjTF_newPwdAgain = cell.ocjTF_input;
            cell.ocjTF_input.placeholder = self.ocjArr_placeHolder[indexPath.row];
            [cell.ocjTF_input addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
            return cell;
        }
            break;
        case 3:{
            __weak OCJModifyPwdVC *weakSelf = self;
            OCJConfirmBtnTVCell *cell = [[OCJConfirmBtnTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJConfirmBtnTVCell"];
            cell.ocjConfirmBtnBlock = ^{
                [weakSelf ocj_clickedConfirmBtn];
            };
            self.ocjBtn_confirm = cell.ocjBtn_confirm;
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 85;
    }
    return 60;
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
