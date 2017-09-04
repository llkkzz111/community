//
//  OCJEvaluateStarsTVCell.m
//  OCJ
//
//  Created by Ray on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJEvaluateStarsTVCell.h"

#define ImageViewHeight 20
#define View_width 140

@interface OCJEvaluateStarsTVCell ()

@property (nonatomic, strong) UIView *ocjView_bg;///<
@property (nonatomic, strong) UIImageView *ocjImgView_normal;///<灰色星星图
@property (nonatomic, strong) UIImageView *ocjImgView_highLighted;///<高亮星星图

@end

@implementation OCJEvaluateStarsTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews {
    //title
    self.ocjLab_title = [[OCJBaseLabel alloc] init];
    self.ocjLab_title.font = [UIFont systemFontOfSize:13];
    self.ocjLab_title.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.bottom.mas_equalTo(self);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_tappedStars:)];
    //
    self.ocjView_bg = [[UIView alloc] init];
    self.ocjView_bg.backgroundColor = OCJ_COLOR_BACKGROUND;
    [self.ocjView_bg addGestureRecognizer:tap];
    [self addSubview:self.ocjView_bg];
    [self.ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_title.mas_right).offset(8);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(View_width);
        make.height.mas_equalTo(@40);
    }];
    //普通图
    self.ocjImgView_normal = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, View_width, ImageViewHeight)];
    [self.ocjImgView_normal setImage:[UIImage imageNamed:@"icon_startfive_thin_"]];
    self.ocjImgView_normal.contentMode = UIViewContentModeLeft;
    [self.ocjView_bg addSubview:self.ocjImgView_normal];
    //高亮图
    self.ocjImgView_highLighted = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, View_width, ImageViewHeight)];
    self.ocjImgView_highLighted.contentMode = UIViewContentModeLeft;
    [self.ocjImgView_highLighted setImage:[UIImage imageNamed:@"icon_startfive_"]];
    [self.ocjView_bg addSubview:self.ocjImgView_highLighted];
    
    //很好
    self.ocjLab_evaluate = [[OCJBaseLabel alloc] init];
    self.ocjLab_evaluate.text = @"很好";
    self.ocjLab_evaluate.font = [UIFont systemFontOfSize:13];
    self.ocjLab_evaluate.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_evaluate.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.ocjLab_evaluate];
    [self.ocjLab_evaluate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.bottom.mas_equalTo(self);
    }];
    //line
    self.ocjView_line = [[UIView alloc] init];
    self.ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self addSubview:self.ocjView_line];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.mas_equalTo(@0.5);
    }];
    self.ocjView_line.hidden = YES;
}

- (void)ocj_setHighlightedImagePlace:(NSInteger)rate {
  self.ocjImgView_highLighted.frame = CGRectMake(0, 10, rate * (View_width / 5.0), ImageViewHeight);
}

/**
 点击星星图
 */
- (void)ocj_tappedStars:(UITapGestureRecognizer *)tap {
    UIView *ocjView = tap.view;
    CGPoint point = [tap locationInView:ocjView];
    self.ocjImgView_highLighted.contentMode = UIViewContentModeLeft;
    self.ocjImgView_highLighted.clipsToBounds = YES;
    [self ocj_setHighlightedImageFrameWithPoint:point];
}

/**
 设置星星高亮图的正确位置
 */
- (void)ocj_setHighlightedImageFrameWithPoint:(CGPoint)point {
    NSInteger rate = point.x / (View_width / 5.0);
    if (rate * (View_width / 5.0) < point.x) {
        [self ocj_setEvaluateLabelTitleWithRate:rate + 1];
        if (rate >= 5) {
            self.ocjImgView_highLighted.frame = CGRectMake(0, 10, View_width, ImageViewHeight);
        }else {
            self.ocjImgView_highLighted.frame = CGRectMake(0, 10, (rate + 1) * (View_width / 5.0), ImageViewHeight);
        }
    }else {
        if (rate <= 0) {
            [self ocj_setEvaluateLabelTitleWithRate:1];
            self.ocjImgView_highLighted.frame = CGRectMake(0, 10, View_width / 5.0, ImageViewHeight);
        }else {
            [self ocj_setEvaluateLabelTitleWithRate:rate];
            self.ocjImgView_highLighted.frame = CGRectMake(0, 10, rate * (View_width / 5.0), ImageViewHeight);
        }
    }
}

/**
 设置对应评价等级
 */
- (void)ocj_setEvaluateLabelTitleWithRate:(NSInteger)rate {
    if (rate == 2) {
        self.ocjLab_evaluate.text = @"不好";
    }else if (rate == 3) {
        self.ocjLab_evaluate.text = @"一般";
    }else if (rate == 4) {
        self.ocjLab_evaluate.text = @"好";
    }else if (rate == 1) {
        self.ocjLab_evaluate.text = @"差";
    }else {
        self.ocjLab_evaluate.text = @"很好";
    }
    if (self.delegate) {
        [self.delegate ocj_getEvaluateStarLevelWithCell:self andLevel:rate];
    }
}

#pragma mark - UITouch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    OCJLog(@"111");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.ocjView_bg];
    self.ocjImgView_highLighted.contentMode = UIViewContentModeLeft;
    self.ocjImgView_highLighted.clipsToBounds = YES;
    [self ocj_setHighlightedImageFrameWithPoint:point];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    OCJLog(@"333");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    OCJLog(@"444");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
