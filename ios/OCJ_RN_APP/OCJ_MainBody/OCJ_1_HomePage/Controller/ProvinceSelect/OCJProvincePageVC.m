//
//  OCJProvincePageVC.m
//  OCJ
//
//  Created by 董克楠 on 8/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJProvincePageVC.h"
#import "OCJRegisterCenterVC.h"
#import "OCJAreaProvinceModel.h"
#import "OCJHttp_authAPI.h"

@interface OCJProvincePageVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic ,strong)OCJBaseTableView * ocjTable_provTable;//展示彩票和礼包列表
@property(nonatomic ,strong)NSMutableDictionary * ocjDict_dataDict;//按字母保存省份字典
@property(nonatomic ,strong)NSMutableArray * ocjArray_hotRegionArr;//保存热门城市数组

@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;             ///<状态栏颜色
@end

#define hotRegionViewH  120     //热门城市view的高

@implementation OCJProvincePageVC
#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  self.ocjStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  
  [[UIApplication sharedApplication] setStatusBarStyle:self.ocjStatusBarStyle];
}


#pragma mark - 私有方法区域
- (void)ocj_back{
  [self ocj_trackEventID:@"AP1706C066D003001C003001" parmas:nil];
    [super ocj_back];
    
    if (self.ocjBlock_handler) {
        self.ocjBlock_handler(nil);
    }
}

-(void)ocj_setSelf{
  
  self.title = @"地区设置";
  self.ocjStr_trackPageID = @"AP1706C066";
  [self ocj_creatUI];
  
  [self ocj_setProvinceData];
}

-(void)ocj_setProvinceData{
  //遍历分组 先清空数组
  [self.ocjDict_dataDict removeAllObjects];
  
  //首先遍历省份
  for (OCJSinglProvinceModel *model in self.ocjModel_provinceModel.ocjArr_provinceList) {
    //在遍历数组
    BOOL isYes =NO;
    NSArray * keyArr = [self.ocjDict_dataDict allKeys];
    for (int i =0; i < keyArr.count; i ++) {
      
      if ([keyArr[i] isEqualToString:model.ocjStr_FirstLetter]) {
        isYes = YES;
        //将当前省份添加到此数组中
        NSMutableArray * provniceArr = [self.ocjDict_dataDict objectForKey:keyArr[i]];
        [provniceArr addObject:model];
        [self.ocjDict_dataDict setValue:provniceArr forKey:keyArr[i]];
        
        break;
      }
    }
    if (isYes == NO) {
      //创建新数组 加入当前新的省份
      NSMutableArray * provniceArr = [NSMutableArray arrayWithObject:model];
      [self.ocjDict_dataDict setValue:provniceArr forKey:model.ocjStr_FirstLetter];
      
    }else{
      isYes = NO;
    }
    //添加热门城市
    if ([model.ocjStr_name isEqualToString:@"北京"] || [model.ocjStr_name isEqualToString:@"上海"] || [model.ocjStr_name isEqualToString:@"江苏"] || [model.ocjStr_name isEqualToString:@"浙江"] ||[model.ocjStr_name isEqualToString:@"湖北"] || [model.ocjStr_name isEqualToString:@"四川"] || [model.ocjStr_name isEqualToString:@"黑龙江"]) {
      [self.ocjArray_hotRegionArr addObject:model];
    }
  }
  [self.ocjTable_provTable reloadData];
  [self reloadDataHotRegion];
  
}

-(void)ocj_upData
{
    [OCJHttp_authAPI ocjAuth_checkProvniceNameWithCompletionHandler:^(OCJBaseResponceModel *responseModel) {
      
        self.ocjModel_provinceModel = (OCJAreaProvinceListModel *)responseModel;
      
        //遍历分组 先清空数组
        [self.ocjDict_dataDict removeAllObjects];
        
        //首先遍历省份
        for (OCJSinglProvinceModel *model in self.ocjModel_provinceModel.ocjArr_provinceList) {
            //在遍历数组
            BOOL isYes =NO;
            NSArray * keyArr = [self.ocjDict_dataDict allKeys];
            for (int i =0; i < keyArr.count; i ++) {

                if ([keyArr[i] isEqualToString:model.ocjStr_FirstLetter]) {
                    isYes = YES;
                    //将当前省份添加到此数组中
                    NSMutableArray * provniceArr = [self.ocjDict_dataDict objectForKey:keyArr[i]];
                    [provniceArr addObject:model];
                    [self.ocjDict_dataDict setValue:provniceArr forKey:keyArr[i]];
                    
                    break;
                }
            }
            if (isYes == NO) {
                //创建新数组 加入当前新的省份
                NSMutableArray * provniceArr = [NSMutableArray arrayWithObject:model];
                [self.ocjDict_dataDict setValue:provniceArr forKey:model.ocjStr_FirstLetter];
                
            }else{
                isYes = NO;
            }
            //添加热门城市
            if ([model.ocjStr_name isEqualToString:@"北京"] || [model.ocjStr_name isEqualToString:@"上海"] || [model.ocjStr_name isEqualToString:@"江苏"] || [model.ocjStr_name isEqualToString:@"浙江"] ||[model.ocjStr_name isEqualToString:@"湖北"] || [model.ocjStr_name isEqualToString:@"四川"] || [model.ocjStr_name isEqualToString:@"黑龙江"]) {
                [self.ocjArray_hotRegionArr addObject:model];
            }
        }
        [self.ocjTable_provTable reloadData];
        [self reloadDataHotRegion];
    }];
}
-(void)ocj_creatUI{
    self.ocjTable_provTable = [[OCJBaseTableView alloc] init];
    self.ocjTable_provTable.dataSource =self;
    self.ocjTable_provTable.delegate =self;
    self.ocjTable_provTable.sectionIndexColor= [UIColor colorWSHHFromHexString:@"#666666"];
    [self.view addSubview:self.ocjTable_provTable];
    [self.ocjTable_provTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
  
}

-(void)reloadDataHotRegion
{
    UIView * ocjView_hotRegionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, hotRegionViewH)];
    self.ocjTable_provTable.tableHeaderView =ocjView_hotRegionView;
  
    UIView * ocjView_titleView =[self rewriteTableHeaderViewTitle:@"热门地区"];

    for (int i =0; i < self.ocjArray_hotRegionArr.count; i ++) {
        int row = i/2;
        int low = i%2;
        UIButton * ocjBtn_cityBtn = [[UIButton alloc] init];
        [ocjBtn_cityBtn setTitle:[self.ocjArray_hotRegionArr[i] ocjStr_name] forState:UIControlStateNormal];
        [ocjBtn_cityBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#666666"] forState:UIControlStateNormal];
        [ocjBtn_cityBtn addTarget:self action:@selector(selectHotRegionBtn:) forControlEvents:UIControlEventTouchUpInside];
        ocjBtn_cityBtn.tag = i;
        [self.ocjTable_provTable.tableHeaderView addSubview:ocjBtn_cityBtn];
        [ocjBtn_cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(row * SCREEN_WIDTH/4);
            make.width.mas_equalTo(SCREEN_WIDTH/5);
            make.top.mas_equalTo(40 + low *35);
            make.height.mas_equalTo(35);
        }];
    }
}

#pragma table delegate and datasouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.ocjDict_dataDict allKeys] count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * keyArr = [[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    return [self.ocjDict_dataDict[keyArr[section]] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray * keyArr = [[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    return keyArr[section];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString * textStr =[[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)][section];
    UIView * ocjView_titleView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    ocjView_titleView.backgroundColor =[UIColor colorWSHHFromHexString:@"#EDEDED"];
    
    UILabel * ocjLabel_headLabel =[[UILabel alloc] init];
    ocjLabel_headLabel.textColor = [UIColor colorWSHHFromHexString:@"#666666"];
    ocjLabel_headLabel.text =textStr;
    ocjLabel_headLabel.font = [UIFont systemFontOfSize:16];
    ocjLabel_headLabel.backgroundColor =[UIColor colorWSHHFromHexString:@"#EDEDED"];
    [ocjView_titleView addSubview:ocjLabel_headLabel];
    [ocjLabel_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];

    return ocjView_titleView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identi = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identi];
    }
    NSArray * keyArr = [[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)];

    cell.textLabel.text = [self.ocjDict_dataDict[keyArr[indexPath.section]][indexPath.row] ocjStr_name];
    cell.textLabel.textColor = [UIColor colorWSHHFromHexString:@"#666666"];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:[[[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy]];
    [arr insertObject:@"#" atIndex:0];
    return arr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray * keyArr = [[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    OCJSinglProvinceModel* proviceModel = self.ocjDict_dataDict[keyArr[indexPath.section]][indexPath.row];
    if ([self.OCJProvDelegate respondsToSelector:@selector(ocj_popWithProvniceInfo:)]) {
        [self.OCJProvDelegate ocj_popWithProvniceInfo:proviceModel];
    }
    
    if (self.ocjBlock_handler) {
        
        self.ocjBlock_handler(proviceModel);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 选择热门城市
-(void)selectHotRegionBtn:(UIButton *)btn
{
    OCJSinglProvinceModel* proviceModel = self.ocjArray_hotRegionArr[btn.tag];
    if ([self.OCJProvDelegate respondsToSelector:@selector(ocj_popWithProvniceInfo:)]) {
        [self.OCJProvDelegate ocj_popWithProvniceInfo:proviceModel];
    }
    
    if (self.ocjBlock_handler) {
        
        self.ocjBlock_handler(proviceModel);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 重写标题栏
-(UIView *)rewriteTableHeaderViewTitle:(NSString *)title{
    UIView * ocjView_titleView =[[UIView alloc] init];
    [self.ocjTable_provTable.tableHeaderView addSubview:ocjView_titleView];
    ocjView_titleView.backgroundColor =[UIColor colorWSHHFromHexString:@"#EDEDED"];
    [ocjView_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    UILabel * ocjLabel_headLabel =[[UILabel alloc] init];
    ocjLabel_headLabel.textColor = [UIColor colorWSHHFromHexString:@"#666666"];
    ocjLabel_headLabel.text =title;
    ocjLabel_headLabel.font = [UIFont systemFontOfSize:16];
    ocjLabel_headLabel.backgroundColor =[UIColor colorWSHHFromHexString:@"#EDEDED"];
    [ocjView_titleView addSubview:ocjLabel_headLabel];
    [ocjLabel_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    return ocjView_titleView;
}
#pragma mark 懒加载
-(NSMutableDictionary *)ocjDict_dataDict{
    if (_ocjDict_dataDict == nil) {
        _ocjDict_dataDict = [[NSMutableDictionary alloc] init];
    }
    return _ocjDict_dataDict;
}
-(NSMutableArray *)ocjArray_hotRegionArr{
    if (_ocjArray_hotRegionArr == nil) {
        _ocjArray_hotRegionArr = [NSMutableArray array];
    }
    return _ocjArray_hotRegionArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
