//
//  OCJBannerTableViewCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBannerTableViewCell.h"
#import "WSHHBannerView.h"


@interface OCJBannerTableViewCell()
@property (nonatomic,strong) WSHHBannerView            *ocjBanner;
@property (nonatomic,strong) NSArray<OCJGSModel_Package2*>* ocjArr_banners;
@end

@implementation OCJBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)dealloc
{
    [self.ocjBanner ocj_stopTimer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWSHHFromHexString:@"#EDEDED"];
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_setBannerArray:(NSArray *)array
{
    self.ocjArr_banners = array;
    NSMutableArray* mArray = [NSMutableArray array];
    for (OCJGSModel_Package2* model in array) {
        [mArray addObject:model.ocjStr_imageUrl];
    }
  
    self.ocjBanner.wshhArr_image = [mArray copy];
}

- (void)ocj_addViews
{
    [self addSubview:self.ocjBanner];
    [self.ocjBanner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
}

- (WSHHBannerView *)ocjBanner
{
    if (!_ocjBanner) {
        _ocjBanner = [[WSHHBannerView alloc] initWSHHWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*150/375 -5) andScrollDuration:4.0];
        [_ocjBanner setBackgroundColor:[UIColor clearColor]];
        __weak OCJBannerTableViewCell* weakSelf = self;
        _ocjBanner.wshhBlock_clickedImage = ^(NSInteger currIndex) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(ocj_golbalHeadBannerPressed:)]) {
                [weakSelf.delegate ocj_golbalHeadBannerPressed:weakSelf.ocjArr_banners[currIndex]];
            }
        };
    }
    return _ocjBanner;
}

@end
