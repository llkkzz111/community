//
//  OCJOnTheNewCollectionCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJOnTheNewCollectionCell.h"

@interface OCJOnTheNewCollectionCell()
@property (nonatomic,strong) UIView         *ocjView_bg;
@property (nonatomic,strong) UIImageView    *ocjImageView_icon;
@property (nonatomic,strong) UILabel        *ocjLab_title;
@property (nonatomic,strong) UILabel        *ocjLab_SubTitle;
@property (nonatomic,strong) UILabel        *ocjLab_Price;

@property (nonatomic,strong) UIImageView* ocjImageView_cache; ///< 获取网络图片用

@end

@implementation OCJOnTheNewCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews
{
    [self addSubview:self.ocjView_bg];
    [self.ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        make.right.mas_equalTo(self);
    }];
    
    [self.ocjView_bg addSubview:self.ocjImageView_icon];
  self.ocjView_bg.layer.borderWidth = .5f;
  self.ocjView_bg.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.ocjView_bg.clipsToBounds = YES;
    [self.ocjImageView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.mas_left).offset(15);
//        make.top.mas_equalTo(self.mas_top).offset(15);
        make.left.mas_equalTo(self.ocjView_bg.mas_left).offset(0);
        make.top.mas_equalTo(self.ocjView_bg.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImageView_icon.mas_right).offset(5);
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(195, 48));
    }];
    
    [self addSubview:self.ocjLab_SubTitle];
    [self.ocjLab_SubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImageView_icon.mas_right).offset(5);
        make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(195, 34));
    }];
    
    [self addSubview:self.ocjLab_Price];
    [self.ocjLab_Price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImageView_icon.mas_right).offset(5);
        make.top.mas_equalTo(self.ocjLab_SubTitle.mas_bottom).offset(7);
        make.size.mas_equalTo(CGSizeMake(195, 21));
    }];
}

- (void)ocj_setViewDataWith:(OCJGSModel_Package43 *)model
{
    [self.ocjImageView_icon ocj_setWebImageWithURLString:model.ocjStr_imageUrl completion:nil];
  
    self.ocjLab_title.text = model.ocjStr_title;
    __weak OCJOnTheNewCollectionCell* weakSelf = self;
    [self.ocjImageView_cache ocj_setWebImageWithURLString:model.ocjStr_countryImageUrl completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
    
        if (image) {
          [weakSelf.ocjLab_title setAttributedText:[weakSelf creatImageAndTextStr:@"" andAfterText:[NSString stringWithFormat:@"  %@",model.ocjStr_title] ImageIcon:image]];
        }
    
    }];
  
    self.ocjLab_SubTitle.text = model.ocjStr_subTitle;
  
    self.ocjLab_Price.text = [NSString stringWithFormat:@"¥%@",model.ocjStr_price];
  
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
  
  [strM appendAttributedString:[[NSAttributedString alloc] initWithString:AfterText]];
  return strM;
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
        _ocjLab_title.font = [UIFont systemFontOfSize:14];
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
        NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥699"]];
        [strM addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];

        _ocjLab_Price =[[UILabel alloc] initWithFrame:CGRectZero];
        [_ocjLab_Price setBackgroundColor:[UIColor clearColor]];
        _ocjLab_Price.font = [UIFont systemFontOfSize:15];
//        _ocjLab_Price.attributedText = strM;
        _ocjLab_Price.textColor = [UIColor colorWithRed:229/255.0 green:41/255.0 blue:13/255.0 alpha:1/1.0];

    }
    return _ocjLab_Price;
}

- (UIView *)ocjView_bg
{
    if (!_ocjView_bg) {
        _ocjView_bg = [[UIView alloc] init];
        [_ocjView_bg setBackgroundColor:[UIColor clearColor]];
//        [_ocjView_bg.layer setMasksToBounds:YES];
//        [_ocjView_bg.layer setBorderWidth:0.5]; //边框宽度
//        CGColorRef color = [UIColor lightGrayColor].CGColor;
//        [_ocjView_bg.layer setBorderColor:color];
      
    }
    return _ocjView_bg;
}

-(UIImageView *)ocjImageView_cache{
  if (!_ocjImageView_cache) {
    _ocjImageView_cache = [[UIImageView alloc]init];
    [self addSubview:_ocjImageView_cache];
  }
  return _ocjImageView_cache;
}

@end
