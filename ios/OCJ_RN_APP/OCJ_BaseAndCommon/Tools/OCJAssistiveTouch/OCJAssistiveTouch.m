//
//  OCJAssistiveTouch.m
//  OCJ
//
//  Created by apple on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJAssistiveTouch.h"
#import "POP.h"
#import "OCJHttp_signInAPI.h"
#import "OCJAssistiveBtn.h"
#import "OCJLocationTool.h"

#define TouchWidth 190*0.5 //按钮宽度
#define TouchHeight 339*0.5 //按钮高度

//#define BtnWidth 140*0.5 //弹出的签到按钮的宽度
#define BtnWidth 260*0.5 //弹出的签到按钮的宽度

@interface OCJAssistiveTouch (){
    OCJAssistiveBtn *btn;///< 小鸟.
    OCJBaseButton *signBtn;///< 签到按钮.
}
@property (nonatomic, assign) OCJAssistiveTouchType type;///< 子视图遮挡间距类型.
@property (nonatomic, assign) UIEdgeInsets aroundOffset;///< 上下左右间距.


@end

@implementation OCJAssistiveTouch

+ (instancetype)ocj_appearAssistiveTouchFrame:(CGRect)frame superView:(UIView *)view appearType:(OCJAssistiveTouchType)styleType{
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, TouchWidth, TouchHeight);
    OCJAssistiveTouch *touch = [[[self class] alloc] initWithFrame:newFrame superstyle:styleType aroundOffset:UIEdgeInsetsZero];
    
    [view addSubview:touch];
    if (touch) {
        return touch;
    }
    return nil;
}

+ (instancetype)ocj_appearAssistiveTouchFrame:(CGRect)frame superView:(UIView *)view aroundOffset:(UIEdgeInsets)aroundOffset{
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, TouchWidth, TouchWidth);
    OCJAssistiveTouch *touch = [[[self class] alloc] initWithFrame:newFrame superstyle:OCJAssistiveTouchTypeCustomOffset aroundOffset:aroundOffset];
    
    [view addSubview:touch];
    if (touch) {
        return touch;
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame superstyle:(OCJAssistiveTouchType)type aroundOffset:(UIEdgeInsets)aroundOffset{
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        self.aroundOffset = aroundOffset;
        [self ocj_setupViews];
    }
    return self;
}

- (void)ocj_setupViews{
    __weak typeof(self) weakSelf = self;
    btn = [[OCJAssistiveBtn alloc] init];
    btn.aroundOffset = self.aroundOffset;
    btn.dragble = NO;
    btn.superStyleType = self.type;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    btn.backgroundColor = [UIColor clearColor];
//    [btn setResponserClickAction:^{
//        [weakSelf ocj_backAction];
//    }];
//    [btn setDragingAction:^{
//        [weakSelf ocj_removeSignBtn];
//    }];
    [self ocj_backAction];
}

#pragma mark masonry布局或者frame布局 判断初始图片的指向
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.center.x <= self.superview.bounds.size.width*0.5) {
//        [btn setImage:[UIImage imageNamed:@"icon_ou_right"] forState:UIControlStateNormal];
    }else{
//        [btn setImage:[UIImage imageNamed:@"icon_ou_left"] forState:UIControlStateNormal];
    }
}

#pragma mark 移除签到按钮
- (void)ocj_removeSignBtn{
    if (signBtn && signBtn.superview) {
        [signBtn removeFromSuperview];
        return;
    }
}

#pragma mark 显示或者移除签到按钮
- (void)ocj_backAction{
    if (signBtn && signBtn.superview) {
        [signBtn removeFromSuperview];
        return;
    }
    
    signBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    signBtn.contentMode = UIControlContentHorizontalAlignmentCenter;
//    [self.superview addSubview:signBtn];
  [self addSubview:signBtn];
//    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
    signBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    if (self.center.x <= self.superview.bounds.size.width*0.5) {
        [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self).offset(5);
//            make.left.equalTo(self.mas_right).offset(-20);
//            make.width.equalTo(@(BtnWidth));
//            make.height.equalTo( @(BtnWidth*107/131) );
          make.edges.equalTo(self);
        }];
        [signBtn setBackgroundImage:[UIImage imageNamed:@"icon_btnbg_right"] forState:UIControlStateNormal];
    }else{
        [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self).offset(5);
//            make.right.equalTo(self.mas_left).offset(20);
//            make.width.equalTo(@(BtnWidth));
//            make.height.equalTo( @(BtnWidth*107/131) );
          make.edges.equalTo(self);
        }];
        [signBtn setBackgroundImage:[UIImage imageNamed:@"icon_btnbg_left"] forState:UIControlStateNormal];
    }
    
    [signBtn addTarget:self action:@selector(ocj_signAction:) forControlEvents:UIControlEventTouchUpInside];
    [self ocj_customSingBtnAnimation];
}

#pragma mark 自定义签到按钮动画
- (void)ocj_customSingBtnAnimation{
    if (signBtn && signBtn.superview && !self.isNoAppearAnimation) {
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        springAnimation.springSpeed = 20;
        springAnimation.springBounciness = 10;
        springAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
        springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake( 1, 1)];
        [signBtn pop_addAnimation:springAnimation forKey:@"springAnimation"];
    }

}

#pragma mark 调用接口获取天数
- (void)ocj_signAction:(OCJBaseButton *)btn2{
//    调用签到接口 获取签到天数
    [OCJHttp_signInAPI OCJRegister_getSigningRecordcheck_inCompletionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            
//            static NSUInteger daysTyep = 15;//接口返回天数
//            
//            if (daysTyep == 15) {
//                daysTyep = 10;
//            }else if (daysTyep == 10){
//                daysTyep = 18;
//            }else if (daysTyep == 18){
//                daysTyep = 20;
//            }else{
//                daysTyep = 15;
//            }
//            接口天数赋值
            [self dismissSelf];//签到成功 移除视图
            
            NSDictionary *dict = responseModel.ocjDic_data;
            NSInteger daysTyep = [dict[@"days"] integerValue]; //接口返回天数
            
            if (self.touchAction) {
                [btn2 removeFromSuperview];
                self.touchAction(daysTyep);
            }
        }
    }];
}

#pragma mark 签到完成 移除页面
- (void)dismissSelf{
    [self ocj_removeSignBtn];
    
    if (self.isNoDismissAnimation) {
        [self removeFromSuperview];
    }else{
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        scaleAnimation.duration = 1.0f;
        scaleAnimation.toValue = @(0);
      __weak OCJAssistiveTouch* weakSelf = self;
        [scaleAnimation setCompletionBlock:^(POPAnimation *pop, BOOL finished){
            if (finished) {
                [weakSelf pop_removeAllAnimations];
                [weakSelf removeFromSuperview];
            }
        }];
        [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}

#pragma mark 获取地址信息样例子
#pragma mark 类方法获取地址信息
+ (void)ocj_classGetLocation:(void(^)(NSDictionary *ad, NSDictionary *local))backAddressDoneBlock{
  [[OCJLocationTool shareInstanceAndStartLocation] setOcjBackAddressAndLocation:^(NSDictionary *address, NSDictionary *location) {
    
    if (backAddressDoneBlock) {
      backAddressDoneBlock(address, location);
    }
  }];
}

@end
