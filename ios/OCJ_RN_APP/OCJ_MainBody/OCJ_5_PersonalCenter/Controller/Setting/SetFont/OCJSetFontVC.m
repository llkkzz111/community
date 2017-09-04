//
//  OCJSetFontVC.m
//  OCJ
//
//  Created by OCJ on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSetFontVC.h"
#import "OCJFontView.h"
#import "OCJFontAdapter.h"

@interface OCJSetFontVC ()
@property (nonatomic,strong) UIView * ocjView_top;
@property (nonatomic,strong) OCJBaseLabel * ocjLab_title;
@property (nonatomic,strong) OCJFontView * ocjView_font;
@end

@implementation OCJSetFontVC

#pragma mark - 接口方法实现区域(包括setter、getter方法)

#pragma mark - 生命周期方法区域
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocj_setSelf];
}
#pragma mark - 私有方法区域
- (void)ocj_setSelf{
    self.title = @"字体大小";
  self.ocjStr_trackPageID = @"AP1706C065";
    self.view.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    [self setUI];
}

- (void)ocj_back {
  [self ocj_trackEventID:@"AP1706C065D003001C003001" parmas:nil];
  [super ocj_back];
}

- (void)setUI{
    [self.view addSubview:self.ocjView_top];
    [self.ocjView_top addSubview:self.ocjLab_title];
    [self.view addSubview:self.ocjView_font];
    
    [self.ocjView_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.top.mas_equalTo(self.view).offset(15);
        make.height.mas_equalTo(180);
    }];
    
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_top).offset(20);
        make.right.mas_equalTo(self.ocjView_top).offset(-20);
        make.top.mas_equalTo(self.ocjView_top).offset(20);
    }];
   
    
    [self.ocjView_font mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(141);
    }];
    __weak OCJSetFontVC *weakSelf = self;
    OCJLog(@"系统字体大小:%ld",[OCJFontAdapter ocj_getFontStatues]);
    if ([OCJFontAdapter ocj_getFontStatues] == 1) {
        self.ocjView_font.ocjState_font = OCJFontState_Normal;
    }else{
        self.ocjView_font.ocjState_font = OCJFontState_Double;
    }
    self.ocjView_font.ocjFontHandler = ^(OCJFontState fontState) {
        if (fontState == OCJFontState_Normal) {
            weakSelf.ocjLab_title.font = [UIFont systemFontOfSize:16];
            [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:OCJ_FONT_SETTING_KEY];

        }else{
            [OCJFontAdapter ocj_adapteFont:[UIFont systemFontOfSize:17]];
            [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:OCJ_FONT_SETTING_KEY];

            weakSelf.ocjLab_title.font = [UIFont systemFontOfSize:18];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SysetmFontChangeNotification" object:nil];
    };
}

- (OCJFontView *)ocjView_font{
    if (!_ocjView_font) {
        _ocjView_font = [[OCJFontView alloc]init];
        _ocjView_font.backgroundColor = [UIColor whiteColor];
    }
    return _ocjView_font;
}
- (OCJBaseLabel *)ocjLab_title{
    if (!_ocjLab_title) {
        _ocjLab_title = [[OCJBaseLabel alloc]init];
        _ocjLab_title.font = [UIFont systemFontOfSize:18];
        _ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_title.numberOfLines = 100;
        _ocjLab_title.text = @"拖动下面的滑块可以设置字体的大小！设置后会改变所有界面的字体大小，有两个选项“标准”、“较大”，选择一个适合自己的字体大小吧。";
    }
    return _ocjLab_title;
}
- (UIView *)ocjView_top{
    if (!_ocjView_top) {
        _ocjView_top = [[UIView alloc]init];
        _ocjView_top.backgroundColor =[UIColor whiteColor];
        _ocjView_top.layer.masksToBounds = YES;
        _ocjView_top.layer.borderWidth = 1;
        _ocjView_top.layer.cornerRadius = 6;
        _ocjView_top.layer.borderColor = [UIColor colorWSHHFromHexString:@"D3D3D3"].CGColor;
    }
    return _ocjView_top;
}
#pragma mark - 协议方法实现区域

@end
