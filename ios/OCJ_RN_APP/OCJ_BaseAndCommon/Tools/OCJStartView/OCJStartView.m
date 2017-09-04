//
//  OCJStartView.m
//  OCJ_RN_APP
//
//  Created by apple on 2017/7/3.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJStartView.h"
#import "GuideCollectionViewCell.h"
#import <UIButton+WebCache.h>
#import "OCJ_RN_WebViewVC.h"
#import "AppDelegate+OCJExtension.h"
#import "OCJHomePageVC.h"

#define kKeyWindow [UIApplication sharedApplication].keyWindow

NSString * const GuideCollectionID = @"guideCollectionID";


NSString * const FirstLanchKey = @"OCJStartViewFirstLanchKey";

NSString * const LastLanchVerKey = @"OCJStartViewLastLanchVerKey";

@interface OCJStartView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *imageS;

@property (nonatomic, strong) OCJBaseButton *advBtn;

@property (nonatomic, strong) MASConstraint *leftContro;

@property (nonatomic, strong) NSString *ocjStr_jumpUrl;
@property (nonatomic) BOOL ocjBool_isFirstClicked;  ///<

@end

static NSString *lastVersionStr = nil;

@implementation OCJStartView

/**
 检测版本号是否被更新.
 @warning 本地化版本号信息更新只会在程序生命一次周期内更新.
 */
extern BOOL ocj_shouldShowStartView(){
  NSString *shouldShow = [[NSUserDefaults standardUserDefaults] valueForKey:FirstLanchKey];
  if (lastVersionStr.length==0) {
    lastVersionStr = [[NSUserDefaults standardUserDefaults] valueForKey:LastLanchVerKey];
  }
  
  //当前版本号
  NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

  if (shouldShow.length==0) {//没存储过数据 第一次启动
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:FirstLanchKey];
      [[NSUserDefaults standardUserDefaults] setValue:appVersion forKey:LastLanchVerKey];
      [[NSUserDefaults standardUserDefaults] synchronize];
    });
    return YES;
  }
  
  if (![appVersion isEqualToString:lastVersionStr]) {// 存储过数据但是版本号不一致
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      [[NSUserDefaults standardUserDefaults] setValue:appVersion forKey:LastLanchVerKey];
      [[NSUserDefaults standardUserDefaults] synchronize];
    });
    
    return YES;
  }
  
  return NO;
}

+ (instancetype)ocj_StartViewCompletionHandler:(OCJStartViewGuideEndBlock)handler{
  
  OCJStartView *startView = [[[self class] alloc] init];
  startView.frame = [UIScreen mainScreen].bounds;
  startView.alpha = 0;
  [kKeyWindow addSubview:startView];
  [kKeyWindow bringSubviewToFront:startView];
  
  if (ocj_shouldShowStartView()) {
    startView.alpha = 1;
    [startView setupGuideCollectionView];
    startView.ocjBlock_guideEnd = handler;
    
  }else{
    
    if (handler) {
        handler(startView);
    }
  }

  /*
  UIImage *logoIcon = [UIImage imageNamed:@"splash"];
  UIImageView *splashImageV = [[UIImageView alloc] initWithImage:logoIcon];
  splashImageV.contentMode = UIViewContentModeScaleAspectFill;
  splashImageV.userInteractionEnabled = YES;
  [startView addSubview:splashImageV];
  [splashImageV mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(startView);
  }];
   
   OCJBaseButton *startBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
   startBtn.backgroundColor = [UIColor clearColor];
   [startBtn addTarget:startView action:@selector(removStartView) forControlEvents:UIControlEventTouchUpInside];
   //  startBtn.backgroundColor = [UIColor greenColor];
   [startView addSubview:startBtn];
   [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
   make.centerX.equalTo(startView);
   make.width.mas_equalTo(660.0*SCREEN_WIDTH/1125);
   make.height.mas_equalTo(136.0*SCREEN_HEIGHT/2001);
   make.bottom.offset(-SCREEN_HEIGHT*140/2001);
   }];
   */
  
  __weak __typeof(startView) weakSelf = startView;
  startView.ocjBool_isFirstClicked = YES;
  startView.advBtn = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
  [startView.advBtn addTarget:startView action:@selector(ocj_clickedADVBtnWithUrl:) forControlEvents:UIControlEventTouchUpInside];
  [startView addSubview:startView.advBtn];
  [startView.advBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    weakSelf.leftContro = make.left.equalTo(startView);
    make.top.equalTo(startView);
    make.width.height.equalTo(startView);
  }];
  startView.advBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
  startView.advBtn.adjustsImageWhenHighlighted = NO;
  startView.advBtn.adjustsImageWhenDisabled = NO;
  startView.advBtn.alpha = 0;
  
  UIButton* advCloseBtn = [[UIButton alloc]init];
  [advCloseBtn setImage:[UIImage imageNamed:@"close_"] forState:UIControlStateNormal];
  [advCloseBtn addTarget:startView action:@selector(ocj_clickAdvCloseButton) forControlEvents:UIControlEventTouchUpInside];
  [startView.advBtn addSubview:advCloseBtn];
  [advCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(startView.advBtn.mas_right);
    make.top.mas_equalTo(startView.advBtn).offset(10);
    make.height.width.mas_equalTo(@60);
  }];
  
  return startView;
}

- (void)ocj_clickedADVBtnWithUrl:(NSString *)ocjStr {
  if ([self.ocjStr_jumpUrl length] > 0) {
    if (self.ocjBool_isFirstClicked) {
      OCJ_RN_WebViewVC *webVC = [[OCJ_RN_WebViewVC alloc] init];
      webVC.ocjDic_router = @{@"url":self.ocjStr_jumpUrl};
      [[AppDelegate ocj_getTopViewController].navigationController pushViewController:webVC animated:YES];
      //    [kKeyWindow addSubview:webVC.view];
      //    [webVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
      //      make.left.bottom.right.mas_equalTo(kKeyWindow);
      //      make.top.mas_equalTo(kKeyWindow.mas_top).offset(20);
      //    }];
      self.ocjBool_isFirstClicked = NO;
    }
    
  }
}

/**
 * @brief 引导页.
 *
 */
- (void)setupGuideCollectionView{
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.itemSize = [UIScreen mainScreen].bounds.size;
  layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  
  UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
  [self addSubview:collectionView];
  [self bringSubviewToFront:collectionView];
  
  [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self);
  }];
  
  collectionView.pagingEnabled = YES;
  
  [collectionView registerClass:[GuideCollectionViewCell class] forCellWithReuseIdentifier:GuideCollectionID];
  
  collectionView.delegate = self;
  collectionView.dataSource = self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
  
  return self.imageS.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  GuideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GuideCollectionID forIndexPath:indexPath];
  [cell.btn setBackgroundImage:[UIImage imageNamed:self.imageS[indexPath.section]] forState:UIControlStateNormal];
  if (indexPath.section!=self.imageS.count-1) {
    [cell.appearbtn setTitle:@"→" forState:UIControlStateNormal];
  }else{
    [cell.appearbtn setTitle:@"进入app" forState:UIControlStateNormal];
  }
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == self.imageS.count-1) {
    [collectionView removeFromSuperview];
    [self removeStartView];
    OCJLog(@"========removeFromSuperview=======");
    if (self.ocjBlock_guideEnd) {
      self.ocjBlock_guideEnd(self);
    }
    
  }else{
    OCJLog(@"========setoffset=======");
    [collectionView setContentOffset:CGPointMake(SCREEN_WIDTH*(indexPath.section+1), 0) animated:YES];
  }
}

- (NSArray *)imageS{
  if (_imageS == nil) {
    _imageS = @[@"start-1",@"start-2",@"start-3"];
  }
  return _imageS;
}

/**
 * @brief 移除视图.
 *
 */
- (void)removeStartView{
  __weak __typeof(self) weakSelf = self;
  [UIView animateWithDuration:1.5 animations:^{
    weakSelf.alpha = 0;
  } completion:^(BOOL finished) {
    [weakSelf removeFromSuperview];
  }];
}

/**
 * 广告页.
 */
- (void)ocjSetAdvImageV:(NSString *)imageUrlStr andJumpUrl:(NSString *)ocjStr_jump {
  if (imageUrlStr.length==0) {
    return;
  }
  if ([ocjStr_jump length] > 0) {
    self.ocjStr_jumpUrl = ocjStr_jump;
  }
//  OCJStartView *startView = [[[self class] alloc] init];
  imageUrlStr = [imageUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  __weak __typeof(self) weakSelf = self;
  [self.advBtn sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    if (weakSelf.advBtn.superview) {
      
      weakSelf.alpha = 1;
      weakSelf.advBtn.alpha = 1.0f;
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf.advBtn removeFromSuperview];
        [weakSelf removeStartView];
      });
    }
  }];
}

-(void)ocj_clickAdvCloseButton{
  [self.advBtn removeFromSuperview];
  [self removeStartView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
