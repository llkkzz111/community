//
//  OCJRefundGoodsVC.m
//  OCJ
//
//  Created by OCJ on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRefundGoodsVC.h"
#import "OCJRefundGoodsTVCell.h"
#import "OCJPlaceholderTextView.h"
#import "OCJHttp_evaluateAPI.h"
#import "OCJResponseModel_evaluate.h"
#import "OCJHttp_onLinePayAPI.h"
#import "OCJReturnMoneyTVCell.h"

@interface OCJRefundGoodsVC ()<UITableViewDataSource,UITableViewDelegate, UITextViewDelegate>

@property (nonatomic,strong) OCJBaseTableView       * ocjTV_main;         ///< 主TableView
@property (nonatomic,assign) BOOL                      ocjBool_expand;    ///< 列表是展开
@property (nonatomic,copy)   NSString                * ocjStr_fundReson;  ///< 退货原因
@property (nonatomic,strong) OCJPlaceholderTextView  * ocjTV_reson;       ///< 退货原因控件
@property (nonatomic,strong) NSMutableArray          * ocjArr_upload;     ///< 上传图片的张数
@property (nonatomic,assign) CGFloat                 ocjFloat_cellHeight; ///< 上传图片控件高度
@property (nonatomic,strong) NSMutableArray          * ocjArr_imageAddr;  ///< 图片数组
@property (nonatomic,strong) NSMutableArray          * ocjArr_imageData;  ///< 图片数组
@property (nonatomic, copy)  NSString                * ocjStr_imageAddr;  ///< 图片地址集合
@property (nonatomic,strong) OCJUploadImageView      * ocjImg_upload;     ///< 上传图片
@property (nonatomic,strong) NSMutableArray          * ocjArr_dataSource; ///< 数据源(退换货商品的数量)

@property (nonatomic,strong) NSMutableDictionary     * ocjDic_goodsInfo;  ///< 退货信息
@property (nonatomic, strong) NSArray *ocjArr_return;                     ///<退货原因数组

@end

@implementation OCJRefundGoodsVC
#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocj_requestReturnGoodsReason];
}

#pragma mark - 私有方法区域
- (void)ocj_requestReturnGoodsReason {
  [OCJHttp_onLinePayAPI ocj_getReChangeResonComplationHandler:^(OCJBaseResponceModel *responseModel) {
    OCJLog(@"responseModel:%@",responseModel.ocjDic_data);
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      self.ocjArr_return = responseModel.ocjDic_data[@"reason"];
      [self ocj_setSelf];
    }
  }];
}

- (void)ocj_setSelf{
    self.title = @"申请退货";
    [self.view addSubview:self.ocjTV_main];
    self.ocjFloat_cellHeight = 105;
    [self.ocjTV_main registerClass:[OCJRefundGoodsTVCell class]          forCellReuseIdentifier:@"OCJRefundGoodsTVCellIdentifier"];
    [self.ocjTV_main registerClass:[OCJRefundGoodsDescTVCell class]      forCellReuseIdentifier:@"OCJRefundGoodsDescTVCellIdentifier"];
    [self.ocjTV_main registerClass:[OCJRefundGoodsUseTVCell class]       forCellReuseIdentifier:@"OCJRefundGoodsUseTVCellIdentifier"];
    [self.ocjTV_main registerClass:[OCJRefundGoodsGoodTVCell class]      forCellReuseIdentifier:@"OCJRefundGoodsGoodTVCellIdentifier"];
    [self.ocjTV_main registerClass:[OCJRefundGoodsLessTVCell class]      forCellReuseIdentifier:@"OCJRefundGoodsLessTVCellIdentifier"];
    [self.ocjTV_main registerClass:[OCJRefundGoodsDamageTVCell class]    forCellReuseIdentifier:@"OCJRefundGoodsDamageTVCellIdentifier"];
    [self.ocjTV_main registerClass:[OCJRefundGoodsMethodTVCell class]    forCellReuseIdentifier:@"OCJRefundGoodsMethodTVCellIdentifier"];
    [self.ocjTV_main registerClass:[OCJRefundUpLoadImgTipTVCell class]   forCellReuseIdentifier:@"OCJRefundUpLoadImgTipTVCellIdentifier"];
    [self.ocjTV_main registerClass:[OCJRefundGoodsBottomTVCell class]    forCellReuseIdentifier:@"OCJRefundGoodsBottomTVCellIdentifier"];
    [self.ocjTV_main registerClass:[OCJReturnMoneyTVCell class] forCellReuseIdentifier:@"OCJReturnMoneyTVCellIdentifier"];
    [self.ocjTV_main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
  
  if ([self.ocjDic_router isKindOfClass:[NSDictionary class]]) {
    NSArray *tempArr = [self.ocjDic_router objectForKey:@"items"];
    NSDictionary *tempDic = tempArr[0];
    NSInteger num = [[tempDic objectForKey:@"order_qty"] integerValue];
    self.ocjDic_goodsInfo = [[NSMutableDictionary alloc] init];
    [self.ocjDic_goodsInfo setValue:[self.ocjDic_router objectForKey:@"orderNo"] forKey:@"orderNo"]; //订单编号
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"order_g_seq"] forKey:@"orderGSeq"];      //订单商品序号
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"order_d_seq"] forKey:@"orderDSeq"];      //赠品序号
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"order_w_seq"] forKey:@"orderWSeq"];      //操作序号
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"receiver_seq"] forKey:@"receiverSeq"];   //退换货地址编码
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"item_code"] forKey:@"retItemCode"];      //商品编号
    [self.ocjDic_goodsInfo setValue:[tempDic objectForKey:@"unit_code"] forKey:@"retUnitCode"];      //商品unitcode
    [self.ocjDic_goodsInfo setValue:[NSString stringWithFormat:@"%ld", num] forKey:@"retExchQty"];   //退货数量
    [self.ocjDic_goodsInfo setValue:@"1" forKey:@"usedYn"];                                          //1：使用过 2：未使用
    [self.ocjDic_goodsInfo setValue:@"1" forKey:@"entiretyYn"];                                      //构建是否齐全 Flag (1:是2:否)
    [self.ocjDic_goodsInfo setValue:@"1" forKey:@"presentYn"];                                       //1：缺少赠品或包装损坏 2：未损坏
    [self.ocjDic_goodsInfo setValue:@"1" forKey:@"packageYn"];                                       //
  }
}


- (OCJBaseTableView *)ocjTV_main{
    if (!_ocjTV_main) {
        _ocjTV_main = [[OCJBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _ocjTV_main.dataSource = self;
        _ocjTV_main.delegate      = self;
        _ocjTV_main.tableHeaderView = [[UIView alloc]init];
        _ocjTV_main.tableFooterView = [self ocj_setTVFooter];
        _ocjTV_main.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _ocjTV_main.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        _ocjTV_main.rowHeight = UITableViewAutomaticDimension;
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
- (NSMutableDictionary *)ocjDic_goodsInfo{
    if (!_ocjDic_goodsInfo) {
        _ocjDic_goodsInfo = [NSMutableDictionary dictionary];
    }
    return _ocjDic_goodsInfo;
}
- (NSMutableArray *)ocjArr_dataSource{
    if (!_ocjArr_dataSource) {
        _ocjArr_dataSource = [NSMutableArray array];
    }
    return _ocjArr_dataSource;
}
- (void)ocj_commitRefundReson{
  if (self.ocjArr_imageAddr.count > 0) {
    ///< 上传图片接口
    [OCJHttp_evaluateAPI ocjPersonal_getImageAddressWithOrderNo:[self.ocjDic_goodsInfo objectForKey:@"orderNo"] goodsNo:[self.ocjDic_goodsInfo objectForKey:@"orderGSeq"] giftNo:[self.ocjDic_goodsInfo objectForKey:@"orderDSeq"] operatonNo:[self.ocjDic_goodsInfo objectForKey:@"orderWSeq"] retItemCode:[self.ocjDic_goodsInfo objectForKey:@"retItemCode"] retUnitCode:[self.ocjDic_goodsInfo objectForKey:@"retUnitCode"] receiverSeq:[self.ocjDic_goodsInfo objectForKey:@"receiverSeq"] imageArr:self.ocjArr_imageAddr completionHandler:^(OCJBaseResponceModel *responseModel) {
      
      if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
        OCJResponceModel_imageAddr *model = (OCJResponceModel_imageAddr *)responseModel;
        
        NSString* imagesStr = [model.ocjArr_imageList componentsJoinedByString:@","];
        [self.ocjDic_goodsInfo setValue:imagesStr forKey:@"imgUrl1"];
        
        [self ocj_requestReturnGoodsAPI];
      }
    }];
  }else {
    [self ocj_requestReturnGoodsAPI];
  }
}

- (void)ocj_requestReturnGoodsAPI {
  NSMutableDictionary * ocjDic_main = [NSMutableDictionary dictionary];
  [ocjDic_main setValue:@"1" forKey:@"retExchYn"];//1：退货 2：换货
  
  NSArray * ocjArr_refundGoods = @[self.ocjDic_goodsInfo];
  [ocjDic_main setObject:ocjArr_refundGoods forKey:@"theList"];
  
  [OCJHttp_evaluateAPI ocjPersonal_RefundGoodsWithOrderNO:ocjDic_main completionHandler:^(OCJBaseResponceModel *responseModel) {
    if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
      if ([responseModel.ocjDic_data isKindOfClass:[NSDictionary class]]) {
        [OCJProgressHUD ocj_showHudWithTitle:[responseModel.ocjDic_data objectForKey:@"result"] andHideDelay:2.0];
      }
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
      });
    }
  }];
}

#pragma mark - 协议方法区域

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
        return 70;
    }else if(indexPath.row ==3){
        return 70;
    }else if ( indexPath.row == 6||indexPath.row == 8 ){
        return 60;
    }else if(indexPath.row ==4 || indexPath.row == 5){
        return 50;
    }else if (indexPath.row == 7){
        return 120;
    }
    return self.ocjFloat_cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak OCJRefundGoodsVC *weakSelf = self;
    if (indexPath.row == 0) {
        OCJRefundGoodsTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJRefundGoodsTVCellIdentifier" forIndexPath:indexPath];
      cell.ocjArr_dataSource = self.ocjArr_return;
      [cell.ocj_tableView reloadData];
        cell.handler = ^(NSDictionary *ocjStr_fundReson) {
            weakSelf.ocjBool_expand = !weakSelf.ocjBool_expand;
          weakSelf.ocjStr_fundReson = ocjStr_fundReson[@"REASON"];
          if ([weakSelf.ocjStr_fundReson length] > 0) {
            [weakSelf.ocjDic_goodsInfo setValue:weakSelf.ocjStr_fundReson forKey:@"claimDesc"];
            [weakSelf.ocjDic_goodsInfo setValue:ocjStr_fundReson[@"CLAIMCODE"] forKey:@"claimCode"];
          }

          
            [weakSelf.ocjTV_main reloadData];
        };
        
        return cell;
    }else if(indexPath.row == 1){
        OCJRefundGoodsDescTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJRefundGoodsDescTVCellIdentifier" forIndexPath:indexPath];
        self.ocjTV_reson = cell.ocjTV_tip;
      self.ocjTV_reson.delegate = self;
      
        return cell;
    }else if(indexPath.row == 2){
        OCJRefundGoodsUseTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJRefundGoodsUseTVCellIdentifier" forIndexPath:indexPath];
        cell.handler = ^(NSString *ocjStr_fundReson) {
            [weakSelf.ocjDic_goodsInfo setValue:ocjStr_fundReson forKey:@"usedYn"];
        };
        return cell;
    }else if(indexPath.row == 3){

        OCJRefundGoodsGoodTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJRefundGoodsGoodTVCellIdentifier" forIndexPath:indexPath];
        cell.handler = ^(NSString *ocjStr_fundReson) {
            [weakSelf.ocjDic_goodsInfo setValue:ocjStr_fundReson forKey:@"entiretyYn"];
        };
        return cell;
    }else if (indexPath.row == 4){
        OCJRefundGoodsLessTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJRefundGoodsLessTVCellIdentifier" forIndexPath:indexPath];
        cell.handler = ^(NSString *ocjStr_fundReson) {
            [weakSelf.ocjDic_goodsInfo setValue:ocjStr_fundReson forKey:@"presentYn"];
        };
        return cell;
    }else if(indexPath.row == 5){
        OCJRefundGoodsDamageTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJRefundGoodsDamageTVCellIdentifier" forIndexPath:indexPath];
        cell.handler = ^(NSString *ocjStr_fundReson) {
            [weakSelf.ocjDic_goodsInfo setValue:ocjStr_fundReson forKey:@"packageYn"];
        };
        return cell;
    }else if(indexPath.row == 6){
        OCJRefundGoodsMethodTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJRefundGoodsMethodTVCellIdentifier" forIndexPath:indexPath];
        return cell;
    }else if(indexPath.row == 7){
        OCJReturnMoneyTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJReturnMoneyTVCellIdentifier" forIndexPath:indexPath];
        cell.ocjChooseReturnMomeyBlock = ^(NSString *ocjStr_return) {
          if ([ocjStr_return isEqualToString:@"0"]) {
            [weakSelf.ocjDic_goodsInfo removeObjectForKey:@"refundSource"];
          }else {
            [weakSelf.ocjDic_goodsInfo setValue:ocjStr_return forKey:@"refundSource"];
          }
        };
        return cell;
    }else if(indexPath.row == 8){
        OCJRefundUpLoadImgTipTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJRefundUpLoadImgTipTVCellIdentifier" forIndexPath:indexPath];
        return cell;
    }else{
        OCJRefundGoodsBottomTVCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OCJRefundGoodsBottomTVCellIdentifier" forIndexPath:indexPath];
      __weak OCJRefundGoodsBottomTVCell *weakCell = cell;
        [cell.ocjView_bottom ocj_addUploadImageViewsWithImageArr:self.ocjArr_imageData dataArr:self.ocjArr_imageAddr];
        cell.ocjView_bottom.ocjUploadImageBlock = ^(CGFloat viewHeight) {
          weakSelf.ocjArr_imageAddr = weakCell.ocjView_bottom.ocjArr_imageData;
          weakSelf.ocjArr_imageData = weakCell.ocjView_bottom.ocjArr_image;
            weakSelf.ocjFloat_cellHeight = viewHeight;
            [weakSelf.ocjTV_main reloadData];
        };

        return cell;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
  if (![self ocj_isEmptyString:textView.text]) {
    [self.ocjDic_goodsInfo setValue:textView.text forKey:@"claimDesc"];
  }
}

/**
 判断字符串是否全部为空字符
 */
- (BOOL) ocj_isEmptyString:(NSString *)str {
  if (!str) {
    return YES;
  }else {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *trimedStr = [str stringByTrimmingCharactersInSet:set];
    
    if ([trimedStr length] == 0) {
      return YES;
    }else {
      return NO;
    }
  }
}

@end
