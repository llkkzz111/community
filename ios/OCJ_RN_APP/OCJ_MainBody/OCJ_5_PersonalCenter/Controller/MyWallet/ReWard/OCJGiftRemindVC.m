//
//  OCJGiftRemindVC.m
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/7/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJGiftRemindVC.h"

@interface OCJGiftRemindVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_remind;       ///<tableView
@property (nonatomic, strong) NSString *ocjStr_desc;                   ///<提示内容
@property (nonatomic, assign) CGFloat ocjFloat_height;                 ///<cell高度

@end

@implementation OCJGiftRemindVC

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf {
  self.title = self.ocjStr_title;
  self.ocjFloat_height = 60;
  self.ocjStr_desc = @"1. 东方购物心意畅想礼包可购买东方购物电视、网站、目录所有产品（特殊商品除外）。\n东方购物心意畅想礼包可在电话订购商品或网站购物时直接使用，您只需在选择支付方式时选择“礼包”即可直接付款；也可以将卡内金额先转存至东方购物的礼包账户中，日后购物时再选择礼包账户进行支付。消费时，如果东方购物心意畅想礼包金额不足以支付商品价格，差额部分以其它支付方式补足。\n2. 实体卡用户可选择直接货到刷东方购物心意畅想礼包，请于订购时提前告知客服人员，在物流送货上门时出示东方购物心意畅想礼包，物流人员会直接刷卡结款。\n您可以拨打东方购物热线：962800，按语音提示操作直接进入东方购物心意畅想礼包业务选项，进行查询及转存；或登录东方购物网站及APP“礼包”充值及查询东方购物心意畅想礼包的余额。\n3. 东方购物心意畅想礼包目前有100元、200元、500元、1000元四种面额。如果东方购物心意畅想礼包内金额转存至东方购物礼包账户中，将不受有效期限制，长期有效。\n东方购物对超过3年有效期但仍有资金余额的东方购物心意畅想礼包，提供免费激活服务，续期一年。\n4. 东方购物心意畅想礼包不记名、不挂失、不兑换现金、不退卡。\n购物时用东方购物心意畅想礼包直接支付，一次只能付一张卡。所以如果您有多张东方购物心意畅想礼包，建议您把它们都转存到您东方购物帐户的礼包账户中，再在购物支付时选择“礼包账户”方式支付。\n5. 如需购买东方购物心意畅想礼包，请拨打购卡热线：021-5111-9922，有销售人员专程为您服务，工作时间为：09:00-17:30。您也可以直接线上订购（仅限先行付款，不支持积分、预付款和抵用券）";
  NSArray *ocjArr = [self.ocjStr_desc componentsSeparatedByString:@"\n"];
  for (int i = 0; i < ocjArr.count; i++) {
    NSString *ocjStr = [ocjArr objectAtIndex:i];
    CGFloat height = [self ocj_calculateCellHeightWithString:ocjStr];
    self.ocjFloat_height += height;
  }
  [self ocj_addTableView];
}

- (void)ocj_addTableView {
  self.ocjTBView_remind = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.ocjTBView_remind.delegate = self;
  self.ocjTBView_remind.dataSource = self;
  self.ocjTBView_remind.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.ocjTBView_remind.showsVerticalScrollIndicator = NO;
  [self.view addSubview:self.ocjTBView_remind];
  [self.ocjTBView_remind mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.bottom.mas_equalTo(self.view);
  }];
}

- (CGFloat)ocj_calculateCellHeightWithString:(NSString *)str {
  CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
  return ceilf(rect.size.height);
}

#pragma mark - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  UILabel *ocjLab = [[UILabel alloc] init];
  ocjLab.text = self.ocjStr_desc;
  ocjLab.font = [UIFont systemFontOfSize:15];
  ocjLab.textColor = OCJ_COLOR_DARK;
  ocjLab.numberOfLines = 0;
  [cell.contentView addSubview:ocjLab];
  [ocjLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
    make.right.mas_equalTo(cell.contentView.mas_right).offset(-15);
    make.top.mas_equalTo(cell.contentView.mas_top).offset(30);
  }];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.ocjFloat_height;
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
