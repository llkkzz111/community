//
//  OCJSignInTipVC.m
//  OCJ
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSignInTipVC.h"
#import "POP.h"
#import "OCJHttp_signInAPI.h"

@interface OCJSignInTipVC (){
    OCJBaseLabel *daysNumLab;   ///< 签到天数.
    OCJBaseLabel *rewardDesLab; ///<签到福利详情提示.
    OCJBaseLabel *normalLab;    ///< 普通签到3秒后消失提示.
    NSTimer      *timer;        ///< 延迟3s关闭页面.
    OCJBaseButton *btn;         ///< 礼包背景按钮.
    OCJBaseButton *cancelBtn;   ///< 取消按钮.
    int i;
}

@end

@implementation OCJSignInTipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    i = 3;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    cancelBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.hidden = YES;
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-10);
        make.width.height.equalTo(@(70*0.5));
    }];
    [cancelBtn setImage:[UIImage imageNamed:@"icon_close_"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(ocj_dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    
    [self ocj_setupViews];
    

    [self ocj_presentAnimation];
}


#pragma mark --页面布局
- (void)ocj_setupViews{
    btn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    btn.adjustsImageWhenHighlighted = NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_popbg"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        //1032 773背景图比例
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH-32));
        make.height.equalTo( @((SCREEN_WIDTH-32)*773/1032.0) );
        make.top.offset(368*0.5);
    }];
    
    daysNumLab = [[OCJBaseLabel alloc] init];
    daysNumLab.textColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
    daysNumLab.font = [UIFont systemFontOfSize:21];
    [btn addSubview:daysNumLab];
    [daysNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.top.offset(380*(SCREEN_WIDTH-32)/1380.0); //1380:380 btn宽度和daynumlab距离顶部的比例
    }];
    
    rewardDesLab = [[OCJBaseLabel alloc] init];
    rewardDesLab.textColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
    [btn addSubview:rewardDesLab];
    rewardDesLab.font = [UIFont systemFontOfSize:17];
    [rewardDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.top.equalTo(daysNumLab.mas_bottom).offset(67.5*0.5);
    }];
    
    [self ocj_setupBottomView];
}

#pragma mark 底部布局
- (void)ocj_setupBottomView{
    switch (self.signVCType) {
        case OCJSignInTipVCTypeLottery:{
            [self ocj_setupTwoBtn];
        }break;
            
        case OCJSignInTipVCTypeMember:{
            [self ocj_setupTwoBtn];
        }break;
            
        default:{//非15天和20天
            normalLab = [[OCJBaseLabel alloc] init];
            normalLab.font = [UIFont systemFontOfSize:15];
            normalLab.textColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
            normalLab.text = @"3秒后自动关闭...";
            [btn addSubview:normalLab];
            [normalLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn);
                make.bottom.offset(-15);
            }];
            [self ocj_startTimer];
        }break;
    }
    [self setModelData];
}

- (void)ocj_startTimer{
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ocj_disappearAction:) userInfo:nil repeats:YES];
    [timer fire];
}

#pragma mark 底部按钮布局
- (void)ocj_setupTwoBtn{
    
//    100:100:1032:516 背景图片矩形到边框的比例
    
    CGFloat btnWidth = SCREEN_WIDTH-32;
    OCJBaseButton *refusedBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [btn addSubview:refusedBtn];
    [refusedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn);
        make.height.equalTo(@45);
        make.left.offset(btnWidth*100/1032.0-1);
    }];
    refusedBtn.backgroundColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
    refusedBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [refusedBtn setTitle:@"暂不领取" forState:UIControlStateNormal];
    [refusedBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#FF5136"] forState:UIControlStateNormal];
    [refusedBtn addTarget:self action:@selector(ocj_refusedAction) forControlEvents:UIControlEventTouchUpInside];
    
    OCJBaseButton *agreeBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [btn addSubview:agreeBtn];
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn);
        make.height.equalTo(@45);
        make.right.offset(-btnWidth*100/1032.0);
        make.left.equalTo(refusedBtn.mas_right).offset(1);
        make.width.equalTo(refusedBtn);
    }];
    agreeBtn.backgroundColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
    agreeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [agreeBtn setTitle:@"领取礼包" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#FF5136"] forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(ocj_agreddAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --按钮事件
#pragma mark 拒绝领取
- (void)ocj_refusedAction{
    [self ocj_dismissSelf];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [WSHHAlert wshh_showHudWithTitle:@"您可前往个人中心继续\n领取查看签到礼包哟~" andHideDelay:2];
  });
}

#pragma mark 同意领取
- (void)ocj_agreddAction{
    [timer invalidate];
    timer = nil;
    
    if (self.view.pop_animationKeys.count>0) {
        return;
    }
    
    if (self.signVCType == OCJSignInTipVCTypeMember) {
        self.view.userInteractionEnabled = NO;
        cancelBtn.hidden = NO;
        [OCJHttp_signInAPI sign20Gift_inSignInSize:@"" CompletionHandler:^(OCJBaseResponceModel *responseModel) {
            if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
                
                if (self.status) {
                    self.status(YES);
                }
                
                POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
                animation.duration = 0.5;
                animation.toValue = [UIColor clearColor];
                [self.view pop_addAnimation:animation forKey:@"viewBackColor"];
                [animation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
                    if (finished) {
                        POPBasicAnimation *disappearAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
                        disappearAnimation.duration = 0.5;
                        disappearAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake( SCREEN_WIDTH*0.5, -SCREEN_HEIGHT*0.5)];
                        [self.view pop_addAnimation:disappearAnimation forKey:@"disappearAni"];
                        [disappearAnimation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
                            if (finished) {
                                [self dismissViewControllerAnimated:NO completion:^{
                                    //                                if (self.agreeReceive) {
                                    //                                    self.agreeReceive(self.signVCType);
                                    //                                }
                                    [WSHHAlert wshh_showHudWithTitle:@"领取成功" andHideDelay:2];
                                }];
                            }
                        }];
                    }
                }];
            }else{
                self.view.userInteractionEnabled = YES;
                cancelBtn.hidden = NO;
                if (self.status) {
                    self.status(NO);
                }
            }
            
        }];
    }else{
        self.view.userInteractionEnabled = NO;
        cancelBtn.hidden = NO;
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
        animation.duration = 0.5;
        animation.toValue = [UIColor clearColor];
        [self.view pop_addAnimation:animation forKey:@"viewBackColor"];
        [animation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
            if (finished) {
                POPBasicAnimation *disappearAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
                disappearAnimation.duration = 0.5;
                disappearAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake( SCREEN_WIDTH*0.5, -SCREEN_HEIGHT*0.5)];
                [self.view pop_addAnimation:disappearAnimation forKey:@"disappearAni"];
                [disappearAnimation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
                    if (finished) {
                        [self dismissViewControllerAnimated:NO completion:^{
                            if (self.agreeReceive) {
                                self.agreeReceive(self.signVCType);
                            }
                        }];
                    }
                }];
            }
        }];
    }
}

#pragma mark 3s消失
- (void)ocj_disappearAction:(NSTimer *)afterTimer{
    normalLab.text = [NSString stringWithFormat:@"%d秒后自动关闭...", i];
    i--;
    if (i==-1) {
        [afterTimer invalidate];
        afterTimer = nil;
        timer = nil;
        [self ocj_dismissSelf];
    }
}

#pragma mark --模态消失
- (void)ocj_dismissSelf{
    [timer invalidate];
    timer = nil;
    
    [self ocj_dismissAnimation];
}

- (void)setModelData{
    switch (self.signVCType) {
        case OCJSignInTipVCTypeLottery:{
            NSMutableAttributedString *strAM = [[NSMutableAttributedString alloc] initWithString:@"已签到15天"];
            [strAM addAttribute:NSForegroundColorAttributeName value:[UIColor colorWSHHFromHexString:@"#FFD363"] range:NSMakeRange( 3, 2)];
            [strAM addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange( 3, 2)];
            
            daysNumLab.attributedText = strAM;
            rewardDesLab.text = @"恭喜您可领取福彩礼包啦~";
        }break;
        case OCJSignInTipVCTypeMember:{
            NSMutableAttributedString *strAM = [[NSMutableAttributedString alloc] initWithString:@"已签到20天"];
            [strAM addAttribute:NSForegroundColorAttributeName value:[UIColor colorWSHHFromHexString:@"#FFD363"] range:NSMakeRange( 3, 2)];
            [strAM addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange( 3, 2)];
            daysNumLab.attributedText = strAM;
            rewardDesLab.text = @"恭喜您可领取会员礼包啦~";
        }break;
        default:{
            NSString *strNormal = [NSString stringWithFormat:@"已签到%lu天", (unsigned long)self.signVCType];
            NSMutableAttributedString *strAM = [[NSMutableAttributedString alloc] initWithString:strNormal];
            [strAM addAttribute:NSForegroundColorAttributeName value:[UIColor colorWSHHFromHexString:@"#FFD363"] range:NSMakeRange( 3, 2)];
            [strAM addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange( 3, 2)];
            daysNumLab.attributedText = strAM;
            
            if (self.signVCType < 15) {
                rewardDesLab.text = [NSString stringWithFormat:@"再签到%lu天可领福彩礼包哦~", 15-(unsigned long)self.signVCType];
            }else if (self.signVCType < 20){
                rewardDesLab.text = [NSString stringWithFormat:@"再签到%lu天可获得会员礼包哦~", 20-(unsigned long)self.signVCType];
            }else{
                rewardDesLab.text = [NSString stringWithFormat:@"已签到%lu天", (unsigned long)self.signVCType];
            }
            
            
        }break;
    }
}

#pragma mark -- 模态动画
#pragma mark 模态弹出动画
- (void)ocj_presentAnimation{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    springAnimation.springSpeed = 10;
    springAnimation.springBounciness = 10;
    springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake( SCREEN_WIDTH*0.5, -SCREEN_HEIGHT*0.5)];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake( SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.5)];
    [self.view pop_addAnimation:springAnimation forKey:@"spring"];
    [springAnimation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
        if (finished) {
            cancelBtn.hidden = NO;
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
            animation.duration = 0.5;
            animation.toValue = [UIColor colorWSHHFromHexString:@"#000000" alpha:0.5019f];
            [self.view pop_addAnimation:animation forKey:@"viewBackColor"];
        }
    }];
}

#pragma mark 模态消失动画
- (void)ocj_dismissAnimation{
    
    if (self.view.pop_animationKeys.count>0) {
        return;
    }
    
    self.view.userInteractionEnabled = NO;
    cancelBtn.hidden = NO;
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    animation.duration = 0.5;
    animation.toValue = [UIColor clearColor];
    [self.view pop_addAnimation:animation forKey:@"viewBackColor"];
    
    [animation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
        if (finished) {
            POPBasicAnimation *disappearAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            disappearAnimation.duration = 0.5;
            disappearAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake( SCREEN_WIDTH*0.5, -SCREEN_HEIGHT*0.5)];
            [self.view pop_addAnimation:disappearAnimation forKey:@"disappearAni"];
            [disappearAnimation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
                if (finished) {
                    [self.view pop_removeAllAnimations];
                    [self dismissViewControllerAnimated:NO completion:^{
                      
//                        [WSHHAlert wshh_showHudWithTitle:@"您可前往个人中心继续\n领取查看签到礼包哟~" andHideDelay:2];
                      
                    }];
                }
            }];
        }
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
