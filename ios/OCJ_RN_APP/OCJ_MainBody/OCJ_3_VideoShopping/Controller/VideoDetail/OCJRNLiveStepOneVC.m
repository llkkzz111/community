//
//  OCJRNLiveStepOneVC.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/11.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJRNLiveStepOneVC.h"
#import "OCJVideoLiveView.h"
#import "OCJRNLiveStepOneTVCell.h"
#import "OCJRNLiveStepTwoVC.h"
#import "AppDelegate.h"

@interface OCJRNLiveStepOneVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *ocjView_container;                      ///<播放器底部容器
@property (nonatomic, strong) UIView *ocjView_bottom;                         ///<底部按钮浮层
@property (nonatomic, strong) UIButton *ocjBtn_pause;                         ///<暂停、播放
@property (nonatomic, strong) UIButton *ocjBtn_fullScreen;                    ///<全屏按钮
@property (nonatomic) BOOL ocjBool_isplay;                                    ///<是否正在播放
@property (nonatomic) BOOL ocjBool_isFullScreen;                              ///<是否全屏播放

@property (nonatomic, strong) OCJVideoLiveView *ocjView_live;                 ///<播放器
@property (nonatomic, strong) OCJBaseTableView *ocjTBView_select;             ///<tableView
@property (nonatomic, strong) NSArray *ocjArr_url;                            ///<数据源
@property (nonatomic, assign) CGFloat ocjFloat_cellHeight;                    ///<cell高度

@property (nonatomic, strong) NSString *ocjStr_url;                           ///<当前视频播放地址
@property (nonatomic, strong) AppDelegate *ocj_appdelegate;

@property (nonatomic, strong) MPMoviePlayerViewController *ocjMPPlarViewVC; ///<


@end

@implementation OCJRNLiveStepOneVC
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
  [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

- (void)ocj_setSelf {
  self.title = @"视频播放";
  self.ocjBool_isplay = YES;
  self.ocjBool_isFullScreen = NO;
  if ([self.ocjDic_router isKindOfClass:[NSDictionary class]]) {
    self.ocjArr_url = [self.ocjDic_router objectForKey:@"item_video_url"];
  }
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ocj_playerSeekToTime:) name:@"PlayerGoonPlay" object:nil];
  self.ocjStr_url = [[self.ocjArr_url objectAtIndex:0] objectForKey:@"video_url"];
  if (!(self.ocjArr_url.count > 0)) {
    [OCJProgressHUD ocj_showHudWithTitle:@"视频播放数组为空" andHideDelay:2.0];
  }
  [self ocj_calculateCellHeightWithArray:self.ocjArr_url];
  [self ocj_addLiveView];
  [self ocj_addSelectView];
  [self configureVolume];
  [self hideControls];
}

/**
 去掉系统全屏、播放按钮，添加新的自定义播放、全屏按钮
 */
- (void)hideControls
{
  for(id views in [[self.ocjMPPlarViewVC.moviePlayer view] subviews]){
    for(id subViews in [views subviews]){
      for (id controlView in [subViews subviews]){
        if ( [controlView isKindOfClass:NSClassFromString(@"MPVideoPlaybackOverlayView")] ) {
          for (id ocjView in [controlView subviews]) {
            if ([ocjView isKindOfClass:NSClassFromString(@"_UIBackdropView")]) {
              for (id ocjView2 in [ocjView subviews]) {
                if ([ocjView2 isKindOfClass:NSClassFromString(@"_UIBackdropContentView")]) {
                  for (id ocjView3 in [ocjView2 subviews]) {
                    if ([ocjView3 isKindOfClass:NSClassFromString(@"MPKnockoutButton")]) {
                      
                      [ocjView3 setHidden:YES];
                      //全屏
                        self.ocjBtn_fullScreen = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 8, 30, 30)];
                      [self.ocjBtn_fullScreen setImage:[UIImage imageNamed:@"icon_zoom"] forState:UIControlStateNormal];
                      [self.ocjBtn_fullScreen addTarget:self action:@selector(ocj_clickedFullScreesBtn) forControlEvents:UIControlEventTouchUpInside];
                      [ocjView2 addSubview:self.ocjBtn_fullScreen];
                      //暂停
                        self.ocjBtn_pause = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 30, 30)];
                      if (!self.ocjBool_isplay) {
                        [self.ocjBtn_pause setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
                      }else {
                        [self.ocjBtn_pause setImage:[UIImage imageNamed:@"Btn_Pause_"] forState:UIControlStateNormal];
                      }
                      
                      [self.ocjBtn_pause addTarget:self action:@selector(ocj_clickedPauseBtn) forControlEvents:UIControlEventTouchUpInside];
                      [ocjView2 addSubview:self.ocjBtn_pause];
                    }else if ([ocjView3 isKindOfClass:[UIButton class]]) {
                      [ocjView3 removeFromSuperview];
                      //全屏
                      if (!self.ocjBtn_fullScreen) {
                        self.ocjBtn_fullScreen = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 8, 30, 30)];
                      }
                      [self.ocjBtn_fullScreen setImage:[UIImage imageNamed:@"icon_zoom"] forState:UIControlStateNormal];
                      [self.ocjBtn_fullScreen addTarget:self action:@selector(ocj_clickedFullScreesBtn) forControlEvents:UIControlEventTouchUpInside];
                      [ocjView2 addSubview:self.ocjBtn_fullScreen];
                      //暂停
                      if (!self.ocjBtn_pause) {
                        self.ocjBtn_pause = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 30, 30)];
                      }
                      
                      if (!self.ocjBool_isplay) {
                        [self.ocjBtn_pause setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
                      }else {
                        [self.ocjBtn_pause setImage:[UIImage imageNamed:@"Btn_Pause_"] forState:UIControlStateNormal];
                      }
                      
                      [self.ocjBtn_pause addTarget:self action:@selector(ocj_clickedPauseBtn) forControlEvents:UIControlEventTouchUpInside];
                      [ocjView2 addSubview:self.ocjBtn_pause];
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
/**
 tableView
 */
- (void)ocj_addSelectView {
  self.ocjTBView_select = [[OCJBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.ocjTBView_select.delegate = self;
  self.ocjTBView_select.dataSource = self;
  self.ocjTBView_select.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:self.ocjTBView_select];
  [self.ocjTBView_select mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.mas_equalTo(self.view);
    make.top.mas_equalTo(self.view.mas_top).offset(SCREEN_WIDTH * 9 / 16.0);
  }];
  [self.ocjTBView_select registerClass:[OCJRNLiveStepOneTVCell class] forCellReuseIdentifier:@"OCJRNLiveStepOneTVCellIdentifier"];
}

/**
 重新回到小屏播放
 */
- (void)ocj_playerSeekToTime:(NSNotification *)noti {
  self.ocjBool_isFullScreen = NO;
  MPMoviePlayerViewController *plareyVC = (MPMoviePlayerViewController *)[noti.userInfo objectForKey:@"currentTime"];
  plareyVC.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
  CGAffineTransform transform = CGAffineTransformMakeRotation(0);
  [plareyVC.moviePlayer.view setTransform:transform];
  [self.ocjView_container addSubview:plareyVC.moviePlayer.view];
  [plareyVC.moviePlayer.view mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(self.ocjView_container);
    make.width.mas_equalTo(SCREEN_WIDTH);
    make.height.mas_equalTo(SCREEN_WIDTH * 9 / 16.0);
  }];
  [plareyVC.moviePlayer play];
  [self hideControls];
}

/**
 播放器
 */
- (void)ocj_addLiveView {
  /*
  __weak OCJRNLiveStepOneVC *weakSelf = self;
  self.ocjView_live = [[OCJVideoLiveView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16.0) tableView:nil indexPath:nil];
  self.ocjView_live.ocjStr_status = @"3";
  self.ocjView_live.ocjUrl_video = [NSURL URLWithString:self.ocjStr_url];
  self.ocjView_live.ocjStr_firstImage = @"";
  self.ocjView_live.ocjView_suspend.ocjView_bottom.hidden = YES;
  self.ocjView_live.ocjLivingViewBlock = ^{
    [weakSelf.ocjView_live.ocjPlayer pause];
    OCJRNLiveStepTwoVC *mpMovie = [[OCJRNLiveStepTwoVC alloc] init];
    mpMovie.ocJStr_url = weakSelf.ocjStr_url;
    [weakSelf presentViewController:mpMovie animated:YES completion:nil];
  };
  [self.view addSubview:self.ocjView_live];
   */
  
  self.ocjView_container  = [[UIView alloc] init];
  self.ocjView_container.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.ocjView_container];
  [self.ocjView_container mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.mas_equalTo(self.view);
    make.height.mas_equalTo(SCREEN_WIDTH * 9 / 16.0);
  }];
  
  self.ocjMPPlarViewVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.ocjStr_url]];
  [self.ocjMPPlarViewVC.moviePlayer prepareToPlay];
  self.ocjMPPlarViewVC.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
  self.ocjMPPlarViewVC.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
  [self.ocjView_container addSubview:self.ocjMPPlarViewVC.moviePlayer.view];
  [self.ocjMPPlarViewVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.top.left.right.mas_equalTo(self.ocjView_container);
    make.height.mas_equalTo(SCREEN_WIDTH * 9 / 16.0);
  }];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackstateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
  //全屏
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFullScreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
  //退出全屏
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitFullScreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
  [self.ocjMPPlarViewVC.moviePlayer play];
  
  //浮层
//  [self ocj_addbottomView];
}

/**
 底部控制层浮层
 */
- (void)ocj_addbottomView {
  self.ocjView_bottom = [[UIView alloc] init];
  self.ocjView_bottom.backgroundColor = [UIColor colorWSHHFromHexString:@"000000"];
  self.ocjView_bottom.alpha = 0.6;
  [self.ocjView_container addSubview:self.ocjView_bottom];
  [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.mas_equalTo(self.ocjView_container);
    make.height.mas_equalTo(@30);
  }];
  //暂停
  self.ocjBtn_pause = [[UIButton alloc] init];
  [self.ocjBtn_pause setImage:[UIImage imageNamed:@"Btn_Pause_"] forState:UIControlStateNormal];
  [self.ocjBtn_pause addTarget:self action:@selector(ocj_clickedPauseBtn) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_bottom addSubview:self.ocjBtn_pause];
  [self.ocjBtn_pause mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.bottom.mas_equalTo(self.ocjView_bottom);
    make.left.mas_equalTo(self.ocjView_bottom.mas_left).offset(10);
    make.width.mas_equalTo(@30);
  }];
  //全屏
  UIButton *ocjBtn_fullScreen = [[UIButton alloc] init];
  [ocjBtn_fullScreen setImage:[UIImage imageNamed:@"icon_zoom"] forState:UIControlStateNormal];
  [ocjBtn_fullScreen addTarget:self action:@selector(ocj_clickedFullScreesBtn) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_bottom addSubview:ocjBtn_fullScreen];
  [ocjBtn_fullScreen mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjView_bottom.mas_right).offset(-10);
    make.top.bottom.mas_equalTo(self.ocjView_bottom);
    make.width.mas_equalTo(@30);
  }];
}

/**
 暂停、播放
 */
- (void)ocj_clickedPauseBtn {
  self.ocjBool_isplay = !self.ocjBool_isplay;
  [self hideControls];
  if (!self.ocjBool_isplay) {
    [self.ocjMPPlarViewVC.moviePlayer pause];
  }else {
    [self.ocjMPPlarViewVC.moviePlayer play];
  }
  
}

/**
 全屏
 */
- (void)ocj_clickedFullScreesBtn {
  self.ocjBool_isFullScreen = YES;
  self.ocjMPPlarViewVC.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
  [self ocj_presentMPMoviewPlayerControllerWithVideoString:self.ocjStr_url];
}

/**
 推出新页面
 */
- (void)ocj_presentMPMoviewPlayerControllerWithVideoString:(NSString *)ocjStr_url {
  [self.ocjMPPlarViewVC.moviePlayer.view removeFromSuperview];
  OCJRNLiveStepTwoVC *liveVC = [[OCJRNLiveStepTwoVC alloc] init];
  liveVC.ocJStr_url = ocjStr_url;
  liveVC.ocjMPPlarViewVC = self.ocjMPPlarViewVC;
  [self.navigationController presentViewController:liveVC animated:YES completion:nil];
}

- (void)ocj_back {
  [super ocj_back];
  self.ocjMPPlarViewVC.moviePlayer.initialPlaybackTime = -1;
  [self.ocjMPPlarViewVC.moviePlayer.view removeFromSuperview];
  [self.ocjMPPlarViewVC.moviePlayer stop];
}

#pragma mark - 静音继续播放声音
/**
 静音模式继续播放声音
 */
-(void)configureVolume {
  //使用这个category的应用不会随着手机静音键打开而静音，可在手机静音模式下播放声音
  NSError *setCategoryError = nil;
  BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
  if (!success) {
    //????
  }
  
  //监听耳机插入和拔出通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}

//耳机插入、拔出事件
-(void)audioRouteChangeListenerCallback:(NSNotification *)notification {
  NSDictionary *interuptionDict = notification.userInfo;
  
  NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
  
  switch (routeChangeReason) {
    case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
      //耳机插入
      break;
    case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
      //耳机拔掉，继续播放
      [self.ocjMPPlarViewVC.moviePlayer play];
      break;
    case AVAudioSessionRouteChangeReasonCategoryChange:
      NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
      break;
    default:
      break;
  }
}

#pragma mark - NSNotification
- (void)movieFinishedCallBack:(NSNotification *)noti {
  
}

- (void)enterFullScreen:(NSNotificationCenter *)noti {
  self.ocj_appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  self.ocj_appdelegate.ocjInt_allowRotation = 2;
//  [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
}

- (void)exitFullScreen:(NSNotificationCenter *)noti {
  self.ocj_appdelegate.ocjInt_allowRotation = 1;
  [self interfaceOrientation:UIInterfaceOrientationPortrait];
  [self.ocjMPPlarViewVC.moviePlayer play];
}

- (void)playbackstateDidChange:(NSNotification *)noti
{
  switch (self.ocjMPPlarViewVC.moviePlayer.playbackState) {
    case MPMoviePlaybackStateInterrupted:
      //中断
      NSLog(@"中断");
      if (!self.ocjBool_isFullScreen) {
        self.ocjBool_isplay = NO;
        [self hideControls];
      }
      
      break;
    case MPMoviePlaybackStatePaused:
      //暂停
      if (!self.ocjBool_isFullScreen) {
        self.ocjBool_isplay = NO;
        [self hideControls];
      }
      
      NSLog(@"暂停");
      break;
    case MPMoviePlaybackStatePlaying:
      //播放中
      NSLog(@"播放中");
      break;
    case MPMoviePlaybackStateSeekingBackward:
      //后退
      NSLog(@"后退");
      break;
    case MPMoviePlaybackStateSeekingForward:
      //快进
      NSLog(@"快进");
      break;
    case MPMoviePlaybackStateStopped:
      //停止
      NSLog(@"停止");
      if (!self.ocjBool_isFullScreen) {
        self.ocjBool_isplay = NO;
        [self hideControls];
      }
      
      break;
      
    default:
      break;
  }
}

- (void)loadStateDidChange:(NSNotification *)noti {
  switch (self.ocjMPPlarViewVC.moviePlayer.loadState) {
    case MPMovieLoadStatePlayable: {
      [self.ocjMPPlarViewVC.moviePlayer play];
    }
      break;
    case MPMovieLoadStatePlaythroughOK: {
      [self.ocjMPPlarViewVC.moviePlayer play];
    }
      break;
      
    default:
      break;
  }
}

- (void)playDidFinish:(NSNotification *)noti
{
  //播放完成
  NSLog(@"FINISHED");
  
}

- (void)ocj_calculateCellHeightWithArray:(NSArray *)arr {
  
  NSInteger row = arr.count / 3 + 1;
  self.ocjFloat_cellHeight = row * (SCREEN_WIDTH - 40) / 3.0 + 20 + 10 * (row - 1);
}

#pragma makr - 协议方法实现区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak OCJRNLiveStepOneVC *weakSelf = self;
  OCJRNLiveStepOneTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OCJRNLiveStepOneTVCellIdentifier"];
  cell.ocjArr_video = self.ocjArr_url;
  cell.ocjChangeVideoUrlBlock = ^(NSString *ocjStr_url) {
    
    weakSelf.ocjBool_isplay = YES;
    weakSelf.ocjView_bottom.hidden = YES;
    if (weakSelf.ocjStr_url != ocjStr_url) {
      weakSelf.ocjStr_url = ocjStr_url;
      [weakSelf.ocjMPPlarViewVC.moviePlayer setContentURL:[NSURL URLWithString:ocjStr_url]];
//      [weakSelf ocj_presentMPMoviewPlayerControllerWithVideoString:ocjStr_url];
    }else {
//      [weakSelf ocj_presentMPMoviewPlayerControllerWithVideoString:ocjStr_url];
    }
    
     
    /*
    [weakSelf.ocjMPPlarViewVC.moviePlayer.view removeFromSuperview];
    [weakSelf ocj_allowRotation];
    [weakSelf interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    weakSelf.ocjMPPlarViewVC.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
     */
//      weakSelf.ocjMPPlarViewVC.moviePlayer.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
//      weakSelf.ocjMPPlarViewVC.moviePlayer.view.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
//      CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI / 2);
//      [weakSelf.ocjMPPlarViewVC.moviePlayer.view setTransform:transform];
    
//    [weakSelf.navigationController presentMoviePlayerViewControllerAnimated:self.ocjMPPlarViewVC];
  };
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.ocjFloat_cellHeight;
}


-(void)interfaceOrientation:(UIInterfaceOrientation)orientation {
  if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
  }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
    
//    self.ocjMPPlarViewVC.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
//    [self.ocjMPPlarViewVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
//      make.top.left.right.mas_equalTo(self.view);
//      make.height.mas_equalTo(SCREEN_HEIGHT * 9 / 16.0);
//    }];
    self.ocjMPPlarViewVC.moviePlayer.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9 / 16.0);
  }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//    [self.ocjMPPlarViewVC.moviePlayer.view mas_remakeConstraints:^(MASConstraintMaker *make) {
//      make.top.left.mas_equalTo(self.view);
//      make.height.mas_equalTo(SCREEN_WIDTH);
//      make.width.mas_equalTo(SCREEN_HEIGHT);
//    }];
    self.ocjMPPlarViewVC.moviePlayer.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
  }
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
