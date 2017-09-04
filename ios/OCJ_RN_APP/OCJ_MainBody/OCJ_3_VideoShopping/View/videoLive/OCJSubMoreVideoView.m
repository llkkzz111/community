//
//  OCJSubMoreVideoView.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/12.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJSubMoreVideoView.h"
#import <UIImageView+WebCache.h>

@interface OCJSubMoreVideoView ()

@property (nonatomic, strong) UIImageView *ocjImgView;   ///<预览图
@property (nonatomic, strong) UIImageView *ocjimgView_play;     ///<播放按钮
@property (nonatomic, strong) OCJBaseLabel *ocjLab_title;///<标题
@property (nonatomic, strong) OCJBaseLabel *ocjLab_time; ///<视频时长

@property (nonatomic, strong) NSString *ocjStr_code;    ///<

@end

@implementation OCJSubMoreVideoView

- (instancetype)init {
  self = [super init];
  if (self) {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tappedView:)];
    [self addGestureRecognizer:tap];
    [self ocj_addViews];
  }
  return self;
}

- (void)ocj_addViews {
  
  //预览图
  self.ocjImgView = [[UIImageView alloc] init];
  self.ocjImgView.contentMode = UIViewContentModeScaleAspectFit;
  [self addSubview:self.ocjImgView];
  [self.ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self).offset(10);
    make.left.mas_equalTo(self.mas_left).offset(15);
    make.right.mas_equalTo(self.mas_right).offset(-15);
    make.height.mas_equalTo(self.mas_height).offset(-50);
  }];
  
  //时长图片
  self.ocjLab_time = [[OCJBaseLabel alloc] init];
  self.ocjLab_time.textColor = [UIColor colorWSHHFromHexString:@"FFFFFF"];
  self.ocjLab_time.font = [UIFont systemFontOfSize:10];
//  self.ocjLab_time.text = @"12:30";
  self.ocjLab_time.textAlignment = NSTextAlignmentRight;
  [self addSubview:self.ocjLab_time];
  [self.ocjLab_time mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.ocjImgView.mas_right).offset(-5);
    make.bottom.mas_equalTo(self.ocjImgView.mas_bottom).offset(-3);
    make.left.mas_equalTo(self.ocjImgView);
    make.height.mas_equalTo(@16);
  }];
  
  //标题
  self.ocjLab_title = [[OCJBaseLabel alloc] init];
//  self.ocjLab_title.text = @"装修风格搭配";
  self.ocjLab_title.font = [UIFont systemFontOfSize:14];
  self.ocjLab_title.textColor = OCJ_COLOR_DARK;
  self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
  self.ocjLab_title.numberOfLines = 1;
  [self addSubview:self.ocjLab_title];
  [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self).offset(10);
    make.right.mas_equalTo(self).offset(-10);
    make.top.mas_equalTo(self.ocjImgView.mas_bottom).offset(10);
    make.height.mas_equalTo(@20);
  }];
  
  //播放按钮
  
  self.ocjimgView_play = [[UIImageView alloc] init];
  [self.ocjimgView_play setImage:[UIImage imageNamed:@"Icon_play_"]];
  [self addSubview:self.ocjimgView_play];
  [self.ocjimgView_play mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.centerY.mas_equalTo(self.ocjImgView);
    make.width.height.mas_equalTo(@55);
  }];
   
}

- (void)ocj_addLabelTagsWithArray:(NSArray *)ocjArr_tag {
  //标签
  UIImageView *ocjImgView_last;
  CGFloat labelWidth,labelHeight;
  for (int i = 0; i < ocjArr_tag.count; i++) {
    UILabel *ocjLab_tag = [[UILabel alloc] init];
    
    CGRect rect = [self ocj_calculateLabelHeightWithString:ocjArr_tag[i]];
    labelWidth = ceilf(rect.size.width) + 12;
    labelHeight = ceil(rect.size.height) + 2;
    UIImageView *imgView =[[ UIImageView alloc] init];
    [imgView setImage:[UIImage imageNamed:@"Icon_tag_bg_"]];
    [self addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
      if (!ocjImgView_last) {
        make.left.mas_equalTo(self.ocjImgView);
      }else {
        make.left.mas_equalTo(ocjImgView_last.mas_right).offset(5);
      }
      make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(5);
      make.width.mas_equalTo(labelWidth);
      make.height.mas_equalTo(labelHeight);
    }];
    
    ocjLab_tag.text = ocjArr_tag[i];
    ocjLab_tag.textColor = OCJ_COLOR_LIGHT_GRAY;
    ocjLab_tag.font = [UIFont systemFontOfSize:9];
    ocjLab_tag.textAlignment = NSTextAlignmentCenter;
    [self addSubview:ocjLab_tag];
    
    [ocjLab_tag mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.right.bottom.mas_equalTo(imgView);
    }];
    ocjImgView_last = imgView;
  }
}

/**
 model
 */
- (void)setOcjModel_desc:(OCJResponceModel_VideoDetailDesc *)ocjModel_desc {
  self.ocjLab_time.hidden = YES;
  self.ocjStr_code = ocjModel_desc.ocjStr_contentCode;
  [self ocj_addLabelTagsWithArray:ocjModel_desc.ocjArr_labelName];
  self.ocjLab_title.text = [NSString stringWithFormat:@"%@", ocjModel_desc.ocjStr_title];
  [self.ocjImgView ocj_setWebImageWithURLString:[NSString stringWithFormat:@"%@", ocjModel_desc.ocjStr_firstImgUrl] completion:nil];
  
}

/**
 计算label高度
 */
- (CGRect)ocj_calculateLabelHeightWithString:(NSString *)ocjStr {
  CGRect rect = [ocjStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil];
  
  return rect;
}

- (void)ocj_tappedView:(UITapGestureRecognizer *)tap {
  if (self.ocjTappedVideoBlock) {
    self.ocjTappedVideoBlock(self.ocjStr_code);
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
