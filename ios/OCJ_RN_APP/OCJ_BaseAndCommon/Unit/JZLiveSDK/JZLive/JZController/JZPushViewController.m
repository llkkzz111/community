//
//  JZPushViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#define loginTag 1
#define ChargeTag 2
#import "JZPushViewController.h"
#import <JZLiveSDK/JZLiveSDK.h>
#import "UIImageView+AFNetworking.h"
//#import "UMSocialUIManager.h"
//#import "JZConstants.h"//定义的常量
#import "AppDelegate.h"//改变屏幕方向的代理
#import "UIImageView+WebCache.h"//第三方的加载图片sdwebimage
#import "JZLiveEndViewController.h"//结束直播后的显示界面
#import "PersonInformationView.h"//个人信息view
#import "JZShareView.h"//分享页面
#import "AwardListView.h"//投票排行榜
@interface JZPushViewController () <UIAlertViewDelegate, UIGestureRecognizerDelegate, JZPushLiveVideoDelegate, PersonInformationViewDelegate>
@property (nonatomic, assign) CGFloat               screenLight;//屏幕亮度
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;//播放缓冲图标
@property (nonatomic, assign) BOOL                  isGoLogin;//判断是否从播放器去登陆页面
@property (nonatomic, weak) PersonInformationView   *personInfoView;//个人信息view
@property (nonatomic, weak) JZShareView               *shareSelectView;//分享选择列表
@property (nonatomic, strong) JZPushLiveVideo       *JZLiveVideo;
@property (nonatomic, strong) UIView                *livePushView;//录制推流view
@property (nonatomic, assign) BOOL                  addLivePushView;//暂时使用这个解决显示问题
@end

@implementation JZPushViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self selectVideoDirection];
    [self performSelector:@selector(loadJZLiveSDK) withObject:nil afterDelay:0.05];//延时是为了让屏幕完成旋转
}
- (void)loadJZLiveSDK {
    JZPushLiveVideo *liveVideo = [JZPushLiveVideo getInstance:2];
    liveVideo.delegate= self;
    _JZLiveVideo = liveVideo;
    liveVideo.user = _user;
    liveVideo.record = _record;
    liveVideo.videoMaxBitRate = 1500 * 1000;//设置最大码率,设置最大码率和 最小码率后 SDK 会根据网络状况自动调整码率
    liveVideo.videoBitRate = 600 * 1000;//设置当前视频码率 configuration.videoMinBitRate = 400 * 1000;//设置最小码率 configuration.audioBitRate = 64 * 1000;//设置音频码率
    //configuration.videoSize = CGSizeMake(360, 640);//设置直播分辨率
    liveVideo.videoSize = CGSizeMake(480, 854);
    liveVideo.fps = 20;//设置帧数
    liveVideo.preset = AVCaptureSessionPresetiFrame1280x720;//设置采集质量
    //设置前置摄像头或后置 摄像头
    liveVideo.position = AVCaptureDevicePositionBack;//设置前置摄像头或后置 摄像头
    liveVideo.enableSkin = NO;
    liveVideo.enableMessage = YES;
    liveVideo.torchMode = AVCaptureTorchModeOff;
    [liveVideo initSocket];
    [liveVideo initLiveVideoConfiguration];
    UIView *livePushView = [liveVideo previewLiveVideoView];
    [self.view addSubview:livePushView];
    //如果想在推流界面再加view可以在上面代码[self.view addSubview:livePushView];后边添加view,也就是放在livePushView的上层,这样就会遮住livePushView,短暂的停留显示某些信息是可以的(注意添加的view不用时必须移除)
    //如加view1:[self.view addSubview:view1];移除view1:[view1 removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    _screenLight = [[UIScreen mainScreen] brightness];
    //延时推流(也可以直接推流)
    [self performSelector:@selector(pushURL) withObject:nil afterDelay:3.0];
    [UIApplication sharedApplication].idleTimerDisabled=YES;//禁止休眠
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //关闭右划返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.ocjInt_allowRotation = 1;
    [self setNewOrientation:NO];
    self.navigationController.navigationBar.hidden  = NO;
    self.tabBarController.tabBar.hidden = NO;
    [[UIScreen mainScreen] setBrightness: _screenLight];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIApplication sharedApplication].idleTimerDisabled=NO;//关闭禁止休眠
}
-(void)pushURL{
    [_JZLiveVideo JZLiveVideoConnectServer];
}

#pragma mark ----------------------------选择视频方向---------------------------------
- (void)selectVideoDirection {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (!_record.videoDirection) {//横屏
        app.ocjInt_allowRotation = 2;
        [self setNewOrientation:YES];
    } else {
        app.ocjInt_allowRotation = 1;
        [self setNewOrientation:NO];
    }
}

#pragma mark ----------------------------选择视频方向---------------------------------
- (void)setNewOrientation:(BOOL)fullscreen {
    if (fullscreen) {
        NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }else{
        NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

#pragma mark ----------------------------playerView代理方法---------------------------------
//关闭录播器
- (void)showLiveEndView:(NSInteger)maxOnlineNumber {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.ocjInt_allowRotation = 1;
    JZLiveEndViewController *endVC = [[JZLiveEndViewController alloc]init];
    endVC.onlineNum = maxOnlineNumber;
    endVC.record = _record;
    endVC.host = _user;
    [self.navigationController pushViewController:endVC animated:YES];
}
//显示个人简略信息
- (void)showPersonalInfo:(JZCustomer *)user {
    PersonInformationView *personInfoView = [[PersonInformationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    personInfoView.user = user;
    personInfoView.isHostLive = YES;
    personInfoView.delegate = self;
    if (self.record.videoDirection) {
        personInfoView.isVertical = YES;
    }
    [self.view addSubview:personInfoView];
}

//进入打赏榜
- (void)showVoteRankView {
    AwardListView *awardListView = [[AwardListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self.record.videoDirection) {
        awardListView.isVertical = YES;
    }
    [self.view addSubview:awardListView];
    //NSDictionary *test = @{@"toUserID":[NSString stringWithFormat:@"%lu", (long)_host.id],@"start":@"0",@"offset":@"100"};
    //__weak typeof(self) block = self;
    //[JZGeneralApi getGiftRecordsWithBlock:test returnBlock:^(NSArray *records, NSInteger allcounts, NSError *error) {
    //    awardListView.rankArray = [NSMutableArray arrayWithArray:records];
    //    awardListView.totalMoney = block.host.receiveGiftValue;
    //    [block.view addSubview:awardListView];
    //}];
}

#pragma mark --------------个人信息view代理方法--------------
//禁言
- (void)clickPersonInformationViewShutUpBtn {
    UIAlertView * alert2 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定禁言该用户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert2 setTag:902];
    UIAlertView * alert3 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定解除禁言该用户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert3 setTag:903];
    if ([_personInfoView.accusationBtn.titleLabel.text isEqualToString:@"禁言"]) {
        [alert2 show];
    }else {
        [alert3 show];
    }
}
//举报
- (void)clickPersonInformationViewAccusationBtn {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定举报该用户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setTag:901];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView tag] == 901){
        if (buttonIndex == 0) {
            nil;
        }else if (buttonIndex == 1) {
            //举报
            NSDictionary *params = @{@"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"content":@"jubao"};
            [JZGeneralApi reportWithBlock:params returnBlock:^(BOOL flag, NSError *error) {
                if (error) {
                    NSLog(@"访问网络出错");
                }else {
                    if (flag) {
                        [JZUtils showMessage:@"举报成功" inView:self.view];
                    }else {
                        [JZUtils showMessage:@"举报失败" inView:self.view];
                    }
                }
            }];
        }
    }else if([alertView tag] == 902){
        if (buttonIndex == 0) {
            nil;
        }else if (buttonIndex == 1) {//禁言
            NSDictionary *params = @{@"userID":[NSString stringWithFormat:@"%ld",(long)_personInfoView.user.id],@"hostID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"operate":@"1"};
            [JZGeneralApi addShutUpUser:params returnBlock:^(BOOL flag, NSError *error) {
                if (error) {
                    [JZUtils showMessage:@"访问网络出错" inView:self.view];
                }else {
                    if (flag) {
                        [JZUtils showMessage:@"禁言成功" inView:self.view];
                        [_personInfoView.accusationBtn setTitle:@"已禁言" forState:UIControlStateNormal];
                    }else {
                        [JZUtils showMessage:@"禁言失败" inView:self.view];
                    }
                }
            }];
        }
    }else if([alertView tag] == 903){
        if (buttonIndex == 0) {
            nil;
        }else if (buttonIndex == 1) {//解除禁言
            NSDictionary *params = @{@"userID":[NSString stringWithFormat:@"%ld",(long)_personInfoView.user.id],@"hostID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"operate":@"2"};
            [JZGeneralApi addShutUpUser:params returnBlock:^(BOOL flag, NSError *error) {
                if (error) {
                    [JZUtils showMessage:@"访问网络出错" inView:self.view];
                }else {
                    if (flag) {
                        [JZUtils showMessage:@"解除禁言成功" inView:self.view];
                        [_personInfoView.accusationBtn setTitle:@"禁言" forState:UIControlStateNormal];
                    }else {
                        [JZUtils showMessage:@"解除禁言失败" inView:self.view];
                    }
                }
            }];
        }
    }
}

@end
