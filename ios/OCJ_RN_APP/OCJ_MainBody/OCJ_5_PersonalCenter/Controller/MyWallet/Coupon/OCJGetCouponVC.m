//
//  OCJGetCouponVC.m
//  OCJ
//
//  Created by Ray on 2017/5/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGetCouponVC.h"
#import "OCJShoppingPOPCouponCell.h"
#import "OCJResponceModel_myWallet.h"
#import "OCJHttp_myWalletAPI.h"

static int OCJ_PAGE_SIZE = 10;

@interface OCJGetCouponVC ()<UITableViewDelegate, UITableViewDataSource, OCJShoppingPOPCouponCellDelegate>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_coupon;    ///<抢券

@property (nonatomic, strong) NSMutableArray *ocjArr_list;          ///<数据源
@property (nonatomic) NSInteger ocjInt_page;                        ///<当前页码
@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;           ///<状态栏颜色

@end

@implementation OCJGetCouponVC

#pragma mark - 接口方法实现区域(包括setter、getter方法)
- (NSMutableArray *)ocjArr_list {
    if (!_ocjArr_list) {
        _ocjArr_list = [NSMutableArray array];
    }
    return _ocjArr_list;
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
- (void)ocj_loginedAndLoadNetWorkData{
    [self ocj_requestCouponList:nil];
}

-(void)ocj_back{
  [super ocj_back];
  
  [self ocj_trackEventID:@"AP1706C041D003001C003001" parmas:nil];
}

- (void)ocj_setSelf {
    self.title = @"抢券";
  
    self.ocjStr_trackPageID = @"AP1706C041";
  self.ocjInt_page = 1;
    [self ocj_requestCouponList:nil];
  
    [self ocj_addTableView];
}

/**
 请求列表数据
 */
- (void)ocj_requestCouponList:(void(^)()) completion {
    [OCJHttp_myWalletAPI ocjWallet_checkTaoCouponDetailWithPage:self.ocjInt_page completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJWalletModel_TaoCouponList *model = (OCJWalletModel_TaoCouponList *)responseModel;
        NSArray *tempArr = model.ocjArr_taoList;
        
        NSInteger count = self.ocjArr_list.count % OCJ_PAGE_SIZE;//不满页数据的数量
        if (count == 0) {
            [self.ocjArr_list addObjectsFromArray:tempArr];
        }else {
            [self.ocjArr_list replaceObjectsInRange:NSMakeRange((self.ocjInt_page - 1)*OCJ_PAGE_SIZE, count) withObjectsFromArray:tempArr];
        }
        
        if (tempArr.count == OCJ_PAGE_SIZE) {
            self.ocjInt_page++;//下一页
        }
        [self.ocjTBView_coupon reloadData];
        
        if (completion) {
            completion();
        }
        
    }];
}

- (void)ocj_addTableView {
    self.ocjTBView_coupon = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.ocjTBView_coupon.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ocjTBView_coupon.delegate = self;
    self.ocjTBView_coupon.dataSource = self;
    self.ocjTBView_coupon.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.ocjTBView_coupon];
    
    [self.ocjTBView_coupon ocj_prepareRefreshing];
    self.ocjInt_page = 1;
    
    __weak OCJGetCouponVC *weakSelf = self;
    self.ocjTBView_coupon.ocjBlock_headerRefreshing = ^{
        [weakSelf.ocjArr_list removeAllObjects];
        weakSelf.ocjInt_page = 1;
        [weakSelf ocj_requestCouponList:^{
            [weakSelf.ocjTBView_coupon ocj_endHeaderRefreshing];
        }];
    };
    
    self.ocjTBView_coupon.ocjBlock_footerRefreshing = ^{
        BOOL isHaveMoreData = (weakSelf.ocjArr_list.count % OCJ_PAGE_SIZE == 0);
        [weakSelf ocj_requestCouponList:^{
            [weakSelf.ocjTBView_coupon ocj_endFooterRefreshingWithIsHaveMoreData:isHaveMoreData];
        }];
    };
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ocjArr_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cellName";
    OCJShoppingPOPCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[OCJShoppingPOPCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellDelegate = self;
    }
    OCJWalletModel_TaoCouponListDesc *listDescModel = (OCJWalletModel_TaoCouponListDesc *)self.ocjArr_list[indexPath.row];
    cell.ocjModel_taoListDesc = listDescModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (void)ocj_clickedCouponCellWithCell:(OCJShoppingPOPCouponCell *)cell andCouponNo:(NSString *)couponNo {
    NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
    if (couponNo.length>0) {
        [mDic setObject:couponNo forKey:@"couponid"];
    }
    [self ocj_trackEventID:@"AP1706C041D005001G001001" parmas:mDic];
  
    [OCJHttp_myWalletAPI ocjWallet_getTaoCouponWithCouponNo:couponNo completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            cell.ocjImgView_getAlready.hidden = NO;
            NSString *ocjStr = [responseModel.ocjDic_data objectForKey:@"result"];
            [OCJProgressHUD ocj_showHudWithTitle:ocjStr andHideDelay:2.0];
            [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notification_personalCenter object:nil userInfo:@{}];
        }else {
            cell.ocjLab_leftTitle.text = @"立即领取";
            cell.ocjBtn_getCoupon.userInteractionEnabled = YES;
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
