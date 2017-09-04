//
//  OCJPaySuccessVC.m
//  OCJ
//
//  Created by OCJ on 2017/6/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJPaySuccessVC.h"
#import "OCJReComTVCell.h"
#import "OCJHttp_onLinePayAPI.h"
#import "OCJRecommandModel.h"

@interface OCJPaySuccessVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray * ocjArray_orderList;
@property (nonatomic,strong) OCJBaseTableView * ocjTBView;         ///< 列表
@property (nonatomic,strong) NSMutableArray   * ocjArr_dataSource; ///< 数据源

@end

@implementation OCJPaySuccessVC


-(instancetype)initWithOrderNums:(NSMutableArray *)orderArray{
  self = [super init];
  self.ocjArray_orderList = orderArray;
  return self;
}

#pragma mark - 生命周期方法区域

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocj_setSelf];
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf{
    self.title = @"东东收银台";
    self.view.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    [self ocj_addTableView];
    [self ocj_requestData];
}

- (void)ocj_requestData{
    [OCJHttp_onLinePayAPI ocj_getAllRecommandComplationHandler:^(OCJBaseResponceModel *responseModel) {
      
        NSArray * array = (NSArray *)responseModel.ocjDic_data[@"result"];
        for (NSDictionary * dic in array) {
            OCJRecommandModel * recommandModel = [[OCJRecommandModel alloc]init];
            [recommandModel setValuesForKeysWithDictionary:dic];
            [self.ocjArr_dataSource addObject:recommandModel];
        }
        [self.ocjTBView reloadData];
    }];
  
}

/**
 tableView
 */
- (void)ocj_addTableView {
    self.ocjTBView = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    self.ocjTBView = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.ocjTBView registerClass:[OCJReComTVCell class] forCellReuseIdentifier:@"OCJReComTVCellIdentifer"];
    self.ocjTBView.delegate = self;
    self.ocjTBView.dataSource = self;
    self.ocjTBView.showsVerticalScrollIndicator = NO;
    self.ocjTBView.tableHeaderView = [self ocj_setTVHeader];
    self.ocjTBView.tableFooterView = [[UIView alloc] init];
    self.ocjTBView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.ocjTBView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    
    [self.view addSubview:self.ocjTBView];
    [self.ocjTBView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
}

- (void)ocj_back{
  
  NSDictionary * successDic = @{@"code":@"2",@"code":@"success"};
  [OCJ_NOTICE_CENTER postNotificationName:OCJ_Notification_onlinePay object:self userInfo:successDic];
  
  if (self.ocjNavigationController.ocjCallback) {
    self.ocjNavigationController.ocjCallback(@{@"beforepage":@"Pay",@"targetRNPage":@"OrderCenter"});
  }
  
  [self.navigationController popToRootViewControllerAnimated:NO];
}

- (UIView *)ocj_setTVHeader{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * ocjImg_log = [[UIImageView alloc]init];
    [ocjImg_log setImage:[UIImage imageNamed:@"img_success"]];
    [headerView addSubview:ocjImg_log];
    [ocjImg_log mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(headerView).offset(17);
    }];
    
    
    UILabel *ocjLab_result = [[UILabel alloc] init];
    ocjLab_result.text = @"谢谢您！订购已完成！";
    ocjLab_result.font = [UIFont systemFontOfSize:17];
    ocjLab_result.textColor = OCJ_COLOR_DARK;
    ocjLab_result.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:ocjLab_result];
    [ocjLab_result mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(17);
        make.left.right.mas_equalTo(headerView);
        make.top.mas_equalTo(ocjImg_log.mas_bottom).offset(10);
    }];
    
    
    UILabel *ocjLab_detail = [[UILabel alloc] init];
    ocjLab_detail.text = @"如您需索取发票，请致电客服";
    ocjLab_detail.font = [UIFont systemFontOfSize:14];
    ocjLab_detail.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_detail.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:ocjLab_detail];
    [ocjLab_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(17);
        make.left.right.mas_equalTo(headerView);
        make.top.mas_equalTo(ocjLab_result.mas_bottom).offset(15);
    }];
    
    
    
    UIView * ocjView_middle = [[UIView alloc]init];
    ocjView_middle.backgroundColor = [UIColor colorWSHHFromHexString:@"FFF1F4"];
    ocjView_middle.layer.masksToBounds= YES;
    ocjView_middle.layer.cornerRadius = 2;
    [headerView addSubview:ocjView_middle];
    [ocjView_middle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(115);
        make.left.mas_equalTo(headerView).offset(40);
        make.right.mas_equalTo(headerView).offset(-40);
        make.top.mas_equalTo(ocjLab_detail.mas_bottom).offset(15);
    }];
  
    NSString * ocjStr_final = @"";
    for (NSString * orderNo in self.ocjArray_orderList) {
        NSString * ocjStr_order = [NSString stringWithFormat:@"订单号:%@\n",orderNo];
        ocjStr_final = [ocjStr_final stringByAppendingFormat:@"%@",ocjStr_order];
    }
    
    UILabel *ocjLab_order = [[UILabel alloc] init];
    ocjLab_order.text = ocjStr_final;
    ocjLab_order.numberOfLines = 0;
    ocjLab_order.font = [UIFont systemFontOfSize:13];
    ocjLab_order.textColor = [UIColor colorWSHHFromHexString:@"EB5E48"];
    ocjLab_order.textAlignment = NSTextAlignmentCenter;
    [ocjView_middle addSubview:ocjLab_order];
    [ocjLab_order mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ocjView_middle);
        make.top.mas_equalTo(ocjView_middle).offset(15);
    }];
    
    UILabel *ocjLab_mobile = [[UILabel alloc] init];
    ocjLab_mobile.text = @"如有任何疑问，请致电顾客中心\n400-889-8000";
    ocjLab_mobile.numberOfLines = 0;
    ocjLab_mobile.font = [UIFont systemFontOfSize:13];
    ocjLab_mobile.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    ocjLab_mobile.textAlignment = NSTextAlignmentCenter;
    [ocjView_middle addSubview:ocjLab_mobile];
    [ocjLab_mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ocjView_middle);
        make.top.mas_equalTo(ocjLab_order.mas_bottom).offset(5);
    }];
    
    UIView * ocjView_bottom = [[UIView alloc]init];
    ocjView_bottom.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:ocjView_bottom];
    [ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(240);
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(ocjView_middle.mas_bottom).offset(25);
    }];
    
    NSArray * titleArray = @[@"查看订单",@"继续购物"];
    for (int i = 0; i< 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.masksToBounds = YES;
        button.tag = i;
        button.layer.cornerRadius = 2;
        button.layer.borderColor = [UIColor colorWSHHFromHexString:@"999999"].CGColor;
        button.layer.borderWidth = 1;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWSHHFromHexString:@"333333"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
      [button addTarget:self action:@selector(ocj_click:) forControlEvents:UIControlEventTouchUpInside];
        [ocjView_bottom addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(ocjView_bottom);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(110);
            make.left.mas_equalTo(130* i);
        }];
    }
    
    UIView * ocjView_dark = [[UIView alloc]init];
    ocjView_dark.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    [headerView addSubview:ocjView_dark];
    [ocjView_dark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10);
        make.left.right.mas_equalTo(headerView);
        make.top.mas_equalTo(ocjView_bottom.mas_bottom).offset(33);
    }];
    
    UIView * ocjView_last = [[UIView alloc]init];
    ocjView_last.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:ocjView_last];
    [ocjView_last mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(42.5);
        make.left.right.mas_equalTo(headerView);
        make.top.mas_equalTo(ocjView_dark.mas_bottom);
    }];
    
    
    UILabel *ocjLab_recommand = [[UILabel alloc] init];
    ocjLab_recommand.text = @"· 为您推荐 ·";
    ocjLab_recommand.font = [UIFont systemFontOfSize:16];
    ocjLab_recommand.textColor = [UIColor colorWSHHFromHexString:@"E5290D"];
    ocjLab_recommand.textAlignment = NSTextAlignmentCenter;
    [ocjView_last addSubview:ocjLab_recommand];
    [ocjLab_recommand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ocjView_last);
        make.height.mas_equalTo(22.5);
        make.centerY.mas_equalTo(ocjView_last);
    }];
    
    UIView * ocjView_line = [[UIView alloc]init];
    ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    [ocjView_last addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(ocjView_last);
        make.bottom.mas_equalTo(ocjView_last);
        make.height.mas_equalTo(0.5);
    }];

    return headerView;
}

- (void)ocj_click:(UIButton *)sender{
  
    if (sender.tag ==0) {
        NSDictionary * successDic = @{@"code":@"2",@"code":@"success"};
        [OCJ_NOTICE_CENTER postNotificationName:OCJ_Notification_onlinePay object:self userInfo:successDic];
        if (self.ocjNavigationController.ocjCallback) {
          self.ocjNavigationController.ocjCallback(@{@"beforepage":@"Pay",@"targetRNPage":@"OrderCenter"});
          [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }else{
        NSDictionary * successDic = @{@"code":@"3",@"code":@"success"};
        [OCJ_NOTICE_CENTER postNotificationName:OCJ_Notification_onlinePay object:self userInfo:successDic];
        if (self.ocjNavigationController.ocjCallback) {
          self.ocjNavigationController.ocjCallback(@{@"beforepage":@"Pay",@"targetRNPage":@"ResetToHome"});
          [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}

#pragma mark - getter
- (NSMutableArray *)ocjArr_dataSource{
  if (!_ocjArr_dataSource) {
    _ocjArr_dataSource = [NSMutableArray array];
  }
  return _ocjArr_dataSource;
}
#pragma mark - 协议方法实现区域
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ocjArr_dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OCJReComTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJReComTVCellIdentifer" forIndexPath:indexPath];
    OCJRecommandModel * model = (OCJRecommandModel *)[self.ocjArr_dataSource objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  OCJRecommandModel * model = (OCJRecommandModel *)[self.ocjArr_dataSource objectAtIndex:indexPath.row];
  
  NSString* itemCode = model.ocjStr_itemCode;
  if (itemCode.length==0) {
    [OCJProgressHUD ocj_showHudWithTitle:@"商品编码为空" andHideDelay:2];
    return;
  }
  
  if (self.ocjNavigationController.ocjCallback) {
    self.ocjNavigationController.ocjCallback(@{@"itemcode":itemCode,@"beforepage":@"Pay",@"targetRNPage":@"GoodsDetailMain"});
    [self.navigationController popToRootViewControllerAnimated:NO];
  }
  
}

@end
