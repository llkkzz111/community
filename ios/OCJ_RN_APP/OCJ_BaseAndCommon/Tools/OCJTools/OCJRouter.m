//
//  OCJRouter.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/25.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRouter.h"
#import "AppDelegate+OCJExtension.h"
#import "OCJSMGView.h"
#import "OCJChooseGoodsSpecView.h"

@interface OCJRouter ()

@property (nonatomic,strong) NSDictionary* ocjDic_routerTable; ///< 路由表字典

@property (nonatomic,strong) UIViewController* ocjHostController; ///< 跳转控制器

@end



@implementation OCJRouter

+ (instancetype)ocj_shareRouter{
    static OCJRouter* shareRouter;
    static dispatch_once_t t = 0;
    
    dispatch_once(&t, ^{
        shareRouter = [[self alloc]init];
    });
    return shareRouter;
}


- (UIViewController*)ocj_openVCWithType:(OCJRouterOpenType)type routerKey:(NSString *)routerKey parmaters:(NSDictionary *)parmaters{
    if (!routerKey || routerKey.length==0) {
        [WSHHAlert wshh_showHudWithTitle:@"调用原生界面需要传入路由表对应Key" andHideDelay:5];
        return nil;
    }
    
    NSDictionary* routerDic = self.ocjDic_routerTable[routerKey];
    
    if (!routerDic) {
        [WSHHAlert wshh_showHudWithTitle:@"路由表对应Key不匹配\n未查到对应页面\n请检查" andHideDelay:5];
        return nil;
    }
    
    Class class = NSClassFromString(routerDic[@"vcName"]);
    NSAssert(class, @"%@页面没找到",routerDic[@"vcName"]);
  
  if ([class isSubclassOfClass:[UIViewController class]]) {
    UIViewController* vc = (UIViewController*)[[class alloc]init];
    vc.navigationController.navigationBar.hidden = NO;
    if ([vc respondsToSelector:@selector(setOcjDic_router:)] && [parmaters isKindOfClass:[NSDictionary class]]) {
        [vc setValue:parmaters forKey:@"ocjDic_router"];
    }
    
    UIViewController* topVC = [AppDelegate ocj_getTopViewController];
    if ([topVC isKindOfClass:class]) {//如果将要推出的控制器与导航栈顶部的控制器重复
      return topVC;
    }
    
    switch (type) {
      case OCJRouterOpenTypePresent:
      {
        
        OCJBaseNC* navC = [[OCJBaseNC alloc]initWithRootViewController:vc];
        
        if ([routerDic[@"vcName"] isEqualToString:@"OCJ_RN_WebViewVC"]) {//H5广告页，动画从上向下出现
          navC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
          navC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        }
        [self.ocjHostController presentViewController:navC animated:YES completion:nil];
        
      }break;
      case OCJRouterOpenTypePush:
      {
        vc.hidesBottomBarWhenPushed = YES;
        
        NSArray* rnBeforeVCs = [AppDelegate ocj_getShareAppDelegate].ocjArr_beforeVCsToRN;
        
        BOOL isContainRnRootVC = NO;//检测保留导航栈中是否存在将要推出的控制器
        for (UIViewController* rnRootVC in rnBeforeVCs) {
          if ([rnRootVC isKindOfClass:class]) {
            isContainRnRootVC = YES;
            break;
          }
        }
        
        BOOL isRePush = NO;//计算RN的目的是推出新的控制器还是调起老的控制器（yes-调起老的<保留导航栈>  no-推出新的）
        if ([routerDic[@"vcName"] isEqualToString:@"OCJ_RN_WebViewVC"]) {
          NSString* url = parmaters[@"url"] == nil ? @"" : parmaters[@"url"];
          if ([url isKindOfClass:[NSString class]]) {
            isRePush = (url.length==0);
          }
        }else{
          isRePush = YES;
        }
        
        if (isContainRnRootVC &&  isRePush) {//RN要调起保留栈中的控制器，并且保留栈中也存在此控制器
          NSMutableArray* mArray = [NSMutableArray arrayWithObject:self.ocjHostController];
          [mArray addObjectsFromArray:rnBeforeVCs];
          [self.ocjHostController.navigationController setViewControllers:[mArray copy] animated:NO];
          [AppDelegate ocj_getShareAppDelegate].ocjArr_beforeVCsToRN = nil;//去除对原生导航栈的保留
          
          return [rnBeforeVCs firstObject];
        }else if(!isContainRnRootVC && isRePush && [routerDic[@"vcName"] isEqualToString:@"OCJ_RN_WebViewVC"]){//RN要调起保留栈中的WebVC，但是保留栈中不存在此控制器时不做响应
          
          return nil;
        }else{//否则重新初始化控制器
          
          [self.ocjHostController.navigationController pushViewController:vc animated:YES];
        }

        
      }break;
    }
    
    return vc;
  }else if([class isSubclassOfClass:[OCJSMGView class]]){
    
    [OCJSMGView ocj_popCompletion:nil];
    
    return nil;
  }else {
    
    return nil;
  }
}


#pragma mark - getter
- (NSDictionary *)ocjDic_routerTable{
    if (!_ocjDic_routerTable) {
        _ocjDic_routerTable = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"router" ofType:@"plist"]];
        NSAssert(_ocjDic_routerTable, @"router表没取到");
    }
    
    return _ocjDic_routerTable;
}

- (UIViewController *)ocjHostController{
    if (!_ocjHostController) {
      OCJBaseNC* naviVC = (OCJBaseNC*)[AppDelegate ocj_getShareAppDelegate].window.rootViewController;
      _ocjHostController = (OCJBaseVC*)[naviVC.viewControllers firstObject];
    }
  
    return _ocjHostController;
}
@end
