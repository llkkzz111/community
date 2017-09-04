//
//  OCJEvaluateInputTVCell.m
//  OCJ
//
//  Created by Ray on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJEvaluateInputTVCell.h"

@interface OCJEvaluateInputTVCell ()<UITextViewDelegate>

@end

@implementation OCJEvaluateInputTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = OCJ_COLOR_BACKGROUND;
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews {
    self.ocjTF_suggest = [[OCJPlaceholderTextView alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 130)];
    self.ocjTF_suggest.font = [UIFont systemFontOfSize:12];
    self.ocjTF_suggest.placeholder = @"亲，商品还满意吗？（成功发表评论并在页面中显示，可获奖励20鸥点/条）";
    self.ocjTF_suggest.delegate = self;
    self.ocjTF_suggest.returnKeyType = UIReturnKeyDone;
    self.ocjTF_suggest.tintColor =[UIColor redColor];
    [self addSubview:self.ocjTF_suggest];
    [self.ocjTF_suggest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(130);
    }];
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(@0.5);
        make.top.mas_equalTo(self.ocjTF_suggest.mas_bottom).offset(0);
    }];
    //
    UIView *ocjView_gray = [[UIView alloc] init];
    ocjView_gray.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    [self addSubview:ocjView_gray];
    [ocjView_gray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(ocjView_line.mas_bottom).offset(0);
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
