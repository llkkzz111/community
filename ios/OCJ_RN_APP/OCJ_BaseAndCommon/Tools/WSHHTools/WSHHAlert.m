//
//  WSHHAlert.m
//  OCJ
//
//  Created by yangyang on 17/4/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "WSHHAlert.h"

@implementation WSHHAlert


+(void)wshh_showHudWithTitle:(NSString *)title andHideDelay:(int)hideDelay{
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    UILabel* label = [window viewWithTag:1002];
    if (!label) {
        label = [[UILabel alloc]init];
        label.tag = 1002;
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
    
}

+(void)fx_removeHud{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    UILabel* label = [window viewWithTag:1002];
    
    if (label) {
        [label removeFromSuperview];
    }
    
}

+(void)wshh_showSheetByVC:(UIViewController *)vc withTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles action:(WSHHBlockAlertAction)alertAction{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString* actionTitle in actionTitles) {
        NSInteger index = [actionTitles indexOfObject:actionTitle];
        
        if (title.length>0) {
            [alertVC addAction:[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                alertAction(index+1);
            }]];
        }

    }
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        alertAction(0);
    }]];

    
    [vc presentViewController:alertVC animated:YES completion:^{
        
        
    }];
}

+(void)wshh_showAlertByVC:(UIViewController *)vc withCustomImage:(UIImage*)image title:(NSString *)title message:(NSString *)message sureButtonTitle:(NSString *)sureButtonTitle CancelButtonTitle:(NSString *)cancelButtonTitle action:(WSHHBlockAlertAction)alertAction presentCompleletion:(WSHHAlertControllerPresentCompletionAction)completion{
    
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //=========添加自定义logo=========
    if (image) {
        [self logSubviewsForView:alertVC.view];
        
        UIView* bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -70,270, 90)];
        bgView.layer.cornerRadius = 10.0;
        bgView.backgroundColor = [UIColor colorWSHHFromHexString:@"#F9F9F9"];
        [alertVC.view addSubview:bgView];
        
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(105, 15,60, 60)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        [bgView addSubview:imageView];
    }
    //==============================
    
    if (cancelButtonTitle.length>0) {
        UIAlertAction* cancelAlertAction =[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (alertAction) {
                alertAction(0);
            }
            
        }];
        if (OCJ_AppVersion_iOS9x) {
            [cancelAlertAction setValue:OCJ_COLOR_DARK_GRAY forKey:@"_titleTextColor"];
        }
        [alertVC addAction:cancelAlertAction];
    }
    
    if (sureButtonTitle.length>0) {
        UIAlertAction* sureAlertAction = [UIAlertAction actionWithTitle:sureButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (alertAction) {
                alertAction(1);
            }
        }];
        if (OCJ_AppVersion_iOS9x) {
            [sureAlertAction setValue:OCJ_COLOR_DARK_GRAY forKey:@"_titleTextColor"];
        }
        [alertVC addAction:sureAlertAction];
    }
    
    [vc presentViewController:alertVC animated:YES completion:^{
        if (completion) {
            completion(alertVC);
        }
    }];
    
}

+(void)logSubviewsForView:(UIView*)view{
    
    for (UIView* subView in view.subviews) {
//        OCJLog(@"subView:%@",subView);
        if ([subView isKindOfClass:NSClassFromString(@"_UIVisualEffectFilterView")]) {
            subView.backgroundColor = [UIColor colorWSHHFromHexString:@"#F9F9F9"];
        }
        
        if (subView.subviews.count>0) {
            [self logSubviewsForView:subView];
        }
    }
    
}


@end
