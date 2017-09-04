//
//  OCJScanJumpWebVC.m
//  OCJ
//
//  Created by Ray on 2017/6/2.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJScanJumpWebVC.h"
#import "OCJProgressHUD.h"

@interface OCJScanJumpWebVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *ocjWebView;
@property (nonatomic, strong) OCJProgressHUD *ocjHud;

@end

@implementation OCJScanJumpWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)ocj_setSelf {
    self.title = @"扫描结果";
    [self ocj_addWebView];
    [self ocj_isWebUrl];
}

- (void)ocj_addWebView {
    self.ocjWebView = [[UIWebView alloc] init];
    self.ocjWebView.scalesPageToFit = YES;
    self.ocjWebView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    self.ocjWebView.delegate = self;
    [self.view addSubview:self.ocjWebView];
    [self.ocjWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(self.view);
    }];
}

- (void)ocj_isWebUrl {
  if (self.ocjEnumWebViewType == OCJEnumWebViewLodingTypeQRCode) {
//    NSString *ocjStr_plistPath = [[NSBundle mainBundle] pathForResource:@"html5" ofType:@"plist"];
//    NSArray *ocjArr_plist = [[NSArray alloc] initWithContentsOfFile:ocjStr_plistPath];
//    for (int i = 0; i < ocjArr_plist.count; i++) {
//      NSString *ocJStr_html = ocjArr_plist[i];
//      if ([self.ocjStr_qrcode containsString:ocJStr_html]) {
        if ([self.ocjStr_qrcode hasPrefix:@"tel"]) {//拨号
          
          if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.ocjStr_qrcode]]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.ocjStr_qrcode]];
          }
        }else {//html
          [self.ocjWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.ocjStr_qrcode]]];
        }
//      }
//    }
  
  }else {
    self.title = self.ocjStr_title;
    [self.ocjWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.ocjStr_qrcode]]];
  }
  
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.ocjHud = [OCJProgressHUD ocj_showHudWithView:self.view andHideDelay:0];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.ocjHud ocj_hideHud];
    //去除html5页面导航栏
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByTagName('header')[0].style.display = 'none'"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.ocjHud ocj_hideHud];
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
