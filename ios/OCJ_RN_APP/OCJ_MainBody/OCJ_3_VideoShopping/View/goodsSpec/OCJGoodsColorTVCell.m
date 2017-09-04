//
//  OCJGoodsColorTVCell.m
//  OCJ
//
//  Created by Ray on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJGoodsColorTVCell.h"

@interface OCJGoodsColorTVCell ()

@property (nonatomic, strong) UILabel *ocjLab_title;       ///<类型
@property (nonatomic, strong) UIButton *ocjBtn_selected;   ///<选中的按钮
@property (nonatomic, strong) NSArray *ocjArr_data;   ///<

@end

@implementation OCJGoodsColorTVCell

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
    self.ocjLab_title = [[UILabel alloc] init];
    self.ocjLab_title.font = [UIFont systemFontOfSize:14];
    self.ocjLab_title.textColor = OCJ_COLOR_DARK;
    self.ocjLab_title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.ocjLab_title];
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(15);
    }];
}

- (void)loadCellWithData:(OCJResponceModel_GoodsSpec *)model andCscode:(NSString *)cscode csoff:(NSString *)csoff title:(NSString *)title {
  
  if ([title isEqualToString:@"规格"]) {
    self.ocjArr_data = model.ocjArr_colorSize;
  }else {
    self.ocjArr_data = model.ocjArr_color;
  }
  
    self.ocjLab_title.text = title;
    
    UIButton *ocjBtn_last;
    __block NSInteger row = 1;
    __block CGFloat labWidth,labHeight,totalRowWidth = 30,horSpace = 20;
    
    for (int i = 0; i < self.ocjArr_data.count; i++) {
        OCJResponceModel_specDetail *model = self.ocjArr_data[i];
        
        UIButton *ocjBtn_spec = [[UIButton alloc] init];
        [ocjBtn_spec setTitle:[NSString stringWithFormat:@"%@", model.ocjStr_name] forState:UIControlStateNormal];
        ocjBtn_spec.layer.borderWidth = 0.5;
        ocjBtn_spec.tag = i;
        
        ocjBtn_spec.selected = NO;
        if ([model.ocjStr_isShow isEqualToString:@"Y"]) {
            if ([csoff containsString:model.ocjStr_cscode]) {
                [ocjBtn_spec setTitleColor:[UIColor colorWSHHFromHexString:@"999999"] forState:UIControlStateNormal];
                ocjBtn_spec.layer.borderColor = [UIColor colorWSHHFromHexString:@"999999"].CGColor;
                ocjBtn_spec.userInteractionEnabled = NO;
            }else if ([model.ocjStr_cscode isEqualToString:cscode]) {
                ocjBtn_spec.selected = YES;
                self.ocjBtn_selected = ocjBtn_spec;
                [ocjBtn_spec setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
                ocjBtn_spec.layer.borderColor = [UIColor colorWSHHFromHexString:@"#E5290D"].CGColor;
                ocjBtn_spec.userInteractionEnabled = YES;
            }else {
                ocjBtn_spec.selected = NO;
                [ocjBtn_spec setTitleColor:[UIColor colorWSHHFromHexString:@"666666"] forState:UIControlStateNormal];
                ocjBtn_spec.layer.borderColor = [UIColor colorWSHHFromHexString:@"666666"].CGColor;
                ocjBtn_spec.userInteractionEnabled = YES;
            }
            
        }else if ([model.ocjStr_isShow isEqualToString:@"N"]) {
            [ocjBtn_spec setTitleColor:[UIColor colorWSHHFromHexString:@"999999"] forState:UIControlStateNormal];
            ocjBtn_spec.layer.borderColor = [UIColor colorWSHHFromHexString:@"999999"].CGColor;
            ocjBtn_spec.userInteractionEnabled = NO;
        }
        
        ocjBtn_spec.titleLabel.font = [UIFont systemFontOfSize:14];
        ocjBtn_spec.layer.cornerRadius = 4;
        [ocjBtn_spec addTarget:self action:@selector(ocj_clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ocjBtn_spec];
        
        CGRect receSize = [self ocj_calculateLabelRectWithString:model.ocjStr_name font:14];
        labWidth = ceilf(receSize.size.width) + 8;
        labHeight = ceilf(receSize.size.height) + 6;
        
        [ocjBtn_spec mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!ocjBtn_last) {
                totalRowWidth += labWidth;
                make.left.mas_equalTo(self.mas_left).offset(15);
            }else {
                totalRowWidth += horSpace + labWidth;
                if (totalRowWidth > SCREEN_WIDTH - 30) {
                    make.left.mas_equalTo(self.mas_left).offset(15);
                }else {
                    make.left.mas_equalTo(ocjBtn_last.mas_right).offset(horSpace);
                }
            }
            if (totalRowWidth > SCREEN_WIDTH - 30) {
                row += 1;
                totalRowWidth = 30 + labWidth;
            }
            make.top.mas_equalTo(self.ocjLab_title.mas_bottom).offset(15 * row + (row - 1) * labHeight);
            
            make.width.mas_equalTo(labWidth);
            make.height.mas_equalTo(labHeight);
        }];
        ocjBtn_last = ocjBtn_spec;
    }
}

/**
 点击按钮事件
 */
- (void)ocj_clickedBtn:(UIButton *)ocjBtn {
    //选中可以取消
    ocjBtn.selected = !ocjBtn.selected;
    if (ocjBtn.tag == self.ocjBtn_selected.tag) {
        if (!ocjBtn.selected) {
            [ocjBtn setTitleColor:[UIColor colorWSHHFromHexString:@"666666"] forState:UIControlStateNormal];
            ocjBtn.layer.borderColor = [UIColor colorWSHHFromHexString:@"666666"].CGColor;
        }else {
            [ocjBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
            ocjBtn.layer.borderColor = [UIColor colorWSHHFromHexString:@"#E5290D"].CGColor;
        }
    }else {
        [self.ocjBtn_selected setTitleColor:[UIColor colorWSHHFromHexString:@"666666"] forState:UIControlStateNormal];
        self.ocjBtn_selected.layer.borderColor = [UIColor colorWSHHFromHexString:@"666666"].CGColor;
        
        [ocjBtn setTitleColor:[UIColor colorWSHHFromHexString:@"#E5290D"] forState:UIControlStateNormal];
        ocjBtn.layer.borderColor = [UIColor colorWSHHFromHexString:@"#E5290D"].CGColor;
        
        OCJLog(@"sss = %ld", ocjBtn.tag);
        OCJLog(@"ddd = %ld", self.ocjBtn_selected.tag);
        ocjBtn.selected = YES;
        self.ocjBtn_selected = ocjBtn;
    }
    
    if (ocjBtn.selected) {
        OCJResponceModel_specDetail *model = self.ocjArr_data[ocjBtn.tag];
        if (self.ocjSelectedSpecBlock) {
            self.ocjSelectedSpecBlock(self.ocjBtn_selected, model);
        }
    }else {
        OCJLog(@"未选择");
        OCJResponceModel_specDetail *model = [[OCJResponceModel_specDetail alloc] init];
        if (self.ocjSelectedSpecBlock) {
            self.ocjSelectedSpecBlock(self.ocjBtn_selected, model);
        }
    }
}

/**
 根据文字内容跟字体大小计算宽高
 */
- (CGRect)ocj_calculateLabelRectWithString:(NSString *)ocjStr font:(NSInteger)font {
    CGRect rect = [ocjStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
