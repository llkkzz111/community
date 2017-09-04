//
//  OCJReComTVCell.m
//  OCJ
//
//  Created by OCJ on 2017/6/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJReComTVCell.h"


@interface OCJReComTVCell (){
    UIView *backView;
    UIImageView *ocjImageView_headIcon;
    OCJBaseLabel *ocjLab_title;
    OCJBaseButton *ocjBtn_gift;
    OCJBaseLabel *ocjLab_price;
    
    OCJBaseButton *ocjBtn_score;
}
@end

@implementation OCJReComTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self ocj_layoutSubviews];
    return self;
}

#pragma mark 头部视图
- (void)ocj_layoutSubviews{
    backView = [[UIView alloc] init];
    [self.contentView addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    // 头像 标题 详情
    ocjImageView_headIcon = [[UIImageView alloc]init];
    [backView addSubview:ocjImageView_headIcon];
    [ocjImageView_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(18.5*0.5);
        make.width.height.equalTo(@(120));
    }];
    ocjImageView_headIcon.backgroundColor = [UIColor redColor];
    
    ocjLab_title = [[OCJBaseLabel alloc]init];
    ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"#333333"];
    ocjLab_title.numberOfLines = 2;
    ocjLab_title.font = [UIFont systemFontOfSize:14];
    [backView addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ocjImageView_headIcon.mas_right).offset(10);
        make.top.equalTo(ocjImageView_headIcon);
        make.right.equalTo(backView).offset(-10);
    }];
    
    ocjBtn_gift = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [ocjBtn_gift setTitleColor:[UIColor colorWSHHFromHexString:@"#666666"] forState:UIControlStateNormal];
    ocjBtn_gift.titleLabel.font = [UIFont systemFontOfSize:12];
  
    ocjBtn_gift.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backView addSubview:ocjBtn_gift];
    [ocjBtn_gift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ocjImageView_headIcon.mas_right).offset(10);
        make.top.equalTo(ocjLab_title.mas_bottom).offset(5);
        make.right.equalTo(backView).offset(-10);
    }];
    
    ocjLab_price = [[OCJBaseLabel alloc] init];
    ocjLab_price.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    ocjLab_price.font = [UIFont boldSystemFontOfSize:15];
    [backView addSubview:ocjLab_price];
    [ocjLab_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ocjImageView_headIcon.mas_right).offset(10);
        make.bottom.equalTo(ocjImageView_headIcon.mas_bottom).offset(-13*0.5);
    }];
    
    
    ocjBtn_score = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
    [ocjBtn_score setTitleColor:[UIColor colorWSHHFromHexString:@"#FA6923"] forState:UIControlStateNormal];
    ocjBtn_score.titleLabel.font = [UIFont systemFontOfSize:13];
    [backView addSubview:ocjBtn_score];
    [ocjBtn_score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ocjLab_price.mas_right).offset(7);
        make.centerY.equalTo(ocjLab_price);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    [backView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWSHHFromHexString:@"#DDDDDD"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(backView).offset(-1);
        make.left.equalTo(ocjImageView_headIcon.mas_right);
    }];
}
- (void)setModel:(OCJRecommandModel *)model{
    _model = model;
    [ocjImageView_headIcon ocj_setWebImageWithURLString:model.ocjStr_url completion:nil];
    ocjLab_title.text = model.ocjStr_itemName;
    ocjLab_price.text = [NSString stringWithFormat:@"¥%@",model.ocjStr_price];
  
  
  //赠品信息，接口暂无赠品信息
    [ocjBtn_gift setTitle:nil forState:UIControlStateNormal];
//    [ocjBtn_gift setImage:[UIImage imageNamed:@"vip_gift"] forState:UIControlStateNormal];
  
    float score = [model.ocjStr_dc floatValue];
    if (score == 0) {
        [ocjBtn_score setImage:nil forState:UIControlStateNormal];
        [ocjBtn_score setTitle:@"" forState:UIControlStateNormal];
    }else{
        [ocjBtn_score setImage:[UIImage imageNamed:@"vip_score"] forState:UIControlStateNormal];
        [ocjBtn_score setTitle:[NSString stringWithFormat:@" %.2f",score] forState:UIControlStateNormal];
    }
  
  
  
}

@end
