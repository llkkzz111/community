//
//  OJCSuperValueButtonView.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OJCSuperValueButtonView.h"

@interface OJCSuperValueButtonView()
@property (nonatomic,strong) UIImageView    *ocjImageView_icon; ///< 图片显示
@property (nonatomic,strong) UILabel        *ocjLab_discount; ///< 折扣显示
@property (nonatomic,strong) UILabel        *ocjLab_title; ///< 主标题显示
@property (nonatomic,strong) UILabel        *ocjLab_SubTitle; ///< 副标题显示
@property (nonatomic,strong) UILabel        *ocjLab_Price; ///< 价格显示
@property (nonatomic,strong) UILabel        *ocjLab_Note; ///< 库存显示
@property (nonatomic,strong) UIButton       *ocjBtn_Main; ///<
@property (nonatomic,strong) UIImageView    *ocjImageView_cache; ///< 取网络图片用

@end

@implementation OJCSuperValueButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews
{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.ocjImageView_icon];
    [self.ocjImageView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2 - 10, SCREEN_WIDTH/2 - 10));
    }];
    
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjImageView_icon.mas_bottom).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
//        make.size.height.mas_equalTo(40);
    }];
  
    UILabel * topLabel = [[UILabel alloc] init];
    self.ocjLab_discount = topLabel;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont systemFontOfSize:11];
    topLabel.textColor = [UIColor colorWSHHFromHexString:@"#ED1C41"];
    topLabel.layer.borderColor = [UIColor colorWSHHFromHexString:@"#ED1C41"].CGColor;
    topLabel.layer.borderWidth =.5;
    topLabel.layer.cornerRadius =7.5;
    [self.ocjLab_title addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.top.mas_equalTo(self.ocjImageView_icon.mas_bottom).offset(5);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@15);
    }];
  
    [self addSubview:self.ocjLab_SubTitle];
    [self.ocjLab_SubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(6.5);
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
    }];
    
    [self addSubview:self.ocjLab_Price];
    [self.ocjLab_Price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        make.left.mas_equalTo(self.mas_left).offset(5);
    }];
    
    [self addSubview:self.ocjLab_Note];
    [self.ocjLab_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ocjLab_Price.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-5);
    }];
    
    [self addSubview:self.ocjBtn_Main];
    [self.ocjBtn_Main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
}


-(void)setOcjModel_goodInfo:(OCJGSModel_Package44 *)ocjModel_goodInfo
{
  
    _ocjModel_goodInfo = ocjModel_goodInfo;
  __weak OJCSuperValueButtonView* weakSelf = self;
  
    [self.ocjImageView_icon ocj_setWebImageWithURLString:ocjModel_goodInfo.ocjStr_imageUrl completion:nil];
  
    if ([ocjModel_goodInfo.ocjStr_title wshh_stringIsValid]) {
        self.ocjLab_title.text = ocjModel_goodInfo.ocjStr_title;
      
        if ([ocjModel_goodInfo.ocjStr_discount isEqualToString:@"0"] || [ocjModel_goodInfo.ocjStr_discount isEqualToString:@"10"] || [ocjModel_goodInfo.ocjStr_discount isEqualToString:@""]) {//0折和10折或者为空时不显示
            self.ocjLab_discount.alpha = 0;
          
        }else{
          
            self.ocjLab_discount.alpha = 1;
            self.ocjLab_discount.text = [NSString stringWithFormat:@"%@折",ocjModel_goodInfo.ocjStr_discount];
        }
      
        [self.ocjImageView_cache ocj_setWebImageWithURLString:ocjModel_goodInfo.ocjStr_countryImageUrl completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (image) {
              NSAttributedString *ocjStr_title = [weakSelf creatImageAndTextStr:weakSelf.ocjLab_discount.alpha?@"占位符  ":@"" andAfterText:ocjModel_goodInfo.ocjStr_title  ImageIcon:image];
              [weakSelf.ocjLab_title setAttributedText:ocjStr_title];
            }
        }];
    }
  
    [self.ocjLab_SubTitle setText:ocjModel_goodInfo.ocjStr_subTitle];
  
    if ([ocjModel_goodInfo.ocjStr_price wshh_stringIsValid]) {
     
        NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@",ocjModel_goodInfo.ocjStr_price]];
        [strM addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
      
        [self.ocjLab_Price setAttributedText:strM];
    }
  
    NSString* stockStatus = @"";
    if ([ocjModel_goodInfo.ocjStr_isInStock isEqualToString:@"1"]) {
        stockStatus = @"库存紧张";
    }else{
        stockStatus = @"";
    }
    [self.ocjLab_Note setText:stockStatus];
  
}

//富文本编辑
-(NSAttributedString *)creatImageAndTextStr:(NSString *)agoText andAfterText:(NSString *)AfterText ImageIcon:(UIImage *)image;
{
  
    NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:agoText];
    if (image) {
      
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, -3, 16, 14);
      
        NSAttributedString *attribStr = [NSAttributedString attributedStringWithAttachment:attachment];
        [strM appendAttributedString:attribStr];
    }
  
    [strM appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",AfterText]]];
  
    if ([agoText wshh_stringIsValid]) {
        [strM addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, 4)];
    }
  
    return strM;
}


-(void)ocj_mianButtonPressed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_onSuperValueButtonPressedWithGoodInfoModel:)]) {
        [self.delegate ocj_onSuperValueButtonPressedWithGoodInfoModel:self.ocjModel_goodInfo];
    }
}

#pragma mark - getter
- (UIImageView *)ocjImageView_icon
{
    if (!_ocjImageView_icon) {
        _ocjImageView_icon =[[UIImageView alloc] initWithFrame:CGRectZero];
        [_ocjImageView_icon setBackgroundColor:[UIColor colorWSHHFromHexString:@"#ededed"]];
    }
    return _ocjImageView_icon;
}

- (UILabel *)ocjLab_title
{
    if (!_ocjLab_title) {
        _ocjLab_title =[[UILabel alloc] initWithFrame:CGRectZero];
        [_ocjLab_title setBackgroundColor:[UIColor clearColor]];
        _ocjLab_title.font = [UIFont systemFontOfSize:13];
        _ocjLab_title.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _ocjLab_title.numberOfLines = 2;
    }
    return _ocjLab_title;
}

- (UILabel *)ocjLab_SubTitle
{
    if (!_ocjLab_SubTitle) {
        _ocjLab_SubTitle =[[UILabel alloc] initWithFrame:CGRectZero];
        [_ocjLab_SubTitle setBackgroundColor:[UIColor clearColor]];
        _ocjLab_SubTitle.font = [UIFont systemFontOfSize:12];
        _ocjLab_SubTitle.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        _ocjLab_SubTitle.numberOfLines = 2;
    }
    return _ocjLab_SubTitle;
}

- (UILabel *)ocjLab_Price
{
    if (!_ocjLab_Price) {
        _ocjLab_Price =[[UILabel alloc] initWithFrame:CGRectZero];
        [_ocjLab_Price setBackgroundColor:[UIColor clearColor]];
        _ocjLab_Price.font = [UIFont systemFontOfSize:18];
        _ocjLab_Price.textColor = [UIColor colorWithRed:299/255.0 green:41/255.0 blue:13/255.0 alpha:1/1.0];
//        _ocjLab_Price.text = @"￥1980";
    }
    return _ocjLab_Price;
}

- (UILabel *)ocjLab_Note
{
    if (!_ocjLab_Note) {
        _ocjLab_Note =[[UILabel alloc] initWithFrame:CGRectZero];
        [_ocjLab_Note setBackgroundColor:[UIColor clearColor]];
//        _ocjLab_Note.text = @"库存紧张";
        _ocjLab_Note.font = [UIFont systemFontOfSize:11];
        _ocjLab_Note.textColor = [UIColor colorWithRed:237/255.0 green:28/255.0 blue:65/255.0 alpha:1/1.0];
    }
    return _ocjLab_Note;
}

- (UIButton *)ocjBtn_Main
{
    if (!_ocjBtn_Main) {
        _ocjBtn_Main = [[UIButton alloc] init];
        [_ocjBtn_Main setBackgroundColor:[UIColor clearColor]];
        [_ocjBtn_Main addTarget:self action:@selector(ocj_mianButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_Main;
}

-(UIImageView *)ocjImageView_cache{
  if (!_ocjImageView_cache) {
    _ocjImageView_cache = [[UIImageView alloc]init];
    [self addSubview:_ocjImageView_cache];
  }
  return _ocjImageView_cache;
}

@end
