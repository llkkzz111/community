//
//  OCJAppointmentGoodsTVCell.m
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "OCJAppointmentGoodsTVCell.h"

@interface OCJAppointmentGoodsTVCell ()

@property (nonatomic, strong) UILabel *ocjLab_name;       ///<商品名称
@property (nonatomic, strong) UIImageView *ocjImgView;    ///<预览图
@property (nonatomic, strong) UILabel *ocjLab_num;        ///<商品数量
@property (nonatomic, strong) UILabel *ocjLab_price;      ///<价格
@property (nonatomic, strong) UIImageView *ocjImgView_recommend;  ///<推荐

@property (nonatomic, strong) UIView *ocjView_gift;       ///<赠品

@end

@implementation OCJAppointmentGoodsTVCell

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
  //预览图
  self.ocjImgView = [[UIImageView alloc] init];
  self.ocjImgView.backgroundColor = [UIColor redColor];
  [self addSubview:self.ocjImgView];
  [self.ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left).offset(15);
    make.top.mas_equalTo(self.mas_top).offset(18);
    make.width.height.mas_equalTo(@90);
  }];
  //商品名称
  self.ocjLab_name = [[UILabel alloc] init];
  self.ocjLab_name.text = @"同方终身重大疾病保险计划三万元保额/月缴 缴费期限：20年";
  self.ocjLab_name.font = [UIFont systemFontOfSize:14];
  self.ocjLab_name.textColor = OCJ_COLOR_DARK;
  self.ocjLab_name.numberOfLines = 2;
  self.ocjLab_name.textAlignment = NSTextAlignmentLeft;
  [self addSubview:self.ocjLab_name];
  [self.ocjLab_name mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjImgView.mas_right).offset(10);
    make.right.mas_equalTo(self.mas_right).offset(-15);
    make.top.mas_equalTo(self.ocjImgView);
  }];
  //数量
  self.ocjLab_num = [[UILabel alloc] init];
  self.ocjLab_num.text = @"x1";
  self.ocjLab_num.font = [UIFont systemFontOfSize:13];
  self.ocjLab_num.textColor = OCJ_COLOR_DARK;
  self.ocjLab_num.textAlignment = NSTextAlignmentRight;
  [self addSubview:self.ocjLab_num];
  [self.ocjLab_num mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.mas_right).offset(-15);
    make.top.mas_equalTo(self.ocjLab_name.mas_bottom).offset(5);
  }];
  //价格
  self.ocjLab_price = [[UILabel alloc] init];
  self.ocjLab_price.text = @"￥20";
  self.ocjLab_price.font = [UIFont systemFontOfSize:15];
  self.ocjLab_price.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
  self.ocjLab_price.textAlignment = NSTextAlignmentLeft;
  [self addSubview:self.ocjLab_price];
  [self.ocjLab_price mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_name);
    make.bottom.mas_equalTo(self.ocjImgView);
  }];
  //主播推荐
  self.ocjImgView_recommend = [[UIImageView alloc] init];
  [self.ocjImgView_recommend setImage:[UIImage imageNamed:@"img_recommond"]];
  [self addSubview:self.ocjImgView_recommend];
  [self.ocjImgView_recommend mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_name);
    make.top.mas_equalTo(self.ocjImgView.mas_top).offset(2);
    make.width.mas_equalTo(@55);
    make.height.mas_equalTo(@13);
  }];
}

- (void)ocj_loadDataWithDictionary:(OCJResponceModel_orderDetail *)model giftViewHeight:(NSInteger)viewHeight {
  
  OCJResponceModel_GoodsDetail *goodsModel = model.ocjModel_goods;
  
  [self bringSubviewToFront:self.ocjImgView_recommend];
  [self ocj_addGiftViewsWithArray:model height:viewHeight];
  if ([goodsModel.ocjStr_isRecommend isEqualToString:@""]) {
    self.ocjLab_name.text = [NSString stringWithFormat:@"                %@", goodsModel.ocjStr_name];
  }else {
    self.ocjLab_name.text = goodsModel.ocjStr_name;
  }

  self.ocjLab_num.text = [NSString stringWithFormat:@"x%@", goodsModel.ocjStr_count];
  self.ocjLab_price.text = [NSString stringWithFormat:@"￥%@", goodsModel.ocjStr_sellPrice];
  [self.ocjImgView ocj_setWebImageWithURLString:goodsModel.ocjStr_imageUrl completion:nil];
}

- (void)ocj_addGiftViewsWithArray:(OCJResponceModel_orderDetail *)model height:(CGFloat)viewHeight {
  NSArray *tempArr = model.ocjArr_gift;
  NSArray *tempArr2 = model.ocjModel_goods.ocjArr_sxGifts;
  if (tempArr.count > 0 || tempArr2.count > 0) {
    self.ocjView_gift = [[UIView alloc] init];
    self.ocjView_gift.backgroundColor = OCJ_COLOR_BACKGROUND;
    [self addSubview:self.ocjView_gift];
    [self.ocjView_gift mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.ocjImgView);
      make.top.mas_equalTo(self.ocjImgView.mas_bottom).offset(0);
      make.right.mas_equalTo(self.mas_right).offset(-15);
      make.height.mas_equalTo(viewHeight);
    }];
    //背景图(部分拉伸图片)
    UIImage *image = [UIImage imageNamed:@"icon_giftbg_"];
    NSInteger leftCapWidth = image.size.width * 0.5;
    NSInteger topCapHeight = image.size.height * 0.5;
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    UIImageView *ocjImgView = [[UIImageView alloc] init];
    [ocjImgView setImage:newImage];
    [self.ocjView_gift addSubview:ocjImgView];
    [ocjImgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.right.bottom.mas_equalTo(self.ocjView_gift);
    }];
    
    UILabel *ocjLab_last;
    NSArray *tempArr3;
    if (tempArr2.count > 0) {
      NSString *ocjStr_sxGift = [model.ocjModel_goods.ocjArr_sxGifts objectAtIndex:0];
      tempArr3 = [ocjStr_sxGift componentsSeparatedByString:@"\r\n"];
      
      for (int i = 0; i < tempArr3.count; i++) {
        NSString *ocjStr_sxGift = [tempArr3 objectAtIndex:i];
        UILabel *ocjLab_gift = [[UILabel alloc] init];
        ocjLab_gift.text = [NSString stringWithFormat:@"%@", ocjStr_sxGift];
        ocjLab_gift.font = [UIFont systemFontOfSize:12];
        ocjLab_gift.textColor = OCJ_COLOR_DARK_GRAY;
        ocjLab_gift.textAlignment = NSTextAlignmentLeft;
        [self.ocjView_gift addSubview:ocjLab_gift];
        [ocjLab_gift mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(self.ocjView_gift.mas_left).offset(5);
          if (!ocjLab_last) {
            make.top.mas_equalTo(self.ocjView_gift.mas_top).offset(15);
          }else {
            make.top.mas_equalTo(ocjLab_last.mas_bottom).offset(4);
          }
          make.right.mas_equalTo(self.ocjView_gift.mas_right).offset(-8);
        }];
        ocjLab_last = ocjLab_gift;
      }
      
    }
    
    if (tempArr.count > 0) {
      for (int i = 0 ; i < tempArr.count; i++) {
        OCJResponceModel_gift *giftModel = tempArr[i];
        UILabel *ocjLab_gift = [[UILabel alloc] init];
        ocjLab_gift.text = [NSString stringWithFormat:@"[赠品%lu]%@", i + 1 + tempArr3.count, giftModel.ocjStr_giftItemName];
        ocjLab_gift.font = [UIFont systemFontOfSize:12];
        ocjLab_gift.textColor = OCJ_COLOR_DARK_GRAY;
        ocjLab_gift.textAlignment = NSTextAlignmentLeft;
        [self.ocjView_gift addSubview:ocjLab_gift];
        [ocjLab_gift mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(self.ocjView_gift.mas_left).offset(5);
          if (!ocjLab_last) {
            make.top.mas_equalTo(self.ocjView_gift.mas_top).offset(15);
          }else {
            make.top.mas_equalTo(ocjLab_last.mas_bottom).offset(4);
          }
          make.right.mas_equalTo(self.ocjView_gift.mas_right).offset(-8);
        }];
        ocjLab_last = ocjLab_gift;
      }
    }
    
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
