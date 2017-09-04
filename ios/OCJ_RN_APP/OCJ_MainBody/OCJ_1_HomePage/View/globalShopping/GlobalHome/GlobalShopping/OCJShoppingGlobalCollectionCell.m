//
//  OCJShoppingGlobalCollectionCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJShoppingGlobalCollectionCell.h"

@interface OCJShoppingGlobalCollectionCell()
@property (nonatomic,strong) UIImageView    *ocjImageView_icon;
@property (nonatomic,strong) UILabel        *ocjLab_title;
@property (nonatomic,strong) UILabel        *ocjLab_Price;

@property (nonatomic,strong) UIImageView* ocjImageView_cache; ///< 获取网络图片用

@end

@implementation OCJShoppingGlobalCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews
{
    [self addSubview:self.ocjImageView_icon];
    [self.ocjImageView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjImageView_icon.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(90, 38));
    }];
    
    [self addSubview:self.ocjLab_Price];
    [self.ocjLab_Price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(5);
        make.left.mas_equalTo(self.ocjLab_title);
    }];
    
}

- (void)ocj_setViewDataWith:(OCJGSModel_Package42 *)model
{
  [self.ocjImageView_icon ocj_setWebImageWithURLString:model.ocjStr_imageUrl completion:nil];
  
  if ([model.ocjStr_title wshh_stringIsValid]) {
    
    self.ocjLab_title.text = model.ocjStr_title;
    
    __weak OCJShoppingGlobalCollectionCell* weakSelf = self;
    [self.ocjImageView_cache ocj_setWebImageWithURLString:model.ocjStr_countryImageUrl completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
      
      if (image) {
          [weakSelf.ocjLab_title setAttributedText:[weakSelf creatImageAndTextStr:@"" andAfterText:[NSString stringWithFormat:@"  %@",model.ocjStr_title] ImageIcon:image]];
      }
      
    }];
  }
  
  if ([model.ocjStr_price wshh_stringIsValid]) {
      NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@",model.ocjStr_price]];
      [strM addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
      
      [self.ocjLab_Price setAttributedText:strM];
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
        _ocjLab_title.font = [UIFont systemFontOfSize:12];
        _ocjLab_title.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _ocjLab_title.numberOfLines = 2;
      
    }
    return _ocjLab_title;
}

- (UILabel *)ocjLab_Price
{
    if (!_ocjLab_Price) {
        _ocjLab_Price =[[UILabel alloc] initWithFrame:CGRectZero];
        [_ocjLab_Price setBackgroundColor:[UIColor clearColor]];
        _ocjLab_Price.font = [UIFont systemFontOfSize:15];
        _ocjLab_Price.textColor = [UIColor colorWithRed:299/255.0 green:41/255.0 blue:13/255.0 alpha:1/1.0];
        _ocjLab_Price.text = @"￥1980";
    }
    return _ocjLab_Price;
}

//富文本编辑
-(NSAttributedString *)creatImageAndTextStr:(NSString *)agoText andAfterText:(NSString *)AfterText ImageIcon:(UIImage *)image;
{
  NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:agoText];
  
  NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
  attachment.image = image;
  attachment.bounds = CGRectMake(0, -3, 16, 14);
  
  NSAttributedString *attribStr = [NSAttributedString attributedStringWithAttachment:attachment];
  [strM appendAttributedString:attribStr];
  
  [strM appendAttributedString:[[NSAttributedString alloc] initWithString:AfterText]];
  
  return strM;
}

#pragma mark - getter
-(UIImageView *)ocjImageView_cache{
  if (!_ocjImageView_cache) {
    _ocjImageView_cache = [[UIImageView alloc]init];
    [self addSubview:_ocjImageView_cache];
  }
  return _ocjImageView_cache;
}

@end
