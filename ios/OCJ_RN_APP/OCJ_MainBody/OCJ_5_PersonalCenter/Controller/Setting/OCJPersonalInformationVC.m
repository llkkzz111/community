//
//  OCJPersonalInformationVC.m
//  OCJ
//
//  Created by Ray on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJPersonalInformationVC.h"
#import "OCJBaseTableView.h"
#import "OCJPersonalInfoCell.h"
#import "OCJDatePickerView.h"
#import "OCJModifyMobileVC.h"
#import "OCJModifyNickNameVC.h"
#import "OCJModifyEmailPwdVC.h"
#import "OCJHttp_personalInfoAPI.h"
#import "UIImageView+WebCache.h"
#import "OCJEditDefaultAddressVC.h"
#import "OCJHttp_addressControlAPI.h"


@interface OCJPersonalInformationVC ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *ocjView_nav;///<导航视图

@property (nonatomic, strong) UIImageView *ocjImgView_portrait;///<头像

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_personal;///<tableView
@property (nonatomic, strong) NSArray *ocjArr_dataSource;///<数据源

@property (nonatomic, strong) OCJBaseLabel *ocjLab_date;///<生日

@end

@implementation OCJPersonalInformationVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  if (self.ocjModel_memberInfo==NULL) {
    [self ocj_loginedAndLoadNetWorkData];
  }
  
    [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 私有方法区域
- (void)ocj_loginedAndLoadNetWorkData{
    [self ocj_requestMemberInfo:nil];
}

- (void)ocj_setSelf {
  self.ocjStr_trackPageID = @"AP1706C056";
  self.title = @"个人资料";
    self.ocjArr_dataSource = @[@[@"头像",@"昵称",@"用户名"],@[@"默认地址"],@[@"邮箱",@"手机号",@"生日"]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocj_reloadMemberInfo) name:OCJ_Notification_personalCenter object:nil];
    [self ocj_addTableView];
}

- (void)ocj_reloadMemberInfo {
  [self ocj_requestMemberInfo:nil];
}

/**
 请求数据
 */
- (void)ocj_requestMemberInfo:(void(^)())completion {
    [OCJHttp_personalInfoAPI ocjPersonal_checkMenberInfoCompletionHandler:^(OCJBaseResponceModel *responseModel) {
        self.ocjModel_memberInfo = (OCJPersonalModel_memberInfo *)responseModel;
        
        [self.ocjTBView_personal reloadData];
    }];
}

/**
 导航
 */
- (void)ocj_addNavView {
    self.ocjView_nav = [[UIView alloc] init];
    self.ocjView_nav.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.ocjView_nav];
    [self.ocjView_nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(180);
    }];
    
    OCJBaseButton * ocjBtn_back = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [ocjBtn_back addTarget:self action:@selector(ocj_back) forControlEvents:UIControlEventTouchUpInside];
    [ocjBtn_back setImage:[UIImage imageNamed:@"naviBackImage"] forState:UIControlStateNormal];
    [self.ocjView_nav addSubview:ocjBtn_back];
    [ocjBtn_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_ocjView_nav).offset(0);
        make.top.mas_equalTo(_ocjView_nav).offset(20);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    OCJBaseLabel * ocjLb_title = [[OCJBaseLabel alloc]init];
    ocjLb_title.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    ocjLb_title.font = [UIFont systemFontOfSize:17];
    ocjLb_title.text = @"个人信息";
    ocjLb_title.textAlignment = NSTextAlignmentCenter;
    [self.ocjView_nav addSubview:ocjLb_title];
    [ocjLb_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(24);
        make.centerX.mas_equalTo(_ocjView_nav.mas_centerX);
        make.top.mas_equalTo(_ocjView_nav).offset(29);
    }];
    
    self.ocjImgView_portrait = [[UIImageView alloc] init];
    self.ocjImgView_portrait.layer.cornerRadius = 30;
    self.ocjImgView_portrait.backgroundColor = [UIColor lightGrayColor];
    self.ocjImgView_portrait.layer.borderWidth = 3;
    self.ocjImgView_portrait.layer.borderColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"].CGColor;
    [self.ocjView_nav addSubview:self.ocjImgView_portrait];
    [self.ocjImgView_portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjView_nav);
        make.top.mas_equalTo(ocjLb_title.mas_bottom).offset(27);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@60);
    }];
}

/**
 tableView
 */
- (void)ocj_addTableView {
    self.ocjTBView_personal = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.ocjTBView_personal.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    self.ocjTBView_personal.delegate = self;
    self.ocjTBView_personal.dataSource = self;
    self.ocjTBView_personal.tableFooterView = [[UIView alloc] init];
    self.ocjTBView_personal.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.ocjTBView_personal];
}

/**
 头像cell
 */
- (void)ocj_addHeadPortraitCell:(UITableViewCell *)cell {
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [cell.contentView addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
        make.right.mas_equalTo(cell.mas_right).offset(0);
        make.bottom.mas_equalTo(cell.contentView);
        make.height.mas_equalTo(@0.5);
    }];
    //头像imageView
    self.ocjImgView_portrait = [[UIImageView alloc] init];
    [self.ocjImgView_portrait ocj_setWebImageWithURLString:self.ocjModel_memberInfo.ocjStr_headPortrait placeHolderImage:[UIImage imageNamed:@"Icon_user_"] hideLoading:NO completion:nil];
    self.ocjImgView_portrait.layer.masksToBounds = YES;
    self.ocjImgView_portrait.layer.cornerRadius = 25;
    [cell.contentView addSubview:self.ocjImgView_portrait];
    [self.ocjImgView_portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(@50);
        make.width.mas_equalTo(@50);
    }];
    
    OCJBaseLabel *ocjLab_title = [[OCJBaseLabel alloc] init];
    ocjLab_title.textColor = OCJ_COLOR_DARK;
    ocjLab_title.font = [UIFont systemFontOfSize:14];
    ocjLab_title.text = @"头像";
    ocjLab_title.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(cell.contentView);
        make.right.mas_equalTo(self.ocjImgView_portrait.mas_left).offset(-10);
        make.height.mas_equalTo(@22);
    }];
}

/**
 用户名cell
 */
- (void)ocj_addUsernameCell:(UITableViewCell *)cell {
    OCJBaseLabel *ocjLab_info = [[OCJBaseLabel alloc] init];
    ocjLab_info.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_info.font = [UIFont systemFontOfSize:14];
    ocjLab_info.textAlignment = NSTextAlignmentRight;
    ocjLab_info.text = self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_userName;
    [cell.contentView addSubview:ocjLab_info];
    [ocjLab_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell.contentView);
        make.right.mas_equalTo(cell.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@20);
    }];
    
    OCJBaseLabel *ocjLab_title = [[OCJBaseLabel alloc] init];
    ocjLab_title.textColor = OCJ_COLOR_DARK;
    ocjLab_title.font = [UIFont systemFontOfSize:14];
    ocjLab_title.text = @"用户名";
    ocjLab_title.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(cell.contentView);
        make.right.mas_equalTo(ocjLab_info.mas_left).offset(-10);
        make.height.mas_equalTo(@22);
    }];
}

/**
 默认地址cell
 */
- (void)ocj_addDefaultAddress:(UITableViewCell *)cell{
  
  OCJBaseLabel *ocjLab_title = [[OCJBaseLabel alloc] init];
  ocjLab_title.textColor = OCJ_COLOR_DARK;
  ocjLab_title.font = [UIFont systemFontOfSize:14];
  ocjLab_title.text = @"默认地址";
  ocjLab_title.textAlignment = NSTextAlignmentLeft;
  [ocjLab_title setBackgroundColor:[UIColor clearColor]];
  [cell.contentView addSubview:ocjLab_title];
  [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
    make.top.mas_equalTo(cell.contentView.mas_top).offset(15);
    make.height.mas_equalTo(@22);
    make.width.mas_equalTo(@70);
    
  }];
  
  OCJBaseLabel *ocjLab_province = [[OCJBaseLabel alloc] init];
  ocjLab_province.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_province.font = [UIFont systemFontOfSize:14];
  ocjLab_province.textAlignment = NSTextAlignmentRight;
  if (self.ocjModel_memberInfo.ocjModel_AdressDesc != nil) {
      NSString *addressStr = [NSString stringWithFormat:@"%@ %@ %@", self.ocjModel_memberInfo.ocjModel_AdressDesc.ocjStr_provinceName, self.ocjModel_memberInfo.ocjModel_AdressDesc.ocjStr_cityName, self.ocjModel_memberInfo.ocjModel_AdressDesc.ocjStr_areaName];
      ocjLab_province.text = addressStr;
  }
  else
  {
      ocjLab_province.text = @"";
  }
  [cell.contentView addSubview:ocjLab_province];
  [ocjLab_province mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(cell.contentView.mas_top).offset(15);
    make.right.mas_equalTo(cell.mas_right).offset(-38);
    make.height.mas_equalTo(@20);
    make.left.mas_greaterThanOrEqualTo(ocjLab_title.mas_right).offset(10);
  }];
  
  OCJBaseLabel *ocjLab_adredd = [[OCJBaseLabel alloc] init];
  ocjLab_adredd.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_adredd.font = [UIFont systemFontOfSize:14];
  ocjLab_adredd.textAlignment = NSTextAlignmentRight;
  ocjLab_adredd.numberOfLines = 0;
  if (self.ocjModel_memberInfo.ocjModel_AdressDesc != nil) {
    ocjLab_adredd.text = self.ocjModel_memberInfo.ocjModel_AdressDesc.ocjStr_addr;
  }
  else
  {
    ocjLab_adredd.text = @"";
  }
  [cell.contentView addSubview:ocjLab_adredd];
  [ocjLab_adredd mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.mas_equalTo(cell.contentView.mas_bottom).offset(-15);
    make.right.mas_equalTo(cell.mas_right).offset(-38);
    make.height.mas_equalTo(@20);
    make.left.mas_greaterThanOrEqualTo(ocjLab_title.mas_right).offset(10);
  }];


}

/**
 将日期字符转转换成指定格式
 */
- (NSString *)ocj_getNewStringWithString:(NSString *)oldStr {
    NSString *newStr;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *dateString = [formatter dateFromString:oldStr];
    
    [formatter setDateFormat:@"yyyyMMdd"];
    newStr = [formatter stringFromDate:dateString];
    
    return newStr;
}

/**
 点击头像事件
 */
- (void)ocj_clickedPortraitBtn {
    __weak OCJPersonalInformationVC *weakSelf = self;
    UIAlertController *ocjAlert_ctrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [ocjAlert_ctrl addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //允许编辑，即放大裁剪
        pickerImage.allowsEditing = YES;
        pickerImage.delegate = self;
        [weakSelf presentViewController:pickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [ocjAlert_ctrl addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        //获取方式:通过相机
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.allowsEditing = YES;
        pickerImage.delegate = self;
        [weakSelf presentViewController:pickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [ocjAlert_ctrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:ocjAlert_ctrl animated:YES completion:nil];
}

- (void)ocj_back {
  [self ocj_trackEventID:@"AP1706C056D003001C003001" parmas:nil];
  [super ocj_back];
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ocjArr_dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.ocjArr_dataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"OCJPersonalInfoCell";
    OCJPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    [self ocj_addHeadPortraitCell:cell];
                    
                    return cell;
                }
                    break;
                case 1:{
                    cell = [[OCJPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    [cell ocj_setInformationWithTitle:[[self.ocjArr_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
                    cell.ocjLab_info.text = self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_nickName;
                    
                    return cell;
                }
                    break;
                case 2:{
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    [self ocj_addUsernameCell:cell];
                    
                    return cell;
                }
                    break;
            }
        }
            break;
        case 1:
        {
          UITableViewCell *cell = [[UITableViewCell alloc] init];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
          [self ocj_addDefaultAddress:cell];
          
          return cell;
        }
        break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    cell = [[OCJPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    [cell ocj_setInformationWithTitle:[[self.ocjArr_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
                    if (self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_email1 != nil && ![self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_email1 isEqualToString:@""]) {
                        cell.ocjLab_info.text = [NSString stringWithFormat:@"%@@%@", self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_email1, self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_email2];
                    }
                    
                    return cell;
                }
                    break;
                case 1:{
                    cell = [[OCJPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    [cell ocj_setInformationWithTitle:[[self.ocjArr_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
                    cell.ocjLab_info.text = [NSString stringWithFormat:@"%@%@%@%@", self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_mobile, self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_mobile1, self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_mobile2, self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_mobile3];
                    
                    return cell;
                }
                    break;
                case 2:{
                    cell = [[OCJPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
                    [cell ocj_setInformationWithTitle:[[self.ocjArr_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
                    if (self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_birthYear != nil && ![self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_birthYear isEqualToString:@""]) {
                        cell.ocjLab_info.text = [NSString stringWithFormat:@"%@.%@.%@", self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_birthYear, self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_birthMonth, self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_birthDay];
                        cell.userInteractionEnabled = NO;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    cell.ocjView_line.hidden = YES;
                    self.ocjLab_date = cell.ocjLab_info;
                    
                    return cell;
                }
                    break;
            }
        }
            break;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80;
        }
    }
    else if (indexPath.section == 1)
    {
      return 70;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak OCJPersonalInformationVC *weakSelf = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//修改头像
          [self ocj_trackEventID:@"AP1706C056F010001A001001" parmas:nil];
            [self ocj_clickedPortraitBtn];
        }else if (indexPath.row == 1) {//昵称
          [self ocj_trackEventID:@"AP1706C056F010002A001001" parmas:nil];
            OCJModifyNickNameVC *nickNameVC = [[OCJModifyNickNameVC alloc] init];
            nickNameVC.ocjModifyNickNameBlock = ^(NSString *ocjStr_nickName) {
                //修改昵称回来后重新加载数据
                 [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notification_personalCenter object:nil userInfo:@{}];
            };
            [self ocj_pushVC:nickNameVC];
        }else {
            OCJLog(@"用户名");
        }
    }
    else if (indexPath.section == 1)
    {
      OCJEditDefaultAddressVC *editDefaultAdressVC = [[OCJEditDefaultAddressVC alloc] initWithAddressModel:self.ocjModel_memberInfo.ocjModel_AdressDesc];
      [self ocj_pushVC:editDefaultAdressVC];
    }
    else {
        if (indexPath.row == 0) {//邮箱
          [self ocj_trackEventID:@"AP1706C056F010003A001001" parmas:nil];
            OCJModifyEmailPwdVC *emailVC = [[OCJModifyEmailPwdVC alloc] init];
            emailVC.ocjModifyEmailBlock = ^(NSString *ocjStr_Email) {
                //修改邮箱回来后重新加载数据
                 [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notification_personalCenter object:nil userInfo:@{}];
            };
            emailVC.ocjStr_nickName = self.ocjModel_memberInfo.ocjModel_memberDesc.ocjStr_nickName;
            [self ocj_pushVC:emailVC];
            
        }else if (indexPath.row == 1) {//修改手机号
            [self ocj_trackEventID:@"AP1706C056F010004A001001" parmas:nil];
            OCJModifyMobileVC *modifyMobileVC = [[OCJModifyMobileVC alloc] init];
            modifyMobileVC.ocjModifyMobileBlock = ^(NSString *newMobile) {
                //更改手机号后回来重新加载数据
              [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notification_personalCenter object:nil userInfo:@{}];
            };
            [self ocj_pushVC:modifyMobileVC];
        }else {//生日
            [self ocj_trackEventID:@"AP1706C056F010005A001001" parmas:nil];
            [OCJDatePickerView ocj_popDatePickerCompletionHandler:^(NSString *dateStr) {
                
                NSString *newStr = [weakSelf ocj_getNewStringWithString:dateStr];
                [OCJHttp_personalInfoAPI ocjPersonal_changeBirthdayWithDate:newStr completionHandler:^(OCJBaseResponceModel *responseModel) {
                    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
                      [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notification_personalCenter object:nil userInfo:@{}];
                    }
                }];
            }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *data = UIImageJPEGRepresentation(newPhoto, 0.1);
    __weak OCJPersonalInformationVC *weakSelf = self;
    [OCJHttp_personalInfoAPI ocjPersonal_changePortraitWithFile:data completionHandler:^(OCJBaseResponceModel *responseModel) {
//        weakSelf.ocjImgView_portrait.image = [UIImage imageWithData:data];
//        weakSelf.ocjImgView_portrait.image = newPhoto;
        [picker dismissViewControllerAnimated:YES completion:nil];
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
           [[NSNotificationCenter defaultCenter] postNotificationName:OCJ_Notification_personalCenter object:nil userInfo:@{}];
        }
    }];
    
}

@end

