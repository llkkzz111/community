//
//  OCJRefundGoodsTVCell.m
//  OCJ
//
//  Created by OCJ on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJRefundGoodsTVCell.h"
#import "OCJPlaceholderTextView.h"
#import "OCJUploadImageView.h"

@interface OCJRefundGoodsTVCell()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel          * ocjLab_tip;
@property (nonatomic,strong) UILabel          * ocjLab_line;
@property (nonatomic,strong) UIButton         * ocjBtn_show;
@property (nonatomic,strong) UILabel          * ocjLab_title;
@property (nonatomic,strong) UIImageView      * ocjImg_log;
@property (nonatomic,assign) BOOL               ocjBool_expand;
@property (nonatomic,strong) NSIndexPath      * index;///< 当前选中状态

@end

@implementation OCJRefundGoodsTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjBtn_show];
        [self.ocjBtn_show addSubview:self.ocjLab_title];
        [self.ocjBtn_show addSubview:self.ocjImg_log];
        [self.contentView addSubview:self.ocjLab_line];
        [self.contentView addSubview:self.ocj_tableView];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.contentView).offset(15);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.ocjBtn_show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.ocjLab_tip);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];

    [self.ocjImg_log mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(8);
        make.centerY.mas_equalTo(self.ocjBtn_show);
        make.right.mas_equalTo(self.ocjBtn_show.mas_right);
    }];
    
    [self.ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjImg_log.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.ocjBtn_show);
    }];
    [self.ocjLab_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.ocjLab_tip.mas_bottom).offset(15);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.ocj_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.ocjLab_line.mas_bottom);
        make.height.mas_equalTo(self.ocjArr_dataSource.count * 50);
    }];
}
- (OCJBaseTableView *)ocj_tableView{
    if (!_ocj_tableView) {
        _ocj_tableView                    = [[OCJBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _ocj_tableView.dataSource         = self;
        _ocj_tableView.delegate           = self;
        _ocj_tableView.scrollEnabled      = NO;
        _ocj_tableView.tableFooterView    = [[UIView alloc]init];
        _ocj_tableView.tableHeaderView    = [[UIView alloc]init];
    }
    return _ocj_tableView;
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"退货原因";
    }
    return _ocjLab_tip;
}
- (UILabel *)ocjLab_line{
    if (!_ocjLab_line) {
        _ocjLab_line = [[UILabel alloc]init];
        _ocjLab_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    }
    return _ocjLab_line;
}
- (UIImageView *)ocjImg_log{
    if (!_ocjImg_log) {
        _ocjImg_log = [[UIImageView alloc]init];
        [_ocjImg_log setImage:[UIImage imageNamed:@"icon_down"]];
    }
    return _ocjImg_log;
}
- (UILabel *)ocjLab_title{
    if (!_ocjLab_title) {
        _ocjLab_title = [[UILabel alloc]init];
        _ocjLab_title.font = [UIFont systemFontOfSize:14];
        _ocjLab_title.textColor = [UIColor colorWSHHFromHexString:@"666666"];
        _ocjLab_title.text = @"";
    }
    return _ocjLab_title;
}
- (UIButton *)ocjBtn_show{
    if (!_ocjBtn_show) {
        _ocjBtn_show = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ocjBtn_show addTarget:self action:@selector(ocj_switch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_show;
}
- (void)ocj_switch{
    self.ocjBool_expand = !self.ocjBool_expand;
    if (self.handler) {
      self.handler(@{});
    }
    if (self.ocjBool_expand) {
        [self.ocjImg_log setImage:[UIImage imageNamed:@"icon_down"]];
    }else{
        [self.ocjImg_log setImage:[UIImage imageNamed:@"icon_up"]];
    }
    [self ocj_refreshUI];
}
- (void)ocj_refreshUI{
    if (self.ocjBool_expand) {
        [self.ocj_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else{
        [self.ocj_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.ocjArr_dataSource.count * 50);
        }];
    }
}
#pragma mark -- UItableViewDelete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ocjArr_dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"secondCellIdentifier";
    OCJRefundResonTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OCJRefundResonTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
  NSDictionary * ocj_dic = [self.ocjArr_dataSource objectAtIndex:indexPath.row];
  
  cell.ocjLab_tip.text = [NSString stringWithFormat:@"%@. %@",[NSString stringWithFormat:@"%ld",indexPath.row + 1],ocj_dic[@"REASON"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSDictionary * ocj_dic = [self.ocjArr_dataSource objectAtIndex:indexPath.row];
  self.ocjLab_title.text = [NSString stringWithFormat:@"%@", ocj_dic[@"REASON"]];
    //之前选中的取消选择
    OCJRefundResonTVCell * cell  =[tableView cellForRowAtIndexPath:self.index];
    cell.ocjBool_isSelected = YES;
    self.index = indexPath;
    
    //
    OCJRefundResonTVCell * currentCell  =[tableView cellForRowAtIndexPath:indexPath];
    currentCell.ocjBool_isSelected = NO;
  
    [self ocj_refresh:ocj_dic];
}

- (void)ocj_refresh:(NSDictionary *)str{
    self.ocjBool_expand = YES;
    [self.ocjImg_log setImage:[UIImage imageNamed:@"icon_down"]];
    [self.ocj_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    if (self.handler) {
        self.handler(str);
    }
}
@end


@interface OCJRefundResonTVCell ()
@property (nonatomic,strong) UIButton * ocjBtn_selected;

@end
@implementation OCJRefundResonTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjBtn_selected];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.top.mas_equalTo(self.contentView).mas_equalTo(15);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.contentView).mas_equalTo(-15);
    }];
    
    [self.ocjBtn_selected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(17);
    }];

}
- (void)setOcjBool_isSelected:(BOOL)ocjBool_isSelected{
    if (ocjBool_isSelected) {
        [_ocjBtn_selected setBackgroundImage:[UIImage imageNamed:@"icon_unselected"] forState:UIControlStateNormal];
    }else{
        [_ocjBtn_selected setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    }
}
- (UIButton *)ocjBtn_selected{
    if (!_ocjBtn_selected) {
        _ocjBtn_selected = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ocjBtn_selected setBackgroundImage:[UIImage imageNamed:@"icon_unselected"] forState:UIControlStateNormal];
    }
    return _ocjBtn_selected;
}

- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"退货原因";
    }
    return _ocjLab_tip;
}
@end


@interface OCJRefundGoodsDescTVCell ()<UITextViewDelegate>

@property (nonatomic,strong) UIView  * ocjView_bg;
@property (nonatomic,strong) UILabel * ocjLab_tip;
@property (nonatomic,strong) UIView  * ocjView_line;
@property (nonatomic,strong) UILabel * ocjLab_num;
@end

@implementation OCJRefundGoodsDescTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_bg];
        [self.ocjView_bg addSubview:self.ocjLab_tip];
        [self.ocjView_bg addSubview:self.ocjView_line];
        [self.ocjView_bg addSubview:self.ocjTV_tip];
        [self.ocjView_bg addSubview:self.ocjLab_num];
        [self.contentView setNeedsUpdateConstraints];

    }
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];
    
    [self.ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
    }];
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_bg).offset(15);
        make.top.mas_equalTo(self.ocjView_bg).offset(15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    [self.ocjLab_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjView_bg).offset(-15);
        make.top.mas_equalTo(self.ocjView_bg).offset(15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.ocjLab_tip.mas_bottom).offset(15);
        make.height.mas_equalTo(0.5);
    }];
    [self.ocjTV_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_bg).offset(15);
        make.right.mas_equalTo(self.ocjView_bg).offset(-15);
        make.top.mas_equalTo(self.ocjView_line.mas_bottom).offset(15);
        make.bottom.mas_equalTo(self.ocjView_bg);
    }];
    
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"退货说明";
    }
    return _ocjLab_tip;
}
- (UILabel *)ocjLab_num{
    if (!_ocjLab_num) {
        _ocjLab_num = [[UILabel alloc]init];
        _ocjLab_num.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_num.font = [UIFont systemFontOfSize:14];
        _ocjLab_num.textAlignment = NSTextAlignmentRight;
    }
    return _ocjLab_num;
}
- (UIView *)ocjView_bg{
    if (!_ocjView_bg) {
        _ocjView_bg = [[UIView alloc]init];
        _ocjView_bg.backgroundColor = [UIColor whiteColor];
    }
    return _ocjView_bg;
}
- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [[UIView alloc]init];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"dddddd"];
    }
    return _ocjView_line;
}
- (OCJPlaceholderTextView *)ocjTV_tip{
    if (!_ocjTV_tip) {
        _ocjTV_tip = [[OCJPlaceholderTextView alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 180)];
        _ocjTV_tip.placeholder = @"请举例描述您退货的原因";
        _ocjTV_tip.font = [UIFont systemFontOfSize:14];
        _ocjTV_tip.tintColor = [UIColor redColor];
        _ocjTV_tip.PlaceholderLabel.textColor = [UIColor colorWSHHFromHexString:@"999999"];
        _ocjTV_tip.delegate = self;
    }
    return _ocjTV_tip;
}
- (void)setOcjStr_reson:(NSString *)ocjStr_reson{
    self.ocjTV_tip.text = ocjStr_reson;
    _ocjLab_num.text = [NSString stringWithFormat:@"%ld/%@",(200 - ocjStr_reson.length),@(200)];///< count是一个显示剩余可输入数字的label

}
- (void)textViewDidChange:(UITextView *)textView{
    NSUInteger count = 200 -  textView.text.length;
    _ocjLab_num.text = [NSString stringWithFormat:@"%ld/%@",count,@(200)];///< count是一个显示剩余可输入数字的label
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(range.location >= 200){
        [OCJProgressHUD ocj_showHudWithTitle:@"输入的自字符数不能超过200" andHideDelay:2];
        return NO;
    }else{
        return YES;
    }
}
@end

@interface OCJRefundGoodsUseTVCell ()

@property (nonatomic,strong) UILabel  * ocjLab_tip;
@property (nonatomic,strong) UILabel  * ocjLab_use;
@property (nonatomic,strong) UILabel  * ocjLab_unUse;
@property (nonatomic,strong) UIButton * ocjBtn_use;
@property (nonatomic,strong) UIButton * ocjBtn_unUse;
@property (nonatomic,strong) UIView   * ocjView_main;

@end
@implementation OCJRefundGoodsUseTVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_main];
        [self.ocjView_main addSubview:self.ocjLab_tip];
        [self.ocjView_main addSubview:self.ocjLab_unUse];
        [self.ocjView_main addSubview:self.ocjBtn_unUse];
        [self.ocjView_main addSubview:self.ocjLab_use];
        [self.ocjView_main addSubview:self.ocjBtn_use];
        [self.contentView setNeedsUpdateConstraints];

    }
    return self;
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_main).offset(15);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.ocjView_main);
    }];
    
    [self.ocjLab_unUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjView_main).offset(-15);
        make.centerY.mas_equalTo(self.ocjView_main);
        make.height.mas_equalTo(18.5);
    }];
    
    [self.ocjBtn_unUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjLab_unUse.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.ocjView_main);
        make.height.mas_equalTo(15.5);
        make.width.mas_equalTo(15.5);
    }];
    
    [self.ocjLab_use mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjBtn_unUse).offset(-20);
        make.centerY.mas_equalTo(self.ocjView_main);
        make.height.mas_equalTo(18.5);
    }];
    
    [self.ocjBtn_use mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjLab_use.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.ocjView_main);
        make.height.mas_equalTo(15.5);
        make.width.mas_equalTo(15.5);
    }];
    
    
}
- (UIView *)ocjView_main{
    if (!_ocjView_main) {
        _ocjView_main = [[UIView alloc]init];
        _ocjView_main.backgroundColor = [UIColor whiteColor];
    }
    return _ocjView_main;
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"收货后是否使用过";
    }
    return _ocjLab_tip;
}
- (UILabel *)ocjLab_use{
    if (!_ocjLab_use) {
        _ocjLab_use = [[UILabel alloc]init];
        _ocjLab_use.textColor = [UIColor colorWSHHFromHexString:@"666666"];
        _ocjLab_use.font = [UIFont systemFontOfSize:13];
        _ocjLab_use.text = @"使用过";
    }
    return _ocjLab_use;
}
- (UILabel *)ocjLab_unUse{
    if (!_ocjLab_unUse) {
        _ocjLab_unUse = [[UILabel alloc]init];
        _ocjLab_unUse.textColor = [UIColor colorWSHHFromHexString:@"666666"];
        _ocjLab_unUse.font = [UIFont systemFontOfSize:14];
        _ocjLab_unUse.text = @"未使用过";
    }
    return _ocjLab_unUse;
}
- (UIButton *)ocjBtn_unUse{
    if (!_ocjBtn_unUse) {
        _ocjBtn_unUse = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
        [_ocjBtn_unUse addTarget:self action:@selector(ocj_switchStatus:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_unUse;
}
- (UIButton *)ocjBtn_use{
    if (!_ocjBtn_use) {
        _ocjBtn_use = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ocjBtn_use setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [_ocjBtn_use addTarget:self action:@selector(ocj_switchStatus:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_use;
}
- (void)ocj_switchStatus:(UIButton *)button{
    if (button == self.ocjBtn_unUse) {
        [self.ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [self.ocjBtn_use setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }else{
        [self.ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
        [self.ocjBtn_use setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    }
    if (self.handler) {
        self.handler(button == self.ocjBtn_use?@"1":@"2");
    }
}



@end


@interface OCJRefundGoodsGoodTVCell ()

@property (nonatomic,strong) UILabel  * ocjLab_tip;
@property (nonatomic,strong) UILabel  * ocjLab_use;
@property (nonatomic,strong) UILabel  * ocjLab_unUse;
@property (nonatomic,strong) UIButton * ocjBtn_use;
@property (nonatomic,strong) UIButton * ocjBtn_unUse;
@property (nonatomic,strong) UIView   * ocjView_main;
@property (nonatomic,strong) UIView   * ocjView_line;

@end

@implementation OCJRefundGoodsGoodTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_main];
        [self.ocjView_main addSubview:self.ocjLab_tip];
        [self.ocjView_main addSubview:self.ocjLab_unUse];
        [self.ocjView_main addSubview:self.ocjBtn_unUse];
        [self.ocjView_main addSubview:self.ocjLab_use];
        [self.ocjView_main addSubview:self.ocjBtn_use];
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_main).offset(15);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.ocjView_main);
    }];
    
    [self.ocjLab_unUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjView_main).offset(-15);
        make.centerY.mas_equalTo(self.ocjView_main);
        make.height.mas_equalTo(18.5);
    }];
    
    [self.ocjBtn_unUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjLab_unUse.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.ocjView_main);
        make.height.mas_equalTo(15.5);
        make.width.mas_equalTo(15.5);
    }];
    
    [self.ocjLab_use mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjBtn_unUse).offset(-20);
        make.centerY.mas_equalTo(self.ocjView_main);
        make.height.mas_equalTo(18.5);
    }];
    
    [self.ocjBtn_use mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ocjLab_use.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.ocjView_main);
        make.height.mas_equalTo(15.5);
        make.width.mas_equalTo(15.5);
    }];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
}
- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [[UIView alloc]init];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    }
    return _ocjView_line;
}
- (UIView *)ocjView_main{
    if (!_ocjView_main) {
        _ocjView_main = [[UIView alloc]init];
        _ocjView_main.backgroundColor = [UIColor whiteColor];
    }
    return _ocjView_main;
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"商品是否完好";
    }
    return _ocjLab_tip;
}
- (UILabel *)ocjLab_use{
    if (!_ocjLab_use) {
        _ocjLab_use = [[UILabel alloc]init];
        _ocjLab_use.textColor = [UIColor colorWSHHFromHexString:@"666666"];
        _ocjLab_use.font = [UIFont systemFontOfSize:13];
        _ocjLab_use.text = @"是";
    }
    return _ocjLab_use;
}
- (UILabel *)ocjLab_unUse{
    if (!_ocjLab_unUse) {
        _ocjLab_unUse = [[UILabel alloc]init];
        _ocjLab_unUse.textColor = [UIColor colorWSHHFromHexString:@"666666"];
        _ocjLab_unUse.font = [UIFont systemFontOfSize:14];
        _ocjLab_unUse.text = @"否";
    }
    return _ocjLab_unUse;
}
- (UIButton *)ocjBtn_unUse{
    if (!_ocjBtn_unUse) {
        _ocjBtn_unUse = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
        [_ocjBtn_unUse addTarget:self action:@selector(ocj_switchStatus:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_unUse;
}
- (UIButton *)ocjBtn_use{
    if (!_ocjBtn_use) {
        _ocjBtn_use = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ocjBtn_use setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [_ocjBtn_use addTarget:self action:@selector(ocj_switchStatus:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_use;
}
- (void)ocj_switchStatus:(UIButton *)button{
    if (button == self.ocjBtn_unUse) {
        [self.ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [self.ocjBtn_use setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }else{
        [self.ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
        [self.ocjBtn_use setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    }
    if (self.handler) {
        self.handler(button == self.ocjBtn_use ?@"1":@"2");
    }
}


@end


@interface OCJRefundGoodsLessTVCell ()
@property (nonatomic,strong) UILabel  * ocjLab_tip;
@property (nonatomic,strong) UIButton * ocjBtn_unUse;
@property (nonatomic,strong) UIView   * ocjView_line;
@property (nonatomic,assign) BOOL  ocjBool_sel;
@end

@implementation OCJRefundGoodsLessTVCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjBtn_unUse];
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints{
    [super updateConstraints];
    
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.ocjBtn_unUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(17);
    }];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];

}


- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [[UIView alloc]init];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    }
    return _ocjView_line;
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"缺少主赠品";
    }
    return _ocjLab_tip;
}

- (UIButton *)ocjBtn_unUse{
    if (!_ocjBtn_unUse) {
        _ocjBtn_unUse = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
        [_ocjBtn_unUse addTarget:self action:@selector(ocj_switch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_unUse;
}
- (void)ocj_switch{
    self.ocjBool_sel = !self.ocjBool_sel;
    if (self.ocjBool_sel) {
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    }else{
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }
    if (self.handler) {
        self.handler(self.ocjBool_sel?@"2":@"1");
    }
}
@end

@interface OCJRefundGoodsDamageTVCell ()
@property (nonatomic,strong) UILabel  * ocjLab_tip;
@property (nonatomic,strong) UIButton * ocjBtn_unUse;
@property (nonatomic,assign) BOOL     ocjBool_sel;
@end

@implementation OCJRefundGoodsDamageTVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjBtn_unUse];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints{
    [super updateConstraints];
    
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.ocjBtn_unUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(17);
    }];
    
}

- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"外包装损坏";
    }
    return _ocjLab_tip;
}

- (UIButton *)ocjBtn_unUse{
    if (!_ocjBtn_unUse) {
        _ocjBtn_unUse = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
        [_ocjBtn_unUse addTarget:self action:@selector(ocj_switch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_unUse;
}
- (void)ocj_switch{
    self.ocjBool_sel = !self.ocjBool_sel;
    if (self.ocjBool_sel) {
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    }else{
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }
    if (self.handler) {
        self.handler(self.ocjBool_sel ?@"2":@"1");
    }
}

@end


@interface OCJRefundGoodsMethodTVCell ()
@property (nonatomic,strong) UILabel  * ocjLab_tip;
@property (nonatomic,strong) UIView   * ocjView_main;
@property (nonatomic,strong) UIView   * ocjView_line;
@end

@implementation OCJRefundGoodsMethodTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_main];
        [self.ocjView_main addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjView_line];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_main).offset(15);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.ocjView_main);
    }];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
}
- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [[UIView alloc]init];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    }
    return _ocjView_line;
}
- (UIView *)ocjView_main{
    if (!_ocjView_main) {
        _ocjView_main = [[UIView alloc]init];
        _ocjView_main.backgroundColor = [UIColor whiteColor];
    }
    return _ocjView_main;
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"退款方式";
    }
    return _ocjLab_tip;
}


@end

@interface OCJRefundGoodsPreTVCell ()
@property (nonatomic,strong) UILabel  * ocjLab_tip;
@property (nonatomic,strong) UIButton * ocjBtn_unUse;
@property (nonatomic,strong) UIView   * ocjView_line;
@property (nonatomic,assign) BOOL      ocjBool_sel;
@end

@implementation OCJRefundGoodsPreTVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjBtn_unUse];
        [self.contentView addSubview:self.ocjView_line];
        if (self.handler) {
            self.handler(@"NO");
        }
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints{
    [super updateConstraints];
    
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.ocjBtn_unUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(17);
    }];
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
}
- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [[UIView alloc]init];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    }
    return _ocjView_line;
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"转预付款";
    }
    return _ocjLab_tip;
}

- (UIButton *)ocjBtn_unUse{
    if (!_ocjBtn_unUse) {
        _ocjBtn_unUse = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
        [_ocjBtn_unUse addTarget:self action:@selector(ocj_switch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_unUse;
}

- (void)ocj_switch{
    self.ocjBool_sel = !self.ocjBool_sel;
    if (self.ocjBool_sel) {
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    }else{
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }
    if (self.handler) {
        self.handler(self.ocjBool_sel?@"YES":@"NO");
    }
}

@end

@interface OCJRefundGoodsOriginalTVCell ()
@property (nonatomic,strong) UILabel  * ocjLab_tip;
@property (nonatomic,strong) UILabel  * ocjLab_second;

@end

@implementation OCJRefundGoodsOriginalTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.ocjLab_tip];
        [self.contentView addSubview:self.ocjLab_second];
        [self.contentView addSubview:self.ocjBtn_unUse];
        if (self.handler) {
            self.handler(@"NO");
        }
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints{
    [super updateConstraints];
    
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.ocjLab_second mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_tip);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(self.ocjLab_tip.mas_bottom);
    }];
    
    [self.ocjBtn_unUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(17);
    }];
    
}

- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"原支付方式退回";
    }
    return _ocjLab_tip;
}
- (UILabel *)ocjLab_second{
    if (!_ocjLab_second) {
        _ocjLab_second = [[UILabel alloc]init];
        _ocjLab_second.textColor = [UIColor colorWSHHFromHexString:@"666666"];
        _ocjLab_second.font = [UIFont systemFontOfSize:11];
        _ocjLab_second.text = @"现金加密退回";
    }
    return _ocjLab_second;
}

- (UIButton *)ocjBtn_unUse{
    if (!_ocjBtn_unUse) {
        _ocjBtn_unUse = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
        [_ocjBtn_unUse addTarget:self action:@selector(ocj_switch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_unUse;
}
- (void)ocj_switch{
    self.ocjBool_sel = !self.ocjBool_sel;
    if (self.ocjBool_sel) {
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    }else{
        [_ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }
    if (self.handler) {
        self.handler(self.ocjBool_sel ? @"YES":@"NO");
    }
}
@end

@interface OCJRefundUpLoadImgTipTVCell()

@property (nonatomic,strong) UIView  * ocjView_main;
@property (nonatomic,strong) UIView  * ocjView_line;///< 分割线
@property (nonatomic,strong) UILabel * ocjLab_tip;

@end

@implementation OCJRefundUpLoadImgTipTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        [self.contentView addSubview:self.ocjView_main];
        [self.ocjView_main addSubview:self.ocjView_line];
        [self.ocjView_main addSubview:self.ocjLab_tip];

    }
    return self;
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_main).offset(15);
        make.top.mas_equalTo(self.ocjView_main).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_main);
        make.right.mas_equalTo(self.ocjView_main);
        make.top.mas_equalTo(self.ocjLab_tip.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
}
- (UIView *)ocjView_main{
    if (!_ocjView_main) {
        _ocjView_main = [[UIView alloc]init];
        _ocjView_main.backgroundColor = [UIColor whiteColor];
    }
    return _ocjView_main;
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"上传凭证（可选，最多9张）";
    }
    return _ocjLab_tip;
}
- (UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [[UIView alloc]init];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    }
    return _ocjView_line;
}
@end

@interface OCJRefundGoodsBottomTVCell ()



@end

@implementation OCJRefundGoodsBottomTVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_bottom];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
}


- (OCJUploadImageView *)ocjView_bottom{
    if (!_ocjView_bottom) {
        _ocjView_bottom = [[OCJUploadImageView alloc]init];
    }
    return _ocjView_bottom;
}

@end
