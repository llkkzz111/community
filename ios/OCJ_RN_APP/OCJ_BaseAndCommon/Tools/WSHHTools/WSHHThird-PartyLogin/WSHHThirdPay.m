//
//  WSHHThirdPay.m
//  OCJ
//
//  Created by Ray on 2017/5/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "WSHHThirdPay.h"
#import "WSHHWXLogin.h"
#import "UPPaymentControl.h"
#import "WSHHAlipayLogin.h"
#import <PassKit/PassKit.h>
#import "AppDelegate+OCJExtension.h"
#import "OCJOnlinePayVC.h"
#import "UPAPayPlugin.h"
#import <objc/runtime.h>

#define URLConnect @"http://101.231.204.84:8091/sim/getacptn"
#define OCJApplePayID @"merchant.applepay.com.iappweb.ocj"

@interface WSHHThirdPay()<PKPaymentAuthorizationViewControllerDelegate,UPAPayPluginDelegate>

@property (nonatomic, strong) NSMutableData *responseData;///<返回数据

@end

@implementation WSHHThirdPay
static char PayResultActionKey; ///< handler暂存地址

+ (instancetype)sharedInstance {
    static WSHHThirdPay *thirdPay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thirdPay = [[self alloc] init];
    });
    return thirdPay;
}

#pragma mark - 调用支付接口
- (void)wshh_alipyPayWithOrder:(NSString *)singStr block:(ThirdPayCallbackBlock)block {
    self.wshhThirdPayBlock = block;
    [[WSHHAlipayLogin sharedInstance] wshhAlipayPaymentWithSignString:singStr completionHandler:^(NSDictionary *resultDic) {
        if(block){
            block(resultDic);
        }
      
    }];
}

- (void)wshh_wxPayWithOrder:(NSDictionary *)poCode block:(ThirdPayCallbackBlock)block {
    [[WSHHWXLogin sharedInstance] wshhWXPayByPoCode:poCode block:^(BaseResp *resp, enum WXErrCode errCode, NSString *prePayId) {
        //回调
        OCJLog(@"fkajslfhllkasd");
    }];
}

- (void)wshh_uPPayWithOrder:(NSString *)tn block:(ThirdPayCallbackBlock)block {
//    [self wshhStartRequestWithUrl:[NSURL URLWithString:URLConnect]];
    /*
     startPay:交易流水号
     scheme:用于引导支付控件返回
     model:'00'生产环境   '01'开发测试环境
     */
     [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"OCJUpPay" mode:@"00" viewController:[AppDelegate ocj_getTopViewController]];
  
    objc_setAssociatedObject(self, &PayResultActionKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
  
}

- (void)wshh_applePayWithOrder:(NSDictionary *)payDic block:(ThirdPayCallbackBlock)block{
    if ([self checkDeviceSupportPayments]){
      
        NSString * ocjStr_tn         = [payDic objectForKey:@"tn"];

        if (ocjStr_tn.length>0) {
            [UPAPayPlugin startPay:ocjStr_tn mode:@"00" viewController:[AppDelegate ocj_getTopViewController] delegate:self andAPMechantID:OCJApplePayID];
        
            objc_setAssociatedObject(self, &PayResultActionKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }else{
          [OCJProgressHUD ocj_showHudWithTitle:@"支付凭证获取出错" andHideDelay:2];
        }
      
      
    }
}

#pragma mark - 银联、alipay回调
/**
 支付回调(银联、支付宝)
 */
- (void)wshh_thirdPartyCompletionHandlerWithUrl:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        [self ocj_alipayHandlerWithUrl:url];
    }else if ([url.host isEqualToString:@"uppayresult"]) {
        [self ocj_uppayHandlerWithUrl:url];
    }
}

//银联支付回调
- (void)ocj_uppayHandlerWithUrl:(NSURL *)url {
    
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        if ([code isEqualToString:@"success"]) {
            OCJLog(@"UPPaySuccess");
          
            ThirdPayCallbackBlock handler = objc_getAssociatedObject(self, &PayResultActionKey);
            if (handler) {
                handler(@{@"payCode":@"200"});//支付成功回调
            }
            //如果想对结果数据验签，可使用下面这段代码，但建议不验签，直接去商户后台查询交易结果
            if(data != nil){
                //数据从NSDictionary转换为NSString
                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                   options:0
                                                                     error:nil];
                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                
                //此处的verify建议送去商户后台做验签，如要放在手机端验，则代码必须支持更新证书
                if([self verify:sign]) {
                    //验签成功
                }
                else {
                    //验签失败
                }
            }
            
            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
            OCJLog(@"UPPayFailed");
          [OCJProgressHUD ocj_showHudWithTitle:@"交易失败" andHideDelay:2];
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
            OCJLog(@"UPPayCanceled");
            [OCJProgressHUD ocj_showHudWithTitle:@"交易取消" andHideDelay:2];
        }
        
    }];
}

- (BOOL)verify:(NSString *)sign {
    
    return NO;
}

//alipay回调
- (void)ocj_alipayHandlerWithUrl:(NSURL *)url {
    __weak WSHHThirdPay *weakSelf = self;
    if ([url.host isEqualToString:@"safepay"]) {
        
        // 支付跳转支付宝钱包进行支付，处理支付结果---处理支付宝客户端返回的url（在app被杀模式下，通过这个方法获取支付结果）
        //本地安装了支付宝客户端，且成功调用支付宝客户端进行支付的情况下，会通过该completionBlock返回支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result222 = %@",resultDic);
            if (weakSelf.wshhThirdPayBlock) {
              weakSelf.wshhThirdPayBlock(resultDic);
            }
          
            NSString *status = [resultDic objectForKey:@"resultStatus"];
            
            if ([status isEqualToString:@"9000"]) {//订单支付成功
                [OCJProgressHUD ocj_showHudWithTitle:@"订单支付成功" andHideDelay:2.0f];
              
            }else if ([status isEqualToString:@"6002"]){//网络连接出错
                
            }else if ([status isEqualToString:@"8000"]) {//正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                
            }else if ([status isEqualToString:@"4000"]) {//订单支付失败
                
            }else if ([status isEqualToString:@"5000"]) {//重复请求
                
            }else if ([status isEqualToString:@"6001"]) {//用户中途取消
                
            }else if ([status isEqualToString:@"6004"]) {//支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                
            }else {//其它支付错误
                
            }
        }];
        
        //TODO:验证
        
        
        // 如果在登录授权过程中，调用方应用被系统终止，则授权方法block无效，需要调用方在appDelegate中调用processAuth_V2Result:standbyCallback:方法获取授权结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resultAuth = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode222 = %@", authCode?:@"");
        }];
        
        /*
         if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
         [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
         //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
         NSLog(@"platformapi  result = %@",resultDic);
         }
         ];
         };
         */
    }
    weakSelf.wshhThirdPayBlock = nil;
}

#pragma mark - applePay支付相关
- (BOOL)checkDeviceSupportPayments{
  
    if (![PKPaymentAuthorizationViewController class]) {

      [OCJProgressHUD ocj_showHudWithTitle:@"设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持" andHideDelay:2];
      return NO;
    }
    //检查当前设备是否可以支付
    if (![PKPaymentAuthorizationViewController canMakePayments]) {
      //支付需iOS9.0以上支持
      [OCJProgressHUD ocj_showHudWithTitle:@"设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持" andHideDelay:2];
      return NO;
    }
  
    NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
      [OCJProgressHUD ocj_showHudWithTitle:@"您的ApplePay没有绑定支付卡" andHideDelay:2];
      
      return NO;
    }
  
    return YES;
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion{
    // 一般在此处,拿到支付信息, 发送给服务器处理, 处理完毕之后, 服务器会返回一个状态, 告诉客户端,是否支付成功, 然后由客户端进行处理
    BOOL isSucess = YES;
    if (isSucess) {
        completion(PKPaymentAuthorizationStatusSuccess);
    }else{
        completion(PKPaymentAuthorizationStatusFailure);
    }
}
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    OCJLog(@"授权结束");
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - uppay
- (void)wshhStartRequestWithUrl:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [urlConnection start];
}

#pragma mark - connection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response {
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    if ([res statusCode] != 200) {
        OCJLog(@"error");
    }else {
        self.responseData = [[NSMutableData alloc] init];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *tn = [[NSMutableString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    if (tn != nil && tn.length > 0) {
        OCJLog(@"tn = %@", tn);
        [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"OCJUpPay" mode:@"01" viewController:[AppDelegate ocj_getTopViewController]];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    OCJLog(@"error = %@", error);
}

#pragma mark - UPAPayPluginDelegate
-(void) UPAPayPluginResult:(UPPayResult *) payResult{
  if (payResult.paymentResultStatus == UPPaymentResultStatusSuccess) {
    ThirdPayCallbackBlock handler = objc_getAssociatedObject(self, &PayResultActionKey);
    if (handler) {
      handler(@{@"payCode":@"200"});//支付成功回调
    }
  }else if (payResult.paymentResultStatus == UPPaymentResultStatusCancel){
    
    [OCJProgressHUD ocj_showHudWithTitle:@"取消支付" andHideDelay:2];
  }else if (payResult.paymentResultStatus == UPPaymentResultStatusFailure){
    
    [OCJProgressHUD ocj_showHudWithTitle:@"支付失败" andHideDelay:2];
  }
  
  
}


@end
