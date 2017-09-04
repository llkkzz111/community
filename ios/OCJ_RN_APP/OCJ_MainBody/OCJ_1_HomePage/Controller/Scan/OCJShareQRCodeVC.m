//
//  OCJShareQRCodeVC.m
//  OCJ
//
//  Created by Ray on 2017/6/2.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJShareQRCodeVC.h"
#import "OCJScanVC.h"

@interface OCJShareQRCodeVC ()

@property (nonatomic, strong) UIButton *ocjBtn_back;
@property (nonatomic, strong) UILabel *ocjLab_title;

@end

@implementation OCJShareQRCodeVC
#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ocj_setSelf];
    // Do any additional setup after loading the view.
}

#pragma mark - 私有方法区域
- (void)ocj_setSelf {
  self.ocjStr_trackPageID = @"AP1706C070";
    [self ocj_addNav];
    [self ocj_addViews];
}

- (void)ocj_addNav {
    //bgView
    UIView *ocjView_bg = [[UIView alloc] init];
    ocjView_bg.backgroundColor = [UIColor colorWSHHFromHexString:@"000000"];
    ocjView_bg.alpha = 0.6;
    [self.view addSubview:ocjView_bg];
    [ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(self.view);
    }];
    //返回按钮
    self.ocjBtn_back = [[UIButton alloc] init];
    [self.ocjBtn_back setImage:[UIImage imageNamed:@"icon_left"] forState:UIControlStateNormal];
    [self.ocjBtn_back addTarget:self action:@selector(ocj_clickedScanBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ocjBtn_back];
    [self.ocjBtn_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.width.mas_equalTo(@44);
        make.height.mas_equalTo(@44);
    }];
    //title
    self.ocjLab_title = [[UILabel alloc] init];
    self.ocjLab_title.text = @"二维码分享";
    self.ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
    self.ocjLab_title.font = [UIFont systemFontOfSize:17];
    self.ocjLab_title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.ocjBtn_back);
    }];
}

- (void)ocj_addViews {
    //imgView
    UIImageView *ocjImgView_share = [[UIImageView alloc] init];
    [ocjImgView_share setImage:[UIImage imageNamed:@"Icon_qrcode_"]];
    [self.view addSubview:ocjImgView_share];
    [ocjImgView_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(120);
        make.width.mas_equalTo(290 / 375.0 * SCREEN_WIDTH);
        make.height.mas_equalTo(360 / 667.0 * SCREEN_HEIGHT);
    }];
    //扫描按钮
    OCJBaseButton *ocjBtn_scan = [[OCJBaseButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 205 / 375.0 * SCREEN_WIDTH) / 2, 120 + 32 + 360 / 667.0 * SCREEN_HEIGHT, 205 / 375.0 * SCREEN_WIDTH, 45)];
  [ocjBtn_scan ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [ocjBtn_scan setTitle:@"二维码扫描" forState:UIControlStateNormal];
    [ocjBtn_scan setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    ocjBtn_scan.ocjFont = [UIFont systemFontOfSize:14];
    ocjBtn_scan.layer.cornerRadius = 2;
  ocjBtn_scan.layer.masksToBounds = YES;
    ocjBtn_scan.backgroundColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    [ocjBtn_scan addTarget:self action:@selector(ocj_clickedScanBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:ocjBtn_scan];
}

- (void)ocj_clickedScanBtn {
  [self ocj_trackEventID:@"AP1706C070F008001O008001" parmas:nil];
    OCJScanVC *scanVC = [[OCJScanVC alloc] init];
    scanVC.isShowNav = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ocj_back {
  [self ocj_trackEventID:@"AP1706C070D003001C003001" parmas:nil];
  [super ocj_back];
}

//根据颜色转图片
-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 协议方法实现区域

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
