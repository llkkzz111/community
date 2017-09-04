//
//  OCJOPMemberLoginVC.m
//  OCJ
//
//  Created by OCJ on 2017/5/3.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJOPMemberLoginVC.h"
#import "TPKeyboardAvoidingTableView.h"
#import "OCJBaseButton+OCJExtension.h"
#import "OCJLoginTypeTVCell.h"

#pragma mark - 固定字符串赋值区域
@interface OCJOPMemberLoginVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TPKeyboardAvoidingTableView * ocjTableView;     ///< tableView
@property (nonatomic,strong) OCJBaseTextField                 * ocjTF_opAccount;  ///< 账号
@property (nonatomic,strong) OCJBaseTextField                 * ocjTF_opPwd;      ///< 密码
@property (nonatomic,strong) OCJBaseButton               * ocjBtn_login;     ///< 登录按钮

@end

@implementation OCJOPMemberLoginVC


#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
#pragma mark - 私有方法区域
- (void)initUI{
    self.title = @"东方明珠会员登录";
    [self.view addSubview:self.ocjTableView];
    [self.ocjTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (TPKeyboardAvoidingTableView *)ocjTableView{
    if (!_ocjTableView) {
        _ocjTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _ocjTableView.scrollEnabled = NO;
        _ocjTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _ocjTableView.tableFooterView = [UIView new];
        _ocjTableView.tableHeaderView = [UIView new];
        _ocjTableView.tableFooterView = [self createTableViewFooterView];
        _ocjTableView.dataSource = self;
        _ocjTableView.delegate = self;
    }
    return _ocjTableView;
}

- (UIView *)createTableViewFooterView{
    UIView *  footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    OCJBaseButton * ocjBtn_Login = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    ocjBtn_Login.frame = CGRectMake(20, 40 , SCREEN_WIDTH - 40, 45);
    [ocjBtn_Login setTitle:@"登录" forState:UIControlStateNormal];
    ocjBtn_Login.layer.masksToBounds = YES;
    ocjBtn_Login.layer.cornerRadius = 2;
    ocjBtn_Login.alpha = 0.2;
    ocjBtn_Login.userInteractionEnabled = NO;
    ocjBtn_Login.ocjFont = [UIFont systemFontOfSize:17];
    [ocjBtn_Login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ocjBtn_Login ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [footerView addSubview:ocjBtn_Login];
    self.ocjBtn_login = ocjBtn_Login;
    [self.ocjBtn_login addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}

- (void)loginAction:(id)sender{
    OCJLog(@"登录");
}

#pragma mark - 协议方法实现区域
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        static NSString * cellIdentifier = @"OCJOPMemberAccountCellIdentifier";
        OCJLoginTypeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[OCJLoginTypeTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.ocjTF_input.placeholder = @"请输入账号";
        cell.ocjTF_input.keyboardType = UIKeyboardTypeDefault;
        self.ocjTF_opAccount = cell.ocjTF_input;
        [self.ocjTF_opAccount addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }else{
        static NSString * cellIdentifier = @"OCJOPMemberPasswordCellIdentifier";
        OCJLoginTypePwdTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[OCJLoginTypePwdTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.ocjTF_pwd.placeholder = @"请输入密码";
        cell.ocjTF_pwd.keyboardType = UIKeyboardTypeDefault;
        self.ocjTF_opPwd = cell.ocjTF_pwd;
        [self.ocjTF_opPwd addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
}
- (void)textFieldChange:(OCJBaseTextField *)textfield{
    if (self.ocjTF_opAccount.text.length > 0 && self.ocjTF_opPwd.text.length >0) {
        self.ocjBtn_login.userInteractionEnabled = YES;
        self.ocjBtn_login.alpha = 1;
    }else{
        self.ocjBtn_login.userInteractionEnabled = NO;
        self.ocjBtn_login.alpha = 0.2;
    }
}
@end
