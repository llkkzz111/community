//
//  JZPlayerViewController.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//  播放界面

#import "JZPlayerViewController.h"

#import <JZLiveSDK/JZLiveSDK.h>//SDK
#import "AppDelegate.h"//改变屏幕方向的代理
#import "UIImageView+WebCache.h"//第三方的加载图片sdwebimage
#import "JZLiveEndViewController.h"//拉流结束
#import "PersonInformationView.h"//个人大致信息view
//#import "JZPersonalHomeView.h"//个人主页信息view
#import "JZShareView.h"//分享页面
#import "SelectedLoginView.h"//选择登陆页面
#import "AwardListView.h"//打赏排行榜
#import "JZLoginViewController.h"//手机登陆页面
#import "RechargeTableViewController.h"//账户充值页面
#import "JZTools.h"//工具
#import "JZPersonalViewController.h"
#import "JZAdvertisementSelectView.h"//显示广告选择view
#import <JZLiveSDK/JZProduct.h>
#import "WebViewJavascriptBridge.h"
#import "AFHTTPSessionManager.h"
#import "OCJLoginVC.h"
#import "OCJBaseNC.h"
#import "OCJ_RN_WebViewVC.h"

//NSString* accessKeyID = @"fnW2ADHtjIyoPSKi";
//NSString* accessKeySecret = @"GWLhHkuhvpK7knCzlU7KSZkFnC9wjl";
@interface JZPlayerViewController ()<
                                        JZMediaPlayerDelegate,
                                        PersonInformationViewDelegate,
                                        SelectedLoginViewDelegate,
                                        JZAdvertisementSelectViewDelegate,
                                        UIWebViewDelegate
                                    >
{
    NSTimer * _livingTimer;
    NSTimer * _nextEventTimer;
    NSInteger _liveBeginTime;
    NSInteger _liveEndTime;
    NSInteger _liveBeginLeftTime;
    NSInteger _liveEndLeftTime;
    NSInteger _firstEventTime;
    NSInteger _second;
    NSInteger _firtEventStartTime;
    NSInteger _nextEventStartTime;
}
@property (nonatomic, assign) CGFloat               screenLight;//屏幕亮度
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;//播放缓冲图标
@property (nonatomic, assign) BOOL                  isGoLogin;//判断是否从播放器去登陆页面
@property (nonatomic, strong) JZMediaPlayer         *mediaPlayer;//播放器
//@property (nonatomic, weak) JZPersonalHomeView      *personalHomeView;//个人主页信息view
@property (nonatomic, weak) UIView                  *mediaPlayerView;//播放器view
@property (nonatomic, strong) UIImageView           *headImageView;//分享用到的头像
@property (nonatomic, assign) BOOL                  isCanPlay1;//是否可以播放
@property (nonatomic, strong) JZCustomer            *clickUser;//点击的用户
@property (nonatomic, weak) PersonInformationView *personInfoView;//个人大致信息view
@property (nonatomic, weak) JZShareView             *shareSelectView;//分享选择view
@property (nonatomic, weak) SelectedLoginView     *loginSelectedView;//登陆选择view
@property (nonatomic, strong) NSArray               *goodsArray;//商品数据
//临时加的
@property (nonatomic, weak) UIWebView *productWebView;
@property (nonatomic, strong)UIWebView *productListWebView;
@property (nonatomic, strong) UIButton *listCoverView;
@property (nonatomic, assign) BOOL isPopWebView;


//@property (nonatomic, weak) UIView *beginView;
@property (nonatomic, strong) NSTimer *timer;//计时器
@property (nonatomic, assign) NSInteger timeNumber;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, assign) BOOL isReady;
@property (nonatomic,strong)NSTimer * finishRotatedTimer;

@property (nonatomic, strong) NSString *ocjStr_accessToken;

@end

@implementation JZPlayerViewController

- (void)closeView {
    if ([_productWebView canGoBack]) {
        [_productWebView goBack];
    }else {
        [_mediaPlayer destroySDKMediaPlayer];
        [self closeMediaPlayer];
    }
}


-(void)intoShowWeb
{
    if(_liveBeginLeftTime<=0 && _liveEndLeftTime>0 && [HDUtil check:_redBagModel.batch_no].length>0)
    {
        if(([_redBagModel.code isEqualToString:@"2"]) && _second>0)
        {
            [self performSelector:@selector(addURL) withObject:nil afterDelay:0.1];
            self.productWebView.hidden = NO;
        
        }
    }
}

/**
 获取直播页面的基本信息请求
 */
- (void)requestLiveInfo:(NSDictionary *)res
{
  AFHTTPSessionManager *Manager = [AFHTTPSessionManager manager];
    __weak typeof (self) weakself = self;
    NSDictionary *para = @{@"shop_no" : [HDUtil check:_shopNo]};
    [Manager GET:liveInfo parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject)
        {
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                _danMuModel = [DanmuModel parseWithDictionary:responseObject];
                _liveBeginTime = [_danMuModel.live_begin_time longLongValue]/1000;
                _liveEndTime = [_danMuModel.live_end_time longLongValue]/1000;
                _liveBeginLeftTime = [_danMuModel.live_begin_left_time longLongValue]/1000;
                _liveEndLeftTime = [_danMuModel.live_end_left_time longLongValue]/1000;
                _firstEventTime = [_danMuModel.first_event_time floatValue]*60;
                _firtEventStartTime = _liveBeginLeftTime + _firstEventTime;
                [weakself selectVideoDirection];//选择屏幕方向
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    self.view.backgroundColor = [UIColor blackColor];
    [self requestLiveInfo:_dictionary];
//    [self performSelector:@selector(loadJZLiveSDK) withObject:nil afterDelay:0.60];//延时是为了让屏幕完成旋转
//    [self requestLiveInfo];
}

/**
 获取直播页面的基本信息请求
 */
- (void)requestLiveInfo
{
    
}
- (void)setStatusBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
//初始化sdk
- (void)loadJZLiveSDK
{
    //JZMediaPlayer *mediaPlayer = [[JZMediaPlayer alloc] init];
    JZMediaPlayer *mediaPlayer = [JZMediaPlayer getInstance:2];
    mediaPlayer.delegate= self;
    _mediaPlayer = mediaPlayer;
    mediaPlayer.user = _user;
    mediaPlayer.host = _host;
    mediaPlayer.record = _record;
    mediaPlayer.enableMessage = YES;
    if ([mediaPlayer judgeActivityState])
    {//可以播放
        [mediaPlayer initSocket];
        [mediaPlayer initMediaPlayerConfiguration];
        UIView *mediaPlayerView = [mediaPlayer previewMediaPlayerView];
        mediaPlayerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view addSubview:mediaPlayerView];
        [self initEventWebview];
        [self initProductListWebView];
        //如果想在推流界面再加view可以在上面代码[self.view addSubview:mediaPlayerView];后边添加view也就是放在mediaPlayerView的上层,这样就会遮住mediaPlayerView,短暂的停留显示某些信息是可以的(注意添加的view不用时必须移除)
        //如加view1:[self.view addSubview:view1];移除view1:[view1 removeFromSuperview];
        [mediaPlayer JZMediaPlayerConnectServer];
    }else {
        NSLog(@"不可以播放");
    }
    [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:@"未开始" titleColor:[UIColor whiteColor] titleFont:12];
    [self  nextEventTime];
}

//对横竖屏转换慢加保护
- (void)setViewFram:(UIView *)view {
    if (!_record.videoDirection)
    {//横屏
        if (SCREEN_WIDTH > SCREEN_HEIGHT) {
            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } else {
            view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        }
    } else {//竖屏
        if (SCREEN_HEIGHT > SCREEN_WIDTH) {
            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } else {
            view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        }
    }
}

//获取商品信息
- (void)getProductInfo {
//获取整个平台的商品信息
//    NSDictionary *params1 = @{@"activityID":@"", @"level":@"1", @"pageNum":@"0", @"offset":@"50",@"token":@"11111111"};
//    __weak typeof(self) block = self;
//    [JZGeneralApi getRecordProductList:params1 returnBlock:^(NSArray *products, NSError *error) {
//        if (error) {
//            NSLog(@"网络出错");
//        }else {
//            block.goodsArray = [NSMutableArray arrayWithArray:products];
//        }
//    }];
//获取当前活动的商品信息(主要用到显示webview的3个url)
    NSDictionary *params1 = @{@"activityID":[NSString stringWithFormat:@"%ld", (long)_record.activityID], @"pageNum":@"0", @"offset":@"50"};
    __weak typeof(self) block = self;
    [JZGeneralApi getRecordProductList:params1 returnBlock:^(NSArray *products, NSError *error) {
        if (error) {
            NSLog(@"网络出错");
        }else {
            block.goodsArray = [NSMutableArray arrayWithArray:products];
        }
    }];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _mediaPlayer = nil;
    [_livingTimer invalidate];
    _livingTimer = nil;
    [_nextEventTimer invalidate];
    _nextEventTimer = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    _screenLight = [[UIScreen mainScreen] brightness];
    //禁止休眠
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    //播放缓冲图标
    if (_activityIndicator != nil) {
        _activityIndicator.hidden = YES;
        [_activityIndicator removeFromSuperview];
    }
//    //登陆界面返回
//    if (_isGoLogin) {
//        [self selectVideoDirection];//选择屏幕方向
//        _isGoLogin = NO;
//        if (self.view.hidden == YES) {
//            [self performSelector:@selector(showLoginSuccess) withObject:nil afterDelay:1.0];
//        }else{
//            [JZUtils showMessage:@"登录成功"];
//        }
//    }
}

-(NSString *)revertTimeString:(NSInteger)second
{
    NSInteger minute = second/60;
    NSInteger sec = second%60;
    NSString * revertTimeString = [NSString stringWithFormat:@"%02ld:%02ld",(long)minute,(long)sec];
    return revertTimeString;
}



 //修按钮改图片
- (void)replaceButtonPicture
{
    _firtEventStartTime = _firtEventStartTime-1;
    _liveBeginLeftTime = _liveBeginLeftTime - 1;
    _liveEndLeftTime = _liveEndLeftTime - 1;
   //直播前
    if(_liveBeginLeftTime>0)//直播间隔时间
    {
        //按钮图片,直播前话术
//        double timeIterval = (double)([_danMuModel.live_begin_time longLongValue]/1000);
//        NSDate * timeDate = [NSDate dateWithTimeIntervalSince1970:timeIterval];
//        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"HH:mm"];
//        NSString * timeString = [formatter stringFromDate:timeDate];

         [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:@"未开始" titleColor:[UIColor whiteColor] titleFont:12];
    }
    else if(_liveBeginLeftTime<=0&&_liveEndLeftTime>0)
    {
        //按钮图片,直播中话术
        if([_redBagModel.batch_no isEqualToString:@"0"]&& [HDUtil check:_redBagModel.batch_no].length>0)
        {
                //活动倒计时
                if(_firtEventStartTime>4&&_firtEventStartTime<=_firstEventTime)
                {
                    //红包活动
                     [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:[self revertTimeString:_firtEventStartTime] titleColor:[UIColor whiteColor] titleFont:12];
                  
                }else if(_firtEventStartTime==4)
                {
                    //首场活动抢中
                     [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:[self revertTimeString:_firtEventStartTime] titleColor:[UIColor whiteColor] titleFont:12];
                   // web显示出来//临街点进来不弹出
                    [self showAdvertisementSelectListView];
                    
                }
                else if (_firtEventStartTime>0&&_firtEventStartTime<4)
                {
                     [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:[self revertTimeString:_firtEventStartTime] titleColor:[UIColor whiteColor] titleFont:12];
                  
                }else if(_firtEventStartTime==0)
                {
                     [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:_danMuModel.do_evt_word titleColor:[UIColor whiteColor] titleFont:12];
                }
        }
        else
        {
            if (!_nextEventTimer)
            {
                _nextEventTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(revertTime) userInfo:nil repeats:YES];
            }
           
        }

    }else
    {
        //按钮图片,直播后话术
        if(_second<=0&&[HDUtil check:_redBagModel.second].length>0)
        {
            [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:@"已结束" titleColor:[UIColor whiteColor] titleFont:12];
        }
    //        [_livingTimer invalidate];
    //        _livingTimer = nil;
    }
}


-(void)revertTime
{
     if([HDUtil  check:_redBagModel.code].length>0)
     {
        if ([_redBagModel.code isEqualToString:@"1"]||[_redBagModel.code isEqualToString:@"2"])
        {
            if (_second>4) {
                [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:[self revertTimeString:_second] titleColor:[UIColor whiteColor] titleFont:12];
                _second = _second-1;
            }
            else if(_second ==4 && _liveEndLeftTime>0)
            {
                [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:[self revertTimeString:_second] titleColor:[UIColor whiteColor] titleFont:12];
                [self showAdvertisementSelectListView];
                _second = _second-1;
            }
            else if(_second <4 && _second >0 && _liveEndLeftTime>0)
            {
                [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:[self revertTimeString:_second] titleColor:[UIColor whiteColor] titleFont:12];
                _second = _second-1;
            }
            else if(_second == 0 && _liveEndLeftTime>0)
            {
                [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:_danMuModel.do_evt_word titleColor:[UIColor whiteColor] titleFont:12];
                _second = _second-1;
            }
        }
       else
        {
//            if(_second<=0&&[HDUtil check:_redBagModel.second].length>0)
//            {
               [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:@"已结束" titleColor:[UIColor whiteColor] titleFont:12];
//            }
            
            //                    [_nextEventTimer invalidate];
            //                    _nextEventTimer = nil;
        }
     }
     else
     {
             [_mediaPlayer replaceShoppingCartPicture:NO imageString:@"JZ_btn_talk_144_144" buttonTitle:@"已结束" titleColor:[UIColor whiteColor] titleFont:12];
        //                    [_nextEventTimer invalidate];
         //                    _nextEventTimer = nil;
     }
   
}


-(void)nextEventTime
{
  AFHTTPSessionManager *Manager = [AFHTTPSessionManager manager];
   _redBagModel = nil;
   NSDictionary * parameterDic = [NSDictionary dictionaryWithObjectsAndKeys:_danMuModel.event_no,@"event_no", nil];
   __weak typeof(self) block = self;
   [Manager POST:LIVING_CHECKTIMES parameters:parameterDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       if (responseObject) {
           if ([responseObject isKindOfClass:[NSDictionary class]]) {
               _redBagModel = [RedBagEventModel parseWithDictionary:responseObject];
               _second = [_redBagModel.second integerValue];
               if(!_livingTimer)
               {
                   [block intoShowWeb];
                   _livingTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:block selector:@selector(replaceButtonPicture) userInfo:nil repeats:YES];
               }
           }
       }
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
   }];


}

-(void)closeGameWebview
{
    [_productWebView removeFromSuperview];
}


- (void)showLoginSuccess {
    self.view.hidden = NO;
    [JZUtils showMessage:@"登录成功"];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //关闭右划返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mediaPlayer = nil;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.ocjInt_allowRotation = 1;
    [self setNewOrientation:NO];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [[UIScreen mainScreen] setBrightness: _screenLight];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark ----------------------------选择视频方向---------------------------------
- (void)selectVideoDirection {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!_record.videoDirection)
    {//横屏
        app.ocjInt_allowRotation = 2;
        [self setNewOrientation:YES];
    }
    else
    {
        app.ocjInt_allowRotation = 1;
        [self setNewOrientation:NO];
    }
}
- (void)orientationDidChange {
    UIDevice *currentDevice = UIDevice.currentDevice;
    if (currentDevice.orientation == 0)
    {
        //准备转为横屏
        _isReady = YES;
    }
    else if (currentDevice.orientation == 3)
    {
        //已经转为横屏
        if (_isReady)
        {
            _isReady = NO;
//            [self loadJZLiveSDK];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            if(SCREEN_WIDTH > SCREEN_HEIGHT && app.ocjInt_allowRotation == 2)
            {
                
                [self loadJZLiveSDK];
               // [self performSelector:@selector(loadJZLiveSDK) withObject:nil afterDelay:0.5];
            }
            else
            {
                if (_finishRotatedTimer == nil)
                {
                    //每隔0.1秒查询一次是否旋转完成
                    _finishRotatedTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(confirmFinishRotated) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:_finishRotatedTimer forMode:NSRunLoopCommonModes];
                }
            }
//            [self performSelector:@selector(loadJZLiveSDK) withObject:nil afterDelay:1.20];
        }
    }
}

-(void)confirmFinishRotated
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(SCREEN_WIDTH > SCREEN_HEIGHT && app.ocjInt_allowRotation == 2) {
        [_finishRotatedTimer invalidate];
        _finishRotatedTimer =nil;
        [self loadJZLiveSDK];
//        [self performSelector:@selector(loadJZLiveSDK) withObject:nil afterDelay:0.5];
    }
}

#pragma mark ----------------------------选择视频方向---------------------------------
- (void)setNewOrientation:(BOOL)isLandscape
{
    if (isLandscape)
    {
        NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }
    else
    {
        NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

#pragma mark ----------------------------播放器代理方法---------------------------------
//关闭播放器(主动关闭播放器)
- (void)closeMediaPlayer
{
//        _mediaPlayer = nil;
        [_livingTimer invalidate];
        _livingTimer = nil;
        [_nextEventTimer invalidate];
        _nextEventTimer = nil;
  for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
    if ([viewCtrl isKindOfClass:[OCJ_RN_WebViewVC class]]) {
      OCJ_RN_WebViewVC *vc = (OCJ_RN_WebViewVC *)viewCtrl;
      if (vc.ocjNavigationController.ocjCallback) {
        [vc.ocjNavigationController popToRootViewControllerAnimated:NO];
      }
    }
  }
}
//主播结束直播,拉流端跳到结束界面(被动的,主播离开自动弹出)
- (void)showLiveEndView:(NSInteger)maxOnlineNumber {
    if (!_livingEendView) {
        _livingEendView = [[UIView alloc]initWithFrame:self.view.bounds];
        UIButton *finishButton = [[UIButton alloc] init];
        finishButton.frame = CGRectMake(self.view.frame.size.width/2-50, (self.view.frame.size.height-64-49)/2-50, 100, 100);
        finishButton.backgroundColor = MAINCOLOR;
        [finishButton setTitle:@"直播结束" forState:UIControlStateNormal];
        [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [finishButton.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE52]];
        [finishButton addTarget:self action:@selector(closeMediaPlayer) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_livingEendView];
        [_livingEendView addSubview:finishButton];
    }
}

//显示个人简略信息
- (void)showPersonalInfo:(JZCustomer *)user {
    PersonInformationView *personInfoView = [[PersonInformationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    personInfoView.user = user;
    personInfoView.isHostLive = NO;
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
}

//显示分享view
- (void)showShareView
{
    
    JZShareView *shareSelectView = [[JZShareView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    shareSelectView.liveInfoModel = self.danMuModel;
    [self.view addSubview:shareSelectView];
    self.shareSelectView = shareSelectView;
}



//压缩图片
- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

//显示登陆view
- (void)showSelectedLoginView {
    SelectedLoginView *loginSelectedView = [[SelectedLoginView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    loginSelectedView.delegate = self;
    [self.view addSubview:loginSelectedView];
    self.loginSelectedView = loginSelectedView;
}


//进入登录手机页面
- (void)enterPhoneLoginView:(UIButton *)button {
    _isGoLogin = YES;
    JZLoginViewController *vc = [[JZLoginViewController alloc]init];
    [vc setRedirectBlock:^(BOOL flag, NSError *error) {
        if (flag) {
            [self.navigationController popToViewController:self animated:YES];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
//第三方登录
- (void)thirdPartyLogin:(UIButton *)sender {
    sender.enabled = NO;
    //先访问第三方应用等第三方应用授权后将第三方服务器返回的值传入下面接口(与微信类似)
    
    /*!
     * param uid   个人id必须是唯一值(必传参数)
     * param loginType  使用SDK的公司名(必传参数)
     * param nickname  昵称(必传参数)
     * param city  所在城市(不是必传参数)
     * param pic1  头像(不是必传参数)
     * param sex   性别(不是必传参数)
     */
    NSDictionary * params = @{@"uid":@"",@"loginType":@"",@"nickname":@"",@"city":@"",@"pic1":@"",@"sex":@""};
    __weak typeof(self) block = self;
    [JZGeneralApi thirdPrtyLoginWithBlock:(NSDictionary *) params getDetailBlock:^(JZCustomer *user, NSError *error) {
        if (error||[JZTools isInvalid:[NSString stringWithFormat:@"%ld",(long)user.id]]) {
            [block.navigationController popViewControllerAnimated:YES];
            [JZTools showMessage:@"登录失败"];
            sender.enabled = YES;
        }else{
            [JZGeneralApi setLoginStatus:1];
            //保存用户信息
            [JZTools showMessage:@"登录成功"];
        }
        sender.enabled = YES;
    }];
}
//显示活动规则
- (void)showActivityRulesView {
    [self performSelector:@selector(addURL3) withObject:nil afterDelay:0.1];
    self.productWebView.hidden = NO;
}


-(void)initEventWebview
{
    UIWebView *productWebView = [[UIWebView alloc]init];
    productWebView.backgroundColor = [UIColor clearColor];
    if (_record.videoDirection) {
    productWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else {
    productWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    productWebView.delegate = self;
    //productWebView.backgroundColor = [UIColor whiteColor];
    productWebView.scrollView.scrollEnabled = YES;
    productWebView.scalesPageToFit = YES;
    productWebView.scrollView.bounces = NO;
    productWebView.opaque = NO;
    _bridge = [WebViewJavascriptBridge bridgeForWebView:productWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {

    }];
    __weak typeof (self)weakSelf = self;
    [_bridge registerHandler:@"nextEventTime" handler:^(id data, WVJBResponseCallback responseCallback){
    [weakSelf nextEventTime];
    }];
    [_bridge registerHandler:@"closeGameWebview" handler:^(id data, WVJBResponseCallback responseCallback){
    [weakSelf closeGameWebview];
    }];
    _productWebView = productWebView;
    [self.view addSubview:_productWebView];

    //关闭按钮
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.frame = CGRectMake(SCREEN_WIDTH-5-40, 10, 40, 40);
    [closeBtn setImage:[UIImage imageNamed:@"JZ_btn_close_144_144"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(removeAdvertisementSelectListView) forControlEvents:UIControlEventTouchUpInside];
    [self.productWebView addSubview:closeBtn];
    
    _productWebView.hidden = YES;
    _isPopWebView = YES;
}

//显示活动web
- (void)showAdvertisementSelectListView {
    if(_liveBeginLeftTime<=0&&_liveEndLeftTime>0&&_firtEventStartTime<=4)
    {
        if([_redBagModel.code isEqualToString:@"2"]||[_redBagModel.code isEqualToString:@"0"]||([_redBagModel.code isEqualToString:@"1"]&&(_second==4)))
        {
            [self performSelector:@selector(addURL) withObject:nil afterDelay:0.1];
            self.productWebView.hidden = NO;
        }
    }
}
- (void)removeAdvertisementSelectListView {
    [self  nextEventTime];
    self.productWebView.hidden = YES;
    NSURLRequest * requset = [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank;"]];
  NSMutableURLRequest *mutableRequest = [requset mutableCopy];
  [mutableRequest setValue:self.ocjStr_accessToken forHTTPHeaderField:@"X-access-token"];
    [self.productWebView loadRequest:mutableRequest];
}

- (void)removeProductListView {
    self.listCoverView.hidden = YES ;
    self.productListWebView.hidden = YES;
}

- (void)webViewBack {
    if ([_productWebView canGoBack]) {
        [_productWebView goBack];
    }else {
        [self closeBottonClick];
    }
}

-(void)listWebViewBack
{
    self.listCoverView.hidden = YES;
    self.productListWebView.hidden = YES;
}
- (void)closeBottonClick {
    [self  nextEventTime];
    self.productWebView.hidden = YES;
    NSURLRequest * requset = [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank;"]];
  NSMutableURLRequest *mutableRequest = [requset mutableCopy];
  [mutableRequest setValue:self.ocjStr_accessToken forHTTPHeaderField:@"X-access-token"];
    [self.productWebView loadRequest:mutableRequest];
}

- (void)addURL {
    if([HDUtil check:_shopNo].length>0&&[HDUtil check:_danMuModel.event_no].length)
    {
        NSURL *url = [NSURL URLWithString:LIVING_EVNTENT(_shopNo,_danMuModel.event_no)];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest setValue:self.ocjStr_accessToken forHTTPHeaderField:@"X-access-token"];
        [_productWebView loadRequest:mutableRequest];
    }
}

- (void)addURL2 {
    if([HDUtil check:_shopNo].length>0)
    {
        NSURL *url = [NSURL URLWithString:LIVING_PRODUCT_LIST(_shopNo)];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
      NSMutableURLRequest *mutableRequest = [request mutableCopy];
      [mutableRequest setValue:self.ocjStr_accessToken forHTTPHeaderField:@"X-access-token"];
        [_productListWebView loadRequest:mutableRequest];
    }
}

- (void)addURL3 {
    if([HDUtil check:_danMuModel.event_no].length>0)
    {
        NSURL *url = [NSURL URLWithString:LIVING_RULES(_danMuModel.event_no)];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
      NSMutableURLRequest *mutableRequest = [request mutableCopy];
      [mutableRequest setValue:self.ocjStr_accessToken forHTTPHeaderField:@"X-access-token"];
        [_productWebView loadRequest:mutableRequest];
    }
}
//显示商品列表
- (void)showAdvertisementSelectView {
    self.productListWebView.hidden = NO;
    self.listCoverView.hidden = NO;
}

-(void)initProductListWebView
{
    UIButton *coverView = [[UIButton alloc] init];
    coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    coverView.backgroundColor = background01GRAY;
    [coverView addTarget:self action:@selector(removeProductListView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:coverView];
    self.listCoverView = coverView;
    
    UIWebView *productWebView = [[UIWebView alloc]init];
    productWebView.backgroundColor = RGB(0, 0, 0, 0.6);
    
    if (_record.videoDirection) {
        productWebView.frame = CGRectMake(0, SCREEN_HEIGHT/3*2-50, SCREEN_WIDTH, SCREEN_HEIGHT/3+50);
    }else {
        productWebView.frame = CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, SCREEN_HEIGHT);
    }
    productWebView.delegate = self;
    productWebView.backgroundColor = [UIColor clearColor];
    
    productWebView.scrollView.scrollEnabled = YES;
    productWebView.scalesPageToFit = YES;
    productWebView.scrollView.bounces = NO;
    productWebView.scrollView.showsHorizontalScrollIndicator = NO;
    productWebView.opaque = NO;
    self.productListWebView = productWebView;
    [self.view addSubview:self.productListWebView];
   
    self.productListWebView.hidden = YES;
    self.listCoverView.hidden = YES;
    [self performSelector:@selector(addURL2) withObject:nil afterDelay:0.1];
    _isPopWebView = NO;
}


//进入充值页面
- (void)enterRechargeView {
    _isGoLogin = YES;
    RechargeTableViewController *vc = [[RechargeTableViewController alloc] init];
    [vc setRedirectBlock:^(BOOL flag, NSError *error) {
        if (flag){
            nil;
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --------------广告选择view代理方法--------------
- (void)openAdvertisementWebView:(NSString *)urlString {
    [_mediaPlayer openProductWebView:urlString];
}
#pragma mark alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView tag] == 901)
    {
        if (buttonIndex == 0) {
            nil;
        }else if (buttonIndex == 1) {
            //举报
            NSDictionary *test = @{@"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"content":@"jubao"};
            [JZGeneralApi reportWithBlock:test returnBlock:^(BOOL flag, NSError *error) {
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
    }
    else if([alertView tag] == 902)
    {
        if (buttonIndex == 0) {
            nil;
        }else if (buttonIndex == 1) {
            [self showSelectedLoginView];
        }
    }
    else if (alertView.tag == 1000)
    {
        if (buttonIndex == 1)
        {

                       
        }
    }
}


#pragma mark - JS调用OC方法列表
//固定路径(app内定义的)
- (void)showfixedURL {
    if (_isPopWebView) {
        NSURL *url = [NSURL URLWithString:@"https://nodejs.org/en/docs/"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_productWebView loadRequest:request];
    }else {
        [self closeBottonClick];
        [self openAdvertisementWebView:@"https://nodejs.org/en/docs/"];
    }
}
//全路径
- (void)showfullURL:(NSString *)urlString {
    if (_isPopWebView) {
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_productWebView loadRequest:request];
    }else {
        [self closeBottonClick];
        [self openAdvertisementWebView:urlString];
    }
}

//相对路径
- (void)showRelativeURL:(NSString *)urlHeadString footURL:(NSString *)urlFootString {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",urlHeadString,urlFootString];
    if (_isPopWebView) {
        NSString *encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:encodedString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
      NSMutableURLRequest *mutableRequest = [request mutableCopy];
      [mutableRequest setValue:self.ocjStr_accessToken forHTTPHeaderField:@"X-access-token"];
        [_productWebView loadRequest:mutableRequest];
    }else {
        [self closeBottonClick];
        [self openAdvertisementWebView:urlString];
    }
}

/**
 获取accesstoken
 */
-(NSString *)ocjStr_accessToken{
  NSDictionary* dic = [OCJUserInfoManager ocj_getTokenForRN];
  return dic[@"token"];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@",NSStringFromSelector(_cmd));
//    //OC调用JS是基于协议拦截实现的 下面是相关操作
//    NSString *absolutePath = request.URL.absoluteString;
//    
//    NSString *scheme = @"rrcc://";
//    
//    if ([absolutePath hasPrefix:scheme]) {
//        NSString *subPath = [absolutePath substringFromIndex:scheme.length];
//
  
        NSString *subPath = request.URL.absoluteString;
        
        if ([subPath containsString:@","]) {//自定义的没有参数或者有多个参数
            
            if ([subPath containsString:@"!"]) {//2个参数
                NSArray *components = [subPath componentsSeparatedByString:@","];
                
                NSString *methodName = [components lastObject];
                
                methodName = [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
                SEL sel = NSSelectorFromString(methodName);
                
                NSString *parameter = [components firstObject];
                NSArray *params = [parameter componentsSeparatedByString:@"!"];
                
                if (params.count == 2) {
                    if ([self respondsToSelector:sel]) {
                        [self performSelector:sel withObject:[params firstObject] withObject:[params lastObject]];
                    }
                }
                
                
            } else {//1个参数或者没有参数
                NSArray *components = [subPath componentsSeparatedByString:@","];
                
                NSString *methodName = [components lastObject];
                methodName = [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
                SEL sel = NSSelectorFromString(methodName);
                
                NSString *parameter = [components firstObject];
                
                if ([self respondsToSelector:sel]) {
                    [self performSelector:sel withObject:parameter];
                }
                
            }
            
        } else {//没有参数
            NSString *methodName = [subPath stringByReplacingOccurrencesOfString:@"_" withString:@":"];
            SEL sel = NSSelectorFromString(methodName);
            
            if ([self respondsToSelector:sel]) {
                [self performSelector:sel];
            }
        }
//    }
    
    if ([subPath rangeOfString:@"/mobileappdetail/"].location != NSNotFound)
    {
        NSArray * detailAry = [subPath componentsSeparatedByString:@"/mobileappdetail/"];
        NSString * item_code = detailAry.lastObject;
        if (item_code.length) {
          for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
            if ([viewCtrl isKindOfClass:[OCJ_RN_WebViewVC class]]) {
              OCJ_RN_WebViewVC *vc = (OCJ_RN_WebViewVC *)viewCtrl;
              if (vc.ocjNavigationController.ocjCallback) {
                
                
                vc.ocjNavigationController.ocjCallback(@{@"targetRNPage":@"GoodsDetailMain",@"itemcode":item_code});
                [_mediaPlayer destroySDKMediaPlayer];
                [self closeMediaPlayer];
              }
            }
          }
        }
        return NO;
    }
    if ([subPath rangeOfString:@"aimnf=Y"].location != NSNotFound)
    {
        if (subPath.length) {
          for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
            if ([viewCtrl isKindOfClass:[OCJ_RN_WebViewVC class]]) {
              OCJ_RN_WebViewVC *vc = (OCJ_RN_WebViewVC *)viewCtrl;
              if (vc.ocjNavigationController.ocjCallback) {
                
                
                vc.ocjNavigationController.ocjCallback(@{@"targetRNPage":@"GoodsDetailMain",@"itemcode":subPath});
                [_mediaPlayer destroySDKMediaPlayer];
                [self closeMediaPlayer];
              }
            }
          }
        }
        return NO;
    }
    else if([subPath rangeOfString:kLoginLanJie].location != NSNotFound)
    {
     // 登录
        [_mediaPlayer destroySDKMediaPlayer];
        [self closeMediaPlayer];
      
      OCJLoginVC *loginVC = [[OCJLoginVC alloc] init];
      [self.navigationController presentViewController:loginVC animated:YES completion:nil];
      /*
        if ([self.delegate respondsToSelector:@selector(shouldLogin)]) {
            [self.delegate shouldLogin];
            }
       */
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录东方购物账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.tag = 1000;
//        [alert show];

//        NSArray *array = [subPath componentsSeparatedByString:@"returnUrl="];
//        NSString* returnUrl;
//        if (array.count >= 2)
//        {
//            NSString *urlStr = [array lastObject];
//            NSArray* ary = [urlStr componentsSeparatedByString:@"&"];
//            NSString* firStr = [ary objectAtIndex:0];
//            if(![ManagerTool shifouBaoHanQianZhui:firStr])
//            {
//                returnUrl =  [NSString stringWithFormat:@"%@%@",REQUEST_PATH,[firStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            }
//            else
//            {
//                returnUrl = [firStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            }
//        }
//        [self tapToSearchViewContro:self.homeBtn andReturnUrls:returnUrl loginSuccessCloseVC:NO];
        return YES;
    }
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"++++++%@",error);
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}
//- (UIInterfaceOrientationMask) supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}

@end
