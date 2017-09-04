//
//  RN_OCJ_WebViewVC.m
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/30.
//  Copyright © 2017年 Facebook. All rights reserved.
//

//
//  OCJ_RN_WebViewVC.m
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RN_OCJ_WebViewVC.h"
#import "OCJUserInfoManager.h"
#import <WebKit/WebKit.h>

@interface RN_OCJ_WebViewVC ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) WKWebView* ocjWebView;

@property (nonatomic,strong) OCJProgressHUD* ocjHud;

@property (nonatomic,strong) NSString* ocjStr_url;

@property (nonatomic,copy) NSString* ocjStr_accessToken;

@property (nonatomic,strong) UIView* ocjView_failure;

@end

@implementation RN_OCJ_WebViewVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self ocj_setSelf];
  
}

#pragma mark - 私有方法

- (void)ocj_setSelf{
  //  self.navigationController.navigationBar.hidden = YES;
  
  [self ocj_setWebView];
}

- (void)ocj_setWebView{
  self.ocjWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
  self.ocjWebView.UIDelegate = self;
  self.ocjWebView.navigationDelegate = self;
  [self.view addSubview:self.ocjWebView];
  
  if (self.ocjStr_url.length >0) {
    self.ocjHud = [OCJProgressHUD ocj_showHudWithView:self.view andHideDelay:0];
    
    NSURL* url = [NSURL URLWithString:self.ocjStr_url];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:self.ocjStr_accessToken forHTTPHeaderField:@"X-access-token"];
    
    [self.ocjWebView loadRequest:request];
    
  }else{
    
    [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeFailure title:@"提醒" message:@"H5 网址为空" sureButtonTitle:@"确定" CancelButtonTitle:nil action:^(NSInteger clickIndex) {
      
      [self ocj_back];
    }];
  }
}

#pragma mark - getter
-(NSString *)ocjStr_accessToken{
  
  return [OCJUserInfoManager ocj_getTokenForRN][@"token"];
  
}

-(UIView *)ocjView_failure{
  if (!_ocjView_failure) {
    _ocjView_failure = [[UIView alloc]initWithFrame:self.view.bounds];
    
  }
  return _ocjView_failure;
}

#pragma mark - setter
- (void)setOcjDic_router:(NSDictionary *)ocjDic_router{
  _ocjDic_router = ocjDic_router;
  self.ocjStr_url = self.ocjDic_router[@"url"];
  
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
  
  
  OCJLog(@"%s",__PRETTY_FUNCTION__);
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
  
  OCJLog(@"%s",__PRETTY_FUNCTION__);
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
  
  OCJLog(@"%s",__PRETTY_FUNCTION__);
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
  
  OCJLog(@"%s",__PRETTY_FUNCTION__);
}

// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
  
  OCJLog(@"%s",__PRETTY_FUNCTION__);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
  
  OCJLog(@"%s",__PRETTY_FUNCTION__);
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
  
  //获取请求的url路径.
  NSString *requestString = navigationResponse.response.URL.absoluteString;
  OCJLog(@"requestString:%@",requestString);
  // 遇到要做出改变的字符串
  NSString *subStr = @"www.baidu.com";
  if ([requestString rangeOfString:subStr].location != NSNotFound) {
    OCJLog(@"这个字符串中有subStr");
    //回调的URL中如果含有百度，就直接返回，也就是关闭了webView界面
    [self.navigationController  popViewControllerAnimated:YES];
    return;
  }
  
  decisionHandler(WKNavigationResponsePolicyAllow);
}
@end

