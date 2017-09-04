//
//  ActivityTableViewCell.m
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//

#import "ActivityTableViewCell.h"

#import <JZLiveSDK/JZLiveSDK.h>
#import "UIImageView+WebCache.h"
#import "JZTools.h"
@interface ActivityTableViewCell ()
@property (nonatomic, weak) UIImageView *headImage;
@property (nonatomic, weak) UILabel *name;
@property (nonatomic, weak) UILabel *hostTag;
@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) UILabel *TimeLabel;
@property (nonatomic, weak) UILabel *onlineNum;
@property (nonatomic, weak) UILabel *lookLabel;
@property (nonatomic, weak) UIImageView *hostBackimage;
@property (nonatomic, weak) UIImageView *liveImage;
@property (nonatomic, strong) NSString *activityType;
@end
@implementation ActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = MAINBACKGROUNDCOLOR;
        UIView *topView = [[UIView alloc] init];
        topView.layer.masksToBounds = YES;
        topView.layer.borderWidth=1;
        topView.layer.borderColor = RGB(234, 234, 234, 1).CGColor;
        topView.frame = CGRectMake(4.5, 10, SCREEN_WIDTH-9, 50);
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        
        UIView *imageView = [[UIView alloc] init];
        imageView.frame = CGRectMake(0, 0, 50, 50);
        imageView.backgroundColor = [UIColor clearColor];
        [topView addSubview:imageView];
        
        UIImageView *headImage = [[UIImageView alloc] init];
        headImage.frame = CGRectMake(8, 8, 34, 34);
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = 17;
        headImage.layer.borderWidth=1.0;
        headImage.layer.borderColor=[MAINCOLOR CGColor];
        [imageView addSubview:headImage];
        self.headImage = headImage;
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:FONTSIZE34];
        name.textColor = FONTGRAYCOLOR;
        name.textAlignment = NSTextAlignmentLeft;
        name.lineBreakMode = NSLineBreakByTruncatingTail;
        [topView addSubview:name];
        self.name = name;
        
        UILabel *hostTag = [[UILabel alloc] init];
        hostTag.textColor = MAINCOLOR;
        hostTag.font = [UIFont systemFontOfSize:FONTSIZE34];
        [topView addSubview:hostTag];
        self.hostTag = hostTag;
        
        UILabel *title = [[UILabel alloc] init];
        title.textColor = FONTBLOCKCOLOR;
        title.font = [UIFont systemFontOfSize:FONTSIZE34];
        title.textAlignment = NSTextAlignmentLeft;
        [topView addSubview:title];
        self.title = title;
        
        UILabel *TimeLabel = [[UILabel alloc] init];
        TimeLabel.backgroundColor = [UIColor clearColor];
        TimeLabel.textAlignment = NSTextAlignmentRight;
        TimeLabel.textColor = FONTGRAYCOLOR;
        TimeLabel.font = [UIFont systemFontOfSize:FONTSIZE2628];
        [topView addSubview:TimeLabel];
        self.TimeLabel = TimeLabel;
        
        UILabel *onlineNum = [[UILabel alloc] init];
        onlineNum.backgroundColor = [UIColor clearColor];
        onlineNum.font = [UIFont systemFontOfSize:FONTSIZE36];
        onlineNum.textColor = [UIColor redColor];
        onlineNum.textAlignment = NSTextAlignmentRight;
        [topView addSubview:onlineNum];
        self.onlineNum = onlineNum;
        
        UILabel *lookLabel = [[UILabel alloc] init];
        lookLabel.backgroundColor = MAINCOLOR;
        lookLabel.textColor = [UIColor whiteColor];
        lookLabel.font = [UIFont systemFontOfSize:10];
        lookLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:lookLabel];
        self.lookLabel = lookLabel;
        
        UIImageView *hostBackimage = [[UIImageView alloc] init];
        hostBackimage.clipsToBounds = YES;
        hostBackimage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:hostBackimage];
        self.hostBackimage = hostBackimage;
        
        UIImageView *liveImage = [[UIImageView alloc] init];
        liveImage.frame = CGRectMake(27, 0, 40, 30);
        liveImage.contentMode = UIViewContentModeScaleToFill;
        [hostBackimage addSubview:liveImage];
        self.liveImage = liveImage;
        
        UIButton *playBtn = [[UIButton alloc] init];
        playBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        playBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        playBtn.userInteractionEnabled = NO;
        [self addSubview:playBtn];
        self.playBtn = playBtn;
    }return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect size = [_activityType boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    self.hostTag.frame = CGRectMake(55, 5, size.size.width, 20);
    self.title.frame = CGRectMake(CGRectGetMaxX(self.hostTag.frame), 5, self.frame.size.width-10-145-size.size.width, 20);
    self.name.frame = CGRectMake(55, 25, self.frame.size.width-10 - 125, 20);
    self.TimeLabel.frame = CGRectMake(self.frame.size.width-10 - 75, 25, 74, 20);
    self.lookLabel.frame = CGRectMake(self.frame.size.width-10 - 35, 5+4, 30, 12);
    self.onlineNum.frame = CGRectMake(self.frame.size.width-10 - 90, 5, 50, 20);
    self.hostBackimage.frame = CGRectMake(5, 60, self.frame.size.width-10, (self.frame.size.width-10)*9/16);
    self.playBtn.frame = CGRectMake((self.frame.size.width-50)/2, 55+((self.frame.size.width-10)*9/16-50)/2, 50, 50);
}
- (void)setRecord:(JZLiveRecord *)record {
    if (_record != record) {
        _record = record;
    }
    NSString * pic1_url =[JZTools filterHttpImage:record.pic1];
    if ([pic1_url isEqualToString:EXPRESS_URL]) {
        [self.headImage setImage:[UIImage imageNamed:@"JZ_icon_defaultFace_116_116"]];
    }else{
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:pic1_url]];
    }
    self.name.text = record.nickname;
    NSString *activityType = [NSString stringWithFormat:@"|%@|",record.type];
    self.activityType = activityType;
    self.hostTag.text = activityType;
    self.title.text = record.title;
    
    NSString * pic2_url = [NSString stringWithFormat:@"%@%@",EXPRESS_URL,record.iconURL];
    if ([pic2_url isEqualToString:EXPRESS_URL]) {
        [self.hostBackimage setImage:[UIImage imageNamed:@"JZ_Icon_activityBackground@2x"]];
    }else{
        [self.hostBackimage sd_setImageWithURL:[NSURL URLWithString:pic2_url] placeholderImage:[UIImage imageNamed:@"JZ_Icon_activityBackground@2x"]];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:record.planStartTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    self.TimeLabel.text = destDateString;
    self.lookLabel.text = @"在看";
    if (record.publish == 1) {
        [self.liveImage setImage:[UIImage imageNamed:@"JZ_Icon_live@2x"]];
        if (record.headTime >= 100000000) {
            self.onlineNum.text = [NSString stringWithFormat:@"%.1f亿", (float)(record.headTime)/100000000];
        }else if ((100000000 >= record.headTime)&&(record.headTime >=1000000)) {
            self.onlineNum.text = [NSString stringWithFormat:@"%lu万", (long)(record.headTime/10000)];
        }else if ((1000000 >= record.headTime)&&(record.headTime >=100000)) {
            self.onlineNum.text = [NSString stringWithFormat:@"%.1f万", (float)(record.headTime)/10000];
        }else if ((100000 >= record.headTime)&&(record.headTime >=10000)) {
            self.onlineNum.text = [NSString stringWithFormat:@"%.2f万", (float)(record.headTime)/10000];
        } else {
            self.onlineNum.text = [NSString stringWithFormat:@"%lu", (long)record.headTime];
        }
    }else{
        [self.liveImage setImage:[UIImage imageNamed:@"JZ_Icon_playback@2x"]];
        if (record.headTime >= 100000000) {
            self.onlineNum.text = [NSString stringWithFormat:@"%.1f亿", (float)(record.headTime)/100000000];
        }else if ((100000000 >= record.headTime)&&(record.headTime >=1000000)) {
            self.onlineNum.text = [NSString stringWithFormat:@"%lu万", (long)(record.headTime/10000)];
        }else if ((1000000 >= record.headTime)&&(record.headTime >=100000)) {
            self.onlineNum.text = [NSString stringWithFormat:@"%.1f万", (float)(record.headTime)/10000];
        }else if ((100000 >= record.headTime)&&(record.headTime >=10000)) {
            self.onlineNum.text = [NSString stringWithFormat:@"%.2f万", (float)(record.headTime)/10000];
        } else {
            self.onlineNum.text = [NSString stringWithFormat:@"%lu", (long)record.headTime];
        }
    }
    [_playBtn setImage:[UIImage imageNamed:@"JZ_Btn_play@2x"] forState:UIControlStateNormal];
}


@end
