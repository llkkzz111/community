//
//  AwardListView.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "AwardListView.h"


@interface AwardListView ()
@property (nonatomic, weak) UIView *awardListView;
@property (nonatomic, weak) UILabel *contentLabel;
@end

@implementation AwardListView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *awardListCoverBtn = [[UIButton alloc] init];
        awardListCoverBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        awardListCoverBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        UITapGestureRecognizer* clickBtn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewBtn)];
        [awardListCoverBtn addGestureRecognizer:clickBtn];
        [self addSubview:awardListCoverBtn];
        
        UIView *awardListView = [[UIView alloc] init];
        awardListView.frame = CGRectMake((SCREEN_WIDTH-SCREEN_HEIGHT)/2, 0, SCREEN_HEIGHT, SCREEN_HEIGHT);
        awardListView.backgroundColor = [UIColor whiteColor];
        awardListView.layer.cornerRadius = 10;
        awardListView.clipsToBounds = YES;
        [self addSubview:awardListView];
        self.awardListView = awardListView;
        
        UIButton *backBtn = [[UIButton alloc] init];
        backBtn.frame = CGRectMake(20, 20, 30, 30);
        [backBtn setImage:[UIImage imageNamed:@"JZ_Btn_close"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backViewBtn) forControlEvents:UIControlEventTouchUpInside];
        [awardListView addSubview:backBtn];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, SCREEN_HEIGHT, 100);
        contentLabel.text = @"打赏榜";
        contentLabel.font = [UIFont systemFontOfSize:FONTSIZE38];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        [awardListView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isVertical) {//竖屏显示frame
        self.awardListView.frame = CGRectMake(30, (self.frame.size.height-self.frame.size.width)/2, self.frame.size.width-60, self.frame.size.width);
        self.contentLabel.frame = CGRectMake(0, self.frame.size.width/2-50, self.frame.size.width-60, 100);
    }
}

//返回
-(void)backViewBtn{
    [self removeFromSuperview];
}
@end
