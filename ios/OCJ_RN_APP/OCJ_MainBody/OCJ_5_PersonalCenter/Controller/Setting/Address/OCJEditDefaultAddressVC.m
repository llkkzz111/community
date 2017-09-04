//
//  OCJEditDefaultAddressVC.m
//  OCJ_RN_APP
//
//  Created by zhangyongbing on 2017/8/1.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJEditDefaultAddressVC.h"
#import "OCJEditAddressTVCell.h"
#import "OCJAddressSheetView.h"
#import "OCJHttp_addressControlAPI.h"

@interface OCJEditDefaultAddressVC ()<UITableViewDelegate,UITableViewDataSource, UITextViewDelegate>
@property (nonatomic, strong) OCJBaseTableView *ocjTBView_edit;

@property (nonatomic,strong) OCJPersonalModel_DefaultAdressDesc *ocjAdress_desc;
@property (nonatomic,strong) OCJBaseLabel           *ocjLab_address;       ///< 地址
@property (nonatomic,strong) OCJBaseTextView        *ocjtv_addDetail;      ///< 详细地址

@property (nonatomic,strong) OCJBaseButton          *ocjBtn_confirm;          ///< 保存按钮

@property (nonatomic,strong) UIImageView            *ocjImage_company;

@property (nonatomic,strong) UIImageView            *ocjImage_residence;

@property (nonatomic,strong) NSString               *ocjStr_placeGb;

@property (nonatomic,strong) NSString               *ocjStr_adress;

@property (nonatomic,strong) NSString               *ocjStr_adressDetail;

@end

@implementation OCJEditDefaultAddressVC

- (instancetype)initWithAddressModel:(OCJPersonalModel_DefaultAdressDesc *)adddesc
{
  self = [super init];
  if (self) {
    self.ocjAdress_desc = adddesc;
    self.ocjStr_placeGb = adddesc.ocjStr_placeGb;
    NSString *addressStr = [NSString stringWithFormat:@"%@ %@ %@", self.ocjAdress_desc.ocjStr_provinceName, self.ocjAdress_desc.ocjStr_cityName, self.ocjAdress_desc.ocjStr_areaName];
    self.ocjStr_adress = addressStr;
    self.ocjStr_adressDetail = self.ocjAdress_desc.ocjStr_addr;
    if (![self.ocjStr_placeGb isEqualToString:@"10"] && ![_ocjStr_placeGb isEqualToString:@"20"]) {
      self.ocjStr_placeGb = @"10";
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self ocj_setSelf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf {
  self.title = @"设置默认地址";
  [self ocj_addTableView];
}

/**
 tableView
 */
- (void)ocj_addTableView {
  [self.view addSubview:self.ocjTBView_edit];
  [self.ocjTBView_edit mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.view);
    make.right.mas_equalTo(self.view);
    make.top.mas_equalTo(self.view);
    make.bottom.mas_equalTo(self.view.mas_bottom);
  }];
}

- (OCJBaseTableView *)ocjTBView_edit{
  if (!_ocjTBView_edit) {
    _ocjTBView_edit = [[OCJBaseTableView alloc]init];
    _ocjTBView_edit.backgroundColor = [UIColor colorWSHHFromHexString:@"ededed"];
    _ocjTBView_edit.scrollEnabled = NO;
    _ocjTBView_edit.dataSource = self;
    _ocjTBView_edit.delegate   = self;
    _ocjTBView_edit.tableFooterView = [[UIView alloc]init];
    _ocjTBView_edit.tableHeaderView = [[UIView alloc]init];
    
  }
  return _ocjTBView_edit;
}

/**
 默认地址cell
 */
- (void)ocj_addDefault:(UITableViewCell *)cell{
    OCJBaseLabel *ocjLab_company = [[OCJBaseLabel alloc] init];
    ocjLab_company.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_company.font = [UIFont systemFontOfSize:14];
    ocjLab_company.textAlignment = NSTextAlignmentRight;
    ocjLab_company.text = @"公司";
    [cell.contentView addSubview:ocjLab_company];
    [ocjLab_company mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.mas_equalTo(cell.contentView);
      make.right.mas_equalTo(cell.contentView.mas_right).offset(-15);
      make.height.mas_equalTo(@20);
    }];
    
    UIImageView *ocj_imageIcon1 = [[UIImageView alloc] init];
    [ocj_imageIcon1 setBackgroundColor:[UIColor clearColor]];
    [ocj_imageIcon1 setImage:[UIImage imageNamed:@"Icon_unselected"]];
    self.ocjImage_company = ocj_imageIcon1;
    [cell.contentView addSubview:ocj_imageIcon1];
    [ocj_imageIcon1 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.mas_equalTo(cell.contentView);
      make.right.mas_equalTo(ocjLab_company.mas_left).offset(-5);
      make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    OCJBaseLabel *ocjLab_residence = [[OCJBaseLabel alloc] init];
    ocjLab_residence.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_residence.font = [UIFont systemFontOfSize:14];
    ocjLab_residence.textAlignment = NSTextAlignmentRight;
    ocjLab_residence.text = @"住宅";
    [cell.contentView addSubview:ocjLab_residence];
    [ocjLab_residence mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.mas_equalTo(cell.contentView);
      make.right.mas_equalTo(ocj_imageIcon1.mas_left).offset(-20);
      make.height.mas_equalTo(@20);
    }];
    
    UIImageView *ocj_imageIcon2 = [[UIImageView alloc] init];
    [ocj_imageIcon2 setBackgroundColor:[UIColor clearColor]];
    [ocj_imageIcon2 setImage:[UIImage imageNamed:@"Icon_unselected"]];
    self.ocjImage_residence = ocj_imageIcon2;
    [cell.contentView addSubview:ocj_imageIcon2];
    [ocj_imageIcon2 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.mas_equalTo(cell.contentView);
      make.right.mas_equalTo(ocjLab_residence.mas_left).offset(-5);
      make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    UIButton *ocjBtn_residence = [[UIButton alloc] init];
    [ocjBtn_residence setBackgroundColor:[UIColor clearColor]];
    [ocjBtn_residence addTarget:self action:@selector(ocj_chooseDefaultButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    ocjBtn_residence.tag = 10;
    [cell.contentView addSubview:ocjBtn_residence];
    [ocjBtn_residence mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(cell.contentView.mas_top);
      make.bottom.mas_equalTo(cell.contentView.mas_bottom);
      make.left.mas_equalTo(ocj_imageIcon2.mas_left);
      make.right.mas_equalTo(ocjLab_residence.mas_right);
    }];
    
    UIButton *ocjBtn_company = [[UIButton alloc] init];
    [ocjBtn_company setBackgroundColor:[UIColor clearColor]];
    [ocjBtn_company addTarget:self action:@selector(ocj_chooseDefaultButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    ocjBtn_company.tag = 11;
    [cell.contentView addSubview:ocjBtn_company];
    [ocjBtn_company mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(cell.contentView.mas_top);
      make.bottom.mas_equalTo(cell.contentView.mas_bottom);
      make.left.mas_equalTo(ocj_imageIcon1.mas_left);
      make.right.mas_equalTo(ocjLab_company.mas_right);
    }];
    
    OCJBaseLabel *ocjLab_title = [[OCJBaseLabel alloc] init];
    ocjLab_title.textColor = OCJ_COLOR_DARK;
    ocjLab_title.font = [UIFont systemFontOfSize:14];
    ocjLab_title.text = @"默认配送";
    ocjLab_title.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
      make.top.mas_equalTo(cell.contentView.mas_top).offset(15);
      make.height.mas_equalTo(@22);
      
    }];
    
    if (self.ocjAdress_desc != nil) {
      if ([self.ocjAdress_desc.ocjStr_placeGb isEqualToString:@"10"]) {
          [self.ocjImage_company setImage:[UIImage imageNamed:@"Icon_unselected"]];
          [self.ocjImage_residence setImage:[UIImage imageNamed:@"Icon_selected"]];
      }
      else if ([self.ocjAdress_desc.ocjStr_placeGb isEqualToString:@"20"])
      {
          [self.ocjImage_company setImage:[UIImage imageNamed:@"Icon_selected"]];
          [self.ocjImage_residence setImage:[UIImage imageNamed:@"Icon_unselected"]];
      }
      else
      {
          //默认家庭
          self.ocjAdress_desc.ocjStr_placeGb = @"10";
          [self.ocjImage_company setImage:[UIImage imageNamed:@"Icon_unselected"]];
          [self.ocjImage_residence setImage:[UIImage imageNamed:@"Icon_selected"]];
      }
    }
  
}

- (void)ocj_chooseDefaultButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
      case 10:
      {
          self.ocjAdress_desc.ocjStr_placeGb = @"10";
          [self.ocjImage_company setImage:[UIImage imageNamed:@"Icon_unselected"]];
          [self.ocjImage_residence setImage:[UIImage imageNamed:@"Icon_selected"]];
      }
        break;
      case 11:
      {
          self.ocjAdress_desc.ocjStr_placeGb = @"20";
          [self.ocjImage_company setImage:[UIImage imageNamed:@"Icon_selected"]];
          [self.ocjImage_residence setImage:[UIImage imageNamed:@"Icon_unselected"]];
      }
        break;
      default:
        break;
    }
}

/**
 保存地址/删除地址cell
 */
- (UITableViewCell *)ocj_addSaveAddressCell {
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.backgroundColor = [UIColor colorWSHHFromHexString:@"ededed"];
  
 
  self.ocjBtn_confirm = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH - 40, 45)];
  
  [self.ocjBtn_confirm setTitle:@"保存地址" forState:UIControlStateNormal];
  [self.ocjBtn_confirm ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
  [self.ocjBtn_confirm setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
  self.ocjBtn_confirm.ocjFont = [UIFont systemFontOfSize:17];
  self.ocjBtn_confirm.layer.cornerRadius = 2;
  
  if (self.ocjtv_addDetail != nil) {
    self.ocjBtn_confirm.alpha = 1.0;
    self.ocjBtn_confirm.userInteractionEnabled = YES;
  }else {
    self.ocjBtn_confirm.alpha = 0.2;
    self.ocjBtn_confirm.userInteractionEnabled = NO;
  }
  
  [self.ocjBtn_confirm addTarget:self action:@selector(ocjSaveAction) forControlEvents:UIControlEventTouchUpInside];
  [cell.contentView addSubview:self.ocjBtn_confirm];
  
  return cell;
}

/**
 点击保存按钮
 */
- (void)ocjSaveAction{
    if ([self.ocjLab_address.text length] == 0) {
      [OCJProgressHUD ocj_showHudWithTitle:@"请选择地址" andHideDelay:2.0];
      return;
    }
    if ([self.ocjtv_addDetail.text length] < 5) {
      [OCJProgressHUD ocj_showHudWithTitle:@"详细地址输入内容不得少于5个字" andHideDelay:2.0];
      return;
    }
  
    [OCJHttp_addressControlAPI ocjAuth_changeDefaultAdressInfoWithProvinceCode:self.ocjAdress_desc.ocjStr_province cityCode:self.ocjAdress_desc.ocjStr_city areaCode:self.ocjAdress_desc.ocjStr_area addrDetail:self.ocjtv_addDetail.text placeGb:self.ocjAdress_desc.ocjStr_placeGb completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          
          [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notification_personalCenter object:nil];
          [self.navigationController popViewControllerAnimated:YES];
          
          [OCJProgressHUD ocj_showHudWithTitle:@"保存成功" andHideDelay:1.0];
        }
    }];
  
}

/**
 返回
 */
- (void)ocj_back {
  NSString *addressStr = [NSString stringWithFormat:@"%@ %@ %@", self.ocjAdress_desc.ocjStr_provinceName, self.ocjAdress_desc.ocjStr_cityName, self.ocjAdress_desc.ocjStr_areaName];
  
  if ([self.ocjStr_placeGb isEqualToString:self.ocjAdress_desc.ocjStr_placeGb] && [self.ocjStr_adressDetail isEqualToString:self.ocjtv_addDetail.text] && [self.ocjStr_adress isEqualToString:addressStr]) {
    //
    [super ocj_back];
  }
  else
  {
    [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeNone title:@"" message:@"信息还未保存，确认现在返回吗？" sureButtonTitle:@"确定" CancelButtonTitle:@"取消" action:^(NSInteger clickIndex) {
      if (clickIndex == 1) {
        [super ocj_back];
      }else {
        
      }
    }];
  }
}

- (void)ocj_textFieldValueChanged {
  if ([self.ocjtv_addDetail.text length] > 0 && ![self.ocjLab_address.text isEqualToString:@"请选择地址"]) {
    self.ocjBtn_confirm.alpha = 1.0;
    self.ocjBtn_confirm.userInteractionEnabled = YES;
  }else {
    self.ocjBtn_confirm.alpha = 0.2;
    self.ocjBtn_confirm.userInteractionEnabled = NO;
  }
}


#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 2;
  }
  else
  {
    return 2;
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
  footView.backgroundColor = [UIColor clearColor];
  return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ( indexPath.section == 0) {
    if (indexPath.row == 0) {
      return 50;
    }
    else
    {
      return 70;
    }
  }else if (indexPath.section == 1){
    if (indexPath.row == 0) {
      return 50;
    }
    else
    {
      return 128;
    }
  }
  return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *cellIdentifier = @"CellIdentifier";
  OCJEditAddressTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[OCJEditAddressTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }
  
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
  
  if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
    [cell setPreservesSuperviewLayoutMargins:NO];
  }
  
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      static NSString *cellIdentifier = @"OCJEditAddressSelectedTVCellIdentifier";
      OCJEditAddressSelectedTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (!cell) {
        cell = [[OCJEditAddressSelectedTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
      }
      cell.ocjLab_tip.text = @"所在地区:";
      self.ocjLab_address = cell.ocjLab_cityLabel;
      
      if (self.ocjAdress_desc != nil) {
        NSString *addressStr = [NSString stringWithFormat:@"%@ %@ %@", self.ocjAdress_desc.ocjStr_provinceName, self.ocjAdress_desc.ocjStr_cityName, self.ocjAdress_desc.ocjStr_areaName];
        self.ocjLab_address.text = addressStr;
        self.ocjLab_address.textColor = OCJ_COLOR_DARK_GRAY;
      }else {
        self.ocjLab_address.text = @"请选择地址";
        self.ocjLab_address.textColor = OCJ_COLOR_LIGHT_GRAY;
      }
      return cell;
    }
    else
    {
      cell.ocjLab_tip.text = @"详细地址：";
      static NSString *cellIdentifier = @"OCJEditMiddleTVCellIdentifier";
      OCJEditMiddleTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      if (!cell) {
        cell = [[OCJEditMiddleTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
      }
      
      cell.ocjLab_placeholder.text = @"(为了快速准确完成商品配送，请输入详细的路名/号牌信息)";
      self.ocjtv_addDetail = cell.ocjTV_city;
      self.ocjtv_addDetail.textAlignment = NSTextAlignmentRight;
      self.ocjtv_addDetail.delegate = self;
      if (self.ocjAdress_desc != nil && ![self.ocjAdress_desc.ocjStr_addr isEqualToString:@""]) {
        self.ocjtv_addDetail.text = self.ocjAdress_desc.ocjStr_addr;
        cell.ocjLab_placeholder.hidden = YES;
      }
      else
      {
        self.ocjtv_addDetail.text = @"";
        cell.ocjLab_placeholder.hidden = NO;
      }
      
      return cell;
    }
  }
  else
  {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ocj_addDefault:cell];
        return cell;
    }
    else
    {
      UITableViewCell *cell = [self ocj_addSaveAddressCell];
      return cell;
    }
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == 0 && indexPath.row == 0) {

    [OCJAddressSheetView ocj_popAddressSheetCompletion:^(NSDictionary *dic_address) {
      
      NSString *city = [dic_address objectForKey:@"city"];
      NSString *district = [dic_address objectForKey:@"district"];
      NSString *province = [dic_address objectForKey:@"provenice"];
      
      NSString *addressStr;
      if (!self.ocjAdress_desc) {
        self.ocjAdress_desc = [[OCJPersonalModel_DefaultAdressDesc alloc] init];
      }
      
      self.ocjAdress_desc.ocjStr_province = [dic_address objectForKey:@"proveniceCode"];
      self.ocjAdress_desc.ocjStr_city = [dic_address objectForKey:@"cityCode"];
      self.ocjAdress_desc.ocjStr_area = [dic_address objectForKey:@"districtCode"];
      self.ocjAdress_desc.ocjStr_areaName = district;
      self.ocjAdress_desc.ocjStr_cityName = city;
      self.ocjAdress_desc.ocjStr_provinceName = province;
      
      
      if ([province isEqualToString:city]) {
        addressStr = [NSString stringWithFormat:@"%@ %@", city, district];
      }else if ([city isEqualToString:district]) {
        addressStr = [NSString stringWithFormat:@"%@ %@", province, city];
      }else {
        OCJLog(@"选择地址");
        addressStr = [NSString stringWithFormat:@"%@ %@ %@", province, city, district];
      }
      self.ocjLab_address.text = [NSString stringWithFormat:@"%@",addressStr];
      [self ocj_textFieldValueChanged];
    }];
  }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
  
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    if (indexPath.row != 4 && indexPath.row != 5 && indexPath.row != 3) {
      [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }else{
      [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
    }
  }
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    if (indexPath.row != 4 && indexPath.row != 5 && indexPath.row != 3) {
      [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }else{
      [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
    }
  }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  UITableViewCell *cell = [self.ocjTBView_edit cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
  if ([cell isKindOfClass:[OCJEditMiddleTVCell class]]) {
    if (![text isEqualToString:@""]) {
      [(OCJEditMiddleTVCell *)cell ocj_showplaceholder:YES];
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
      [(OCJEditMiddleTVCell *)cell ocj_showplaceholder:NO];
    }
  }
  [self ocj_textFieldValueChanged];
  return YES;
}

@end
