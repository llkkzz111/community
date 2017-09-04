//
//  OCJPayWebVC.m
//  OCJ
//
//  Created by wb_yangyang on 2017/6/1.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJPayWebVC.h"

#define PayIdentity @"itjkajksjfljalkjfalkdfjlajfl"

@interface OCJPayWebVC () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView* ocjWebView;

@property (nonatomic,copy) NSString* ocjStr_html;

@property (nonatomic,strong) OCJProgressHUD* ocjHud;

@end

@implementation OCJPayWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setWebView];
}

- (void)ocj_setWebView{
    self.ocjStr_html = @"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"></head><script language=javascript>setTimeout(\"document.form.submit()\",1000)</script><body>itjkajksjfljalkjfalkdfjlajfl</body></html>";
  
    self.ocjWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.ocjWebView.delegate = self;
    [self.ocjWebView setScalesPageToFit:YES];
    [self.view addSubview:self.ocjWebView];
  
    if ([self.ocjStr_payID isEqualToString:@"35"]) {//支付宝国际
//        self.ocjStr_url = [self.ocjStr_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:self.ocjStr_url];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
      
        [self.ocjWebView loadRequest:request];
      
    }else{
      
        self.ocjStr_html = [self.ocjStr_html stringByReplacingOccurrencesOfString:PayIdentity withString:self.ocjStr_url];//拼接html文件
      
        [self.ocjWebView loadHTMLString:self.ocjStr_html baseURL:nil];
    }
  
    self.ocjHud = [OCJProgressHUD ocj_showHudWithView:self.view andHideDelay:0];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
  
    NSString* jumpUrl = request.URL.absoluteString;
    if ((self.ocjStr_returnUrl.length >0 && [jumpUrl containsString:self.ocjStr_returnUrl]) || [jumpUrl isEqualToString:@"https://payment.bankcomm.com/mobilegateway/ShopService/paysucc.aspx"] || [jumpUrl isEqualToString:@"https://pay-return.ocj.com.cn/api/returnpay/spdbDirect_pay_notify.jhtml"]) {//如果拦截到支付成功回调地址，则跳回支付页面
      
        if (self.ocjBlock_paySuccessCallback) {
            self.ocjBlock_paySuccessCallback();
        }
        [self ocj_back];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    OCJLog(@"%s",__PRETTY_FUNCTION__);
    if (self.ocjHud) {
      [self.ocjHud ocj_hideHud];
    }
  
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    OCJLog(@"%s \n %@",__PRETTY_FUNCTION__,error);
  if (self.ocjHud) {
    [self.ocjHud ocj_hideHud];
  }
}


@end
