//
//  OCJGlobalScreenHeadView.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobalScreenHeadView.h"


@interface OCJGlobalScreenHeadView()
@property (nonatomic,strong) UIButton       *ocjBtn_all;
@property (nonatomic,strong) UIView         *ocjView_gapone;
@property (nonatomic,strong) UIButton       *ocjBtn_salesVolume;
@property (nonatomic,strong) UIButton       *ocjBtn_price;
@property (nonatomic,strong) UIButton       *ocjBtn_screen;
@property (nonatomic,strong) UIButton       *ocjBtn_hotArea; ///<
@property (nonatomic,strong) UIButton       *ocjBtn_SingleProduce; ///<
@property (nonatomic,strong) UIButton       *ocjBtn_brand; ///<


@property (nonatomic,strong) UIView         *ocjView_headone;
@property (nonatomic,strong) UIView         *ocjView_headsec;
@property (nonatomic,assign) NSInteger      ocjInt_salesSort;
@property (nonatomic,assign) NSInteger      ocjInt_priceSort;
@property (nonatomic,assign) NSInteger      ocjInt_singleProductions;

@end

@implementation OCJGlobalScreenHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.ocjInt_salesSort = 0;
        self.ocjInt_priceSort = 0;
        self.ocjInt_singleProductions = 0;
        [self ocj_addViews];
    }
    return self;
}

#pragma mark - 私有方法区域
- (void)ocj_addViews
{
    [self addSubview:self.ocjView_headone];
    [self.ocjView_headone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.size.height.mas_equalTo(40);
    }];
    
    [self.ocjView_headone addSubview:self.ocjBtn_all];//全部
    [self.ocjBtn_all mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_headone);
        make.top.mas_equalTo(self.ocjView_headone);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 40));
    }];
    
    [self.ocjView_headone addSubview:self.ocjBtn_salesVolume];//销量
    [self.ocjBtn_salesVolume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_all.mas_right);
        make.top.mas_equalTo(self.ocjView_headone);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 40));
    }];
    
    [self.ocjView_headone addSubview:self.ocjBtn_price];//价格
    [self.ocjBtn_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_salesVolume.mas_right);
        make.top.mas_equalTo(self.ocjView_headone);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 40));
    }];
  
    UIView *gapone = [self ocj_duplicate:self.ocjView_gapone];
    [self.ocjView_headone addSubview:gapone];
    [gapone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_all.mas_right);
        make.centerY.mas_equalTo(self.ocjBtn_all.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 16.4));
    }];
    
    UIView *gapsec = [self ocj_duplicate:self.ocjView_gapone];
    [self.ocjView_headone addSubview:gapsec];
    [gapsec mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_salesVolume.mas_right);
        make.centerY.mas_equalTo(self.ocjBtn_salesVolume.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 16.4));
    }];
    
    UIView *gapthr = [self ocj_duplicate:self.ocjView_gapone];
    [self.ocjView_headone addSubview:gapthr];
    [gapthr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_price.mas_right);
        make.centerY.mas_equalTo(self.ocjBtn_price.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 16.4));
    }];
    
    [self addSubview:self.ocjView_headsec];
    [self.ocjView_headsec mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self.ocjView_headone.mas_bottom).offset(1);
        make.size.height.mas_equalTo(44);
    }];
    
    [self.ocjView_headsec addSubview:self.ocjBtn_SingleProduce];
    [self.ocjBtn_SingleProduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_headsec).offset((SCREEN_WIDTH/3 - 80)/2);
        make.centerY.mas_equalTo(self.ocjView_headsec.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 22.5));
    }];
    
    [self.ocjView_headsec addSubview:self.ocjBtn_hotArea];
    [self.ocjBtn_hotArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_SingleProduce.mas_right).offset(SCREEN_WIDTH/3 - 80);
        make.centerY.mas_equalTo(self.ocjView_headsec.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 22.5));
    }];
    
    [self.ocjView_headsec addSubview:self.ocjBtn_brand];
    [self.ocjBtn_brand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_hotArea.mas_right).offset(SCREEN_WIDTH/3 - 80);
        make.centerY.mas_equalTo(self.ocjView_headsec.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 22.5));
    }];
    
    [self ocj_setButtonStly];
}

-(void)setOcjModel_condition:(OCJGSRModel_screenCondition *)ocjModel_condition{
    _ocjModel_condition = ocjModel_condition;
  
    //=======
    if (ocjModel_condition.ocjBool_isAll) {
        [self.ocjBtn_all setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
    }else{
        [self.ocjBtn_all setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
    }
  
    //=======
    if ([ocjModel_condition.ocjStr_priceSort isEqualToString:@"1"]) {//升序
    
        [self.ocjBtn_price setImage:[UIImage imageNamed:@"icon_asc_"] forState:UIControlStateNormal];
    
    }else if ([ocjModel_condition.ocjStr_priceSort isEqualToString:@"2"]){//降序
    
        [self.ocjBtn_price setImage:[UIImage imageNamed:@"icon_desc_"] forState:UIControlStateNormal];
    }else{
    
        [self.ocjBtn_price setImage:[UIImage imageNamed:@"icon_asc_gray_"] forState:UIControlStateNormal];
    }
  
    //=======
    if ([ocjModel_condition.ocjStr_salesVolumeSort isEqualToString:@"1"]) {
    
        [self.ocjBtn_salesVolume setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
    }else{
    
        [self.ocjBtn_salesVolume setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
    }
  
    //=======
    if (ocjModel_condition.ocjArr_areaFiltrate.count>0) {
    
        [self.ocjBtn_hotArea setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
        [self.ocjBtn_hotArea.layer setBorderColor:[UIColor colorWSHHFromHexString:@"#E5290D"].CGColor];
      
        [self.ocjBtn_hotArea setTitle:ocjModel_condition.ocjStr_area forState:UIControlStateNormal];
        [self.ocjBtn_hotArea setImage:[UIImage imageNamed:@"icon_left_red"] forState:UIControlStateNormal];
      
        self.ocjBtn_hotArea.backgroundColor = [UIColor clearColor];
    }else{
    
        [self.ocjBtn_hotArea setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
        [self.ocjBtn_hotArea.layer setBorderColor:[UIColor clearColor].CGColor];
        [self.ocjBtn_hotArea setTitle:@"热门地区" forState:UIControlStateNormal];
        self.ocjBtn_hotArea.backgroundColor = [UIColor colorWSHHFromHexString:@"#EEEEEE"];
      
        [self.ocjBtn_hotArea setImage:[UIImage imageNamed:@"icon_right_gray"] forState:UIControlStateNormal];
    }
  
    //=======
    if (ocjModel_condition.ocjArr_brandFiltrate.count>0) {
    
        [self.ocjBtn_brand setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
        [self.ocjBtn_brand.layer setBorderColor:[UIColor colorWSHHFromHexString:@"#E5290D"].CGColor];
      
        [self.ocjBtn_brand setImage:[UIImage imageNamed:@"icon_left_red"] forState:UIControlStateNormal];
        [self.ocjBtn_brand setTitle:ocjModel_condition.ocjStr_brand forState:UIControlStateNormal];
      
        self.ocjBtn_brand.backgroundColor = [UIColor clearColor];
    }else{
      
        [self.ocjBtn_brand setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
        [self.ocjBtn_brand.layer setBorderColor:[UIColor clearColor].CGColor];
        [self.ocjBtn_brand setTitle:@"品牌" forState:UIControlStateNormal];
        self.ocjBtn_brand.backgroundColor = [UIColor colorWSHHFromHexString:@"#EEEEEE"];
      
        [self.ocjBtn_brand setImage:[UIImage imageNamed:@"icon_right_gray"] forState:UIControlStateNormal];
    }
  
    //=======
    if ([ocjModel_condition.ocjStr_superValueFiltrate isEqualToString:@"1"]) {
    
        [self.ocjBtn_SingleProduce setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
        [self.ocjBtn_SingleProduce.layer setBorderColor:[UIColor colorWSHHFromHexString:@"#E5290D"].CGColor];
    }else{
    
        [self.ocjBtn_SingleProduce setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
        [self.ocjBtn_SingleProduce.layer setBorderColor:[UIColor clearColor].CGColor];
    }
}

- (void)ocj_setButtonStly
{
    CGFloat spacing = 3.0;
    
    CGSize imageSize = self.ocjBtn_price.imageView.frame.size;
    self.ocjBtn_price.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
    CGSize titleSize = self.ocjBtn_price.titleLabel.frame.size;
    self.ocjBtn_price.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
    
    imageSize = self.ocjBtn_salesVolume.imageView.frame.size;
    self.ocjBtn_salesVolume.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
    titleSize = self.ocjBtn_salesVolume.titleLabel.frame.size;
    self.ocjBtn_salesVolume.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
  
    self.ocjBtn_screen.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing, 0.0, 0.0);
    self.ocjBtn_screen.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -spacing);
}

- (UIView*)ocj_duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (void)ocj_buttonPressed:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalHeadButtonPressed:)]) {
      
        [self.delegate ocj_golbalHeadButtonPressed:sender.tag];
    }
}

#pragma mark - getter
- (UIView *)ocjView_headone
{
    if (!_ocjView_headone) {
        _ocjView_headone = [[UIView alloc] init];
        [_ocjView_headone setBackgroundColor:[UIColor whiteColor]];
    }
    return _ocjView_headone;
}

- (UIView *)ocjView_headsec
{
    if (!_ocjView_headsec) {
        _ocjView_headsec = [[UIView alloc] init];
        [_ocjView_headsec setBackgroundColor:[UIColor whiteColor]];
    }
    return _ocjView_headsec;
}

- (UIButton *)ocjBtn_all
{
    if (!_ocjBtn_all) {
        _ocjBtn_all = [[UIButton alloc] init];
        _ocjBtn_all.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ocjBtn_all setTitle:@"全部" forState:UIControlStateNormal];
        _ocjBtn_all.tag = 10001;
        [_ocjBtn_all addTarget:self action:@selector(ocj_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _ocjBtn_all;
}

- (UIButton *)ocjBtn_salesVolume
{
    if (!_ocjBtn_salesVolume) {
        _ocjBtn_salesVolume = [[UIButton alloc] init];
        _ocjBtn_salesVolume.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ocjBtn_salesVolume setTitle:@"销量" forState:UIControlStateNormal];
        _ocjBtn_salesVolume.tag = 10002;
        [_ocjBtn_salesVolume addTarget:self action:@selector(ocj_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_salesVolume;
}

- (UIButton *)ocjBtn_price
{
    if (!_ocjBtn_price) {
        _ocjBtn_price = [[UIButton alloc] init];
        _ocjBtn_price.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ocjBtn_price setTitle:@"价格" forState:UIControlStateNormal];
        [_ocjBtn_price setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
        [_ocjBtn_price setImage:[UIImage imageNamed:@"icon_asc_gray_"] forState:UIControlStateNormal];
        _ocjBtn_price.tag = 10003;
        [_ocjBtn_price addTarget:self action:@selector(ocj_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _ocjBtn_price;
}

- (UIButton *)ocjBtn_screen
{
    if (!_ocjBtn_screen) {
        _ocjBtn_screen = [[UIButton alloc] init];
        _ocjBtn_screen.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ocjBtn_screen setTitle:@"筛选" forState:UIControlStateNormal];
        [_ocjBtn_screen setImage:[UIImage imageNamed:@"Icon_filter"] forState:UIControlStateNormal];
        [_ocjBtn_screen setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        _ocjBtn_screen.tag = 10004;
        [_ocjBtn_screen addTarget:self action:@selector(ocj_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_screen;
}

- (UIButton *)ocjBtn_SingleProduce
{
    if (!_ocjBtn_SingleProduce) {
        _ocjBtn_SingleProduce = [[UIButton alloc] init];
        _ocjBtn_SingleProduce.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ocjBtn_SingleProduce setTitle:@"超值单品" forState:UIControlStateNormal];

        [_ocjBtn_SingleProduce.layer setMasksToBounds:YES];
        [_ocjBtn_SingleProduce.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
        [_ocjBtn_SingleProduce.layer setBorderWidth:1.0]; //边框宽度
        _ocjBtn_SingleProduce.layer.borderColor = [UIColor clearColor].CGColor;
      
        _ocjBtn_SingleProduce.tag = 20001;
        [_ocjBtn_SingleProduce addTarget:self action:@selector(ocj_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_SingleProduce;
}

- (UIButton *)ocjBtn_hotArea
{
    if (!_ocjBtn_hotArea) {
        _ocjBtn_hotArea = [[UIButton alloc] init];
        _ocjBtn_hotArea.titleLabel.font = [UIFont systemFontOfSize:13];
      
        [_ocjBtn_hotArea.layer setMasksToBounds:YES];
        [_ocjBtn_hotArea.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
        [_ocjBtn_hotArea.layer setBorderWidth:1.0]; //边框宽度
        _ocjBtn_hotArea.layer.borderColor = [UIColor clearColor].CGColor;
        [_ocjBtn_hotArea setImage:[UIImage imageNamed:@"icon_right_gray"] forState:UIControlStateNormal];
        [_ocjBtn_hotArea setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
        [_ocjBtn_hotArea setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        _ocjBtn_hotArea.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
      
        _ocjBtn_hotArea.tag = 20002;
        [_ocjBtn_hotArea addTarget:self action:@selector(ocj_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_hotArea;
}

- (UIButton *)ocjBtn_brand
{
    if (!_ocjBtn_brand) {
        _ocjBtn_brand = [[UIButton alloc] init];
        _ocjBtn_brand.titleLabel.font = [UIFont systemFontOfSize:13];
      
        [_ocjBtn_brand.layer setMasksToBounds:YES];
        [_ocjBtn_brand.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
        [_ocjBtn_brand.layer setBorderWidth:1.0]; //边框宽度
        _ocjBtn_brand.layer.borderColor = [UIColor clearColor].CGColor;
        [_ocjBtn_brand setImage:[UIImage imageNamed:@"icon_right_gray"] forState:UIControlStateNormal];
      
        [_ocjBtn_brand setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
        [_ocjBtn_brand setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        _ocjBtn_brand.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
      
        _ocjBtn_brand.tag = 20003;
        [_ocjBtn_brand addTarget:self action:@selector(ocj_buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_brand;
}

- (UIView *)ocjView_gapone
{
    if (!_ocjView_gapone) {
        _ocjView_gapone = [[UIView alloc] init];
        [_ocjView_gapone setBackgroundColor: [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1/1.0]];
    }
    return _ocjView_gapone;
}

@end
