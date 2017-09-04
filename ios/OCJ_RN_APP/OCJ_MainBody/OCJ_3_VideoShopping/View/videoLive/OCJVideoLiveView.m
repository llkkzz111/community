//
//  OCJVideoLiveView.m
//  OCJ
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJVideoLiveView.h"
#import "OCJVideoComingVC.h"
#import "AppDelegate.h"
#import <AFNetworking.h>

@interface OCJVideoLiveView ()<OCJLiveSuspendViewDelegate>

@property (nonatomic, strong) AVPlayerLayer *playerLayer;       ///<
@property (nonatomic,strong) UIImageView* ocjImageView_firstPicture; ///< 首帧图片展示窗

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_live;
@property (nonatomic, strong) NSIndexPath *ocjIndexPath;
@property (nonatomic) BOOL isBottomLive;                        ///<
@property (nonatomic) BOOL isReadyPlay;                         ///<是否开始播放
@property (nonatomic) BOOL isFullScreen;                        ///<是否全屏
@property (nonatomic) OCJEnumVideoPlayType ocjEnumVideoPlayType;///<视频类型枚举
@property (nonatomic, strong) AppDelegate *ocj_appdelegate;

@property (nonatomic, strong) NSString *ocjStr_url;             ///<视频播放地址
@property (nonatomic) BOOL ocjBool_isfirst;                     ///<第一次点击播放监测网络状态

@property (nonatomic, assign) CGFloat sliderLastValue;          ///<
@property (nonatomic, assign) NSInteger seekTime;               ///<开始播放的时间(从xx秒开始播放视频跳转)
@property (nonatomic, strong) NSTimer *timer;                   ///<
@property (nonatomic, assign) OCJEnumVideoState state;          ///<视频播放状态
@property (nonatomic, assign) BOOL isPauseByUser;               //<是否用户手动暂停

@end

@implementation OCJVideoLiveView

- (instancetype)initWithFrame:(CGRect)frame tableView:(OCJBaseTableView *)tableView indexPath:(NSIndexPath *)indexPath {
    self = [super initWithFrame:frame];
    if (self) {
//        self.ocjTBView_live = tableView;
//        self.ocjIndexPath = indexPath;
        self.backgroundColor = OCJ_COLOR_BACKGROUND;
        self.isBottomLive = NO;
        self.isPlaying = NO;
        self.isReadyPlay = NO;
        self.isFullScreen = NO;
        self.ocjBool_isfirst = YES;
        self.isPauseByUser = NO;
    }
    return self;
}

/**
 视频url
 */
- (void)setOcjUrl_video:(NSURL *)ocjUrl_video {
  self.ocjStr_url = [NSString stringWithFormat:@"%@", ocjUrl_video];
    AVAsset *videoAsset = [AVURLAsset URLAssetWithURL:ocjUrl_video options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:videoAsset];
    self.ocjPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.ocjPlayer];
    
    if ([self.playerLayer.videoGravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }else {
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    self.playerLayer.frame = self.bounds;
    //设置playerLayer填充模式
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
    
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    
//    [self.ocjPlayer play];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
  // 监听loadedTimeRanges属性
  [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
  //缓冲区空了，需要等待数据(缓冲播放完了)
  [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
  //缓冲区有足够数据可以继续播放了
  [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
//  if (!(self.ocjTBView_live == nil)) {
//    [self.ocjTBView_live addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
//  }
  [self ocj_addSuspendView];
  [self ocj_addNotification];
  [self configureVolume];
  [self createTimer];
  self.state = VideoStateBuffering;
}

/**
 浮层
 */
- (void)ocj_addSuspendView {
    if ([self.ocjStr_status isEqualToString:@"2"]) {
        self.ocjEnumVideoPlayType = OCJVideoPlayTypeComing;
    }else if ([self.ocjStr_status isEqualToString:@"1"]) {
        self.ocjEnumVideoPlayType = OCJVideoPlayTypeLiving;
    }else {
        self.ocjEnumVideoPlayType = OCJVideoPlayTypeReplay;
    }
  
    self.ocjImageView_firstPicture = [[UIImageView alloc]init];
    self.ocjImageView_firstPicture.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.ocjImageView_firstPicture];
    [self.ocjImageView_firstPicture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
  
    self.ocjView_suspend = [[OCJLiveSuspendView alloc] initWithEnumType:self.ocjEnumVideoPlayType];
    self.ocjView_suspend.delegate = self;
    [self addSubview:self.ocjView_suspend];
    [self.ocjView_suspend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
}

- (void)setOcjModel_desc:(OCJResponceModel_VideoDetailDesc *)ocjModel_desc {
  
    self.ocjView_suspend.ocjLab_name.text = [NSString stringWithFormat:@"%@", ocjModel_desc.ocjStr_author];
    self.ocjView_suspend.ocjLab_date.text = [NSString stringWithFormat:@"%@", ocjModel_desc.ocjStr_videoDate];
    self.ocjView_suspend.ocjLab_watchNum.text = [NSString stringWithFormat:@"%@ 观看", ocjModel_desc.ocjStr_watchNum];
}

-(void)setOcjStr_firstImage:(NSString *)ocjStr_firstImage{
  _ocjStr_firstImage = ocjStr_firstImage;
  
  [self.ocjImageView_firstPicture ocj_setWebImageWithURLString:ocjStr_firstImage completion:nil];
  
}

- (void)setState:(OCJEnumVideoState)state {
  _state = state;
  if (state == VideoStatePlaying) {
    //改为黑色背景，否则占位图会显示
    UIImage *image = [self buttonImageFromColor:[UIColor whiteColor]];
    self.layer.contents = (id)image.CGImage;
  }else if (state == VideoStateFailed) {

  }
  
  //控制菊花显示、隐藏
  state == VideoStateBuffering ? ([self.ocjView_suspend.activity startAnimating]) : ([self.ocjView_suspend.activity stopAnimating]);
}
//通过颜色来生成一个纯色图片
- (UIImage *)buttonImageFromColor:(UIColor *)color
{
  CGRect rect = self.bounds;
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

/**
 添加通知
 */
- (void)ocj_addNotification {
  //推入后台
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
  //进入前台
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
  //slider滑动
  [self.ocjView_suspend.ocjSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
  //slider正在滑动事件
  [self.ocjView_suspend.ocjSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
  //slider结束滑动事件
  [self.ocjView_suspend.ocjSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchUpInside | UIControlEventTouchCancel];
}

/**
 重置播放器
 */

- (void)ocj_resetPlayer {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
  [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
  [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
  [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
//  if (!(self.ocjTBView_live == nil)) {
//    [self.ocjTBView_live removeObserver:self forKeyPath:@"contentOffset"];
//  }
  
    self.playerItem = nil;
    [self.ocjPlayer pause];
    [self.playerLayer removeFromSuperlayer];
    [self.ocjPlayer replaceCurrentItemWithPlayerItem:nil];
    self.ocjPlayer = nil;
//    self.ocjTBView_live = nil;
    self.ocjIndexPath = nil;
  [self.timer invalidate];
  self.timer = nil;
    [self removeFromSuperview];
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.playerItem) {
        if ([keyPath isEqualToString:@"status"]) {
          
            if (self.ocjPlayer.status == AVPlayerStatusReadyToPlay) {
                OCJLog(@"ReadyToPlay");
              [self.ocjImageView_firstPicture removeFromSuperview];
              self.state = VideoStatePlaying;
            }else if (self.ocjPlayer.status == AVPlayerStatusFailed) {
                OCJLog(@"加载失败");
              self.state = VideoStateFailed;
            }else {
                OCJLog(@"unknow");
            }
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
          // Will warn you when your buffer is empty
          //当缓冲是空的时候
          if (self.playerItem.playbackBufferEmpty) {
            self.state = VideoStateBuffering;
            //缓冲为空时要暂停一会儿获取缓冲视频
            [self bufferingSomeSeconds];
          }
        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
          
          //计算缓冲进度
          NSTimeInterval timeInterval = [self availableDuration];
          NSTimeInterval cuttTime = CMTimeGetSeconds(self.playerItem.currentTime);
          CMTime duration = self.playerItem.duration;
          CGFloat totalDuration = CMTimeGetSeconds(duration);
          
          //如果缓冲和当前slider的差值超过0.1就自动播放（解决弱网情况下不会自动播放问题）
          if (totalDuration > 0) {//url地址为回放时
            //计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration = self.playerItem.duration;
            CGFloat totalDuration = CMTimeGetSeconds(duration);
            [self.ocjView_suspend.ocjProgress setProgress:(timeInterval / totalDuration) animated:NO];
            
            //如果缓冲和当前slider的差值超过0.1就自动播放（解决弱网情况下不会自动播放问题）
            if (!self.isPauseByUser&& (self.ocjView_suspend.ocjProgress.progress - self.ocjView_suspend.ocjSlider.value > 1.0)) {
              [self.ocjPlayer play];
            }
          }else {//直播
              if (cuttTime < timeInterval) {
                if (self.isPlaying) {
                  [self.ocjView_suspend.activity stopAnimating];
                }
              }else {
                [self.ocjView_suspend.activity startAnimating];
              }
          }
          
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
          //缓冲好的时候
          if (self.playerItem.isPlaybackLikelyToKeepUp && self.state == VideoStateBuffering) {
            self.state = VideoStatePlaying;
          }
        }
    }
//    else if (object == self.ocjTBView_live) {
//        if ([keyPath isEqualToString:@"contentOffset"]) {
//            [self ocj_handlerScrollAction];
//        }
//    }
}

/**
 缓冲为空时要暂停一会儿获取缓冲视频
 */
- (void)bufferingSomeSeconds {
  self.state = VideoStateBuffering;
  //playbackBufferEmpty会反复进入，因此在bufferingSomeSeconds延时播放执行完之前再次调用此方法都忽略掉
  __block BOOL isBuffering = NO;
  if (isBuffering) {
    return;
  }
  isBuffering = YES;
  // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
  [self.ocjPlayer pause];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //如果此时用户已经暂停了，则不再需要开启播放了
    if (self.isPauseByUser) {
      isBuffering = NO;
      return ;
    }
    [self.ocjPlayer play];
    //如果执行了play还是没有播放则说明没有缓存好，则再次缓存一段时间
    isBuffering = NO;
    if (!self.playerItem.isPlaybackLikelyToKeepUp) {
      [self bufferingSomeSeconds];
    }
  });
}

- (NSTimeInterval)availableDuration {
  NSArray *loadedTimeRanges = [[self.ocjPlayer currentItem] loadedTimeRanges];
  CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
  float startSeconds = CMTimeGetSeconds(timeRange.start);
  float durationSeconds = CMTimeGetSeconds(timeRange.duration);
  NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
  return result;
}

- (void)dealloc {
    //移除观察者
    [self.playerItem removeObserver:self forKeyPath:@"status"];
  [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
  [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
  [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    self.playerItem = nil;
//  if (!(self.ocjTBView_live == nil)) {
//    [self.ocjTBView_live removeObserver:self forKeyPath:@"contentOffset"];
//    self.ocjTBView_live = nil;
//  }
  
}


/**
 滑动时处理播放控件
 */

- (void)ocj_handlerScrollAction {
    /*
    UITableViewCell *cell = [self.ocjTBView_live cellForRowAtIndexPath:self.ocjIndexPath];
    NSArray *visibleCells = self.ocjTBView_live.visibleCells;
  
    if ([visibleCells containsObject:cell]) {
        [self ocj_updatePlayerTOCell];
    }
     */
  /*
    if (![visibleCells containsObject:cell]) {
        [self ocj_updatePlayerTOBottom];
    }else {
        [self ocj_updatePlayerTOCell];
    }
   */
}

/**
 底部播放
 */
- (void)ocj_updatePlayerTOBottom {
    if (self.isBottomLive) {
        return;
    }
    self.isBottomLive = YES;
  
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.ocjTBView_live);
        make.top.mas_equalTo(self.ocjTBView_live.contentInset.bottom);
        make.height.mas_equalTo(SCREEN_WIDTH * 9 / 16.0);
    }];
}

- (void)ocj_updatePlayerTOCell {
  
    if (!self.isBottomLive) {
        return;
    }
    self.isBottomLive = NO;
    
    [self removeFromSuperview];

    UITableViewCell *cell = [self.ocjTBView_live cellForRowAtIndexPath:self.ocjIndexPath];
        
    [cell.contentView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(cell.contentView);
        make.height.mas_equalTo(SCREEN_WIDTH * 9 / 16.0);
    }];
}

/**
 中间大按钮点击播放
 */
- (void)ocj_play {
  
  if ([self.ocjStr_status isEqualToString:@"2"]) {//即将直播视频播放按钮点击事件
    [OCJProgressHUD ocj_showHudWithTitle:@"直播尚未开始，请您先观看其他视频～" andHideDelay:2.0];
    return;
  }
  
  NSTimeInterval time = CMTimeGetSeconds(self.ocjPlayer.currentTime);
  NSString *ocjStr_time = [NSString stringWithFormat:@"%f", time];
  [OcjStoreDataAnalytics trackEvent:@"AP1706A048" label:nil parameters:@{@"type":@"视频回放",@"status":@"停止",@"time":ocjStr_time,@"movieid":self.ocjStr_contentCode,@"pID":@"AP1706A048"}];
  
  [self ocj_checkNetworkStatusWithType:0];
}

/**
 小按钮点击暂停
 */
- (void)ocj_pauseOrPlay {
  
  if (!([self.ocjStr_url length] > 0)) {
    [OCJProgressHUD ocj_showHudWithTitle:@"视频播放地址为空" andHideDelay:2.0];
    return;
  }
  self.isPlaying = !self.isPlaying;
  if (self.isPlaying) {
    [self ocj_checkNetworkStatusWithType:1];
  }else {
    NSTimeInterval time = CMTimeGetSeconds(self.ocjPlayer.currentTime);
    NSString *ocjStr_time = [NSString stringWithFormat:@"%f", time];
    [OcjStoreDataAnalytics trackEvent:@"AP1706A048" label:nil parameters:@{@"type":@"视频回放",@"status":@"暂停",@"time":ocjStr_time,@"movieid":self.ocjStr_contentCode,@"pID":@"AP1706A048"}];
    [self.ocjView_suspend.ocjBtn_pause setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    [self.ocjPlayer pause];
    if (self.state == VideoStatePlaying || self.state == VideoStateBuffering) {
      self.state = VideoStatePause;
    }
    self.isPauseByUser = !self.isPauseByUser;
    [self.ocjView_suspend ocj_showSuspendView];
  }
  
}

/**
 点击中间大按钮播放
 */
- (void)ocj_MinBtnPlay {
  self.ocjView_suspend.ocjBool_isResponseTap = YES;
  if (self.ocjEnumVideoPlayType == OCJVideoPlayTypeLiving) {
    self.ocjView_suspend.ocjView_bottom.hidden = YES;
    self.ocjView_suspend.ocjView_bottom3.hidden = YES;
    self.ocjView_suspend.ocjView_bottom2.hidden = NO;
    [self.ocjView_suspend bringSubviewToFront:self.ocjView_suspend.ocjView_bottom2];
  }else if (self.ocjEnumVideoPlayType == OCJVideoPlayTypeReplay) {
    self.ocjView_suspend.ocjView_bottom.hidden = NO;
    self.ocjView_suspend.ocjView_bottom2.hidden = YES;
    self.ocjView_suspend.ocjView_bottom3.hidden = YES;
    [self.ocjView_suspend bringSubviewToFront:self.ocjView_suspend.ocjView_bottom];
  }
  
  NSTimeInterval time = CMTimeGetSeconds(self.ocjPlayer.currentTime);
  NSString *ocjStr_time = [NSString stringWithFormat:@"%f", time];
  [OcjStoreDataAnalytics trackEvent:@"AP1706A048" label:nil parameters:@{@"type":@"视频回放",@"status":@"开始",@"time":ocjStr_time,@"movieid":self.ocjStr_contentCode,@"pID":@"AP1706A048"}];
  self.state = VideoStateBuffering;
  self.isPauseByUser = NO;
  [self.ocjView_suspend.ocjBtn_pause setImage:[UIImage imageNamed:@"Btn_Pause_"] forState:UIControlStateNormal];
  self.isPlaying = !self.isPlaying;
  if (self.isPlaying) {
    self.ocjView_suspend.ocjBool_isShow = NO;
    [self.ocjPlayer play];
    [self.ocjView_suspend ocj_hideSuspendView];
  }
}

/**
 点击底部按钮播放
 */
- (void)ocj_bottonBtnPlay {
  self.state = VideoStateBuffering;
  NSTimeInterval time = CMTimeGetSeconds(self.ocjPlayer.currentTime);
  NSString *ocjStr_time = [NSString stringWithFormat:@"%f", time];
  [OcjStoreDataAnalytics trackEvent:@"AP1706A048" label:nil parameters:@{@"type":@"视频回放",@"status":@"开始",@"time":ocjStr_time,@"movieid":self.ocjStr_contentCode,@"pID":@"AP1706A048"}];
  if (self.isPlaying) {
    [self.ocjView_suspend.ocjBtn_pause setImage:[UIImage imageNamed:@"Btn_Pause_"] forState:UIControlStateNormal];
    [self.ocjPlayer play];
    self.isPauseByUser = NO;
    if (self.state == VideoStatePause) {
      self.state = VideoStatePlaying;
    }
    [self.ocjView_suspend ocj_hideSuspendView];
  }else {
    
  }
}

/**
 检测网络状态，非wifi提醒用户
 */
- (void)ocj_checkNetworkStatusWithType:(NSInteger)type {
  __weak OCJVideoLiveView *weakSelf = self;
  if (self.ocjBool_isfirst) {
    if (![AFNetworkReachabilityManager sharedManager].reachableViaWiFi) {
      self.ocjBool_isfirst = NO;
      [OCJProgressHUD ocj_showAlertByVC:[AppDelegate ocj_getTopViewController] withAlertType:OCJAlertTypeNone title:nil message:@"当前网络状态为非WIFI状态，确认继续播放吗" sureButtonTitle:@"确定" CancelButtonTitle:@"取消" action:^(NSInteger clickIndex) {
        if (clickIndex == 1) {
          [weakSelf ocj_playWithType:type];
        }else {
          self.isPlaying = NO;
        }
      }];
    }else {
      [weakSelf ocj_playWithType:type];
    }
  }else {
    [weakSelf ocj_playWithType:type];
  }
}

- (void)ocj_playWithType:(NSInteger)type {
  if (type == 0) {
    [self ocj_MinBtnPlay];
  }else {
    [self ocj_bottonBtnPlay];
  }
}
#pragma mark - Notification
- (void)appDidEnterBackground {
  [self.ocjPlayer pause];
  self.state = VideoStatePause;
}

- (void)appDidEnterPlayGround {
  if (!self.isPauseByUser && self.isPlaying) {
    self.state = VideoStatePlaying;
    self.isPauseByUser = NO;
    [self.ocjPlayer play];
  }
}

#pragma mark - 获取系统音量

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
      [self.ocjPlayer play];
      break;
    case AVAudioSessionRouteChangeReasonCategoryChange:
      NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
      break;
    default:
      break;
  }
}

#pragma mark - 进度条事件
- (void)progressSliderTouchBegan:(UISlider *)slider {
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  if (self.ocjPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
    //暂停timer
    [self.timer setFireDate:[NSDate distantFuture]];
  }
}

- (void)progressSliderValueChanged:(UISlider *)slider {
  if (self.ocjPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
    NSString *style = @"";
    CGFloat value = slider.value - self.sliderLastValue;
    self.sliderLastValue = slider.value;
    [self.ocjPlayer pause];
    
    CGFloat total = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
    //计算出拖动的当前秒数
    NSInteger draggedSeconds = floor(total * slider.value);
    //转换成CMTime才能给player来控制播放进度
    CMTime draggedCMTime = CMTimeMake(draggedSeconds, 1);
    //拖拽的时长
    NSInteger proSec = (NSInteger)CMTimeGetSeconds(draggedCMTime) / 60;//当前秒
    NSInteger proMin = (NSInteger)CMTimeGetSeconds(draggedCMTime) % 60;//当前分钟
    //duration总时长
    NSInteger durSec = (NSInteger)total / 60;//总秒数
    NSInteger durMin = (NSInteger)total % 60;//总分钟
    
    NSString *currentTime = [NSString stringWithFormat:@"%02zd:%02zd", proSec, proMin];
    NSString *totalTime = [NSString stringWithFormat:@"%02zd:%02zd", durSec, durMin];
    if (total > 0) {
      self.ocjView_suspend.ocjLab_currentTime.text = currentTime;
      
    }else {
      slider.value = 0;
    }
  }else {//加载失败
    slider.value = 0;
  }
}

//slider滑动结束
-(void)progressSliderTouchEnded:(UISlider *)slider {
  if (self.ocjPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
      self.ocjView_suspend.ocjLab_horizon.hidden = YES;
    });
    //结束滑动时把开始播放按钮改为播放状态
    self.ocjView_suspend.ocjBtn_pause.selected = YES;
    
    //滑动结束时隐藏operationView
//    [self autoFadeOutOperationView];
    //视频总时间长度
    CGFloat total = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
    //计算出拖动的当前秒数
    NSInteger draggedSeconds = floorf(total * slider.value);
    //从指定时间开始播放视频（跳转到指定时间开始播放）
    [self seekToTime:draggedSeconds completionHandler:nil];
  }
}

//从指定时间开始播放视频（跳转到指定时间开始播放）
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler {
  [self.ocjView_suspend.activity startAnimating];
  if (self.ocjPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
    // seekTime:completionHandler:不能精确定位
    // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
    // 转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.ocjPlayer seekToTime:dragedCMTime toleranceBefore:CMTimeMake(1, 5) toleranceAfter:CMTimeMake(1, 5) completionHandler:^(BOOL finished) {
      //        [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
      // 视频跳转回调
      if (completionHandler) {
        completionHandler(finished);
      }
      
      if (finished) {//跳转完成之后再继续播放
        [self.ocjView_suspend.activity stopAnimating];
        //在跳转完成后重新开启timer，否则显示当前播放时间的label会跳回之前位置再跳到指定时间的位置
        [self.timer setFireDate:[NSDate date]];
        // 如果点击了暂停按钮
        if (self.isPauseByUser){
          return;
        }
        [self.ocjPlayer play];
        self.seekTime = 0;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) {
          self.state = VideoStateBuffering;
        }
      }else {
        NSLog(@"111");
        [self.ocjView_suspend.activity startAnimating];
      }
      
      
    }];
  }
}

- (void)ocj_sliderTapped:(CGFloat)value {
  [self.ocjPlayer pause];
  //视频总长度
  CGFloat total = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
  //计算出拖动的当前秒数
  NSInteger dragedSeconds = floorf(total * value);
  [self seekToTime:dragedSeconds completionHandler:^(BOOL finished) {
    if (finished) {
      //只要点击进度条就跳转播放
      self.ocjView_suspend.ocjBtn_pause.selected = NO;
      [self.ocjPlayer play];
    }
  }];
}

#pragma mark -定时器
//定时器
-(void)createTimer {
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playerTimerAction) userInfo:nil repeats:YES];
  [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//定时器启动
-(void)playerTimerAction {
  if (self.playerItem.duration.timescale != 0) {
    self.ocjView_suspend.ocjSlider.value = CMTimeGetSeconds([self.playerItem currentTime])/(self.playerItem.duration.value / self.playerItem.duration.timescale);//当前进度
    //当前时长进度progress
    NSInteger proMin = (NSInteger)CMTimeGetSeconds([self.ocjPlayer currentTime]) / 60;//当前分钟
    NSInteger proSec = (NSInteger)CMTimeGetSeconds([self.ocjPlayer currentTime]) % 60;//当前秒
    //duration 总时长
    OCJLog(@"value = %lld", self.playerItem.duration.value);
    NSInteger durMin = (NSInteger)self.playerItem.duration.value / self.playerItem.duration.timescale / 60;//总分钟
    NSInteger durSec = (NSInteger)self.playerItem.duration.value / self.playerItem.duration.timescale % 60;//总秒
    
    NSInteger surplusTime = (durMin * 60 + durSec) - (proMin * 60 + proSec);
    NSInteger surplusMin = surplusTime / 60;//剩余分钟
    NSInteger surplusSec = surplusTime % 60;//剩余秒
    
    self.ocjView_suspend.ocjLab_currentTime.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    //        NSLog(@"str = %@", self.operationView.currentTimeLbl.text);
    self.ocjView_suspend.ocjLab_totalTime.text = [NSString stringWithFormat:@"-%02zd:%02zd", surplusMin, surplusSec];
  }
}

#pragma mark - 全屏事件
/**
 全屏
 */
- (void)ocj_fullScreen {
  if (self.ocjLivingViewBlock) {
    [self.ocjPlayer pause];
    self.ocjView_suspend.ocjBtn_play.hidden = YES;
    [self.ocjView_suspend.ocjBtn_pause setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    self.ocjLivingViewBlock();
    return;
  }
    self.isFullScreen = !self.isFullScreen;
    if (self.isFullScreen) {
      [self ocj_allowRotation];
      [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
      [self ocj_changeLiveViewFrame];
    }else {
      [self ocj_stopRotation];
      [self interfaceOrientation:UIInterfaceOrientationPortrait];
      [self ocj_changeLiveViewFrame];
    }
}

/**
 旋转屏幕
 */
- (void)ocj_allowRotation {
  self.ocj_appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  self.ocj_appdelegate.ocjInt_allowRotation = 2;
}

- (void)ocj_stopRotation {
  self.ocj_appdelegate.ocjInt_allowRotation = 1;
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

- (void)ocj_changeLiveViewFrame {
  self.playerLayer.frame = self.bounds;
  
  [self.ocjView_suspend mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.mas_equalTo(self);
    make.height.mas_equalTo(SCREEN_WIDTH * 9 / 16.0);
  }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
