//
//  OCJAreaSettingVC.m
//  OCJ
//
//  Created by Ray on 2017/6/5.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJAreaSettingVC.h"
#import "OCJAreaSettingTVCell.h"
#import "OCJHttp_authAPI.h"

@interface OCJAreaSettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_area;///<tableView

@property (nonatomic, strong) OCJBaseButton *ocjBtn_last;     ///<
@property (nonatomic, assign) CGFloat ocjFloat_height;        ///<热门地区view高度

@property (nonatomic, strong) NSMutableArray *ocjArr_indexs;  ///<
@property (nonatomic, strong) NSMutableArray *ocjArr_title;   ///<
@property (nonatomic) UIStatusBarStyle ocjStatusBayStyle;     ///<记录状态栏状态

@property(nonatomic ,strong)NSMutableDictionary * ocjDict_dataDict;//按字母保存省份字典
@property(nonatomic ,strong)NSMutableArray * ocjArray_hotRegionArr;//保存热门城市数组
@property(nonatomic ,strong)OCJAreaProvinceListModel * ocjModel_provinceModel;//省份信息model

@end

@implementation OCJAreaSettingVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)
- (NSMutableDictionary *)ocjDict_dataDict {
  if (!_ocjDict_dataDict) {
    _ocjDict_dataDict = [NSMutableDictionary dictionary];
  }
  return _ocjDict_dataDict;
}

- (NSMutableArray *)ocjArray_hotRegionArr {
  if (!_ocjArray_hotRegionArr) {
    _ocjArray_hotRegionArr = [NSMutableArray array];
  }
  return _ocjArray_hotRegionArr;
}

- (void)ocj_requestAreaData {
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
    [self.ocjTBView_area reloadData];
//    [self reloadDataHotRegion];
  }];
}

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.ocjStatusBayStyle = [UIApplication sharedApplication].statusBarStyle;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:self.ocjStatusBayStyle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf {
    self.title = @"地区设置";
    self.ocjFloat_height = 0;
    self.ocjArr_indexs = [NSMutableArray array];
    self.ocjArr_title = [NSMutableArray array];
    
    for(char c = 'A'; c <= 'Z'; c++ )
    {
        [self.ocjArr_indexs addObject:[NSString stringWithFormat:@"%c",c]];
        [self.ocjArr_title addObject:[NSString stringWithFormat:@"%c",c]];
        [self.ocjArr_title addObject:[NSString stringWithFormat:@"%c",c]];
    }
    [self ocj_addTableView];
  [self ocj_requestAreaData];
}

- (void)ocj_addTableView {
    self.ocjTBView_area = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.ocjTBView_area.delegate = self;
    self.ocjTBView_area.dataSource = self;
    self.ocjTBView_area.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ocjTBView_area.tableHeaderView = [self ocj_addHotAreaView];
    [self.view addSubview:self.ocjTBView_area];
}

- (UIView *)ocj_addHotAreaView {
    UIView *ocjView_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 76)];
    ocjView_bg.backgroundColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    
    UIView *ocjView_top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 24)];
    ocjView_top.backgroundColor = [UIColor colorWSHHFromHexString:@"EDEDED"];
    [ocjView_bg addSubview:ocjView_top];
    
    OCJBaseLabel *ocjLab_hot = [[OCJBaseLabel alloc] init];
    ocjLab_hot.text = @"热门地区";
    ocjLab_hot.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_hot.font = [UIFont systemFontOfSize:12];
    ocjLab_hot.textAlignment = NSTextAlignmentLeft;
    [ocjView_top addSubview:ocjLab_hot];
    [ocjLab_hot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjView_top.mas_left).offset(15);
        make.top.bottom.mas_equalTo(ocjView_top);
    }];
    
    //热门地区
    __block NSInteger row = 1;
    __block CGFloat labWidth,labHeight,totalRowWidth = 15,totalHeight = 30 + 24,horSpace = 5,verSpace = 15;
    NSArray *ocjArr_hotArea = @[@"新疆维吾尔族自治区",@"上海",@"北京",@"江苏",@"黑龙江",@"四川",@"浙江",@"湖北",@"齐齐哈尔",@"南京"];
    
    for (int i = 0; i < self.ocjArray_hotRegionArr.count; i++) {
        NSString *ocjStr = [self ocj_transFormChineseToPinyin:ocjArr_hotArea[i]];
        OCJLog(@"str = %@", ocjStr);
        UIButton *ocjLab_area = [[UIButton alloc] init];
        ocjLab_area.titleLabel.font = [UIFont systemFontOfSize:12];
        [ocjLab_area setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
        [ocjLab_area setTitle:ocjArr_hotArea[i] forState:UIControlStateNormal];
        
        CGRect receSize = [self ocj_calculateLabelRectWithString:ocjLab_area.titleLabel.text label:ocjLab_area.titleLabel];
        labWidth = receSize.size.width + 28;
        labHeight = ceilf(receSize.size.height) + 4;
        
        [ocjView_bg addSubview:ocjLab_area];
        [ocjLab_area mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (!self.ocjBtn_last) {
                totalRowWidth += labWidth;
                totalHeight += labHeight;
                make.left.mas_equalTo(ocjView_bg.mas_left).offset(15);
            }else {
                totalRowWidth += horSpace + labWidth;
                if (totalRowWidth > SCREEN_WIDTH - 50) {
                    totalHeight += verSpace + labHeight;
                    make.left.mas_equalTo(ocjView_bg.mas_left).offset(15);
                }else {
                    make.left.mas_equalTo(self.ocjBtn_last.mas_right).offset(horSpace);
                }
            }
            if (totalRowWidth > SCREEN_WIDTH - 50) {
                row += 1;
                totalRowWidth = 30 + labWidth;
            }
            make.top.mas_equalTo(ocjView_bg.mas_top).offset(15 * row + (row - 1) * labHeight + 24);
            
            make.width.mas_equalTo(labWidth);
            make.height.mas_equalTo(labHeight);
        }];
        self.ocjBtn_last = ocjLab_area;
    }
    
    ocjView_bg.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, totalHeight);
    self.ocjFloat_height = totalHeight;
    
    return ocjView_bg;
}

/**
 根据文字内容跟字体大小计算宽高
 */
- (CGRect)ocj_calculateLabelRectWithString:(NSString *)ocjStr label:(UILabel *)ocjLab {
    CGRect rect = [ocjStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20 - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:ocjLab.font.pointSize]} context:nil];
    
    return rect;
}

- (NSString *)ocj_transFormChineseToPinyin:(NSString *)chineseStr {
    NSMutableString *pinyin = [chineseStr mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}

#pragma mark - 协议方法实现区域
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.ocjDict_dataDict allKeys] count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray * keyArr = [[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
  return [self.ocjDict_dataDict[keyArr[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"OCJAreaSettingTVCell";
    OCJAreaSettingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (!cell) {
        cell = [[OCJAreaSettingTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
  NSArray * keyArr = [[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
  
  cell.ocjLab_title.text = [self.ocjDict_dataDict[keyArr[indexPath.section]][indexPath.row] ocjStr_name];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *ocjView_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 24)];
    ocjView_header.backgroundColor = [UIColor colorWSHHFromHexString:@"EDEDED"];
    
    OCJBaseLabel *ocjLab_title = [[OCJBaseLabel alloc] init];
    ocjLab_title.font = [UIFont systemFontOfSize:12];
    ocjLab_title.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_title.textAlignment = NSTextAlignmentLeft;
  NSArray * keyArr = [[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    ocjLab_title.text = [keyArr objectAtIndex:section];
    
    [ocjView_header addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjView_header.mas_left).offset(15);
        make.top.bottom.mas_equalTo(ocjView_header);
    }];
    
    return ocjView_header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:[[[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy]];
  [arr insertObject:@"#" atIndex:0];
  return arr;
//    return self.ocjArr_indexs;
}
//响应点击索引时的委托方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger count = 0;
  NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:[[[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy]];
  [arr insertObject:@"#" atIndex:0];
    for (NSString *character in arr) {
        
        if ([[character uppercaseString] hasPrefix:title]) {
            return count;
        }
        
        count++;
    }
    
    return  0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSArray * keyArr = [[self.ocjDict_dataDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
  OCJSinglProvinceModel* proviceModel = self.ocjDict_dataDict[keyArr[indexPath.section]][indexPath.row];
  
  NSDictionary* provinceDic = [NSDictionary dictionary];
  provinceDic = [self ocj_getLoginGetPostParametersFromModel:proviceModel];
  [[NSUserDefaults standardUserDefaults] setObject:provinceDic forKey:OCJUserInfo_Province];
  [OCJProgressHUD ocj_showHudWithTitle:@"地区设置成功" andHideDelay:2.0];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.navigationController popViewControllerAnimated:YES];
  });
  
}

- (NSDictionary*)ocj_getLoginGetPostParametersFromModel:(OCJSinglProvinceModel*)model{
  NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
  [mDic setValue:model.ocjStr_regionCd forKey:@"region_cd"];
  [mDic setValue:model.ocjStr_selRegionCd forKey:@"sel_region_cd"];
  [mDic setValue:model.ocjStr_id forKey:@"substation_code"];
  [mDic setValue:model.ocjStr_remark forKey:@"district_code"];
  [mDic setValue:model.ocjStr_remark1_v forKey:@"area_lgroup"];
  [mDic setValue:model.ocjStr_remark2_v forKey:@"area_mgroup"];
  [mDic setValue:model.ocjStr_name forKey:@"area_lgroup_name"];
  
  return [mDic copy];
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
