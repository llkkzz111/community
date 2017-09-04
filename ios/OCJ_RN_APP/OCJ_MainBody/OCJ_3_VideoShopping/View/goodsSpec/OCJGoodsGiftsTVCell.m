//
//  OCJGoodsGiftsTVCell.m
//  OCJ
//
//  Created by Ray on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGoodsGiftsTVCell.h"

@interface OCJGoodsGiftsTVCell ()

@property (nonatomic, strong) UILabel *ocjLab_gift;///<赠品名称
@property (nonatomic, strong) UILabel *ocjLab_change;///<更换赠品
@property (nonatomic, strong) UILabel *ocjLab_giftNum;///<赠品数量

@end

@implementation OCJGoodsGiftsTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews {
    //更换赠品
    self.ocjLab_change = [[UILabel alloc] init];
    self.ocjLab_change.text = @"更换赠品";
    self.ocjLab_change.font = [UIFont systemFontOfSize:12];
    self.ocjLab_change.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_change.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.ocjLab_change];
    [self.ocjLab_change mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-38);
        make.centerY.mas_equalTo(self);
    }];
    //赠品名称
    self.ocjLab_gift = [[UILabel alloc] init];
    self.ocjLab_gift.font = [UIFont systemFontOfSize:14];
    self.ocjLab_gift.textColor = OCJ_COLOR_DARK;
    self.ocjLab_gift.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_gift];
    [self.ocjLab_gift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self);
    }];
    //赠品数量
    self.ocjLab_giftNum = [[UILabel alloc] init];
    self.ocjLab_giftNum.text = @"x1";
    self.ocjLab_giftNum.font = [UIFont systemFontOfSize:14];
    self.ocjLab_giftNum.textColor = OCJ_COLOR_DARK;
    self.ocjLab_giftNum.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_giftNum];
    [self.ocjLab_giftNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_gift.mas_right).offset(0);
        make.right.mas_equalTo(self.ocjLab_change.mas_left).offset(-13);
        make.width.mas_equalTo(@15);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)ocj_loadCellNameWithHasGetGift:(NSString *)hasGet name:(NSString *)name {
    if ([hasGet isEqualToString:@"YES"]) {
        self.ocjLab_change.text = @"更换赠品";
        self.ocjLab_giftNum.hidden = NO;
    }else {
        self.ocjLab_change.text = @"去领赠品";
        self.ocjLab_giftNum.hidden = YES;
    }
    self.ocjLab_gift.text = name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
