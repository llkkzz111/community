//
//  OCJOnlinePayVC.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJOnlinePayVC.h"
#import "OCJOtherCView.h"
#import "OCJPayViewLayout.h"
#import "OCJHttp_onLinePayAPI.h"
#import "OCJOtherPayView.h"
#import "WSHHThirdPay.h"
#import "OCJPayWebVC.h"
#import "OCJPaySuccessVC.h"
#import "WSHHWXLogin.h"
#import "OCJ_RN_WebViewVC.h"


@interface OCJOnlinePayVC ()

@property (nonatomic,strong) OCJOtherCView  * collectionView;
@property (nonatomic,strong) NSMutableArray * ocjArr_original;
@property (nonatomic,strong) NSMutableArray * ocjArr_orders;

@property (nonatomic,strong) NSMutableArray * ocjArr_dataSource;
@property (nonatomic,strong) UIView         * ocjView_top;
@property (nonatomic,copy)   NSString       * ocjStr_accessToken;
@property (nonatomic,strong) NSString       * ocjTime_now;  ///< 当前时间

@property (nonatomic,strong) UILabel* ocjLab_tip; ///< 提示文本框
@end

@implementation OCJOnlinePayVC

#pragma mark - 对外开放方法区域

- (void)setOcjDic_router:(NSDictionary *)ocjDic_router{
  _ocjDic_router = ocjDic_router;
  NSArray* orders = self.ocjDic_router[@"orders"];
  self.ocjArr_original = [orders mutableCopy];
  if ([orders isKindOfClass:[NSArray class]]) {
    self.ocjArr_orders = [orders mutableCopy];
  }
  
}

#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocj_setSelf];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bankCardSelectedNotification" object:nil];
}

#pragma mark - 私有方法区域

- (void)ocj_setSelf{
  self.ocjStr_trackPageID = @"AP1706C018";
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bankCardSelected:) name:@"bankCardSelectedNotification" object:nil];
  self.title = @"东东收银台";
  self.view.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
  
  [self ocj_setTopView];
  [self ocj_setCollectionView];
}

- (void)ocj_back{
  
  [self ocj_trackEventID:@"AP1706C018D003001C003001" parmas:nil];
  [OCJ_NOTICE_CENTER removeObserver:self];
  
  BOOL isOpenByWebView = NO;
  for (OCJBaseVC* vc in self.navigationController.viewControllers) {
    if ([vc isKindOfClass:[OCJ_RN_WebViewVC class]]) {
      isOpenByWebView = YES;
    }
  }
  
  if (isOpenByWebView) {//如果是webView调起的支付页面，点返回直接回到app
    [self.navigationController popToRootViewControllerAnimated:YES];
  }else{
    [super ocj_back];
    NSDictionary * successDic = @{@"code":@"1",@"code":@"failure"};
    [OCJ_NOTICE_CENTER postNotificationName:OCJ_Notification_onlinePay object:self userInfo:successDic];
  }
  
}

- (void)ocj_loginedAndLoadNetWorkData{
    [self.ocjArr_dataSource removeAllObjects];
    [self requestData];
}

- (void)requestData{
  
    __weak OCJOnlinePayVC* weakSelf = self;
    if (self.ocjArr_orders.count>0) {
      
      for (NSString* orderNO in self.ocjArr_orders) {
        if ([orderNO isKindOfClass:[NSString class]]) {
        
          [OCJHttp_onLinePayAPI ocjPayMoneyWithOrderNO:orderNO complationHandler:^(OCJBaseResponceModel *responseModel) {
            OCJModel_onLinePay * model = (OCJModel_onLinePay *)responseModel;
            if ([model.ocjStr_code isEqualToString:@"200"]) {
              [weakSelf ocj_addOrderInfo:model];
            }
          }];
        }
      }
    }else{
      [weakSelf ocj_addOrderInfo:nil];
    }
}

/**
 订单信息
 */
- (void)ocj_addOrderInfo:(OCJModel_onLinePay*)model{
  
    if ([model isKindOfClass:[OCJModel_onLinePay class]]) {
      [self.ocjArr_dataSource addObject:model];
    }
  
    self.ocjLab_tip.text = [NSString stringWithFormat:@"您一共有 %zi 笔订单需要支付，请在30分钟内完成,不然就要溜走啦！",self.ocjArr_dataSource.count];
  
    self.collectionView.ocjArr_dataSource = self.ocjArr_dataSource;
    [self.collectionView reloadData];
}

- (NSString*)ocj_pingURlStringWithDic:(NSDictionary*)dic{
    NSString* payUrl = dic[@"payUrl"];
    
    for (NSString* key in [dic allKeys]) {
        if (![key isEqualToString:@"payUrl"]) {
            NSString* value = dic[key] ;
            if ([value isKindOfClass:[NSString class]]) {
                value = [value description];
            }else if ([value isKindOfClass:[NSDictionary class]]){
                NSDictionary* valueDic = (NSDictionary*)value;
                value = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:valueDic options:0 error:nil] encoding:NSUTF8StringEncoding];
            }
            
            if ([payUrl containsString:@"?"]) {
                payUrl = [[payUrl stringByAppendingString:@"&"]stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
            }else{
                payUrl = [[payUrl stringByAppendingString:@"?"]stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
            }
        }
    }
    payUrl  =  [payUrl stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return payUrl;
}

/*
 */
- (void)bankCardSelected:(NSNotification *)notification{
  
    OCJOtherPayModel * model = notification.userInfo[@"userInfo"];
    NSString * saveamt       = notification.userInfo[@"score"];
    NSString * deposit       = notification.userInfo[@"pre"];
    NSString * record        = notification.userInfo[@"record"];
    NSString * orderNO       = notification.userInfo[@"orderNo"];
    NSString * realMoney     = notification.userInfo[@"realMoney"]; ///< 实际支付金额
    NSString * ocjStr_realMoney = [realMoney stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    OCJLog(@"你选择了%@银行",model.ocjStr_title);
  
    if (model.ocjStr_id.length==0) {
        [OCJProgressHUD ocj_showHudWithTitle:@"请选择正确的支付方式" andHideDelay:2];
        return;
    }
  
  
    [self ocj_trackEventID:@"AP1706C018F008001O008001" parmas:@{@"type":@"确认支付",@"orderid":orderNO,@"payMethod":model.ocjStr_id}];

    __weak OCJOnlinePayVC * weakSelf = self;
    [OCJHttp_onLinePayAPI ocjPayGetEvidenceWithOrderNo:orderNO paymthod:model.ocjStr_id saveamt:saveamt deposit:deposit gistcard:record complationHandler:^(OCJBaseResponceModel *responseModel) {
        
        if([ocjStr_realMoney floatValue] <= 0){//积分、预付款、礼包支付
          
            [weakSelf ocj_reloadCurrentView:orderNO beginTime:[weakSelf ocj_formatDate]];
          
        }else if([model.ocjStr_id isEqualToString:@"38"]) {///< 支付宝支付
          
            NSString * ocjStr_ocjSignString = @"";
            if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
                ocjStr_ocjSignString = [responseModel.ocjDic_data  objectForKey:@"result"];
                if ((!ocjStr_ocjSignString) || (![ocjStr_ocjSignString isKindOfClass:[NSString class]])) {
                    return ;
                }
              
                [[WSHHThirdPay sharedInstance] wshh_alipyPayWithOrder:ocjStr_ocjSignString block:^(NSDictionary *order) {
                  NSString* resultStatus = order[@"resultStatus"];
                  
                  if ([resultStatus isEqualToString:@"9000"]) {//支付成功
                      [weakSelf ocj_reloadCurrentView:orderNO beginTime:[weakSelf ocj_formatDate]];
                  }else{
                    if ([resultStatus isEqualToString:@"6001"]) {
                      [OCJProgressHUD ocj_showHudWithTitle:@"用户中途取消" andHideDelay:2.0];
                    }else {
                      NSString* failurlMessage = order[@"memo"];
                      if (failurlMessage.length>0) {
                        [OCJProgressHUD ocj_showHudWithTitle:failurlMessage andHideDelay:2];
                      }
                    }
                  }
                  
                }];
            }
            
        }else if ([model.ocjStr_id isEqualToString:@"39"]){ ///< 微信支付
           
            NSString * ocjStr_ocjSignString = @"";
            if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
                ocjStr_ocjSignString = [responseModel.ocjDic_data  objectForKey:@"result"];
                NSData * ocjData = [ocjStr_ocjSignString dataUsingEncoding:NSUTF8StringEncoding];
                if ((!ocjData) || (![ocjData isKindOfClass:[NSData class]]) ) {
                    return ;
                }
                NSDictionary * ocjDic = [NSJSONSerialization JSONObjectWithData:ocjData options:0 error:nil];
                if ((!ocjDic) || (![ocjDic isKindOfClass:[NSDictionary class]])) {
                    return;
                }
                NSString * ocjStr_partnerid = [ocjDic objectForKey:@"partnerid"];
                NSString * ocjStr_prepayid  = [ocjDic objectForKey:@"prepayid"];
                NSString * ocjStr_noncestr  = [ocjDic objectForKey:@"noncestr"];
                NSString * ocjStr_timeStamp = [ocjDic objectForKey:@"timestamp"];
                NSString * ocjStr_sign      = [ocjDic objectForKey:@"sign"];
                NSString * ocjStr_package   = [ocjDic objectForKey:@"packageValue"];
                NSDictionary * dic = @{@"partnerid":ocjStr_partnerid,@"prepayid":ocjStr_prepayid,@"noncestr":ocjStr_noncestr,@"timeStamp":ocjStr_timeStamp,@"sign":ocjStr_sign,@"package":ocjStr_package};
                
                [[WSHHWXLogin sharedInstance] wshhWXPayByPoCode:dic block:^(BaseResp *resp, enum WXErrCode errCode, NSString *prePayId) {
                  
                  if (errCode == WXSuccess) {
                    
                    [weakSelf ocj_reloadCurrentView:orderNO beginTime:[weakSelf ocjTime_now]];
                  }else if (errCode == WXErrCodeUserCancel){
                    [OCJProgressHUD ocj_showHudWithTitle:@"用户取消支付" andHideDelay:2];
                  }else{
                    [OCJProgressHUD ocj_showHudWithTitle:@"支付失败" andHideDelay:2];
                  }
                  
                }];
            }
        }else if ([model.ocjStr_id isEqualToString:@"45"]){ ///< 银联支付
            NSString * ocjStr_ocjSignString = @"";
            ocjStr_ocjSignString = [responseModel.ocjDic_data  objectForKey:@"result"];
            if (!ocjStr_ocjSignString || ocjStr_ocjSignString.length <=0) {
                return;
            }
            NSArray * ocjArr_list = [ocjStr_ocjSignString componentsSeparatedByString:@","];
            for (NSString * subString in ocjArr_list) {
                OCJLog(@"subString:%@",subString);
                if ([subString containsString:@"tn"]) {
                    NSString * ocjStr_tn = [subString substringFromIndex:4];
                    [[WSHHThirdPay sharedInstance] wshh_uPPayWithOrder:ocjStr_tn block:^(NSDictionary *order) {
                      
                        [weakSelf ocj_reloadCurrentView:orderNO beginTime:[weakSelf ocj_formatDate]];
                    }];
                }
            }
        }else if([model.ocjStr_id isEqualToString:@"49"]){ ///< applePay支付
          
            NSString * ocjStr_ocjSignString = @"";
            if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
              
                ocjStr_ocjSignString = [responseModel.ocjDic_data  objectForKey:@"result"];
                NSData * ocjData = [ocjStr_ocjSignString dataUsingEncoding:NSUTF8StringEncoding];
                if ((!ocjData) || (![ocjData isKindOfClass:[NSData class]]) ) {
                    return ;
                }
              
                NSDictionary * ocjDic = [NSJSONSerialization JSONObjectWithData:ocjData options:0 error:nil];
                if ((!ocjDic) || (![ocjDic isKindOfClass:[NSDictionary class]])) {
                    return;
                }
              
                [[WSHHThirdPay sharedInstance] wshh_applePayWithOrder:ocjDic block:^(NSDictionary *order) {
                  
                    [weakSelf ocj_reloadCurrentView:orderNO beginTime:[weakSelf ocj_formatDate]];
                }];
            }
        }else if([model.ocjStr_id isEqualToString:@"35"]){//支付宝国际
              
            NSString* urlStr = responseModel.ocjDic_data[@"result"];
            if (![urlStr isKindOfClass:[NSString class]]) {
              [WSHHAlert wshh_showHudWithTitle:[NSString stringWithFormat:@"调起%@支付失败",model.ocjStr_title] andHideDelay:2];
              return ;
            }
          
            OCJPayWebVC* webVC = [[OCJPayWebVC alloc]init];
            webVC.ocjStr_url = urlStr;
            webVC.ocjStr_payID = model.ocjStr_id;
          
            [self ocj_pushVC:webVC];
          
        }else if([model.ocjStr_id isEqualToString:@"53"] || [model.ocjStr_id isEqualToString:@"51"] || [model.ocjStr_id isEqualToString:@"46"] || [model.ocjStr_id isEqualToString:@"8"]){
            if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
                NSString* result = responseModel.ocjDic_data[@"result"];
                if (![result isKindOfClass:[NSString class]]) {
                    [WSHHAlert wshh_showHudWithTitle:[NSString stringWithFormat:@"调起%@支付失败",model.ocjStr_title] andHideDelay:2];
                    return ;
                }
                
                NSData* resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
                if (!resultData) {
                    [WSHHAlert wshh_showHudWithTitle:[NSString stringWithFormat:@"调起%@支付失败",model.ocjStr_title] andHideDelay:2];
                    return;
                }
                
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
                if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
                    [WSHHAlert wshh_showHudWithTitle:[NSString stringWithFormat:@"调起%@支付失败",model.ocjStr_title] andHideDelay:2];
                    return;
                }
              
                NSString * formStr = dic[@"form"];
                if (formStr.length==0) {
                    [WSHHAlert wshh_showHudWithTitle:[NSString stringWithFormat:@"调起%@支付失败:无支付凭证",model.ocjStr_title] andHideDelay:2];
                    return;
                }
              
                NSString * returnUrlStr = dic[@"payReturnUrl"];
                if (returnUrlStr.length==0) {
                  [WSHHAlert wshh_showHudWithTitle:[NSString stringWithFormat:@"调起%@支付失败:无支付成功回调地址",model.ocjStr_title] andHideDelay:2];
                  return;
                }
              
                OCJPayWebVC* webVC = [[OCJPayWebVC alloc]init];
                webVC.ocjStr_payID = model.ocjStr_id;
                webVC.ocjStr_url = formStr;
                webVC.ocjDic_requestBody = dic;
                webVC.ocjStr_returnUrl = returnUrlStr;
                webVC.ocjBlock_paySuccessCallback = ^{
                    [weakSelf ocj_reloadCurrentView:orderNO beginTime:[weakSelf ocj_formatDate]];
                };
              
                [self ocj_pushVC:webVC];
            }
        }else if(model.ocjStr_id.length>0){
            
            [weakSelf ocj_reloadCurrentView:orderNO beginTime:[weakSelf ocj_formatDate]];
          
        }
    }];
  
}



/**
 时间差计算函数

 @param startTime 开始时间
 @param endTime 结束时间
 @return 时间差单位秒
 */
- (CGFloat )dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    CGFloat value = (CGFloat)end - start;
    return value;
}

- (NSString *)ocj_formatDate{
  
    NSDate   * ocjDate_now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:ocjDate_now];
  
    return currentDateString;
}

// 支付成功之后刷新当前界面
- (void)ocj_reloadCurrentView:(NSString *)orderNO beginTime:(NSString*)beginTime{
    __weak OCJOnlinePayVC * weakSelf = self;
    [OCJHttp_onLinePayAPI ocjQueryOrderSateWithOrderNO:orderNO complationHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
          
            for (int i = 0; i < self.ocjArr_orders.count; i ++) {
                if ([self.ocjArr_orders[i] isEqualToString:orderNO]) {
                    [self.ocjArr_orders removeObject:self.ocjArr_orders[i]];//清除支付成功的订单
                    break;
                }
            }
          
            if (self.ocjArr_orders.count <= 0) {//全部订单支付完成后，跳转支付成功页面
                OCJPaySuccessVC* paySuccessVC = [[OCJPaySuccessVC  alloc] initWithOrderNums:self.ocjArr_original];
                [weakSelf ocj_pushVC:paySuccessVC];
                return;
            }
    
            [self.ocjArr_dataSource removeAllObjects];
            [self requestData];
          
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjDic_data[@"responseResult"] andHideDelay:2];
        }else{
            //因服务端和支付方联络存在时间差，查询订单支付状态失败后轮询20s
            NSString       * ocjStr_current = [weakSelf ocj_formatDate];
            CGFloat ocj_div = [weakSelf dateTimeDifferenceWithStartTime:beginTime endTime:ocjStr_current];
          
            if (ocj_div < 20) {
                [weakSelf ocj_reloadCurrentView:orderNO beginTime:beginTime];
            }else{
                [WSHHAlert wshh_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2];
            }
        }
    }];
}



- (NSMutableArray *)ocjArr_dataSource{
    if (!_ocjArr_dataSource) {
        _ocjArr_dataSource = [NSMutableArray array];
    }
    return _ocjArr_dataSource;
}

- (void)ocj_setTopView{
    
    [self.view addSubview:self.ocjView_top];
    
    [self.ocjView_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(57);
    }];
    
    UIButton * ocjBtn_back = [OCJBaseButton buttonWithType:UIButtonTypeSystem];
    [ocjBtn_back setBackgroundImage:[UIImage imageNamed:@"con_tips"] forState:UIControlStateNormal];
    ocjBtn_back.backgroundColor = [UIColor clearColor];
    [self.ocjView_top addSubview:ocjBtn_back];
    [ocjBtn_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_top).offset(15);
        make.top.mas_equalTo(self.ocjView_top).offset(15);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    self.ocjLab_tip = [[UILabel alloc]init];
    self.ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    self.ocjLab_tip.font = [UIFont systemFontOfSize:14];
    self.ocjLab_tip.numberOfLines = 2;
    [self.ocjView_top addSubview:self.ocjLab_tip];
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjBtn_back.mas_right).offset(10);
        make.right.mas_equalTo(self.ocjView_top.mas_right).offset(-15);
        make.top.mas_equalTo(self.ocjView_top).offset(15);
    }];
}

- (void)ocj_setCollectionView{
    
    OCJPayViewLayout    * flowLayout=[[OCJPayViewLayout alloc] init];
    self.collectionView  = [[OCJOtherCView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.ocjView_top.mas_bottom).offset(11);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-7);
    }];
}

#pragma mark - getter
- (UIView *)ocjView_top{
    if(!_ocjView_top){
        _ocjView_top = [UIView new];
        _ocjView_top.backgroundColor = [UIColor colorWSHHFromHexString:@"FFF1F4"];
    }
    return _ocjView_top;
}


@end
