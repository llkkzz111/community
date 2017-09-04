//
//  OCJRewardVC.m
//  OCJ
//
//  Created by OCJ on 2017/5/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRewardVC.h"
#import "OCJBaseTableView.h"
#import "OCJRewardModel.h"
#import "OCJRewardTVCell.h"
#import "OCJLoginVC.h"
#import "OCJSelectedView.h"
#import "OCJExchangeGiftCertificateVC.h"
#import "OCJWalletRechargeVC.h"
#import "OCJHttp_myWalletAPI.h"
#import "UITableView+OCJTableView.h"
#import "OCJRewardVCModel.h"


static int OCJ_PAGE_SIZE = 10;

/*
 礼包记录类型
 */
typedef NS_ENUM(NSInteger,OCJRewardListType) {
    OCJRewardListTypeAll = 0, ///< 全部
    OCJRewardListTypeUsed,    ///< 使用过的
    OCJRewardListTypeGet    ///< 获得过的
};

@interface OCJRewardVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)  UIImageView        * ocjView_nav;       ///< 导航栏视图
@property (nonatomic,strong)  OCJBaseTableView   * ocj_tableView;     ///< tableView
@property (nonatomic,strong)  NSMutableArray     * ocjArr_rewardList; ///< 数据源
@property (nonatomic,strong)  OCJBaseLabel       * ocjLab_score;      ////< 余额
@property (nonatomic)         OCJRewardListType    ocjEnum_listType;  ///< 列表数据类型
@property (nonatomic)         NSInteger            ocjInt_page;       ///< 数据页码
@property (nonatomic, strong) UIButton           * ocjBtn_last;       ///< 筛选标签按钮

@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;         ///<状态栏颜色

@end

@implementation OCJRewardVC

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


#pragma mark - 接口方法实现区域（包括setter、getter方法）

#pragma mark - 私有方法区域
-(void)ocj_back{
  [super ocj_back];
  
  [self ocj_trackEventID:@"AP1706C043C005001C003001" parmas:nil];
  
}

- (void)ocj_setSelf {
  self.ocjStr_trackPageID = @"AP1706C043";
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocj_reloadBalanceData) name:OCJ_Notification_personalCenter object:nil];
  [self ocj_setUI];
  [self ocj_requestScore:nil];
}

- (void)ocj_reloadBalanceData {
  [self ocj_requestScore:nil];
}

- (void)ocj_loginedAndLoadNetWorkData{
    [self ocj_requestScore:nil];
}

- (void)ocj_requestScore:(void(^)())completion{
    NSString* listType;
    switch (self.ocjEnum_listType) {
        case OCJRewardListTypeAll:
        {
            listType = @"";
        }break;
        case OCJRewardListTypeUsed:
        {
            listType = @"2";
        }break;
        case OCJRewardListTypeGet:
        {
            listType = @"1";
        }break;
    }
    
    [OCJHttp_myWalletAPI ocjWallet_RewardWithType:listType page:self.ocjInt_page   completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJWalletModel_RewardDetail * model = (OCJWalletModel_RewardDetail *)responseModel;
      if ([model.ocjStr_code isEqualToString:@"200"]) {
        
        NSArray * tempArray = model.ocjArr_myEGiftCardList;
        if (self.ocjEnum_listType == OCJRewardListTypeAll && tempArray.count == 0) {
          self.ocj_tableView.ocjDic_NoData = @{@"image":@"img_gift",
                                                  @"tipStr":@"是时候去抱个大礼包啦!,别怪我没提醒你哦~"};
          [self.ocj_tableView reloadData];
        }else if (tempArray.count == 0) {
          self.ocj_tableView.ocjDic_NoData = @{@"image":@"img_empty",
                                                  @"tipStr":@"您还没有记录哦~,我还要孤单多久"};
          [self.ocj_tableView reloadData];
        }else {
          NSArray* rewardList = [OCJRewardVCModel ocj_getRewardListModelsFromArray:tempArray];
          NSInteger moreCount = self.ocjArr_rewardList.count % OCJ_PAGE_SIZE;//不满页数据的数量
          if (moreCount == 0) {
            [self.ocjArr_rewardList addObjectsFromArray:rewardList];
          }else{
            [self.ocjArr_rewardList replaceObjectsInRange:NSMakeRange((self.ocjInt_page-1)*OCJ_PAGE_SIZE, moreCount) withObjectsFromArray:rewardList];
          }
          
          if (tempArray.count == OCJ_PAGE_SIZE) {
            self.ocjInt_page++; //翻页
          }
          
        }
        [self.ocj_tableView reloadData];
        if (completion) {
          completion();
        }
      }
        
    }];
    
    [OCJHttp_myWalletAPI ocjWallet_RewardQueryCompletionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJWalletModel_RewardcheckBalance * model = (OCJWalletModel_RewardcheckBalance *)responseModel;
        self.ocjLab_score.text = model.ocjStr_num;
        
    }];
    
}

- (void)ocj_setUI{
    [self.view addSubview:self.ocjView_nav];
    [self.view addSubview:self.ocj_tableView];
    [self ocj_setTableView];
    [self.ocjView_nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(165);
    }];
    
    [self.ocj_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjView_nav.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)ocj_setTableView{
    
    //==============刷新块==============
    [self.ocj_tableView ocj_prepareRefreshing];
    self.ocjInt_page = 1;
    
    __weak OCJRewardVC* weakSelf = self;
    self.ocj_tableView.ocjBlock_headerRefreshing = ^{
      //下拉刷新
        OCJLog(@"下拉刷新");
        [weakSelf.ocjArr_rewardList removeAllObjects];
        weakSelf.ocjInt_page = 1;
        [weakSelf ocj_requestScore:^{
            [weakSelf.ocj_tableView ocj_endHeaderRefreshing];
        }];
        
    };
    
    self.ocj_tableView.ocjBlock_footerRefreshing = ^{
      //上拉刷新
        OCJLog(@"上拉刷新");
        
        [weakSelf ocj_requestScore:^{
            BOOL isHaveMoreData = (weakSelf.ocjArr_rewardList.count%OCJ_PAGE_SIZE==0);
            [weakSelf.ocj_tableView ocj_endFooterRefreshingWithIsHaveMoreData:isHaveMoreData];
        }];
        
    };
    
    
}


- (UIImageView *)ocjView_nav{
    if (!_ocjView_nav) {
        _ocjView_nav = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 165)];
        _ocjView_nav.userInteractionEnabled = YES;
        [_ocjView_nav setImage:[UIImage imageNamed:@"icon_integralIcondetails_bg"]];
        
        OCJBaseButton * ocjBtn_back = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
        [ocjBtn_back addTarget:self action:@selector(ocj_back) forControlEvents:UIControlEventTouchUpInside];
        [ocjBtn_back setImage:[UIImage imageNamed:@"icon_left"] forState:UIControlStateNormal];
        [_ocjView_nav addSubview:ocjBtn_back];
        [ocjBtn_back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_ocjView_nav).offset(0);
            make.top.mas_equalTo(_ocjView_nav).offset(20);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
        
        UILabel * ocjLab_title = [[UILabel alloc]init];
        ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
        ocjLab_title.font = [UIFont systemFontOfSize:17];
        ocjLab_title.text = @"礼包详情";
        ocjLab_title.textAlignment = NSTextAlignmentCenter;
        [_ocjView_nav addSubview:ocjLab_title];
        [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(24);
            make.centerX.mas_equalTo(_ocjView_nav.mas_centerX);
            make.top.mas_equalTo(_ocjView_nav).offset(29);
        }];
        
        OCJBaseButton * ocjBtn_change = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
        [ocjBtn_change setTitle:@"充值" forState:UIControlStateNormal];
        ocjBtn_change.ocjFont = [UIFont systemFontOfSize:14];
      ocjBtn_change.layer.cornerRadius = 2;
      ocjBtn_change.layer.borderWidth = 0.5;
      ocjBtn_change.layer.borderColor = [UIColor colorWSHHFromHexString:@"FFFFFF"].CGColor;
        [ocjBtn_change setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
        [ocjBtn_change addTarget:self action:@selector(ocj_switch) forControlEvents:UIControlEventTouchUpInside];
        [_ocjView_nav addSubview:ocjBtn_change];
        [ocjBtn_change mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_ocjView_nav).offset(-15);
            make.top.mas_equalTo(_ocjView_nav).offset(33);
            make.height.mas_equalTo(@25);
            make.width.mas_equalTo(@55);
        }];
        
        
        OCJBaseLabel * ocjLab_tip = [[OCJBaseLabel alloc]init];
        ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
        ocjLab_tip.font = [UIFont systemFontOfSize:13];
        ocjLab_tip.text = @"礼包余额 (元)";
        ocjLab_tip.textAlignment = NSTextAlignmentCenter;
        [_ocjView_nav addSubview:ocjLab_tip];
        [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_ocjView_nav).offset(30);
            make.height.mas_equalTo(24);
            make.top.mas_equalTo(_ocjView_nav).offset(67.5);
        }];
        
        self.ocjLab_score = [[OCJBaseLabel alloc]init];
        self.ocjLab_score.textColor = [UIColor whiteColor];
        self.ocjLab_score.font = [UIFont systemFontOfSize:35];
        self.ocjLab_score.textAlignment = NSTextAlignmentCenter;
        [_ocjView_nav addSubview:self.ocjLab_score];
        [self.ocjLab_score mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ocjLab_tip);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(ocjLab_tip.mas_bottom).offset(10);
        }];
        
        
        OCJBaseButton * ocjBtn_help = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
        ocjBtn_help.ocjFont = [UIFont systemFontOfSize:14];
        [ocjBtn_help setImage:[UIImage imageNamed:@"icon_question"] forState:UIControlStateNormal];
        ocjBtn_help.layer.masksToBounds = YES;
        [_ocjView_nav addSubview:ocjBtn_help];
        [ocjBtn_help mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_ocjView_nav).offset(-15);
            make.bottom.mas_equalTo(_ocjView_nav.mas_bottom).offset(-17);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(12);
        }];
        ocjBtn_help.layer.cornerRadius = 6;
        
        
        OCJBaseLabel * ocjLab_fetchScore = [[OCJBaseLabel alloc]init];
        ocjLab_fetchScore.textColor = [UIColor colorWSHHFromHexString:@"FCE9E6"];
        ocjLab_fetchScore.font = [UIFont systemFontOfSize:12];
        ocjLab_fetchScore.text = @"什么是礼包";
        ocjLab_fetchScore.textAlignment = NSTextAlignmentRight;
        [_ocjView_nav addSubview:ocjLab_fetchScore];
        [ocjLab_fetchScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ocjBtn_help.mas_left).offset(-5);
            make.bottom.mas_equalTo(_ocjView_nav.mas_bottom).offset(-15);
            make.height.mas_equalTo(17);
            make.width.mas_equalTo(80);
        }];
      ocjLab_fetchScore.hidden = YES;
      ocjBtn_help.hidden = YES;
    }
    return _ocjView_nav;
}


/**
 充值
 */
- (void)ocj_switch{
    [self ocj_trackEventID:@"AP1706C043C005001A001001" parmas:nil];
  
    OCJWalletRechargeVC * ocjExchange = [[OCJWalletRechargeVC alloc]init];
    [self ocj_pushVC:ocjExchange];
}

#pragma mark - getter
- (OCJBaseTableView *)ocj_tableView{
    if (!_ocj_tableView) {
        _ocj_tableView = [[OCJBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _ocj_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ocj_tableView.showsVerticalScrollIndicator = NO;
        _ocj_tableView.dataSource = self;
        _ocj_tableView.delegate = self;
        _ocj_tableView.sectionFooterHeight = 0.0;
        _ocj_tableView.sectionHeaderHeight = 0.0;
        _ocj_tableView.tableFooterView = [[UIView alloc]init];
        _ocj_tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    }
    return _ocj_tableView;
}

- (NSMutableArray *)ocjArr_rewardList{
    if (!_ocjArr_rewardList) {
        _ocjArr_rewardList = [NSMutableArray array];
    }
    return _ocjArr_rewardList;
}

#pragma mark - setter
-(void)setOcjEnum_listType:(OCJRewardListType)ocjEnum_listType{
    _ocjEnum_listType = ocjEnum_listType;
    self.ocjInt_page = 1;
    [self ocj_requestScore:nil];
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
    
    OCJSelectedView * ocjView_selected = [[OCJSelectedView alloc]initWithTitleArray:[NSMutableArray arrayWithObjects:@"全部",@"使用记录",@"获取记录", nil] andIndex:self.ocjBtn_last.tag] ;
    __weak OCJRewardVC* weakSelf = self;
    ocjView_selected.ocj_handler = ^(UIButton *currentBtn) {
        weakSelf.ocjBtn_last = currentBtn;
        [weakSelf.ocjArr_rewardList removeAllObjects];
        switch (currentBtn.tag) {
          case 0:{
            weakSelf.ocjEnum_listType = OCJRewardListTypeAll;
            [weakSelf ocj_trackEventID:@"AP1706C043F012001O006001" parmas:nil];
          }break;
          case 1:{
            weakSelf.ocjEnum_listType = OCJRewardListTypeUsed;
            [weakSelf ocj_trackEventID:@"AP1706C043F012001O006002" parmas:nil];
          }break;
          case 2:{
            weakSelf.ocjEnum_listType = OCJRewardListTypeGet;
            [weakSelf ocj_trackEventID:@"AP1706C043F012001O006003" parmas:nil];
          }break;
        }
    };
    
    ocjView_selected.backgroundColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    [view addSubview:ocjView_selected];
    [ocjView_selected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left);
        make.right.mas_equalTo(view.mas_right);
        make.bottom.mas_equalTo(view.mas_bottom).offset(-1);
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
  if (self.ocjEnum_listType == OCJRewardListTypeAll && self.ocjArr_rewardList.count == 0) {
    return 0;
  }
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ocjArr_rewardList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"OCJScoreDetaiVCellIdentifer";
    OCJRewardTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OCJRewardTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    OCJRewardModel * detailModel = [self.ocjArr_rewardList objectAtIndex:indexPath.row];
    cell.ocjModel_score = detailModel;
    return cell;
}

@end
