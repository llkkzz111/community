//
//  OCJCouponDetailVC.m
//  OCJ
//
//  Created by Ray on 2017/5/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJCouponDetailVC.h"
#import "OCJGetCouponVC.h"
#import "OCJBaseTableView.h"
#import "OCJShoppingPOPCouponCell.h"
#import "OCJSelectedView.h"
#import "OCJHttp_myWalletAPI.h"
#import "UITableView+OCJTableView.h"

static int OCJ_PAGE_SIZE = 10;

/**
 抵用券记录类型
 */
typedef NS_ENUM(NSInteger, OCJCouponDetailListType) {
    OCJCouponDetailListTypeALL = 0,     ///<全部
    OCJCouponDetailListTypeNoUse,       ///<未使用
    OCJCouponDetailListTypeUsed         ///<已使用
};

@interface OCJCouponDetailVC ()<UITableViewDelegate, UITableViewDataSource, OCJShoppingPOPCouponCellDelegate>

@property (nonatomic, strong) UIImageView      * ocjView_nav;     ///< 导航视图
@property (nonatomic, strong) UIView *ocjView_tbHeader;           ///< tableView headView

@property (nonatomic, strong) OCJBaseLabel * ocjLab_num;          ///< 可使用券张数

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_coupon; ///< tableView

@property (nonatomic, strong) OCJBaseTextField *ocjTF_coupon;     ///< 输入兑换码兑换抵用券
@property (nonatomic, strong) OCJBaseButton *ocjBtn_exchange;     ///< 确认兑换按钮

@property (nonatomic, strong) OCJBaseButton *ocjBtn_arrow;        ///< 箭头
@property (nonatomic, assign) BOOL isSHowAllInvalid;              ///< 是否显示全部即将失效抵用券

@property (nonatomic) NSInteger ocjInt_page;                      ///< 数据页码
@property (nonatomic, strong) NSMutableArray *ocjArr_couponList;  ///< 数据源

@property (nonatomic) OCJCouponDetailListType ocjEnum_listType;   ///< 列表数据类型

@property (nonatomic,strong) UIButton *ocjBtn_last;               ///< 筛选标签按钮

@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;         ///<状态栏颜色

@end

@implementation OCJCouponDetailVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)
- (void)setOcjEnum_listType:(OCJCouponDetailListType)ocjEnum_listType {
    _ocjEnum_listType = ocjEnum_listType;
    self.ocjInt_page = 1;
    [self ocj_requestCouponDetail:nil];
}

- (NSMutableArray *)ocjArr_couponList {
    if (!_ocjArr_couponList) {
        _ocjArr_couponList = [[NSMutableArray alloc] init];
    }
    return _ocjArr_couponList;
}

#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
  
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  self.ocjStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:self.ocjStatusBarStyle];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - 私有方法区域
- (void)ocj_loginedAndLoadNetWorkData{
    [self ocj_requestCouponDetail:nil];
}

-(void)ocj_back{
  [super ocj_back];
  
  [self ocj_trackEventID:@"AP1706C040C005001C003001" parmas:nil];
}

- (void)ocj_setSelf {
    self.ocjStr_trackPageID = @"AP1706C040";
  self.ocjInt_page = 1;
    [self ocj_requestCouponDetail:nil];
  
    self.isSHowAllInvalid = NO;
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocj_reloadCouponData) name:OCJ_Notification_personalCenter object:nil];
  
    [self ocj_addNavView];
    [self ocj_addTableView];
}

/**
 抢券成功刷新数据
 */
- (void)ocj_reloadCouponData {
  [self ocj_requestCouponDetail:nil];
}

/**
 请求抵用券数据
 */
- (void)ocj_requestCouponDetail:(void(^)())completion {
    NSString *listType;
    switch (self.ocjEnum_listType) {
        case OCJCouponDetailListTypeALL:{
            listType = @"all";
        }break;
        case OCJCouponDetailListTypeNoUse:{
            listType = @"noUse";
        }break;
        case OCJCouponDetailListTypeUsed:{
            listType = @"use";
        }break;
    }

    [OCJHttp_myWalletAPI ocjWallet_checkCouponNumCompletionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJWalletModel_CouponNum *model = (OCJWalletModel_CouponNum *)responseModel;
        self.ocjLab_num.text = model.ocjStr_couponNum;
    }];
    
    [OCJHttp_myWalletAPI ocjWallet_checkCouponDetailWithStatusType:listType page:self.ocjInt_page completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJWalletModel_CouponList *model = (OCJWalletModel_CouponList *)responseModel;
      if ([model.ocjStr_code isEqualToString:@"200"]) {
        
        NSArray *tempArr = model.ocjArr_coupon;
        if (self.ocjEnum_listType == OCJCouponDetailListTypeALL && tempArr.count == 0) {
          self.ocjTBView_coupon.ocjDic_NoData = @{@"image":@"img_coupon",
                                                  @"tipStr":@"怎么可以没有抵用券,你值得拥有~"};
          [self.ocjTBView_coupon reloadData];
        }else if (tempArr.count == 0) {
          self.ocjTBView_coupon.ocjDic_NoData = @{@"image":@"img_empty",
                                                  @"tipStr":@"您还没有记录哦~,我还要孤单多久",
                                                  @"header":@"YES"};
          self.ocjTBView_coupon.tableHeaderView = [self ocj_addTableHeaderView];
          [self.ocjTBView_coupon reloadData];
        }else {
          self.ocjTBView_coupon.tableHeaderView = [self ocj_addTableHeaderView];
          NSInteger moreCount = self.ocjArr_couponList.count % OCJ_PAGE_SIZE;//不满页数据的数量
          
          if (moreCount == 0) {
            [self.ocjArr_couponList addObjectsFromArray:tempArr];
          }else {
            [self.ocjArr_couponList replaceObjectsInRange:NSMakeRange((self.ocjInt_page - 1)*OCJ_PAGE_SIZE, moreCount) withObjectsFromArray:tempArr];
          }
          
          if (tempArr.count == OCJ_PAGE_SIZE) {
            self.ocjInt_page++;//下一页
          }
          [self.ocjTBView_coupon reloadData];
        }
        if (completion) {
          completion();
        }
      }

    }];
}

/**
 导航
 */
- (void)ocj_addNavView {
    self.ocjView_nav = [[UIImageView alloc] init];
    self.ocjView_nav.userInteractionEnabled = YES;
    [self.ocjView_nav setImage:[UIImage imageNamed:@"icon_integralIcondetails_bg"]];
    [self.view addSubview:self.ocjView_nav];

    
    [self.ocjView_nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(165);
    }];
    
    OCJBaseButton * ocjBtn_back = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [ocjBtn_back addTarget:self action:@selector(ocj_back) forControlEvents:UIControlEventTouchUpInside];
    [ocjBtn_back setImage:[UIImage imageNamed:@"icon_left"] forState:UIControlStateNormal];
    [self.ocjView_nav addSubview:ocjBtn_back];
    [ocjBtn_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_ocjView_nav).offset(0);
        make.top.mas_equalTo(_ocjView_nav).offset(20);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    UILabel * ocjLab_title = [[UILabel alloc]init];
    ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    ocjLab_title.font = [UIFont systemFontOfSize:17];
    ocjLab_title.text = @"抵用券详情";
    ocjLab_title.textAlignment = NSTextAlignmentCenter;
    [self.ocjView_nav addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(24);
        make.centerX.mas_equalTo(_ocjView_nav.mas_centerX);
        make.top.mas_equalTo(_ocjView_nav).offset(29);
    }];
    
    UIButton * ocjBtn_getCoupon = [UIButton buttonWithType:UIButtonTypeCustom];
    [ocjBtn_getCoupon setTitle:@"抢券" forState:UIControlStateNormal];
    ocjBtn_getCoupon.titleLabel.font = [UIFont systemFontOfSize:14];
  ocjBtn_getCoupon.layer.cornerRadius = 2;
  ocjBtn_getCoupon.layer.borderWidth = 0.5;
  ocjBtn_getCoupon.layer.borderColor = [UIColor colorWSHHFromHexString:@"FFFFFF"].CGColor;
    [ocjBtn_getCoupon setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [ocjBtn_getCoupon addTarget:self action:@selector(ocj_clickedGetCouponBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_nav addSubview:ocjBtn_getCoupon];
    [ocjBtn_getCoupon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_ocjView_nav).offset(-10);
        make.top.mas_equalTo(_ocjView_nav).offset(30);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@55);
    }];
    
    
    OCJBaseLabel * ocjLab_tip = [[OCJBaseLabel alloc]init];
    ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    ocjLab_tip.font = [UIFont systemFontOfSize:13];
    ocjLab_tip.text = @"可使用券（张）";
    ocjLab_tip.textAlignment = NSTextAlignmentCenter;
    [self.ocjView_nav addSubview:ocjLab_tip];
    [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_ocjView_nav).offset(30);
        make.height.mas_equalTo(24);
        make.top.mas_equalTo(_ocjView_nav).offset(67.5);
    }];
    
    self.ocjLab_num = [[OCJBaseLabel alloc]init];
    self.ocjLab_num.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    self.ocjLab_num.font = [UIFont systemFontOfSize:35];
    self.ocjLab_num.textAlignment = NSTextAlignmentCenter;
    [self.ocjView_nav addSubview:self.ocjLab_num];
    [self.ocjLab_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjLab_tip);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(ocjLab_tip.mas_bottom).offset(10);
    }];
}

/**
 tableView
 */
- (void)ocj_addTableView {
    self.ocjTBView_coupon = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.ocjTBView_coupon.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ocjTBView_coupon.delegate = self;
    self.ocjTBView_coupon.dataSource = self;
    self.ocjTBView_coupon.showsVerticalScrollIndicator = NO;
    self.ocjTBView_coupon.tableHeaderView = [self ocj_addTableHeaderView];
    [self.view addSubview:self.ocjTBView_coupon];
    [self.ocjTBView_coupon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjView_nav.mas_bottom).offset(0);
    }];
    
    [self.ocjTBView_coupon ocj_prepareRefreshing];
    self.ocjInt_page = 1;
    
    __weak OCJCouponDetailVC *weakSelf = self;
    self.ocjTBView_coupon.ocjBlock_headerRefreshing = ^{
        OCJLog(@"下拉刷新");
        [weakSelf.ocjArr_couponList removeAllObjects];
        weakSelf.ocjInt_page = 1;
        [weakSelf ocj_requestCouponDetail:^{
            [weakSelf.ocjTBView_coupon ocj_endHeaderRefreshing];
        }];
    };
    
    self.ocjTBView_coupon.ocjBlock_footerRefreshing = ^{
        OCJLog(@"上拉加载");
        
        [weakSelf ocj_requestCouponDetail:^{
            BOOL isHaveMoreData = (weakSelf.ocjArr_couponList.count%OCJ_PAGE_SIZE==0);
            [weakSelf.ocjTBView_coupon ocj_endFooterRefreshingWithIsHaveMoreData:isHaveMoreData];
        }];
    };
}

/**
 tableHeaderView(兑换抵用券)
 */
- (UIView *)ocj_addTableHeaderView {
    //headerView
    self.ocjView_tbHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
    self.ocjView_tbHeader.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    //白色背景
    UIView *ocjView_whiteBg = [[UIView alloc] init];
    ocjView_whiteBg.backgroundColor = OCJ_COLOR_BACKGROUND;
    [self.ocjView_tbHeader addSubview:ocjView_whiteBg];
    [ocjView_whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.ocjView_tbHeader);
        make.bottom.mas_equalTo(self.ocjView_tbHeader.mas_bottom).offset(-10);
    }];
    //按钮
    self.ocjBtn_exchange = [[OCJBaseButton alloc] init];
    self.ocjBtn_exchange.backgroundColor = [UIColor redColor];
    self.ocjBtn_exchange.layer.cornerRadius = 2;
    [self.ocjBtn_exchange setTitle:@"确认兑换" forState:UIControlStateNormal];
    self.ocjBtn_exchange.userInteractionEnabled = NO;
    self.ocjBtn_exchange.alpha = 0.2;
    [self.ocjBtn_exchange setTitleColor:OCJ_COLOR_BACKGROUND forState:UIControlStateNormal];
    self.ocjBtn_exchange.ocjFont = [UIFont systemFontOfSize:14];
    [self.ocjBtn_exchange addTarget:self action:@selector(ocj_clickedExchangeBtn) forControlEvents:UIControlEventTouchUpInside];
    [ocjView_whiteBg addSubview:self.ocjBtn_exchange];
    [self.ocjBtn_exchange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ocjView_whiteBg.mas_right).offset(-15);
        make.top.mas_equalTo(ocjView_whiteBg.mas_top).offset(15);
        make.height.mas_equalTo(@32);
        make.width.mas_equalTo(@80);
    }];
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [ocjView_whiteBg addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjView_whiteBg.mas_left).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH-118);
        make.bottom.mas_equalTo(ocjView_whiteBg.mas_bottom).offset(-15);
        make.height.mas_equalTo(@0.5);
    }];
    //tf
    self.ocjTF_coupon = [[OCJBaseTextField alloc] init];
    self.ocjTF_coupon.placeholder = @"请输入代码兑换抵用券";
    self.ocjTF_coupon.keyboardType = UIKeyboardTypeDefault;
    self.ocjTF_coupon.tintColor = [UIColor redColor];
    self.ocjTF_coupon.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ocjTF_coupon.textAlignment = NSTextAlignmentLeft;
    self.ocjTF_coupon.font = [UIFont systemFontOfSize:14];
    [self.ocjTF_coupon addTarget:self action:@selector(ocj_textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.ocjTF_coupon.textColor = OCJ_COLOR_DARK_GRAY;
    [ocjView_whiteBg addSubview:self.ocjTF_coupon];
    [self.ocjTF_coupon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjView_line.mas_left).offset(0);
        make.right.mas_equalTo(ocjView_line.mas_right).offset(0);
        make.top.mas_equalTo(ocjView_whiteBg.mas_top).offset(15);
        make.bottom.mas_equalTo(ocjView_line.mas_top).offset(0);
    }];
    
    return self.ocjView_tbHeader;
}

/**
 全部抵用券
 */
- (UIView *)ocj_addShowAllCouponsHeaderView {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 65)];
    view.backgroundColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    
    UIView * ocjView_line = [[UIView alloc]init];
    ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [view addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    __weak OCJCouponDetailVC *weakSelf = self;
    OCJSelectedView * ocjView_selected = [[OCJSelectedView alloc]initWithTitleArray:[NSMutableArray arrayWithObjects:@"全部",@"未使用",@"已使用", nil] andIndex:self.ocjBtn_last.tag];
    //点击事件
    ocjView_selected.ocj_handler = ^(UIButton *currentBtn) {
        weakSelf.ocjBtn_last = currentBtn;
        [weakSelf.ocjArr_couponList removeAllObjects];
        switch (currentBtn.tag) {
            case 0:{
                weakSelf.ocjEnum_listType = OCJCouponDetailListTypeALL;
                [weakSelf ocj_trackEventID:@"AP1706C040F012001O006001" parmas:nil];
            }break;
            case 1:{
                weakSelf.ocjEnum_listType = OCJCouponDetailListTypeNoUse;
                [weakSelf ocj_trackEventID:@"AP1706C040F012001O006002" parmas:nil];
            }break;
            case 2:{
                weakSelf.ocjEnum_listType = OCJCouponDetailListTypeUsed;
                [weakSelf ocj_trackEventID:@"AP1706C040F012001O006003" parmas:nil];
            }break;
        }
        
    };
  
  ocjView_selected.backgroundColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
  [view addSubview:ocjView_selected];
  [ocjView_selected mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(view.mas_left);
    make.right.mas_equalTo(view.mas_right);
    make.bottom.mas_equalTo(view.mas_bottom).offset(-0.5);
    make.top.mas_equalTo(view);
  }];
  
    return view;
}

- (void)ocj_textFieldValueChanged:(UITextField *)currentTF {
    if ([self.ocjTF_coupon.text length] > 0) {
        self.ocjBtn_exchange.userInteractionEnabled = YES;
        self.ocjBtn_exchange.alpha = 1.0;
    }else {
        self.ocjBtn_exchange.userInteractionEnabled = NO;
        self.ocjBtn_exchange.alpha = 0.2;
    }
}

#pragma mark - 按钮点击事件
/**
 抢券
 */
- (void)ocj_clickedGetCouponBtn {
    [self ocj_trackEventID:@"AP1706C040C005001A001001" parmas:nil];
  
    [self ocj_pushVC:[[OCJGetCouponVC alloc] init]];
}


/**
 确认兑换
 */
- (void)ocj_clickedExchangeBtn {
  
    [self ocj_trackEventID:@"AP1706C040F008001O008001" parmas:nil];
  
    [OCJHttp_myWalletAPI ocjWallet_exchangeTaoCouponWithCouponNO:self.ocjTF_coupon.text completionhandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
        }
    }];
}

/**
 点击显示(隐藏)全部即将过期抵用券
 */
- (void)ocj_clickedArrowBtn {
    self.isSHowAllInvalid = !self.isSHowAllInvalid;
    [self.ocjTBView_coupon reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - 协议方法实现区域
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.ocjEnum_listType == OCJCouponDetailListTypeALL && self.ocjArr_couponList.count == 0) {
    return 0;
  }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ocjArr_couponList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cellName";
    OCJShoppingPOPCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[OCJShoppingPOPCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
  
    cell.cellDelegate = self;
    OCJWalletModel_CouponListDesc *model = self.ocjArr_couponList[indexPath.row];
    cell.ocjModel_couponListDesc = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [self ocj_addShowAllCouponsHeaderView];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - OCJShoppingPOPCouponCellDelegate
- (void)ocj_clickedCouponCellWithCell:(OCJShoppingPOPCouponCell *)cell andCouponNo:(NSString *)couponNo {
    
    OCJLog(@"立即使用");
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
