
//
//  JZAdvertisementSelectView.m
//  JZLiveDemo
//
//  Created by wangcliff on 2017/5/10.
//  Copyright © 2017年 jz. All rights reserved.
//  商品展示view

#import "JZAdvertisementSelectView.h"
#import <JZLiveSDK/JZLiveSDK.h>
#import <JZLiveSDK/JZProduct.h>//产品model

@interface JZAdvertisementSelectView ()
@property (nonatomic, weak) UIView *advertisementSelectView;
@property (nonatomic, weak) UILabel *yieldsLabel;
@property (nonatomic, weak) UILabel *achievementLabel;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *formLabel;
@property (nonatomic, weak) UIButton *buyProductBtn;
@property (nonatomic, strong) JZProduct *product;
@end

@implementation JZAdvertisementSelectView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *coverView = [[UIButton alloc] init];
        coverView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        coverView.backgroundColor = background01GRAY;
        [coverView addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coverView];
        
        UIView *advertisementSelectView = [[UIView alloc] init];
        advertisementSelectView.backgroundColor = tableViewBackColor;
        advertisementSelectView.layer.cornerRadius = 3;
        advertisementSelectView.clipsToBounds = YES;
        [self addSubview:advertisementSelectView];
        self.advertisementSelectView = advertisementSelectView;
        
        UILabel *yieldsLabel = [[UILabel alloc] init];
        //yieldsLabel.text = @"8.00%";
        yieldsLabel.textColor = [UIColor redColor];
        yieldsLabel.textAlignment = NSTextAlignmentLeft;
        yieldsLabel.font = [UIFont systemFontOfSize:15];
        [advertisementSelectView addSubview:yieldsLabel];
        self.yieldsLabel = yieldsLabel;
        
        UILabel *achievementLabel = [[UILabel alloc] init];
        achievementLabel.text = @"业绩基准";
        achievementLabel.textColor = [UIColor grayColor];
        achievementLabel.textAlignment = NSTextAlignmentLeft;
        achievementLabel.font = [UIFont systemFontOfSize:15];
        [advertisementSelectView addSubview:achievementLabel];
        self.achievementLabel = achievementLabel;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"聚安稳系列2号";
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:18];
        [advertisementSelectView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"30天|低风险";
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.font = [UIFont systemFontOfSize:15];
        [advertisementSelectView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UILabel *formLabel = [[UILabel alloc] init];
        formLabel.text = @"定期";
        formLabel.textColor = MAINCOLOR;
        formLabel.textAlignment = NSTextAlignmentLeft;
        formLabel.font = [UIFont systemFontOfSize:13];
        formLabel.layer.cornerRadius = 10;
        formLabel.clipsToBounds = YES;
        formLabel.layer.borderColor = [MAINCOLOR CGColor];
        formLabel.layer.borderWidth = 1;
        formLabel.textAlignment = NSTextAlignmentCenter;
        [advertisementSelectView addSubview:formLabel];
        self.formLabel = formLabel;
        
        NSString *buyProductString = @"立即购买(1元起投)";
        NSArray *subArray = [buyProductString componentsSeparatedByString:@"("];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:buyProductString];
        UIButton *buyProductBtn = [[UIButton alloc] init];
        buyProductBtn.backgroundColor = [UIColor redColor];
        [buyProductBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        buyProductBtn.clipsToBounds = YES;
        buyProductBtn.layer.cornerRadius = 3;
        [buyProductBtn.titleLabel setTextColor:[UIColor whiteColor]];
        //[buyProductBtn setTitle:@"立即购买(1元起投)" forState:UIControlStateNormal];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(0, ((NSString *)subArray[0]).length)];
        [buyProductBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
        [buyProductBtn addTarget:self action:@selector(buyProduct:) forControlEvents:UIControlEventTouchUpInside];
        [advertisementSelectView addSubview:buyProductBtn];
        self.buyProductBtn = buyProductBtn;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    JZProduct *product = self.goodsArray[0];
    self.product = product;
    NSString *yieldsString = product.finPercentage;
    NSArray *subArray = [yieldsString componentsSeparatedByString:@"%"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:yieldsString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25.0] range:NSMakeRange(0, ((NSString *)subArray[0]).length)];
    self.yieldsLabel.attributedText = attributedString;
    self.nameLabel.text = product.productName;
    self.timeLabel.text = [NSString stringWithFormat:@"%@|%@",product.finValidPeriod,product.finChallenge];
    CGRect timeLabelSize = [self.timeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    if (SCREEN_WIDTH>SCREEN_HEIGHT) {//横屏
        self.advertisementSelectView.frame = CGRectMake(0, SCREEN_HEIGHT-60*RATIOLH, SCREEN_WIDTH, 60*RATIOLH);
        self.yieldsLabel.frame = CGRectMake(30*RATIOLW, 5*RATIOLH, 100*RATIOLW, 25*RATIOLH);
        self.achievementLabel.frame = CGRectMake(CGRectGetMinX(self.yieldsLabel.frame), CGRectGetMaxY(self.yieldsLabel.frame), 100*RATIOLW, 20*RATIOLH);
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.yieldsLabel.frame), 5*RATIOLH, SCREEN_WIDTH-(30+100+210)*RATIOLW, 25*RATIOLH);
        self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.yieldsLabel.frame), CGRectGetMaxY(self.nameLabel.frame), timeLabelSize.size.width+5*RATIOLW, 20*RATIOLH);
        self.formLabel.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+10*RATIOLW, CGRectGetMaxY(self.nameLabel.frame), 50*RATIOLW, 20*RATIOLH);
        self.buyProductBtn.frame = CGRectMake(SCREEN_WIDTH-210*RATIOLW, 10*RATIOLH, 200*RATIOLW, 40*RATIOLH);
    }else {//竖屏
        self.advertisementSelectView.frame = CGRectMake(0, SCREEN_HEIGHT-110*RATIOH, SCREEN_WIDTH, 115*RATIOH);
        self.yieldsLabel.frame = CGRectMake(30*RATIOW, 10*RATIOH, 100*RATIOW, 25*RATIOH);
        self.achievementLabel.frame = CGRectMake(CGRectGetMinX(self.yieldsLabel.frame), CGRectGetMaxY(self.yieldsLabel.frame), 100*RATIOW, 20*RATIOH);
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.yieldsLabel.frame), 10*RATIOH, SCREEN_WIDTH-(30+100)*RATIOW, 25*RATIOH);
        self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.yieldsLabel.frame), CGRectGetMaxY(self.nameLabel.frame), timeLabelSize.size.width+5*RATIOW, 20*RATIOH);
        self.formLabel.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+10*RATIOW, CGRectGetMaxY(self.nameLabel.frame), 50*RATIOW, 20*RATIOH);
        self.buyProductBtn.frame = CGRectMake(10*RATIOW, 65*RATIOH, SCREEN_WIDTH-20*RATIOW, 40*RATIOH);
    }
    
}
//移除view
- (void)removeSelf {
    [self removeFromSuperview];
}
- (void)buyProduct:(UIButton *)button {
    //NSString *urlString = @"https://nodejs.org/en/docs/";
    NSString *urlString = self.product.productURL;
    [_delegate openAdvertisementWebView:urlString];
    [self removeSelf];
}
@end
