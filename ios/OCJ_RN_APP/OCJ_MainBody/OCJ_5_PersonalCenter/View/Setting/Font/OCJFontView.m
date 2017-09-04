//
//  OCJFontView.m
//  OCJ
//
//  Created by OCJ on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJFontView.h"


@interface OCJFontView()
@property (nonatomic,strong) UILabel     * ocjLab_normal;
@property (nonatomic,strong) UILabel     * ocjLab_double;
@property (nonatomic,strong) UIImageView * ocjImg_bg;
@property (nonatomic,strong) UIImageView * ocjImg_front;
@property (nonatomic,assign) BOOL          ocjBool_isMove;

@end
@implementation OCJFontView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.ocjLab_double];
        [self addSubview:self.ocjLab_normal];
        [self addSubview:self.ocjImg_bg];
        [self.ocjImg_bg addSubview:self.ocjImg_front];
        [self.ocjLab_normal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(40);
            make.top.mas_equalTo(self).offset(40);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(21);
        }];
        
        [self.ocjLab_double mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-40);
            make.top.mas_equalTo(self).offset(40);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(21);
        }];
        
        [self.ocjImg_bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.ocjLab_double).offset(-15);
            make.left.mas_equalTo(self.ocjLab_normal).offset(15);
            make.top.mas_equalTo(self.ocjLab_normal.mas_bottom).offset(15);
            make.height.mas_equalTo(15);
        }];
        
        [self.ocjImg_front mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.ocjImg_bg).offset(-15);
            make.centerY.mas_equalTo(self.ocjImg_bg);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.ocjImg_front addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}
- (void)setOcjState_font:(OCJFontState)ocjState_font{
    if (ocjState_font ==  OCJFontState_Normal) {
        [self.ocjImg_front mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.ocjImg_bg).offset(-15);
            make.centerY.mas_equalTo(self.ocjImg_bg);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
    }else{
        [self.ocjImg_front mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.ocjImg_bg).offset(15);
            make.centerY.mas_equalTo(self.ocjImg_bg);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
    }
}
- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer{

}
- (UILabel *)ocjLab_normal{
    if (!_ocjLab_normal) {
        _ocjLab_normal = [[UILabel alloc]init];
        _ocjLab_normal.font = [UIFont systemFontOfSize:14];
        _ocjLab_normal.text = @"标准";
        _ocjLab_normal.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    }
    return _ocjLab_normal;
}

- (UILabel *)ocjLab_double{
    if (!_ocjLab_double) {
        _ocjLab_double = [[UILabel alloc]init];
        _ocjLab_double.font = [UIFont systemFontOfSize:15];
        _ocjLab_double.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_double.text = @"放大";
    }
    return _ocjLab_double;
}

- (UIImageView *)ocjImg_bg{
    if (!_ocjImg_bg) {
        _ocjImg_bg = [[UIImageView alloc]init];
        [_ocjImg_bg setImage:[UIImage imageNamed:@"icon_fontsizeBg"]];
    }
    return _ocjImg_bg;
}

- (UIImageView *)ocjImg_front{
    if (!_ocjImg_front) {
        _ocjImg_front = [[UIImageView alloc]init];
        _ocjImg_front.layer.masksToBounds = YES;
        _ocjImg_front.layer.cornerRadius = 15;
        [_ocjImg_front setImage:[UIImage imageNamed:@"icon_fontsizebtnBg"]];
    }
    return _ocjImg_front;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.ocjImg_bg];
    if (point.x + 15 < self.ocjImg_bg.frame.size.width /2 ) {
        self.ocjImg_front.frame = CGRectMake(-15, self.ocjImg_front.frame.origin.y, self.ocjImg_front.frame.size.width, self.ocjImg_front.frame.size.height);
        if (self.ocjFontHandler) {
            self.ocjFontHandler(OCJFontState_Normal);///< 正常字体回调
        }
    }else {
        self.ocjImg_front.frame = CGRectMake(self.ocjImg_bg.frame.size.width- 15, self.ocjImg_front.frame.origin.y, self.ocjImg_front.frame.size.width, self.ocjImg_front.frame.size.height);
        if (self.ocjFontHandler) {
            self.ocjFontHandler(OCJFontState_Double); ///< 放大字体回调
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.ocjImg_bg];
    if (point.x  >= self.ocjImg_bg.frame.size.width- 15 || point.x <= -15) {
        return;
    }
    self.ocjImg_front.frame = CGRectMake(point.x, self.ocjImg_front.frame.origin.y, self.ocjImg_front.frame.size.width, self.ocjImg_front.frame.size.height);
}

@end
