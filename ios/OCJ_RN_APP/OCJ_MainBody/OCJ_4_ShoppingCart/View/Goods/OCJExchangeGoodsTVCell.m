//
//  OCJExchangeGoodsTVCell.m
//  OCJ
//
//  Created by OCJ on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJExchangeGoodsTVCell.h"
#import "OCJPlaceholderTextView.h"
#import "OCJUploadImageView.h"
#import "OCJGoodsCaulateView.h" ///< 计算

@interface OCJExchangeGoodsTVCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel          * ocjLab_tip;
@property (nonatomic,strong) UILabel          * ocjLab_line;
@property (nonatomic,strong) UIButton         * ocjBtn_show;
@property (nonatomic,strong) UILabel          * ocjLab_title;
@property (nonatomic,strong) UIImageView      * ocjImg_log;
@property (nonatomic,assign) BOOL               ocjBool_expand;
@property (nonatomic,strong) NSIndexPath      * index;///< 当前选中状态

@end

@implementation OCJExchangeGoodsTVCell

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
- (NSMutableArray *)ocjArr_dataSource{
    if (!_ocjArr_dataSource) {
        _ocjArr_dataSource = [NSMutableArray array];
    }
    return _ocjArr_dataSource;
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
        make.top.mas_equalTo(self.ocjLab_tip.mas_bottom).offset(14.5);
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
        _ocjLab_tip.text = @"换货原因";
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
    OCJExchangeGoodsResonTVCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OCJExchangeGoodsResonTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary * ocj_dic = [self.ocjArr_dataSource objectAtIndex:indexPath.row];
  
    cell.ocjLab_tip.text = [NSString stringWithFormat:@"%@. %@",[NSString stringWithFormat:@"%ld",indexPath.row + 1],ocj_dic[@"REASON"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * ocj_dic = [self.ocjArr_dataSource objectAtIndex:indexPath.row];
    self.ocjLab_title.text = [NSString stringWithFormat:@"%@", ocj_dic[@"REASON"]];

    //之前选中的取消选择
    OCJExchangeGoodsResonTVCell * cell  =[tableView cellForRowAtIndexPath:self.index];
    cell.ocjBool_isSelected = YES;
    self.index = indexPath;

    
    //
    OCJExchangeGoodsResonTVCell * currentCell  =[tableView cellForRowAtIndexPath:indexPath];
    currentCell.ocjBool_isSelected = NO;
    [self ocj_refresh:self.ocjArr_dataSource [indexPath.row]];
}
- (void)ocj_refresh:(NSDictionary *)dic{
    self.ocjBool_expand = YES;
    [self.ocjImg_log setImage:[UIImage imageNamed:@"icon_down"]];
    [self.ocj_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    if (self.handler) {
        self.handler(dic);
    }
}

@end

@interface OCJExchangeGoodsResonTVCell ()
@property (nonatomic,strong) UIButton * ocjBtn_selected;

@end
@implementation OCJExchangeGoodsResonTVCell

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
        _ocjLab_tip.text = @"换货原因";
    }
    return _ocjLab_tip;
}
@end

@interface OCJExchangeGoodsDescTVCell ()<UITextViewDelegate>

@property (nonatomic,strong) UIView  * ocjView_bg;
@property (nonatomic,strong) UILabel * ocjLab_tip;
@property (nonatomic,strong) UIView  * ocjView_line;
@property (nonatomic,strong) UILabel * ocjLab_num;
@property (nonatomic,copy)   NSString               * ocjStr_reson;
@property (nonatomic,strong) OCJPlaceholderTextView * ocjTV_tip;

@end

@implementation OCJExchangeGoodsDescTVCell

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
        _ocjLab_tip.text = @"换货说明";
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
        _ocjTV_tip.placeholder = @"请举例描述您换货的原因";
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
    if (self.handler) {
        self.handler(textView.text);
    }
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




@interface OCJGoodsDescTVCell ()
@property (nonatomic,strong) UIView  * ocjView_main;
@property (nonatomic,strong) UIView  * ocjView_line;
@property (nonatomic,strong) UILabel * ocjLab_tip;        ///< 商品名称
@property (nonatomic,strong) UIButton *ocjBtn_goodProp;   ///<
@property (nonatomic,strong) UIImageView * ocjImg_indicator;
@property (nonatomic,strong) OCJGoodsCaulateView * ocjView_calculate; ///< 计算View


@end

@implementation OCJGoodsDescTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_main];
        [self.ocjView_main addSubview:self.ocjLab_tip];
        [self.ocjView_main addSubview:self.ocjView_line];
        [self.ocjView_main addSubview:self.ocjImg_goodDes];
        [self.ocjView_main addSubview:self.ocjLab_goodName];
        [self.ocjView_main addSubview:self.ocjBtn_goodProp];
        [self.ocjBtn_goodProp addSubview:self.ocjLab_goodProp];
        [self.ocjView_main addSubview:self.ocjImg_indicator];
        [self.ocjView_main addSubview:self.ocjView_calculate];
        [self.contentView setNeedsUpdateConstraints];
        
    }
    return self;
}
- (void)updateConstraints{
    [super updateConstraints];
    [self.ocjView_main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).mas_equalTo(10);
    }];
    
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_main).mas_offset(15);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.ocjView_main).mas_offset(15);
    }];
    
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_main);
        make.right.mas_equalTo(self.ocjView_main);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.ocjLab_tip.mas_bottom).mas_offset(15);
    }];
    [self.ocjImg_goodDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_main).offset(15);
        make.top.mas_equalTo(self.ocjView_line).offset(12.5);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90);
    }];
    [self.ocjLab_goodName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImg_goodDes.mas_right).offset(10);
        make.right.mas_equalTo(self.ocjView_main.mas_right).offset(-15);
        make.top.mas_equalTo(self.ocjImg_goodDes);
    }];
    
    [self.ocjBtn_goodProp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_goodName);
        make.right.mas_equalTo(self.ocjLab_goodName);
        make.top.mas_equalTo(self.ocjLab_goodName.mas_bottom);
        make.height.mas_equalTo(24);
    }];
    
    [self.ocjLab_goodProp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_goodProp.mas_left).offset(15);
        make.centerY.mas_equalTo(self.ocjBtn_goodProp);
    }];
    
    [self.ocjImg_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(7.5);
        make.right.mas_equalTo(self.ocjBtn_goodProp).offset(-10);
        make.centerY.mas_equalTo(self.ocjBtn_goodProp);
    }];
    
    [self.ocjView_calculate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjBtn_goodProp);
        make.right.mas_equalTo(self.ocjBtn_goodProp);
        make.top.mas_equalTo(self.ocjBtn_goodProp.mas_bottom).offset(5);
        make.height.mas_equalTo(25);
    }];
    
}

- (OCJGoodsCaulateView *)ocjView_calculate{
    if (!_ocjView_calculate) {
        _ocjView_calculate = [[OCJGoodsCaulateView alloc]init];
        _ocjView_calculate.backgroundColor = [UIColor whiteColor];
    }
    return _ocjView_calculate;
}
-(UIView *)ocjView_line{
    if (!_ocjView_line) {
        _ocjView_line = [[UIView alloc]init];
        _ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
    }
    return _ocjView_line;
}
-(UIView *)ocjView_main{
    if (!_ocjView_main) {
        _ocjView_main = [[UIView alloc]init];
        _ocjView_main.backgroundColor = [UIColor whiteColor];
    }
    return _ocjView_main;
}
- (UIImageView *)ocjImg_goodDes{
    if (!_ocjImg_goodDes) {
        _ocjImg_goodDes = [[UIImageView alloc]init];
    }
    return _ocjImg_goodDes;
}
- (UIImageView *)ocjImg_indicator{
    if (!_ocjImg_indicator) {
        _ocjImg_indicator = [[UIImageView alloc]init];
        [_ocjImg_indicator setImage:[UIImage imageNamed:@"arrow"]];
    }
    return _ocjImg_indicator;
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.text = @"请选择您要换的商品";
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    }
    return _ocjLab_tip;
}

- (UILabel *)ocjLab_goodName{
    if (!_ocjLab_goodName) {
        _ocjLab_goodName = [[UILabel alloc]init];
        _ocjLab_goodName.text = @"博朗（Braun）HD580家用便携大功率离子电吹风";
        _ocjLab_goodName.numberOfLines = 2;
        _ocjLab_goodName.font = [UIFont systemFontOfSize:14];
        _ocjLab_goodName.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    }
    return _ocjLab_goodName;
}

- (UILabel *)ocjLab_goodProp{
    if (!_ocjLab_goodProp) {
        _ocjLab_goodProp = [[UILabel alloc]init];
        _ocjLab_goodProp.text = @"重量：1.2kg  颜色：BCO410";
        _ocjLab_goodProp.font = [UIFont systemFontOfSize:12];
        _ocjLab_goodProp.textColor = [UIColor colorWSHHFromHexString:@"666666"];
        _ocjLab_goodProp.backgroundColor = [UIColor colorWSHHFromHexString:@"EEEEEE"];
        _ocjLab_goodProp.layer.masksToBounds = YES;
        _ocjLab_goodProp.layer.cornerRadius = 4;
    }
    return _ocjLab_goodProp;
}

- (UIButton *)ocjBtn_goodProp {
    if (!_ocjBtn_goodProp) {
        _ocjBtn_goodProp = [[UIButton alloc] init];
        [_ocjBtn_goodProp setTitleColor:OCJ_COLOR_DARK_GRAY forState:UIControlStateNormal];
        _ocjBtn_goodProp.backgroundColor = [UIColor colorWSHHFromHexString:@"EEEEEE"];
        [_ocjBtn_goodProp addTarget:self action:@selector(ocj_clickedGoodPropBtn) forControlEvents:UIControlEventTouchUpInside];
        _ocjBtn_goodProp.layer.cornerRadius = 4;
    }
    return _ocjBtn_goodProp;
}

/**
 点击选择想要更换的商品规格
 */
- (void)ocj_clickedGoodPropBtn {
    if (self.ocjChooseGoodSpecblock) {
        self.ocjChooseGoodSpecblock();
    }
}

@end












@interface OCJExchangeGoodsGoodsUseTVCell()
@property (nonatomic,strong) UILabel  * ocjLab_tip;
@property (nonatomic,strong) UILabel  * ocjLab_use;
@property (nonatomic,strong) UILabel  * ocjLab_unUse;
@property (nonatomic,strong) UIButton * ocjBtn_use;
@property (nonatomic,strong) UIButton * ocjBtn_unUse;
@property (nonatomic,strong) UIView   * ocjView_main;
@end

@implementation OCJExchangeGoodsGoodsUseTVCell

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
        if (self.handler) {
            self.handler(@"2");
        }
        [self.ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [self.ocjBtn_use setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }else{
        if (self.handler) {
            self.handler(@"1");
        }        [self.ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
        [self.ocjBtn_use setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    }
}


@end



@interface OCJExchangeGoodsDamageTVCell ()
@property (nonatomic,strong) UILabel  * ocjLab_tip;
@property (nonatomic,strong) UILabel  * ocjLab_use;
@property (nonatomic,strong) UILabel  * ocjLab_unUse;
@property (nonatomic,strong) UIButton * ocjBtn_use;
@property (nonatomic,strong) UIButton * ocjBtn_unUse;
@property (nonatomic,strong) UIView   * ocjView_main;
@end

@implementation OCJExchangeGoodsDamageTVCell



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
        _ocjLab_tip.text = @"缺少主赠品或包装损坏";
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
        if (self.handler) {
            self.handler(@"2");
        }        [self.ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [self.ocjBtn_use setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
    }else{
        if (self.handler) {
            self.handler(@"1");
        }
        [self.ocjBtn_unUse setBackgroundImage:[UIImage imageNamed:@"icon_unSelected"] forState:UIControlStateNormal];
        [self.ocjBtn_use setBackgroundImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    }

}

@end


@interface OCJExchangeGoodsBottomTVCell ()

@property (nonatomic,strong) UIView  * ocjView_main;
@property (nonatomic,strong) UIView  * ocjView_line;///< 分割线
@property (nonatomic,strong) UILabel * ocjLab_tip;

@end

@implementation OCJExchangeGoodsBottomTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjView_main];
        [self.ocjView_main addSubview:self.ocjLab_tip];
        [self.ocjView_main addSubview:self.ocjView_line];
        [self.ocjView_main addSubview:self.ocjView_bottom];
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
        make.top.mas_equalTo(self.ocjView_main).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_main);
        make.right.mas_equalTo(self.ocjView_main);
        make.top.mas_equalTo(self.ocjLab_tip.mas_bottom).offset(15);
        make.height.mas_equalTo(1);
    }];
    
    [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_main);
        make.right.mas_equalTo(self.ocjView_main);
        make.bottom.mas_equalTo(self.ocjView_main);
        make.top.mas_equalTo(self.ocjView_line.mas_bottom);
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
- (OCJUploadImageView *)ocjView_bottom{
    if (!_ocjView_bottom) {
        _ocjView_bottom = [[OCJUploadImageView alloc]init];
    }
    return _ocjView_bottom;
}

@end
