//
//  OCJLockSliderView.m
//  HBLockSliderViewDemo
//
//  Created by wb_yangyang on 2017/4/28.
//  Copyright © 2017年 yhb. All rights reserved.
//

#import "OCJLockSliderView.h"


#define kSliderW self.bounds.size.width
#define kSliderH self.bounds.size.height
#define kCornerRadius 5.0  //默认圆角为5
#define kBorderWidth 0 //默认边框为2
#define kAnimationSpeed 0.25 //默认动画移速
#define kForegroundColor [UIColor orangeColor] //默认滑过颜色
#define kBackgroundColor [UIColor darkGrayColor] //默认未滑过颜色
#define kThumbColor [UIColor lightGrayColor] //默认Thumb颜色
#define kBorderColor [UIColor blackColor] //默认边框颜色
#define kThumbW 15 //默认的thumb的宽度

@interface OCJLockSliderView ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) OCJBaseLabel* ocjLabel; ///< 提示文本展示框
@property (nonatomic,strong) UIImageView* ocjImageView_thumb; ///<
@property (nonatomic,strong) UIImage* ocjImage_thumb;   ///<滑动块的图片
@property (nonatomic,strong) UIImage* ocjImage_finish;  ///<滑动结束时滑动块的图片
@property (nonatomic,strong) UIView* ocjView_foreground; ///< 滑动过的区域视图
@property (nonatomic,strong) UIView* ocjView_touch; ///< 滑动块视图
@end

@implementation OCJLockSliderView

#pragma mark - 开放接口方法区域

- (void)ocj_setSliderValue:(CGFloat)value animation:(BOOL)animation completion:(void (^)(BOOL))completion{
    if (value > 1) {
        value = 1;
    }
    if (value < 1) {
        value = 0;
    }
    CGPoint point = CGPointMake(value * kSliderW, 0);
    __weak typeof(self) weakSelf = self;
    if (animation) {
        [UIView animateWithDuration:kAnimationSpeed animations:^{
            [weakSelf fillForeGroundViewWithPoint:point];
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [self fillForeGroundViewWithPoint:point];
        if (completion) {
            completion(YES);
        }
    }
}

- (void)ocj_setColorForBackgroud:(UIColor *)backgroud foreground:(UIColor *)foreground thumb:(UIColor *)thumb border:(UIColor *)border textColor:(UIColor *)textColor{
    self.backgroundColor = backgroud;
    self.ocjView_foreground.backgroundColor = foreground;
    self.ocjImageView_thumb.backgroundColor = thumb;
    [self.layer setBorderColor:border.CGColor];
    self.ocjLabel.textColor = textColor;
}

-(void)setOcjImage_thumb:(UIImage *)ocjImage_thumb{
    _ocjImage_thumb = ocjImage_thumb;
    self.ocjImageView_thumb.image = ocjImage_thumb ;
    [self.ocjImageView_thumb sizeToFit];
    [self ocj_setSliderValue:0.0];
    
}

- (void)ocj_setThumbBeginImage:(UIImage *)beginImage finishImage:(UIImage *)finishImage{
    self.ocjImage_thumb = beginImage;
    self.ocjImage_finish = finishImage;
}

- (void)ocj_removeRoundCorners:(BOOL)corners border:(BOOL)border{
    if (corners) {
        self.layer.cornerRadius = 0.0;
        self.layer.masksToBounds = NO;
        self.ocjImageView_thumb.layer.cornerRadius = 0.0;
        self.ocjImageView_thumb.layer.masksToBounds = NO;
    }
    if (border) {
        [self.layer setBorderWidth:0.0];
    }
}

#pragma mark - 私有方法区域
-(instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.ocjView_foreground = [[UIView alloc] init];
    [self addSubview:self.ocjView_foreground];
    
    self.ocjLabel = [[OCJBaseLabel alloc] initWithFrame:self.bounds];
    self.ocjLabel.textAlignment = NSTextAlignmentCenter;
    self.ocjLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.ocjLabel];
    
    self.ocjImageView_thumb = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.ocjImageView_thumb.layer.cornerRadius = kCornerRadius;
    self.ocjImageView_thumb.layer.masksToBounds = YES;
    self.ocjImageView_thumb.userInteractionEnabled = YES;
    [self addSubview:self.ocjImageView_thumb];
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = kBorderWidth;
    [self ocj_setSliderValue:0.0];
    
    //默认配置
    self.thumbBack = YES;
    self.backgroundColor = kBackgroundColor;
    self.ocjView_foreground.backgroundColor = kForegroundColor;
    self.ocjImageView_thumb.backgroundColor = kThumbColor;
    [self.layer setBorderColor:kBorderColor.CGColor];
    self.ocjView_touch = self.ocjImageView_thumb;
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(ocj_panSlider:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    
}

- (void)ocj_panSlider:(UIPanGestureRecognizer*)pan{
    
    pan.cancelsTouchesInView = NO;
}

- (void)ocj_setSliderValue:(CGFloat)value{
    [self ocj_setSliderValue:value animation:NO completion:nil];
}



#pragma mark - Private
- (void)fillForeGroundViewWithPoint:(CGPoint)point{
    CGFloat thunmbW = self.ocjImage_thumb ? self.ocjImage_thumb.size.width : kThumbW;
    CGPoint p = point;
    //修正
    p.x += thunmbW/2;
    if (p.x > kSliderW) {
        p.x = kSliderW;
    }
    if (p.x < 0) {
        p.x = 0;
    }
    if (self.ocjImage_thumb) {
        self.ocjImageView_thumb.image = point.x  < (kSliderW - thunmbW/2) ? self.ocjImage_thumb : self.ocjImage_finish;
    }
    self.ocjFloat_value = p.x  / kSliderW;
    
    
    self.ocjView_foreground.frame = CGRectMake(0, 0, point.x, kSliderH);
    
    
    if (self.ocjView_foreground.frame.size.width <= 0) {
        self.ocjImageView_thumb.frame = CGRectMake(0, kBorderWidth, thunmbW, self.ocjView_foreground.frame.size.height- kBorderWidth);
        
    }else if (self.ocjView_foreground.frame.size.width >= kSliderW) {
        self.ocjImageView_thumb.frame = CGRectMake(self.ocjView_foreground.frame.size.width - thunmbW, kBorderWidth, thunmbW, self.ocjView_foreground.frame.size.height - 2 * kBorderWidth );
        
    }else{
        self.ocjImageView_thumb.frame = CGRectMake(self.ocjView_foreground.frame.size.width-thunmbW/2, kBorderWidth, thunmbW, self.ocjView_foreground.frame.size.height-kBorderWidth*2);
    }
    
}


#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if ( self.ocjView_touch == self.ocjImageView_thumb) {
        return;
    }
    CGPoint point = [touch locationInView:self];
    [self fillForeGroundViewWithPoint:point];
    
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (touch.view != self.ocjView_touch) {
        return;
    }
    CGPoint point = [touch locationInView:self];
    [self fillForeGroundViewWithPoint:point];
    if ([self.ocjDelegate respondsToSelector:@selector(ocj_sliderValueChanging:)] ) {
        [self.ocjDelegate ocj_sliderValueChanging:self];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view != self.ocjView_touch) {
        return;
    }
    CGPoint __block point = [touch locationInView:self];
    if ([self.ocjDelegate respondsToSelector:@selector(ocj_sliderEndValueChanged:)]) {
        [self.ocjDelegate ocj_sliderEndValueChanged:self];
    }
    __weak typeof(self) weakSelf = self;
    if (_thumbBack) {
        //回到原点
        [UIView animateWithDuration:0.5 animations:^{
            point.x = 0;
            [weakSelf fillForeGroundViewWithPoint:point];
            
        }];
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
    return YES;
}

@end
