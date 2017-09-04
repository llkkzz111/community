//
//  OCJExchangeGoodsVC.m
//  OCJ
//
//  Created by OCJ on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJExchangeGoodsVC.h"
#import "OCJPlaceholderTextView.h"
#import "OCJExchangeGoodsTVCell.h"
#import "OCJHttp_evaluateAPI.h"
#import "OCJResponseModel_evaluate.h"
#import "OCJChooseGoodsSpecView.h"
#import "OCJHttp_onLinePayAPI.h"
#


@interface OCJExchangeGoodsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) OCJBaseTableView        * ocjTV_main;         ///< 主TableView
@property (nonatomic,assign) BOOL                      ocjBool_expand;     ///< 列表是展开
@property (nonatomic,copy)   NSString                * ocjStr_fundReson;   ///< 退货原因
@property (nonatomic,strong) OCJPlaceholderTextView  * ocjTV_reson;        ///< 退货原因控件
@property (nonatomic,strong) NSMutableDictionary     * ocjDic_goodsInfo;   ///< 退货信息
@property (nonatomic,assign) CGFloat                   ocjFloat_cellHeight;
@property (nonatomic,strong) NSMutableString         * ocjStr_imageAddr;
@property (nonatomic,strong) NSMutableArray          * ocjArr_imageAddr;    ///< 上传图片数组
@property (nonatomic,strong) NSMutableArray          * ocjArr_exchangeReson;///< 退换货原因和代码
@property (nonatomic,strong) NSDictionary            * ocjDic_order;        ///< RN字典
@property (nonatomic,strong) NSMutableArray          * ocjArr_image;        ///< 预览看大图
@property (nonatomic, strong) NSString               *ocjStr_unitCode;      ///<选中商品unitcode

@end

@implementation OCJExchangeGoodsVC
#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
  [super viewDidLoad];
  [self ocj_requestData];
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf{
  self.title = @"申请换货";
  [self ocj_getOrderNO]; ///< 获取商品数组字典
  [self.view addSubview:self.ocjTV_main];
  
  self.ocjFloat_cellHeight = 114;
  [self.ocjTV_main registerClass:[OCJExchangeGoodsTVCell class]             forCellReuseIdentifier:@"OCJExchangeGoodsTVCellIdentifier"];
  [self.ocjTV_main registerClass:[OCJExchangeGoodsDescTVCell class]         forCellReuseIdentifier:@"OCJExchangeGoodsDescTVCellIdentifier"];
  [self.ocjTV_main registerClass:[OCJGoodsDescTVCell class]                 forCellReuseIdentifier:@"OCJGoodsDescTVCellIdentifier"];
  [self.ocjTV_main registerClass:[OCJExchangeGoodsGoodsUseTVCell class]     forCellReuseIdentifier:@"OOCJExchangeGoodsIdentifier"];
  [self.ocjTV_main registerClass:[OCJExchangeGoodsDamageTVCell class]       forCellReuseIdentifier:@"OCJExchangeGoodsDamageTVCellIdentifier"];     ///< 缺少主赠品或包装损坏
  [self.ocjTV_main registerClass:[OCJExchangeGoodsBottomTVCell class]       forCellReuseIdentifier:@"OCJExchangeGoodsBottomTVCellIdentifier"];     ///< 底部Cell
  [self.ocjTV_main mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(self.view);
  }];
  
}
- (void)ocj_getOrderNO{
  //遍历数组第读取第一个字典，换货只能单个换货
  if ([self.ocjDic_router isKindOfClass:[NSDictionary class]]) {
    NSArray *tempArr = [self.ocjDic_router objectForKey:@"items"];
    NSDictionary *tempDic = tempArr[0];
    self.ocjDic_order = tempDic;
    self.ocjStr_unitCode = [tempDic objectForKey:@"unit_code"];
    NSInteger num = [[tempDic objectForKey:@"order_qty"] integerValue];
    self.ocjDic_goodsInfo = [[NSMutableDictionary alloc] init];
    [self.ocjDic_goodsInfo setValue:[self.ocjDic_router objectForKey:@"orderNo"] forKey:@"orderNo"]; //订单编号
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"order_g_seq"] forKey:@"orderGSeq"];      //订单商品序号
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"order_d_seq"] forKey:@"orderDSeq"];      //赠品序号
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"order_w_seq"] forKey:@"orderWSeq"];      //操作序号
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"receiver_seq"] forKey:@"receiverSeq"];   //退换货地址编码
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"item_code"] forKey:@"retItemCode"];      //商品编号
    [self.ocjDic_goodsInfo setValue:self.ocjStr_unitCode forKey:@"retUnitCode"];                     //商品unitcode
    [self.ocjDic_goodsInfo setValue:[NSString stringWithFormat:@"%ld", num] forKey:@"retExchQty"];   //退货数量
    [self.ocjDic_goodsInfo setValue:@"1" forKey:@"usedYn"];                                          //1：使用过 2：未使用
    [self.ocjDic_goodsInfo setValue:@"1" forKey:@"entiretyYn"];                                      //构建是否齐全 Flag (1:是2:否)
    [self.ocjDic_goodsInfo setValue:@"1" forKey:@"presentYn"];                                       //1：缺少赠品或包装损坏 2：未损坏
    [self.ocjDic_goodsInfo setValue:@"1" forKey:@"packageYn"];                                       //
//    [self.ocjDic_goodsInfo setValue:@"1" forKey:@"refundSource"];                                    //
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"item_code"] forKey:@"exchItemCode"];     //新商品编号(与原商品编号相同)
    [self.ocjDic_goodsInfo setValue:self.ocjStr_unitCode forKey:@"exchUnitCode"];                    //新商品unitcode
  }
}
- (void)ocj_requestData{
  __weak OCJExchangeGoodsVC * weakSelf  = self;
  [OCJHttp_onLinePayAPI ocj_getReChangeResonComplationHandler:^(OCJBaseResponceModel *responseModel) {
    OCJLog(@"responseModel:%@",responseModel.ocjDic_data);
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      weakSelf.ocjArr_exchangeReson = responseModel.ocjDic_data[@"reason"];
      [self ocj_setSelf];
    }
  }];
  
}
- (OCJBaseTableView *)ocjTV_main{
  if (!_ocjTV_main) {
    _ocjTV_main                    = [[OCJBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _ocjTV_main.dataSource         = self;
    _ocjTV_main.delegate           = self;
    _ocjTV_main.tableHeaderView    = [[UIView alloc]init];
    _ocjTV_main.tableFooterView    = [self ocj_setTVFooter];
    _ocjTV_main.separatorStyle     = UITableViewCellSeparatorStyleNone;
    _ocjTV_main.backgroundColor    = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    _ocjTV_main.rowHeight          = UITableViewAutomaticDimension;
    _ocjTV_main.estimatedRowHeight = 50;
  }
  return _ocjTV_main;
}

- (UIView *)ocj_setTVFooter{
  UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
  footerView.backgroundColor = [UIColor colorWSHHFromHexString:@"dddddd"];
  
  OCJBaseButton * ocjBtn_commit = [[OCJBaseButton alloc] init];
  ocjBtn_commit.backgroundColor = [UIColor redColor];
  ocjBtn_commit.layer.cornerRadius = 2;
  [ocjBtn_commit setTitle:@"确认提交" forState:UIControlStateNormal];
  [ocjBtn_commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [ocjBtn_commit addTarget:self action:@selector(ocj_commitRefundReson) forControlEvents:UIControlEventTouchUpInside];
  ocjBtn_commit.backgroundColor = [UIColor colorWSHHFromHexString:@"FF6048"];
  ocjBtn_commit.ocjFont = [UIFont systemFontOfSize:14];
  [footerView addSubview:ocjBtn_commit];
  
  [ocjBtn_commit mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(footerView).offset(-20);
    make.left.mas_equalTo(footerView).offset(20);
    make.centerY.mas_equalTo(footerView.mas_centerY);
    make.height.mas_equalTo(45);
  }];
  return footerView;
}
- (void)ocj_commitRefundReson{
  if (self.ocjArr_imageAddr.count > 0) {
    ///< 上传图片接口
    [OCJHttp_evaluateAPI ocjPersonal_getImageAddressWithOrderNo:self.ocjDic_router[@"orderNo"] goodsNo:self.ocjDic_order[@"order_g_seq"] giftNo:self.ocjDic_order[@"order_d_seq"] operatonNo:self.ocjDic_order[@"order_w_seq"] retItemCode:self.ocjDic_order[@"item_code"] retUnitCode:self.ocjDic_order[@"unit_code"] receiverSeq:self.ocjDic_order[@"receiver_seq"] imageArr:self.ocjArr_imageAddr completionHandler:^(OCJBaseResponceModel *responseModel) {
      
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        OCJResponceModel_imageAddr *model = (OCJResponceModel_imageAddr *)responseModel;
        
        self.ocjStr_imageAddr = [[NSMutableString alloc] init];
        
        for (int i = 0; i < model.ocjArr_imageList.count; i++) {
          NSString *ocjStr = [model.ocjArr_imageList objectAtIndex:i];
          if (i == 0) {
            [self.ocjStr_imageAddr appendFormat:@"%@", ocjStr];
          }else {
            [self.ocjStr_imageAddr appendFormat:@",%@", ocjStr];
          }
        }
        [self.ocjDic_goodsInfo setValue:self.ocjStr_imageAddr forKey:@"imgUrl1"];
        [self ocj_requestReturnGoodsAPI];
      }
    }];
  }else {
    [self ocj_requestReturnGoodsAPI];
  }
}
//请求退换货接口
- (void)ocj_requestReturnGoodsAPI {
//  NSString *ocjStr_newunitcode = [self.ocjDic_goodsInfo objectForKey:@"exchUnitCode"];
//  if ([self.ocjStr_unitCode isEqualToString:ocjStr_newunitcode] || !([ocjStr_newunitcode length] > 0)) {
//    [OCJProgressHUD ocj_showHudWithTitle:@"请选择需要更换的商品规格" andHideDelay:2.0];
//    return;
//  }
  
  NSMutableDictionary * ocjDic_main = [NSMutableDictionary dictionary];
  [ocjDic_main setValue:@"2" forKey:@"retExchYn"];//1：退货 2：换货
  
  NSArray * ocjArr_refundGoods = @[self.ocjDic_goodsInfo];
  [ocjDic_main setObject:ocjArr_refundGoods forKey:@"theList"];
  
  [OCJHttp_evaluateAPI ocjPersonal_RefundGoodsWithOrderNO:ocjDic_main completionHandler:^(OCJBaseResponceModel *responseModel) {
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      [self.navigationController popViewControllerAnimated:YES];
    }
  }];
}

- (NSMutableDictionary *)ocjDic_goodsInfo{
  if (!_ocjDic_goodsInfo) {
    _ocjDic_goodsInfo = [NSMutableDictionary dictionary];
  }
  return _ocjDic_goodsInfo;
}
#pragma mark - 协议方法区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row == 0) {
    if (self.ocjBool_expand) {
      return 50;
    }else{
      return 400;
    }
  }else if(indexPath.row == 1){
    return 190;
  }else if(indexPath.row == 2){
    return 177;
  }else if(indexPath.row ==3){
    return 70;
  }else if(indexPath.row ==4 ){
    return 70;
  }
  return 52+ self.ocjFloat_cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  __weak OCJExchangeGoodsVC *weakSelf = self;
  if (indexPath.row == 0) {
    OCJExchangeGoodsTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJExchangeGoodsTVCellIdentifier" forIndexPath:indexPath];
    __weak OCJExchangeGoodsTVCell * weakCell = cell;
    cell.ocjArr_dataSource = self.ocjArr_exchangeReson;
    [cell.ocj_tableView reloadData];
    weakCell.handler = ^(NSDictionary *ocjStr_fundReson) {
        weakSelf.ocjBool_expand = !weakSelf.ocjBool_expand;
        weakSelf.ocjStr_fundReson = ocjStr_fundReson[@"REASON"];
      if ([weakSelf.ocjStr_fundReson length] > 0) {
//        [weakSelf.ocjDic_goodsInfo setValue:weakSelf.ocjStr_fundReson forKey:@"claimDesc"];
        [weakSelf.ocjDic_goodsInfo setValue:weakSelf.ocjStr_fundReson forKey:@"claimCode"];
      }
        [weakSelf.ocjTV_main reloadData];
    };
    return cell;
  }else if(indexPath.row == 1){
    OCJExchangeGoodsDescTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJExchangeGoodsDescTVCellIdentifier" forIndexPath:indexPath];
    cell.handler = ^(NSString *ocjStr_reson) {
      [weakSelf.ocjDic_goodsInfo setValue:ocjStr_reson ? ocjStr_reson:@"" forKey:@"claimDesc"];
    };
    return cell;
  }else if(indexPath.row == 2){
    OCJGoodsDescTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJGoodsDescTVCellIdentifier" forIndexPath:indexPath];
    __weak OCJGoodsDescTVCell *weakCell = cell;
    cell.ocjLab_goodName.text = self.ocjDic_order[@"item_name"];
    [cell.ocjImg_goodDes ocj_setWebImageWithURLString:self.ocjDic_order[@"contentLink"] completion:nil];
    cell.ocjLab_goodProp.text = self.ocjDic_order[@"dt_info"];
    cell.ocjChooseGoodSpecblock = ^{
      
      NSString *ocjStr_itemcode = [weakSelf.ocjDic_order objectForKey:@"item_code"];
      OCJChooseGoodsSpecView *view = [[OCJChooseGoodsSpecView alloc] initWithEnumType:OCJEnumGoodsSpecExchange andItemCode:ocjStr_itemcode];
      view.ocjConfirmBlock = ^(NSString *ocjStr_unitcode, NSString *ocjStr_size, OCJResponceModel_specDetail *ocjModel_specColor) {
        weakCell.ocjLab_goodProp.text = [NSString stringWithFormat:@"尺寸：%@  颜色：%@", ocjStr_size, ocjModel_specColor.ocjStr_name];
        [weakCell.ocjImg_goodDes ocj_setWebImageWithURLString:ocjModel_specColor.ocjStr_imgUrl completion:nil];
        [weakSelf.ocjDic_goodsInfo setValue:ocjStr_unitcode forKey:@"exchUnitCode"];

      };
      UIWindow *window = [UIApplication sharedApplication].keyWindow;
      [window addSubview:view];
      [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(window);
      }];
    };
    return cell;
  }else if(indexPath.row == 3){
    OCJExchangeGoodsGoodsUseTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OOCJExchangeGoodsIdentifier" forIndexPath:indexPath];
    cell.handler = ^(NSString *ocjStr_use) {
      [weakSelf.ocjDic_goodsInfo setValue:ocjStr_use forKey:@"usedYn"];
    };
    return cell;
  }else if (indexPath.row == 4){
    OCJExchangeGoodsDamageTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJExchangeGoodsDamageTVCellIdentifier" forIndexPath:indexPath];
    cell.handler = ^(NSString *ocjStr_damage) {
      [weakSelf.ocjDic_goodsInfo setValue:ocjStr_damage forKey:@"packageYn"];
    };
    return cell;
  }else{
    OCJExchangeGoodsBottomTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJExchangeGoodsBottomTVCellIdentifier" forIndexPath:indexPath];
    __weak OCJExchangeGoodsBottomTVCell *weakCell = cell;
    [cell.ocjView_bottom ocj_addUploadImageViewsWithImageArr:self.ocjArr_image dataArr:self.ocjArr_imageAddr];
    cell.ocjView_bottom .ocjUploadImageBlock = ^(CGFloat viewHeight) {
      weakSelf.ocjArr_imageAddr = weakCell.ocjView_bottom.ocjArr_imageData;
      weakSelf.ocjArr_image = weakCell.ocjView_bottom.ocjArr_image;
      OCJLog(@"%lf",viewHeight);
      weakSelf.ocjFloat_cellHeight = viewHeight;
      [weakSelf.ocjTV_main reloadData];
    };
    return cell;
  }
}


@end
