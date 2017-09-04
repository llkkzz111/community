//
//  OCJGlobalScreenBrandAreaView.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobalScreenBrandAreaView.h"
#import "OCJScreenAlphabeticSorting.h"
#import "OCJScreeningTableViewCell.h"

@interface OCJGlobalScreenBrandAreaView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView         *ocjViwe_bg;
@property (nonatomic,strong) UIView         *ocjView_tableViewBg;
@property (nonatomic,strong) UIView         *ocjView_head;
@property (nonatomic,strong) UIView         *ocjVIew_tableHead;
@property (nonatomic,strong) UITableView    *ocjTableView_main;

@property (nonatomic,strong) UILabel        *ocjLab_title;
@property (nonatomic,strong) UIButton       *ocjBtn_return;

@property (nonatomic,strong) UIButton       *ocjBtn_hotArea;
@property (nonatomic,strong) UIButton       *ocjBtn_brand;
@property (nonatomic,strong) UIView         *ocjVIew_tableHeadgap;

@property (nonatomic,strong) UIButton       *ocjBtn_sure;

@property (nonatomic,strong) NSArray *ocjArray_main;

@property (nonatomic,strong) NSMutableArray *ocjArray_indexes;

@property (nonatomic,strong) NSMutableDictionary *ocjDic_indexes;

@property (nonatomic,strong) UIView         *ocjVIew_hotAreaChoose;
@property (nonatomic,strong) UIView         *ocjVIew_brandChoose;

@property (nonatomic,strong) NSMutableArray *ocjArray_Selected;

@property (nonatomic,strong) NSString       *strOcj_title;

@property (nonatomic) OCJGlobalScreenBrandAreaViewType ocjEnum_type;

@end


@implementation OCJGlobalScreenBrandAreaView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self ocj_addViews];
        [self ocj_reloadChooseGap];
    }
    return self;
}

#pragma mark - 私有方法区域
- (void)ocj_addViews
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.ocjViwe_bg];
    [self.ocjViwe_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    
    [self addSubview:self.ocjView_tableViewBg];
    [self.ocjView_tableViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(SCREEN_WIDTH);
        make.top.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*254/375, SCREEN_HEIGHT));
    }];
    
    [self.ocjView_tableViewBg addSubview:self.ocjView_head];
    [self.ocjView_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_tableViewBg);
        make.top.mas_equalTo(self.ocjView_tableViewBg);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*254/375, 60));
    }];
    
    [self.ocjView_head addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.ocjView_head.center);
    }];
    
    [self.ocjView_head addSubview:self.ocjBtn_return];
    [self.ocjBtn_return mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_head);
        make.centerY.mas_equalTo(self.ocjView_head.mas_centerY);
    }];
    
    [self.ocjView_tableViewBg addSubview:self.ocjVIew_tableHead];
    [self.ocjVIew_tableHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_tableViewBg);
        make.top.mas_equalTo(self.ocjView_head.mas_bottom).offset(1);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*254/375, 38));
    }];
    
    [self.ocjVIew_tableHead addSubview:self.ocjBtn_hotArea];
    [self.ocjBtn_hotArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjVIew_tableHead.mas_left);
        make.top.mas_equalTo(self.ocjVIew_tableHead);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*254/375/2, 38));
    }];
    
    [self.ocjVIew_tableHead addSubview:self.ocjBtn_brand];
    [self.ocjBtn_brand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_hotArea.mas_right);
        make.top.mas_equalTo(self.ocjVIew_tableHead);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*254/375/2, 38));
    }];
    
    [self.ocjBtn_hotArea addSubview:self.ocjVIew_hotAreaChoose];
    [self.ocjVIew_hotAreaChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjBtn_hotArea.mas_centerX);
        make.bottom.mas_equalTo(self.ocjBtn_hotArea);
        make.size.mas_equalTo(CGSizeMake(52, 2));
    }];
    
    [self.ocjBtn_brand addSubview:self.ocjVIew_brandChoose];
    [self.ocjVIew_brandChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjBtn_brand.mas_centerX);
        make.bottom.mas_equalTo(self.ocjBtn_brand);
        make.size.mas_equalTo(CGSizeMake(52, 2));
    }];
    
    [self.ocjVIew_tableHead addSubview:self.ocjVIew_tableHeadgap];
    [self.ocjVIew_tableHeadgap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.ocjVIew_tableHead.center);
        make.size.mas_equalTo(CGSizeMake(1, 16));
    }];
    
    [self.ocjView_tableViewBg addSubview:self.ocjBtn_sure];
    [self.ocjBtn_sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_tableViewBg);
        make.right.mas_equalTo(self.ocjView_tableViewBg);
        make.bottom.mas_equalTo(self.ocjView_tableViewBg);
        make.size.height.mas_equalTo(44);
    }];

    
    [self.ocjView_tableViewBg addSubview:self.ocjTableView_main];
    [self.ocjTableView_main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_tableViewBg);
        make.right.mas_equalTo(self.ocjView_tableViewBg);
        make.top.mas_equalTo(self.ocjVIew_tableHead.mas_bottom).offset(0.5);
        make.bottom.mas_equalTo(self.ocjBtn_sure.mas_top);
    }];
    
    [self layoutIfNeeded];
    
}

- (void)ocj_reloadChooseGap
{
    if (self.intTab_type == 0) {
        [self.ocjVIew_hotAreaChoose setHidden:NO];
        [self.ocjVIew_brandChoose setHidden:YES];
    }
    else
    {
        [self.ocjVIew_hotAreaChoose setHidden:YES];
        [self.ocjVIew_brandChoose setHidden:NO];
    }
}

- (void)ocj_initType:(OCJGlobalScreenBrandAreaViewType)type originalArray:(NSArray *)originalArray SelectedArrar:(NSArray *)selectedArray;
{
  
    self.ocjArray_main = originalArray;
    NSDictionary *dicShort = @{};
  
    self.ocjEnum_type = type;
    switch (type) {
      case OCJGlobalScreenBrandAreaViewTypeBrand:
        [self.ocjBtn_hotArea setTitle:@"推荐品牌" forState:UIControlStateNormal];
        dicShort = [OCJScreenAlphabeticSorting ocj_screnAlphabeticSortingWithServicesArray:self.ocjArray_main type:OCJScreenSortTypeBrand];
        break;
      case OCJGlobalScreenBrandAreaViewTypeHotArea:
        [self.ocjBtn_hotArea setTitle:@"推荐地区" forState:UIControlStateNormal];
        dicShort = [OCJScreenAlphabeticSorting ocj_screnAlphabeticSortingWithServicesArray:self.ocjArray_main type:OCJScreenSortTypeHotArea];
        break;
    }
    
    [self.ocjDic_indexes addEntriesFromDictionary:dicShort];
    NSArray *keys = [dicShort allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    [self.ocjArray_indexes addObjectsFromArray:sortedArray];
  
    self.ocjArray_Selected = [selectedArray mutableCopy];
    [self.ocjTableView_main reloadData];
}

- (void)ocj_showChooseView {
    
    [self.ocjView_tableViewBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(SCREEN_WIDTH - SCREEN_WIDTH*254/375);//这里是设置动画的结尾位置
    }];
    [UIView animateWithDuration:0.5f animations:^{
        [self layoutIfNeeded];//这里是关键
        self.ocjViwe_bg.alpha = 0.4;//透明度的变化依然和老方法一样
    } completion:^(BOOL finished) {
        //动画完成后的代码
    }];
}

- (void)ocj_hiddenChooseView
{
    [self.ocjView_tableViewBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(SCREEN_WIDTH);//这里是设置动画的结尾位置
    }];
    [UIView animateWithDuration:0.5f animations:^{
        [self layoutIfNeeded];//这里是关键
        self.ocjViwe_bg.alpha = 0;//透明度的变化依然和老方法一样
    } completion:^(BOOL finished) {
        //动画完成后的代码
        [self removeFromSuperview];
    }];
}

- (void)ocj_removeSelf
{
    [self ocj_hiddenChooseView];
}

- (void)ocj_typeButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
  
  if (sender == _ocjBtn_hotArea) {
    _ocjBtn_hotArea.selected = YES;
    _ocjBtn_brand.selected = NO;
  }else{
    _ocjBtn_hotArea.selected = NO;
    _ocjBtn_brand.selected = YES;
  }
  
    if (button.tag == 1001) {//推荐地区
        self.intTab_type = 0;
    }
    else if (button.tag == 1002){//字母排序
        self.intTab_type = 1;
    }
    [self ocj_reloadChooseGap];
    [self.ocjTableView_main reloadData];
}

- (void)ocj_sureButtonPressed
{
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalScreenBrandAreaSelectedArray:type:)]) {
        [self.delegate ocj_golbalScreenBrandAreaSelectedArray:[self.ocjArray_Selected copy] type:self.ocjEnum_type];
    }
  
  
    [self ocj_removeSelf];
}

-(NSObject*)ocj_checkModelIsSelected:(NSObject*)model{
  
  if (self.ocjEnum_type == OCJGlobalScreenBrandAreaViewTypeBrand && [model isKindOfClass:[OCJGSModel_Brand class]]) {
      OCJGSModel_Brand* brandModel = (OCJGSModel_Brand*)model;
      for (OCJGSModel_Brand* brand in self.ocjArray_Selected) {
        if ([brandModel.ocjStr_brandCode isEqualToString:brand.ocjStr_brandCode]) {
          return brand;
        }
      }
  }else if (self.ocjEnum_type == OCJGlobalScreenBrandAreaViewTypeHotArea && [model isKindOfClass:[OCJGSModel_HotArea class]]){
      OCJGSModel_HotArea* areaModel = (OCJGSModel_HotArea*)model;
      for (OCJGSModel_HotArea* area in self.ocjArray_Selected) {
        if ([areaModel.ocjStr_areaCode isEqualToString:area.ocjStr_areaCode]) {
          return area;
        }
      }
  }
  
  return nil;
}

#pragma mark - getter
- (UIView *)ocjViwe_bg
{
    if (!_ocjViwe_bg) {
        _ocjViwe_bg = [[UIView alloc] init];
        [_ocjViwe_bg setBackgroundColor:[UIColor lightGrayColor]];
        [_ocjViwe_bg setAlpha:0.3];
        
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [control setBackgroundColor:[UIColor clearColor]];
        [control addTarget:self action:@selector(ocj_removeSelf) forControlEvents:UIControlEventTouchUpInside];
        [_ocjViwe_bg addSubview:control];
    }
    return _ocjViwe_bg;
}

- (UIView *)ocjView_tableViewBg
{
    if (!_ocjView_tableViewBg) {
        _ocjView_tableViewBg = [[UIView alloc] init];
        [_ocjView_tableViewBg setBackgroundColor: [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1/1.0]];
    }
    return _ocjView_tableViewBg;
}

- (UIView *)ocjView_head
{
    if (!_ocjView_head) {
        _ocjView_head = [[UIView alloc] init];
        [_ocjView_head setBackgroundColor:[UIColor whiteColor]];
    }
    return _ocjView_head;
}

- (UIView *)ocjVIew_tableHead
{
    if (!_ocjVIew_tableHead) {
        _ocjVIew_tableHead = [[UIView alloc] init];
        [_ocjVIew_tableHead setBackgroundColor:[UIColor whiteColor]];
    }
    return _ocjVIew_tableHead;
}

- (UITableView *)ocjTableView_main{
    if (!_ocjTableView_main) {
        _ocjTableView_main = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _ocjTableView_main.backgroundColor = [UIColor clearColor];
        _ocjTableView_main.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ocjTableView_main.showsVerticalScrollIndicator = NO;
        _ocjTableView_main.dataSource = self;
        _ocjTableView_main.delegate   = self;
//        _ocjTableView_main.ocjImage_NoData = [UIImage imageNamed:@"Icon_couponleft_"];
        //        _ocjTableView_main.sectionFooterHeight = 0.0;
        //        _ocjTableView_main.sectionHeaderHeight = 0.0;
        _ocjTableView_main.sectionIndexColor =  [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    }
    return _ocjTableView_main;
}

- (UILabel *)ocjLab_title
{
    if (!_ocjLab_title) {
        _ocjLab_title = [[UILabel alloc] init];
        [_ocjLab_title setBackgroundColor:[UIColor clearColor]];
        _ocjLab_title.text = @"热门地区";
        _ocjLab_title.font = [UIFont systemFontOfSize:16];
        _ocjLab_title.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _ocjLab_title;
}

- (UIButton *)ocjBtn_return
{
    if (!_ocjBtn_return) {
        _ocjBtn_return = [[UIButton alloc] init];
        [_ocjBtn_return setTitle:@"<" forState:UIControlStateNormal];
        [_ocjBtn_return setTitleColor: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        _ocjBtn_return.backgroundColor = [UIColor clearColor];
        [_ocjBtn_return addTarget:self action:@selector(ocj_removeSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_return;
}

- (UIButton *)ocjBtn_hotArea
{
    if (!_ocjBtn_hotArea) {
        _ocjBtn_hotArea = [[UIButton alloc] init];
        _ocjBtn_hotArea.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ocjBtn_hotArea setTitle:@"推荐地区" forState:UIControlStateNormal];
        [_ocjBtn_hotArea setTitleColor:  [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
      [_ocjBtn_hotArea setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateSelected];
      
        _ocjBtn_hotArea.backgroundColor = [UIColor whiteColor];
      _ocjBtn_hotArea.selected = YES;
        _ocjBtn_hotArea.tag = 1001;
        [_ocjBtn_hotArea addTarget:self action:@selector(ocj_typeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_hotArea;
}

- (UIView *)ocjVIew_hotAreaChoose
{
    if (!_ocjVIew_hotAreaChoose) {
        _ocjVIew_hotAreaChoose = [[UIView alloc] init];
        [_ocjVIew_hotAreaChoose setBackgroundColor: [UIColor colorWithRed:229/255.0 green:41/255.0 blue:13/255.0 alpha:1/1.0]];
    }
    return _ocjVIew_hotAreaChoose;
}

- (UIView *)ocjVIew_brandChoose
{
    if (!_ocjVIew_brandChoose) {
        _ocjVIew_brandChoose = [[UIView alloc] init];
        [_ocjVIew_brandChoose setBackgroundColor: [UIColor colorWithRed:229/255.0 green:41/255.0 blue:13/255.0 alpha:1/1.0]];
    }
    return _ocjVIew_brandChoose;
}

- (UIView *)ocjVIew_tableHeadgap
{
    if (!_ocjVIew_tableHeadgap) {
        _ocjVIew_tableHeadgap = [[UIView alloc] init];
        [_ocjVIew_tableHeadgap setBackgroundColor:[UIColor colorWSHHFromHexString:@"#DCDDE3"]];
    }
    return _ocjVIew_tableHeadgap;
}

- (UIButton *)ocjBtn_brand
{
    if (!_ocjBtn_brand) {
        _ocjBtn_brand = [[UIButton alloc] init];
        _ocjBtn_brand.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ocjBtn_brand setTitle:@"字母排序" forState:UIControlStateNormal];
        [_ocjBtn_brand setTitleColor:  [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];

        [_ocjBtn_brand setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateSelected];
      
        _ocjBtn_brand.backgroundColor = [UIColor clearColor];
        _ocjBtn_brand.tag = 1002;
        [_ocjBtn_brand addTarget:self action:@selector(ocj_typeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_brand;
}


- (UIButton *)ocjBtn_sure
{
    if (!_ocjBtn_sure) {
        _ocjBtn_sure = [[UIButton alloc] init];
        _ocjBtn_sure.titleLabel.font = [UIFont systemFontOfSize:15];
        [_ocjBtn_sure setTitle:@"确定" forState:UIControlStateNormal];
        [_ocjBtn_sure setTitleColor:  [UIColor whiteColor] forState:UIControlStateNormal];
        _ocjBtn_sure.backgroundColor = [UIColor colorWithRed:299/255.0 green:31/255.0 blue:13/255.0 alpha:1/1.0];
        [_ocjBtn_sure addTarget:self action:@selector(ocj_sureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_sure;
}

- (NSArray *)ocjArray_main
{
    if (!_ocjArray_main) {
        _ocjArray_main = [[NSArray alloc] init];
    }
    return _ocjArray_main;
}

- (NSMutableArray *)ocjArray_indexes
{
    if (!_ocjArray_indexes) {
        _ocjArray_indexes = [[NSMutableArray alloc] init];
    }
    return _ocjArray_indexes;
}

- (NSMutableDictionary *)ocjDic_indexes
{
    if (!_ocjDic_indexes) {
        _ocjDic_indexes = [[NSMutableDictionary alloc] init];
    }
    return _ocjDic_indexes;
}

- (NSMutableArray *)ocjArray_Selected
{
    if (!_ocjArray_Selected) {
        _ocjArray_Selected = [[NSMutableArray alloc] init];
    }
    return _ocjArray_Selected;
}

#pragma mark - 协议方法实现区域

//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.intTab_type == 0) {
        return @[];
    }
    else
    {
        return self.ocjArray_indexes;
    }
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSInteger count = 0;
    
    for(NSString *character in self.ocjArray_indexes)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
}


//返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    if (self.intTab_type == 0) {
        return 1;
    }
    else
    {
        return [self.ocjArray_indexes count];
    }
    
}

//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.intTab_type == 0) {
        return @"";
    }
    else
    {
        return [self.ocjArray_indexes objectAtIndex:section];
    }
}

//返回每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.intTab_type == 0) {
        return self.ocjArray_main.count;
    }
    else
    {
        NSString *string = [self.ocjArray_indexes objectAtIndex:section];
        NSArray *array = [self.ocjDic_indexes objectForKey:string];
        return [array count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

//cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifierzeo = @"OCJScreeningTableViewCell";
    OCJScreeningTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierzeo];
    if (!cell) {
        cell = [[OCJScreeningTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierzeo];
    }
  
    if (self.intTab_type == 0) {
      
        NSObject* element = self.ocjArray_main[indexPath.row];
        if (self.ocjEnum_type == OCJGlobalScreenBrandAreaViewTypeBrand) {
            OCJGSModel_Brand* model = (OCJGSModel_Brand*)element;
            [cell ocj_setShowtitle:model.ocjStr_brandName];
        }else if (self.ocjEnum_type == OCJGlobalScreenBrandAreaViewTypeHotArea){
            OCJGSModel_HotArea* model = (OCJGSModel_HotArea*)element;
            [cell ocj_setShowtitle:model.ocjStr_areaName];
        }
      
        [cell ocj_showIsCellSelected:[self ocj_checkModelIsSelected:element]];
    }
    else
    {
        NSString *string = [self.ocjArray_indexes objectAtIndex:indexPath.section];
        NSArray *array = [self.ocjDic_indexes objectForKey:string];
        NSObject* element = [array objectAtIndex:indexPath.row];
      
        if (self.ocjEnum_type == OCJGlobalScreenBrandAreaViewTypeBrand) {
            OCJGSModel_Brand* model = (OCJGSModel_Brand*)element;
            [cell ocj_setShowtitle:model.ocjStr_brandName];
        }else if (self.ocjEnum_type == OCJGlobalScreenBrandAreaViewTypeHotArea){
            OCJGSModel_HotArea* model = (OCJGSModel_HotArea*)element;
            [cell ocj_setShowtitle:model.ocjStr_areaName];
        }
      
        [cell ocj_showIsCellSelected:[self ocj_checkModelIsSelected:element]];
    }
  
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark - Table view didSelect

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.intTab_type == 0) {
        NSObject * obj = [self.ocjArray_main objectAtIndex:indexPath.row];
        if ([self ocj_checkModelIsSelected:obj]) {
            [self.ocjArray_Selected removeObject:[self ocj_checkModelIsSelected:obj]];
        }else{
            [self.ocjArray_Selected addObject:obj];
        }
    }else{
        NSString *string = [self.ocjArray_indexes objectAtIndex:indexPath.section];
        NSArray *array = [self.ocjDic_indexes objectForKey:string];
        NSObject * obj = [array objectAtIndex:indexPath.row];
      
        if ([self ocj_checkModelIsSelected:obj]) {
            [self.ocjArray_Selected removeObject:[self ocj_checkModelIsSelected:obj]];
        }else{
            [self.ocjArray_Selected addObject:obj];
        }
    }
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

@end
