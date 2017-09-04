//
//  OCJSuperValueTableViewCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSuperValueTableViewCell.h"
#import "OJCSuperValueButtonView.h"

@interface OCJSuperValueTableViewCell()<OJCSuperValueButtonViewDelegate>
@property (nonatomic,strong) NSArray     *ocjArr_Data;
@end

@implementation OCJSuperValueTableViewCell


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
    [self setBackgroundColor:[UIColor clearColor]];
  
    for (int i = 0; i < 2; i ++) {
        OJCSuperValueButtonView *view = [[OJCSuperValueButtonView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(SCREEN_WIDTH/2.0*i);
            make.right.mas_equalTo(self).offset(-(SCREEN_WIDTH/2.0*(1-i)));
            make.top.bottom.mas_equalTo(self);
        }];
        view.tag = i+1;
        view.delegate = self;
    }
  
    UIView* middleVerSep = [[UIView alloc]init];
    middleVerSep.backgroundColor = [UIColor colorWSHHFromHexString:@"#DDDDDD"];
    [self addSubview:middleVerSep];
    [middleVerSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@1);
        make.top.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
    }];
  
    UIView* topHorSep = [[UIView alloc]init];
    topHorSep.backgroundColor = [UIColor colorWSHHFromHexString:@"#DDDDDD"];
    [self addSubview:topHorSep];
    [topHorSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@1);
        make.top.mas_equalTo(self);
        make.left.right.mas_equalTo(self);
    }];
  
    self.ocjLab_bottomSep = [[UILabel alloc]init];
    self.ocjLab_bottomSep.backgroundColor = [UIColor colorWSHHFromHexString:@"#DDDDDD"];
    [self addSubview:self.ocjLab_bottomSep];
    [self.ocjLab_bottomSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@1);
        make.bottom.mas_equalTo(self);
        make.left.right.mas_equalTo(self);
    }];
  
}

- (void)ocj_setShowDataWithArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]]) {
        array = @[];
    }
  
    self.ocjArr_Data = array;
  
    //给预置展示视图赋值
    for (int i = 0; i < array.count; i ++) {
        OJCSuperValueButtonView *view = [self viewWithTag:i+1];
        view.alpha = 1;
        if (view) {
            OCJGSModel_Package44 *model = [self.ocjArr_Data objectAtIndex:i];
            view.ocjModel_goodInfo = model;
        }
    }
  
    //商品不足两件时，隐藏无对应商品数据的预置展示视图
    for (NSInteger i = 0; i<2-array.count; i++) {
        OJCSuperValueButtonView *view = [self viewWithTag:2-i];
        view.alpha = 0;
    }
  
}

- (NSArray *)ocjArr_Data
{
    if (!_ocjArr_Data) {
        _ocjArr_Data = [[NSMutableArray alloc] init];
    }
    return _ocjArr_Data;
}

#pragma mark - OJCSuperValueButtonViewDelegate
- (void)ocj_onSuperValueButtonPressedWithGoodInfoModel:(OCJGSModel_Package44 *)model
{
      if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalSuperValuePressed:At:)]) {
          [self.delegate ocj_golbalSuperValuePressed:model At:self];
      }
}

@end
