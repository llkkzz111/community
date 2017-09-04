//
//  OCJClassifyVC.m
//  OCJ
//
//  Created by yangyang on 2017/5/2.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJClassifyVC.h"

@interface OCJClassifyVC ()

@property (nonatomic,strong) UIWebView* ocjWebView;

@end

@implementation OCJClassifyVC


#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];

    [self ocj_setUI];
}

#pragma mark - 私有方法区域
-(void)ocj_setUI{
    self.ocjWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.ocjWebView];
    
    [self.ocjWebView loadHTMLString:@"<form name=\"form\"action=\"https://pay.spdbccc.com.cn/paycashier/accountForward/BFpayOrderByDirect.do\" METHOD=\"POST\"target=\"_self\"><input type=\"hidden\" name=\"data\" value=\"{'bigOrderNo':'20170515181880','bigReqNo':'2017051808971494','serviceCode':'031001002107151','bigOrderDate':'20170515','bigOrderAmt':'27000','pgUrl':'http://www.ocj.com.cn/pay/spdbCreditCard_pay_return.jhtml','bgUrl':'http://www.ocj.com.cn/pay/spdbCreditCard_pay_notify.jhtml','orderFields':[{'mchntCode':'031001002107151','tradeCode':'0001','reqSeq':'2017051808971494','orderNo':'20170515181880','orderDate':'20170515','orderAmt':'27000'}],'clientIp':'127.0.0.1','clientMac':'00-00-00-00-00-00','termType':'07'}\"/><input type=\"hidden\" name=\"sign\"  value=\" 434F4A3A0C2653D5D76ADE980292960BCDCC6FABF4810CDB38B2A97D93E07D3094A329D792E9AE118FCA7D7E98282456EEA2FD0A28EC099FD5D8C96E7EC37AA2A7BF235828F3485A06DC5A41FDCD1B189346898D4AD7BDF81EDCA79243A2C0A62DBA54CA396025E259CD20F1FFF6BFE96BC5D885AD6E04D07098F3A9136CD9354BDF52E58D1E4397AC51380DD58F987BF0CCE135DAC34DD2619F9C7ED27B426C06A4C9568D052E6F46415C563450080E\"/></form>" baseURL:nil];
}

#pragma mark - 协议方法区域






@end
