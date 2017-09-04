//
//  OCJOrderListScrollView.m
//  OCJ
//
//  Created by OCJ on 2017/5/22.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJOrderListScrollView.h"
#import "OCJOrderView.h"

@interface OCJOrderListScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *ocjScrollView;
@property (nonatomic, strong) OCJOrderView *lastView;
@end

@implementation OCJOrderListScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews {
 
    self.ocjScrollView = [[UIScrollView alloc] init];
    self.ocjScrollView.userInteractionEnabled = YES;
    self.ocjScrollView.scrollEnabled = YES;
    self.ocjScrollView.showsHorizontalScrollIndicator = NO;
    self.ocjScrollView.delegate = self;
    [self addSubview:self.ocjScrollView];
    [self.ocjScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.right.mas_equalTo(self);
    }];
}

- (void)setOcjArr_data:(NSArray *)ocjArr_data {
  for (UIView *view in self.ocjScrollView.subviews) {
    [view removeFromSuperview];
  }
    self.lastView = nil;
    
    self.ocjScrollView.contentSize = CGSizeMake((60 + 15)* ocjArr_data.count + 15, 60);
    for (int i = 0; i < ocjArr_data.count; i++) {
        NSString * ocjStr_imgUrl = ocjArr_data[i];
        OCJOrderView *view = [[OCJOrderView alloc] init];
        [self.ocjScrollView addSubview:view];
        [view ocj_setImgWithUrl:ocjStr_imgUrl];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.lastView) {
                make.left.mas_equalTo(self.lastView.mas_right).offset(15);
            }else {
                make.left.mas_equalTo(self.ocjScrollView.mas_left).offset(15);
            }
            make.top.mas_equalTo(self.ocjScrollView);
            make.height.mas_equalTo(self.ocjScrollView);
            make.width.mas_equalTo(60);
        }];
        self.lastView = view;
    }
}

@end
