//
//  OCJProgressHUD.m
//  OCJ
//
//  Created by yangyang on 2017/4/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJProgressHUD.h"

@interface OCJProgressHUD ()
@property (nonatomic) NSInteger ocjInt_count; ///< 相同视图添加hud数量
@end

@implementation OCJProgressHUD


+ (void)ocj_showHudWithTitle:(NSString *)title andHideDelay:(int)hideDelay{
    if (![title wshh_stringIsValid]) {
        return;
    }
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    OCJBaseLabel* label = [window viewWithTag:10002];
    if (!label) {
        label = [[OCJBaseLabel alloc]init];
        label.tag = 10002;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        label.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
        [window addSubview:label];
        
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:5];
    }
    
    CGRect frame = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    if (frame.size.width<=SCREEN_WIDTH-80) {
        label.mj_w = frame.size.width+50;
        label.mj_h = 70;
    }else{
        frame = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil];
        label.mj_w = SCREEN_WIDTH-32;
        label.mj_h = frame.size.height+40;
    }
    
    label.text = title;
    label.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0-100);
    
    if (hideDelay>0) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((hideDelay-0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                
                label.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                [label removeFromSuperview];
            }];
            
        });
    }
    [window bringSubviewToFront:label];
}

+(OCJProgressHUD *)ocj_showHudWithView:(UIView *)view andHideDelay:(NSInteger)hideDelay{
    
  
  OCJProgressHUD* hud1 = (OCJProgressHUD*)[OCJProgressHUD HUDForView:view];
  if (hud1) {
    hud1.ocjInt_count++;
    return hud1;
  }
  
  OCJProgressHUD* hud = [[OCJProgressHUD alloc]initWithView:view];
  hud.ocjInt_count = 1;
  hud.mode = MBProgressHUDModeCustomView;
  hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
  hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
  hud.removeFromSuperViewOnHide = YES;
  
  
  UIImageView* customView = [[UIImageView alloc]init];
//  customView.layer.cornerRadius = 40;
//  customView.layer.masksToBounds = true;
  customView.frame = CGRectMake(0, 0, 80, 80);
//  customView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
  customView.animationImages = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"progressHub1"],
                                [UIImage imageNamed:@"progressHub2"],
                                [UIImage imageNamed:@"progressHub3"],
                                [UIImage imageNamed:@"progressHub4"],
                                [UIImage imageNamed:@"progressHub5"],
                                [UIImage imageNamed:@"progressHub6"],
                                [UIImage imageNamed:@"progressHub7"],
                                [UIImage imageNamed:@"progressHub8"],
                                [UIImage imageNamed:@"progressHub9"],nil];
  customView.animationDuration = 1.0;
  customView.animationRepeatCount = 0;
  [customView startAnimating];
  CGFloat centX = SCREEN_WIDTH/2;
  CGFloat centY = SCREEN_HEIGHT/2 - 32;
  customView.center = CGPointMake(centX, centY);
  
  hud.minSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
  hud.margin = -2.0f;
  //    hud.customView = customView;
  [hud addSubview:customView];
  
  //    hud.label.text = @"正在载入...";
  //    hud.label.font = [UIFont systemFontOfSize:18];
  //    hud.label.textColor = OCJ_COLOR_DARK;
  //    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
  //    hud.color = [UIColor whiteColor];
  
  
  //旋转动画
  //    CABasicAnimation* rotationAnimation;
  //    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  //    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
  //    rotationAnimation.duration = 1;
  //    rotationAnimation.cumulative = YES;
  //    rotationAnimation.removedOnCompletion = NO;
  //    rotationAnimation.repeatCount = MAXFLOAT;
  //    [customView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
  
  [view insertSubview:hud atIndex:view.subviews.count+1];
  [hud showAnimated:YES];
  
  
  if (hideDelay>0) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [hud ocj_hideHud];
    });
  }
  
  return hud;
}

-(void)ocj_hideHud{
    self.ocjInt_count--;
  
    if (self.ocjInt_count==0) {
        [self hideAnimated:YES];
    }
    
}

+(void)ocj_showAlertByVC:(UIViewController *)vc withAlertType:(OCJAlertType)alertType title:(NSString *)title message:(NSString *)message sureButtonTitle:(NSString *)sureButtonTitle CancelButtonTitle:(NSString *)cancelButtonTitle action:(WSHHBlockAlertAction)alertAction{
    
    UIImage* customImage;
    switch (alertType) {
        case OCJAlertTypeFailure:
            customImage = [UIImage imageNamed:@"alertBGImage"];
            break;
        case OCJAlertTypeSuccessSendEmail:
            customImage = [UIImage imageNamed:@"alertImage_sendEmail"];
            break;
        case OCJAlertTypeSuccessBindTelephone:
            customImage = [UIImage imageNamed:@"alertImage_bindingTel"];
            break;
        case OCJAlertTypeNone:customImage = nil;break;
    }
    
    [WSHHAlert wshh_showAlertByVC:vc withCustomImage:customImage title:title message:message sureButtonTitle:sureButtonTitle CancelButtonTitle:cancelButtonTitle action:alertAction presentCompleletion:^(UIAlertController *alertController) {
        //对官方的alertView做一些属性调整
            [self logSubviewsForView:alertController.view boldTitle:sureButtonTitle];
    }];
}


+(void)logSubviewsForView:(UIView*)view boldTitle:(NSString*)boldTitle{
    
    for (UIView* subView in view.subviews) {
        //        OCJLog(@"subView:%@",subView);
        
        if ([subView isKindOfClass:NSClassFromString(@"_UIInterfaceActionItemSeparatorView_iOS")]) {
            subView.backgroundColor = [UIColor colorWSHHFromHexString:@"#F5A99E"];
            subView.alpha = 0.3;
        }
        
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel* boldLabel = (UILabel*)subView;
            if ([boldLabel.text isEqualToString:boldTitle]) {
                boldLabel.font = [UIFont boldSystemFontOfSize:boldLabel.font.pointSize];
            }
        }
        
        if (subView.subviews.count>0) {
            [self logSubviewsForView:subView boldTitle:boldTitle];
        }
    }
    
}
@end
