//
//  OCJScoreDetailVC.m
//  OCJ
//
//  Created by OCJ on 2017/5/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJScoreDetailVC.h"
#import "OCJBaseTableView.h"
#import "OCJScoreDetailTVCell.h"
#import "OCJScoreDetaiModel.h"
#import "OCJLoginVC.h"
#import "OCJSelectedView.h"
#import "OCJExchangeGiftCertificateVC.h"
#import "OCJHttp_myWalletAPI.h"
#import "OCJResponceModel_myWallet.h"
#import "UITableView+OCJTableView.h"

static int OCJ_PAGE_SIZE = 10;

/*
 积分记录类型
 */
typedef NS_ENUM(NSInteger,OCJScoreListType) {
    OCJScoreListTypeAll = 0,        ///< 全部
    OCJScoreListTypeWillExpired,    ///< 即将过期
    OCJScoreListTypeUseRecord ,     ///< 使用记录
    OCJScoreListTypeGetRecord       ///< 获取记录
};


@interface OCJScoreDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIImageView       * ocjView_nav;         ///< 导航栏视图
@property (nonatomic,strong) UIView            * ocjView_adv;         ///< 广告视图
@property (nonatomic,strong) OCJBaseTableView  * ocj_tableView;       ///< tableView
@property (nonatomic,strong) OCJBaseLabel      * ocjLab_score;        ///< 余额控件
@property (nonatomic,strong) NSMutableArray    * ocjArr_scoreList;    ///< 数据源
@property (nonatomic)        OCJScoreListType    ocjEnum_listType;    ///< 列表数据类型
@property (nonatomic)        NSInteger           ocjInt_page;         ///< 数据页码
@property (nonnull,strong) UIButton            * ocjBtn_last;         ///< 筛选标签按钮

@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;             ///<状态栏颜色

@end

@implementation OCJScoreDetailVC

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
- (void)setOcjEnum_listType:(OCJScoreListType)ocjEnum_listType{
    _ocjEnum_listType = ocjEnum_listType;
    self.ocjInt_page = 1;
    [self requestScore:nil];
}
#pragma mark - 私有方法区域
- (void)ocj_loginedAndLoadNetWorkData{
    [self requestScore:nil];
}

-(void)ocj_back{
  [super ocj_back];
  
  [self ocj_trackEventID:@"AP1706C037C005001C003001" parmas:nil];
}

- (void)ocj_setSelf{
  self.ocjStr_trackPageID = @"AP1706C037";
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocj_reloadScoreDetail) name:OCJ_Notification_personalCenter object:nil];
    [self ocj_setUI];
    [self requestScore:nil];
}
- (void)setOcjBool_showTip:(BOOL)ocjBool_showTip{
    if (ocjBool_showTip) {
        [self ocjDisMissAdView];
    }
}
//兑换积分成功回来刷新数据
- (void)ocj_reloadScoreDetail {
  [self requestScore:nil];
}
- (void)ocj_setTableView{
    
    //==============刷新块==============
    [self.ocj_tableView ocj_prepareRefreshing];
    self.ocjInt_page = 1;
    
    __weak OCJScoreDetailVC* weakSelf = self;
    self.ocj_tableView.ocjBlock_headerRefreshing = ^{
        //下拉刷新
        OCJLog(@"下拉刷新");
        weakSelf.ocjInt_page = 1;
        [weakSelf requestScore:^{
            [weakSelf.ocj_tableView ocj_endHeaderRefreshing];
        }];
    };
    
    self.ocj_tableView.ocjBlock_footerRefreshing = ^{
        //上拉刷新
        OCJLog(@"上拉刷新");
        [weakSelf requestScore:^{
            BOOL isHaveMoreData = (weakSelf.ocjArr_scoreList.count % OCJ_PAGE_SIZE==0);
            [weakSelf.ocj_tableView ocj_endFooterRefreshingWithIsHaveMoreData:isHaveMoreData];
        }];
    };
}

- (void)requestScore:(void(^)())completion{
    NSString* listType;
    switch (self.ocjEnum_listType) {
        case OCJScoreListTypeAll:
        {
            listType = @"-1";
        }break;
        case OCJScoreListTypeWillExpired:
        {
            listType = @"3";
        }break;
        case OCJScoreListTypeUseRecord:
        {
            listType = @"1";
        }break;
        case OCJScoreListTypeGetRecord:
        {
            listType = @"0";
        }
    }
    
    [OCJHttp_myWalletAPI ocjWallet_scoreDetailWithType:listType page:self.ocjInt_page completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJWalletModel_ScoreDetail * model = (OCJWalletModel_ScoreDetail *)responseModel;
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        
        NSArray * tempArray = model.ocjArr_amtList;
        if (self.ocjEnum_listType == OCJScoreListTypeAll && tempArray.count == 0) {//全部数据为空
          self.ocj_tableView.ocjDic_NoData = @{@"image":@"img_score",
                                                  @"tipStr":@"怎么可以没有积分,下单就能赚"};
          [self.ocj_tableView reloadData];
        }else if (tempArray.count == 0) {
          self.ocj_tableView.ocjDic_NoData = @{@"image":@"img_empty",
                                                  @"tipStr":@"您还没有记录哦~,我还要孤单多久"};
          [self.ocj_tableView reloadData];
        }else {
          NSMutableArray * scoreList = [NSMutableArray array];
          for (NSDictionary * dic in tempArray) {
            OCJScoreDetaiModel * detailModel = [[OCJScoreDetaiModel alloc]init];
            [detailModel setValuesForKeysWithDictionary:dic];
            [scoreList addObject:detailModel];
          }
          
          NSInteger moreCount = self.ocjArr_scoreList.count % OCJ_PAGE_SIZE;//不满页数据的数量
          if (moreCount == 0) {
            [self.ocjArr_scoreList addObjectsFromArray:scoreList];
          }else{
            [self.ocjArr_scoreList replaceObjectsInRange:NSMakeRange((self.ocjInt_page-1)*OCJ_PAGE_SIZE, moreCount) withObjectsFromArray:scoreList];
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

    [OCJHttp_myWalletAPI ocjWallet_scoreQueryCompletionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJWalletModel_ScorecheckBalance * model = (OCJWalletModel_ScorecheckBalance *)responseModel;
        self.ocjLab_score.text = model.ocjStr_num;
        [self.ocj_tableView reloadData];
    }];
}

- (void)ocj_setUI{
    [self.view addSubview:self.ocjView_nav];
    [self.view addSubview:self.ocjView_adv];
    [self.view addSubview:self.ocj_tableView];
    self.ocjBool_showTip = YES;
    [self ocj_setTableView];
    [self.ocjView_nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(165);
    }];
    
    [self.ocjView_adv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjView_nav.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    [self.ocj_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjView_adv.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
}
- (UIView *)ocjView_adv{
    if (!_ocjView_adv) {
        _ocjView_adv = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 40)];
        _ocjView_adv.backgroundColor = [UIColor colorWSHHFromHexString:@"FFF7E5"];
        
        OCJBaseButton * ocjBtn_back = [OCJBaseButton buttonWithType:UIButtonTypeSystem];
        [ocjBtn_back setBackgroundImage:[UIImage imageNamed:@"con_tips"] forState:UIControlStateNormal];
        ocjBtn_back.backgroundColor = [UIColor clearColor];
        [_ocjView_adv addSubview:ocjBtn_back];
        [ocjBtn_back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_ocjView_adv).offset(15);
            make.centerY.mas_equalTo(_ocjView_adv);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15);
        }];
        
        OCJBaseLabel * ocjLab_title = [[OCJBaseLabel alloc]init];
        ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"DF2928"];
        ocjLab_title.font = [UIFont systemFontOfSize:13];
        ocjLab_title.text = @"";//@"您有26分 (=26元) 即将过期喔~";
        [_ocjView_adv addSubview:ocjLab_title];
        [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ocjBtn_back.mas_right).offset(10);
            make.top.mas_equalTo(ocjBtn_back);
            make.bottom.mas_equalTo(ocjBtn_back);
        }];
        
        OCJBaseButton * ocjBtn_right = [OCJBaseButton buttonWithType:UIButtonTypeSystem];
        [ocjBtn_right setBackgroundImage:[UIImage imageNamed:@"icon_close_red"] forState:UIControlStateNormal];
        [ocjBtn_right addTarget:self action:@selector(ocj_close) forControlEvents:UIControlEventTouchUpInside];
        [_ocjView_adv addSubview:ocjBtn_right];
        [ocjBtn_right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_ocjView_adv).offset(-10);
            make.centerY.mas_equalTo(_ocjView_adv);
            make.width.mas_equalTo(11);
            make.height.mas_equalTo(11);
        }];
    }
    return _ocjView_adv;
}
- (void)ocjDisMissAdView{
    [self.ocjView_adv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjView_nav.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    self.ocjView_adv.hidden = YES;
    
    [self.ocj_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjView_adv.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
}
- (void)ocj_close{
    [self ocjDisMissAdView];
}

- (UIImageView *)ocjView_nav{
    if (!_ocjView_nav) {
        _ocjView_nav = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 165)];
        [_ocjView_nav setImage:[UIImage imageNamed:@"icon_integralIcondetails_bg"]];
        _ocjView_nav.userInteractionEnabled = YES;
        
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
        ocjLab_title.text = @"积分详情";
        ocjLab_title.textAlignment = NSTextAlignmentCenter;
        [_ocjView_nav addSubview:ocjLab_title];
        [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(24);
            make.centerX.mas_equalTo(_ocjView_nav.mas_centerX);
            make.top.mas_equalTo(_ocjView_nav).offset(29);
        }];
        
        UIButton * ocjBtn_change = [UIButton buttonWithType:UIButtonTypeCustom];
        [ocjBtn_change setTitle:@"礼券兑换" forState:UIControlStateNormal];
        ocjBtn_change.titleLabel.font = [UIFont systemFontOfSize:14];
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
            make.width.mas_equalTo(@80);
        }];
        
        
        OCJBaseLabel * ocjLab_tip = [[OCJBaseLabel alloc]init];
        ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
        ocjLab_tip.font = [UIFont systemFontOfSize:13];
        ocjLab_tip.text = @"可用积分（1分=1元）";
        ocjLab_tip.textAlignment = NSTextAlignmentCenter;
        [_ocjView_nav addSubview:ocjLab_tip];
        [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_ocjView_nav).offset(30);
            make.height.mas_equalTo(24);
            make.top.mas_equalTo(_ocjView_nav).offset(67.5);
        }];
        
        self.ocjLab_score = [[OCJBaseLabel alloc]init];
        self.ocjLab_score.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
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
        [ocjBtn_help setBackgroundImage:[UIImage imageNamed:@"icon_question"] forState:UIControlStateNormal];
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
        ocjLab_fetchScore.text = @"如何获取积分";
        ocjLab_fetchScore.textAlignment = NSTextAlignmentRight;
        [_ocjView_nav addSubview:ocjLab_fetchScore];
        [ocjLab_fetchScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ocjBtn_help.mas_left).offset(-5);
            make.bottom.mas_equalTo(_ocjView_nav.mas_bottom).offset(-15);
            make.height.mas_equalTo(17);
            make.width.mas_equalTo(100);
        }];
      ocjLab_fetchScore.hidden = YES;
      ocjBtn_help.hidden = YES;
    }
    return _ocjView_nav;
}


/**
 礼券兑换
 */
- (void)ocj_switch{
    [self ocj_trackEventID:@"AP1706C037C005001A001001" parmas:nil];
  
    __weak OCJScoreDetailVC *weakSelf = self;
    OCJExchangeGiftCertificateVC * ocjExchange = [[OCJExchangeGiftCertificateVC alloc]init];
    ocjExchange.ocjExchangeScoreBlock = ^{
        [weakSelf requestScore:nil];
    };
    [self ocj_pushVC:ocjExchange];
}

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
- (NSMutableArray *)ocjArr_scoreList{
    if (!_ocjArr_scoreList) {
        _ocjArr_scoreList = [NSMutableArray array];
    }
    return _ocjArr_scoreList;
}

- (void)showAd{
    [self.ocjView_adv mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjView_nav.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    self.ocjView_adv.hidden = NO;
    [self.ocj_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjView_adv.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
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
    
    __weak OCJScoreDetailVC *weakSelf = self;
    OCJSelectedView * ocjView_selected = [[OCJSelectedView alloc]initWithTitleArray:[NSMutableArray arrayWithObjects:@"全部",@"即将过期",@"使用记录",@"获取记录", nil] andIndex:weakSelf.ocjBtn_last.tag] ;
    //点击事件
    ocjView_selected.ocj_handler = ^(UIButton *currentBtn) {
        weakSelf.ocjBtn_last = currentBtn;
        [weakSelf.ocjArr_scoreList removeAllObjects];
        switch (currentBtn.tag) {
            case 0:{
                weakSelf.ocjEnum_listType = OCJScoreListTypeAll;
                [weakSelf ocj_trackEventID:@"AP1706C037F012001O006001" parmas:nil];
            }break;
            case 1:{
                weakSelf.ocjEnum_listType = OCJScoreListTypeWillExpired;
                [weakSelf ocj_trackEventID:@"AP1706C037F012001O006002" parmas:nil];
            }break;
            case 2:{
                weakSelf.ocjEnum_listType = OCJScoreListTypeUseRecord;
                [weakSelf ocj_trackEventID:@"AP1706C037F012001O006003" parmas:nil];
            }break;
            case 3:{
                weakSelf.ocjEnum_listType = OCJScoreListTypeGetRecord;
                [weakSelf ocj_trackEventID:@"AP1706C037F012001O006004" parmas:nil];
            }break;
            default:
                break;
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
    return 95;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.ocjEnum_listType == OCJScoreListTypeAll && self.ocjArr_scoreList.count == 0) {
    return 0;
  }
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ocjArr_scoreList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"OCJScoreDetaiVCellIdentifer";
    OCJScoreDetailTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OCJScoreDetailTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    OCJScoreDetaiModel * detailModel = [self.ocjArr_scoreList objectAtIndex:indexPath.row];
    cell.ocjModel_score = detailModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showAd];
}
@end
