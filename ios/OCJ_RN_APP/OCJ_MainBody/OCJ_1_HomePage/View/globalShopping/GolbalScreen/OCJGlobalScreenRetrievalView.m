//
//  OCJGlobalScreenRetrievalView.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobalScreenRetrievalView.h"
#import "OCJGlobalScreenRetrievalHead.h"
#import "OCJGlobalScreenRetrievalButtonViewCell.h"
#import "OCJGlobalScreenRetrievalPriceTableViewCell.h"
#import "OCJGlobalScreenBrandAreaView.h"

@interface OCJGlobalScreenRetrievalView()<UITableViewDelegate,UITableViewDataSource,OCJGlobalScreenRetrievalButtonViewCellDelegate,OCJGlobalScreenRetrievalPriceTableViewCellDelegate,OCJGlobalScreenRetrievalHeadDelegate,OCJGlobalScreenBrandAreaViewDelegate>
@property (nonatomic,strong) UIView         *ocjViwe_bg;
@property (nonatomic,strong) UIView         *ocjView_tableViewBg;
@property (nonatomic,strong) UITableView    *ocjTableView_main;
@property (nonatomic,strong) UIView         *ocjView_button;
@property (nonatomic,strong) UIButton       *ocjBtn_sure;
@property (nonatomic,strong) UIButton       *ocjBtn_cancel;
@property (nonatomic,strong) UIView         *ocjView_gap;

@property (nonatomic,strong) NSMutableArray *ocjArray_main;
@property (nonatomic,strong) NSMutableArray *ocjArray_selectBrand;
@property (nonatomic,strong) NSMutableArray *ocjArray_selectCategory;
@property (nonatomic,strong) NSMutableArray *ocjArray_selectArea;

@property (nonatomic,strong) NSString       *ocjStr_brandTitle;
@property (nonatomic,strong) NSString       *ocjStr_areaTitle;
@property (nonatomic,strong) NSString       *ocjStr_categoryTitle;
@property (nonatomic,strong) NSString       *ocjStr_minPrice;
@property (nonatomic,strong) NSString       *ocjStr_maxPrice;

@property (nonatomic,strong) NSMutableArray *ocjArray_showDetail;
@end

@implementation OCJGlobalScreenRetrievalView

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    self.ocjStr_brandTitle = @"全部";
    self.ocjStr_areaTitle = @"全部";
    self.ocjStr_categoryTitle = @"全部";
    for (int i = 0; i<4; i++) {
      [self.ocjArray_showDetail addObject:[NSNumber numberWithBool:YES]];
    }
    [self ocj_addViews];
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
  
  CGFloat tableviewW = SCREEN_WIDTH*320/375;
  
  [self addSubview:self.ocjView_tableViewBg];
  [self.ocjView_tableViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self).offset(SCREEN_WIDTH);
    make.top.mas_equalTo(self);
    make.size.mas_equalTo(CGSizeMake(tableviewW, SCREEN_HEIGHT));
  }];
  
  [self.ocjView_tableViewBg addSubview:self.ocjView_button];
  [self.ocjView_button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_tableViewBg);
    make.right.mas_equalTo(self.ocjView_tableViewBg);
    make.bottom.mas_equalTo(self.ocjView_tableViewBg);
    make.size.height.mas_equalTo(44);
  }];
  
  [self.ocjView_button addSubview:self.ocjView_gap];
  [self.ocjView_gap mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.ocjView_button);
    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
  }];
  
  [self.ocjView_button addSubview:self.ocjBtn_cancel];
  [self.ocjBtn_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.ocjView_button);
    make.left.mas_equalTo(self.ocjView_button);
    make.bottom.mas_equalTo(self.ocjView_button);
    make.size.with.mas_equalTo(tableviewW/2);
  }];
  [self.ocjView_button addSubview:self.ocjBtn_sure];
  [self.ocjBtn_sure mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.ocjView_button);
    make.left.mas_equalTo(self.ocjBtn_cancel.mas_right);
    make.bottom.mas_equalTo(self.ocjView_button);
    make.size.with.mas_equalTo(tableviewW/2);
  }];
  
  
  [self.ocjView_tableViewBg addSubview:self.ocjTableView_main];
  [self.ocjTableView_main mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_tableViewBg);
    make.right.mas_equalTo(self.ocjView_tableViewBg);
    make.top.mas_equalTo(self.ocjView_tableViewBg).offset(20);
    make.bottom.mas_equalTo(self.ocjView_button.mas_top);
  }];
  
  [self layoutIfNeeded];
  
}

- (void)ocj_showChooseView {
  
  CGFloat tableviewW = SCREEN_WIDTH*320/375;
  
  [self.ocjView_tableViewBg mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self).offset(SCREEN_WIDTH - tableviewW);//这里是设置动画的结尾位置
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

- (void)ocj_surebuttonPressed:(id)sender
{
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  if (self.ocjArray_selectBrand.count > 0) {
    NSString *stringBrand = @"";
    NSDictionary *dicf = [self.ocjArray_selectBrand objectAtIndex:0];
    stringBrand = [dicf objectForKey:@"propertyName"];
    for (int i = 1; i < self.ocjArray_selectBrand.count; i++) {
      NSDictionary *dic = [self.ocjArray_selectBrand objectAtIndex:i];
      NSString *strtitle = [dic objectForKey:@"propertyName"];
      stringBrand = [NSString stringWithFormat:@"%@,%@",stringBrand,strtitle];
    }
    [dictionary setObject:stringBrand forKey:@"brandConditions"];
  }
  
  if (self.ocjArray_selectArea.count > 0) {
    NSString *stringarea = @"";
    stringarea = [self.ocjArray_selectArea objectAtIndex:0];
    for (int i = 1; i < self.ocjArray_selectArea.count; i++) {
      stringarea = [NSString stringWithFormat:@"%@,%@",stringarea,[self.ocjArray_selectArea objectAtIndex:i]];
    }
    [dictionary setObject:stringarea forKey:@"areaConditions"];
  }
  
  if (self.ocjArray_selectCategory.count > 0) {
    NSString *stringaCategory = @"";
    stringaCategory = [self.ocjArray_selectCategory objectAtIndex:0];
    for (int i = 1; i < self.ocjArray_selectCategory.count; i++) {
      stringaCategory = [NSString stringWithFormat:@"%@,%@",stringaCategory,[self.ocjArray_selectCategory objectAtIndex:i]];
    }
    [dictionary setObject:stringaCategory forKey:@"cateConditions"];
  }
  if (self.ocjStr_minPrice) {
    [dictionary setObject:self.ocjStr_minPrice forKey:@"minPriceConditions"];
  }
  
  if (self.ocjStr_maxPrice) {
    [dictionary setObject:self.ocjStr_maxPrice forKey:@"maxPriceConditions"];
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalScreenRetrievalSelectfinish:)]) {
    [self.delegate ocj_golbalScreenRetrievalSelectfinish:dictionary];
  }
  [self ocj_removeSelf];
}

- (void)ocj_resetbuttonPressed:(id)sender
{
  self.ocjStr_minPrice = @"";
  self.ocjStr_maxPrice = @"";
  self.ocjStr_areaTitle = @"全部";
  self.ocjStr_brandTitle = @"全部";
  self.ocjStr_categoryTitle = @"全部";
  [self.ocjArray_selectArea removeAllObjects];
  [self.ocjArray_selectBrand removeAllObjects];
  [self.ocjArray_selectCategory removeAllObjects];
  [self.ocjTableView_main reloadData];
}

- (void)ocj_setChooseArray:(NSArray *)array
          SelectDictionary:(NSDictionary *)dictionary
{
  [self.ocjArray_main removeAllObjects];
  [self.ocjArray_main addObjectsFromArray:array];
  //处理已选择条件
  //品牌
  NSString *chooseBrand = [dictionary objectForKey:@"brandConditions"];
  if (chooseBrand) {
    NSArray *brand = [chooseBrand componentsSeparatedByString:@","];
    NSArray *allBrand = [self.ocjArray_main objectAtIndex:0];
    for (NSDictionary *dic in allBrand) {
      NSString *stringBrand = [dic objectForKey:@"propertyName"];
      if ([brand indexOfObject:stringBrand] != NSNotFound) {
        [self.ocjArray_selectBrand addObject:dic];
      }
    }
  }
  
  //地区
  NSString *chooseArea = [dictionary objectForKey:@"areaConditions"];
  if (chooseArea) {
    NSArray *area = [chooseArea componentsSeparatedByString:@","];
    NSArray *allArea = [self.ocjArray_main objectAtIndex:1];
    for (NSString *string in allArea) {
      if ([area indexOfObject:string] != NSNotFound) {
        [self.ocjArray_selectArea addObject:string];
      }
    }
  }
  
  //类别
  NSString *chooseCate = [dictionary objectForKey:@"cateConditions"];
  if (chooseCate) {
    NSArray *cate = [chooseCate componentsSeparatedByString:@","];
    NSArray *allCate = [self.ocjArray_main objectAtIndex:2];
    for (NSString *string in allCate) {
      if ([cate indexOfObject:string] != NSNotFound) {
        [self.ocjArray_selectCategory addObject:string];
      }
    }
  }
  
  NSString *minprice = [dictionary objectForKey:@"minPriceConditions"];
  if (minprice) {
    self.ocjStr_minPrice = minprice;
  }
  
  NSString *maxprice = [dictionary objectForKey:@"maxPriceConditions"];
  if (maxprice) {
    self.ocjStr_maxPrice = maxprice;
  }
  
  //添加价格区间
  [self.ocjArray_main insertObject:@[] atIndex:2];
  [self.ocjTableView_main reloadData];
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
    [_ocjView_tableViewBg setBackgroundColor: [UIColor whiteColor]];
  }
  return _ocjView_tableViewBg;
}

- (UIView *)ocjView_button
{
  if (!_ocjView_button) {
    _ocjView_button = [[UIView alloc] init];
    [_ocjView_button setBackgroundColor: [UIColor whiteColor]];
  }
  return _ocjView_button;
}

- (UITableView *)ocjTableView_main{
  if (!_ocjTableView_main) {
    _ocjTableView_main = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _ocjTableView_main.backgroundColor = [UIColor clearColor];
    _ocjTableView_main.separatorStyle = UITableViewCellSeparatorStyleNone;
    _ocjTableView_main.showsVerticalScrollIndicator = NO;
    _ocjTableView_main.dataSource = self;
    _ocjTableView_main.delegate   = self;
    //        _ocjTableView_main.sectionFooterHeight = 0.0;
    //        _ocjTableView_main.sectionHeaderHeight = 0.0;
    _ocjTableView_main.sectionIndexColor =  [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
  }
  return _ocjTableView_main;
}

- (UIButton *)ocjBtn_sure
{
  if (!_ocjBtn_sure) {
    _ocjBtn_sure = [[UIButton alloc] init];
    _ocjBtn_sure.titleLabel.font = [UIFont systemFontOfSize:15];
    [_ocjBtn_sure setTitle:@"确定" forState:UIControlStateNormal];
    [_ocjBtn_sure setTitleColor:  [UIColor whiteColor] forState:UIControlStateNormal];
    _ocjBtn_sure.backgroundColor = [UIColor colorWithRed:299/255.0 green:31/255.0 blue:13/255.0 alpha:1/1.0];
    [_ocjBtn_sure addTarget:self action:@selector(ocj_surebuttonPressed:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _ocjBtn_sure;
}

- (UIButton *)ocjBtn_cancel
{
  if (!_ocjBtn_cancel) {
    _ocjBtn_cancel = [[UIButton alloc] init];
    _ocjBtn_cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [_ocjBtn_cancel setTitle:@"重置" forState:UIControlStateNormal];
    [_ocjBtn_cancel setTitleColor:  [UIColor blackColor] forState:UIControlStateNormal];
    _ocjBtn_cancel.backgroundColor = [UIColor clearColor];
    [_ocjBtn_cancel addTarget:self action:@selector(ocj_resetbuttonPressed:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _ocjBtn_cancel;
}

- (UIView *)ocjView_gap
{
  if (!_ocjView_gap) {
    _ocjView_gap = [[UIView alloc] init];
    [_ocjView_gap setBackgroundColor:[UIColor colorWithRed:230/255.0 green:231/255.0 blue:235/255.0 alpha:1/1.0]];
  }
  return _ocjView_gap;
}

- (NSMutableArray *)ocjArray_main
{
  if (!_ocjArray_main) {
    _ocjArray_main = [[NSMutableArray alloc] init];
  }
  return _ocjArray_main;
}

- (NSMutableArray *)ocjArray_selectBrand
{
  if (!_ocjArray_selectBrand) {
    _ocjArray_selectBrand = [[NSMutableArray alloc] init];
  }
  return _ocjArray_selectBrand;
}

- (NSMutableArray *)ocjArray_selectCategory
{
  if (!_ocjArray_selectCategory) {
    _ocjArray_selectCategory = [[NSMutableArray alloc] init];
  }
  return _ocjArray_selectCategory;
}

- (NSMutableArray *)ocjArray_selectArea
{
  if (!_ocjArray_selectArea) {
    _ocjArray_selectArea = [[NSMutableArray alloc] init];
  }
  return _ocjArray_selectArea;
}

- (NSMutableArray *)ocjArray_showDetail
{
  if (!_ocjArray_showDetail) {
    _ocjArray_showDetail = [[NSMutableArray alloc] init];
  }
  return _ocjArray_showDetail;
}

#pragma mark - 协议方法实现区域

#pragma mark - 协议方法实现区域

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  if (section == 2) {
    return 0.1;
  }
  CGFloat number = 44;
  return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
  OCJGlobalScreenRetrievalHead *view = [[OCJGlobalScreenRetrievalHead alloc] initWithFrame:CGRectMake(0, 0, 270, 44)];
  NSNumber *bumber = [self.ocjArray_showDetail objectAtIndex:section];
  BOOL  isShow = [bumber boolValue];
  [view ocj_IsShowDetail:isShow];
  view.ocjInt_viewTag = section;
  view.delegate = self;
  switch (section) {
    case 0:
    {
      if (self.ocjArray_selectBrand.count > 0) {
        NSString *string = @"";
        NSDictionary *dicf = [self.ocjArray_selectBrand objectAtIndex:0];
        NSArray *arraytitlef = [dicf objectForKey:@"propertyValue"];
        string = arraytitlef[0];
        for (int i = 1; i < self.ocjArray_selectBrand.count; i++) {
          NSDictionary *dic = [self.ocjArray_selectBrand objectAtIndex:i];
          NSArray *arraytitle = [dic objectForKey:@"propertyValue"];
          string = [NSString stringWithFormat:@"%@,%@",string,arraytitle[0]];
        }
        self.ocjStr_brandTitle = string;
      }
      else
      {
        self.ocjStr_brandTitle = @"全部";
      }
      [view ocj_setShowTitle:@"品牌" SubTitle:self.ocjStr_brandTitle];
      break;
    }
    case 1:
    {
      if (self.ocjArray_selectArea.count > 0) {
        NSString *string = [self.ocjArray_selectArea objectAtIndex:0];
        
        for (int i = 1; i < self.ocjArray_selectArea.count; i++) {
          string = [NSString stringWithFormat:@"%@,%@",string,[self.ocjArray_selectArea objectAtIndex:i]];
        }
        self.ocjStr_areaTitle = string;
      }
      else
      {
        self.ocjStr_areaTitle = @"全部";
      }
      [view ocj_setShowTitle:@"热门地区" SubTitle:self.ocjStr_areaTitle];
      break;
    }
    case 2:
    {
      [view ocj_setShowTitle:@"价格区间(元)" SubTitle:@""];
      break;
    }
    case 3:
    {
      if (self.ocjArray_selectCategory.count > 0) {
        NSString *string = [self.ocjArray_selectCategory objectAtIndex:0];
        
        for (int i = 1; i < self.ocjArray_selectCategory.count; i++) {
          string = [NSString stringWithFormat:@"%@,%@",string,[self.ocjArray_selectCategory objectAtIndex:i]];
        }
        self.ocjStr_categoryTitle = string;
      }
      else
      {
        self.ocjStr_categoryTitle = @"全部";
      }
      [view ocj_setShowTitle:@"类别" SubTitle:self.ocjStr_categoryTitle];
      break;
    }
    default:
      break;
  }
  view.clipsToBounds = YES;
  return view;
}


//返回section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
  // Return the number of sections.
  return self.ocjArray_main.count;
}


//返回每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 2) {
    //        return 1;
    return 0;
  }
  else if (section == 3) {
    NSNumber *bumber = [self.ocjArray_showDetail objectAtIndex:section];
    BOOL  isShow = [bumber boolValue];
    if (!isShow) {
      return 0;
    }
    NSInteger number;
    NSArray *arraySec = [self.ocjArray_main objectAtIndex:section];
    number = arraySec.count/3;
    if (arraySec.count%3 != 0) {
      number = number + 1;
    }
    return number;
  }
  else
  {
    NSInteger number;
    NSNumber *bumber = [self.ocjArray_showDetail objectAtIndex:section];
    BOOL  isShow = [bumber boolValue];
    if (!isShow) {
      return 0;
    }
    NSArray *arraySec = [self.ocjArray_main objectAtIndex:section];
    NSInteger count = arraySec.count;
    if (count > 9) {
      number = 3;
    }
    else
    {
      number = arraySec.count/3;
      if (arraySec.count%3 != 0) {
        number = number + 1;
      }
    }
    return number;
  }
  
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  CGFloat cellW = SCREEN_WIDTH*320/375;
  CGFloat btnW = (cellW - 50)/3;
  CGFloat benH = btnW*28/92 + 10;
  
  return benH;
}

//cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      static NSString * cellIdentifierprice = @"OCJGlobalScreenRetrievalPriceTableViewCell";
      OCJGlobalScreenRetrievalPriceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierprice];
      cell.delegate = self;
      if (!cell) {
        cell = [[OCJGlobalScreenRetrievalPriceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierprice];
      }
      return cell;
    }
    else
    {
      static NSString * cellIdentifiernomal = @"OCJGlobalScreenRetrievalButtonViewCell";
      OCJGlobalScreenRetrievalButtonViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiernomal];
      if (!cell) {
        cell = [[OCJGlobalScreenRetrievalButtonViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifiernomal];
      }
      cell.delegate = self;
      NSArray *arraSec = [self.ocjArray_main objectAtIndex:indexPath.section];
      NSMutableArray *array = [[NSMutableArray alloc] init];
      for (int i = 0 ; i < 3; i++) {
        if (arraSec.count > 3*indexPath.row + i) {
          [array addObject:[arraSec objectAtIndex:3*indexPath.row + i]];
        }
      }
      
      [cell ocj_setTitleArray:array SelectArray:self.ocjArray_selectBrand];
      
      return cell;
    }
  }
  else
  {
    static NSString * cellIdentifiernomal = @"OCJGlobalScreenRetrievalButtonViewCell";
    OCJGlobalScreenRetrievalButtonViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiernomal];
    if (!cell) {
      cell = [[OCJGlobalScreenRetrievalButtonViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifiernomal];
    }
    cell.delegate = self;
    NSArray *arraSec = [self.ocjArray_main objectAtIndex:indexPath.section];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 3; i++) {
      if (arraSec.count > 3*indexPath.row + i) {
        [array addObject:[arraSec objectAtIndex:3*indexPath.row + i]];
      }
      if (indexPath.section != 3) {
        if (arraSec.count > 9) {
          if (3*indexPath.row + i == 8) {
            NSMutableDictionary *dicAll = [[NSMutableDictionary alloc] init];
            [dicAll setObject:@[@"查看全部"] forKey:@"propertyValue"];
            [array replaceObjectAtIndex:2 withObject:dicAll];
          }
        }
      }
    }
    if (indexPath.section == 0) {
      [cell ocj_setTitleArray:array SelectArray:self.ocjArray_selectBrand];
    }
    else if (indexPath.section == 1)
    {
      [cell ocj_setTitleArray:array SelectArray:self.ocjArray_selectArea];
    }
    else if (indexPath.section == 3)
    {
      [cell ocj_setTitleArray:array SelectArray:self.ocjArray_selectCategory];
    }
    
    return cell;
  }
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



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}


- (void)ocj_golbalScreenRetrievalPressed:(NSInteger)index At:(OCJGlobalScreenRetrievalButtonViewCell *)cell
{
  NSIndexPath *indexPath = [self.ocjTableView_main indexPathForCell:cell];
  NSArray *arraSec = [self.ocjArray_main objectAtIndex:indexPath.section];
  if (arraSec.count > 9) {
    if (indexPath.row == 2 && index == 2) {
      if (indexPath.section == 0) {
        OCJGlobalScreenBrandAreaView *view = [[OCJGlobalScreenBrandAreaView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.delegate = self;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in self.ocjArray_selectBrand) {
          [array addObject:[dic objectForKey:@"propertyName"]];
        }
//        [view ocj_setTitle:@"品牌" ScreenArray:arraSec SelectedArrar:array];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:view];
        [view ocj_showChooseView];
      }
      else if (indexPath.section == 1)
      {
        OCJGlobalScreenBrandAreaView *view = [[OCJGlobalScreenBrandAreaView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.delegate = self;
//        [view ocj_setTitle:@"热门地区" ScreenArray:arraSec SelectedArrar:self.ocjArray_selectArea];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:view];
        [view ocj_showChooseView];
      }
      return;
    }
  }
  if (indexPath.section == 0) {
    NSDictionary *dic = [arraSec objectAtIndex:3*indexPath.row + index];
    if ([self.ocjArray_selectBrand indexOfObject:dic] != NSNotFound) {
      [self.ocjArray_selectBrand removeObject:dic];
    }
    else
    {
      [self.ocjArray_selectBrand addObject:dic];
    }
    
  }
  else if (indexPath.section == 1)
  {
    NSString *string = [arraSec objectAtIndex:3*indexPath.row + index];
    if ([self.ocjArray_selectArea indexOfObject:string] != NSNotFound) {
      [self.ocjArray_selectArea removeObject:string];
    }
    else
    {
      [self.ocjArray_selectArea addObject:string];
    }
    
  }
  else if (indexPath.section == 3)
  {
    NSString *string = [arraSec objectAtIndex:3*indexPath.row + index];
    if ([self.ocjArray_selectCategory indexOfObject:string] != NSNotFound) {
      [self.ocjArray_selectCategory removeObject:string];
    }
    else
    {
      [self.ocjArray_selectCategory addObject:string];
    }
    
  }
  
  [self.ocjTableView_main reloadData];
}

- (void)ocj_golbalScreenRetrievalPriceChangeed:(NSString *)price At:(BOOL)isMax
{
  if (isMax) {
    self.ocjStr_maxPrice = price;
  }
  else
  {
    self.ocjStr_minPrice = price;
  }
}

- (void)ocj_onScreenRetrievalHeadPressed:(NSInteger)tag
{
  NSNumber *bumber = [self.ocjArray_showDetail objectAtIndex:tag];
  BOOL  isShow = ![bumber boolValue];
  [self.ocjArray_showDetail replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:isShow]];
  [self.ocjTableView_main reloadData];
}

- (void)ocj_golbalScreenBrandAreaSelectfinish:(NSDictionary *)dictionary
{
  NSString *stringBrand = [dictionary objectForKey:@"brandConditions"];
  if (stringBrand) {
    [self.ocjArray_selectBrand removeAllObjects];
    
    NSArray *brand = [stringBrand componentsSeparatedByString:@","];
    NSArray *allBrand = [self.ocjArray_main objectAtIndex:0];
    for (NSDictionary *dic in allBrand) {
      NSString *stringBrand = [dic objectForKey:@"propertyName"];
      if ([brand indexOfObject:stringBrand] != NSNotFound) {
        [self.ocjArray_selectBrand addObject:dic];
      }
    }
  }
  NSString *stringArea = [dictionary objectForKey:@"areaConditions"];
  if (stringArea) {
    [self.ocjArray_selectArea removeAllObjects];
    NSArray *area = [stringArea componentsSeparatedByString:@","];
    [self.ocjArray_selectArea addObjectsFromArray:area];
  }
  [self.ocjTableView_main reloadData];
}

@end

