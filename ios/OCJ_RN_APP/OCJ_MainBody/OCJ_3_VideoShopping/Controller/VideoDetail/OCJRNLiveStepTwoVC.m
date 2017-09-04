//
//  OCJRNLiveStepTwoVC.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/11.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJRNLiveStepTwoVC.h"
#import "AppDelegate.h"

@interface OCJRNLiveStepTwoVC ()

@property (nonatomic, strong) MPMoviePlayerController *ocjMPMoviePlayer;    ///<MP播放器
@property (nonatomic, strong) AppDelegate *ocj_appdelegate;

@end

@implementation OCJRNLiveStepTwoVC

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  [self ocj_setSelf];
    // Do any additional setup after loading the view.
}
/**
 旋转屏幕
 */
- (void)ocj_allowRotation {
  
}

- (void)ocj_stopRotation {
  
}
- (void)dealloc {
  [self.ocjMPMoviePlayer.view removeFromSuperview];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)ocj_setSelf {
  
//  self.ocjMPPlarViewVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.ocJStr_url]];
  [self.ocjMPPlarViewVC.moviePlayer prepareToPlay];
//  [self presentMoviePlayerViewControllerAnimated:self.ocjMPPlarViewVC];
  [self.ocjMPPlarViewVC.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
  self.ocjMPPlarViewVC.moviePlayer.scalingMode = MPMovieScalingModeFill;
//  self.ocjMPPlarViewVC.moviePlayer.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
//  self.ocjMPPlarViewVC.moviePlayer.view.center = CGPointMake(SCREEN_HEIGHT / 2.0, SCREEN_WIDTH / 2.0);
  CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI / 2);
  [self.ocjMPPlarViewVC.moviePlayer.view setTransform:transform];
  [self.view addSubview:self.ocjMPPlarViewVC.moviePlayer.view];
  [self.ocjMPPlarViewVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(self.view);
    make.height.mas_equalTo(SCREEN_WIDTH);
    make.width.mas_equalTo(SCREEN_HEIGHT);
  }];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackstateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
  [self.ocjMPPlarViewVC.moviePlayer play];
}

- (void)ocj_addNoti
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(playbackstateDidChange:)
                                               name:MPMoviePlayerPlaybackStateDidChangeNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)movieFinishedCallBack:(NSNotification *)noti {
  OCJLog(@"currentTime = %f", self.ocjMPPlarViewVC.moviePlayer.currentPlaybackTime);
  CGFloat currentTime = self.ocjMPPlarViewVC.moviePlayer.currentPlaybackTime;
  NSString *ocjStr_time = [NSString stringWithFormat:@"%f", currentTime];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayerGoonPlay" object:nil userInfo:@{@"currentTime":self.ocjMPPlarViewVC}];
  [self dismissMoviePlayerViewControllerAnimated];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playbackstateDidChange:(NSNotification *)noti
{
  switch (self.ocjMPMoviePlayer.playbackState) {
    case MPMoviePlaybackStateInterrupted:
      //中断
      NSLog(@"中断");
      break;
    case MPMoviePlaybackStatePaused:
      //暂停
      
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
      break;
      
    default:
      break;
  }
}

- (void)loadStateDidChange:(NSNotification *)noti {
  switch (self.ocjMPMoviePlayer.loadState) {
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
  [self dismissMoviePlayerViewControllerAnimated];
  [self dismissViewControllerAnimated:YES completion:nil];
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
