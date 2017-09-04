//
//  OCJEditAddressTVCell.m
//  OCJ
//
//  Created by OCJ on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJEditAddressTVCell.h"

@interface OCJEditAddressTVCell ()<UITextViewDelegate>



@end

@implementation OCJEditAddressTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjTF_input];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.ocjTF_input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.ocjLab_tip.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
}
- (OCJBaseLabel *)ocjLab_tip{
    if (!_ocjLab_tip ) {
        _ocjLab_tip  = [[OCJBaseLabel alloc]init];
        _ocjLab_tip.font = [UIFont systemFontOfSize:15];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.text = @"收货人";
    }
    return _ocjLab_tip;
}

- (OCJBaseTextField *)ocjTF_input{
    if (!_ocjTF_input) {
        _ocjTF_input = [[OCJBaseTextField alloc]init];
        _ocjTF_input.textColor = [UIColor colorWSHHFromHexString:@"666666"];
      _ocjTF_input.textAlignment = NSTextAlignmentRight;
        _ocjTF_input.font = [UIFont systemFontOfSize:15];
        _ocjTF_input.tintColor = [UIColor redColor];
    }
    return _ocjTF_input;
}
@end


@interface OCJEditAddressSelectedTVCell ()

@end


@implementation OCJEditAddressSelectedTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.ocjLab_cityLabel];
        self.ocjTF_input.hidden = YES;
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
-(void)updateConstraints{
    [super updateConstraints];
    
    [self.ocjLab_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.left.mas_greaterThanOrEqualTo(self.ocjLab_tip.mas_right).offset(10);
    }];
    
}
- (OCJBaseLabel *)ocjLab_cityLabel{
    if (!_ocjLab_cityLabel ) {
        _ocjLab_cityLabel  = [[OCJBaseLabel alloc]init];
        _ocjLab_cityLabel.font = [UIFont systemFontOfSize:15];
        _ocjLab_cityLabel.textAlignment = NSTextAlignmentRight;
        _ocjLab_cityLabel.numberOfLines = 0;
        _ocjLab_cityLabel.textColor = [UIColor colorWSHHFromHexString:@"999999"];
    }
    return _ocjLab_cityLabel;
}

@end


@interface OCJEditBottomTVCell ()

@property (nonatomic,strong) UIView       * ocjView_bottom;
@property (nonatomic,strong) OCJBaseLabel * ocjLab_title;
@property (nonatomic,strong) OCJBaseLabel * ocjLab_subTitle;

@end

@implementation OCJEditBottomTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"F1F1F1"];
        [self.contentView addSubview:self.ocjView_bottom];
        [self.ocjView_bottom addSubview:self.ocjLab_title];
        [self.ocjView_bottom addSubview:self.ocjLab_subTitle];
        [self.ocjView_bottom addSubview:self.ocjSwitch];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(10);
    }];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_bottom).offset(15);
        make.top.mas_equalTo(self.ocjView_bottom).offset(10);
        make.height.mas_equalTo(21);
    }];
    
    [self.ocjLab_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_title);
        make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(5);
    }];
    
    [self.ocjSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ocjView_bottom.mas_centerY).offset(-5);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(28);
        make.right.mas_equalTo(self.ocjView_bottom).offset(-15);
    }];
}
- (UISwitch *)ocjSwitch{
    if (!_ocjSwitch) {
        _ocjSwitch = [[UISwitch alloc]init];
        [_ocjSwitch addTarget:self action:@selector(ocj_Switch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjSwitch;
}
- (void)ocj_Switch{
    if (self.switchHandler) {
        self.switchHandler(self.ocjSwitch.isOn);
    }
}
- (UIView *)ocjView_bottom{
    if (!_ocjView_bottom) {
        _ocjView_bottom = [[UIView alloc]init];
        _ocjView_bottom.backgroundColor = [UIColor whiteColor];
    }
    return _ocjView_bottom;
}

- (OCJBaseLabel *)ocjLab_title{
    if (!_ocjLab_title ) {
        _ocjLab_title  = [[OCJBaseLabel alloc]init];
        _ocjLab_title.font = [UIFont systemFontOfSize:15];
        _ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_title.text = @"设置为默认地址";
    }
    return _ocjLab_title;
}
- (OCJBaseLabel *)ocjLab_subTitle{
    if (!_ocjLab_subTitle ) {
        _ocjLab_subTitle  = [[OCJBaseLabel alloc]init];
        _ocjLab_subTitle.font = [UIFont systemFontOfSize:11];
        _ocjLab_subTitle.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_subTitle.text = @"每次下单时会使用该地址";
    }
    return _ocjLab_subTitle;
}

@end


@implementation OCJEditMiddleTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjLab_placeholder];
        [self.contentView addSubview:self.ocjTV_city];
        self.ocjLab_placeholder.text = @"";
        self.ocjLab_tip.text = @"详细地址:";
        self.ocjTF_input.hidden = YES;
      NSLog(@"%@",self.ocjLab_tip.text);
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
-(void)updateConstraints{
    [super updateConstraints];
  
    [self.ocjTV_city mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(13);
        make.bottom.mas_equalTo(self.contentView).offset(-13);
        make.left.mas_equalTo(self.ocjLab_tip.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
  
    [self.ocjLab_placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(13);
        make.bottom.mas_equalTo(self.contentView).offset(-13);
        make.left.mas_greaterThanOrEqualTo(self.ocjLab_tip.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);

    }];
}

- (void)ocj_showplaceholder:(BOOL)isshow
{
  if (![self.ocjLab_placeholder.text isEqualToString:@""]) {
    if (isshow) {
      self.ocjLab_placeholder.hidden = YES;
    }
    else
    {
      self.ocjLab_placeholder.hidden = NO;
    }
  }
}

- (OCJBaseLabel *)ocjLab_placeholder
{
  if (!_ocjLab_placeholder) {
      _ocjLab_placeholder  = [[OCJBaseLabel alloc]init];
      _ocjLab_placeholder.numberOfLines = 0;
      _ocjLab_placeholder.hidden = NO;
      _ocjLab_placeholder.textAlignment = NSTextAlignmentRight;
      _ocjLab_placeholder.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
      _ocjLab_placeholder.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
  }
  return _ocjLab_placeholder;
}

- (OCJBaseTextView *)ocjTV_city{
    if (!_ocjTV_city) {
        _ocjTV_city = [[OCJBaseTextView alloc]init];
        _ocjTV_city.delegate = self;
        _ocjTV_city.tintColor = [UIColor redColor];
        _ocjTV_city.font = [UIFont systemFontOfSize:15];
        _ocjTV_city.textColor =[UIColor colorWSHHFromHexString:@"666666"];
        _ocjTV_city.backgroundColor = [UIColor clearColor];
    }
    return _ocjTV_city;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  
    if (![self.ocjLab_placeholder.text isEqualToString:@""]) {
      if (![text isEqualToString:@""]) {
        self.ocjLab_placeholder.hidden = YES;
      }
      
      if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.ocjLab_placeholder.hidden = NO;
      }
    }
    
    NSInteger maxLineNum = 2;
    CGSize fontSize = [textView.text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    CGSize tallerSize = CGSizeMake(textView.frame.size.width - 15,textView.frame.size.height * 2);
    
    CGSize newSize = [newText boundingRectWithSize:tallerSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: textView.font}
                                           context:nil].size;
    NSInteger newLineNum = newSize.height / fontSize.height;
    if ([text isEqualToString:@"\n"]) {
        newLineNum += 1;
    }
    
    if ((newLineNum <= maxLineNum)
        && newSize.width < textView.frame.size.width-15)
    {
        return YES;
    }else{
        return NO;
    }
}
@end

