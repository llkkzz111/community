//
//  OCJScanVC.m
//  OCJ
//
//  Created by Ray on 2017/6/2.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJScanVC.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "OCJScanView.h"
#import "OCJShareQRCodeVC.h"
#import "OCJScanJumpWebVC.h"

@interface OCJScanVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice *defaultDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *defaultDeviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIButton *ocjBtn_back;          ///<返回按钮
@property (nonatomic, strong) UILabel *ocjLab_title;          ///<title

@property (nonatomic, strong) UIImageView *ocjImgView_line;   ///<动画线
@property (nonatomic, strong) NSTimer *ocjTimer_scan;         ///<定时器

@property (nonatomic, strong) OCJScanView *ocjView_scan;      ///<

@end

@implementation OCJScanVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)
- (AVCaptureDevice *)defaultDevice {
    if (!_defaultDevice) {
        _defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _defaultDevice;
}

- (AVCaptureDeviceInput *)defaultDeviceInput {
    if (!_defaultDeviceInput) {
        _defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.defaultDevice error:nil];
    }
    return _defaultDeviceInput;
}

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _previewLayer;
}

- (AVCaptureMetadataOutput *)metadataOutput {
    if (!_metadataOutput) {
        _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        CGRect rect = self.view.bounds;
        CGRect containerRect = CGRectMake((SCREEN_WIDTH - 255)/2, (SCREEN_HEIGHT - 255)/2, 255, 255);;
        
        CGFloat x = containerRect.origin.y / rect.size.height;
        CGFloat y = containerRect.origin.x / rect.size.width;
        CGFloat width = containerRect.size.height / rect.size.height;
        CGFloat height = containerRect.size.width / rect.size.width;
        
        _metadataOutput.rectOfInterest = CGRectMake(x, y, width, height);
    }
    return _metadataOutput;
}

#pragma mark - 生命周期方法区域
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.isShowNav = YES;
    //从其他页面回来开始扫描
    if ([self ocj_canUseCamera]) {
        [self ocj_startTimer];
    }
    if (_session) {
        [_session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (self.isShowNav) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self ocj_checkJurisdiction];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _previewLayer.frame = self.view.bounds;
}

-(void)layoutSublayersOfLayer:(CALayer *)layer {
    [_session startRunning];
}

#pragma mark - 私有方法区域
/**
 检验相机权限
 */
-(void)ocj_checkJurisdiction{
  AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
  if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
    // 没有权限。弹出alertView
    self.view.backgroundColor = [UIColor blackColor];
    __weak OCJScanVC* weakSelf = self;
    [OCJProgressHUD ocj_showAlertByVC:self withAlertType:OCJAlertTypeNone title:@"相机权限未开启" message:@"相机权限未开启，请进入系统【设置】>【隐私】>【相机】中打开开关,开启相机功能" sureButtonTitle:@"立即开启" CancelButtonTitle:@"稍后设置" action:^(NSInteger clickIndex) {
      
      if (clickIndex == 1) {
        //跳入当前App设置界面
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
      }
      
      [weakSelf ocj_back];
    }];
  }else{
    [self ocj_setSelf];
  }
  
}

- (void)ocj_setSelf {
  self.ocjStr_trackPageID = @"AP1706C069";
    self.view.backgroundColor = [UIColor blackColor];
    self.isShowNav = NO;
    
    [self ocj_addScanView];
    [self ocj_addNavView];
    [self ocj_addAVComponents];
    [_ocjView_scan.layer insertSublayer:self.previewLayer atIndex:0];
  
}

/**
 导航栏
 */
- (void)ocj_addNavView {
    //返回按钮
    self.ocjBtn_back = [[UIButton alloc] init];
    [self.ocjBtn_back setImage:[UIImage imageNamed:@"icon_left"] forState:UIControlStateNormal];
    [self.ocjBtn_back addTarget:self action:@selector(ocj_back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ocjBtn_back];
    [self.ocjBtn_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.width.mas_equalTo(@44);
        make.height.mas_equalTo(@44);
    }];
    //title
    self.ocjLab_title = [[UILabel alloc] init];
    self.ocjLab_title.text = @"二维码扫描";
    self.ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    self.ocjLab_title.font = [UIFont systemFontOfSize:17];
    self.ocjLab_title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.ocjBtn_back);
    }];
}


//是否有使用摄像头的权限
-(BOOL)ocj_canUseCamera {
  
  NSString *mediaType = AVMediaTypeVideo;
  AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
  if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
    return NO;
  }
  return YES;
}
/**
 扫描
 */
- (void)ocj_addAVComponents {
    // 1.判断输入能否添加到会话中
    if ([self.session canAddInput:self.defaultDeviceInput]) {
        [self.session addInput:self.defaultDeviceInput];
    }
    
    if ([self.session canAddOutput:self.metadataOutput]) {
        // 2.判断输出能够添加到会话中
        [self.session addOutput:self.metadataOutput];
    }
    
    // 4.设置输出能够解析的数据类型
    // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
    self.metadataOutput.metadataObjectTypes = self.metadataOutput.availableMetadataObjectTypes;
    
    
    // 5.设置监听监听输出解析到的数据
    [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 6.添加预览图层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.frame = self.view.bounds;
    // self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // 7.开始扫描
    [self.session startRunning];
}

- (void)ocj_addScanView {
    self.ocjView_scan = [[OCJScanView alloc] init];
    self.ocjView_scan.translatesAutoresizingMaskIntoConstraints = NO;
    self.ocjView_scan.clipsToBounds = YES;
    [self.view addSubview:self.ocjView_scan];
    [self.ocjView_scan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.mas_equalTo(self.view);
    }];
    
    //扫描框的四个角添加图片
    CGFloat x = ceilf((SCREEN_WIDTH - 255) / 2 );
    CGFloat y = ceilf((SCREEN_HEIGHT - 255) / 2.5);
    CGFloat imgWidth = 25;
    
    UIImageView *ocjImgView_leftTop = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imgWidth, imgWidth)];
    ocjImgView_leftTop.image = [UIImage imageNamed:@"left_top_"];
    [self.view addSubview:ocjImgView_leftTop];
    
    UIImageView *ocjImgView_rightTop = [[UIImageView alloc] initWithFrame:CGRectMake(x - imgWidth + 255, y, imgWidth, imgWidth)];
    ocjImgView_rightTop.image = [UIImage imageNamed:@"right_top_"];
    [self.view addSubview:ocjImgView_rightTop];
    
    UIImageView *ocjImgView_leftBottom = [[UIImageView alloc] initWithFrame:CGRectMake(x, y + 255 - imgWidth, imgWidth, imgWidth)];
    ocjImgView_leftBottom.image = [UIImage imageNamed:@"left_bottom_"];
    [self.view addSubview:ocjImgView_leftBottom];
    
    UIImageView *ocjImgView_rightBottom = [[UIImageView alloc] initWithFrame:CGRectMake(x - imgWidth + 255, y + 255 - imgWidth, imgWidth, imgWidth)];
    ocjImgView_rightBottom.image = [UIImage imageNamed:@"right_bottom_"];
    [self.view addSubview:ocjImgView_rightBottom];
  
  self.ocjImgView_line = [[UIImageView alloc] initWithFrame:CGRectMake(x + 2, y, 250, 3)];
  [self.ocjImgView_line setImage:[UIImage imageNamed:@"scanbar_"]];
  [self.view addSubview:self.ocjImgView_line];
  
    [self ocj_addTipsWithImgView:ocjImgView_leftBottom];
}

- (void)ocj_addTipsWithImgView:(UIImageView *)imgView {
    OCJBaseButton *ocjBtn_shareQRCode = [[OCJBaseButton alloc] initWithFrame:CGRectMake(ceilf((SCREEN_WIDTH - 205)/2), ceilf((SCREEN_HEIGHT - 255)/2.5) + 305, 205, 45)];
    [ocjBtn_shareQRCode ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [ocjBtn_shareQRCode setTitle:@"APP下载二维码分享" forState:UIControlStateNormal];
    [ocjBtn_shareQRCode setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    ocjBtn_shareQRCode.layer.cornerRadius = 2;
    ocjBtn_shareQRCode.layer.masksToBounds = YES;
    ocjBtn_shareQRCode.ocjFont = [UIFont systemFontOfSize:14];
    [ocjBtn_shareQRCode addTarget:self action:@selector(ocj_clickedShareQRCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:ocjBtn_shareQRCode];
    
    OCJBaseLabel *ocjLab_tips = [[OCJBaseLabel alloc] init];
    ocjLab_tips.text = @"将二维码对准扫描框，即可自动扫描";
    ocjLab_tips.textColor = OCJ_COLOR_LIGHT_GRAY;
    ocjLab_tips.font = [UIFont systemFontOfSize:14];
    ocjLab_tips.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ocjLab_tips];
    [ocjLab_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(imgView.mas_bottom).offset(15);
    }];
    
}

/**
 开启定时器
 */
- (void)ocj_startTimer {
  [self ocj_stopScan];
  self.ocjTimer_scan = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(ocj_scanAnimation) userInfo:nil repeats:YES];
  [[NSRunLoop currentRunLoop] addTimer:self.ocjTimer_scan forMode:NSRunLoopCommonModes];
}

/**
 关闭定时器
 */
- (void)ocj_stopTimer {
  if (self.ocjTimer_scan) {
    [self.ocjTimer_scan invalidate];
    self.ocjTimer_scan = nil;
  }
}

/**
 动画
 */
- (void)ocj_scanAnimation {
  CGFloat x = ceilf((SCREEN_WIDTH - 255) / 2 );
  CGFloat y = ceilf((SCREEN_HEIGHT - 255) / 2.5);
  
  self.ocjImgView_line.frame = CGRectMake(x + 2, y, 250, 3);
  __block CGFloat imgLineY = self.ocjImgView_line.frame.origin.y;
  [UIView animateWithDuration:2.0f animations:^{
    self.ocjImgView_line.frame = CGRectMake(self.ocjImgView_line.frame.origin.x, self.ocjImgView_line.frame.origin.y + 255 - 5, self.ocjImgView_line.frame.size.width, self.ocjImgView_line.frame.size.height);
  } completion:^(BOOL finished) {
    CGFloat maxY = self.ocjImgView_line.frame.origin.y + 255;
    if (imgLineY > maxY) {
      imgLineY = self.ocjImgView_line.frame.origin.y;
    }
    imgLineY++;
  }];
}

/**
 返回
 */
- (void)ocj_back {
  [self ocj_trackEventID:@"AP1706C069D003001C003001" parmas:nil];
  [super ocj_back];
  [self ocj_stopScan];
  [self ocj_stopTimer];
}

/**
 点击分享二维码
 */
- (void)ocj_clickedShareQRCodeBtn {
  [self ocj_trackEventID:@"AP1706C069F008001O008001" parmas:nil];
    self.isShowNav = NO;
    [self ocj_stopScan];
    [self ocj_stopTimer];
    OCJShareQRCodeVC *qrcodeVC = [[OCJShareQRCodeVC alloc] init];
    [self ocj_pushVC:qrcodeVC];
}

/**
 停止扫描
 */
- (void)ocj_stopScan {
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}

#pragma mark - 协议方法实现区域
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        if ([metadataObject isKindOfClass:[AVMetadataFaceObject class]]) {
          return;
        }
      
        stringValue = metadataObject.stringValue;
        
        NSString *ocjStr_plistPath = [[NSBundle mainBundle] pathForResource:@"html5" ofType:@"plist"];
        NSArray *ocjArr_plist = [[NSArray alloc] initWithContentsOfFile:ocjStr_plistPath];
        BOOL urlDiscernIsOk = NO;
        for (int i = 0; i < ocjArr_plist.count; i++) {
            NSString *ocjStr_html = ocjArr_plist[i];
            if ([stringValue containsString:ocjStr_html]) {
                [self ocj_stopScan];
              [self ocj_stopTimer];
                urlDiscernIsOk = YES;
//                OCJScanJumpWebVC *webVC = [[OCJScanJumpWebVC alloc] init];
//                webVC.ocjStr_qrcode = stringValue;
//                [self ocj_pushVC:webVC];
              
                if (self.ocjNavigationController.ocjCallback) {
                    self.ocjNavigationController.ocjCallback(@{@"url":stringValue, @"isScan":@"YES"});
                }
                [self ocj_back];
            }
        }
      
        if (!urlDiscernIsOk) {
            [OCJProgressHUD ocj_showHudWithTitle:@"二维码内容不符合识别规则" andHideDelay:2];
        }
    }
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
