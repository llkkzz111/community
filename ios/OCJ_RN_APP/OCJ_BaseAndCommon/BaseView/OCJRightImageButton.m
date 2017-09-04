//
//  OCJRightImageButton.m
//  OCJ_RN_APP
//
//  Created by apple on 2017/7/9.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJRightImageButton.h"

@interface OCJRightImageButton ()

@property (nonatomic, weak) OCJBaseLabel *ocjTitleLabel;
@property (nonatomic, weak) UIImageView *ocjImageView;


@end

@implementation OCJRightImageButton

- (instancetype)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    [self setupCustomView];
  }
  return self;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
  [super setImage:image forState:state];
  self.ocjImageView.image = image;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
  [super setTitle:title forState:state];
  self.ocjTitleLabel.text = title;
}

- (void)setOcjFont:(UIFont *)ocjFont{
  self.ocjTitleLabel.font = ocjFont;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
  [super setTitleColor:color forState:state];
  self.ocjTitleLabel.textColor = color;
}

- (void)layoutSubviews{
  [super layoutSubviews];
  self.imageView.alpha = 0;
  self.titleLabel.alpha = 0;
  self.ocjTitleLabel.textColor = self.currentTitleColor;
  self.ocjImageView.image = self.currentImage;
}

- (void)setupCustomView{
  
  OCJBaseLabel *label = [[OCJBaseLabel alloc] init];
  label.font = self.titleLabel.font;
  label.textAlignment = NSTextAlignmentCenter;
  [self addSubview:label];
  self.ocjTitleLabel = label;
  [label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.titleLabel);
    make.width.height.equalTo(self.titleLabel);
    make.left.equalTo(self.imageView);
  }];
//  label.layer.borderColor = [UIColor redColor].CGColor;
//  label.layer.borderWidth = 1.0f;
  
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.contentMode = self.imageView.contentMode;
  [self addSubview:imageView];
  self.ocjImageView = imageView;
  [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.imageView);
    make.width.height.equalTo(self.imageView);
    make.right.equalTo(self.titleLabel.mas_right);
  }];
//  imageView.layer.borderColor = [UIColor blueColor].CGColor;
//  imageView.layer.borderWidth = 1.0f;
}

@end
