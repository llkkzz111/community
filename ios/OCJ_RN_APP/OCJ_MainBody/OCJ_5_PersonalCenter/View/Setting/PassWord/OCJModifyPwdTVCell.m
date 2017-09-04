//
//  OCJModifyPwdTVCell.m
//  OCJ
//
//  Created by Ray on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJModifyPwdTVCell.h"

@interface OCJModifyPwdTVCell ()

@property (nonatomic, strong) UIButton *ocjBtn_pwd;///<显示或隐藏密码

@end

@implementation OCJModifyPwdTVCell

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
    UIView *ocjView_bg = [[UIView alloc] init];
    ocjView_bg.backgroundColor = OCJ_COLOR_BACKGROUND;
    [self addSubview:ocjView_bg];
    [ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.top.bottom.mas_equalTo(self);
    }];
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_LIGHT_GRAY;
    [ocjView_bg addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(ocjView_bg);
        make.height.mas_equalTo(@0.5);
    }];
    //btn
    self.ocjBtn_pwd = [[UIButton alloc] init];
    [self.ocjBtn_pwd setImage:[UIImage imageNamed:@"icon_pw_active"] forState:UIControlStateNormal];
    [self.ocjBtn_pwd addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [ocjView_bg addSubview:self.ocjBtn_pwd];
    [self.ocjBtn_pwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ocjView_bg);
        make.right.mas_equalTo(ocjView_bg);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    //textField
    self.ocjTF_input = [[OCJBaseTextField alloc] init];
    self.ocjTF_input.font = [UIFont systemFontOfSize:15];
    self.ocjTF_input.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ocjTF_input.tintColor = [UIColor redColor];
    [ocjView_bg addSubview:self.ocjTF_input];
    [self.ocjTF_input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(ocjView_bg);
        make.right.mas_equalTo(self.ocjBtn_pwd.mas_left).offset(-10);
        make.height.mas_equalTo(@30);
    }];
}

- (void)action:(id)sender{
    self.ocjBool_showPwd = !self.ocjBool_showPwd;
    if (self.ocjBool_showPwd) {
        self.ocjTF_input.secureTextEntry = YES;
        [self.ocjBtn_pwd setImage:[UIImage imageNamed:@"icon_pw_normal"] forState:UIControlStateNormal];
    }else{
        self.ocjTF_input.secureTextEntry = NO;
        [self.ocjBtn_pwd setImage:[UIImage imageNamed:@"icon_pw_active"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
