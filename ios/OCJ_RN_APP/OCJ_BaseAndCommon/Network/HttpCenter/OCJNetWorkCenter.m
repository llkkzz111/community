//
//  OCJNetWorkCenter.m
//  OCJ
//
//  Created by yangyang on 2017/4/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJNetWorkCenter.h"
#import "OCJProgressHUD.h"
#import "AppDelegate+OCJExtension.h"
#import <AFNetworking.h>
#import "OCJSMGView.h"

static NSString* ocjBaseUrl = @"https://m1.ocj.com.cn:443"; ///< 正式环境https域名地址
//static NSString* ocjBaseUrl = @"http://ocj-test1.ocj.com.cn"; ///< 测试服务器根域名地址
//static NSString* ocjBaseUrl = @"http://10.22.218.162"; ///< 测试服务器根域名地址

//#ifdef DEBUG  // 调试状态
//static NSString* ocjBaseUrl = @"http://10.22.218.162"; ///< 测试服务器根域名地址
//#else   // 发布状态
//static NSString* ocjBaseUrl = @"https://m1.ocj.com.cn:443"; ///< 正式环境https域名地址
//#endif

static NSInteger ocjHttpRequestTimeoutInterval = 60; ///< 请求超时时间

@implementation OCJNetWorkCenter
#pragma mark - 接口方法实现区域
+ (instancetype)sharedCenter{
    static dispatch_once_t onceTaken;
    static OCJNetWorkCenter * sharedCenter;
    dispatch_once(&onceTaken, ^{
        sharedCenter = [[OCJNetWorkCenter alloc]init];
    });
    return sharedCenter;
}

#pragma mark - 请求主体方法
-(void)ocj_POSTWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *)parameters andLodingType:(OCJHttpLoadingType)loadingType completionHandler:(OCJHttpResponseHander)handler{
    [AppDelegate ocj_dismissKeyboard];//收起键盘
    
    //loading视图处理
    UIViewController* topVC = [AppDelegate ocj_getTopViewController];
    UIView* loadingView = topVC.view;
    UIWindow* keyWindow = [AppDelegate ocj_getShareAppDelegate].window;
    for (UIView* view in keyWindow.subviews) {
        if ([view isKindOfClass:[OCJSMGView class]]) {
            loadingView = keyWindow;
        }
    }
    OCJProgressHUD* hud;
    switch (loadingType) {
        case OCJHttpLoadingTypeBegin:
            hud = [OCJProgressHUD ocj_showHudWithView:loadingView andHideDelay:2];
            break;
            
        case OCJHttpLoadingTypeBeginAndEnd:
            hud = [OCJProgressHUD ocj_showHudWithView:loadingView andHideDelay:0];
            break;
        default:
            break;
    }
    
    if (loadingType != OCJHttpLoadingTypeNone) {
        if (![self ocj_checkNetworkIsNormal]) {
            [WSHHAlert wshh_showHudWithTitle:@"网络情况异常，请检查设备网络" andHideDelay:2];
            [hud ocj_hideHud];
            return;
        }
    }
  
    //请求处理
    NSData* postBody = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString* str = [[NSString alloc]initWithData:postBody encoding:NSUTF8StringEncoding];
    OCJLog(@"发送请求%@%@：%@",ocjBaseUrl,urlPath,str);
    
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  
    if ([ocjBaseUrl hasPrefix:@"https"]) {
      [manager setSecurityPolicy:[OCJNetWorkCenter ocj_customSecurityPolicy]];
    }

    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", ocjBaseUrl, urlPath];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:requestUrl
                                                                                parameters:nil
                                                                                     error:nil];
    request.timeoutInterval = ocjHttpRequestTimeoutInterval;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request =  [self ocj_setHttpHeader:request];
    [request setHTTPBody:postBody];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    manager.responseSerializer = responseSerializer;
    
    __weak OCJNetWorkCenter* weakSelf = self;
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            [weakSelf ocj_dealWithFailureResponseWithError:error completionHandler:handler];
        }else{
            [weakSelf ocj_dealWithSuccessResponse:responseObject urlPath:urlPath completionHandler:handler];
        }
        
        if (hud) {
            [hud ocj_hideHud];
        }
    }] resume];
    
}

-(void)ocj_fromData_POSTWithUrlPath:(NSString *)urlPath prameters:(NSDictionary*)parmeters files:(NSArray<NSDictionary*> *)files andLodingType:(OCJHttpLoadingType)loadingType completionHandler:(OCJHttpResponseHander)handler{
    [AppDelegate ocj_dismissKeyboard];//收起键盘
    
    //loading视图处理
    UIViewController* topVC = [AppDelegate ocj_getTopViewController];
    OCJProgressHUD* hud;
    switch (loadingType) {
        case OCJHttpLoadingTypeBegin:
            hud = [OCJProgressHUD ocj_showHudWithView:topVC.view andHideDelay:2];
            break;
            
        case OCJHttpLoadingTypeBeginAndEnd:
            hud = [OCJProgressHUD ocj_showHudWithView:topVC.view andHideDelay:0];
            break;
        default:
            break;
    }
    
    if (![self ocj_checkNetworkIsNormal]) {
        [WSHHAlert wshh_showHudWithTitle:@"网络情况异常，请检查设备网络" andHideDelay:2];
        [hud ocj_hideHud];
        return;
    }
  
    //请求处理
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", ocjBaseUrl, urlPath];
    OCJLog(@"发送请求%@：%@",requestUrl,parmeters);
    AFHTTPSessionManager* manager = [self ocj_setHttp];
    [self ocj_setHttpHeader:manager.requestSerializer];

    if ([ocjBaseUrl hasPrefix:@"https"]) {
        [manager setSecurityPolicy:[OCJNetWorkCenter ocj_customSecurityPolicy]];
    }

    __weak OCJNetWorkCenter* weakSelf = self;
    [manager POST:requestUrl parameters:parmeters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSDictionary* dic in files) {
            if (![dic isKindOfClass:NSDictionary.class]) {
                [WSHHAlert wshh_showHudWithTitle:@"传文件时请遵照接口格式打包数据" andHideDelay:2];
                return ;
            }
            
            NSData*     fileValue = dic[@"data"];
            OCJLog(@"图片大小：%f",fileValue.length/1000000.0);
            NSString*   fileKey = dic[@"key"];
            [formData appendPartWithFileData:fileValue name:fileKey fileName:[NSString stringWithFormat:@"%@.png",fileKey] mimeType:@"png"];
        }
      
      
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf ocj_dealWithSuccessResponse:responseObject urlPath:urlPath completionHandler:handler];
        
        if (hud) {
            [hud ocj_hideHud];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf ocj_dealWithFailureResponseWithError:error completionHandler:handler];
        
        if (hud) {
            [hud ocj_hideHud];
        }
        
    }];
}



-(void)ocj_GETWithUrlPath:(NSString *)urlPath parameters:(NSDictionary *)parameters andLodingType:(OCJHttpLoadingType)loadingType completionHandler:(OCJHttpResponseHander)handler{
    [AppDelegate ocj_dismissKeyboard];//收起键盘
    
    //loading视图处理
    UIViewController* topVC = [AppDelegate ocj_getTopViewController];
    UIView* loadingView = topVC.view;
    UIWindow* keyWindow = [AppDelegate ocj_getShareAppDelegate].window;
    for (UIView* view in keyWindow.subviews) {
        if ([view isKindOfClass:[OCJSMGView class]]) {
            loadingView = keyWindow;
        }
    }
    OCJProgressHUD* hud;
    switch (loadingType) {
        case OCJHttpLoadingTypeBegin:
            hud = [OCJProgressHUD ocj_showHudWithView:loadingView andHideDelay:2];
            break;
        case OCJHttpLoadingTypeBeginAndEnd:
            hud = [OCJProgressHUD ocj_showHudWithView:loadingView andHideDelay:0];
            break;
        default:
            break;
    }
  
    OCJLog(@"发送请求%@%@：%@",ocjBaseUrl,urlPath,parameters);
    
    AFHTTPSessionManager* manager = [self ocj_setHttp];
    [self ocj_setHttpHeader:manager.requestSerializer];
    if ([ocjBaseUrl hasPrefix:@"https"]) {
        [manager setSecurityPolicy:[OCJNetWorkCenter ocj_customSecurityPolicy]];
    }

    __weak OCJNetWorkCenter* weakSelf = self;
    [manager GET:urlPath parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //对下载进度进行处理
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakSelf ocj_dealWithSuccessResponse:responseObject urlPath:urlPath completionHandler:handler];
        
        if (hud) {
            [hud ocj_hideHud];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf ocj_dealWithFailureResponseWithError:error completionHandler:handler];
        if (hud) {
            [hud ocj_hideHud];
        }
    }];
}


#pragma mark - 私有方法实现区域
/**
 GET请求设置http-head
 */
-(AFHTTPSessionManager*)ocj_setHttp{
    
    //Http 相关设置
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:ocjBaseUrl]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = ocjHttpRequestTimeoutInterval;
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    manager.responseSerializer = responseSerializer;
    
    return manager;
}


/**
 在http header中添加通用参数
 */
-(NSMutableURLRequest*)ocj_setHttpHeader:(id)request{
  
  NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  NSString* deviceID = [[NSUserDefaults standardUserDefaults]objectForKey:OCJDeviceID];
  NSString* accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:OCJAccessToken];
  if (!([accessToken length] > 0)) {
    accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:OCJAccessToken_guest];
  }
  NSDictionary* userProvinceDic = [[NSUserDefaults standardUserDefaults] objectForKey:OCJUserInfo_Province];
  NSString* netType = @"OTHER";
  if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
      netType = @"WIFI";
  }else if ([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN){
      netType = @"4G";
  }
  
  
  if ([request isKindOfClass:[AFHTTPRequestSerializer class]]) {
    
    AFHTTPRequestSerializer* newRequest = (AFHTTPRequestSerializer*)request;
    
    [request setValue:@"IOS" forHTTPHeaderField:@"X-msale-way"];
    [request setValue:appVersion forHTTPHeaderField:@"X-version-info"];
    [request setValue:@"TM" forHTTPHeaderField:@"X-msale-code"];
    [request setValue:deviceID forHTTPHeaderField:@"X-device-id"];
    [request setValue:deviceID forHTTPHeaderField:@"X-jiguang-id"];
    [request setValue:accessToken forHTTPHeaderField:@"X-access-token"];
    [request setValue:netType forHTTPHeaderField:@"X-net-type"];
    if ([userProvinceDic isKindOfClass:[NSDictionary class]]) {
      [request setValue:userProvinceDic[@"region_cd"] forHTTPHeaderField:@"X-region-cd"];
      [request setValue:userProvinceDic[@"sel_region_cd"] forHTTPHeaderField:@"X-sel-region-cd"];
      [request setValue:userProvinceDic[@"substation_code"] forHTTPHeaderField:@"X-substation-code"];
    }
    
    OCJLog(@"af-requestHeader:%@",[newRequest HTTPRequestHeaders]);
    
    return nil;//AF的request无需返回值
    
  }else if ([request isKindOfClass:[NSURLRequest class]]){
    NSURLRequest* newRequest = (NSURLRequest*)request;
    NSMutableURLRequest* mutableRequest = [newRequest mutableCopy];
    
    [mutableRequest addValue:@"IOS" forHTTPHeaderField:@"X-msale-way"];
    [mutableRequest addValue:appVersion forHTTPHeaderField:@"X-version-info"];
    [mutableRequest addValue:@"TM" forHTTPHeaderField:@"X-msale-code"];
    [mutableRequest addValue:deviceID forHTTPHeaderField:@"X-device-id"];
    [mutableRequest addValue:deviceID forHTTPHeaderField:@"X-jiguang-id"];
    [mutableRequest addValue:accessToken forHTTPHeaderField:@"X-access-token"];
    [mutableRequest addValue:netType forHTTPHeaderField:@"X-net-type"];
    if ([userProvinceDic isKindOfClass:[NSDictionary class]]) {
      [request addValue:userProvinceDic[@"region_cd"] forHTTPHeaderField:@"X-region-cd"];
      [request addValue:userProvinceDic[@"sel_region_cd"] forHTTPHeaderField:@"X-sel-region-cd"];
      [request addValue:userProvinceDic[@"substation_code"] forHTTPHeaderField:@"X-substation-code"];
    }
    
    OCJLog(@"ns-requestHeader:%@",[mutableRequest allHTTPHeaderFields]);
    return  mutableRequest;
  }
  
  return nil;
}

/**
 检测网络可用性
 */
-(BOOL)ocj_checkNetworkIsNormal{
    BOOL isRechable = [AFNetworkReachabilityManager sharedManager].isReachable;
    return isRechable;
}


/**
 处理http成功响应
 */
- (void)ocj_dealWithSuccessResponse:(id)responseObject urlPath:(NSString*)urlPath completionHandler:(OCJHttpResponseHander)handler{
    
    OCJBaseResponceModel* responceModel = [[OCJBaseResponceModel alloc]init];
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        
        [responceModel setValuesForKeysWithDictionary:responseObject];
        
        //调试日志=========
        NSData* data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString* str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        OCJLog(@"接口返回%@:%@",urlPath,str);
        
    }else if([responseObject isKindOfClass:[NSData class]]){
        NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (!resultDic) {//服务器返回格式非json
            NSString* str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            OCJLog(@"接口返回%@:%@",urlPath,str);
            
            responceModel.ocjStr_code = @"-1";
            responceModel.ocjStr_message = @"服务器返回数据非json";
          
            return ;
        }
        
        [responceModel setValuesForKeysWithDictionary:resultDic];
        
        //调试日志=========
        if ([resultDic isKindOfClass:[NSDictionary class]]) {
            NSData* data = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString* str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            OCJLog(@"接口返回%@:%@",urlPath,str);
        }else{
            OCJLog(@"接口返回%@:%@",urlPath,resultDic);
        }
      
    }else{
        
        responceModel.ocjStr_code = @"-1";
        responceModel.ocjStr_message = @"服务器出问题了";
    }
  
    if ([urlPath isEqualToString:@"/api/members/checking/token"] || [urlPath isEqualToString:@"/api/members/loginrules/login_by_access_code"]  || [urlPath isEqualToString:@"/api/members/sites/substations"] || [urlPath isEqualToString:@"/api/members/loginrules/login_by_visit"]|| [urlPath isEqualToString:@"/api/members/app/ver/check"] || [urlPath isEqualToString:@"/api/members/opoints/sign/mcontent"]) {//检测token是属于访客还是会员，不过筛子
        handler(responceModel);
        return;
    }
  
    if (![self ocj_dealWithAccessTokenLoseEfficacyWithResponceModel:responceModel urlPath:urlPath]) {//过一遍accessToken的筛子
        handler(responceModel);
    };
}


/**
 发送token失效的通知
 */
- (BOOL)ocj_dealWithAccessTokenLoseEfficacyWithResponceModel:(OCJBaseResponceModel*)model urlPath:(NSString*)urlPath{
    
    if ([model.ocjStr_code isEqualToString:@"4011"] || [model.ocjStr_code isEqualToString:@"4012"] || [model.ocjStr_code isEqualToString:@"4013"] || [model.ocjStr_code isEqualToString:@"4014"] || [model.ocjStr_code isEqualToString:@"4010"]) {
        
        [OCJ_NOTICE_CENTER postNotificationName:OCJNotice_NeedLogin object:nil];
//      [OCJProgressHUD ocj_showAlertByVC:[AppDelegate ocj_getTopViewController] withAlertType:OCJAlertTypeFailure title:@"提示" message:urlPath sureButtonTitle:@"确定" CancelButtonTitle:nil action:nil];
        return YES;
    }else{
        return NO;
    }
}


/**
 处理http失败响应
 */
- (void)ocj_dealWithFailureResponseWithError:(NSError*)error completionHandler:(OCJHttpResponseHander)handler{
    
    OCJBaseResponceModel* responceModel = [[OCJBaseResponceModel alloc]init];
    responceModel.ocjStr_code = @"-2";
    responceModel.ocjStr_message = @"网络请求失败";
    handler(responceModel);
  
    OCJLog(@"接口错误：%@",error.description);
  
    NSString* errorUrl =  error.userInfo[@"NSErrorFailingURLKey"];
    if ([errorUrl isKindOfClass:[NSURL class]]) {
      NSURL* url = (NSURL*)errorUrl;
      errorUrl  = [url absoluteString];
    }
  
    if ([errorUrl containsString:@"/api/members/checking/token"] || [errorUrl containsString:@"/api/members/sites/substations"]) {
        return;
    }
  
//    [WSHHAlert wshh_showHudWithTitle:error.localizedDescription andHideDelay:2];
  
}


+ (AFSecurityPolicy*)ocj_customSecurityPolicy
{
  // /先导入证书
  NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ocj" ofType:@"cer"];//证书的路径
  NSData *certData = [NSData dataWithContentsOfFile:cerPath];
  
  // AFSSLPinningModeCertificate 使用证书验证模式
  AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
  
  // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
  // 如果是需要验证自建证书，需要设置为YES
  securityPolicy.allowInvalidCertificates = NO;
  
  //validatesDomainName 是否需要验证域名，默认为YES；
  //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
  //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
  //如置为NO，建议自己添加对应域名的校验逻辑。
  securityPolicy.validatesDomainName = YES;
  
  securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
  
  return securityPolicy;
}

@end
