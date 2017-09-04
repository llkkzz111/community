//
//  OCJChooseGiftTVCell.m
//  OCJ
//
//  Created by Ray on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJChooseGiftTVCell.h"

@interface OCJChooseGiftTVCell ()

@property (nonatomic, strong) UIButton *ocjBtn_select;      ///<选择按钮
@property (nonatomic, strong) UIImageView *ocjImgView_gift; ///<预览图
@property (nonatomic, strong) UILabel *ocjLab_color;        ///<赠品颜色
@property (nonatomic, strong) UILabel *ocjLab_price;        ///<价格
@property (nonatomic, strong) UILabel *ocjLab_num;          ///<数量

@property (nonatomic) BOOL isSelected;                      ///<是否选中
@property (nonatomic, strong) NSDictionary *ocjDic_data;            ///<

@end

@implementation OCJChooseGiftTVCell

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
    //选择按钮
    self.ocjBtn_select = [[UIButton alloc] init];
    [self.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
    [self.ocjBtn_select addTarget:self action:@selector(ocj_clickedBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ocjBtn_select];
    [self.ocjBtn_select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(@42);
    }];
    //imageView
    self.ocjImgView_gift = [[UIImageView alloc] init];
    self.ocjImgView_gift.backgroundColor = [UIColor redColor];
    [self addSubview:self.ocjImgView_gift];
    [self.ocjImgView_gift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_select.mas_right).offset(0);
        make.width.height.mas_equalTo(@90);
        make.centerY.mas_equalTo(self);
    }];
    //名称
    self.ocjLab_name = [[UILabel alloc] init];
    self.ocjLab_name.text = @"Panasonic/松下 F-CM339C纳米落地电风扇水离子自然风静音家用";
    self.ocjLab_name.font = [UIFont systemFontOfSize:14];
    self.ocjLab_name.numberOfLines = 2;
    self.ocjLab_name.textColor = OCJ_COLOR_DARK;
    self.ocjLab_name.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_name];
    [self.ocjLab_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImgView_gift.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self.ocjImgView_gift).offset(20);
    }];
    //价格
    self.ocjLab_price = [[UILabel alloc] init];
    self.ocjLab_price.text = @"￥2000";
    self.ocjLab_price.font = [UIFont systemFontOfSize:17];
    self.ocjLab_price.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    self.ocjLab_price.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_price];
     [self.ocjLab_price mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.ocjLab_name);
         make.bottom.mas_equalTo(self.ocjImgView_gift);
     }];
    //数量
    self.ocjLab_num = [[UILabel alloc] init];
    self.ocjLab_num.text = @"x1";
    self.ocjLab_num.font = [UIFont systemFontOfSize:17];
    self.ocjLab_num.textColor = OCJ_COLOR_DARK;
    self.ocjLab_num.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_num];
    [self.ocjLab_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.ocjImgView_gift);
    }];
    //颜色
    self.ocjLab_color = [[UILabel alloc] init];
    self.ocjLab_color.text = @"颜色分类：银色";
    self.ocjLab_color.font = [UIFont systemFontOfSize:12];
    self.ocjLab_color.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_color.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_color];
    [self.ocjLab_color mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_name);
        make.top.mas_equalTo(self.ocjLab_name.mas_bottom).offset(6);
    }];
    //
    self.ocjLab_color.hidden = YES;
    self.ocjLab_num.hidden = YES;
    self.ocjLab_price.hidden = YES;
}

- (void)ocj_loadData:(OCJResponceModel_giftDesc *)model title:(NSString *)title {
    
    if ([title containsString:model.ocjStr_itemName]) {
        self.isSelected = YES;
        [self.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_selected"] forState:UIControlStateNormal];
        self.ocjBtn_select.userInteractionEnabled = NO;
    }else {
        self.isSelected = NO;
        [self.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
        self.ocjBtn_select.userInteractionEnabled = YES;
    }
    self.ocjLab_name.text = model.ocjStr_itemName;
    [self.ocjImgView_gift ocj_setWebImageWithURLString:model.ocjStr_imgUrl completion:nil];
}

- (void)ocj_clickedBtn {
    if (self.isSelected) {
        return;
    }else {
        self.isSelected = YES;
        if (self.ocjSelectedGiftBlock) {
            self.ocjSelectedGiftBlock(self.isSelected, self.ocjLab_name.text);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
