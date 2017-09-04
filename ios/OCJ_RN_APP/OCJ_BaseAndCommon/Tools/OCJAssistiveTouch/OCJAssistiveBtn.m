//
//  OCJAssistiveBtn.m
//  OCJ
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJAssistiveBtn.h"
#import "OCJAssistiveTouch.h"

static BOOL shouldResponser = YES;

#define RigthImage @"icon_ou_right"//小鸟指向右边
#define LeftImage @"icon_ou_left"//小鸟指向左边

@interface OCJAssistiveBtn ()

@property (nonatomic, assign)CGPoint startPos;///< 开始按下的触点坐标.

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, assign) CGFloat topOffset;///< 原有父视图顶部遮盖的偏移量.
@property (nonatomic, assign) CGFloat bottomOffset;///< 原有父视图底部遮盖的偏移量.

@property (nonatomic, assign) CGFloat leftOffset;///< 原有父视图左边部遮盖的偏移量.
@property (nonatomic, assign) CGFloat rightOffset;///< 原有父视图右边遮盖的偏移量.

@property (nonatomic, weak) UIView *topMotherView;///< 顶级父视图.

@end

@implementation OCJAssistiveBtn


#pragma mark 开始触摸，记录触点位置用于判断是拖动还是点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
  
    shouldResponser = YES;
  
    UITouch *touch = [touches anyObject];
    _startPos = [touch locationInView:self.topMotherView];
}

#pragma mark 手指按住移动过程,通过悬浮按钮的拖动事件来拖动整个悬浮窗口
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (!self.isDragble) {
    return;
  }
  
    shouldResponser = NO;
  
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:self.topMotherView];
    
    // 移动按钮到当前触摸位置
    self.superview.center = [self calculate:curPoint];
    
    if (self.dragingAction) {
        self.dragingAction();
    }
    
//    CGFloat left = curPoint.x;
//    CGFloat right = SCREEN_WIDTH - curPoint.x;
//    if (left<=right && ![self.imageName isEqualToString:RigthImage]) {
//        [self setImage:[UIImage imageNamed:RigthImage] forState:UIControlStateNormal];
//        self.imageName = RigthImage;
//    }else if ( left>right && ![self.imageName isEqualToString:LeftImage]){
//        [self setImage:[UIImage imageNamed:LeftImage] forState:UIControlStateNormal];
//        self.imageName = LeftImage;
//    }
}

#pragma mark 排除越界坐标
- (CGPoint)calculate:(CGPoint)point{
    if (point.y<_topOffset) {
        point.y = _topOffset;
    }
    if (point.y>self.topMotherView.bounds.size.height-_bottomOffset) {
        point.y = self.topMotherView.bounds.size.height-_bottomOffset;
    }
    
    if (point.x<_leftOffset) {
        point.x = _leftOffset;
    }
    if (point.x>self.topMotherView.bounds.size.width-_rightOffset) {
        point.x = self.topMotherView.bounds.size.width-_rightOffset;
    }
    return point;
}

#pragma mark 拖动结束后使悬浮窗口吸附在最近的屏幕边缘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:self.topMotherView];
  
  if (!self.isDragble) {
    if (self.responserClickAction) {
      self.responserClickAction();
    }
    return;
  }
    
    if (shouldResponser) {
        //弹出签到按钮
        if (self.responserClickAction) {
            self.responserClickAction();
        }
        return;
    }else{
    }
    
    CGFloat left = curPoint.x;
    CGFloat right = SCREEN_WIDTH - curPoint.x;
    
    CGFloat topOffset = curPoint.y-self.bounds.size.height*0.5;
    if (topOffset<0) {
        topOffset = 0;
    }
    
    if (topOffset>self.topMotherView.bounds.size.height-_bottomOffset-self.bounds.size.height) {
        topOffset = self.topMotherView.bounds.size.height-_bottomOffset-self.bounds.size.height;
    }
    
    if (left<=right) {
        [self.superview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.superview.bounds.size.width));
            make.height.equalTo(@(self.superview.bounds.size.height));
            make.left.equalTo(self.topMotherView).offset(_leftOffset);
            make.top.offset(topOffset);
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.topMotherView setNeedsLayout];
            [self.topMotherView layoutIfNeeded];
        }];
        
        [self setImage:[UIImage imageNamed:@"icon_ou_right"] forState:UIControlStateNormal];
    }else{
        [self.superview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.superview.bounds.size.width));
            make.height.equalTo(@(self.superview.bounds.size.height));
            make.right.equalTo(self.topMotherView).offset(-_rightOffset);
            make.top.offset(topOffset);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self.topMotherView setNeedsLayout];
            [self.topMotherView layoutIfNeeded];
        }];

        [self setImage:[UIImage imageNamed:@"icon_ou_left"] forState:UIControlStateNormal];
    }
}

#pragma mark 设置上下遮盖的偏移量
- (void)setSuperStyleType:(NSUInteger)superStyleType{
    _superStyleType = superStyleType;
    switch (_superStyleType) {
        case OCJAssistiveTouchTypeNone:{
            _topOffset = 0;
            _leftOffset = 0;
            _rightOffset = 0;
        }break;
        case OCJAssistiveTouchTypeTabbar:{
            _bottomOffset = 49;
            _leftOffset = 0;
            _rightOffset = 0;
        }break;
        case OCJAssistiveTouchTypeCustomOffset:{
            _topOffset = self.aroundOffset.top;
            _bottomOffset = self.aroundOffset.bottom;
            _leftOffset = self.aroundOffset.left;
            _rightOffset = self.aroundOffset.right;
        }break;
        default:{
            _topOffset = 0;
            _leftOffset = 0;
            _rightOffset = 0;
        }break;
    }
}

#pragma mark 悬浮窗的父视图
- (UIView *)topMotherView{
    return self.superview.superview;
}

@end
