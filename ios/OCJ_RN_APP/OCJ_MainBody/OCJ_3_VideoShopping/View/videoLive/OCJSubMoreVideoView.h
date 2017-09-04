//
//  OCJSubMoreVideoView.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/12.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_videoLive.h"

typedef void (^OCJTappedVideoBlock)(NSString *ocjStr_contentCode);

@interface OCJSubMoreVideoView : UIView

@property (nonatomic, strong) OCJResponceModel_VideoDetailDesc *ocjModel_desc;///<数据model
@property (nonatomic, copy) OCJTappedVideoBlock ocjTappedVideoBlock;

@end
