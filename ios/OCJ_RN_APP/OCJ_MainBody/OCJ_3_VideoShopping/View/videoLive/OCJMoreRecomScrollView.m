//
//  OCJMoreRecomScrollView.m
//  OCJ
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJMoreRecomScrollView.h"
#import "OCJMoreRecommendView.h"

@interface OCJMoreRecomScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *ocjScrollView;

@property (nonatomic, strong) OCJMoreRecommendView *lastView;
@property (nonatomic, strong) NSArray *ocjArr_tappedData;

@end

@implementation OCJMoreRecomScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self ocj_addViews];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)ocj_addViews {
    OCJBaseLabel *ocjLab_title = [[OCJBaseLabel alloc] init];
    ocjLab_title.text = @"· 更多推荐 ·";
    ocjLab_title.textColor = OCJ_COLOR_DARK;
    ocjLab_title.font = [UIFont systemFontOfSize:16];
    ocjLab_title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(@44);
        make.top.mas_equalTo(self);
    }];
    
    self.ocjScrollView = [[UIScrollView alloc] init];
    self.ocjScrollView.backgroundColor = OCJ_COLOR_BACKGROUND;
    self.ocjScrollView.userInteractionEnabled = YES;
    self.ocjScrollView.scrollEnabled = YES;
    self.ocjScrollView.showsHorizontalScrollIndicator = NO;
    self.ocjScrollView.delegate = self;
    [self addSubview:self.ocjScrollView];
    [self.ocjScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(ocjLab_title.mas_bottom).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(168);
    }];
}

//TODO:设置view的内容
- (void)setOcjArr_data:(NSArray *)ocjArr_data {
    self.ocjArr_tappedData = ocjArr_data;
    self.ocjScrollView.contentSize = CGSizeMake((90 + 15) * ocjArr_data.count + 15, 168);
    for (int i = 0; i < ocjArr_data.count; i++) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tappedView:)];
        
        OCJMoreRecommendView *view = [[OCJMoreRecommendView alloc] init];
        view.tag = i;
        [view addGestureRecognizer:tap];
        [self.ocjScrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.lastView) {
                make.left.mas_equalTo(self.lastView.mas_right).offset(15);
            }else {
                make.left.mas_equalTo(self.ocjScrollView.mas_left).offset(15);
            }
            make.top.mas_equalTo(self.ocjScrollView);
            make.height.mas_equalTo(@168);
            make.width.mas_equalTo(@90);
        }];
        self.lastView = view;
        
        OCJResponceModel_VideoDetailDesc *model = ocjArr_data[i];
        view.ocjLab_sellPrice.attributedText = [self ocj_changeStringColorWithString:[NSString stringWithFormat:@"￥%@", model.ocjStr_salePrice] andTitleFont:15];
        view.ocjLab_name.text = model.ocjStr_title;
        [view.ocjImgView ocj_setWebImageWithURLString:[NSString stringWithFormat:@"%@", model.ocjStr_firstImgUrl] completion:nil];
    }
  /*
    //查看更多
    if (self.ocjScrollView.contentSize.width >= SCREEN_WIDTH) {
        UIButton *ocjBtn_more = [[UIButton alloc] init];
        [ocjBtn_more addTarget:self action:@selector(ocj_clickedMoreBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.ocjScrollView addSubview:ocjBtn_more];
        [ocjBtn_more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.lastView.mas_right).offset(0);
            make.top.mas_equalTo(self.ocjScrollView);
            make.height.mas_equalTo(@90);
            make.width.mas_equalTo(@50);
        }];
        
        UILabel *ocjLab_more = [[UILabel alloc] init];
        ocjLab_more.text = @"查看更多";
        ocjLab_more.font = [UIFont systemFontOfSize:12];
        ocjLab_more.textColor = OCJ_COLOR_LIGHT_GRAY;
        ocjLab_more.numberOfLines = 0;
        [ocjBtn_more addSubview:ocjLab_more];
        [ocjLab_more mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(ocjBtn_more);
            make.centerX.mas_equalTo(ocjBtn_more);
            make.width.mas_equalTo(@14);
            make.height.mas_equalTo(70);
        }];
        
        self.ocjScrollView.contentSize = CGSizeMake((90 + 15) * ocjArr_data.count + 50, 140);
    }
   */
}

/**
 点击查看更多
 */
- (void)ocj_clickedMoreBtn {
    if (self.delegate) {
        [self.delegate ocj_seeMoreAction];
    }
}

- (void)ocj_tappedView:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    NSInteger index = view.tag;
    
    if (self.delegate) {
        [self.delegate ocj_tappedViewToGoodsDetail:self.ocjArr_tappedData[index]];
    }
}

/**
 改变字符串中特定字符字体大小
 */
- (NSMutableAttributedString *)ocj_changeStringColorWithString:(NSString *)oldStr andTitleFont:(NSInteger)font {
  NSMutableAttributedString *newStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
  for (int i = 0; i < oldStr.length; i++) {
    unichar c = [oldStr characterAtIndex:i];
    if ((c >= 48 && c <= 57)) {
      [newStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(i, 1)];
    }else {
      [newStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font-3] range:NSMakeRange(i, 1)];
    }
  }
  return newStr;
}

@end
