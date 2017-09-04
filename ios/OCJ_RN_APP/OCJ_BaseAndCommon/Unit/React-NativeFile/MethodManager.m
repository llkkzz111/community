	//
//  MethodManager
//  AwesomeProject
//
//  Created by daihaiyao on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//
// CalendarManager.m

#import "MethodManager.h"
#import "AppDelegate+OCJExtension.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "OCJFontAdapter.h"
#import "OCJRouter.h"
#import "OCJSelectAddressVC.h"
#import "OCJHomePageVC.h"
#import "OCJSettingCenterVC.h"
#import "OCJScanVC.h"
#import "OCJAddressSheetView.h"
#import "OCJSharePopView.h"
#import "OCJVipAreaVC.h"
#import "OCJVideoComingVC.h"
#import "OCJGlobalShoppingVC.h"
#import "OCJLoginVC.h"
#import "OCJOnlinePayVC.h"
#import "OCJ_RN_WebViewVC.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>

@implementation MethodManager
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()



//界面跳转
RCT_EXPORT_METHOD(pushToPage:(NSDictionary *)param callback:(RCTResponseSenderBlock)callback)
{
  OCJHomePageVC *home = [self getHomePage];
  home.ocjCallback = nil;
  //清理一下通知
  if ([param[@"page" ] isEqualToString:@"init"]) {
    [self ocj_addObserver];
    callback(@[[NSNull null],@"init"]);
    return ;
  }
  
    NSLog(@"ios param ==== %@",param);
  //获取页面标志
    NSString *log = [param[@"page"] componentsSeparatedByString:@"/"].lastObject;
  //弹出界面方式
    OCJRouterOpenType openType;
  //登录是modal方式
    if ([param[@"openType"] isEqualToString:@"present"])
    {
        openType = OCJRouterOpenTypePresent;
    }else{
        openType = OCJRouterOpenTypePush;
    }
  
  
    if ([log isEqualToString:@"SelectArea"]) {//选择配送区域 homepage弹出
        [self showSelectArea:callback];
  
    }else if ([log isEqualToString:@"Share"]) {//分享 homepage弹出
      
        [self showSharePopView:param[@"param"]];
    }else{
      
      switch (openType) {
        case OCJRouterOpenTypePresent:
        {
          
          if([log isEqualToString:@"Login"]){//调起登录页面
            
              [[AppDelegate ocj_getShareAppDelegate]ocj_reLogin];
            
          }else{
              UIViewController *vc = [[OCJRouter ocj_shareRouter]ocj_openVCWithType:OCJRouterOpenTypePresent
                                                           routerKey:param[@"page"]
                                                           parmaters:param[@"param"]];
              [vc.navigationController setNavigationBarHidden:NO];
          }
          OCJHomePageVC *home = [self getHomePage];
          home.ocjCallback = ^(NSDictionary *dict){
            if(dict){
              callback(@[[NSNull null],@{@"tokenType":@"guest"}]);
            }else{
              NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getTokenAbout]];
              [dict setObject:@"self" forKey:@"tokenType"];
              callback(@[[NSNull null],dict]);
            }
            
          };
        }break;
        case OCJRouterOpenTypePush:
        {
          
          if([log isEqualToString:@"Login"]){//调起登录页面
            
            [[AppDelegate ocj_getShareAppDelegate]ocj_reLogin];
            
            return;
          }
          NSDictionary *ocjDic_param = param[@"param"];
          UIViewController *vc;
          if ([ocjDic_param isKindOfClass:[NSDictionary class]]) {
            vc = [[OCJRouter ocj_shareRouter]ocj_openVCWithType:OCJRouterOpenTypePush
                                                                        routerKey:param[@"page"]
                                                                        parmaters:ocjDic_param];
          }else {
            vc = [[OCJRouter ocj_shareRouter]ocj_openVCWithType:OCJRouterOpenTypePush
                                                                        routerKey:param[@"page"]
                                                                        parmaters:@{}];
          }
          
          //展开导航栏
          [vc.navigationController setNavigationBarHidden:NO];
          
          //选择地址回调
          if ([log isEqualToString:@"SelectAddress"]) {
            OCJSelectAddressVC *address = (OCJSelectAddressVC *)vc;
            address.ocjSelectedAddrBlock = ^(OCJAddressModel_listDesc *listModel) {
              callback(@[[NSNull null],[self transformListModel:listModel]]);
            };
          //设置
          }else if([log isEqualToString:@"Setting"]){
            
//            callback(@[[NSNull null],log]);
          
          }else if([log isEqualToString:@"Pay"]){//在线支付
            
            OCJBaseNC* naviVC = (OCJBaseNC*)vc.navigationController;
            naviVC.ocjCallback = ^(NSDictionary *dict) {
              
              callback(@[[NSNull null],dict]);
            };
          
          }else if([log isEqualToString:@"Score"]){//个人中心 积分
            

          }else if([log isEqualToString:@"Global"]){//全球购
            
            OCJBaseNC* naviVC = (OCJBaseNC*)vc.navigationController;
            naviVC.ocjCallback = ^(NSDictionary *dict) {
              
              callback(@[[NSNull null],dict]);
            };
            
          }else if([log isEqualToString:@"VIP"]){//VIP专区
            
            OCJBaseNC* naviVC = (OCJBaseNC*)vc.navigationController;
            naviVC.ocjCallback = ^(NSDictionary *dict) {
              
              callback(@[[NSNull null],dict]);
            };
            
          }else if([log isEqualToString:@"Homeocj_Video"]){//视频详情
            
            OCJBaseNC* naviVC = (OCJBaseNC*)vc.navigationController;
            naviVC.ocjCallback = ^(NSDictionary *dict) {
              
              callback(@[[NSNull null],dict]);
            };
            
          }else if ([log isEqualToString:@"Sweep"]){//扫一扫
              OCJBaseNC* naviVC = (OCJBaseNC*)vc.navigationController;
            
              naviVC.ocjCallback = ^(NSDictionary *dict) {
                  NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [mdict setObject:@"Sweep" forKey:@"beforepage"];
                [mdict setValue:@"iOSocj_WebView" forKey:@"targetRNPage"];
                  callback(@[[NSNull null],mdict]);
              };
            
          }else if([log isEqualToString:@"iOSocj_WebView"]){//H5容器
              OCJBaseNC* naviVC = (OCJBaseNC*)vc.navigationController;
              if(!naviVC){
                  naviVC = [self ocj_getBaseNavigationVC];
              }
              naviVC.ocjCallback = ^(NSDictionary *dict) {
                  callback(@[[NSNull null],dict]);
              };
          }else if ([log isEqualToString:@"Reserve"]) {//预约订单
            OCJBaseNC* naviVC = (OCJBaseNC*)vc.navigationController;
            naviVC.ocjCallback = ^(NSDictionary *dict) {
              
              callback(@[[NSNull null],dict]);
            };
          }else if ([log isEqualToString:@"Valuate"]) {//评价
            OCJBaseNC* naviVC = (OCJBaseNC*)vc.navigationController;
            naviVC.ocjCallback = ^(NSDictionary *dict) {
              
              callback(@[[NSNull null],dict]);
            };
          }
        }
          break;
        default:
          callback(@[[NSNull null],@"ok"]);
          break;
      }
    }
}

//获取token
RCT_EXPORT_METHOD(getToken:(RCTResponseSenderBlock)callback)
{
  callback(@[[NSNull null],[self getTokenAbout]]);
}

//重新登录
RCT_EXPORT_METHOD(reLogin:(RCTResponseSenderBlock)callback){
  
  [[AppDelegate ocj_getShareAppDelegate]ocj_reLogin];
  callback(@[[NSNull null],@"ok"]);
}

//显示小鸟
RCT_EXPORT_METHOD(showSigns:(RCTResponseSenderBlock)callback)
{
  [[self getHomePage]ocj_showSignInView];
  callback(@[[NSNull null],@"ok"]);
}
//隐藏小鸟
RCT_EXPORT_METHOD(hideSigns:(RCTResponseSenderBlock)callback)
{
  [[self getHomePage]ocj_hideSignInView];
  callback(@[[NSNull null],@"ok"]);
}

//获取font
RCT_EXPORT_METHOD(getFont:(RCTResponseSenderBlock)callback)
{
  callback(@[[NSNull null],[@([OCJFontAdapter ocj_getFontStatues]) stringValue]]);
}


#pragma mark - 原生方法

- (void)ocj_addObserver{
  [self addPayObserver];
  [self addLoginObserver];
  [self addCenterObserver];
  [self addLogoutObserver];
  [self addLoginCancelObserver];
  [self addPushNoticeObserver];
}

//观察登录 OCJ_Notice_Logined
-(void)addLoginObserver
{
  
  [[NSNotificationCenter defaultCenter]addObserverForName:OCJ_Notice_Logined object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    OCJHomePageVC *home = [self getHomePage];
    if(home.ocjCallback){
      home.ocjCallback(nil);
       home.ocjCallback = nil;
    };
    //刷新下边导航栏156
//    [[self getHomePage]loadRN];
    [self VCOpenRN:@{@"name":OCJ_Notice_Logined,@"data":[self getTokenAbout]}];

  }];
  
}

//观察退出登录 OCJ_Notice_LoginOut
-(void)addLogoutObserver
{
  
  [[NSNotificationCenter defaultCenter]addObserverForName:OCJ_Notice_LoginOut object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    OCJHomePageVC *home = [self getHomePage];
    if(home.ocjCallback){
       home.ocjCallback(@{@"action":@"logout"});
       home.ocjCallback = nil;
    };
    //回调
    [self VCOpenRN:@{@"name":OCJ_Notice_LoginOut,@"data":[self getTokenAbout]}];//去首页
  }];
}

//取消登录 OCJ_Notice_LoginCancel
-(void)addLoginCancelObserver
{
  
  [[NSNotificationCenter defaultCenter]addObserverForName:OCJ_Notice_LoginCancel object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    OCJHomePageVC *home = [self getHomePage];
    if(home.ocjCallback){
      home.ocjCallback(@{@"action":@"cancel"});
      home.ocjCallback = nil;
    };
    //刷新下边导航栏

  }];
  
}
//观察支付 OCJ_Notification_onlinePay
-(void)addPayObserver
{
  
  [[NSNotificationCenter defaultCenter]addObserverForName:OCJ_Notification_onlinePay object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    //回调
    NSLog(@"note.userInfo = %@",note.userInfo);
    [self VCOpenRN:@{@"name":OCJ_Notification_onlinePay,@"data":note.userInfo}];//去首页
  }];
}

//观察个人中心  OCJ_Notification_personalCenter
-(void)addCenterObserver
{
  
  [[NSNotificationCenter defaultCenter]addObserverForName:OCJ_Notification_personalCenter object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    //回调
    [self VCOpenRN:@{@"name":OCJ_Notification_personalCenter,@"data":@{}}];//刷新个人中心
  }];
}

//观察推送相关消息
-(void)addPushNoticeObserver{
  
  [OCJ_NOTICE_CENTER addObserverForName:OCJ_Notification_DealPushMessage object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    //回调
    [self VCOpenRN:@{@"name":OCJ_Notification_DealPushMessage,@"data":note.userInfo?note.userInfo:@{}}];//刷新个人中心
  }];
}

//OC调用RN
RCT_EXPORT_METHOD(VCOpenRN:(NSDictionary *)dictionary){
  NSString *value=[dictionary objectForKey:@"name"];
  if([value isEqualToString:OCJ_Notice_Logined]){//登录消息
    
    [self.bridge.eventDispatcher sendAppEventWithName:@"refreshApp" body:@{@"type":@"refreshToken"}];//通知RN刷新token
    [self.bridge.eventDispatcher sendAppEventWithName:@"refreshCartData" body:dictionary[@"data"]];//刷新购物车
    [self.bridge.eventDispatcher sendAppEventWithName:@"refreshApp" body:@{@"type":@"refreshMePage"}];//刷新个人中心
    
  }else if([value isEqualToString:OCJ_Notice_LoginOut]){//退出登录消息
    
    [self.bridge.eventDispatcher sendAppEventWithName:@"refreshApp" body:dictionary[@"data"]];//通知RN刷新token
    [self.bridge.eventDispatcher sendAppEventWithName:@"refreshCartData" body:dictionary[@"data"]];//刷新购物车
    [self.bridge.eventDispatcher sendAppEventWithName:@"refreshApp" body:@{@"type":@"refreshToHomePage"}];//去首页
    
  }else if([value isEqualToString:OCJ_Notification_onlinePay]){//支付消息
    // {"code":"0","message":"失败"} code 1 成功   都是刷新购物车
    //code 2 查看订单 转订单详情 code 3 继续购物 转首页
    [self.bridge.eventDispatcher sendAppEventWithName:@"refreshCartData" body:dictionary[@"data"]];
    
  }else if([value isEqualToString:OCJ_Notification_personalCenter]){//个人中心消息
    
    [self.bridge.eventDispatcher sendAppEventWithName:@"refreshApp" body:@{@"type":@"refreshMePage"}];//type:refreshMePage 刷新个人中心
    
  }else if ([value isEqualToString:OCJ_Notification_DealPushMessage]){
    
    [self.bridge.eventDispatcher sendAppEventWithName:@"goToNativeView" body:dictionary[@"data"]?dictionary[@"data"]:@{}];//
  }
  
}

//获取首页
-(OCJHomePageVC *)getHomePage{
  OCJBaseNC* naviVC = (OCJBaseNC*)[AppDelegate ocj_getShareAppDelegate].window.rootViewController;
  OCJHomePageVC *vc = (OCJHomePageVC*)[naviVC.viewControllers firstObject];
  
  return vc;
}

-(OCJBaseNC*)ocj_getBaseNavigationVC{
  OCJBaseNC* naviVC = (OCJBaseNC*)[AppDelegate ocj_getShareAppDelegate].window.rootViewController;
  
  return naviVC;
}

//选择地区
-(void)showSelectArea:(RCTResponseSenderBlock)callback

{
  [OCJAddressSheetView ocj_popAddressSheetCompletion:^(NSDictionary *dic_address) {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic_address options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    callback(@[[NSNull null],str]);
  }];
}

//分享
-(void)showSharePopView:(NSDictionary *)dict
{
  [[OCJSharePopView sharedInstance]ocj_setShareContent:dict];
}

//转换地址
-(NSString *)transformListModel:(OCJAddressModel_listDesc *)listModel
{
  NSString *mobile1 = [NSString stringWithFormat:@"%@%@%@",listModel.ocjStr_mobile1,listModel.ocjStr_mobile2,listModel.ocjStr_mobile3];
  NSString *mobile2 = [NSString stringWithFormat:@"%@****%@",listModel.ocjStr_mobile1,listModel.ocjStr_mobile3];
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  [dict setObject:listModel.ocjStr_cust_no?listModel.ocjStr_cust_no:@"" forKey:@"cust_no"];
  [dict setObject:listModel.ocjStr_receiverName?listModel.ocjStr_receiverName:@"" forKey:@"receiverName"];
  [dict setObject:listModel.ocjStr_mobile1?mobile1:@"" forKey:@"mobile1"];
  [dict setObject:listModel.ocjStr_mobile2?mobile2:@"" forKey:@"mobile2"];
  [dict setObject:listModel.ocjStr_mobile3?listModel.ocjStr_mobile3:@"" forKey:@"mobile3"];
  [dict setObject:listModel.ocjStr_isDefault?listModel.ocjStr_isDefault:@"" forKey:@"isDefault"];
  [dict setObject:listModel.ocjStr_addrProCity?listModel.ocjStr_addrProCity:@"" forKey:@"addrProCity"];
  [dict setObject:listModel.ocjStr_addrDetail?listModel.ocjStr_addrDetail:@"" forKey:@"addrDetail"];
  [dict setObject:listModel.ocjStr_addressIDRN?listModel.ocjStr_addressIDRN:@"" forKey:@"addressID"];
  [dict setObject:listModel.ocjStr_provinceCode?listModel.ocjStr_provinceCode:@"" forKey:@"provinceCode"];
  [dict setObject:listModel.ocjStr_cityCode?listModel.ocjStr_cityCode:@"" forKey:@"cityCode"];
  [dict setObject:listModel.ocjStr_districtCode?listModel.ocjStr_districtCode:@"" forKey:@"districtCode"];
  NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
  NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
  return str;
}

//获取token字典
-(NSDictionary *)getTokenAbout
{
//  NSLog(@"[OCJUserInfoManager ocj_getTokenForRN] = %@",[OCJUserInfoManager ocj_getTokenForRN]);
  return [OCJUserInfoManager ocj_getTokenForRN];
}



/*
cust_no;           ///<顾客编号
receiverName;      ///<收货人
mobile1;           ///<手机号第一段 13544445555
mobile2;           ///<手机号第二段 135****5555
mobile3;           ///<手机号第三段
isDefault;         ///<是否是默认地址
addrProCity;       ///<收货地址省市信息
addrDetail;        ///<收货地址详细信息
addressID;         ///<地址id
provinceCode;      ///<省对应code
cityCode;          ///<市对应code
districtCode;        ///<区对应code
 
//支付回调参数 @{@"orders":@[@"20170606120342",@"20170606120344",@"20170606120346"]}];
*/

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}
@end
