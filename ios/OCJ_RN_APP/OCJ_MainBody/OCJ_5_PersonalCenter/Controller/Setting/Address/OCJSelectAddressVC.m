//
//  OCJSelectAddressVC.m
//  OCJ
//
//  Created by Ray on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSelectAddressVC.h"
#import "OCJBaseTableView.h"
#import "OCJManageAddressCell.h"
#import "OCJManageAddressVC.h"

@interface OCJSelectAddressVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_address;///<tableView

@property (nonatomic, strong) NSMutableArray *ocjArr_addressList;        ///<数据源
@property (nonatomic, strong) OCJAddressModel_listDesc *ocjModel_defaultAddr;///<默认地址

@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;                 ///<状态栏颜色

@end

@implementation OCJSelectAddressVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)
- (NSMutableArray *)ocjArr_addressList {
    if (!_ocjArr_addressList) {
        _ocjArr_addressList = [[NSMutableArray alloc] init];
    }
    return _ocjArr_addressList;
}

#pragma mark - 生命周期方法区域
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
  
    self.title = @"选择收货信息";
    [self ocj_setRightItemTitles:@[@"管理"] selectorNames:@[NSStringFromSelector(@selector(ocj_manageAddress))]];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocj_loginedAndLoadNetWorkData) name:@"OCJRefreshAddressNOTI" object:nil];
  
    [self ocj_setSelf];
    [self ocj_requestAddressList:nil];
    // Do any additional setup after loading the view.
}

#pragma mark - 私有方法区域
- (void)ocj_loginedAndLoadNetWorkData{
    [self ocj_requestAddressList:nil];
}

- (void)ocj_requestAddressList:(void(^)())completion {
    [OCJHttp_addressControlAPI ocjAddress_checkMemberAddressListCompletionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJAddressModel_detailList *model = (OCJAddressModel_detailList *)responseModel;
      
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        self.ocjArr_addressList = [[NSMutableArray alloc] init];
        NSArray *tempArr = model.ocjArr_receivers;
        
        [self.ocjArr_addressList addObjectsFromArray:tempArr];
        [self.ocjTBView_address reloadData];
      }
        
    }];
}

- (void)ocj_setSelf {
    [self ocj_addTableView];
}

- (void)ocj_addTableView {
    self.ocjTBView_address = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.ocjTBView_address.delegate = self;
    self.ocjTBView_address.dataSource = self;
    self.ocjTBView_address.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_address];
}

- (void)ocj_back {
  __weak OCJSelectAddressVC *weakSelf = self;
  [super ocj_back];
  if (self.ocjModel_defaultAddr != nil) {
    if (self.ocjSelectedAddrBlock) {
      self.ocjSelectedAddrBlock(weakSelf.ocjModel_defaultAddr);
    }
  }
  
}

/**
 点击管理地址
 */
- (void)ocj_manageAddress {
  __weak OCJSelectAddressVC *weakSelf = self;
    OCJManageAddressVC *manageVC = [[OCJManageAddressVC alloc] init];
  manageVC.ocjDefaultAddressBlock = ^(OCJAddressModel_listDesc *ocjModel_default) {
    weakSelf.ocjModel_defaultAddr = ocjModel_default;
  };
    [self ocj_pushVC:manageVC];
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ocjArr_addressList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cellName";
    OCJManageAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (!cell) {
        cell = [[OCJManageAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    [cell loadData:self.ocjArr_addressList[indexPath.section] canEdit:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *ocjView_foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    ocjView_foot.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    
    return ocjView_foot;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak OCJSelectAddressVC *weakSelf = self;
    if (self.ocjSelectedAddrBlock) {
        self.ocjSelectedAddrBlock(weakSelf.ocjArr_addressList[indexPath.section]);
        [self.navigationController popViewControllerAnimated:YES];
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
