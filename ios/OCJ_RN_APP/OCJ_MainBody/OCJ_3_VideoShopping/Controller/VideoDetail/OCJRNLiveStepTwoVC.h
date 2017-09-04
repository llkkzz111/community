//
//  OCJRNLiveStepTwoVC.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/11.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJBaseVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface OCJRNLiveStepTwoVC : OCJBaseVC

@property (nonatomic, strong) MPMoviePlayerViewController *ocjMPPlarViewVC; ///<
@property (nonatomic, strong) NSString *ocJStr_url;       ///<视频播放地址

@end
