//
//  OCJGlobalScreenGoodCollectionCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobalScreenGoodCollectionCell.h"

@interface OCJGlobalScreenGoodCollectionCell()
@property (nonatomic,strong) UIImageView    *ocjImageView_icon;
@property (nonatomic,strong) UILabel        *ocjLab_title;
@property (nonatomic,strong) UILabel        *ocjLab_Price;
@property (nonatomic,strong) UILabel        *ocjLab_Note;
@property (nonatomic,strong) UILabel        *ocjLab_warning;

@property (nonatomic,strong) UILabel        *ocjLab_discount; ///< 折扣显示
@property (nonatomic,strong) UIImageView    *ocjImageView_cache; ///< 取网络图片用

@end

@implementation OCJGlobalScreenGoodCollectionCell

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
        make.size.height.mas_equalTo(40);
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
    make.top.mas_equalTo(self.ocjImageView_icon.mas_bottom).offset(8);
    make.width.mas_equalTo(@40);
    make.height.mas_equalTo(@15);
  }];
  
    [self addSubview:self.ocjLab_Price];
    [self.ocjLab_Price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(5);
    }];
    
    [self addSubview:self.ocjLab_Note];
    [self.ocjLab_Note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ocjLab_Price.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-6.5);
    }];
    
    [self addSubview:self.ocjLab_warning];
    [self.ocjLab_warning mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjLab_Note.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-6.5);
    }];
    
}


- (void)ocj_setViewDataWith:(OCJGSModel_Package44 *)model
{
  __weak OCJGlobalScreenGoodCollectionCell *weakSelf = self;
  [self.ocjImageView_icon ocj_setWebImageWithURLString:model.ocjStr_imageUrl completion:nil];
  
  self.ocjLab_title.text = model.ocjStr_title;
  
  if ([model.ocjStr_discount floatValue] == 0 || [model.ocjStr_discount floatValue] == 10 || [model.ocjStr_discount isEqualToString:@""]) {//0折和10折或者为空时不显示
    self.ocjLab_discount.alpha = 0;
    
  }else{
    
    self.ocjLab_discount.alpha = 1;
    self.ocjLab_discount.text = [NSString stringWithFormat:@"%@折",model.ocjStr_discount];
  }
  
  [self.ocjImageView_cache ocj_setWebImageWithURLString:model.ocjStr_countryImageUrl completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
    if (image) {
      NSAttributedString *ocjStr_title = [weakSelf creatImageAndTextStr:weakSelf.ocjLab_discount.alpha?@"占位符  ":@"" andAfterText:model.ocjStr_title  ImageIcon:image];
      [weakSelf.ocjLab_title setAttributedText:ocjStr_title];
    }
  }];
  
  
  [self.ocjLab_Price setText:model.ocjStr_price];
  
  
  
  NSString *stockStatus = nil;
  if ([model.ocjStr_isInStock isEqualToString:@"1"]) {
    stockStatus = @"库存紧张";
  }else{
    stockStatus = @"";
  }
  [self.ocjLab_warning setText:stockStatus];
  
  
  NSString *gift = model.ocjStr_giftContent;
  if (gift.length>0) {
    [self.ocjLab_Note setText:@"赠品"];
  }else{
    
    [self.ocjLab_Note setText:@""];
  }

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
        _ocjLab_title.text = @"               德国Valentina2016年限量版粉红玫瑰淡香水";
        _ocjLab_title.font = [UIFont systemFontOfSize:13];
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

- (UILabel *)ocjLab_Note
{
    if (!_ocjLab_Note) {
        _ocjLab_Note =[[UILabel alloc] initWithFrame:CGRectZero];
        [_ocjLab_Note setBackgroundColor:[UIColor clearColor]];
        _ocjLab_Note.font = [UIFont systemFontOfSize:11];
        _ocjLab_Note.textColor = [UIColor colorWithRed:237/255.0 green:28/255.0 blue:65/255.0 alpha:1/1.0];
    }
    return _ocjLab_Note;
}

- (UILabel *)ocjLab_warning
{
    if (!_ocjLab_warning) {
        _ocjLab_warning =[[UILabel alloc] initWithFrame:CGRectZero];
        [_ocjLab_warning setBackgroundColor:[UIColor clearColor]];
        _ocjLab_warning.text = @"库存紧张";
        _ocjLab_warning.font = [UIFont systemFontOfSize:11];
        _ocjLab_warning.textColor = [UIColor colorWithRed:237/255.0 green:28/255.0 blue:65/255.0 alpha:1/1.0];
    }
    return _ocjLab_warning;
}


-(UIImageView *)ocjImageView_cache{
  if (!_ocjImageView_cache) {
    _ocjImageView_cache = [[UIImageView alloc]init];
    [self addSubview:_ocjImageView_cache];
  }
  return _ocjImageView_cache;
}

@end
