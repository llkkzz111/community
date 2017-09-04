//
//  OCJRegisterTableView.m
//  OCJ
//
//  Created by 董克楠 on 10/6/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRegisterTableView.h"
#import "OCJRegisterCellTableViewCell.h"
#import "OCJWelfareCell.h"
#import "UITableView+OCJTableView.h"

@interface OCJRegisterTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UIView * ocjView_selectView;

@property (nonatomic ,strong) UIButton * ocjBtn_giftBagBtn;
@property (nonatomic ,strong) UIButton * ocjBtn_raffleTicketBtn;
@property (nonatomic ,strong) UIImageView * ocjImage_raffleTicketImg;
@property (nonatomic ,strong) UIImageView * ocjImage_selectImg;

@end

@implementation OCJRegisterTableView

-(instancetype)init
{
    if (self =[super init]) {
        [self ocj_creatSwitchTableView];
        [self ocj_creatTable];
    }
    return self;
}

-(void)ocj_creatSwitchTableView
{
    self.ocjView_selectView = [[UIView alloc] init];
    [self addSubview:self.ocjView_selectView];
    [self.ocjView_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(60);
    }];
    
    self.ocjBtn_raffleTicketBtn = [[UIButton alloc] init];
    self.ocjBtn_raffleTicketBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.ocjBtn_raffleTicketBtn.layer.cornerRadius =5;
    [self.ocjBtn_raffleTicketBtn setTitle:@"福利彩票" forState:UIControlStateNormal];
    [self.ocjBtn_raffleTicketBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#666666"] forState:UIControlStateNormal];
    [self.ocjBtn_raffleTicketBtn setBackgroundColor:[UIColor colorWSHHFromHexString:@"#EEEEEE"]];
    [self.ocjBtn_raffleTicketBtn addTarget:self action:@selector(selecterLottery) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_selectView addSubview:self.ocjBtn_raffleTicketBtn];
    [self.ocjBtn_raffleTicketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.ocjView_selectView.mas_top).offset(15);
        make.width.mas_equalTo(82);
        make.height.mas_equalTo(25);
    }];
    
    self.ocjImage_raffleTicketImg =[[UIImageView alloc] init];
    self.ocjImage_raffleTicketImg.image = [UIImage imageNamed:@"icon_confirm"];
    self.ocjImage_raffleTicketImg.hidden =YES;
    [self.ocjBtn_raffleTicketBtn addSubview:self.ocjImage_raffleTicketImg];
    [self.ocjImage_raffleTicketImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjBtn_raffleTicketBtn.mas_right);
        make.bottom.mas_equalTo(self.ocjBtn_raffleTicketBtn.mas_bottom);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];

    self.ocjBtn_giftBagBtn = [[UIButton alloc] init];
    [self.ocjBtn_giftBagBtn setTitle:@"签到有礼" forState:UIControlStateNormal];
    [self.ocjBtn_giftBagBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.ocjBtn_giftBagBtn setBackgroundColor:[UIColor colorWSHHFromHexString:@"#FFEBE8"]];
    [self.ocjBtn_giftBagBtn addTarget:self action:@selector(selecterRegister) forControlEvents:UIControlEventTouchUpInside];
    self.ocjBtn_giftBagBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.ocjBtn_giftBagBtn.layer.cornerRadius =5;
    [self.ocjView_selectView addSubview:self.ocjBtn_giftBagBtn];
    [self.ocjBtn_giftBagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_raffleTicketBtn.mas_right).offset(15);
        make.top.mas_equalTo(self.ocjView_selectView.mas_top).offset(15);
        make.width.mas_equalTo(82);
        make.height.mas_equalTo(25);
    }];
    
    self.ocjImage_selectImg =[[UIImageView alloc] init];
    self.ocjImage_selectImg.image = [UIImage imageNamed:@"icon_confirm"];
    [self.ocjBtn_giftBagBtn addSubview:self.ocjImage_selectImg];
    [self.ocjImage_selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjBtn_giftBagBtn.mas_right);
        make.bottom.mas_equalTo(self.ocjBtn_giftBagBtn.mas_bottom);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    UIView * ocjView_lineView = [[UIView alloc] init];
    ocjView_lineView.backgroundColor = [UIColor colorWSHHFromHexString:@"#EEEEEE"];
    [self.ocjView_selectView addSubview:ocjView_lineView];
    [ocjView_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.ocjView_selectView.mas_bottom).offset(-1);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(1);
    }];
}

-(void)ocj_creatTable{
    self.ocjTable_dataTableView = [[OCJBaseTableView alloc] init];
    self.ocjTable_dataTableView.delegate =self;
    self.ocjTable_dataTableView.dataSource =self;
    self.ocjTable_dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    [self addSubview:self.ocjTable_dataTableView];
    [self.ocjTable_dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.ocjView_selectView.mas_bottom);
        make.width.mas_equalTo(self.mas_width);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 1) {
        return self.ocjModel_giftModel.ocjArr_GiftList.count;
    }else{
        return self.ocjModel_lotteryModel.ocjArr_lotteryList.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 1) {
        static NSString * regis = @"idetifireLotteryRegis";
        OCJRegisterCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:regis];
        if (cell == nil) {
            cell = [[OCJRegisterCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:regis];
        }
      cell.ocjModel_dataModel = self.ocjModel_giftModel.ocjArr_GiftList[indexPath.row];
      return cell;

    }else{
        static NSString * lottery = @"idetifireLottery";
        OCJWelfareCell * cell = [tableView dequeueReusableCellWithIdentifier:lottery];
        if (cell == nil) {
            cell = [[OCJWelfareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lottery];
        }
        cell.ocjModel_dataModel = self.ocjModel_lotteryModel.ocjArr_lotteryList[indexPath.row];
        return cell;
    }
}

#pragma makr  btn 响应事件
-(void)selecterLottery
{
    //改变控件形态
    [self.ocjBtn_raffleTicketBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.ocjBtn_raffleTicketBtn setBackgroundColor:[UIColor colorWSHHFromHexString:@"#FFEBE8"]];
    [self.ocjBtn_giftBagBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#666666"] forState:UIControlStateNormal];
    [self.ocjBtn_giftBagBtn setBackgroundColor:[UIColor colorWSHHFromHexString:@"#EEEEEE"]];
    
    self.ocjImage_raffleTicketImg.hidden =NO;
    self.ocjImage_selectImg.hidden =YES;
    
    self.index = 2;
    [self.ocjTable_dataTableView reloadData];
}

-(void)selecterRegister
{
    [self.ocjBtn_giftBagBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.ocjBtn_giftBagBtn setBackgroundColor:[UIColor colorWSHHFromHexString:@"#FFEBE8"]];
    [self.ocjBtn_raffleTicketBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#666666"] forState:UIControlStateNormal];
    [self.ocjBtn_raffleTicketBtn setBackgroundColor:[UIColor colorWSHHFromHexString:@"#EEEEEE"]];
    
    self.ocjImage_raffleTicketImg.hidden =YES;
    self.ocjImage_selectImg.hidden =NO;
    
    self.index = 1;
    [self.ocjTable_dataTableView reloadData];
}

@end
