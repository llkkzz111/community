//
//  OCJVipAreaCell3.m
//  OCJ
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJVipAreaCell3.h"

@interface OCJVipAreaCell3 (){
    UIView *backView;
    UIImageView *ocjImageView_headIcon;
    OCJBaseLabel *ocjLab_title;
    UILabel *ocjLab_gift;
    OCJBaseLabel *ocjLab_price;
    
    OCJBaseButton *ocjBtn_score;
    UIView* ocjView_line;
  
  OCJBaseLabel *ocjLab_sellPrice;
  UIView *ocjView_sellLine;
}

@end

@implementation OCJVipAreaCell3

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ocj_setSubView];
        [self ocj_layoutSubviews];
    }
    return self;
}

#pragma mark 头部视图
-(void)ocj_setSubView{
  backView = [[UIView alloc] init];
  [self.contentView addSubview:backView];
  backView.backgroundColor = [UIColor whiteColor];
  
  // 头像 标题 详情
  ocjImageView_headIcon = [[UIImageView alloc]init];
  ocjImageView_headIcon.backgroundColor = [UIColor colorWSHHFromHexString:@"#ededed"];
  [backView addSubview:ocjImageView_headIcon];
  
  ocjLab_title = [[OCJBaseLabel alloc]init];
  ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"#333333"];
  ocjLab_title.numberOfLines = 2;
  ocjLab_title.font = [UIFont systemFontOfSize:14];
  [backView addSubview:ocjLab_title];
  
  ocjLab_gift = [[UILabel alloc]init];
  ocjLab_gift.textColor = [UIColor colorWSHHFromHexString:@"#666666"];
  ocjLab_gift.font = [UIFont systemFontOfSize:12];
  ocjLab_gift.numberOfLines = 1;
  [backView addSubview:ocjLab_gift];
  
  ocjLab_price = [[OCJBaseLabel alloc] init];
  ocjLab_price.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
  ocjLab_price.font = [UIFont boldSystemFontOfSize:15];
  ocjLab_price.textAlignment = NSTextAlignmentLeft;
  [backView addSubview:ocjLab_price];
  
  ocjBtn_score = [OCJBaseButton buttonWithType:UIButtonTypeCustom];
  [ocjBtn_score setTitleColor:[UIColor colorWSHHFromHexString:@"#FA6923"] forState:UIControlStateNormal];
  ocjBtn_score.titleLabel.font = [UIFont systemFontOfSize:13];
  [backView addSubview:ocjBtn_score];
  
  ocjView_line = [[UIView alloc] init];
  ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"#DDDDDD"];
  [backView addSubview:ocjView_line];
  
  ocjLab_sellPrice = [[OCJBaseLabel alloc] init];
  ocjLab_sellPrice.textColor = OCJ_COLOR_DARK_GRAY;
  ocjLab_sellPrice.font = [UIFont systemFontOfSize:14];
  ocjLab_sellPrice.textAlignment = NSTextAlignmentLeft;
  [backView addSubview:ocjLab_sellPrice];
  
  ocjView_sellLine = [[UIView alloc] init];
  ocjView_sellLine.backgroundColor = OCJ_COLOR_DARK;
  [backView addSubview:ocjView_sellLine];
}

- (void)ocj_layoutSubviews{
  
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
  
    [ocjImageView_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(18.5*0.5);
        make.width.height.equalTo(@(120));
    }];
  
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ocjImageView_headIcon.mas_right).offset(10);
        make.top.equalTo(ocjImageView_headIcon);
        make.right.equalTo(backView).offset(-10);
    }];
  
    [ocjLab_gift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ocjImageView_headIcon.mas_right).offset(10);
        make.top.equalTo(ocjLab_title.mas_bottom);
        make.right.equalTo(backView).offset(-10);
        make.height.equalTo(@20);
    }];
  
    [ocjLab_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ocjImageView_headIcon.mas_right).offset(10);
        make.bottom.equalTo(ocjImageView_headIcon.mas_bottom).offset(-13*0.5);
    }];
  
    [ocjBtn_score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ocjLab_price.mas_right).offset(7);
        make.centerY.equalTo(ocjLab_price);
    }];
  
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(backView).offset(-1);
        make.left.equalTo(ocjImageView_headIcon.mas_right);
    }];
  
  [ocjLab_sellPrice mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(ocjLab_price);
    make.left.mas_equalTo(ocjBtn_score.mas_right).offset(10);
    make.right.mas_lessThanOrEqualTo(backView.mas_right).offset(-10);
  }];
  
  [ocjView_sellLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.mas_equalTo(ocjLab_sellPrice);
    make.centerY.mas_equalTo(ocjLab_sellPrice);
    make.height.mas_equalTo(@1);
  }];
}

- (void)setOcjModel_choicenessItem:(OCJVIPModel_VIPChoicenessItem *)ocjModel_choicenessItem{
    _ocjModel_choicenessItem = ocjModel_choicenessItem;
    
    [ocjImageView_headIcon ocj_setWebImageWithURLString:ocjModel_choicenessItem.ocjStr_imageUrl completion:nil];
  
    if (ocjModel_choicenessItem.ocjStr_content_nm.length>0) {
      
      ocjLab_title.attributedText = [self ocj_titleCreatImageAndTextStr:@"" andAfterText:ocjModel_choicenessItem.ocjStr_title ImageIcon:[UIImage imageNamed:@"img_recommond"]];
    }else{
      ocjLab_title.text = ocjModel_choicenessItem.ocjStr_title;
    }
  
    if (ocjModel_choicenessItem.ocjStr_giftName.length>0) {
        ocjLab_gift.attributedText = [self ocj_giftCreatImageAndTextStr:@"" andAfterText:ocjModel_choicenessItem.ocjStr_giftName ImageIcon:[UIImage imageNamed:@"vip_gift"]];
    }else{
        ocjLab_gift.text = @"";
    }
  
    ocjLab_price.text = [NSString stringWithFormat:@"¥%@",ocjModel_choicenessItem.ocjStr_price];
    if ([ocjModel_choicenessItem.ocjStr_sellPrice length] > 0 && [ocjModel_choicenessItem.ocjStr_sellPrice floatValue] != 0) {
      ocjLab_sellPrice.text = ocjModel_choicenessItem.ocjStr_sellPrice;
      ocjLab_sellPrice.hidden = NO;
      ocjView_sellLine.hidden = NO;
    }else {
      ocjLab_sellPrice.hidden = YES;
      ocjView_sellLine.hidden = YES;
    }
    
    float score = [ocjModel_choicenessItem.ocjStr_score floatValue];
    if (score == 0) {
        [ocjBtn_score setImage:nil forState:UIControlStateNormal];
        [ocjBtn_score setTitle:@"" forState:UIControlStateNormal];
      [ocjLab_sellPrice mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjLab_price.mas_right).offset(10);
      }];
    }else{
        [ocjBtn_score setImage:[UIImage imageNamed:@"vip_score"] forState:UIControlStateNormal];
        [ocjBtn_score setTitle:[NSString stringWithFormat:@" %.2f",score] forState:UIControlStateNormal];
      [ocjLab_sellPrice mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjBtn_score.mas_right).offset(10);
      }];
    }
    
}


//富文本编辑
-(NSAttributedString *)ocj_titleCreatImageAndTextStr:(NSString *)agoText andAfterText:(NSString *)AfterText ImageIcon:(UIImage *)image;
{
  NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:agoText];
  
  NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
  attachment.image = image;
  attachment.bounds = CGRectMake(0, -2, 55, 13);
  
  NSAttributedString *attribStr = [NSAttributedString attributedStringWithAttachment:attachment];
  [strM appendAttributedString:attribStr];
  
  [strM appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",AfterText]]];
  
  return strM;
}

-(NSAttributedString *)ocj_giftCreatImageAndTextStr:(NSString *)agoText andAfterText:(NSString *)AfterText ImageIcon:(UIImage *)image;
{
  NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:agoText];
  
  NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
  attachment.image = image;
  attachment.bounds = CGRectMake(0, -3, 28, 15);
  
  NSAttributedString *attribStr = [NSAttributedString attributedStringWithAttachment:attachment];
  [strM appendAttributedString:attribStr];
  
  [strM appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",AfterText]]];
  
  return strM;
}

@end
