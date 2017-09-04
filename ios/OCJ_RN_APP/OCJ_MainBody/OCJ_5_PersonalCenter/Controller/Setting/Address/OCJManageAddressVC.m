//
//  OCJManageAddressVC.m
//  OCJ
//
//  Created by Ray on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJManageAddressVC.h"
#import "OCJBaseTableView.h"
#import "OCJManageAddressCell.h"
#import "OCJEditAddressVC.h"
#import "OCJHttp_addressControlAPI.h"
#import "OCJControlAddressTVCell.h"

@interface OCJManageAddressVC ()<UITableViewDelegate, UITableViewDataSource, OCJControlAddressTVCellDelegate>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_address;  ///<tableView

@property (nonatomic, strong) NSMutableArray *ocjArr_addrList;      ///<数据源
@property (nonatomic, strong) NSString *ocjStr_cust_no;             ///<顾客编号

@end

@implementation OCJManageAddressVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)
- (NSMutableArray *)ocjArr_addrList {
    if (!_ocjArr_addrList) {
        _ocjArr_addrList = [[NSMutableArray alloc] init];
    }
    return _ocjArr_addrList;
}

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
    [self ocj_requestAddressList:nil];
    // Do any additional setup after loading the view.
}

#pragma mark - 私有方法区域
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)ocj_loginedAndLoadNetWorkData{
    [self ocj_requestAddressList:nil];
}

/**
 请求数据
 */
- (void)ocj_requestAddressList:(void(^)())completion {
    [OCJHttp_addressControlAPI ocjAddress_checkMemberAddressListCompletionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJAddressModel_detailList *model = (OCJAddressModel_detailList *)responseModel;
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        self.ocjStr_cust_no = model.ocjStr_cust_no;
        
        NSArray *tempArr = model.ocjArr_receivers;
        self.ocjArr_addrList = [NSMutableArray arrayWithArray:tempArr];
        
        [self.ocjTBView_address reloadData];
      }
      
    }];
}

- (void)ocj_setSelf {
  self.title = @"收货地址管理";
  self.ocjStr_trackPageID = @"AP1706C062";
  [self ocj_setRightItemTitles:@[@"添加"] selectorNames:@[NSStringFromSelector(@selector(ocj_createNewAddress))]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocj_loginedAndLoadNetWorkData) name:@"OCJRefreshAddressNOTI" object:nil];
  [self ocj_addTableView];
}

- (void)ocj_addTableView {
    self.ocjTBView_address = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.ocjTBView_address.delegate = self;
    self.ocjTBView_address.dataSource = self;
    self.ocjTBView_address.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_address];
}

/**
 返回
 */
- (void)ocj_back {
  [self ocj_trackEventID:@"AP1706C062C005001C003001" parmas:nil];
   [super ocj_back];
  OCJAddressModel_listDesc *model;
  if (self.ocjArr_addrList.count > 0) {
    for (model in self.ocjArr_addrList) {
      if ([model.ocjStr_isDefault isEqualToString:@"1"]) {
        if (self.ocjDefaultAddressBlock) {
          self.ocjDefaultAddressBlock(model);
        }
      }
    }
  }
  
}

/**
 点击新建地址
 */
- (void)ocj_createNewAddress {
  [self ocj_trackEventID:@"AP1706C062C005001A001001" parmas:nil];
    OCJEditAddressVC *editVC = [[OCJEditAddressVC alloc] initWithEditType:OCJEditType_add OCJManageAddressModel:nil OCJShopAddressHandler:^(OCJAddressModel_listDesc *shopModel) {
      
        [self ocj_requestAddressList:nil];
    }];
    editVC.ocjStr_custno = self.ocjStr_cust_no;
    [self ocj_pushVC:editVC];
}

/**
 设置默认地址
 */
/*
- (void)ocj_setDefaultAddress:(OCJAddressModel_listDesc *)model {
    OCJLog(@"设为默认");
    [OCJHttp_addressControlAPI ocjAddress_setDefaultAddressWithAddressID:model.ocjStr_addressID completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
            [self.ocjArr_addrList removeAllObjects];
            [self ocj_requestAddressList:nil];
        }
    }];
}
 */

/**
 编辑地址
 */
/*
- (void)ocj_editAddress:(OCJAddressModel_listDesc *)model {
    OCJEditAddressVC *editVC = [[OCJEditAddressVC alloc] initWithEditType:OCJEditType_edit OCJManageAddressModel:model OCJShopAddressHandler:^(OCJAddressModel_listDesc *shopModel) {
        OCJLog(@"22222");
        [self ocj_requestAddressList:nil];
    }];
    [self ocj_pushVC:editVC];
}
 */

/**
 删除地址
 */
/*
- (void)ocj_deleteAddress:(OCJAddressModel_listDesc *)model {
    OCJLog(@"删除");
    [OCJHttp_addressControlAPI ocjAddress_deleteAddressWithAddressID:model.ocjStr_addressID completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
            [self ocj_requestAddressList:nil];
            [self.ocjTBView_address reloadData];
        }
    }];
}
 */

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ocjArr_addrList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cellName";
    OCJControlAddressTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (!cell) {
        cell = [[OCJControlAddressTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.ocjModel_address = self.ocjArr_addrList[indexPath.section];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122;
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
/*
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    OCJManageAddressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.ocjbtn_modify.userInteractionEnabled = NO;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    OCJManageAddressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.ocjbtn_modify.userInteractionEnabled = YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak OCJManageAddressVC *wself = self;
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"设为\n默认" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [wself ocj_setDefaultAddress:wself.ocjArr_addrList[indexPath.section]];
    }];
    editAction.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [wself ocj_deleteAddress:wself.ocjArr_addrList[indexPath.section]];
    }];
    
    return @[deleteAction,editAction];
}
 */

#pragma mark - OCJControlAddressTVCellDelegate
- (void)ocj_setDefaultAddress:(OCJAddressModel_listDesc *)model {
    [OCJHttp_addressControlAPI ocjAddress_setDefaultAddressWithAddressID:model.ocjStr_addressID completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OCJRefreshAddressNOTI" object:nil];
        }
    }];
}

- (void)ocj_editAddress:(OCJAddressModel_listDesc *)model {
  [self ocj_trackEventID:@"AP1706C062F012001O006001" parmas:nil];
    OCJEditAddressVC *editVC = [[OCJEditAddressVC alloc] initWithEditType:OCJEditType_edit OCJManageAddressModel:model OCJShopAddressHandler:^(OCJAddressModel_listDesc *shopModel) {
        [self ocj_requestAddressList:nil];
    }];
    [self ocj_pushVC:editVC];
}

- (void)ocj_deleteAddress:(OCJAddressModel_listDesc *)model {
  [self ocj_trackEventID:@"AP1706C062F012001O006002" parmas:nil];
  [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeNone title:@"" message:@"确定删除该地址吗？" sureButtonTitle:@"确定" CancelButtonTitle:@"取消" action:^(NSInteger clickIndex) {
    if (clickIndex == 1) {
      [OCJHttp_addressControlAPI ocjAddress_deleteAddressWithAddressID:model.ocjStr_addressID completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          
          [[NSNotificationCenter defaultCenter] postNotificationName:@"OCJRefreshAddressNOTI" object:nil];
        }
      }];
    }else {
      
    }
  }];
  
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
