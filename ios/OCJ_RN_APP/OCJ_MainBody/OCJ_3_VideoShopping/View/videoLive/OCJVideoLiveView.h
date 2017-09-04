//
//  OCJVideoLiveView.h
//  OCJ
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "OCJResponseModel_videoLive.h"
#import "OCJLiveSuspendView.h"

typedef NS_ENUM(NSInteger, OCJEnumVideoState) {
  VideoStateFailed,       ///<播放失败
  VideoStateBuffering,    ///<正在缓冲
  VideoStatePlaying,      ///<正在播放
  VideoStateStopped,      ///<停止播放
  VideoStatePause         ///<暂停播放
};

typedef NS_ENUM(NSInteger, OCJEnumPlayWays) {
  OCJEnumPlayWaysAV,      ///<原生视频详情播放
  OCJEnumPlayWaysMP       ///<RN商品详情播放
};

typedef void (^OCJLivingViewBlock)();

/**
 视频播放控件
 */
@interface OCJVideoLiveView : UIView

@property (nonatomic, strong) NSURL *ocjUrl_video;///<播放地址

@property (nonatomic, copy) NSString* ocjStr_firstImage;///< 首帧图片

@property (nonatomic, strong) AVPlayer *ocjPlayer;///<播放器@property (nonatomic) BOOL isFullScreen;///<是否全屏

@property (nonatomic, assign) BOOL isPlaying;               ///<是否在播放

@property (nonatomic, strong) AVPlayerItem *playerItem;     ///<
@property (nonatomic, strong) NSString *ocjStr_status;      ///<视频状态
@property (nonatomic, strong) NSString *ocjStr_contentCode; ///<视频id

@property (nonatomic) OCJEnumPlayWays ocjEnumPlayWays;      ///<播放渠道
@property (nonatomic, strong) OCJLiveSuspendView *ocjView_suspend;///<浮层
@property (nonatomic, copy) OCJLivingViewBlock ocjLivingViewBlock;///<推出MPMoviePlayer

@property (nonatomic, strong) OCJResponceModel_VideoDetailDesc *ocjModel_desc;

- (instancetype)initWithFrame:(CGRect)frame tableView:(OCJBaseTableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler;

- (void)ocj_resetPlayer;

@end
