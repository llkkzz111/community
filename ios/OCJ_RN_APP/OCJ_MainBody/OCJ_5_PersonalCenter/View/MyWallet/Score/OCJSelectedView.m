//
//  OCJSelectedView.m
//  OCJ
//
//  Created by OCJ on 2017/5/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSelectedView.h"

@interface OCJSelectedView()
@property (nonatomic,assign) NSUInteger    currentIndex; ///< 选中的支付方式
@property (nonatomic,strong) UIButton    * previousButton;  ///< 之前的按钮

@end
@implementation OCJSelectedView



- (instancetype)initWithTitleArray:(NSMutableArray *)title andIndex:(NSInteger)index{
    if (self = [super init]) {
        self.titleArray = title;
        self.currentIndex = index;
        [self ocj_setUI];
    }
    return self;
}

- (void)ocj_setUI{
    CGFloat buttonWidth;
    if (self.titleArray.count > 4) {
      buttonWidth  = (SCREEN_WIDTH - 20 * (self.titleArray.count + 1)) / self.titleArray.count;
    }else {
      buttonWidth  = (SCREEN_WIDTH - 20 * (4 + 1)) / 4;
    }
  
    CGFloat buttonHeight = 25;
    CGFloat itemWidth = 20;
    
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.titleArray[i]  forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14 * SCREEN_WIDTH / 375.0];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        button.tag = i;
        if (i == self.currentIndex) {
            [button setBackgroundImage:[UIImage imageNamed:@"icon_selectedbg"] forState:UIControlStateNormal];
            [button setTitleColor: [UIColor colorWSHHFromHexString:@"E5290D"] forState:UIControlStateNormal];
        }else{
            [button setBackgroundColor:[UIColor colorWSHHFromHexString:@"EEEEEE"]];
            [button setTitleColor: [UIColor colorWSHHFromHexString:@"999999"] forState:UIControlStateNormal];
        }
        [self addSubview:button];
        [button addTarget:self action:@selector(ocj_Switch:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(itemWidth + (buttonWidth + itemWidth) * i);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo(buttonHeight);
        }];
    }
}
- (void)ocj_Switch:(id)sender{
    UIButton * button = (UIButton *)sender;
    self.ocjBtn_selected = button;
    if (button.tag != self.currentIndex) {
        self.currentIndex = button.tag;
    }
    for (UIButton * subBut in self.subviews) {
        if (subBut.tag == self.currentIndex) {
          [subBut setBackgroundImage:[UIImage imageNamed:@"icon_selectedbg"] forState:UIControlStateNormal];
            [subBut setTitleColor: [UIColor colorWSHHFromHexString:@"E5290D"] forState:UIControlStateNormal];
        }else{
          [subBut setBackgroundColor:[UIColor colorWSHHFromHexString:@"EEEEEE"]];
          [subBut setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [subBut setTitleColor: [UIColor colorWSHHFromHexString:@"999999"] forState:UIControlStateNormal];
        }
    }
    if (self.ocj_handler) {
        self.ocj_handler(sender);
    }
}

/**
 支付点击事件
 */
- (void)ocj_paySwitch:(id)sender{
  UIButton * button = (UIButton *)sender;
  if (button.tag != self.currentIndex) {
    self.currentIndex = button.tag;
  }
  UIImageView *ocjImgView_last = (UIImageView *)[self.ocjBtn_selected viewWithTag:self.ocjBtn_selected.tag + 10];
  ocjImgView_last.hidden = YES;
  
  for (UIButton * subBut in self.subviews) {
    UIImageView *ocjImgView = (UIImageView *)[subBut viewWithTag:button.tag + 10];
    
    if (subBut.tag == self.currentIndex) {
      ocjImgView.hidden = NO;
      self.ocjBtn_selected = subBut;
      subBut.layer.borderColor = [UIColor colorWSHHFromHexString:@"E5290D"].CGColor;
      [subBut setTitleColor: [UIColor colorWSHHFromHexString:@"E5290D"] forState:UIControlStateNormal];
    }else{
      subBut.layer.borderColor = [UIColor colorWSHHFromHexString:@"999999"].CGColor;
      [subBut setTitleColor: [UIColor colorWSHHFromHexString:@"999999"] forState:UIControlStateNormal];
    }
  }

  if (self.ocj_handler) {
    self.ocj_handler(sender);
  }
}

- (void)setPayUI{
    CGFloat buttonWidth  = 80;
    CGFloat buttonHeight = 20;
    CGFloat itemWidth = 18.5;
    self.currentIndex = 0;
    
    for (int i = 0; i < self.titleArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.titleArray[i]  forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        button.layer.borderWidth = 1;
        button.tag = i;
        if (i == 0) {
            button.layer.borderColor = [UIColor colorWSHHFromHexString:@"E5290D"].CGColor;
            [button setTitleColor: [UIColor colorWSHHFromHexString:@"E5290D"] forState:UIControlStateNormal];
        }else{
            button.layer.borderColor = [UIColor colorWSHHFromHexString:@"999999"].CGColor;
            [button setTitleColor: [UIColor colorWSHHFromHexString:@"999999"] forState:UIControlStateNormal];
        }
        [self addSubview:button];
        [button addTarget:self action:@selector(ocj_paySwitch:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10 + (buttonWidth + itemWidth) * i);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(i == 2 ? 85: buttonWidth);
            make.height.mas_equalTo(buttonHeight);
        }];
    }
}


- (instancetype)initWithOnLinePayArray:(NSMutableArray *)title andIndex:(NSInteger)index{
    if (self = [super init]) {
        self.titleArray = title;
        self.currentIndex = index;
        [self ocj_setOnLineUI];
    }
    return self;
}

- (void)ocj_setOnLineUI{
    
//    CGFloat buttonWidth= (SCREEN_WIDTH -  40 - 20 - 14*(self.titleArray.count - 1)) / totalNum ;///< 每个字宽度
//    CGFloat space = 13;//按钮间距
    CGFloat buttonWidth = 80.0;///< 按钮宽度
    CGFloat space = (SCREEN_WIDTH - buttonWidth * self.titleArray.count  - 40 )/ (self.titleArray.count + 1);//按钮间距
    for (int i = 0; i < self.titleArray.count; i ++) {
      
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.titleArray[i]  forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        button.layer.borderWidth = 1;
        button.tag = i;
      
        UIImageView *ocjImgView = [[UIImageView alloc] init];
        [ocjImgView setImage:[UIImage imageNamed:@"icon_confirm"]];
        ocjImgView.tag = i + 10;
        [button addSubview:ocjImgView];
        [ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(button);
        make.width.height.mas_equalTo(@15);
      }];
      
        if (i == self.currentIndex) {
            ocjImgView.hidden = NO;
            self.ocjBtn_selected = button;
            button.layer.borderColor = [UIColor colorWSHHFromHexString:@"E5290D"].CGColor;
            [button setTitleColor: [UIColor colorWSHHFromHexString:@"E5290D"] forState:UIControlStateNormal];
        }else{
            ocjImgView.hidden = YES;
            button.layer.borderColor = [UIColor colorWSHHFromHexString:@"999999"].CGColor;
            [button setTitleColor: [UIColor colorWSHHFromHexString:@"999999"] forState:UIControlStateNormal];
        }
        [self addSubview:button];
        [button addTarget:self action:@selector(ocj_paySwitch:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.top.mas_equalTo(self.mas_top);
            make.width.mas_equalTo(buttonWidth);
            i == 0 ? make.left.mas_equalTo(space + (space  + buttonWidth) * i):make.left.mas_equalTo(self.previousButton.mas_right).offset(space);
        }];
        
        if (button.tag != self.titleArray.count - 1) {
            self.previousButton = button;
        }
    }
}


@end
