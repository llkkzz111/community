//
//  OCJBaseVC.m
//  OCJ
//
//  Created by yangyang on 17/4/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"
#import "NSString+WSHHExtension.h"


@interface OCJBaseVC ()

@end

@implementation OCJBaseVC

#pragma mark - 接口方法实现区域（包括setter、getter方法）
-(void)ocj_pushVC:(OCJBaseVC*)vc{
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)ocj_modelVC:(UIViewController*)vc{
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

-(void)ocj_back{
    
    if (self.navigationController.viewControllers.count>1) {
      
        [self.navigationController popViewControllerAnimated:YES];
      
    }else if(self.presentingViewController ){
      
        [self dismissViewControllerAnimated:YES completion:^{
          
          if (self.ocjBlock_backDone) {
            self.ocjBlock_backDone();
          }
          
        }];
      
    }else if ( self.navigationController.presentingViewController){
      
      [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        if (self.ocjBlock_backDone) {
          self.ocjBlock_backDone();
        }
        
      }];
      
    }
}

-(void)ocj_popToNavigationRootVC{
  
  if (self.navigationController) {
    NSMutableArray* viewControllers = [self.navigationController.viewControllers mutableCopy];
    
    OCJLog(@"vcs:%@",viewControllers);
    [viewControllers removeObjectAtIndex:0];
    [AppDelegate ocj_getShareAppDelegate].ocjArr_beforeVCsToRN = [viewControllers copy];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
  }
}

-(void)ocj_setLeftItemTitles:(NSArray<NSString*> *)titles selectorNames:(NSArray<NSString*> *)selectorNames;{
    NSMutableArray* mArr_RightItems = [NSMutableArray arrayWithCapacity:titles.count];
    
    for (NSUInteger i=0; i<titles.count; i++) {
        NSString* title = titles[i];
        SEL selector = NSSelectorFromString(selectorNames[i]);
        if (![title isKindOfClass:[NSString class]] || title.length==0) {
            
            NSAssert(0, @"按钮标题格式设置错误");
        }
        
        if (![self respondsToSelector:selector]) {
            
            NSAssert(0, @"按钮点击响应方法设置错误");
        }
        
        OCJBaseButton * ocj_rightBut = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
        ocj_rightBut.ocjFont = [UIFont systemFontOfSize:15];
        CGFloat width = [title wshh_getWidthWithFont:[UIFont systemFontOfSize:15] height:21];
        [ocj_rightBut setTitle:title forState:UIControlStateNormal];
        ocj_rightBut.frame =  CGRectMake(0, 10, width, 21);
        ocj_rightBut.titleLabel.textAlignment = NSTextAlignmentRight;
        [ocj_rightBut setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
        [ocj_rightBut addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:ocj_rightBut];
        
        [mArr_RightItems addObject:rightItem];
    }
    
    self.navigationItem.leftBarButtonItems = [mArr_RightItems copy];
}

-(void)ocj_setRightItemImageNames:(NSArray<NSString*> *)images selectorNames:(NSArray<NSString*> *)selectorNames{
    NSMutableArray* mArr_RightItems = [NSMutableArray arrayWithCapacity:images.count];
    
    for (NSUInteger i=0; i<images.count; i++) {
        NSString* imagename = images[i];
        SEL selector = NSSelectorFromString(selectorNames[i]);
        if (![imagename isKindOfClass:[NSString class]] || imagename.length==0) {
            
            NSAssert(0, @"按钮标题格式设置错误");
        }
        
        if (![self respondsToSelector:selector]) {
            
            NSAssert(0, @"按钮点击响应方法设置错误");
        }
        
        OCJBaseButton * ocj_rightBut = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
      
        [ocj_rightBut setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
      
        UIImage *imageSel = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel", imagename]];
        if (imageSel) {
          [ocj_rightBut setBackgroundImage:imageSel forState:UIControlStateSelected];
        }
      
        ocj_rightBut.frame =  CGRectMake(0, 10, 22, 22);
        [ocj_rightBut addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:ocj_rightBut];
        
        [mArr_RightItems addObject:rightItem];
    }
    
    self.navigationItem.rightBarButtonItems = [mArr_RightItems copy];

}

-(void)ocj_setRightItemTitles:(NSArray<NSString *> *)titles selectorNames:(NSArray<NSString *> *)selectorNames{
    NSMutableArray* mArr_RightItems = [NSMutableArray arrayWithCapacity:titles.count];
    
    for (NSUInteger i=0; i<titles.count; i++) {
        NSString* title = titles[i];
        SEL selector = NSSelectorFromString(selectorNames[i]);
        if (![title isKindOfClass:[NSString class]] || title.length==0) {
           
            NSAssert(0, @"按钮标题格式设置错误");
        }
        
        if (![self respondsToSelector:selector]) {
            
            NSAssert(0, @"按钮点击响应方法设置错误");
        }
        
        UIButton * ocj_rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
        ocj_rightBut.titleLabel.font = [UIFont systemFontOfSize:15];
        CGFloat width = [title wshh_getWidthWithFont:[UIFont systemFontOfSize:15] height:21];
        [ocj_rightBut setTitle:title forState:UIControlStateNormal];
        ocj_rightBut.frame =  CGRectMake(0, 10, width, 21);
        ocj_rightBut.titleLabel.textAlignment = NSTextAlignmentRight;
        [ocj_rightBut setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
        [ocj_rightBut addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:ocj_rightBut];
        
        [mArr_RightItems addObject:rightItem];
    }
    
    self.navigationItem.rightBarButtonItems = [mArr_RightItems copy];
}

- (void)ocj_loginedAndLoadNetWorkData{
    
    
}

#pragma mark - 生命周期方法区域
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setBackBarButton];
    [OCJ_NOTICE_CENTER addObserver:self selector:@selector(ocj_loginedAndLoadNetWorkData) name:OCJ_Notice_Logined object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  
    if (self.ocjStr_trackPageID.length>0) {
        NSString* pageVersion = self.ocjStr_trackPageVersion.length==0?@"V1":self.ocjStr_trackPageVersion;
        [OcjStoreDataAnalytics trackPageEnd:self.ocjStr_trackPageID];
    }
}

-(void)dealloc{
    [OCJ_NOTICE_CENTER removeObserver:self];
    
    OCJLog(@"%@ 页面已释放",NSStringFromClass([self class]));
}

#pragma mark - 私有方法区域



/**
 自定义导航栏左边按钮
 */
-(void)setBackBarButton{
    if (!self.navigationController) {
        return;
    }
    
    self.navigationItem.hidesBackButton = YES;
    OCJBaseButton * button = [OCJBaseButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 50, 44) ;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, button.frame.size.width-15);

    if (self.navigationController.viewControllers.count>1) {
        
        [button setImage:[UIImage imageNamed:@"naviBackImage"] forState:UIControlStateNormal] ;
        [button setImage:[UIImage imageNamed:@"naviBackImage"] forState:UIControlStateHighlighted] ;
    }else if (self.navigationController.presentingViewController){
        
        [button setImage:[UIImage imageNamed:@"modelBackImage"] forState:UIControlStateNormal] ;
        [button setImage:[UIImage imageNamed:@"modelBackImage"] forState:UIControlStateHighlighted] ;
    }
    
    [button addTarget:self action:@selector(ocj_back) forControlEvents:UIControlEventTouchUpInside] ;
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc]initWithCustomView:button] ;
    
    self.navigationItem.leftBarButtonItem = backButton;
}

-(void)ocj_trackEventID:(NSString *)eventID parmas:(NSDictionary *)parmas{
  
  if (eventID.length==0) {
    return;
  }
  
  NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
  if ([parmas isKindOfClass:[NSDictionary class]]) {
    mDic = [NSMutableDictionary dictionaryWithDictionary:parmas];
  }
  
  if (self.ocjStr_trackPageID.length>0) {
    [mDic setObject:self.ocjStr_trackPageID forKey:@"pID"];
  }
  
  if (self.ocjStr_trackPageVersion.length>0) {
    [mDic setObject:self.ocjStr_trackPageVersion forKey:@"vID"];
  }
  
  [OcjStoreDataAnalytics trackEvent:eventID label:nil parameters:[mDic copy]];
}

#pragma mark - setter
-(void)setOcjStr_trackPageID:(NSString *)ocjStr_trackPageID{
  _ocjStr_trackPageID = ocjStr_trackPageID;
  if (ocjStr_trackPageID.length>0) {
    NSString* pageVersion = self.ocjStr_trackPageVersion.length==0?@"V1":self.ocjStr_trackPageVersion;
    [OcjStoreDataAnalytics trackPageBegin:[NSString stringWithFormat:@"%@%@",ocjStr_trackPageID,pageVersion]];
  }
}

#pragma mark - getter

- (OCJBaseNC *)ocjNavigationController{
  if (self.navigationController) {
    return (OCJBaseNC*)self.navigationController;
  }
  
  return nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    OCJLog(@"=================================内存警告，请注意=================================");
}

@end

