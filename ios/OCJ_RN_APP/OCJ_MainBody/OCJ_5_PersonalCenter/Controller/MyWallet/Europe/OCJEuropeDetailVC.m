//
//  OCJEuropeDetailVC.m
//  OCJ
//
//  Created by OCJ on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJEuropeDetailVC.h"
#import "OCJBaseTableView.h"
#import "OCJEuropeModel.h"
#import "OCJEurpoeTVCell.h"
#import "OCJLoginVC.h"
#import "OCJSelectedView.h"
#import "OCJHttp_myWalletAPI.h"
#import "UITableView+OCJTableView.h"
#import "OCJScanJumpWebVC.h"
#import "OCJRegisterCenterVC.h"
#import "OCJRouter.h"

static int OCJ_PAGE_SIZE = 10;

/*
 欧点记录类型
 */
typedef NS_ENUM(NSInteger,OCJEuropeListType) {
    OCJEuropeListTypeAll = 0, ///< 全部
    OCJEuropeListTypeWillPast,///< 即将过期
    OCJEuropeListTypeUsed,    ///< 使用过的
    OCJEuropeListTypeGet      ///< 获得过的
};

@interface OCJEuropeDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIImageView   * ocjView_nav;            ///< 导航栏视图
@property (nonatomic,strong) UIButton * ocjBtn_pay;                  ///< 花欧点
@property (nonatomic,strong) UIButton * ocjBtn_make;                 ///< 赚欧点
@property (nonatomic,strong) OCJBaseLabel  * ocjLab_tip;             ///< 提示
@property (nonatomic,strong) OCJBaseLabel  * ocjLab_money;           ///< 欧点
@property (nonatomic,strong) OCJBaseTableView * ocj_tableView;       ///< tableView
@property (nonatomic,strong) NSMutableArray * ocjArr_europeList;     ///< 数据源
@property (nonatomic,assign) float ocj_lasContentOffset;             ///< 偏移量
@property (nonatomic) OCJEuropeListType ocjEnum_listType;            ///< 列表数据类型
@property (nonatomic) NSInteger ocjInt_page;                         ///< 数据页码
@property (nonatomic,strong) UIButton *ocjBtn_last;                  ///< 筛选标签按钮

@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;            ///<状态栏颜色

@end

@implementation OCJEuropeDetailVC

#pragma mark - 生命周期方法区域
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 接口方法实现区域（包括setter、getter方法）

#pragma mark - 私有方法区域
- (void)ocj_loginedAndLoadNetWorkData{
    
    [self ocj_requestEurope:nil];
}

-(void)ocj_back{
  [super ocj_back];
  
  [self ocj_trackEventID:@"AP1706C042D003001C003001" parmas:nil];
  
}

-(void)ocj_setSelf{
  self.ocjStr_trackPageID = @"AP1706C042";
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocj_reloadEuropeData) name:@"OCJReloadEurope" object:nil];
  [self ocj_setUI];
  [self ocj_requestEurope:nil];
}

/**
 花鸥点跳转h5回来时刷新页面
 */
- (void)ocj_reloadEuropeData {
  [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notification_personalCenter object:nil userInfo:@{}];
  [self ocj_requestEurope:nil];
}

/**
 请求数据
 */
- (void)ocj_requestEurope:(void(^)())completion{
    NSString* listType;
    switch (self.ocjEnum_listType) {
        case OCJEuropeListTypeAll:
        {
            listType = @"1";
        }break;
        case OCJEuropeListTypeWillPast:
        {
            listType = @"4";
        }break;
        case OCJEuropeListTypeUsed:
        {
            listType = @"3";
        }break;
        case OCJEuropeListTypeGet:
        {
            listType = @"2";
        }break;
    }
    
    ///（1-全部 2-获取记录 3-使用记录 4-即将过期）
    [OCJHttp_myWalletAPI ocjWallet_europeDetailWithType:listType page:self.ocjInt_page completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJWalletModel_EuropseDetail * model = (OCJWalletModel_EuropseDetail *)responseModel;
      if ([model.ocjStr_code isEqualToString:@"200"]) {
        
        NSArray * tempArray = model.ocjArr_opointList;
        if (self.ocjEnum_listType == OCJEuropeListTypeAll && tempArray.count == 0) {
          self.ocj_tableView.ocjDic_NoData = @{@"image":@"img_score",
                                                  @"tipStr":@"怎么可以没有抵用券,你值得拥有~"};
          [self.ocj_tableView reloadData];
        }else if (tempArray.count == 0) {
          self.ocj_tableView.ocjDic_NoData = @{@"image":@"img_empty",
                                                  @"tipStr":@"您还没有记录哦~,我还要孤单多久"};
          [self.ocj_tableView reloadData];
        }else {
          NSArray * preBargainList = [OCJEuropeModel ocj_getPreBargainListModelsFromArray:tempArray];
          NSInteger moreCount = self.ocjArr_europeList.count % OCJ_PAGE_SIZE;//不满页数据的数量
          if (moreCount == 0) {
            [self.ocjArr_europeList addObjectsFromArray:preBargainList];
          }else{
            [self.ocjArr_europeList replaceObjectsInRange:NSMakeRange((self.ocjInt_page-1)*OCJ_PAGE_SIZE, moreCount) withObjectsFromArray:preBargainList];
          }
          
          if (tempArray.count == OCJ_PAGE_SIZE) {
            self.ocjInt_page++; //翻页
          }
          
          [self.ocj_tableView reloadData];
        }
        if (completion) {
          completion();
        }
      }
    }];
    
    [OCJHttp_myWalletAPI ocjWallet_checkEuropeNumCompletionHandler:^(OCJBaseResponceModel *responseModel) {
        self.ocjLab_money.text = [[responseModel.ocjDic_data objectForKey:@"num"] description];
    }];
}

- (void)ocj_setUI{
    [self.view addSubview:self.ocjView_nav];
    [self ocj_setNavView];
    [self.ocjView_nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(165);
    }];
    
    [self.view addSubview:self.ocj_tableView];
    [self ocj_setTableView];
    [self.ocj_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjView_nav.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)ocj_setNavView{
    
    OCJBaseButton * ocjBtn_back = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [ocjBtn_back addTarget:self action:@selector(ocj_back) forControlEvents:UIControlEventTouchUpInside];
    [ocjBtn_back setImage:[UIImage imageNamed:@"icon_left"] forState:UIControlStateNormal];
    [self.ocjView_nav addSubview:ocjBtn_back];
    [ocjBtn_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_nav).offset(0);
        make.top.mas_equalTo(self.ocjView_nav).offset(20);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    UILabel * ocjLab_title = [[UILabel alloc]init];
    ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    ocjLab_title.font = [UIFont systemFontOfSize:17];
    ocjLab_title.text = @"鸥点详情";
    ocjLab_title.textAlignment = NSTextAlignmentCenter;
    [self.ocjView_nav addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(24);
        make.centerX.mas_equalTo(self.ocjView_nav.mas_centerX);
        make.top.mas_equalTo(self.ocjView_nav).offset(29);
    }];
    
    self.ocjLab_money = [[OCJBaseLabel alloc]init];
    self.ocjLab_money.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    self.ocjLab_money.font = [UIFont systemFontOfSize:35];
    [self.ocjView_nav addSubview:self.ocjLab_money];
    [self.ocjLab_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_nav.mas_left).offset(30);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.ocjView_nav.mas_bottom).offset(-20);
    }];

    self.ocjLab_tip = [[OCJBaseLabel alloc]init];
    self.ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    self.ocjLab_tip.font = [UIFont systemFontOfSize:13];
    self.ocjLab_tip.text = @"当前鸥点 (个)";
    self.ocjLab_tip.textAlignment = NSTextAlignmentLeft;
    [self.ocjView_nav addSubview:self.ocjLab_tip];
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_nav).offset(30);
        make.height.mas_equalTo(18.5);
        make.bottom.mas_equalTo(self.ocjLab_money.mas_top).offset(-10);
    }];
    
    self.ocjBtn_pay= [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    self.ocjBtn_pay.layer.masksToBounds = YES;
    self.ocjBtn_pay.layer.cornerRadius= 2;
    self.ocjBtn_pay.layer.borderColor  =[UIColor whiteColor].CGColor;
    self.ocjBtn_pay.backgroundColor = [UIColor clearColor];
    self.ocjBtn_pay.layer.borderWidth = 0.5;
  [self.ocjBtn_pay addTarget:self action:@selector(ocj_clickedPayBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_nav addSubview:self.ocjBtn_pay];
    [self.ocjBtn_pay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(self.ocjView_nav).offset(-15);
        make.top.mas_equalTo(self.ocjView_nav).offset(70);
    }];
    
    UIImageView * ocjImg_pay = [[UIImageView alloc]init];
    [ocjImg_pay setImage:[UIImage  imageNamed:@"icon_expendituregulls"]];
    ocjImg_pay.layer.masksToBounds = YES;
    ocjImg_pay.layer.cornerRadius = 8;
    [self.ocjBtn_pay addSubview:ocjImg_pay];
    [ocjImg_pay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(self.ocjBtn_pay.mas_centerY);
        make.left.mas_equalTo(self.ocjBtn_pay).offset(10);
    }];
    
    OCJBaseLabel * ocjLab_payTip = [[OCJBaseLabel alloc]init];
    ocjLab_payTip.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    ocjLab_payTip.font = [UIFont systemFontOfSize:14];
    ocjLab_payTip.text = @"花鸥点";
    ocjLab_payTip.textAlignment = NSTextAlignmentRight;
    [self.ocjBtn_pay addSubview:ocjLab_payTip];
    [ocjLab_payTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.ocjBtn_pay.mas_centerY);
        make.right.mas_equalTo(self.ocjBtn_pay).offset(-5);
    }];
    
    
    self.ocjBtn_make = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    self.ocjBtn_make.layer.masksToBounds = YES;
    self.ocjBtn_make.layer.cornerRadius= 2;
    self.ocjBtn_make.layer.borderColor  =[UIColor whiteColor].CGColor;
    self.ocjBtn_make.layer.borderWidth = 0.5;
  [self.ocjBtn_make addTarget:self action:@selector(ocj_clickedMakeMoneyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_nav addSubview:self.ocjBtn_make];
    [self.ocjBtn_make mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(self.ocjView_nav).offset(-15);
        make.bottom.mas_equalTo(self.ocjView_nav.mas_bottom).offset(-25);
    }];
    
    UIImageView * ocjImg_make = [[UIImageView alloc]init];
    ocjImg_make.layer.masksToBounds = YES;
    [ocjImg_make setImage:[UIImage imageNamed:@"icon_earngulls"]];
    ocjImg_make.layer.cornerRadius = 8;
    [self.ocjBtn_make addSubview:ocjImg_make];
    [ocjImg_make mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(self.ocjBtn_make.mas_centerY);
        make.left.mas_equalTo(self.ocjBtn_make).offset(10);
    }];
    
    OCJBaseLabel * ocjLab_makeMoneyTip = [[OCJBaseLabel alloc]init];
    ocjLab_makeMoneyTip.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    ocjLab_makeMoneyTip.font = [UIFont systemFontOfSize:14];
    ocjLab_makeMoneyTip.text = @"赚鸥点";
    ocjLab_makeMoneyTip.textAlignment = NSTextAlignmentRight;
    [self.ocjBtn_make addSubview:ocjLab_makeMoneyTip];
    [ocjLab_makeMoneyTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.ocjBtn_make.mas_centerY);
        make.right.mas_equalTo(self.ocjBtn_make).offset(-5);
    }];

}

- (void)ocj_setTableView{
    
    //==============刷新块==============
    [self.ocj_tableView ocj_prepareRefreshing];
    self.ocjInt_page = 1;
    
    __weak OCJEuropeDetailVC* weakSelf = self;
    self.ocj_tableView.ocjBlock_headerRefreshing = ^{
        //下拉刷新
        OCJLog(@"下拉刷新");
        [weakSelf.ocjArr_europeList removeAllObjects];
        weakSelf.ocjInt_page = 1;
        [weakSelf ocj_requestEurope:^{
            [weakSelf.ocj_tableView ocj_endHeaderRefreshing];
        }];
        
    };
    
    self.ocj_tableView.ocjBlock_footerRefreshing = ^{
        //上拉刷新
        OCJLog(@"上拉刷新");
        
        [weakSelf ocj_requestEurope:^{
            BOOL isHaveMoreData = (weakSelf.ocjArr_europeList.count%OCJ_PAGE_SIZE==0);
            [weakSelf.ocj_tableView ocj_endFooterRefreshingWithIsHaveMoreData:isHaveMoreData];
        }];
        
    };
}
#pragma mark - 花鸥点、赚鸥点

/**
 花鸥点
 */
- (void)ocj_clickedPayBtn {
  [self ocj_trackEventID:@"AP1706C042F008001O008001" parmas:nil];
  
  UIViewController* vc = [[OCJRouter ocj_shareRouter]ocj_openVCWithType:OCJRouterOpenTypePush routerKey:@"iOSocj_WebView" parmaters:@{@"url":@"http://m.ocj.com.cn/oclub/product",@"europe":@"YES"}];
  [vc.navigationController setNavigationBarHidden:YES];
}


/**
 赚鸥点
 */
- (void)ocj_clickedMakeMoneyBtn {
  [self ocj_trackEventID:@"AP1706C042F008002O008001" parmas:nil];
  
  OCJRegisterCenterVC *signVc = [[OCJRegisterCenterVC alloc] init];
  [self ocj_pushVC:signVc];
  
}

#pragma mark - getter
- (OCJBaseTableView *)ocj_tableView{
    if (!_ocj_tableView) {
        _ocj_tableView = [[OCJBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _ocj_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ocj_tableView.showsVerticalScrollIndicator = NO;
        _ocj_tableView.dataSource = self;
        _ocj_tableView.delegate   = self;
        _ocj_tableView.sectionFooterHeight = 0.0;
        _ocj_tableView.sectionHeaderHeight = 0.0;
        _ocj_tableView.tableFooterView = [[UIView alloc]init];
        _ocj_tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    }
    return _ocj_tableView;
}

- (UIImageView *)ocjView_nav{
    if (!_ocjView_nav) {
        _ocjView_nav = [[UIImageView alloc]init];
        _ocjView_nav.userInteractionEnabled = YES;
        [_ocjView_nav setImage:[UIImage imageNamed:@"icon_integralIcondetails_bg"]];
        
    }
    return _ocjView_nav;
}

- (NSMutableArray *)ocjArr_europeList{
    if (!_ocjArr_europeList) {
        _ocjArr_europeList = [NSMutableArray array];
    }
    return _ocjArr_europeList;
}

- (void)setOcjEnum_listType:(OCJEuropeListType)ocjEnum_listType{
    _ocjEnum_listType = ocjEnum_listType;
    self.ocjInt_page = 1;
    [self ocj_requestEurope:nil];
}

#pragma mark - 协议方法实现区域
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 65)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView * ocjView_line = [[UIView alloc]init];
    ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [view addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.bottom.mas_equalTo(view.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    OCJSelectedView * ocjView_selected = [[OCJSelectedView alloc]initWithTitleArray:[NSMutableArray arrayWithObjects:@"全部",@"即将过期",@"使用记录",@"获取记录", nil] andIndex:self.ocjBtn_last.tag] ;
    __weak OCJEuropeDetailVC *weakSelf = self;
    ocjView_selected.ocj_handler = ^(UIButton *currentBtn) {
        weakSelf.ocjBtn_last = currentBtn;
        [weakSelf.ocjArr_europeList removeAllObjects];
        switch (currentBtn.tag) {
          case 0:{
            weakSelf.ocjEnum_listType = OCJEuropeListTypeAll;
            [weakSelf ocj_trackEventID:@"AP1706C042F012001O006001" parmas:nil];
          }break;
          case 1:{
            weakSelf.ocjEnum_listType = OCJEuropeListTypeWillPast;
            [weakSelf ocj_trackEventID:@"AP1706C042F012001O006002" parmas:nil];
          }break;
          case 2:{
            weakSelf.ocjEnum_listType = OCJEuropeListTypeUsed;
            [weakSelf ocj_trackEventID:@"AP1706C042F012001O006003" parmas:nil];
          }break;
          case 3:{weakSelf.ocjEnum_listType = OCJEuropeListTypeGet;
            [weakSelf ocj_trackEventID:@"AP1706C042F012001O006004" parmas:nil];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.ocjEnum_listType == OCJEuropeListTypeAll && self.ocjArr_europeList.count == 0) {
    return 0;
  }
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ocjArr_europeList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"OCJScoreDetaiVCellIdentifer";
    OCJEurpoeTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OCJEurpoeTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    OCJEuropeModel * detailModel = [self.ocjArr_europeList objectAtIndex:indexPath.row];
    cell.ocjModel_score = detailModel;
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  self.ocj_lasContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.ocjArr_europeList.count>3) {
        if (self.ocj_lasContentOffset < scrollView.contentOffset.y) {
            //上滑
            [self ocj_updateTopViewFrame:scrollView.contentOffset.y];
        }else{
            //下滑
            [self ocj_updateBottomViewFrame:scrollView.contentOffset.y];
        }
    }
}

- (void)ocj_updateTopViewFrame:(CGFloat)contentOffset{

  if (self.ocjArr_europeList.count * 72 - self.ocj_tableView.frame.size.height > 100) {
    if (contentOffset > 50 && contentOffset < 100) {
      
      [UIView animateWithDuration:0 animations:^{
        [self.ocjLab_tip mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(0);
        }];
        self.ocjLab_tip.hidden = YES;
        
        [self.ocjBtn_make mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(0);
        }];
        
        [self.ocjLab_money mas_updateConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(self.ocjView_nav.mas_bottom).offset(-15);
        }];
        
        [self.ocjView_nav mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(120);
        }];
      }];
    }
  }
  
}

- (void)ocj_updateBottomViewFrame:(CGFloat)contentOffset{
  if (self.ocjArr_europeList.count * 72 - self.ocj_tableView.frame.size.height) {
    if (contentOffset <= 50 ) {
      self.ocjLab_tip.hidden = NO;
      [UIView animateWithDuration:0 animations:^{
        [self.ocjLab_tip mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(18.5);
        }];
        
        [self.ocjBtn_make mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(25);
        }];
        
        [self.ocjLab_money mas_updateConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(self.ocjView_nav.mas_bottom).offset(-20);
        }];
        
        [self.ocjView_nav mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(165);
        }];
      }];
    }
  }
  
}


@end
