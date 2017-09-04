//
//  CropImageView.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/15.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "CropImageView.h"
#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height
//#define BlackViewHeight (SHeight/2-(SWidth/4*3)/2)
#define BlackViewHeight (SHeight/2-SWidth*9/16/2)
#define BlackViewHeight2 (SHeight/2-SWidth*10/22/2)
#define BlackViewHeight1 (SHeight/2-SWidth/2)
@interface CropImageView (){
    UIImageView *_imageView;
    CGRect _oldImageViewFrame;
    NSInteger _cropH;
}
@end

@implementation CropImageView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=[UIColor blackColor];
        //self.automaticallyAdjustsScrollViewInsets=NO;
    }
    return self;
}

//初始化
- (void)initImage:(UIImage *)image {
    if (self.imageType == 1) {
        _cropH = BlackViewHeight;
    }else if (self.imageType == 2) {
        _cropH = BlackViewHeight2;
    }else{
        _cropH = BlackViewHeight1;
    }
    _imageView=[[UIImageView alloc] initWithImage:image];
    [self createUI];
}
- (instancetype)initWithImage:(UIImage *)image {
    if (self=[super init]) {
        _imageView=[[UIImageView alloc] initWithImage:image];
        [self createUI];
    }
    return self;
}
#pragma mark - 创建UI
- (void)createUI {
    _imageView.userInteractionEnabled=YES;
    _imageView.contentMode=UIViewContentModeScaleToFill;
    CGSize imageSize=_imageView.image.size;
    if (imageSize.width>imageSize.height) {
        NSInteger width=(SHeight-_cropH*2)/imageSize.height*imageSize.width;
        _imageView.frame=CGRectMake(0,0,width,SHeight-_cropH*2);
        if (width<SWidth) {
            _imageView.frame=CGRectMake(0,0,SWidth,SWidth/width*_imageView.bounds.size.height);
        }
    }
    else{
        NSInteger height=SWidth/imageSize.width*imageSize.height;
        _imageView.frame=CGRectMake(0,0,SWidth,height);
        
        if (height<SHeight-_cropH*2) {
            _imageView.frame=CGRectMake(0,0,(SHeight-_cropH*2)/height*_imageView.bounds.size.width,SHeight-_cropH*2);
        }
    }
    _imageView.center=[UIApplication sharedApplication].delegate.window.center;
    _oldImageViewFrame=_imageView.frame;
    
    [self addSubview:_imageView];
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0,0,SWidth,_cropH)];
    topView.backgroundColor=[UIColor blackColor];
    topView.alpha=0.7;
    topView.userInteractionEnabled=NO;
    [self addSubview:topView];
    
    UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0,SHeight-_cropH,SWidth,_cropH)];
    footView.backgroundColor=[UIColor blackColor];
    footView.alpha=0.7;
    footView.userInteractionEnabled=NO;
    [self addSubview:footView];
    [self addGestureRecognizerToImageView];
    [self createTopBar];
}
//imageView添加手势
- (void)addGestureRecognizerToImageView {
    //拖动
    UIPanGestureRecognizer *panGR=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImageView:)];
    [_imageView addGestureRecognizer:panGR];
    //缩放
    UIPinchGestureRecognizer *pinchGR=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImageView:)];
    [_imageView addGestureRecognizer:pinchGR];
}

- (void)createTopBar {
    UIButton *confirmButton=[[UIButton alloc] initWithFrame:CGRectMake(SWidth/2-20,SHeight-80,40,40)];
    //UIButton *confirmButton=[[UIButton alloc] initWithFrame:CGRectMake(SWidth-14-40,20+20,40,22)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
}
#pragma mark - 点击事件
//确定
- (void)confirmClick {
    UIImage *image=[self getImageFromImageView:_imageView withRect:CGRectMake(0,_cropH,SWidth,SHeight-_cropH*2)];
    UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(confirmClickWithImage:)]) {
            [_delegate confirmClickWithImage:image];
        }
        else{
            NSLog(@"CDPImageCropDelegate的confirmClickWithImage:方法未设置");
        }
    }
    else{
        NSLog(@"CDPImageCropDelegate未设置");
    }
}
#pragma mark - 图片裁剪
//裁剪修改后的图片
- (UIImage *)getImageFromImageView:(UIImageView *)imageView withRect:(CGRect)rect {
    CGRect subRect=[self convertRect:rect toView:imageView];
    UIImage *changedImage=[self createChangedImageWithImageView:imageView];
    //UIGraphicsBeginImageContext(subRect.size);//会显得模糊
    UIGraphicsBeginImageContextWithOptions(subRect.size, NO, [UIScreen mainScreen].scale);
    [changedImage drawInRect:CGRectMake(-subRect.origin.x,-subRect.origin.y,changedImage.size.width,changedImage.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//创建修改后的图片
- (UIImage *)createChangedImageWithImageView:(UIImageView *)imageView {
    //UIGraphicsBeginImageContext(imageView.bounds.size);//图片模糊(替换为下面的)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [imageView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark - 手势相关
//拖动
- (void)panImageView:(UIPanGestureRecognizer *)panGR {
    CGPoint translation = [panGR translationInView:self];
    panGR.view.center = CGPointMake(panGR.view.center.x+translation.x,panGR.view.center.y+translation.y);
    [panGR setTranslation:CGPointZero inView:self];
    if (panGR.state==UIGestureRecognizerStateEnded) {
        [self changeFrameForGestureView:panGR.view];
    }
}
//缩放
- (void)pinchImageView:(UIPinchGestureRecognizer *)pinchGR {
    pinchGR.view.transform = CGAffineTransformScale(pinchGR.view.transform,pinchGR.scale,pinchGR.scale);
    pinchGR.scale = 1;
    if (pinchGR.state==UIGestureRecognizerStateEnded) {
        if (pinchGR.view.transform.a<1||pinchGR.view.transform.d<1) {
            [UIView animateWithDuration:0.25 animations:^{
                pinchGR.view.transform=CGAffineTransformIdentity;
                pinchGR.view.frame=_oldImageViewFrame;
                pinchGR.view.center=[UIApplication sharedApplication].delegate.window.center;
            }];
        }
        else{
            [self changeFrameForGestureView:pinchGR.view];
        }
    }
}
//调整手势view的frame
- (void)changeFrameForGestureView:(UIView *)view {
    CGRect frame=view.frame;
    if (frame.origin.x>0) {
        frame.origin.x=0;
    }
    if (frame.origin.y>_cropH) {
        frame.origin.y=_cropH;
    }
    if (CGRectGetMaxX(frame)<SWidth) {
        frame.origin.x=frame.origin.x+(SWidth-CGRectGetMaxX(frame));
    }
    if (CGRectGetMaxY(frame)<(SHeight-_cropH)) {
        frame.origin.y=frame.origin.y+(SHeight-_cropH-CGRectGetMaxY(frame));
    }
    [UIView animateWithDuration:0.25 animations:^{
        view.frame=frame;
    }];
}
@end

