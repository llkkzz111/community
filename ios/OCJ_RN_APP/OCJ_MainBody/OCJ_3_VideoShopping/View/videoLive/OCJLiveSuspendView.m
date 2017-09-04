//
//  OCJLiveSuspendView.m
//  OCJ
//
//  Created by Ray on 2017/6/2.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJLiveSuspendView.h"

@interface OCJLiveSuspendView ()

@property (nonatomic, strong) UIView *ocjView_replay;///<精彩回放
@property (nonatomic, strong) UIImageView *ocjImgView;///<
@property (nonatomic, strong) UIView *ocjView_line;///<线
@property (nonatomic) OCJEnumVideoPlayType ocjEnumVideoPlayType;///<视频类型
@property (nonatomic, strong) UIView *ocjView_top;    ///<顶部view
@property (nonatomic) BOOL ocjBool_isPause;           ///<播放、暂停

@end

@implementation OCJLiveSuspendView

- (instancetype)initWithEnumType:(OCJEnumVideoPlayType)videoPlaryType {
    self = [super init];
    if (self) {
        self.ocjEnumVideoPlayType = videoPlaryType;
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tappedView)];
      [self addGestureRecognizer:tap];
      
      self.ocjBool_isShow = YES;
      self.ocjBool_isPause = YES;
      self.ocjBool_isResponseTap = NO;
      [self ocj_addTopViews];
      //底部显示播放、暂停按钮
      [self ocj_addBottomView];
      
      [self ocj_addBottomView2];
      //底部显示观看人数view
      [self ocj_addBottomView3];
      
      [self.activity stopAnimating];
      self.ocjView_bottom.hidden = YES;
      self.ocjView_bottom2.hidden = YES;
      self.ocjView_bottom3.hidden = NO;
      [self bringSubviewToFront:self.ocjView_bottom3];
      
    }
    return self;
}

- (void)ocj_addBottomView2 {
  //底部播放人数view
  self.ocjView_bottom2 = [[UIView alloc] init];
  self.ocjView_bottom2.backgroundColor = [UIColor colorWSHHFromHexString:@"000000"];
  self.ocjView_bottom2.alpha = 0.6;
  [self addSubview:self.ocjView_bottom2];
  [self.ocjView_bottom2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.mas_equalTo(self);
    make.height.mas_equalTo(@30);
  }];
  //全屏
  UIButton *ocjBtn_fullScreen = [[UIButton alloc] init];
  [ocjBtn_fullScreen setImage:[UIImage imageNamed:@"icon_zoom"] forState:UIControlStateNormal];
  [ocjBtn_fullScreen addTarget:self action:@selector(ocj_clickedFullScreesBtn) forControlEvents:UIControlEventTouchUpInside];
  [self.ocjView_bottom2 addSubview:ocjBtn_fullScreen];
  [ocjBtn_fullScreen mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjView_bottom2.mas_right).offset(-10);
    make.top.bottom.mas_equalTo(self.ocjView_bottom2);
    make.width.mas_equalTo(@30);
  }];
}

- (void)ocj_addBottomView3 {
  self.ocjView_bottom3 = [[UIView alloc] init];
  self.ocjView_bottom3.backgroundColor = [UIColor blackColor];
  self.ocjView_bottom3.alpha = 0.6;
  [self addSubview:self.ocjView_bottom3];
  [self.ocjView_bottom3 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.mas_equalTo(self);
    make.height.mas_equalTo(@30);
  }];
  //时间
  self.ocjLab_date = [[OCJBaseLabel alloc] init];
  self.ocjLab_date.font = [UIFont systemFontOfSize:12];
  self.ocjLab_date.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
  self.ocjLab_date.text = @"05月11日 14:00-16:00";
  self.ocjLab_date.textAlignment = NSTextAlignmentRight;
  [self.ocjView_bottom3 addSubview:self.ocjLab_date];
  [self.ocjLab_date mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjView_bottom3.mas_right).offset(-15);
    make.bottom.mas_equalTo(self.ocjView_bottom3.mas_bottom).offset(-8);
  }];
  
  self.ocjView_line = [[UIView alloc] init];
  self.ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
  [self.ocjView_bottom3 addSubview:self.ocjView_line];
  [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjLab_date.mas_left).offset(-5);
    make.top.mas_equalTo(self.ocjLab_date.mas_top).offset(2);
    make.bottom.mas_equalTo(self.ocjLab_date.mas_bottom).offset(-2);
    make.width.mas_equalTo(@0.5);
  }];
  //名字
  self.ocjLab_name = [[OCJBaseLabel alloc] init];
  self.ocjLab_name.text = @"徐菲";
  self.ocjLab_name.font = [UIFont systemFontOfSize:12];
  self.ocjLab_name.textAlignment = NSTextAlignmentRight;
  self.ocjLab_name.textColor = [UIColor colorWSHHFromHexString:@"#FFFFFF"];
  //    [self.ocjLab_name setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];//使label约束宽度根据内容自适应
  [self.ocjView_bottom3 addSubview:self.ocjLab_name];
  [self.ocjLab_name mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.mas_equalTo(self.ocjView_bottom3).offset(-8);
    if (self.ocjEnumVideoPlayType == OCJVideoPlayTypeReplay) {
      make.right.mas_equalTo(self.ocjView_bottom3.mas_right).offset(-15);
      self.ocjLab_date.hidden = YES;
      self.ocjView_line.hidden = YES;
    }else {
      make.right.mas_equalTo(self.ocjView_line.mas_left).offset(-5);
      self.ocjLab_date.hidden = NO;
      self.ocjView_line.hidden = NO;
    }
  }];
  //眼睛图片
  self.ocjImgView = [[UIImageView alloc] init];
  [self.ocjImgView setImage:[UIImage imageNamed:@"Icon_eye_"]];
  [self.ocjView_bottom3 addSubview:self.ocjImgView];
  [self.ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_bottom3.mas_left).offset(17);
    make.centerY.mas_equalTo(self.ocjLab_date);
    make.width.mas_equalTo(@11);
    make.height.mas_equalTo(@7);
  }];
  //观看人数
  self.ocjLab_watchNum = [[OCJBaseLabel alloc] init];
  self.ocjLab_watchNum.text = @"10209 观看";
  self.ocjLab_watchNum.font = [UIFont systemFontOfSize:12];
  self.ocjLab_watchNum.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
  self.ocjLab_watchNum.textAlignment = NSTextAlignmentLeft;
  [self.ocjView_bottom3 addSubview:self.ocjLab_watchNum];
  [self.ocjLab_watchNum mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjImgView.mas_right).offset(5);
    make.centerY.mas_equalTo(self.ocjImgView);
  }];
}

- (void)ocj_addTopViews {
    //
    self.ocjView_replay = [[UIView alloc] init];
  
    [self addSubview:self.ocjView_replay];
    [self.ocjView_replay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.width.mas_equalTo(@71);
        make.height.mas_equalTo(@19);
    }];
    //精彩回放背景图
    UIImageView *ocjImgView = [[UIImageView alloc] init];
    [self.ocjView_replay addSubview:ocjImgView];
    [ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.ocjView_replay);
    }];
    //精彩回放label
    UILabel *ocjLab_replay = [[UILabel alloc] init];
    ocjLab_replay.font = [UIFont systemFontOfSize:13];
    ocjLab_replay.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    ocjLab_replay.textAlignment = NSTextAlignmentLeft;
    [self.ocjView_replay addSubview:ocjLab_replay];
    [ocjLab_replay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_replay.mas_left).offset(11);
        make.top.mas_equalTo(self.ocjView_replay);
        make.width.mas_equalTo(@55);
        make.height.mas_equalTo(@19);
    }];
    //播放按钮
    self.ocjBtn_play = [[UIButton alloc] init];
    [self.ocjBtn_play setImage:[UIImage imageNamed:@"Icon_play_"] forState:UIControlStateNormal];
    [self.ocjBtn_play addTarget:self action:@selector(ocj_clickedPlayBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ocjBtn_play];
    [self.ocjBtn_play mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(@55);
        make.height.mas_equalTo(@55);
    }];
    //正在直播
    if (self.ocjEnumVideoPlayType == OCJVideoPlayTypeLiving) {
        [ocjImgView setImage:[UIImage imageNamed:@"Icon_info_bg_"]];
        ocjLab_replay.text = @"正在直播";
    }else if (self.ocjEnumVideoPlayType == OCJVideoPlayTypeReplay) {//精彩回放
        [ocjImgView setImage:[UIImage imageNamed:@"Icon_gray_bg2_"]];
        ocjLab_replay.text = @"精彩回放";
    }else if (self.ocjEnumVideoPlayType == OCJVideoPlayTypeComing) {//即将播出
        [ocjImgView setImage:[UIImage imageNamed:@"Icon_yellow_bg2_"]];
        ocjLab_replay.text = @"即将播出";
    }
  //
  self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [self addSubview:self.activity];
  [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.mas_equalTo(self);
  }];
}


/**
 底部进度条、全屏、播放view
 */
- (void)ocj_addBottomView {
  self.ocjView_bottom = [[UIView alloc] init];
  self.ocjView_bottom.backgroundColor = [UIColor colorWSHHFromHexString:@"000000"];
  self.ocjView_bottom.alpha = 0.6;
  [self addSubview:self.ocjView_bottom];
  [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.mas_equalTo(self);
    make.height.mas_equalTo(@30);
  }];
  //暂停
  self.ocjBtn_pause = [[UIButton alloc] init];
  [self.ocjBtn_pause setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
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
  //当前播放时间
  self.ocjLab_currentTime = [[UILabel alloc] init];
  self.ocjLab_currentTime.font = [UIFont systemFontOfSize:12];
  self.ocjLab_currentTime.textColor = [UIColor whiteColor];
  self.ocjLab_currentTime.textAlignment = NSTextAlignmentCenter;
  [self.ocjView_bottom addSubview:self.ocjLab_currentTime];
  [self.ocjLab_currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjBtn_pause.mas_right).offset(-3);
    make.centerY.mas_equalTo(self.ocjBtn_pause.mas_centerY);
    make.width.mas_equalTo(@43);
  }];
  //视频总时长
  self.ocjLab_totalTime = [[UILabel alloc] init];
  self.ocjLab_totalTime.font = [UIFont systemFontOfSize:12];
  self.ocjLab_totalTime.textColor = [UIColor whiteColor];
  self.ocjLab_totalTime.textAlignment = NSTextAlignmentCenter;
  [self.ocjView_bottom addSubview:self.ocjLab_totalTime];
  [self.ocjLab_totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(ocjBtn_fullScreen.mas_left).offset(3);
    make.centerY.mas_equalTo(self.ocjBtn_pause.mas_centerY);
    make.width.mas_equalTo(@43);
  }];
  //进度条
  self.ocjProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
  self.ocjProgress.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
  self.ocjProgress.trackTintColor = [UIColor clearColor];
  [self.ocjView_bottom addSubview:self.ocjProgress];
  [self.ocjProgress mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_currentTime.mas_right).offset(4);
    make.right.mas_equalTo(self.ocjLab_totalTime.mas_left).offset(-4);
    make.centerY.mas_equalTo(self.ocjBtn_pause.mas_centerY);
  }];
  //滑竿
  UITapGestureRecognizer *tapSlider = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tappedSlider:)];
  self.ocjSlider = [[UISlider alloc] init];
  [self.ocjSlider setThumbImage:[UIImage imageNamed:@"player_slider"] forState:UIControlStateNormal];
  self.ocjSlider.maximumValue = 1;
  self.ocjSlider.minimumTrackTintColor = [UIColor whiteColor];
  self.ocjSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
  [self.ocjSlider addGestureRecognizer:tapSlider];
  [self.ocjView_bottom addSubview:self.ocjSlider];
  [self.ocjSlider mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_currentTime.mas_right).offset(4);
    make.right.mas_equalTo(self.ocjLab_totalTime.mas_left).offset(-4);
    make.centerY.mas_equalTo(self.ocjLab_currentTime.mas_centerY).offset(-1);
    make.height.mas_equalTo(@30);
  }];
}

- (void)ocj_resetSuspendView {
  self.ocjSlider.value = 0;
  self.ocjProgress.progress = 0;
  self.ocjLab_currentTime.text = @"00:00";
  self.ocjLab_totalTime.text = @"00:00";
  self.backgroundColor = [UIColor clearColor];
}

- (void)ocj_hideSuspendView {
  self.ocjBtn_play.hidden = YES;
//    self.ocjView_replay.hidden = YES;
    self.ocjBtn_play.hidden = YES;
  self.ocjView_bottom.hidden = YES;
  self.ocjView_bottom2.hidden = YES;
}

- (void)ocj_showSuspendView {
//    self.ocjLab_date.hidden = NO;
//    self.ocjLab_name.hidden = NO;
//    self.ocjView_line.hidden = NO;
//    self.ocjLab_watchNum.hidden = NO;
//    self.ocjImgView.hidden = NO;
//    self.ocjView_replay.hidden = NO;
    self.ocjBtn_play.hidden = NO;
  if (self.ocjEnumVideoPlayType == OCJVideoPlayTypeLiving) {
    self.ocjView_bottom2.hidden = NO;
  }else {
    self.ocjView_bottom.hidden = NO;
  }
}

/**
 中间播放按钮
 */
- (void)ocj_clickedPlayBtn {
    if (self.delegate) {
        [self.delegate ocj_play];
    }
}

/**
 播放、暂停
 */
- (void)ocj_clickedPauseBtn {
  if (self.delegate) {
    [self.delegate ocj_pauseOrPlay];
  }
}

/**
 点击全屏按钮
 */
- (void)ocj_clickedFullScreesBtn {
  if (self.delegate) {
    [self.delegate ocj_fullScreen];
  }
}

/**
 单击浮层
 */
- (void)ocj_tappedView {
  if (self.ocjBool_isResponseTap) {
    if (self.ocjEnumVideoPlayType == OCJVideoPlayTypeLiving) {
      if (!self.ocjBool_isShow) {
        self.ocjView_bottom2.hidden = NO;
      }else {
        self.ocjView_bottom2.hidden = YES;
      }
    }else {
      if (!self.ocjBool_isShow) {
        self.ocjView_bottom.hidden = NO;
      }else {
        self.ocjView_bottom.hidden = YES;
      }
    }
    
    self.ocjBool_isShow = !self.ocjBool_isShow;
  }
  
}

- (void)ocj_tappedSlider:(UITapGestureRecognizer *)tap {
  OCJLog(@"tapptd");
  if ([tap.view isKindOfClass:[UISlider class]] && self.delegate) {
    UISlider *slider = (UISlider *)tap.view;
    CGPoint point = [tap locationInView:slider];
    CGFloat length = slider.frame.size.width;
    //视频跳转的value
    //计算点击的位置栈比
    CGFloat tapValue = point.x / length;
    [self.delegate ocj_sliderTapped:tapValue];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
