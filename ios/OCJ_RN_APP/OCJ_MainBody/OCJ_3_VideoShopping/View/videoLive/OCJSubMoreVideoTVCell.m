//
//  OCJSubMoreVideoTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/12.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJSubMoreVideoTVCell.h"
#import "OCJSubMoreVideoView.h"

@interface OCJSubMoreVideoTVCell ()

@property (nonatomic, strong) UIImageView *ocjImgView;            ///<预览图
@property (nonatomic, strong) UIImageView *ocjimgView_play;       ///<播放按钮
@property (nonatomic, strong) OCJBaseLabel *ocjLab_title;         ///<标题
@property (nonatomic, strong) OCJBaseLabel *ocjLab_time;          ///<视频时长

@property (nonatomic, strong) OCJSubMoreVideoView *ocjView_left;  ///<左半边视图
@property (nonatomic, strong) OCJSubMoreVideoView *ocjView_right; ///<右半边视图

@end

@implementation OCJSubMoreVideoTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      [self ocj_addSubView];
  }
  return self;
}

-(void)ocj_addSubView{
  CGFloat viewWidth = (SCREEN_WIDTH - 40) / 2;
  __weak OCJSubMoreVideoTVCell *weakSelf = self;
  
  UIView* middleVerSep = [[UIView alloc]init];
  middleVerSep.backgroundColor = [UIColor colorWSHHFromHexString:@"#DDDDDD"];
  [self.contentView addSubview:middleVerSep];
  [middleVerSep mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.mas_equalTo(@1);
    make.top.bottom.mas_equalTo(self);
    make.centerX.mas_equalTo(self);
  }];
  
  UIView* topHorSep = [[UIView alloc]init];
  topHorSep.backgroundColor = [UIColor colorWSHHFromHexString:@"#DDDDDD"];
  [self.contentView addSubview:topHorSep];
  [topHorSep mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(@1);
    make.top.mas_equalTo(self);
    make.left.right.mas_equalTo(self);
  }];
  
  self.ocjView_left = [[OCJSubMoreVideoView alloc] init];
  [self addSubview:self.ocjView_left];
  [self.ocjView_left mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left).offset(10);
    make.top.mas_equalTo(self.mas_top).offset(5);
    make.width.height.mas_equalTo(viewWidth);
  }];
  
  self.ocjView_right = [[OCJSubMoreVideoView alloc] init];
  [self addSubview:self.ocjView_right];
  [self.ocjView_right mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjView_left.mas_right).offset(20);
    make.top.mas_equalTo(self.mas_top).offset(5);
    make.width.height.mas_equalTo(viewWidth);
  }];
  self.ocjView_left.ocjTappedVideoBlock = ^(NSString *ocjStr_contentCode) {
    weakSelf.ocjSubMoreVideoBlock(ocjStr_contentCode);
  };
  self.ocjView_right.ocjTappedVideoBlock = ^(NSString *ocjStr_contentCode) {
    weakSelf.ocjSubMoreVideoBlock(ocjStr_contentCode);
  };
}

- (void)setOcjArr_data:(NSArray *)ocjArr_data {
  
  if (ocjArr_data.count == 1) {
    self.ocjView_right.hidden = YES;
    self.ocjView_left.ocjModel_desc = ocjArr_data[0];
    
  }else {
    self.ocjView_right.hidden = NO;
    self.ocjView_left.ocjModel_desc = ocjArr_data[0];
    self.ocjView_right.ocjModel_desc = ocjArr_data[1];
  }
  
//  for (UIView *view in self.subviews) {
//    [view removeFromSuperview];
//  }
//  __weak OCJSubMoreVideoTVCell *weakSelf = self;
//  OCJSubMoreVideoView *ocjView_last;
//  CGFloat viewWidth = (SCREEN_WIDTH - 40) / 2;
//  for (int i = 0; i < ocjArr_data.count; i++) {
//    OCJSubMoreVideoView *ocjView = [[OCJSubMoreVideoView alloc] init];
//    ocjView.ocjModel_desc = ocjArr_data[i];
//    ocjView.ocjTappedVideoBlock = ^(NSString *ocjStr_contentCode) {
//      if (weakSelf.ocjSubMoreVideoBlock) {
//        weakSelf.ocjSubMoreVideoBlock(ocjStr_contentCode);
//      }
//    };
//    
//    [self addSubview:ocjView];
//    [ocjView mas_makeConstraints:^(MASConstraintMaker *make) {
//      if (!ocjView_last) {
//        make.left.mas_equalTo(self.mas_left).offset(10);
//      }else {
//        make.left.mas_equalTo(ocjView_last.mas_right).offset(20);
//      }
//      make.top.mas_equalTo(self.mas_top).offset(5);
//      make.width.height.mas_equalTo(viewWidth);
//    }];
//    
//    ocjView_last = ocjView;
//  }
  /*
  for (OCJResponceModel_VideoDetailDesc* model in ocjArr_data) {
    NSInteger index = [ocjArr_data indexOfObject:model];
    NSInteger tag = 200 + index; //视图标签
    OCJSubMoreVideoView* view = [self.contentView viewWithTag:tag];
    
    view.ocjModel_desc = model;
  }
   */
}


@end
