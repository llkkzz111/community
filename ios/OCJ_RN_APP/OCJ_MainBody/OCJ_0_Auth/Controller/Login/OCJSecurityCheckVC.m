//
//  OCJSecurityCheckVC.m
//  OCJ
//
//  Created by LZB on 2017/4/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSecurityCheckVC.h"
#import "OCJSecurityGoodsView.h"
#import "OCJBaseButton+OCJExtension.h"
#import "OCJAddressSheetView.h"
#import "OCJBindingPhoneNumberVC.h"
#import "OCJLoginModel.h"
#import "OCJHttp_authAPI.h"

@interface OCJSecurityCheckVC ()<UIScrollViewDelegate, OCJSOCJSecurityGoodsViewDelegate>

@property (nonatomic, strong) UIScrollView *ocjScrollView_main;

@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;///<确认按钮

@property (nonatomic, strong) UIView *ocjView_selectUser;///<选择历史收货人

@property (nonatomic, strong) UIView *ocjView_selectAddress;///<收货地址

@property (nonatomic, strong) UIView *ocjView_selectGoods;///<选择最近购买过的商品

@property (nonatomic, strong) NSString *ocjStr_selectUser;///<选中的用户名

@property (nonatomic, strong) OCJBaseLabel *ocjLab_selectedAddr;///<选中的地址

@property (nonatomic, strong) OCJBaseButton *ocjBtn_lastSelected;///<用来记录选中的用户

@property (nonatomic, strong) UIView *ocjView_showGoods;///<展示所有商品的view

@property (nonatomic, assign) NSInteger ocjInt_scrollContentHeight;///<scrollviewContentHeight

@property (nonatomic, strong) NSMutableArray *ocjArr_showGoodsView;///<用来存储展示商品的view的数组

@property (nonatomic, strong) OCJSecurityGoodsView *ocjView_last;///<用来存储点击过的商品

@property (nonatomic, strong) UIImageView *ocjImgView_userSelected;///<选中用户时显示

@property (nonatomic, strong) OCJAuthModel_HistoryGoods* model;///<历史商品model

@property (nonatomic,copy) NSString* ocjStr_address; ///< 存储选中地址编码的拼接字符串

@property (nonatomic, strong) OCJBaseTextField *ocjTF_name;///<输入历史收件人姓名

@end

@implementation OCJSecurityCheckVC

#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
}

#pragma mark - 私有方法区域
-(void)ocj_back{
  [super ocj_back];
  
  [self ocj_trackEventID:@"AP1706C012D003001C003001" parmas:nil];
}

- (void)ocj_setSelf{
    self.title = @"安全校验";
  
    self.ocjStr_trackPageID = @"AP1706C012";
  
    self.ocjInt_scrollContentHeight = 0;
    
    [self addViews];
    
    [self ocj_getNetworkData];
}

- (void)ocj_getNetworkData{
    
    [OCJHttp_authAPI ocjAuth_checkHistoryGoodsWithMemberID:self.ocjStr_memberID completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJAuthModel_HistoryGoods* model = (OCJAuthModel_HistoryGoods*)responseModel;
        self.model = model;
        
        if ([model.ocjStr_code isEqualToString:@"200"]) {
            
            [self ocj_showGoodsReloadData:model.ocjArr_items];
            
        }else if([model.ocjStr_code isEqualToString:@"1020100501"] || [model.ocjStr_code isEqualToString:@"1020100502"]){
            [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeFailure title:model.ocjStr_message message:nil sureButtonTitle:@"联系客服" CancelButtonTitle:@"取消" action:^(NSInteger clickIndex) {
                [self.navigationController popViewControllerAnimated:YES];
                
                if (clickIndex==1) {
                    //联系客服code
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://400-889-8000"]]) {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://400-889-8000"]];
                    }
                }
                
            }];
        }
    }];
}

#pragma mark - 添加视图
- (void)addViews {
    [self ocj_addScrollView];
    [self ocj_addSelectUserView];
    [self ocj_addSelectAddressView];
    [self ocj_addSelectGoodsView];
    [self ocj_addConfirmBtn];
    
    self.ocjScrollView_main.contentSize = CGSizeMake(SCREEN_WIDTH, _ocjInt_scrollContentHeight);
}

//添加底部scrollView
- (void)ocj_addScrollView {
    self.ocjScrollView_main = [[UIScrollView alloc] init];
    self.ocjScrollView_main.backgroundColor = [UIColor colorWSHHFromHexString:@"EEEEEE"];
    self.ocjScrollView_main.showsHorizontalScrollIndicator = NO;
    self.ocjScrollView_main.showsVerticalScrollIndicator = NO;
    self.ocjScrollView_main.userInteractionEnabled = YES;
    self.ocjScrollView_main.delegate = self;
    [self.view addSubview:self.ocjScrollView_main];
    [self.ocjScrollView_main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.view);
    }];
}

//请选择历史收货人姓名
- (void) ocj_addSelectUserView {
    self.ocjView_selectUser = [[UIView alloc] init];
    self.ocjView_selectUser.backgroundColor = [UIColor whiteColor];
    [self.ocjScrollView_main addSubview:self.ocjView_selectUser];
    [self.ocjView_selectUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.ocjScrollView_main);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(@60);
    }];
    self.ocjInt_scrollContentHeight += 60;
    
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [self.ocjView_selectUser addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_selectUser.mas_left).offset(15);
        make.right.mas_equalTo(self.ocjView_selectUser.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.ocjView_selectUser.mas_bottom).offset(-13);
        make.height.mas_equalTo(@0.5);
    }];
    
    OCJBaseLabel *ocjLab_selectUser = [[OCJBaseLabel alloc] init];
    ocjLab_selectUser.textAlignment = NSTextAlignmentLeft;
    ocjLab_selectUser.numberOfLines = 1;
    ocjLab_selectUser.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_selectUser.font = [UIFont systemFontOfSize:17];
    ocjLab_selectUser.text = @"姓名";
    [self.ocjView_selectUser addSubview:ocjLab_selectUser];
    [ocjLab_selectUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ocjView_selectUser);
        make.left.mas_equalTo(self.ocjView_selectUser.mas_left).offset(15);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@24);
    }];
    
    self.ocjTF_name = [[OCJBaseTextField alloc] init];
    self.ocjTF_name.placeholder = @"请输入历史收货人姓名";
    self.ocjTF_name.font = [UIFont systemFontOfSize:15];
    self.ocjTF_name.textColor = OCJ_COLOR_LIGHT_GRAY;
    self.ocjTF_name.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ocjTF_name.tintColor = [UIColor redColor];
    self.ocjTF_name.textAlignment = NSTextAlignmentRight;
    [self.ocjView_selectUser addSubview:self.ocjTF_name];
    [self.ocjTF_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ocjView_line.mas_right).offset(0);
        make.centerY.mas_equalTo(self.ocjView_selectUser);
        make.height.mas_equalTo(@30);
        make.left.mas_equalTo(ocjLab_selectUser.mas_right).offset(10);
    }];
}

//最近收货地址
- (void)ocj_addSelectAddressView {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tappedSelectedAddressView)];
    
    self.ocjView_selectAddress = [[UIView alloc] init];
    self.ocjView_selectAddress.backgroundColor = [UIColor whiteColor];
    [self.ocjView_selectAddress addGestureRecognizer:tap];
    [self.ocjScrollView_main addSubview:self.ocjView_selectAddress];
    [self.ocjView_selectAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.ocjView_selectUser.mas_bottom).offset(10);
        make.height.mas_equalTo(@54);
    }];
    self.ocjInt_scrollContentHeight += 64;
    
    OCJBaseLabel *ocjLab_address = [[OCJBaseLabel alloc] init];
    ocjLab_address.textAlignment = NSTextAlignmentLeft;
    ocjLab_address.numberOfLines = 1;
    ocjLab_address.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_address.font = [UIFont systemFontOfSize:17];
    ocjLab_address.text = @"最近收货地址";
    [self.ocjView_selectAddress addSubview:ocjLab_address];
    [ocjLab_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ocjView_selectAddress);
        make.left.mas_equalTo(self.ocjView_selectAddress.mas_left).offset(15);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(@112);
    }];
    
    UIImageView *ocjImgView = [[UIImageView alloc] init];
    ocjImgView.image = [UIImage imageNamed:@"arrow"];
    [self.ocjView_selectAddress addSubview:ocjImgView];
    [ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjView_selectAddress.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.ocjView_selectAddress);
        make.width.mas_equalTo(@8);
        make.height.mas_equalTo(@12);
    }];
    
    self.ocjLab_selectedAddr = [[OCJBaseLabel alloc] init];
    self.ocjLab_selectedAddr.textAlignment = NSTextAlignmentRight;
    self.ocjLab_selectedAddr.numberOfLines = 1;
    self.ocjLab_selectedAddr.textColor = OCJ_COLOR_DARK;
    self.ocjLab_selectedAddr.font = [UIFont systemFontOfSize:17];
    self.ocjLab_selectedAddr.text = @"选择地区";
    [self.ocjView_selectAddress addSubview:self.ocjLab_selectedAddr];
    [self.ocjLab_selectedAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjLab_address.mas_right).offset(10);
        make.right.mas_equalTo(ocjImgView.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.ocjView_selectAddress);
        make.height.mas_equalTo(@24);
    }];
}

//请选择最近购买过的商品
- (void)ocj_addSelectGoodsView {
    self.ocjView_selectGoods = [[UIView alloc] init];
    self.ocjView_selectGoods.backgroundColor = [UIColor whiteColor];
    [self.ocjScrollView_main addSubview:self.ocjView_selectGoods];
    [self.ocjView_selectGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjView_selectAddress.mas_bottom).offset(10);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    //label
    OCJBaseLabel *ocjLab_goods = [[OCJBaseLabel alloc] init];
    ocjLab_goods.textAlignment = NSTextAlignmentLeft;
    ocjLab_goods.numberOfLines = 1;
    ocjLab_goods.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_goods.font = [UIFont systemFontOfSize:17];
    ocjLab_goods.text = @"请选择最近购买过的商品";
    [self.ocjView_selectGoods addSubview:ocjLab_goods];
    [ocjLab_goods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_selectGoods.mas_left).offset(15);
        make.top.mas_equalTo(self.ocjView_selectGoods.mas_top).offset(15);
        make.height.mas_equalTo(@24);
        make.width.mas_equalTo(@200);
    }];
    self.ocjInt_scrollContentHeight += 64;
    
    //换一批btn
    OCJBaseButton *ocjBtn_exchange = [[OCJBaseButton alloc] init];
    ocjBtn_exchange.backgroundColor = [UIColor whiteColor];
    [ocjBtn_exchange setTitle:@"换一批" forState:UIControlStateNormal];
    [ocjBtn_exchange setTitleColor:[UIColor colorWSHHFromHexString:@"3673F1"] forState:UIControlStateNormal];
    ocjBtn_exchange.ocjFont = [UIFont systemFontOfSize:16];
    [ocjBtn_exchange addTarget:self action:@selector(ocj_exchangeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_selectGoods addSubview:ocjBtn_exchange];
    [ocjBtn_exchange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjView_selectGoods.mas_right).offset(-10);
        make.top.mas_equalTo(self.ocjView_selectGoods.mas_top).offset(17);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@60);
    }];
    
    //线
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self.ocjView_selectGoods addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.ocjView_selectGoods);
        make.top.mas_equalTo(self.ocjView_selectGoods.mas_top).offset(54);
        make.height.mas_equalTo(@0.5);
    }];
    
    //showGoods
    self.ocjView_showGoods = [[UIView alloc] init];
    self.ocjView_showGoods.backgroundColor = [UIColor whiteColor];
    [self.ocjScrollView_main addSubview:self.ocjView_showGoods];
    [self.ocjView_showGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(ocjView_line.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.view);
    }];
    
    CGFloat ocj_space = 15;
    CGFloat ocj_viewWidth = (SCREEN_WIDTH - 15 * 4) / 3;
    CGFloat ocj_viewHeight = ocj_viewWidth + 26;
    for (int i = 0; i < 9; i++) {
        
        NSInteger row = i / 3;
        NSInteger col = i % 3;
        
        OCJSecurityGoodsView *ocj_goodsView = [[OCJSecurityGoodsView alloc] initWithFrame:CGRectMake(col * ocj_viewWidth + ocj_space * (col + 1), row * ocj_viewHeight + ocj_space * (row + 1), ocj_viewWidth, ocj_viewHeight)];
        ocj_goodsView.tag = i;
        ocj_goodsView.delegate = self;
        [ocj_goodsView ocj_loadData:nil];
        [self.ocjView_showGoods addSubview:ocj_goodsView];
        [self.ocjArr_showGoodsView addObject:ocj_goodsView];
    }
    self.ocjInt_scrollContentHeight += ocj_space * 4 + ocj_viewHeight * 3 + 64;
}

//懒加载
- (NSMutableArray *)ocjArr_showGoodsView {
    if (!_ocjArr_showGoodsView) {
        _ocjArr_showGoodsView = [[NSMutableArray alloc] init];
    }
    return _ocjArr_showGoodsView;
}

//确认按钮
- (void)ocj_addConfirmBtn {
    self.ocjBtn_confirm = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    self.ocjBtn_confirm.frame = CGRectMake(20, SCREEN_HEIGHT - 28 - 45 - 64, SCREEN_WIDTH - 40, 45);
    self.ocjBtn_confirm.backgroundColor = [UIColor redColor];
    [self.ocjBtn_confirm setTitle:@"确认" forState:UIControlStateNormal];
    self.ocjBtn_confirm.ocjFont = [UIFont systemFontOfSize:17];
    [self.ocjBtn_confirm setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [self.ocjBtn_confirm addTarget:self action:@selector(ocj_confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjBtn_confirm ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [self.view addSubview:self.ocjBtn_confirm];
    [self.view bringSubviewToFront:self.ocjBtn_confirm];
}

//点击换一批按钮更换图片
- (void)ocj_showGoodsReloadData:(NSArray *)dataArr {
    for (int i = 0; i < self.ocjArr_showGoodsView.count; i++) {
        OCJSecurityGoodsView *view = [self.ocjArr_showGoodsView objectAtIndex:i];
        view.ocj_isSelected = NO;
        view.ocjLab_name.textColor = OCJ_COLOR_DARK_GRAY;
        NSDictionary* dic = [dataArr objectAtIndex:i];
        NSString* imageUrlStr = @"";
        NSString* imageNameStr = @"";
        if([dic isKindOfClass:[NSDictionary class]]){
            imageUrlStr = dic[@"item_image"];
            imageNameStr = dic[@"item_name"];
        }
        
        [view.ocjImgView_goods ocj_setWebImageWithURLString:imageUrlStr completion:nil];
        view.ocjLab_name.text = imageNameStr;
    }
}

#pragma mark - btnClicked
//点击选择用户
- (void)ocj_usernameBtnClicked:(OCJBaseButton *)ocjBtn {
    if (ocjBtn == _ocjBtn_lastSelected) {
        _ocjStr_selectUser = ocjBtn.titleLabel.text;
    }else {
        _ocjBtn_lastSelected.backgroundColor = [UIColor colorWSHHFromHexString:@"EEEEEE"];
        [_ocjBtn_lastSelected setTitleColor:[UIColor colorWSHHFromHexString:@"444444"] forState:UIControlStateNormal];
        for (UIView *imgView in _ocjBtn_lastSelected.subviews) {
            if ([imgView isKindOfClass:[UIImageView class]]) {
                imgView.hidden = YES;
            }
        }
        
        ocjBtn.backgroundColor =[UIColor colorWSHHFromHexString:@"EAF0FD"];
        [ocjBtn setTitleColor:[UIColor colorWSHHFromHexString:@"3673F1"] forState:UIControlStateNormal];
        for (UIView *imgView in ocjBtn.subviews) {
            if ([imgView isKindOfClass:[UIImageView class]]) {
                imgView.hidden = NO;
            }
        }
        
        _ocjStr_selectUser = ocjBtn.titleLabel.text;
        _ocjBtn_lastSelected = ocjBtn;
    }
}
//点击换一批按钮
- (void)ocj_exchangeBtnClicked {
    [self.ocjTF_name resignFirstResponder];
  
    NSMutableString* itemCodesStr = [NSMutableString string];
    if (self.model.ocjArr_items.count>0) {
      for (NSDictionary* itemDic in self.model.ocjArr_items) {
        if ([itemDic isKindOfClass:[NSDictionary class]]) {
          NSString* itemID = itemDic[@"id"];
          if (itemID.length>0) {
            [itemCodesStr appendString:itemID];
          }
        }
      }
    }
  
    [self ocj_trackEventID:@"AP1706C012F010002A001001" parmas:@{@"itemcode":[itemCodesStr copy]}];
  
    //再次请求数据
    [OCJHttp_authAPI ocjAuth_checkHistoryGoodsWithMemberID:self.ocjStr_memberID completionHandler:^(OCJBaseResponceModel *responseModel) {
        OCJAuthModel_HistoryGoods* model = (OCJAuthModel_HistoryGoods*)responseModel;
        self.model = model;
        [self ocj_showGoodsReloadData:model.ocjArr_items];
    }];
}

//点击确认按钮
- (void)ocj_confirmBtnClicked {
    if (!(self.ocjStr_address.length > 0)) {
        [WSHHAlert wshh_showHudWithTitle:@"请选择正确的收获地址" andHideDelay:2];
        return;
    }
    
    NSString *goodsID;
    if (self.ocjView_last) {
        goodsID = [[self.model.ocjArr_items objectAtIndex:self.ocjView_last.tag] objectForKey:@"id"];
    }else {
        [OCJProgressHUD ocj_showHudWithTitle:@"请选择最近购买过的商品" andHideDelay:2.0];
        return;
    }
    
    NSString *userName = self.ocjTF_name.text;
    if (!(userName.length>0)) {
        [WSHHAlert wshh_showHudWithTitle:@"请输入正确的历史收货人姓名" andHideDelay:2];
        return;
    }
  
  
    [self ocj_trackEventID:@"AP1706C012F008001O008001" parmas:nil];
  
    [OCJHttp_authAPI ocjAuth_securityCheckWithMemberID:self.ocjStr_memberID custName:self.ocjStr_custName telPhone:self.ocjStr_account historyReceivers:userName historyAddress:self.ocjStr_address historyItems:goodsID thirdPartyInfo:self.ocjStr_thirdPartyInfo completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        OCJBindingPhoneNumberVC *bindingVC = [[OCJBindingPhoneNumberVC alloc] init];
        bindingVC.ocjStr_custName = self.ocjStr_custName;
        bindingVC.ocjStr_custNo = self.ocjStr_memberID;
        bindingVC.ocjStr_mobile = self.ocjStr_mobile;
        [self ocj_pushVC:bindingVC];
        
    }];
    
}
//点击选择地址
- (void)ocj_tappedSelectedAddressView {
    [self.ocjTF_name resignFirstResponder];
    [self ocj_trackEventID:@"AP1706C012F010001A001001" parmas:nil];
  
    [OCJAddressSheetView ocj_popAddressSheetCompletion:^(NSDictionary *dic_address) {
    
        NSString *city = [dic_address objectForKey:@"city"];
        NSString *district = [dic_address objectForKey:@"district"];
        NSString *provenice = [dic_address objectForKey:@"provenice"];
        NSString * proveniceCode = dic_address[@"proveniceCode"];
        NSString * cityCode = dic_address[@"cityCode"];
        NSString * districtCode = dic_address[@"districtCode"];
        
        NSString *addressStr;
        
        if ([provenice isEqualToString:city]) {
            addressStr = [NSString stringWithFormat:@"%@ %@", city, district];
        }else if ([city isEqualToString:district]) {
            addressStr = [NSString stringWithFormat:@"%@ %@", provenice, city];
        }else {
            OCJLog(@"选择地址");
            addressStr = [NSString stringWithFormat:@"%@ %@ %@", provenice, city, district];
        }
        
        self.ocjLab_selectedAddr.text = addressStr;
        self.ocjStr_address = [NSString stringWithFormat:@"%@,%@,%@",proveniceCode,cityCode,districtCode];
        
    }];
    
}

#pragma mark - 协议方法实现区域
#pragma mark - OCJSOCJSecurityGoodsViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.ocjTF_name resignFirstResponder];
}

- (void)ocj_tappedImageView:(OCJSecurityGoodsView *)view {
    OCJSecurityGoodsView *ocj_goodsView = view;
    
    if (_ocjView_last) {
        _ocjView_last.ocj_isSelected = YES;
        _ocjView_last.ocjLab_name.textColor = OCJ_COLOR_DARK_GRAY;
        _ocjView_last.ocjImgView_selected.hidden = YES;
        
    }
    ocj_goodsView.ocj_isSelected = YES;
    ocj_goodsView.ocjLab_name.textColor = [UIColor colorWSHHFromHexString:@"3673f1"];
    ocj_goodsView.ocjImgView_selected.hidden = NO;
    [ocj_goodsView bringSubviewToFront:ocj_goodsView.ocjImgView_selected];
    _ocjView_last = ocj_goodsView;
    OCJLog(@"selected tag = %ld", (long)view.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
