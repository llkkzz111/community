//
//  OCJModifyNickNameVC.m
//  OCJ
//
//  Created by Ray on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJModifyNickNameVC.h"
#import "OCJConfirmBtnTVCell.h"
#import "OCJHttp_personalInfoAPI.h"

@interface OCJModifyNickNameVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_mobile;///<tableView

@property (nonatomic, strong) OCJBaseTextField *ocjTF_nickName;///<昵称
@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;///<确认按钮

@end

@implementation OCJModifyNickNameVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf {
  self.title = @"修改昵称";
  self.ocjStr_trackPageID = @"AP1706C057";
    [self ocj_addTableView];
}

/**
 tableView
 */
- (void)ocj_addTableView {
    self.ocjTBView_mobile = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.ocjTBView_mobile.delegate = self;
    self.ocjTBView_mobile.dataSource = self;
    self.ocjTBView_mobile.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_mobile];
}

- (void)ocj_textFieldValueChanged:(UITextField *)currentTF {
    if ([self.ocjTF_nickName.text length] > 0) {
        self.ocjBtn_confirm.alpha = 1.0;
        self.ocjBtn_confirm.userInteractionEnabled = YES;
    }else {
        self.ocjBtn_confirm.alpha = 0.2;
        self.ocjBtn_confirm.userInteractionEnabled = NO;
    }
}

/**
 确认
 */
- (void)ocj_clickedConfirmBtn {
    __weak OCJModifyNickNameVC *weakSelf = self;
  [self ocj_trackEventID:@"AP1706C058F008001O008001" parmas:nil];
    NSString *nickName = [self.ocjTF_nickName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [OCJHttp_personalInfoAPI ocjPersonal_changeNickNameWithCustUpstatus:nil custName:nickName completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:@"修改成功" andHideDelay:2.0];
            if (self.ocjModifyNickNameBlock) {
                self.ocjModifyNickNameBlock(weakSelf.ocjTF_nickName.text);
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)ocj_back {
  [self ocj_trackEventID:@"AP1706C057D003001C003001" parmas:nil];
  [super ocj_back];
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *ocjView_line = [[UIView alloc] init];
        ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
        [cell.contentView addSubview:ocjView_line];
        [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(20);
            make.right.mas_equalTo(cell.contentView.mas_right).offset(-20);
            make.bottom.mas_equalTo(cell.contentView);
            make.height.mas_equalTo(@0.5);
        }];
        
        self.ocjTF_nickName = [[OCJBaseTextField alloc] init];
        self.ocjTF_nickName.placeholder = @"请输入新昵称";
        self.ocjTF_nickName.font = [UIFont systemFontOfSize:15];
        self.ocjTF_nickName.keyboardType = UIKeyboardTypeDefault;
        self.ocjTF_nickName.tintColor = [UIColor redColor];
        self.ocjTF_nickName.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.ocjTF_nickName addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:self.ocjTF_nickName];
        [self.ocjTF_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(ocjView_line);
            make.height.mas_equalTo(@30);
            make.bottom.mas_equalTo(ocjView_line.mas_top).offset(0);
        }];
        
        return cell;
    }
    //确认按钮
    __weak OCJModifyNickNameVC *weakSelf = self;
    OCJConfirmBtnTVCell *cell = [[OCJConfirmBtnTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJConfirmBtnTVCell"];
    cell.ocjConfirmBtnBlock = ^{
        [weakSelf ocj_clickedConfirmBtn];
    };
    self.ocjBtn_confirm = cell.ocjBtn_confirm;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    }else {
        return 85;
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
