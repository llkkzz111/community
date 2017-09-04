//
//  WSHHBannerView.m
//  WSHH-BannerScrollView
//
//  Created by LZB on 2017/4/10.
//  Copyright © 2017年 LZB. All rights reserved.
//

#import "WSHHBannerView.h"

@interface WSHHBannerView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *wshhScrollView;///<
@property (nonatomic, strong) UIPageControl *wshhPageControl;
@property (nonatomic, strong) UIImageView *wshhImageView_left;///<
@property (nonatomic, strong) UIImageView *wshhImageView_middle;
@property (nonatomic, strong) UIImageView *wshhImageView_right;

@property (nonatomic, assign) NSInteger wshhInt_currentIndex;///<当前是第几页

@property (nonatomic, strong) NSTimer *wshhTimer;///<定时器

@property (nonatomic, assign) NSTimeInterval wshhTimeInterVal;///<时间间隔

@end

@implementation WSHHBannerView

- (instancetype)initWSHHWithFrame:(CGRect)frame andScrollDuration:(NSInteger)duration {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.wshhTimeInterVal = duration;
        [self addObservers];
        [self setupViews];
        [self startTimer];
    }
    return self;
}

- (void)setupViews {
    self.wshhScrollView.frame = self.bounds;
    if (!_wshhImageView_left) {
        _wshhImageView_left = [[UIImageView alloc] init];
        _wshhImageView_left.contentMode = UIViewContentModeScaleToFill;
        _wshhImageView_left.clipsToBounds = YES;
    }
    
    if (!_wshhImageView_middle) {
        _wshhImageView_middle = [[UIImageView alloc] init];
        _wshhImageView_middle.contentMode = UIViewContentModeScaleToFill
        ;
        _wshhImageView_middle.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [_wshhImageView_middle addGestureRecognizer:tap];
        _wshhImageView_middle.userInteractionEnabled = YES;
    }
    
    if (!_wshhImageView_right) {
        _wshhImageView_right = [[UIImageView alloc] init];;
        _wshhImageView_right.contentMode = UIViewContentModeScaleToFill;
        _wshhImageView_right.clipsToBounds = YES;
    }
    if (!_wshhPageControl) {
        _wshhPageControl = [[UIPageControl alloc] init];
//        _wshhPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//        _wshhPageControl.currentPageIndicatorTintColor = [UIColor blueColor];
      _wshhPageControl.pageIndicatorTintColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
      _wshhPageControl.currentPageIndicatorTintColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    }
    CGFloat imageWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat imageHeight = CGRectGetHeight(self.wshhScrollView.bounds);
    //设置3个imageView的位置
    self.wshhImageView_left.frame = CGRectMake(imageWidth * 0, 0, imageWidth, imageHeight);
    self.wshhImageView_middle.frame = CGRectMake(imageWidth * 1, 0, imageWidth, imageHeight);
    self.wshhImageView_right.frame = CGRectMake(imageWidth * 2, 0, imageWidth, imageHeight);
    [self.wshhScrollView addSubview:self.wshhImageView_left];
    [self.wshhScrollView addSubview:self.wshhImageView_middle];
    [self.wshhScrollView addSubview:self.wshhImageView_right];
    [self addSubview:self.wshhScrollView];
    [self addSubview:self.wshhPageControl];
    
    self.wshhPageControl.frame = CGRectMake(0, CGRectGetMaxY(self.wshhScrollView.bounds) - 25, CGRectGetWidth(self.bounds), 20);
    
    self.wshhScrollView.contentSize = CGSizeMake(imageWidth * 3, 0);
    
    self.wshhScrollView.contentOffset = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0);
}

//设置定时器
- (void)startTimer {
    [self ocj_stopTimer];
    self.wshhTimer = [NSTimer scheduledTimerWithTimeInterval:self.wshhTimeInterVal target:self selector:@selector(autoScrollToPosition:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.wshhTimer forMode:NSRunLoopCommonModes];
}

-(void)ocj_stopTimer {
    [self.wshhTimer invalidate];
    self.wshhTimer = nil;
}

#pragma mark - AutoScroll(自动滚动)
- (void)autoScrollToPosition:(NSTimer *)timer {
    CGFloat criticalValue = .2f;
    if (self.wshhScrollView.contentOffset.x < CGRectGetWidth([UIScreen mainScreen].bounds) - criticalValue || self.wshhScrollView.contentOffset.x > CGRectGetWidth([UIScreen mainScreen].bounds) + criticalValue) {
        self.wshhScrollView.contentOffset = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0);
    }
    CGPoint newOffset = CGPointMake(self.wshhScrollView.contentOffset.x + CGRectGetWidth([UIScreen mainScreen].bounds), 0);
    [self.wshhScrollView setContentOffset:newOffset animated:YES];
}

#pragma mark - KVO
- (void)addObservers {
    [self.wshhScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void) removeObservers {
    [self.wshhScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self caculateCurrentIndex];
    }
}

//销毁timer
- (void)dealloc {
    [self removeObservers];
    if (self.wshhTimer) {
        [self.wshhTimer invalidate];
        self.wshhTimer = nil;
    }
}

#pragma mark - getter
- (UIScrollView *)wshhScrollView {
    if (!_wshhScrollView) {
        _wshhScrollView = [[UIScrollView alloc] init];
        _wshhScrollView.delegate = self;
        _wshhScrollView.pagingEnabled = YES;
        _wshhScrollView.showsHorizontalScrollIndicator = NO;
        _wshhScrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _wshhScrollView;
}

//- (UIPageControl *)wshhPageControl {
//    
//    
//    return _wshhPageControl;
//}

//- (UIImageView *)wshhImageView_left {
//    
//    
//    return _wshhImageView_left;
//}
//
//- (UIImageView *)wshhImageView_middle {
//    
//    
//    return _wshhImageView_middle;
//}
//
//- (UIImageView *)wshhImageView_right {
//    
//    
//    return _wshhImageView_right;
//}

#pragma mark - setter
-(void)setWshhArr_image:(NSArray *)wshhArr_image {
    if (wshhArr_image.count==0) {
      return;
    }
  
    if (wshhArr_image) {
        _wshhArr_image = wshhArr_image;
        self.wshhInt_currentIndex = 0;
        
        if (wshhArr_image.count > 1) {
            self.wshhPageControl.numberOfPages = wshhArr_image.count;
            self.wshhPageControl.currentPage = 0;
            self.wshhPageControl.hidden = NO;
        } else {
            self.wshhPageControl.hidden = YES;
            [self.wshhImageView_left removeFromSuperview];
            [self.wshhImageView_right removeFromSuperview];
            self.wshhScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.wshhScrollView.bounds), 0);
        }
    }
}

//设置图片
-(void)setWshhInt_currentIndex:(NSInteger)wshhInt_currentIndex {
    if (_wshhInt_currentIndex >= 0) {
        _wshhInt_currentIndex = wshhInt_currentIndex;
    }
    NSInteger imageCount = self.wshhArr_image.count;
    NSInteger leftIndex = (wshhInt_currentIndex + imageCount - 1) % imageCount;
    NSInteger rightIndex= (wshhInt_currentIndex + 1) % imageCount;
    
    NSString *leftStr = self.wshhArr_image[leftIndex];
    NSString *middleStr = self.wshhArr_image[self.wshhInt_currentIndex];
    NSString *rightStr = self.wshhArr_image[rightIndex];
  
    [self.wshhImageView_left ocj_setWebImageWithURLString:[self wshh_dealWithNSNullString:leftStr] completion:nil];
    [self.wshhImageView_middle ocj_setWebImageWithURLString:[self wshh_dealWithNSNullString:middleStr] completion:nil];
    [self.wshhImageView_right ocj_setWebImageWithURLString:[self wshh_dealWithNSNullString:rightStr] completion:nil];
  
    self.wshhScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.wshhScrollView.bounds), 0);
    self.wshhPageControl.currentPage = wshhInt_currentIndex;
}

- (NSString *)wshh_dealWithNSNullString:(NSString *)oldStr {
  NSString *newStr;
  if ([oldStr isKindOfClass:[NSNull class]]) {
    newStr = @"";
  }else {
    newStr = oldStr;
  }
  return newStr;
}

//计算当前是第几张图片
- (void)caculateCurrentIndex {
    if (self.wshhArr_image && self.wshhArr_image.count > 0) {
        CGFloat pointX = self.wshhScrollView.contentOffset.x;
        CGFloat criticalValue = .2f;
        //右滑
        if (pointX > 2 * CGRectGetWidth([UIScreen mainScreen].bounds) - criticalValue) {
            self.wshhInt_currentIndex = (self.wshhInt_currentIndex + 1) % self.wshhArr_image.count;
        }else if (pointX < criticalValue) {//左滑
            self.wshhInt_currentIndex = (self.wshhInt_currentIndex + self.wshhArr_image.count - 1) % self.wshhArr_image.count;
        }
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.wshhArr_image.count > 1) {
        [self ocj_stopTimer];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startTimer];
}

#pragma mark - 点击图片跳转
- (void)imageClicked:(UITapGestureRecognizer *)tap {
    if (self.wshhBlock_clickedImage) {
        self.wshhBlock_clickedImage(self.wshhInt_currentIndex);
    }
}


@end
