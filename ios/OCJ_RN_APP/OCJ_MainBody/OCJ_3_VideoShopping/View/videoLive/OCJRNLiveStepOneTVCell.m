//
//  OCJRNLiveStepOneTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/11.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJRNLiveStepOneTVCell.h"

@interface OCJRNLiveStepOneTVCell ()

@property (nonatomic, strong) UIButton *ocjBtn_video;         ///<
@property (nonatomic, strong) UIImageView *ocjImgView;        ///<
@property (nonatomic, strong) NSArray *ocjArr_temp;
@property (nonatomic, strong) UIImageView *ocjImgView_selected;///<上一次选中图片

@end

@implementation OCJRNLiveStepOneTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self ocj_setSelf];
  }
  return self;
}

- (void)ocj_setSelf {
  
}

- (void)setOcjArr_video:(NSArray *)ocjArr_video {
  self.ocjArr_temp = ocjArr_video;
  CGFloat space = 10;
  __block CGFloat totalWidth = 40;
  CGFloat viewWidth = (SCREEN_WIDTH - totalWidth) / 3.0;
  UIView *ocjView_last;
  for (int i = 0; i < ocjArr_video.count; i++) {
    NSInteger row = i / 3 + 1;
//    NSInteger col = i % 3 + 1;
    NSDictionary *dic = [ocjArr_video objectAtIndex:i];
    UIView *ocjView = [[UIView alloc] init];
    ocjView.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tappedLiveImage:)];
    [ocjView addGestureRecognizer:tap];
    ocjView.tag = i;
    [self addSubview:ocjView];
    [ocjView mas_makeConstraints:^(MASConstraintMaker *make) {
      if (!ocjView_last) {
        totalWidth += viewWidth;
        make.left.mas_equalTo(self.mas_left).offset(space);
      }else {
        totalWidth += viewWidth;
        if (totalWidth > SCREEN_WIDTH + 1) {
          make.left.mas_equalTo(self.mas_left).offset(space);
          totalWidth = 40 + viewWidth;
        }else {
          make.left.mas_equalTo(ocjView_last.mas_right).offset(space);
        }
      }
      make.top.mas_equalTo(self.mas_top).offset(space * row + (viewWidth) * (row - 1));
      make.width.height.mas_equalTo(viewWidth);
    }];
    
    //预览图
    NSString *ocjStr_url = [dic objectForKey:@"video_picpath"];
    UIImageView *ocjImgView2 = [[UIImageView alloc] init];
    [ocjView addSubview:ocjImgView2];
    [ocjImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.right.bottom.mas_equalTo(ocjView);
    }];
    [ocjImgView2 ocj_setWebImageWithURLString:ocjStr_url completion:nil];
    //选中图
    UIImageView *ocjImgView = [[UIImageView alloc] init];
    [ocjImgView setImage:[UIImage imageNamed:@"Image_select"]];
    ocjImgView.tag = i + 100;
    [ocjView addSubview:ocjImgView];
    [ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.right.bottom.mas_equalTo(ocjView);
    }];
    if (i == 0) {
      ocjImgView.hidden = NO;
      self.ocjImgView_selected = ocjImgView;
    }else {
      ocjImgView.hidden = YES;
    }
    
    ocjView_last = ocjView;
  }
}

- (void)ocj_tappedLiveImage:(UITapGestureRecognizer *)tap {
  NSInteger index = tap.view.tag;
  NSDictionary *ocjDic = [self.ocjArr_temp objectAtIndex:index];
  NSString *ocjStr = [ocjDic objectForKey:@"video_url"];
  self.ocjImgView_selected.hidden = YES;
  UIImageView *ocjImgView = (UIImageView *)[tap.view viewWithTag:index + 100];
  self.ocjImgView_selected = ocjImgView;
  ocjImgView.hidden = NO;
  if (self.ocjChangeVideoUrlBlock) {
    self.ocjChangeVideoUrlBlock(ocjStr);
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
