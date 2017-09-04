//
//  OCJFeedBackSuccessVC.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJFeedBackSuccessVC.h"
#import "OCJFeedBackSuccessTVCell.h"

@interface OCJFeedBackSuccessVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_success;      ///<tableView

@end

@implementation OCJFeedBackSuccessVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
  
  [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf {
  self.title = @"我要提意见";
  [self ocj_addTableView];
}

- (void)ocj_addTableView {
  self.ocjTBView_success = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.ocjTBView_success.backgroundColor = OCJ_COLOR_BACKGROUND;
  self.ocjTBView_success.delegate = self;
  self.ocjTBView_success.dataSource = self;
  self.ocjTBView_success.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:self.ocjTBView_success];
  [self.ocjTBView_success mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.bottom.mas_equalTo(self.view);
  }];
  [self.ocjTBView_success registerClass:[OCJFeedBackSuccessTVCell class] forCellReuseIdentifier:@"OCJFeedBackSuccessTVCellIdentifier"];
  [self.ocjTBView_success registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellIdentifier"];
}

- (void)ocj_clickedHomeBtn {
  [self.navigationController popToRootViewControllerAnimated:NO];
  [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notice_LoginOut object:nil userInfo:@{}];
}

#pragma mark - 协议方法区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    OCJFeedBackSuccessTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJFeedBackSuccessTVCellIdentifier"];
    
    return cell;
  }else {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OCJBaseButton *ocjBtn_home = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 45)];
    [ocjBtn_home ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [ocjBtn_home setTitle:@"去首页逛逛" forState:UIControlStateNormal];
    ocjBtn_home.titleLabel.font = [UIFont systemFontOfSize:17];
    [ocjBtn_home setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [ocjBtn_home addTarget:self action:@selector(ocj_clickedHomeBtn) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:ocjBtn_home];
    return cell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    return 200;
  }
  return 45;
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
