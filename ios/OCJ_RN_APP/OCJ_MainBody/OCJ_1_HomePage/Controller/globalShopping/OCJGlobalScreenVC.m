//
//  OCJGlobalScreenVC.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobalScreenVC.h"
#import "OCJGlobalScreenGoodCollectionCell.h"
#import "OCJGlobalScreenHeadView.h"
#import "OCJGlobalScreenRetrievalView.h"
#import "OCJGlobalScreenTransverseCollectionCell.h"
#import "OCJ_GlobalShoppingHttpAPI.h"
#import "OCJBaseCollectionView.h"
#import "OCJGlobalScreenBrandAreaView.h"
#import "OCJGlobalScreenModel.h"

@interface OCJGlobalScreenVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,OCJGlobalScreenHeadViewDelegate,OCJGlobalScreenRetrievalViewDelegate,OCJGlobalScreenBrandAreaViewDelegate>
{
    /**商品是否列表模式*/
    BOOL    ocj_Transverse;
}

@property (nonatomic,strong)  NSString            * ocjStr_lGroup; ///< 列表数据类型1
@property (nonatomic,copy)    NSString            * ocjStr_contentType;///< 列表数据类型2
@property (nonatomic,copy)    NSString            * ocjStr_keyword; ///< 关键字，地区进来为国家名 ,品牌进来是品牌名

@property (nonatomic,assign) NSInteger            ocjint_Page; ///< 分页页码（首屏数据分页从第二页开始，筛选分页接口从第一页开始）

@property (nonatomic,strong) NSString           *ocjStr_componentGoodId; ///< 分页接口使用的id,从首页数据接口中解析

@property (nonatomic,strong) OCJBaseCollectionView    *ocjCollention; ///< 商品展示视图

@property (nonatomic,strong) OCJGlobalScreenHeadView    *ocjHeadView; ///< 筛选条件栏
@property (nonatomic) BOOL ocjBool_isFirstPageStatus; ///< 是否为首页数据（没动过筛选条件，上拉时page需从第二页开始）
@property (nonatomic,strong) NSArray     *ocjArray_brand; ///< 品牌数组
@property (nonatomic,strong) NSArray     *ocjArray_area; ///< 地区数组
@property (nonatomic,strong) OCJGSRModel_screenCondition* ocjModel_screenRequest; ///< 筛选条件记录model

@property (nonatomic,strong) NSMutableArray     *ocjArray_goodList; ///< 商品list

@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;         ///< 状态栏颜色

@end

@implementation OCJGlobalScreenVC


#pragma mark - 生命周期方法区域

- (instancetype)initWithContentLGroup:(NSString *)lGroup contentType:(NSString *)contentType keyword:(NSString *)keyword
{
    self = [super init];
    if (self) {
        self.ocjStr_lGroup = lGroup;
        self.ocjStr_contentType = contentType;
        self.ocjStr_keyword = keyword;
      
        if ([contentType isEqualToString:@"1"]) {//分类
        
          self.ocjModel_screenRequest.ocjStr_cate = lGroup;
          
        }else if ([contentType isEqualToString:@"3"]){//品牌
          
          OCJGSModel_Brand* model = [[OCJGSModel_Brand alloc]init];
          model.ocjStr_brandCode = lGroup;
          model.ocjStr_brandName = keyword;
          
          self.ocjModel_screenRequest.ocjArr_brandFiltrate = @[model];
        }else if ([contentType isEqualToString:@"4"]){//地区
          
          OCJGSModel_HotArea* model = [[OCJGSModel_HotArea alloc]init];
          model.ocjStr_areaCode = lGroup;
          model.ocjStr_areaName = keyword;
          
          self.ocjModel_screenRequest.ocjArr_areaFiltrate = @[model];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
  self.ocjStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [[UIApplication sharedApplication] setStatusBarStyle:self.ocjStatusBarStyle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self ocj_setSelf];
}

#pragma mark - 接口方法实现区域（包括setter、getter方法）

#pragma mark - 私有方法区域
-(void)ocj_setSelf{
  self.title = @"全球购";
  
  self.ocjBool_isFirstPageStatus = YES;
  self.ocjint_Page = 2;
  self.ocjStr_componentGoodId = @"";
  ocj_Transverse = NO;
  
  [self ocj_setUI];
  [self ocj_requestGlobalHome:nil];
  [self ocj_requestGlobalScreeningCondition:nil];
}
- (void)ocj_setUI{
    [self.view setBackgroundColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1/1.0]];
  
    [self ocj_setRightItemImageNames:@[@"Icon_listcolumn"] selectorNames:@[@"ocj_switchingDirection:"]];
    
    [self.view addSubview:self.ocjHeadView];
    [self.ocjHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.size.height.mas_equalTo(86);
    }];
    
    [self.view addSubview:self.ocjCollention];
    [self ocj_setCollention];
    [self.ocjCollention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjHeadView.mas_bottom);
//        make.bottom.mas_equalTo(self.view).offset(-49);
      make.bottom.mas_equalTo(self.view);
    }];
    
}

- (void)ocj_setCollention{
  
    [self.ocjCollention registerClass:[OCJGlobalScreenGoodCollectionCell class] forCellWithReuseIdentifier:@"OCJGlobalScreenGoodCollectionCell"];
    [self.ocjCollention registerClass:[OCJGlobalScreenTransverseCollectionCell class] forCellWithReuseIdentifier:@"OCJGlobalScreenTransverseCollectionCell"];
  
    //==============刷新块==============
    [self.ocjCollention ocj_prepareRefreshingType:OCJBaseCollectionRefreshTypeHeaderAndEnder];
  
    __weak OCJGlobalScreenVC* weakSelf = self;
    self.ocjCollention.ocjBlock_headerRefreshing = ^{
        //下拉刷新
        OCJLog(@"下拉刷新");
      [weakSelf.ocjArray_goodList removeAllObjects];
      
      if (weakSelf.ocjBool_isFirstPageStatus) {
          weakSelf.ocjint_Page = 2;
          [weakSelf ocj_requestGlobalHome:^{
              [weakSelf.ocjCollention ocj_endHeaderRefreshing];
          }];
      }else{
          weakSelf.ocjint_Page = 1;
          [weakSelf ocj_requestGlobalHomeMore:^{
              [weakSelf.ocjCollention ocj_endHeaderRefreshing];
          }];
      }
    };
    
    self.ocjCollention.ocjBlock_footerRefreshing = ^{
        //上拉加载更多
        OCJLog(@"上拉刷新");
        
        [weakSelf ocj_requestGlobalHomeMore:^{
          
            [weakSelf.ocjCollention ocj_endFooterRefreshingWithIsHaveMoreData:NO];
        }];
        
    };
}


- (void)ocj_switchingDirection:(id)btn
{
  
  if ([btn isKindOfClass:[OCJBaseButton class]]) {
    OCJBaseButton *btnn = (OCJBaseButton *)btn;
    btnn.selected = !btnn.selected;
  }
  
    NSLog(@"ocj_switchingDirection");
    if (ocj_Transverse) {
        ocj_Transverse = NO;
    }
    else
    {
        ocj_Transverse = YES;
    }
    [self.ocjCollention reloadData];
}


#pragma mark 条件筛选接口请求
- (void)ocj_requestGlobalScreeningCondition:(void(^)())completion
{
  
    [OCJ_GlobalShoppingHttpAPI ocjGlobalShopping_getScreeningConditionComplationHandler:^(OCJBaseResponceModel *responseModel) {
      
        OCJGSModel_ScreeningCondition* model = (OCJGSModel_ScreeningCondition*)responseModel;

        self.ocjArray_brand = model.ocjArr_Brands;
        self.ocjArray_area = model.ocjArr_hotAreas;
      
    }];
}

- (void)ocj_requestGlobalHome:(void(^)())completion
{
  
    [OCJ_GlobalShoppingHttpAPI ocjGlobalShopping_checkGoodList:self.ocjStr_lGroup contentType:self.ocjStr_contentType ComplationHandler:^(OCJBaseResponceModel *responseModel) {
        OCJGSModel_listDetail* model = (OCJGSModel_listDetail*)responseModel;
        self.ocjStr_componentGoodId = model.ocjStr_goodsID;
        self.ocjStr_trackPageVersion = model.ocjStr_pageVersionName;
        self.ocjStr_trackPageID = model.ocjStr_codeValue;
      
        self.ocjArray_goodList = [model.ocjArr_listItem mutableCopy];
        [self.ocjCollention reloadData];
        if (completion) {
            completion();
        }
    }];
  
}

- (void)ocj_requestGlobalHomeMore:(void(^)())completion
{
    if (self.ocjStr_componentGoodId.length==0) {
        if (completion) {
            completion();
        }
        return;
    }
  
    [OCJ_GlobalShoppingHttpAPI ocjGlobalShopping_checkGoodListNext:self.ocjStr_componentGoodId PageNum:[NSString stringWithFormat:@"%ld",(long)self.ocjint_Page] ScreeningCondition:[self.ocjModel_screenRequest ocj_getRequestDicFromSelf] ContentCode:self.ocjStr_lGroup complationHandler:^(OCJBaseResponceModel *responseModel)
    {
        self.ocjint_Page ++;
        OCJGSModel_moreListDetail* model = (OCJGSModel_moreListDetail*)responseModel;
        [self.ocjArray_goodList addObjectsFromArray:model.ocjArr_listItem];
      
        [self.ocjCollention scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:NO];
        [self.ocjCollention reloadData];
      
        if (completion) {
            completion();
        }
        
    }];
}

#pragma mark - getter
- (OCJBaseCollectionView *)ocjCollention
{
    if (!_ocjCollention) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _ocjCollention = [[OCJBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _ocjCollention.delegate = self;
        _ocjCollention.dataSource = self;
        [_ocjCollention setBackgroundColor:[UIColor clearColor]];
    }
    return _ocjCollention;
}

- (OCJGlobalScreenHeadView *)ocjHeadView
{
    if (!_ocjHeadView) {
        _ocjHeadView = [[OCJGlobalScreenHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
        [_ocjHeadView setBackgroundColor:[UIColor clearColor]];
        _ocjHeadView.ocjModel_condition = self.ocjModel_screenRequest;
        _ocjHeadView.delegate = self;
    }
    return _ocjHeadView;
}

- (NSMutableArray *)ocjArray_goodList
{
    if (!_ocjArray_goodList) {
        _ocjArray_goodList = [[NSMutableArray alloc] init];
    }
    return _ocjArray_goodList;
}

- (NSArray *)ocjArray_brand
{
    if (!_ocjArray_brand) {
        _ocjArray_brand = [[NSArray alloc] init];
    }
    return _ocjArray_brand;
}

- (NSArray *)ocjArray_area
{
    if (!_ocjArray_area) {
        _ocjArray_area = [[NSArray alloc] init];
    }
    return _ocjArray_area;
}

-(OCJGSRModel_screenCondition *)ocjModel_screenRequest{
  
  if (!_ocjModel_screenRequest) {
    _ocjModel_screenRequest = [[OCJGSRModel_screenCondition alloc]init];
  }
  
  return _ocjModel_screenRequest;
}

#pragma mark - 协议方法实现区域
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.ocjArray_goodList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
     if (ocj_Transverse)
     {
         OCJGlobalScreenTransverseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OCJGlobalScreenTransverseCollectionCell" forIndexPath:indexPath];
         OCJGSModel_Package44 * model = [self.ocjArray_goodList objectAtIndex:indexPath.row];
         [cell ocj_setViewDataWith:model];
         return cell;
     }
    else
    {
        OCJGlobalScreenGoodCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OCJGlobalScreenGoodCollectionCell" forIndexPath:indexPath];
        OCJGSModel_Package44 * model = [self.ocjArray_goodList objectAtIndex:indexPath.row];
        [cell ocj_setViewDataWith:model];
        
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OCJGSModel_Package44* item = self.ocjArray_goodList[indexPath.row];
  
    [self ocj_trackEventID:item.ocjStr_codeValue parmas:nil];
    NSString* itemCode = item.ocjStr_itemCode;
    if (![itemCode wshh_stringIsValid] || itemCode.length==0) {
        [OCJProgressHUD ocj_showHudWithTitle:@"商品编码为空" andHideDelay:2];
        return;
    }
  
    if (self.ocjNavigationController.ocjCallback) {
    
        self.ocjNavigationController.ocjCallback(@{@"itemcode":itemCode,@"beforepage":@"Global",@"targetRNPage":@"GoodsDetailMain"});
        [self ocj_popToNavigationRootVC];
    }
  
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (ocj_Transverse) {
        return CGSizeMake(SCREEN_WIDTH, 139.5);
    }
    else
    {
        return CGSizeMake(SCREEN_WIDTH/2 -0.5, (SCREEN_WIDTH/2)*(277.5/187.5));
    }
    
}

#pragma mark - OCJGlobalScreenHeadViewDelegate
- (void)ocj_golbalHeadButtonPressed:(NSInteger)tag
{
    switch (tag) {
        case 10001:
        {//全部
            [self.ocjModel_screenRequest ocj_resetScreenCondition];

        }break;
        case 10002:
        {//销量
            self.ocjModel_screenRequest.ocjStr_salesVolumeSort = ([self.ocjModel_screenRequest.ocjStr_salesVolumeSort isEqualToString:@""])?@"1":@"";
            self.ocjint_Page = 1;
            [self.ocjArray_goodList removeAllObjects];
            [self ocj_requestGlobalHomeMore:nil];
          
        }break;
        case 10003:
        {//价格
        
          NSString* priceSort =  self.ocjModel_screenRequest.ocjStr_priceSort;
          if ([priceSort isEqualToString:@"1"]) {
            priceSort = @"2";
            
          }else if ([priceSort isEqualToString:@"2"]){
            priceSort = @"";
          }else{
            priceSort = @"1";
          }
          self.ocjModel_screenRequest.ocjStr_priceSort = priceSort;
          
        }break;
        case 20001:{
            self.ocjModel_screenRequest.ocjStr_superValueFiltrate = [self.ocjModel_screenRequest.ocjStr_superValueFiltrate isEqualToString:@""]?@"1":@"";
          
        }break;
        case 20002:
        {//热门地区
          
            OCJGlobalScreenBrandAreaView *view = [[OCJGlobalScreenBrandAreaView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [view ocj_initType:OCJGlobalScreenBrandAreaViewTypeHotArea originalArray:self.ocjArray_area SelectedArrar:self.ocjModel_screenRequest.ocjArr_areaFiltrate];
            view.delegate = self;
            UIWindow* window = [AppDelegate ocj_getShareAppDelegate].window;
            [window addSubview:view];
            [view ocj_showChooseView];
            return;
        
        }break;
        case 20003:{
            //品牌
          
            OCJGlobalScreenBrandAreaView *view = [[OCJGlobalScreenBrandAreaView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [view ocj_initType:OCJGlobalScreenBrandAreaViewTypeBrand originalArray:self.ocjArray_brand SelectedArrar:self.ocjModel_screenRequest.ocjArr_brandFiltrate];
            view.delegate = self;
            UIWindow* window = [AppDelegate ocj_getShareAppDelegate].window;
            [window addSubview:view];
            [view ocj_showChooseView];
          
            return;
        } break;
        default:
            break;
    }
  
    self.ocjBool_isFirstPageStatus = NO;
    self.ocjint_Page = 1;
    self.ocjHeadView.ocjModel_condition = self.ocjModel_screenRequest;
    [self.ocjArray_goodList removeAllObjects];
    [self ocj_requestGlobalHomeMore:nil];
  
}

#pragma mark - OCJGlobalScreenBrandAreaViewDelegate
- (void)ocj_golbalScreenBrandAreaSelectedArray:(NSArray *)selectedArray type:(OCJGlobalScreenBrandAreaViewType)type{
    if (type == OCJGlobalScreenBrandAreaViewTypeBrand) {
      
        self.ocjModel_screenRequest.ocjArr_brandFiltrate = selectedArray;
      
    }else if (type == OCJGlobalScreenBrandAreaViewTypeHotArea){
      
        self.ocjModel_screenRequest.ocjArr_areaFiltrate = selectedArray;
    }
  
    self.ocjHeadView.ocjModel_condition = self.ocjModel_screenRequest;
  
    self.ocjBool_isFirstPageStatus = NO;
    self.ocjint_Page = 1;
    [self.ocjArray_goodList removeAllObjects];
    [self ocj_requestGlobalHomeMore:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  self.ocjHeadView.userInteractionEnabled = NO;
}
// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  self.ocjHeadView.userInteractionEnabled = YES;
}
// 滚动停止时，触发该函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  self.ocjHeadView.userInteractionEnabled = YES;
}

@end
