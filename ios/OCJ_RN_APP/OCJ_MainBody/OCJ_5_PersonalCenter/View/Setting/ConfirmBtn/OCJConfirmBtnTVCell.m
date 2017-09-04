//
//  OCJConfirmBtnTVCell.m
//  OCJ
//
//  Created by Ray on 2017/5/25.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJConfirmBtnTVCell.h"

@implementation OCJConfirmBtnTVCell

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
    self.ocjBtn_confirm = [[OCJBaseButton alloc] initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH - 40, 45)];
    [self.ocjBtn_confirm setTitle:@"确 定" forState:UIControlStateNormal];
    [self.ocjBtn_confirm ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [self.ocjBtn_confirm setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    self.ocjBtn_confirm.ocjFont = [UIFont systemFontOfSize:17];
    self.ocjBtn_confirm.layer.cornerRadius = 2;
    self.ocjBtn_confirm.alpha = 0.2;
    self.ocjBtn_confirm.userInteractionEnabled = NO;
    [self.ocjBtn_confirm addTarget:self action:@selector(ocj_clickedConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ocjBtn_confirm];
}

- (void)ocj_clickedConfirmBtn {
    if (self.ocjConfirmBtnBlock) {
        self.ocjConfirmBtnBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
