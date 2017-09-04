//
//  JZPushLiveVideo.h
//  JZMSGApi
//
//  Created by wangcliff on 16/12/29.
//  Copyright © 2016年 jz. All rights reserved.
//  直播器(推流)
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "JZCustomer.h"
//#import "JZLiveRecord.h"
@class JZCustomer;
@class JZLiveRecord;
@class JZMainView;
@protocol JZPushLiveVideoDelegate <NSObject>
@required
- (void)showLiveEndView:(NSInteger)maxOnlineNumber;//展示直播结束界面
- (void)showPersonalInfo:(JZCustomer *)user;//创建个人信息view
- (void)showVoteRankView;//展示投票排行榜
@end
@interface JZPushLiveVideo : NSObject
@property (nonatomic, weak) id<JZPushLiveVideoDelegate> delegate;
@property (nonatomic, strong) JZCustomer *user;//主播信息
@property (nonatomic, strong) JZLiveRecord *record;//房间信息
@property (nonatomic, assign) BOOL enableSkin;//美颜开关,默认是关的
@property (nonatomic, assign) BOOL enableMessage;//信息开关,默认是关的
@property (nonatomic, assign) AVCaptureTorchMode torchMode; //闪光灯开关,默认是关的
@property (nonatomic, assign) AVCaptureDevicePosition position;//设置前置摄像头或后置摄像头,默认后置
@property (nonatomic, strong) NSString* preset;//设置采集质量
@property (nonatomic, assign) CGSize videoSize;//默认360, 640,设置直播分辨率
@property (nonatomic, assign) NSInteger videoMaxBitRate;//最大码率，网速变化的时候会根据这个值来提供建议码率(默认 1500 * 1000)
@property (nonatomic, assign) NSInteger videoMinBitRate;//最小码率，网速变化的时候会根据这个值来提供建议码率(默认 400 * 1000)
@property (nonatomic, assign) NSInteger videoBitRate;//默认码率，在最大码率和最小码率之间(默认 600 * 1000)
@property (nonatomic, assign) NSInteger audioBitRate;//设置音频码率,默认 64 * 1000
@property (nonatomic, assign) NSInteger fps;//设置帧数,默认30
@property (nonatomic, assign) BOOL isHiddenShareButton;//是否隐藏分享按钮

//sdk内部属性(只读,使用sdk不需要操作)
@property (nonatomic, weak) JZMainView *mainFunctionView;//UI界面view

+ (JZPushLiveVideo *)getInstance:(NSInteger)liveMode;//选择实例模式(直播器器模板默认0,0横竖都有,1只有竖屏,2横竖都有)
- (void)initSocket;//初始化即时通讯
- (void)initLiveVideoConfiguration;//初始化直播器配置
- (UIView *)previewLiveVideoView;//显示view
- (void)JZLiveVideoConnectServer;//推流到服务器
- (void)hideInteractionView;//隐藏交互view只留显示媒体view和退出按钮
- (void)showInteractionView;//展示交互view

@end
