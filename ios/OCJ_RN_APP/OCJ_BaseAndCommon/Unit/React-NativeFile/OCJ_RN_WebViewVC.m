//
//  OCJ_RN_WebViewVC.m
//  OCJ_RN_APP
//
//  Created by wb_yangyang on 2017/6/29.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJ_RN_WebViewVC.h"
#import "OCJUserInfoManager.h"
#import <WebKit/WebKit.h>
#import "OCJSharePopView.h"
#import "OCJOnlinePayVC.h"
#import "OCJGlobalShoppingVC.h"
#import "OCJQuickRegisterVC.h"

#import <AFNetworkReachabilityManager.h>
#import "WebViewJavascriptBridge.h"
//#import <JavaScriptCore/JavaScriptCore.h>
#import "OCJHttp_authAPI.h"
#import "OCJFailureView.h"
#import "OCJJZLiveLoginManager.h"
#import <UIWebView+AFNetworking.h>
#import <AFNetworking.h>


@interface OCJ_RN_WebViewVC ()<UIWebViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,OCJFailureViewDelegate>

@property (nonatomic,strong) UIWebView* ocjWebView;           ///< webView视图

@property (nonatomic,strong) OCJProgressHUD* ocjHud;          ///< loading图
@property (nonatomic,strong) AFHTTPSessionManager* ocjHttpManager; ///< 请求管理器

@property (nonatomic,strong) NSString* ocjStr_url;            ///< 外界传入的url路径

@property (nonatomic,copy) NSString* ocjStr_accessToken;      ///< 登录凭证

@property (nonatomic,copy) NSString* ocjStr_loginedRefreshUrl;///< 弹原生页面

@property (nonatomic,strong) NSURLRequest* ocjRequest;        ///< header中加登录凭证后刷新页面保存的请求

@property (nonatomic,strong) OCJFailureView* ocjView_failure; ///< 请求错误视图
@property (nonatomic) BOOL ocjBool_islogin;                   ///<是否在当前页面登录
@property (nonatomic, strong) NSString *ocjStr_fromPage;      ///<之前页面路径
@property (nonatomic, strong) NSString *ocjStr_europe;        ///<是否从鸥点详情页过来，是的返回时发送刷新鸥点通知

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@property (nonatomic) UIStatusBarStyle ocjStatusBarStyle;     ///<状态栏颜色
@property (nonatomic) BOOL ocjBool_isWebViewDisappear;        ///< webView 是否处于隐藏状态，隐藏式不carewebView加载失败情况,目前有跳转RN<商品详情>和<购物车>两种情况需要考虑

@end

@implementation OCJ_RN_WebViewVC

#pragma mark - 接口方法区域
+(void)ocj_setUserAgentForApp
{
  // Set user agent (the only problem is that we can't modify the User-Agent later in the program)
  UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
  NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
  NSString *newUagent = [NSString stringWithFormat:@"OCJ_Iphoneapp_log_iPhone_%@",secretAgent];
  NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newUagent, @"UserAgent", nil];
  [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
  webView = nil;
}


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_setSelf];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  self.ocjStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  self.ocjBool_isWebViewDisappear = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
  
  [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:self.ocjStatusBarStyle];
  
  [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - 私有方法

- (void)ocj_setSelf{
  self.ocjBool_islogin = NO;
  
  [self ocj_setWebView];
  
  [self WebViewJavascriptBridgeMethod];
}

- (void)ocj_setWebView{
  
  self.ocjWebView = [[UIWebView alloc]init];
  self.ocjWebView.backgroundColor = [UIColor whiteColor];
  self.ocjWebView.delegate = self;
  [self.ocjWebView setScalesPageToFit:YES];
  [self.view addSubview:self.ocjWebView];
  [self.ocjWebView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.mas_equalTo(self.view);
    make.top.offset(0);
  }];
  
  //状态栏视图
  UIView *view = [[UIView alloc] init];
  view.backgroundColor = [UIColor whiteColor];
  view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
  [self.view addSubview:view];
  
  if (self.ocjStr_url.length >0) {
    
      NSURL* url = [NSURL URLWithString:self.ocjStr_url];
      NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
      request.timeoutInterval = 30;
      [request setValue:self.ocjStr_accessToken forHTTPHeaderField:@"X-access-token"];
      [self.ocjWebView loadRequest:request];
    
  }else{
    
      [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeFailure title:@"提醒" message:@"H5 网址为空" sureButtonTitle:@"确定" CancelButtonTitle:nil action:^(NSInteger clickIndex) {
      
          [self ocj_back];
      }];
  }
  
}

- (void)ocj_back {
  if ([self.ocjStr_europe isEqualToString:@"YES"]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OCJReloadEurope" object:nil];
  }
  [super ocj_back];
}

/**
 处理H5跳转需求

 @param jumpMessage 跳转暗号
 */
-(void)ocj_dealWithJumpMessage:(NSDictionary*)jumpMessage{
    NSString* action = jumpMessage[@"action"];//触发事件标识
    NSDictionary* paramsDic = jumpMessage[@"param"];//触发事件参数
  
    if ([action isEqualToString:@"share"] ) {//分享
      if (![paramsDic isKindOfClass:[NSDictionary class]]) {
        [OCJProgressHUD ocj_showHudWithTitle:@"分享参数不对" andHideDelay:2];
        return;
      }
      
      NSString* title = paramsDic[@"title"];
      NSString* text = paramsDic[@"content"];
      NSString* imageUrlStr = paramsDic[@"image_url"];
      NSString* urlStr = paramsDic[@"target_url"];
      
      NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
      [mDic setValue:title forKey:@"title"];
      [mDic setValue:text forKey:@"text"];
      [mDic setValue:imageUrlStr forKey:@"image"];
      [mDic setValue:urlStr forKey:@"url"];
      [[OCJSharePopView sharedInstance]ocj_setShareContent:[mDic copy]];
    
    }else if ([action isEqualToString:@"back"]){//返回RN页面
      
      [self ocj_back];
      
    }else if ([action isEqualToString:@"login"]){//登录
      
      NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken];
      if (token.length==0) {
          self.ocjStr_loginedRefreshUrl = jumpMessage[@"url"];
          [[AppDelegate ocj_getShareAppDelegate]ocj_reLogin];
      }else{
          //检测token
          [OCJHttp_authAPI ocjAuth_chechToken:token completionHandler:^(OCJBaseResponceModel *responseModel) {
            OCJAuthModel_checkToken* model = (OCJAuthModel_checkToken*)responseModel;
            if (model.ocjStr_custNo.length==0) {
              self.ocjStr_loginedRefreshUrl = jumpMessage[@"url"];
              [[AppDelegate ocj_getShareAppDelegate]ocj_reLogin];
            }
          }];
      }

    }else if ([action isEqualToString:@"pay"]){//跳转东东收银台
      if (![paramsDic isKindOfClass:[NSDictionary class]]) {
        [OCJProgressHUD ocj_showHudWithTitle:@"订单参数不对" andHideDelay:2];
        return;
      }
      NSString* orderNo = paramsDic[@"order_no"];
      if (orderNo.length==0) {
        [OCJProgressHUD ocj_showHudWithTitle:@"订单号为空" andHideDelay:2];
        return;
      }
      
      OCJOnlinePayVC* vc = [[OCJOnlinePayVC alloc]init];
      vc.ocjDic_router = @{@"orders":@[orderNo]};
      [self ocj_pushVC:vc];
    
    }else if ([action isEqualToString:@"detail"]){//跳转商品详情
      if (![paramsDic isKindOfClass:[NSDictionary class]]) {
        [OCJProgressHUD ocj_showHudWithTitle:@"商品参数不对" andHideDelay:2];
        return;
      }
      
      NSString* itemCode = paramsDic[@"itemCode"];
    
      [self ocj_jumpToRNGoodDetailPageWithItemCode:itemCode];
      
    }else if ([action isEqualToString:@"cart"]){
      NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
      [mDic setValue:@"CartPage" forKey:@"targetRNPage"];
      [mDic setValue:self.ocjStr_fromPage forKey:@"fromPage"];
      
      if (self.ocjNavigationController.ocjCallback) {
         self.ocjNavigationController.ocjCallback([mDic copy]);
          self.ocjBool_isWebViewDisappear = YES;
         [self ocj_popToNavigationRootVC];
      }
    }
  
}

- (void)ocj_jumpToRNGoodDetailPageWithItemCode:(NSString*)itemCode{
  
  NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
  [mDic setValue:itemCode forKey:@"itemcode"];
  
  NSString* beforePage = @"iOSocj_WebView";
  [mDic setValue:beforePage forKey:@"beforepage"];
  [mDic setValue:@"GoodsDetailMain" forKey:@"targetRNPage"];
  [mDic setValue:self.ocjStr_fromPage forKey:@"fromPage"];
  
  if (self.ocjNavigationController.ocjCallback) {
    self.ocjNavigationController.ocjCallback([mDic copy]);
    [self ocj_popToNavigationRootVC];
    
  }
}


/**
 url 解码

 @param unicodeStr unicode编码后的url
 @return 解码后的字符串
 */
- (NSString *)ocj_replaceUnicodeToUTF8Str:(NSString *)unicodeStr
{
  
  NSString*decodedString=(__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)unicodeStr,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
  
  return decodedString;
}


/**
 登录后刷新页面
 */
- (void)ocj_loginedAndLoadNetWorkData{
  
  if (self.ocjStr_loginedRefreshUrl.length>0) {
    self.ocjBool_islogin = YES;
    NSString *ocjStr = [self returnFormatString:self.ocjStr_loginedRefreshUrl];
    NSURL* url = [NSURL URLWithString:ocjStr];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 30;
    [request setValue:self.ocjStr_accessToken forHTTPHeaderField:@"X-access-token"];
    [self.ocjWebView loadRequest:request];
  }
}

- (NSString *)returnFormatString:(NSString *)str
{
  return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}


/**
 返回url比对表

 @param urlStr 待比对url
 */
-(BOOL)ocj_checkIsBackUrl:(NSString*)urlStr{
  NSString *ocjStr_plistPath = [[NSBundle mainBundle] pathForResource:@"RN_BackUrls" ofType:@"plist"];
  NSArray *ocjArr_plist = [[NSArray alloc] initWithContentsOfFile:ocjStr_plistPath];
  
  for (NSString* backUrlStr in ocjArr_plist) {
      if ([backUrlStr isEqualToString:urlStr]) {
        
        
          if ([urlStr isEqualToString:@"http://m.ocj.com.cn/cart.jhtml"]) {
              self.ocjNavigationController.ocjCallback(@{@"targetRNPage":@"CartPage",@"fromPage":self.ocjStr_fromPage});
              self.ocjBool_isWebViewDisappear = YES;
              [self ocj_popToNavigationRootVC];
          }else {
              [self ocj_back];
          }
          return YES;
          break;
      }
  }
  
  return NO;
}

-(void)ocj_showHud{
  self.ocjHud = [OCJProgressHUD ocj_showHudWithView:self.ocjWebView andHideDelay:0];//加载loading视图
}

-(void)ocj_hideHud{
  
  if (self.ocjHud) {
    [self.ocjHud ocj_hideHud];
    [self.ocjHud removeFromSuperview];
    self.ocjHud = nil;
  }
}

- (void)WebViewJavascriptBridgeMethod{
  
  //初始化&注册WebViewJavascriptBridg
  
  _bridge = [WebViewJavascriptBridge bridgeForWebView:self.ocjWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
    NSLog(@"ObjC received message from JS: %@", data);
    responseCallback(@"Response for message from ObjC");
  }];
  
  // 传网络状态值给后台
  __weak __typeof(self) weakSelf = self;
  [_bridge registerHandler:@"OCJAppNetWorkStatues" handler:^(id data, WVJBResponseCallback responseCallback)
   {
     NSString *statues = [weakSelf OCJAppNetWorkStatues];
     responseCallback(statues);
   }];
}


- (NSString *)OCJAppNetWorkStatues{
  if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
    return @"WIFI";
  }
  return @"";
}

#pragma mark - getter
-(NSString *)ocjStr_accessToken{
  NSDictionary* dic = [OCJUserInfoManager ocj_getTokenForRN];
  return dic[@"token"];
}

-(UIView *)ocjView_failure{
  if (!_ocjView_failure) {
    _ocjView_failure = [[OCJFailureView alloc]initWithFrame:self.view.bounds imageType:OCJFailureTypeNetwork delegate:self];
  
    
  }
  return _ocjView_failure;
}

#pragma mark - setter
- (void)setOcjDic_router:(NSDictionary *)ocjDic_router{
  _ocjDic_router = ocjDic_router;
  self.ocjStr_url = self.ocjDic_router[@"url"];
  
  self.ocjStr_fromPage = @"";
  NSString* rn_fromPage = [ocjDic_router[@"fromPage"]description];
  if (rn_fromPage.length>0) {
    self.ocjStr_fromPage = rn_fromPage;
  }
  
  self.ocjStr_europe = @"";
  NSString *ocjStr = [[ocjDic_router objectForKey:@"europe"] description];
  if ([ocjStr length] > 0) {
    self.ocjStr_europe = ocjStr;
  }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
  
  NSString* jumpUrl = request.URL.absoluteString;
  
  // url拦截
  if ([jumpUrl containsString:@"eventbarragevideo"]) {// 直播SDK  如果是直播sdk就不用网页上加载了
//    [self.navigationController popViewControllerAnimated:NO];
    [OCJJZLiveLoginManager ocj_jzliveManagerWithString:jumpUrl];
    return NO;
  }
  //======================优先级一 拦截规则==》遇到上传请求，不做任何处理直接加载
  if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
    return YES;
  }
  
  if ([jumpUrl isEqualToString:@"about:blank"]) {
      return NO;
  }
  
  //======================优先级二 拦截规则==》按拦截名单，拦截返回事件
  if ([self ocj_checkIsBackUrl:jumpUrl]) {
    
    return NO;
  };
  
  self.ocjRequest = request;//保留request
  [self ocj_showHud];
  
  //======================优先级三 拦截规则==》识别与H5的约定的#字暗号规则
  NSArray* urlArray;
  BOOL isJumpCipher =  [jumpUrl containsString:@"#"];
  if (isJumpCipher) {
    urlArray = [jumpUrl componentsSeparatedByString:@"#"];
    if (urlArray.count>=2) {//以#为分割符获取暗号
      NSString* urlJsonStr = [urlArray lastObject];
      
      if (urlJsonStr.length>0) {//暗号不能为空
        urlJsonStr  = [self ocj_replaceUnicodeToUTF8Str:urlJsonStr];//反编码
        NSData* jsonData = [urlJsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        if ([jsonDic isKindOfClass:[NSDictionary class]]) {
          OCJLog(@"跳转暗号信息：%@",jsonDic);
          [self ocj_dealWithJumpMessage:jsonDic];
          self.ocjBool_isWebViewDisappear = YES;
          [self ocj_hideHud];
          return NO;
        }else{
          
          [self ocj_hideHud];
          return YES;
        }
      }else{
        
        [self ocj_back];//东东客服返回规则（单个#号）
      }
    }
  }
  
  //======================优先级四 拦截规则==》拦截需跳原生app的商品详情但不带#的url
  NSArray* goodDetailUrls = @[@"m.ocj.com.cn/detail/",@"m.ocj.com.hk/detail/",@"www.ocj.com.cn/qr/detail"];
  BOOL isDetail = [jumpUrl containsString:@"/mobileappdetail/"];
  if (isDetail) {
    urlArray = [jumpUrl componentsSeparatedByString:@"/mobileappdetail/"];
    
    if (urlArray.count<2) {
      [OCJProgressHUD ocj_showHudWithTitle:[NSString stringWithFormat:@"商品链接缺少商品Itemcode\n%@",self.ocjStr_url] andHideDelay:5];
      
      [self ocj_hideHud];
      return NO;
    }
    
    NSString* itemCodeStr = urlArray[1];
    NSString* itemCode = [[itemCodeStr componentsSeparatedByString:@"?"]firstObject];
    if (![WSHHRegex wshh_isNumString:itemCode]) {//如果itemCode不是纯数字，则继续加载，不跳app原生商品详情
      return YES;
    }
    
    NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
    [mDic setValue:itemCode forKey:@"itemcode"];
    [mDic setValue:@"GoodsDetailMain" forKey:@"targetRNPage"];

    [mDic setValue:self.ocjStr_fromPage forKey:@"fromPage"];
    
    if ([jumpUrl containsString:@"isBone=1"]) {//特价商品标识
      [mDic setValue:@"1" forKey:@"isBone"];
    }
    
    BOOL isNoNeedBackUrl = NO;//YES:不需要返回当前页 NO:需要返回当前页
    for (NSString* goodDetailUrl in goodDetailUrls) {
      if ([self.ocjStr_url containsString:goodDetailUrl]) {
        isNoNeedBackUrl = YES;
        break;
      }
    }
    
    if (self.ocjNavigationController.ocjCallback ) {
      
      self.ocjBool_isWebViewDisappear = YES;
      if (isNoNeedBackUrl) {
        
        self.ocjNavigationController.ocjCallback([mDic copy]);
        [self.navigationController popViewControllerAnimated:NO];
      }else{
        NSString* beforePage = @"iOSocj_WebView";
        [mDic setValue:beforePage forKey:@"beforepage"];
        self.ocjNavigationController.ocjCallback([mDic copy]);
        [self ocj_popToNavigationRootVC];
      }
    }
    
    [self ocj_hideHud];
    return NO;
  }
  
  //================去注册页面===========
  BOOL isRegisterRequest = [jumpUrl containsString:@"customers/emp/new/method1/rednumber"];
  if (isRegisterRequest) {
    OCJQuickRegisterVC* vc =  [[OCJQuickRegisterVC alloc]init];
    OCJBaseNC* nc = [[OCJBaseNC alloc]initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
    [self ocj_hideHud];
    return NO;
  }
  
  //=========================== 所有非与原生交互的请求都需要在http 的header中添加登录凭证参数
  NSDictionary *requestHeaders = request.allHTTPHeaderFields;
  if ([jumpUrl isEqualToString:@"http://ha.ocj.com.cn/storage.html#_ha"]){
    
    [self ocj_hideHud];
    return NO;
  }else if (requestHeaders[@"X-access-token"]) {
    
    OCJLog(@"requestHeader:%@",requestHeaders);
    return YES;
    
  } else if(requestHeaders[@"Accept"]){
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setValue:self.ocjStr_accessToken forHTTPHeaderField:@"X-access-token"];
    self.ocjRequest = [mutableRequest copy];
    [self.ocjWebView loadRequest:mutableRequest];
    
    OCJLog(@"requestHeader:%@",mutableRequest.allHTTPHeaderFields);
    
    [self ocj_hideHud];
    return NO;
  }
  //===================
  
  return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
  
  OCJLog(@"ocjRequest:%@",webView.request);
  
  NSString*   jsonStr =@"document.documentElement.innerHTML";
  NSString*   htmlStr = [webView stringByEvaluatingJavaScriptFromString:jsonStr];
  OCJLog(@"ocjHtml:%@",htmlStr);
  
  OCJLog(@"%s",__PRETTY_FUNCTION__);
  
  [self ocj_hideHud];
  [self.ocjView_failure removeFromSuperview];
  
  self.ocjRequest = nil;
  [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
  
  self.ocjRequest = webView.request;
  OCJLog(@"failureUrl:%@",webView.request.URL.absoluteString);
  OCJLog(@"%s \n %zi \n%@",__PRETTY_FUNCTION__,error.code,error);
  [self ocj_hideHud];
  
  if (error.code == -1200) {
    NSURLConnection* urlConnection = [[NSURLConnection alloc] initWithRequest:webView.request delegate:self];
    
    [urlConnection start];
  }
  
//  //显示错误视图
//  if (!self.ocjBool_isWebViewDisappear) {
//    [self.ocjWebView addSubview:self.ocjView_failure];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//  }

}

#pragma mark - OCJFailureViewDelegate
-(void)ocj_failureView:(OCJFailureView*)failurlView andClickRefreshButton:(UIButton*)refreshButton{
  
  [failurlView removeFromSuperview];
  [self.ocjWebView loadRequest:self.ocjRequest];
  
}



@end
