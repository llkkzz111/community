//
//  OCJGlobalScreenRetrievalPriceTableViewCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGlobalScreenRetrievalPriceTableViewCell.h"

@interface OCJGlobalScreenRetrievalPriceTableViewCell()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField        *ocjField_minPrice;
@property (nonatomic,strong) UITextField        *ocjField_maxPrice;
@property (nonatomic,strong) UILabel            *ocjLab_line;

@end

@implementation OCJGlobalScreenRetrievalPriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews
{
    [self addSubview:self.ocjLab_line];
    [self.ocjLab_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self addSubview:self.ocjField_minPrice];
    [self.ocjField_minPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.ocjLab_line.mas_left).offset(-10);
    }];
    
    [self addSubview:self.ocjField_maxPrice];
    [self.ocjField_maxPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.left.mas_equalTo(self.ocjLab_line.mas_right).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    UITextField *field = (UITextField *)theTextField;
    if (field.tag == 201) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalScreenRetrievalPriceChangeed:At:)]) {
            [self.delegate ocj_golbalScreenRetrievalPriceChangeed:self.ocjField_minPrice.text At:NO];
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalScreenRetrievalPriceChangeed:At:)]) {
            [self.delegate ocj_golbalScreenRetrievalPriceChangeed:self.ocjField_maxPrice.text At:YES];
        }
    }
}

#pragma mark - getter
- (UILabel *)ocjLab_line
{
    if (!_ocjLab_line) {
        _ocjLab_line = [[UILabel alloc] init];
        [_ocjLab_line setBackgroundColor:[UIColor clearColor]];
        _ocjLab_line.text = @"-";
        _ocjLab_line.font = [UIFont systemFontOfSize:16];
        _ocjLab_line.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _ocjLab_line;
}

- (UITextField *)ocjField_minPrice
{
    if (!_ocjField_minPrice) {
        _ocjField_minPrice = [[UITextField alloc] init];
        [_ocjField_minPrice setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1/1.0]];
        [_ocjField_minPrice addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _ocjField_minPrice.delegate = self;
        _ocjField_minPrice.tag = 201;
        _ocjField_minPrice.textAlignment = NSTextAlignmentCenter;
        _ocjField_minPrice.placeholder = @"最低价";
        _ocjField_minPrice.layer.cornerRadius = 4;
        _ocjField_minPrice.layer.masksToBounds = YES;
        _ocjField_minPrice.font = [UIFont systemFontOfSize:16];
        _ocjField_minPrice.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _ocjField_minPrice;
}

- (UITextField *)ocjField_maxPrice
{
    if (!_ocjField_maxPrice) {
        _ocjField_maxPrice = [[UITextField alloc] init];
        [_ocjField_maxPrice setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1/1.0]];
        [_ocjField_maxPrice addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _ocjField_maxPrice.delegate = self;
        _ocjField_maxPrice.tag = 202;
        _ocjField_maxPrice.textAlignment = NSTextAlignmentCenter;
        _ocjField_maxPrice.placeholder = @"最高价";
        _ocjField_maxPrice.layer.cornerRadius = 4;
        _ocjField_maxPrice.layer.masksToBounds = YES;
        _ocjField_maxPrice.font = [UIFont systemFontOfSize:16];
        _ocjField_maxPrice.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _ocjField_maxPrice;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UITextField *field = (UITextField *)textField;
    if (field.tag == 201) {
        [self.ocjField_minPrice resignFirstResponder];
    }
    else
    {
        [self.ocjField_maxPrice resignFirstResponder];;
    }
    return YES;
}

@end
