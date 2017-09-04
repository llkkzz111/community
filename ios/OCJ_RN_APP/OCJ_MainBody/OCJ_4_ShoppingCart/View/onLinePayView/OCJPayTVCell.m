//
//  OCJPayTVCell.m
//  OCJ
//
//  Created by OCJ on 2017/5/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJPayTVCell.h"
#import "OCJSelectedView.h"
#import "OCJOrderListScrollView.h"
#import "OCJOtherPayView.h"


@interface OCJPayTVCell()



@end

@implementation OCJPayTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjLab_order];
        [self.contentView addSubview:self.ocjLab_page];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjLab_order mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(self.contentView).offset(8);
        make.height.mas_equalTo(18.5);
    }];
    
    [self.ocjLab_page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.centerY.mas_equalTo(self.ocjLab_order);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
}

- (UILabel *)ocjLab_order{
    if (!_ocjLab_order) {
        _ocjLab_order = [[UILabel alloc]init];
        _ocjLab_order.font = [UIFont systemFontOfSize:13];
        _ocjLab_order.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    }
    return _ocjLab_order;
}

- (UILabel *)ocjLab_page{
    if (!_ocjLab_page) {
        _ocjLab_page = [[UILabel alloc]init];
        _ocjLab_page.font = [UIFont systemFontOfSize:12];
        _ocjLab_page.textAlignment = NSTextAlignmentCenter;
        _ocjLab_page.textColor = [UIColor whiteColor];
        _ocjLab_page.backgroundColor = [UIColor colorWSHHFromHexString:@"999999"];
        _ocjLab_page.layer.masksToBounds = YES;
        _ocjLab_page.layer.cornerRadius = 12.5;
    }
    return _ocjLab_page;
}
@end


@interface OCJPayTVCell_TF ()

@property (nonatomic, strong) UILabel * ocjLab_subTip;

@end

@implementation OCJPayTVCell_TF

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjBtn_select];
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjLab_subTip];
        [self.contentView addSubview:self.ocjTF_input];
        [self.contentView addSubview:self.ocjLab_fact];
        [self addSubview:self.ocjView_line];
        self.ocjView_line.hidden = YES;
        self.ocjBtn_select.selected = NO;
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjBtn_select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(@35);
    }];
  
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_select.mas_right).offset(0);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18.5);
    }];
    
    [self.ocjLab_fact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18.5);
    }];
    
    [self.ocjTF_input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjLab_fact.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(51);
    }];
    
    [self.ocjLab_subTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjTF_input.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.ocjLab_tip.mas_right).offset(10);;
        make.height.mas_equalTo(18.5);
    }];
  
  [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left).offset(15);
    make.bottom.right.mas_equalTo(self);
    make.height.mas_equalTo(@0.5);
  }];
}

- (void)setOcjStr_canScore:(NSString *)ocjStr_canScore {
  if ([ocjStr_canScore isEqualToString:@"NO"]) {
    [self.ocjBtn_select mas_updateConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(@0);
    }];
  }
}

- (UIButton *)ocjBtn_select {
  if (!_ocjBtn_select) {
    _ocjBtn_select = [[UIButton alloc] init];
    [_ocjBtn_select setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
    [_ocjBtn_select addTarget:self action:@selector(ocj_clickedSelectBtn) forControlEvents:UIControlEventTouchUpInside];
  }
  return _ocjBtn_select;
}

- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.font = [UIFont systemFontOfSize:13];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"666666"];
    }
    return _ocjLab_tip;
}

- (UILabel *)ocjLab_subTip{
    if (!_ocjLab_subTip) {
        _ocjLab_subTip = [[UILabel alloc]init];
        _ocjLab_subTip.font = [UIFont systemFontOfSize:13];
        _ocjLab_subTip.textAlignment = NSTextAlignmentRight;
        _ocjLab_subTip.text = @"使用";
        _ocjLab_subTip.textColor = [UIColor colorWSHHFromHexString:@"666666"];
    }
    return _ocjLab_subTip;
}

- (UIView *)ocjView_line {
  if (!_ocjView_line) {
    _ocjView_line = [[UIView alloc] init];
    _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
  }
  return _ocjView_line;
}

- (UILabel *)ocjLab_fact{
    if (!_ocjLab_fact) {
        _ocjLab_fact = [[UILabel alloc]init];
        _ocjLab_fact.font = [UIFont systemFontOfSize:13];
        _ocjLab_fact.textAlignment = NSTextAlignmentRight;
        _ocjLab_fact.textColor = [UIColor colorWSHHFromHexString:@"666666"];
        self.ocjLab_fact.text = [NSString stringWithFormat:@"抵￥0"];

    }
    return _ocjLab_fact;
}

- (UITextField *)ocjTF_input{
    if (!_ocjTF_input) {
        _ocjTF_input = [[UITextField alloc]init];
        _ocjTF_input.layer.masksToBounds = YES;
        _ocjTF_input.font = [UIFont systemFontOfSize:13];
        _ocjTF_input.layer.cornerRadius  = 0.5;
        _ocjTF_input.layer.borderColor   = [UIColor blackColor].CGColor;
        _ocjTF_input.layer.borderWidth   = 0.5;
        _ocjTF_input.keyboardType        = UIKeyboardTypeDecimalPad;
        _ocjTF_input.tintColor           = [UIColor redColor];
        _ocjTF_input.placeholder         = @"0";
        _ocjTF_input.textAlignment       = NSTextAlignmentCenter;
    }
    return _ocjTF_input;
}

-(void)ocj_resetStatus{
  
  self.ocjTF_input.text = @"";
  
  if (self.ocjBtn_select.selected) {//如果选中，重置cell内容
    [self ocj_clickedSelectBtn];
  }
}

- (void)ocj_clickedSelectBtn{
  self.ocjBtn_select.selected = !self.ocjBtn_select.selected;
  if (self.ocjBtn_select.selected) {
    [self.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_selected"] forState:UIControlStateNormal];
  }else {
    [self.ocjBtn_select setImage:[UIImage imageNamed:@"Icon_unselected"] forState:UIControlStateNormal];
  }
  if (self.ocjUseAllScoreBlock) {
    self.ocjUseAllScoreBlock();
  }
}


@end

@interface OCJPayTVCell_Text()

@property (nonatomic,strong) UILabel * ocjLab_fact;
@property (nonatomic,strong) UIView  * ocjView_line;

@end

@implementation OCJPayTVCell_Text
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjLab_fact];
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(self.ocjView_line.mas_bottom).offset(10);
        make.height.mas_equalTo(18.5);
    }];
    [self.ocjLab_fact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.ocjLab_tip);
        make.height.mas_equalTo(18.5);
    }];

}

- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [[UIView alloc]init];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"dddddd"];
    }
    return _ocjView_line;
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.font = [UIFont systemFontOfSize:13];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"666666"];
    }
    return _ocjLab_tip;
}
- (UILabel *)ocjLab_fact{
    if (!_ocjLab_fact) {
        _ocjLab_fact = [[UILabel alloc]init];
        _ocjLab_fact.font = [UIFont systemFontOfSize:13];
        _ocjLab_fact.textAlignment = NSTextAlignmentRight;
        _ocjLab_fact.textColor = [UIColor colorWSHHFromHexString:@"666666"];
    }
    return _ocjLab_fact;
}

- (void)ocj_setshopMoney:(NSString *)money{
    self.ocjLab_fact.text =[NSString stringWithFormat:@"￥ %.2f",[money floatValue] ? [money floatValue] : 0 ];  ///< 商品价格
}

@end


@interface OCJPayTVCell_TextSecond()


@end
@implementation OCJPayTVCell_TextSecond
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjLab_fact];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18.5);
    }];
    [self.ocjLab_fact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.ocjLab_tip);
        make.height.mas_equalTo(18.5);
    }];
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.font = [UIFont systemFontOfSize:13];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"666666"];
    }
    return _ocjLab_tip;
}
- (UILabel *)ocjLab_fact{
    if (!_ocjLab_fact) {
        _ocjLab_fact = [[UILabel alloc]init];
        _ocjLab_fact.font = [UIFont systemFontOfSize:13];
        _ocjLab_fact.textAlignment = NSTextAlignmentRight;
        _ocjLab_fact.textColor = [UIColor colorWSHHFromHexString:@"666666"];
    }
    return _ocjLab_fact;
}

- (void)ocj_setShopMoney:(NSString *)money{
    self.ocjLab_fact.text = [NSString stringWithFormat:@"¥ %@",money ?money:@"0"];
}
@end



@interface OCJPayTVCell_fact()
@property (nonatomic,strong) UILabel * ocjLab_tip;
@end

@implementation OCJPayTVCell_fact

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"F9F8F8"];
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjLab_fact];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(70);
    }];
    
    [self.ocjLab_fact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.mas_equalTo(self.ocjLab_tip);
        make.bottom.mas_equalTo(self.ocjLab_tip);
        make.left.greaterThanOrEqualTo(self.ocjLab_tip.mas_right);
    }];
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.font = [UIFont systemFontOfSize:18];
        _ocjLab_tip.text = @"实际需付：";
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"151515"];
    }
    return _ocjLab_tip;
}
- (UILabel *)ocjLab_fact{
    if (!_ocjLab_fact) {
        _ocjLab_fact = [[UILabel alloc]init];
        _ocjLab_fact.font = [UIFont systemFontOfSize:18];
        _ocjLab_fact.textAlignment = NSTextAlignmentRight;
        _ocjLab_fact.textColor = [UIColor colorWSHHFromHexString:@"151515"];
    }
    return _ocjLab_fact;
}

- (void)ocj_setShopMoney:(NSString *)money{
    self.ocjLab_fact.text = [NSString stringWithFormat:@"¥ %@",money?money:@"0"];
}
@end


@interface OCJPayTVCell_orderList ()
@property (nonatomic,strong)OCJOrderListScrollView * ocjScrollView_list;
@end

@implementation OCJPayTVCell_orderList
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjScrollView_list];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
- (void)ocj_setImgWithArray:(NSArray *)imgArr{
    if (self.ocjScrollView_list.ocjArr_data.count > 0 ) {
        self.ocjScrollView_list.ocjArr_data = nil;
    }
    self.ocjScrollView_list.ocjArr_data = imgArr;
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjScrollView_list mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).mas_equalTo(UIEdgeInsetsMake(10, 0, 10, 10));
    }];
}
- (OCJOrderListScrollView *)ocjScrollView_list{
    if (!_ocjScrollView_list) {
        _ocjScrollView_list = [[OCJOrderListScrollView alloc]init];
    }
    return _ocjScrollView_list;
}

@end

@interface OCJPayTVCell_onlineReduce ()

@property (nonatomic, strong) UILabel *ocjLab_title;  ///<名字

@end

@implementation OCJPayTVCell_onlineReduce

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self ocj_addViews];
  }
  return self;
}

- (void)ocj_addViews {
  
  self.ocjLab_title = [[UILabel alloc]init];
  self.ocjLab_title.font = [UIFont systemFontOfSize:13];
  self.ocjLab_title.text = @"在线支付优惠：";
  self.ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
  [self addSubview:self.ocjLab_title];
  [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.mas_left).offset(10);
    make.centerY.mas_equalTo(self);
    make.height.mas_equalTo(20);
    //        make.width.mas_equalTo(70);
  }];
  
  self.ocjLab_reduce = [[UILabel alloc]init];
  self.ocjLab_reduce.font = [UIFont systemFontOfSize:13];
  self.ocjLab_reduce.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
  [self addSubview:self.ocjLab_reduce];
  [self.ocjLab_reduce mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.mas_right).offset(-10);
    make.top.mas_equalTo(self.ocjLab_title);
    make.bottom.mas_equalTo(self.ocjLab_title);
    make.left.greaterThanOrEqualTo(self.ocjLab_title.mas_right);
  }];
}

@end
