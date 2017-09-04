//
//  OCJGlobalShoppingVC.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobalShoppingVC.h"

#import "OCJGlobaShoppingTableViewHeadView.h"
#import "OCJClassificationTableViewCell.h"
#import "OCJShoppingGlobalTableViewCell.h"
#import "OCJOnTheNewTableViewCell.h"
#import "OCJImageTitleTableViewCell.h"
#import "OCJOverseasRecommendTableViewCell.h"
#import "OCJGlobalHotTableViewCell.h"
#import "OCJBannerTableViewCell.h"
#import "OCJSuperValueTableViewCell.h"
#import "OCJ_GlobalShoppingHttpAPI.h"

#import "OCJGlobalScreenVC.h"
#import "OCJ_RN_WebViewVC.h"

@interface OCJGlobalShoppingVC ()<UITableViewDelegate,UITableViewDataSource,OCJBannerTableViewCellDelegate,OCJClassificationTableViewCellDelegate,OCJShoppingGlobalTableViewCellDelegate,OCJOnTheNewTableViewCellCellDelegate,OCJImageTitleTableViewCellDelegate,OCJOverseasRecommendTableViewCellDelegate,OCJGlobalHotTableViewCellDelegate,OCJSuperValueTableViewCellDelegate,UIWebViewDelegate>
/**分页页码*/
@property (nonatomic,assign) NSInteger          ocjint_Page;
/**获取分页的id。从第一页接口中解析*/
@property (nonatomic,strong) NSString           *ocjStr_componentGoodId;
/**数据tableview容器*/
@property (nonatomic,strong) OCJBaseTableView    *ocjTableView_main;

/**超值推荐商品列表数组*/
@property (nonatomic,strong) NSMutableArray     *ocjArray_goodsList;

@property (nonatomic,strong) OCJGSModel_Detail* ocjModel_globalDetail;

@property (nonatomic,strong) UIImage* ocjImage_frontNaviBG;       ///<
@property (nonatomic,strong) UIColor* ocjColor_frontNaviTint;     ///<
@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;         ///<状态栏颜色

@property (nonatomic, assign) CGFloat row4Height;//自适应的cell高度
@property (nonatomic, assign) CGFloat row5Height;

@property (nonatomic,strong) UIButton     *ocjBtn_returnTop;

@end

@implementation OCJGlobalShoppingVC

#pragma mark - 接口方法实现区域（包括setter、getter方法）

#pragma mark - 生命周期方法区域

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  self.ocjStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  [self ocj_setNavUI];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:self.ocjStatusBarStyle];
  [self ocj_resetNavigation];
  
}


#pragma mark - 私有方法区域
-(void)ocj_setSelf{
  
  self.row4Height = 189+SCREEN_WIDTH*120/375;
  self.row5Height = 189+SCREEN_WIDTH*120/375;
  
  self.ocjStr_componentGoodId = @"";
  self.ocjint_Page = 2;
  
  [self ocj_setUI];
  [self ocj_requestGlobalHome:nil];
}

- (void)ocj_requestGlobalHome:(void(^)())completion{
    [OCJ_GlobalShoppingHttpAPI ocjGlobalShopping_checkHomeHandler:^(OCJBaseResponceModel *responseModel) {
        self.ocjModel_globalDetail = (OCJGSModel_Detail*)responseModel;
      
        //页面埋点
        self.ocjStr_trackPageVersion = self.ocjModel_globalDetail.ocjStr_pageVersionName;
        self.ocjStr_trackPageID = self.ocjModel_globalDetail.ocjStr_codeValue;
      
        self.ocjArray_goodsList  = [[self ocj_getSourceByIndex:13]mutableCopy];
        if (self.ocjArray_goodsList.count>0) {//取出分页索引ID
            OCJGSModel_Package44* model = self.ocjArray_goodsList[0];
            self.ocjStr_componentGoodId = model.ocjStr_id;
        }
        
        [self.ocjTableView_main reloadData];
        if (completion) {
            completion();
        }
    }];
}

-(OCJGSModel_Detail *)ocjModel_globalDetail{
  if (!_ocjModel_globalDetail) {
      _ocjModel_globalDetail = [[OCJGSModel_Detail alloc]init];
  }
  return _ocjModel_globalDetail;
}

- (void)ocj_requestGlobalHomeMore:(void(^)())completion{
    [OCJ_GlobalShoppingHttpAPI ocjGlobalShopping_checkHomeNext:self.ocjStr_componentGoodId PageNum:[NSString stringWithFormat:@"%ld",(long)self.ocjint_Page] PageSize:@"4"  complationHandler:^(OCJBaseResponceModel *responseModel) {
        OCJGSModel_MorePageList* model = (OCJGSModel_MorePageList *)responseModel;
      if (model.ocjArr_moreItems.count>0){
        [self.ocjTableView_main reloadData];
        [self.ocjArray_goodsList addObjectsFromArray:model.ocjArr_moreItems];
        self.ocjint_Page ++;
      }
      
        if (completion) {
            completion();
        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
  return UIStatusBarStyleLightContent;
}

- (void)ocj_setUI{
  
    [self.view addSubview:self.ocjTableView_main];
    [self ocj_setTableView];
    [self.ocjTableView_main mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
  
    [self.view addSubview:self.ocjBtn_returnTop];
    [self.ocjBtn_returnTop mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(self.view.mas_right).offset(-20);
      make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
      make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

- (void)ocj_setNavUI{
  self.navigationController.navigationBar.hidden = NO;
  
  UIImage *image = [UIImage imageNamed:@"icon_nav"];
  NSInteger leftCapWidth = image.size.width * 0.5;
  NSInteger topCapHeight = image.size.height * 0.5;
  UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
  
  self.ocjImage_frontNaviBG = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
  [self.navigationController.navigationBar setBackgroundImage:newImage forBarMetrics:UIBarMetricsDefault];
  
  UIImageView* titleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 63, 30)];
  titleView.image = [UIImage imageNamed:@"icon_nav_log"];
  self.navigationItem.titleView = titleView;
  
  self.ocjColor_frontNaviTint =  self.navigationController.navigationBar.tintColor;
  self.navigationController.navigationBar.tintColor= [UIColor whiteColor];
  
  UIButton * ocjBtn_ocj_clickMessageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
  [ocjBtn_ocj_clickMessageBtn setImage:[UIImage imageNamed:@"icon_message1_"] forState:UIControlStateNormal];
  [ocjBtn_ocj_clickMessageBtn addTarget:self action:@selector(ocj_clickMessageBtn) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ocjBtn_ocj_clickMessageBtn];
}

- (void)ocj_back{
  [super ocj_back];
  
  [self ocj_resetNavigation];
}

- (void)ocj_resetNavigation{
  
    self.navigationController.navigationBar.tintColor = self.ocjColor_frontNaviTint;
    [self.navigationController.navigationBar setBackgroundImage:self.ocjImage_frontNaviBG forBarMetrics:UIBarMetricsDefault];
  
}

//导航栏右侧按钮
- (void)ocj_clickMessageBtn {
    
  if (self.ocjNavigationController.ocjCallback) {
    
    self.ocjNavigationController.ocjCallback(@{@"beforepage":@"Global",@"targetRNPage":@"MessageListPage"});
    [self ocj_popToNavigationRootVC];
  }
}

- (void)ocj_setTableView{
    
    //==============刷新块==============
    [self.ocjTableView_main ocj_prepareRefreshing];
    __weak OCJGlobalShoppingVC* weakSelf = self;
    self.ocjTableView_main.ocjBlock_headerRefreshing = ^{
        //下拉刷新
        OCJLog(@"下拉刷新");
        weakSelf.ocjint_Page = 2;
        [weakSelf ocj_requestGlobalHome:^{
            [weakSelf.ocjTableView_main ocj_endHeaderRefreshing];
        }];
        
    };
    
    self.ocjTableView_main.ocjBlock_footerRefreshing = ^{
        //上拉加载更多
        OCJLog(@"上拉刷新");
        [weakSelf ocj_requestGlobalHomeMore:^{
            [weakSelf.ocjTableView_main ocj_endFooterRefreshingWithIsHaveMoreData:NO];
        }];
        
    };
}


- (NSArray *)ocj_ComparatorArrayWith:(NSArray *)array{
    NSComparator finderSort = ^(NSDictionary *data1,NSDictionary *data2){
        if ([[data1 objectForKey:@"shortNumber"] floatValue] > [[data2 objectForKey:@"shortNumber"] floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([[data1 objectForKey:@"shortNumber"] floatValue] < [[data2 objectForKey:@"shortNumber"] floatValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *rearray = [array sortedArrayUsingComparator:finderSort];
    return rearray;
}

- (NSArray*)ocj_getSourceByIndex:(NSInteger)index{
    NSArray* array = [NSArray array];
    if (index<self.ocjModel_globalDetail.ocjArr_packages.count) {
        array = self.ocjModel_globalDetail.ocjArr_packages[index];
    }
    return [array copy];
}

//回到顶部页面
- (void)ocj_returnPageTop
{
  [self.ocjTableView_main setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - getter
- (OCJBaseTableView *)ocjTableView_main{
    if (!_ocjTableView_main) {
        _ocjTableView_main = [[OCJBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _ocjTableView_main.backgroundColor = [UIColor clearColor];
        _ocjTableView_main.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ocjTableView_main.showsVerticalScrollIndicator = NO;
        _ocjTableView_main.dataSource = self;
        _ocjTableView_main.delegate   = self;
        _ocjTableView_main.sectionFooterHeight = 0.0;
        _ocjTableView_main.sectionHeaderHeight = 0.0;
    }
    return _ocjTableView_main;
}

- (UIButton *)ocjBtn_returnTop
{
  if (!_ocjBtn_returnTop) {
    _ocjBtn_returnTop = [[UIButton alloc] init];
    _ocjBtn_returnTop.backgroundColor = [UIColor clearColor];
    [_ocjBtn_returnTop setBackgroundImage:[UIImage imageNamed:@"Icon_btn_top"] forState:UIControlStateNormal];
    [_ocjBtn_returnTop addTarget:self action:@selector(ocj_returnPageTop) forControlEvents:UIControlEventTouchUpInside];
    _ocjBtn_returnTop.hidden = YES;
  }
  return _ocjBtn_returnTop;
}

- (NSMutableArray *)ocjArray_goodsList{
    if (!_ocjArray_goodsList) {
        _ocjArray_goodsList = [[NSMutableArray alloc] init];
    }
    return _ocjArray_goodsList;
}

#pragma mark - 协议方法实现区域 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat number = 0;
    switch (section) {
      case 1: {
        number = 6;
        break;
      }
        case 0:
        case 4:
        case 5:{
            number = 0.1;
            break;
        }
        case 2:
        case 3:
        case 6:
        case 7:
        case 8:{
            number = 53.5;
            break;
        }
        default:
        break;
    }
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
        case 4:
        case 5:{
            UIView *view = [[UIView alloc] init];
            return view;
            break;
        }
      case 1: {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        headerView.backgroundColor = [UIColor colorWSHHFromHexString:@"EDEDED"];
        return headerView;
        break;
      }
        case 2:{
            OCJGlobaShoppingTableViewHeadView *view = [[OCJGlobaShoppingTableViewHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 53.5) TitleText:@"· 平价好物 ·" SubTitleText:@"每天12:00更新" isShowLine:YES];
            return view;
            break;
        }
        case 3:{
            OCJGlobaShoppingTableViewHeadView *view = [[OCJGlobaShoppingTableViewHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 53.5) TitleText:@"· 本周新品 ·" SubTitleText:nil isShowLine:YES];
            return view;
            break;
        }
        case 6:{
            OCJGlobaShoppingTableViewHeadView *view = [[OCJGlobaShoppingTableViewHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 53.5) TitleText:@"· 海外大牌推荐 ·" SubTitleText:nil  isShowLine:YES];
            return view;
            break;
        }
        case 7:{
            OCJGlobaShoppingTableViewHeadView *view = [[OCJGlobaShoppingTableViewHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 53.5) TitleText:@"· 全球热门 ·" SubTitleText:nil isShowLine:YES];
            return view;
            break;
        }
        case 8:{
            OCJGlobaShoppingTableViewHeadView *view = [[OCJGlobaShoppingTableViewHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 53.5) TitleText:@"· 超值推荐 ·" SubTitleText:nil isShowLine:NO];
            return view;
            break;
        }
        default:
            break;
    }
    UIView *view = [[UIView alloc] init];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat number = 5;
    switch (indexPath.section) {
        case 0:
        {
            number = SCREEN_WIDTH*150/375;
            break;
        }
        case 1:
        {
            number = 109;
            break;
        }
        case 2:
        {
            number = 170;
            break;
        }
        case 3:
        {
            number = 205+SCREEN_WIDTH/3 - 53.5;
            break;
        }
        case 4:{
          number = self.row4Height;
          break;
        }
        case 5:
        {
          number = self.row5Height;
            break;
        }
        case 6:
        {
            number  = (SCREEN_WIDTH/3)*2;
            break;
        }
        case 7:
        {
            number  = SCREEN_WIDTH/3 + (SCREEN_WIDTH/2)*(121.5/187.5);
            break;
        }
        case 8:
        {
            number  = (SCREEN_WIDTH/2)-5+130;
            break;
        }
        default:
            break;
    }
    
    return number;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 1;
    switch (section) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        {
            number = 1;
            break;
        }
        case 8:
        {
            number = self.ocjArray_goodsList.count/2;
            if (self.ocjArray_goodsList.count%2 > 0) {
                number = number + 1;
            }
            break;
        }
        default:
            break;
    }
    
    return number;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            static NSString * cellIdentifierzeo = @"OCJBannerTableViewCell";
            OCJBannerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierzeo];
            if (!cell) {
                cell = [[OCJBannerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierzeo];
            }
            cell.delegate = self;
            [cell ocj_setBannerArray:[self ocj_getSourceByIndex:0]];
            
            return cell;
        }
        case 1:
        {
            static NSString * cellIdentifierone = @"OCJClassificationTableViewCell";
            OCJClassificationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierone];
            if (!cell) {
                cell = [[OCJClassificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierone];
            }
            cell.delegate = self;
            [cell ocj_setShowDataWithArray:[self ocj_getSourceByIndex:1]];
            return cell;
        }
        case 2:
        {
            static NSString * cellIdentifiersec = @"OCJShoppingGlobalTableViewCell";
            OCJShoppingGlobalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiersec];
            if (!cell) {
                cell = [[OCJShoppingGlobalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifiersec];
            }
            cell.delegate = self;
            [cell ocj_setShowDataWithArray:[self ocj_getSourceByIndex:2]];
          
            return cell;
        }
        case 3:
        {
            static NSString * cellIdentifierthr = @"OCJOnTheNewTableViewCell";
            OCJOnTheNewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierthr];
          
            if (!cell) {
                cell = [[OCJOnTheNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierthr];
            }
            cell.delegate = self;
            [cell ocj_setShowCollectionDataWithArray:[self ocj_getSourceByIndex:3]];
            [cell ocj_setShowSubDataWithArray:[self ocj_getSourceByIndex:4]];
            return cell;
        }
      case 4:{
        static NSString * cellIdentifierfour = @"OCJImageTitleTableViewCell";
        OCJImageTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierfour];
        
        if (!cell) {
          cell = [[OCJImageTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierfour];
        }
        cell.delegate = self;
        NSArray *arrayTitleData = @[];
        NSArray *arrayData = @[];
        
        arrayTitleData = [self ocj_getSourceByIndex:5];
        arrayData = [self ocj_getSourceByIndex:6];
        
        [cell ocj_setShowTitleDataWithArray:arrayTitleData];
        [cell ocj_setShowCollectionDataWithArray:arrayData];
        
        //刷新height
        __weak __typeof(tableView) weakTb = tableView;
        __weak __typeof(self) weakSelf = self;
        [cell setBackImageSize:^(CGSize imageSize) {
          if (weakSelf.row4Height != imageSize.height+189) {
            weakSelf.row4Height = imageSize.height+189;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [weakTb beginUpdates];
              [weakTb endUpdates];
            });
          }
        }];
        return cell;
      }
        case 5:
        {
            static NSString * cellIdentifierfour = @"OCJImageTitleTableViewCell";
            OCJImageTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierfour];
          
            if (!cell) {
                cell = [[OCJImageTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierfour];
            }
            cell.delegate = self;
            NSArray *arrayTitleData = @[];
            NSArray *arrayData = @[];
            if (indexPath.section == 4) {
                arrayTitleData = [self ocj_getSourceByIndex:5];
                arrayData = [self ocj_getSourceByIndex:6];
            }else
            {
                arrayTitleData = [self ocj_getSourceByIndex:7];
                arrayData = [self ocj_getSourceByIndex:8];
            }
            [cell ocj_setShowTitleDataWithArray:arrayTitleData];
            [cell ocj_setShowCollectionDataWithArray:arrayData];
          
          //刷新height
          __weak __typeof(tableView) weakTb = tableView;
          __weak __typeof(self) weakSelf = self;
          [cell setBackImageSize:^(CGSize imageSize) {
            if (weakSelf.row5Height != imageSize.height+189) {
              weakSelf.row5Height = imageSize.height+189;
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakTb beginUpdates];
                [weakTb endUpdates];
              });
            }
          }];
            
            return cell;
        }
        case 6:
        {
            static NSString * cellIdentifierfiv = @"OCJOverseasRecommendTableViewCell";
            OCJOverseasRecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierfiv];
            if (!cell) {
                cell = [[OCJOverseasRecommendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierfiv];
            }
            cell.delegate = self;
          
            NSMutableArray *arrayData = [[NSMutableArray alloc] init];
            [arrayData addObjectsFromArray:[self ocj_getSourceByIndex:9]];
            [arrayData addObjectsFromArray:[self ocj_getSourceByIndex:10]];
            [cell ocj_setShowDataWithArray:arrayData];
            return cell;
            
        }
        case 7:
        {
            static NSString * cellIdentifiersix = @"OCJGlobalHotTableViewCell";
            OCJGlobalHotTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiersix];
            if (!cell) {
                cell = [[OCJGlobalHotTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifiersix];
            }
            cell.delegate = self;
          
            NSMutableArray *arrayData = [[NSMutableArray alloc] init];
            [arrayData addObjectsFromArray:[self ocj_getSourceByIndex:11]];
            [arrayData addObjectsFromArray:[self ocj_getSourceByIndex:12]];
            [cell ocj_setShowDataWithArray:arrayData];
            return cell;
            
        }
        case 8:
        {
            static NSString * cellIdentifiersve = @"OCJSuperValueTableViewCell";
            OCJSuperValueTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiersve];
            if (!cell) {
                cell = [[OCJSuperValueTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifiersve];
            }
          
            cell.delegate =self;
            if (indexPath.row == self.ocjArray_goodsList.count/2 && self.ocjArray_goodsList.count%2 ==1) {
                [cell ocj_setShowDataWithArray:@[[self.ocjArray_goodsList lastObject]]];
            }else{
                [cell ocj_setShowDataWithArray:[self.ocjArray_goodsList subarrayWithRange:NSMakeRange(indexPath.row*2, 2)]];
            }
          
          //控制cell底部分割线是否显示
            BOOL isLastRow = self.ocjArray_goodsList.count%2==0?(indexPath.row == self.ocjArray_goodsList.count/2-1):(indexPath.row == self.ocjArray_goodsList.count/2);
            if (isLastRow) {//最后一行显示
                cell.ocjLab_bottomSep.alpha = 1;
            }else{
                cell.ocjLab_bottomSep.alpha = 0;
            }
          
            return cell;
        }
        
        default:return nil;
    }
  
  
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 400) {
      self.ocjBtn_returnTop.hidden = NO;
    }else
    {
      self.ocjBtn_returnTop.hidden = YES;
    }
}
// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  
}
// 滚动停止时，触发该函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  
}

#pragma mark - OCJBannerTableViewCellDelegate
/**
 广告栏点击-H5
 */
- (void)ocj_golbalHeadBannerPressed:(OCJGSModel_Package2 *)model
{
  NSString* h5Url = model.ocjStr_destinationUrl;
  
  [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];
  
  if (h5Url.length==0) {
    [OCJProgressHUD ocj_showHudWithTitle:@"H5网页地址为空" andHideDelay:2];
  }
  
  OCJ_RN_WebViewVC * webVC = [[OCJ_RN_WebViewVC alloc]init];
  webVC.ocjDic_router = @{@"url":h5Url};

  [self ocj_pushVC:webVC];
}

#pragma mark - OCJClassificationTableViewCellDelegate
/**
 分类点击
 */
- (void)ocj_golbalClassificationPressed:(OCJGSModel_Package4 *)model At:(OCJClassificationTableViewCell *)cell
{
    [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];
  
    OCJGlobalScreenVC *ctrl = [[OCJGlobalScreenVC alloc] initWithContentLGroup:model.ocjStr_lGroup contentType:model.ocjStr_contentType keyword:model.ocjStr_title];
  
    [self.navigationController pushViewController:ctrl animated:YES];

}

#pragma mark - OCJShoppingGlobalTableViewCellDelegate
/**
 200元购遍全球商品点击
 */
- (void)ocj_golbalShoppingPressed:(OCJGSModel_Package42*)model At:(OCJShoppingGlobalTableViewCell *)cell
{
  NSString* itemCode = model.ocjStr_itemCode;
  [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];
  
  if (itemCode.length==0) {
    [OCJProgressHUD ocj_showHudWithTitle:@"商品编号为空" andHideDelay:2];
  }
  
  if (self.ocjNavigationController.ocjCallback) {
    
    self.ocjNavigationController.ocjCallback(@{@"itemcode":itemCode,@"beforepage":@"Global",@"targetRNPage":@"GoodsDetailMain"});
    [self ocj_popToNavigationRootVC];
  }
  
}

#pragma mark - OCJShoppingGlobalTableViewCellDelegate
/**
 200元购遍全球查看更多
 */
- (void)ocj_200ShoppingAllOverWorld:(OCJGSModel_Package42 *)model
{
  [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];
  
  //后台定的传200
  OCJGlobalScreenVC *ctrl = [[OCJGlobalScreenVC alloc] initWithContentLGroup:@"200add" contentType:@"" keyword:@"200add"];

  [self.navigationController pushViewController:ctrl animated:YES];

}

#pragma mark - OCJOnTheNewTableViewCellCellDelegate
/*
  第三块周五上新-进商品详情
 */
-(void)ocj_golbaltheNewPressed:(OCJGSModel_Package43 *)model At:(OCJOnTheNewTableViewCell *)cell
{
    [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];
  
    NSString* itemCode = model.ocjStr_itemCode;
    if (itemCode.length==0) {
        [OCJProgressHUD ocj_showHudWithTitle:@"商品编码为空" andHideDelay:2];
        return;
    }
  
    if (self.ocjNavigationController.ocjCallback) {
      
        self.ocjNavigationController.ocjCallback(@{@"itemcode":itemCode,@"beforepage":@"Global",@"targetRNPage":@"GoodsDetailMain"});
      [self ocj_popToNavigationRootVC];
    }
 
}

#pragma mark - OCJOnTheNewTableViewCellCellDelegate
/**
  第四块补货专场点击事件-H5
 */
-(void)ocj_globalReplenishmentItemPressed:(OCJGSModel_Package14 *)model{
  
  [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];
  
  NSString* h5Url = model.ocjStr_destinationUrl;
  
  if (h5Url.length==0) {
    [OCJProgressHUD ocj_showHudWithTitle:@"H5网页地址为空" andHideDelay:2];
  }
  
  OCJ_RN_WebViewVC * webVC = [[OCJ_RN_WebViewVC alloc]init];
  webVC.ocjDic_router = @{@"url":h5Url};
  
  [self ocj_pushVC:webVC];
}

#pragma mark - OCJImageTitleTableViewCellDelegate
/**
  第五块-跳活动页H5
 */
- (void)ocj_golbalImageTitlePressed:(OCJGSModel_Package10 *)model At:(OCJImageTitleTableViewCell *)cell
{
  [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];
  
  NSString* h5Url = model.ocjStr_destinationUrl;
  
  if (h5Url.length==0) {
    [OCJProgressHUD ocj_showHudWithTitle:@"H5网页地址为空" andHideDelay:2];
  }
  
  OCJ_RN_WebViewVC * webVC = [[OCJ_RN_WebViewVC alloc]init];
  webVC.ocjDic_router = @{@"url":h5Url};
  
  [self ocj_pushVC:webVC];
}

/**
 第六块商品-进商品详情
 */
-(void)ocj_globalSixPackagePressed:(OCJGSModel_Package42 *)model{
  [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];
  
  NSString* itemCode = model.ocjStr_itemCode;
  if (itemCode.length==0) {
    [OCJProgressHUD ocj_showHudWithTitle:@"商品编码为空" andHideDelay:2];
    return;
  }
  
  if (self.ocjNavigationController.ocjCallback) {
    self.ocjNavigationController.ocjCallback(@{@"itemcode":itemCode,@"beforepage":@"Global",@"targetRNPage":@"GoodsDetailMain"});
    [self ocj_popToNavigationRootVC];
  }
  
}

/*
 全球购第六模块更多按钮点击事件-列表页
 */
- (void)ocj_golbalViewMorePressed:(OCJGSModel_Package10 *)model At:(OCJImageTitleTableViewCell *)cell
{
  
  NSString* h5Url = model.ocjStr_destinationUrl;
  
  if (h5Url.length==0) {
    [OCJProgressHUD ocj_showHudWithTitle:@"H5网页地址为空" andHideDelay:2];
  }
  
  OCJ_RN_WebViewVC * webVC = [[OCJ_RN_WebViewVC alloc]init];
  webVC.ocjDic_router = @{@"url":h5Url};
  
  [self ocj_pushVC:webVC];
  
}

#pragma mark - OCJOverseasRecommendTableViewCellDelegate
/*
 海外大牌推荐 跳转相关商品列表
 */
- (void)ocj_golbalOverSeasPressed:(OCJGSModel_Package14 *)model At:(OCJOverseasRecommendTableViewCell *)cell
{
  
  [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];

  OCJGlobalScreenVC *ctrl = [[OCJGlobalScreenVC alloc] initWithContentLGroup:model.ocjStr_lGroup contentType:model.ocjStr_contentType keyword:model.ocjStr_title];
  
  [self.navigationController pushViewController:ctrl animated:YES];

}

#pragma mark - OCJGlobalHotTableViewCellDelegate
/*
 全球热门 跳转相关商品列表
 */
- (void)ocj_golbalHotPressed:(OCJGSModel_Package14 *)model At:(OCJGlobalHotTableViewCell *)cell
{
  [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];

  OCJGlobalScreenVC *ctrl = [[OCJGlobalScreenVC alloc] initWithContentLGroup:model.ocjStr_lGroup contentType:model.ocjStr_contentType keyword:model.ocjStr_title];
  
  [self.navigationController pushViewController:ctrl animated:YES];

}

#pragma mark - OCJSuperValueTableViewCellDelegate
/**
 超值推荐商品点击-进详情
 */
- (void)ocj_golbalSuperValuePressed:(OCJGSModel_Package44 *)model At:(OCJSuperValueTableViewCell *)cell
{
  
  [self ocj_trackEventID:model.ocjStr_codeValue parmas:nil];
  
  NSString* itemCode = model.ocjStr_itemCode;
  if (itemCode.length==0) {
    [OCJProgressHUD ocj_showHudWithTitle:@"商品编码为空" andHideDelay:2];
    return;
  }
  
  if (self.ocjNavigationController.ocjCallback) {
    
    self.ocjNavigationController.ocjCallback(@{@"itemcode":itemCode,@"beforepage":@"Global",@"targetRNPage":@"GoodsDetailMain"});
    [self ocj_popToNavigationRootVC];
  }
}


@end
