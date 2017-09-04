//
//  OCJVipAreaVC.m
//  OCJ
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJVipAreaVC.h"
#import "OCJVipAreaCell.h"
#import "OCJVipAreaCell3.h"
#import "OCJBannerScrView.h"

#import "VipAreaHomeModel.h"
#import "UIImage+WSHHExtension.h"
#import "OCJ_VipAreaHttpAPI.h"

//仅头部下拉刷新
#import "MJRefresh.h"
@interface OCJBaseTableView (VipExtend)
-(void)ocj_prepareHeaderRefreshing;
@end

@implementation OCJBaseTableView (VipExtend)

-(void)headerRefreshForVipArea{
  if (self.ocjBlock_headerRefreshing) self.ocjBlock_headerRefreshing();
}

-(void)ocj_prepareHeaderRefreshing{
  self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshForVipArea)];
  self.mj_header.automaticallyChangeAlpha = YES;
  
}
@end


@interface OCJVipAreaVC () <UITableViewDelegate, UITableViewDataSource,OCJVIPAreaCellDelegate>

@property (nonatomic, weak) OCJBaseTableView *tableView;

@property (nonatomic,strong) OCJVIPModel_Detail* ocjModel_vipDetail; ///< 承载本页所有数据的model


@property (nonatomic,strong) UIImage* ocjImage_frontNaviBG;
@property (nonatomic,strong) UIColor* ocjColor_frontNaviTint;
@end

@implementation OCJVipAreaVC

#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  [self ocj_setNavUI];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  
  [self ocj_resetNavigation];
  
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf{
  
  [self setupTbView];
  
  [self netRequest];
}

- (void)ocj_setNavUI{
    self.ocjImage_frontNaviBG = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWSHHWithColor:[UIColor colorWSHHFromHexString:@"#333333"]] forBarMetrics:UIBarMetricsDefault];
    
    UIImageView* titleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 71, 20)];
    titleView.image = [UIImage imageNamed:@"vip_naviTitleView"];
    self.navigationItem.titleView = titleView;
    
    self.ocjColor_frontNaviTint =  self.navigationController.navigationBar.tintColor;
    self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
}

- (void)ocj_resetNavigation{
  
  [self.navigationController.navigationBar setBackgroundImage:self.ocjImage_frontNaviBG forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.tintColor= self.ocjColor_frontNaviTint;
}

-(void)ocj_loginedAndLoadNetWorkData{
  
  [self netRequest];
}

- (void)netRequest{
    [OCJ_VipAreaHttpAPI ocjVipArea_checkHomeHandler:^(OCJBaseResponceModel *responseModel) {
        
        self.ocjModel_vipDetail = (OCJVIPModel_Detail*)responseModel;
        self.ocjStr_trackPageVersion = self.ocjModel_vipDetail.ocjStr_pageVersionName;
        self.ocjStr_trackPageID = self.ocjModel_vipDetail.ocjStr_codeValue;

        [self.tableView ocj_endHeaderRefreshing];
        [self.tableView reloadData];
    }];
}

static NSString* VipAreaHorCellID = @"VipAreaHorCellID";
static NSString* VipAreaVerCellID2 = @"VipAreaVerCellID2";
static NSString* OCJBannerCellID = @"OCJBannerCellID";

- (void)setupTbView{
  
    OCJBaseTableView *tbView = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tbView.backgroundColor = OCJ_COLOR_BACKGROUND;
    
    [tbView ocj_prepareHeaderRefreshing];
    
    __weak typeof(self) weakSelf = self;
    tbView.ocjBlock_headerRefreshing = ^{
        //下拉刷新
        [weakSelf netRequest];
    };
    
    [self.view addSubview:tbView];
    [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [tbView registerClass:[OCJVipAreaCell class] forCellReuseIdentifier:VipAreaHorCellID];
    [tbView registerClass:[OCJVipAreaCell3 class] forCellReuseIdentifier:VipAreaVerCellID2];
    [tbView registerClass:[OCJBannerScrView class] forCellReuseIdentifier:OCJBannerCellID];
    
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView = tbView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        return self.ocjModel_vipDetail.ocjModel_vipChoicenessDetail.ocjArr_vipChoicenessItems.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OCJBannerScrView *bannerCell = [tableView dequeueReusableCellWithIdentifier:OCJBannerCellID forIndexPath:indexPath];
        bannerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return bannerCell;
    }else if (indexPath.section == 1) {
        OCJVipAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:VipAreaHorCellID forIndexPath:indexPath];
        cell.ocjDelegate = self;
        cell.ocjModel_brandDetail = self.ocjModel_vipDetail.ocjModel_brandDetail;
        return cell;
    }else if (indexPath.section == 2) {
        OCJVipAreaCell3 *cell = [tableView dequeueReusableCellWithIdentifier:VipAreaVerCellID2 forIndexPath:indexPath];
        cell.ocjModel_choicenessItem = self.ocjModel_vipDetail.ocjModel_vipChoicenessDetail.ocjArr_vipChoicenessItems[indexPath.row];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 220;
    }else if (indexPath.section==1) {
        
        return [OCJVipAreaCell ocj_getCellHeight];
        
    }else if (indexPath.section == 2){
        
        return 140;
    }
    return 565*0.5;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 45;
    }
    
    return 0.01;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    footerView.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    return footerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        
        UILabel* headerLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        headerLab.backgroundColor = [UIColor whiteColor];
        headerLab.text = @"·VIP精选·";
        headerLab.textColor = [UIColor colorWSHHFromHexString:@"#B3792C"];
        headerLab.font = [UIFont systemFontOfSize:16];
        headerLab.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:headerLab];
        
        UILabel* horSep = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
        horSep.backgroundColor = [UIColor colorWSHHFromHexString:@"#DDDDDD"];
        [headerLab addSubview:horSep];
        
        return headerView;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
      OCJVIPModel_VIPChoicenessItem* model = self.ocjModel_vipDetail.ocjModel_vipChoicenessDetail.ocjArr_vipChoicenessItems[indexPath.row];
      
      [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];
      
      NSString* itemCode = model.ocjStr_itemCode;
      if (itemCode.length==0) {
        [OCJProgressHUD ocj_showHudWithTitle:@"商品编码为空" andHideDelay:2];
        return;
      }
      
      if (self.ocjNavigationController.ocjCallback ) {
        
        self.ocjNavigationController.ocjCallback(@{@"itemcode":itemCode,@"beforepage":@"VIP",@"targetRNPage":@"GoodsDetailMain"});
        [self ocj_popToNavigationRootVC];
      }
    }
}


#pragma mark - OCJVIPAreaCellDelegate
-(void)ocj_vipAreaCell:(OCJVipAreaCell *)cell clickGoodIndex:(NSInteger)index{
    NSInteger goodIndex = index -100;
    
    OCJVIPModel_BrandItem* brandItem =  self.ocjModel_vipDetail.ocjModel_brandDetail.ocjArr_brandItems[goodIndex];
  
    [self ocj_trackEventID:brandItem.ocjStr_codeValue parmas:nil];
  
    NSString* itemCode = brandItem.ocjStr_itemCode;
    if (itemCode.length==0) {
      [OCJProgressHUD ocj_showHudWithTitle:@"商品编码为空" andHideDelay:2];
      return;
    }
  
    if (self.ocjNavigationController.ocjCallback) {
      
      self.ocjNavigationController.ocjCallback(@{@"itemcode":itemCode,@"beforepage":@"VIP",@"targetRNPage":@"GoodsDetailMain"});
      [self ocj_popToNavigationRootVC];
    }
  
}



@end
