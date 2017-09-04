//
//  OCJEditAddressVC.m
//  OCJ
//
//  Created by OCJ on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJEditAddressVC.h"
#import "OCJBaseTableView.h"
#import "OCJEditAddressTVCell.h"
#import "OCJAddressSheetView.h"
#import "OCJHttp_addressControlAPI.h"
#import "OCJConfirmBtnTVCell.h"
#import "WSHHRegex.h"

@interface OCJEditAddressVC ()<UITableViewDelegate,UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic,assign) OCJEditType            ocjEnum_editType;      ///< 编辑类型
@property (nonatomic,copy) OCJShopAddressHandler    ocjBlock_handler;      ///< 处理回调block
@property (nonatomic,strong) OCJAddressModel_listDesc  *ocjModel_address;  ///< model
@property (nonatomic,strong) OCJBaseTableView       *ocjTableView;         ///< tableView
@property (nonatomic,strong) OCJBaseButton          *ocjBtn_confirm;          ///< 保存按钮
@property (nonatomic,strong) OCJBaseLabel           *ocjLab_address;       ///< 地址
@property (nonatomic,strong) OCJBaseTextField       *ocjTF_mobile;         ///< 联系方式
@property (nonatomic,strong) OCJBaseTextField       *ocjTF_name  ;         ///< 联系方式
@property (nonatomic,strong) OCJBaseTextView        *ocjtv_addDetail;      ///< 详细地址

@property (nonatomic, strong) NSString              *ocjStr_isDefault;     ///<是否是默认地址 0:否 1:是
@property (nonatomic, strong) NSMutableArray        *ocjArr_address;       ///<记录选择的地址信息

@end

@implementation OCJEditAddressVC

#pragma mark - 生命周期方法区域

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocj_setSelf];
}
#pragma mark - 私有方法区域

- (instancetype)initWithEditType:(OCJEditType)editType OCJManageAddressModel:(OCJAddressModel_listDesc *)model OCJShopAddressHandler:(OCJShopAddressHandler )handler{
    self = [super init];
    if (self) {
        self.ocjEnum_editType = editType;
        self.ocjBlock_handler = handler;
        self.ocjModel_address = model;
        self.ocjArr_address = [[NSMutableArray alloc] init];
    }
    return self;
}
#pragma mark - 接口方法实现区域(包括setter、getter方法)
- (NSMutableArray *)ocjArr_address {
    if (!_ocjArr_address) {
        _ocjArr_address = [[NSMutableArray alloc] init];
    }
    return _ocjArr_address;
}

- (void)ocj_setSelf {
  if (self.ocjEnum_editType == OCJEditType_edit) {
    self.ocjStr_trackPageID = @"AP1706C064";
  }else {
    self.ocjStr_trackPageID = @"AP1706C063";
  }
    self.title = self.ocjEnum_editType == OCJEditType_edit ? @"编辑收货地址" :@"新增收货地址";
    [self.view addSubview:self.ocjTableView];
    [self.ocjTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}
- (OCJBaseTableView *)ocjTableView{
    if (!_ocjTableView) {
        _ocjTableView = [[OCJBaseTableView alloc]init];
        _ocjTableView.backgroundColor = [UIColor colorWSHHFromHexString:@"ededed"];
        _ocjTableView.scrollEnabled = NO;
        _ocjTableView.dataSource = self;
        _ocjTableView.delegate   = self;
        _ocjTableView.tableFooterView = [[UIView alloc]init];
        _ocjTableView.tableHeaderView = [[UIView alloc]init];
      
    }
    return _ocjTableView;
}

/**
 返回
 */
- (void)ocj_back {
  if (self.ocjEnum_editType == OCJEditType_edit) {
    self.ocjStr_trackPageID = @"AP1706C064C005001C003001";
  }else {
    self.ocjStr_trackPageID = @"AP1706C063C005001C003001";
  }
  if (self.ocjBtn_confirm.userInteractionEnabled) {
    [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeNone title:@"" message:@"信息还未保存，确认现在返回吗？" sureButtonTitle:@"确定" CancelButtonTitle:@"取消" action:^(NSInteger clickIndex) {
      if (clickIndex == 1) {
        [super ocj_back];
      }else {
        
      }
    }];
  }else {
    [super ocj_back];
  }
}

/**
 点击保存按钮
 */
- (void)ocjSaveAction{
    
    if (![WSHHRegex wshh_isTelPhoneNumber:self.ocjTF_mobile.text]) {
        [OCJProgressHUD ocj_showHudWithTitle:@"请输入正确的手机号" andHideDelay:2.0];
        return;
    }
  
    if ([self.ocjtv_addDetail.text length] < 5) {
        [OCJProgressHUD ocj_showHudWithTitle:@"详细地址输入内容不得少于5个字" andHideDelay:2.0];
        return;
    }
  if (self.ocjEnum_editType == OCJEditType_edit) {
    self.ocjStr_trackPageID = @"AP1706C064F008002O008001";
  }else {
    self.ocjStr_trackPageID = @"AP1706C063F008001O008001";
  }
    if (self.ocjEnum_editType == OCJEditType_edit) {//修改地址
        [OCJHttp_addressControlAPI ocjAddress_changeAddressWithAddressID:self.ocjModel_address.ocjStr_addressID receiver:self.ocjTF_name.text phone:self.ocjTF_mobile.text mobile:self.ocjTF_mobile.text province:self.ocjModel_address.ocjStr_provinceCode city:self.ocjModel_address.ocjStr_cityCode strict:self.ocjModel_address.ocjStr_districtCode streetAddr:self.ocjtv_addDetail.text isDefaultAddr:self.ocjStr_isDefault completionHandler:^(OCJBaseResponceModel *responseModel) {
            
            if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"OCJRefreshAddressNOTI" object:nil];
              [self.navigationController popViewControllerAnimated:YES];
                [OCJProgressHUD ocj_showHudWithTitle:@"修改成功" andHideDelay:2.0];
            }
        }];
    }else if (self.ocjEnum_editType == OCJEditType_add) {//新增地址
        [OCJHttp_addressControlAPI ocjAddress_addNewAddressWithCustNO:self.ocjStr_custno isDefaultAddr:self.ocjStr_isDefault receiver:self.ocjTF_name.text phone:self.ocjTF_mobile.text mobile:self.ocjTF_mobile.text province:self.ocjModel_address.ocjStr_provinceCode city:self.ocjModel_address.ocjStr_cityCode strict:self.ocjModel_address.ocjStr_districtCode streetAddr:self.ocjtv_addDetail.text completionHandler:^(OCJBaseResponceModel *responseModel) {
            
          if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OCJRefreshAddressNOTI" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
            [OCJProgressHUD ocj_showHudWithTitle:@"保存成功" andHideDelay:1.0];
          }
        }];
    }
  
}

- (void)ocj_textFieldValueChanged {
    if ([self.ocjTF_name.text length] > 0 && [self.ocjTF_mobile.text length] > 0 && ![self.ocjLab_address.text isEqualToString:@"请选择地址"] && [self.ocjtv_addDetail.text length] > 0) {
        self.ocjBtn_confirm.alpha = 1.0;
        self.ocjBtn_confirm.userInteractionEnabled = YES;
    }else {
        self.ocjBtn_confirm.alpha = 0.2;
        self.ocjBtn_confirm.userInteractionEnabled = NO;
    }
}

/**
 点击设置默认地址按钮
 */
- (void)switchDefaultAddress:(BOOL)selected{
    if (selected) {
        OCJLog(@"设置默认地址");
        self.ocjStr_isDefault = @"1";
    }else{
        OCJLog(@"不设置默认地址");
        self.ocjStr_isDefault = @"0";
    }
}

/**
 删除地址
 */
- (void)ocj_deleteAddress {
  __weak OCJEditAddressVC *weakSelf = self;
  [self ocj_trackEventID:@"AP1706C064F008001O008001" parmas:nil];
  [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeNone title:@"" message:@"确定删除该地址吗？" sureButtonTitle:@"确定" CancelButtonTitle:@"取消" action:^(NSInteger clickIndex) {
    if (clickIndex == 1) {
      [OCJHttp_addressControlAPI ocjAddress_deleteAddressWithAddressID:self.ocjModel_address.ocjStr_addressID completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          if (weakSelf.ocjBlock_handler) {
            weakSelf.ocjBlock_handler();
          }
          [weakSelf.navigationController popViewControllerAnimated:YES];
          [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
      }];
    }else {
      
    }
  }];
  
}

/**
 设置默认地址cell
 */
- (OCJEditBottomTVCell *)ocj_addSetDefaultAddressCell {
    static NSString *cellIdentifier = @"OCJEditBottomTVCellIdentifier";
    OCJEditBottomTVCell * cell = [[OCJEditBottomTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];;
    if (!cell) {
        cell = [[OCJEditBottomTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    __weak OCJEditAddressVC *weakself = self;
    
    if ([self.ocjModel_address.ocjStr_isDefault isEqualToString:@"1"]) {
        cell.ocjSwitch.on = YES;
        self.ocjStr_isDefault = @"1";
    }else {
        cell.ocjSwitch.on = NO;
        self.ocjStr_isDefault = @"0";
    }
    
    cell.switchHandler = ^(BOOL isOn) {
        [weakself switchDefaultAddress:isOn];
    };
    
    return cell;
}

/**
 保存地址/删除地址cell
 */
- (UITableViewCell *)ocj_addSaveAddressCell {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWSHHFromHexString:@"ededed"];
    
    if (self.ocjEnum_editType == OCJEditType_add) {
        self.ocjBtn_confirm = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH - 40, 45)];
    }else if (self.ocjEnum_editType == OCJEditType_edit) {
  
        OCJBaseButton *ocjbtn_delete = [[OCJBaseButton alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 43)];
        ocjbtn_delete.backgroundColor = OCJ_COLOR_BACKGROUND;
        [ocjbtn_delete setTitle:@"删除地址" forState:UIControlStateNormal];
        [ocjbtn_delete setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
        ocjbtn_delete.titleEdgeInsets = UIEdgeInsetsMake(0, -SCREEN_WIDTH + 90, 0, 0);
        ocjbtn_delete.titleLabel.font = [UIFont systemFontOfSize:14];
        [ocjbtn_delete addTarget:self action:@selector(ocj_deleteAddress) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:ocjbtn_delete];
        
        self.ocjBtn_confirm = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 83, SCREEN_WIDTH - 40, 45)];
    }

    [self.ocjBtn_confirm setTitle:@"保存地址" forState:UIControlStateNormal];
    [self.ocjBtn_confirm ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [self.ocjBtn_confirm setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    self.ocjBtn_confirm.ocjFont = [UIFont systemFontOfSize:17];
    self.ocjBtn_confirm.layer.cornerRadius = 2;
    
    if (self.ocjModel_address != nil) {
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

#pragma mark - 协议方法实现区域
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( indexPath.row == 4) {
        return 70;
    }else if (indexPath.row == 3){
        return 64;
    }else if (indexPath.row == 5) {
        return 128;
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
  
    if (indexPath.row == 0) {
        cell.ocjLab_tip.text = @"收货人:";
        cell.ocjTF_input.placeholder = @"收货人";
        cell.ocjTF_input.keyboardType = UIKeyboardTypeDefault;
        if (self.ocjModel_address != nil) {
            cell.ocjTF_input.text = self.ocjModel_address.ocjStr_receiverName;
        }

        self.ocjTF_name = cell.ocjTF_input;
        [self.ocjTF_name addTarget:self action:@selector(ocj_textFieldValueChanged) forControlEvents:UIControlEventEditingChanged];
    }else if (indexPath.row ==1){
        cell.ocjLab_tip.text = @"联系方式:";
        cell.ocjTF_input.placeholder = @"联系方式";
        cell.ocjTF_input.keyboardType = UIKeyboardTypeNumberPad;
        
        if (self.ocjModel_address != nil) {
            cell.ocjTF_input.text = [NSString stringWithFormat:@"%@%@%@", self.ocjModel_address.ocjStr_mobile1, self.ocjModel_address.ocjStr_mobile2, self.ocjModel_address.ocjStr_mobile3];
        }
        
        self.ocjTF_mobile = cell.ocjTF_input;
        self.ocjTF_mobile.delegate = self;
        [self.ocjTF_mobile addTarget:self action:@selector(ocj_textFieldValueChanged) forControlEvents:UIControlEventEditingChanged];
    }else if(indexPath.row == 2){
        
        static NSString *cellIdentifier = @"OCJEditAddressSelectedTVCellIdentifier";
        OCJEditAddressSelectedTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[OCJEditAddressSelectedTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
         cell.ocjLab_tip.text = @"所在地区:";
         self.ocjLab_address = cell.ocjLab_cityLabel;
        
        if (self.ocjModel_address != nil) {
            self.ocjLab_address.text = self.ocjModel_address.ocjStr_addrProCity;
          self.ocjLab_address.textColor = OCJ_COLOR_DARK_GRAY;
        }else {
            self.ocjLab_address.text = @"请选择地址";
          self.ocjLab_address.textColor = OCJ_COLOR_LIGHT_GRAY;
        }
        
        return cell;
    }else if(indexPath.row == 3){//OCJEditMiddleTVCell
        cell.ocjLab_tip.text = @"详细地址：";
        static NSString *cellIdentifier = @"OCJEditMiddleTVCellIdentifier";
        OCJEditMiddleTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[OCJEditMiddleTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        self.ocjtv_addDetail = cell.ocjTV_city;
      self.ocjtv_addDetail.textAlignment = NSTextAlignmentRight;
        self.ocjtv_addDetail.delegate = self;
        if (self.ocjModel_address != nil) {
            self.ocjtv_addDetail.text = self.ocjModel_address.ocjStr_addrDetail;
        }

        return cell;
        
    }
//    //新增地址时不能设置默认地址
//    if (self.ocjEnum_editType == OCJEditType_add) {
//        if(indexPath.row == 4){
//            UITableViewCell *cell = [self ocj_addSaveAddressCell];
//            return cell;
//        }
//    }else if (self.ocjEnum_editType == OCJEditType_edit) {
        if(indexPath.row == 4){
            OCJEditBottomTVCell * cell = [self ocj_addSetDefaultAddressCell];
            return cell;
        }else if (indexPath.row == 5) {
            UITableViewCell *cell = [self ocj_addSaveAddressCell];
            return cell;
        }
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
      if (self.ocjEnum_editType == OCJEditType_edit) {
        self.ocjStr_trackPageID = @"AP1706C064D010001C010001";
      }else {
        self.ocjStr_trackPageID = @"AP1706C063D010001C010001";
      }
        [OCJAddressSheetView ocj_popAddressSheetCompletion:^(NSDictionary *dic_address) {
            
            NSString *city = [dic_address objectForKey:@"city"];
            NSString *district = [dic_address objectForKey:@"district"];
            NSString *province = [dic_address objectForKey:@"provenice"];
          
            NSString *addressStr;
            if (!self.ocjModel_address) {
                self.ocjModel_address = [[OCJAddressModel_listDesc alloc] init];
            }
          
            self.ocjModel_address.ocjStr_provinceCode = [dic_address objectForKey:@"proveniceCode"];
            self.ocjModel_address.ocjStr_cityCode = [dic_address objectForKey:@"cityCode"];
            self.ocjModel_address.ocjStr_districtCode = [dic_address objectForKey:@"districtCode"];
            
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.ocjTF_mobile) {
        if (str.length > 11) {
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self ocj_textFieldValueChanged];
}

@end
