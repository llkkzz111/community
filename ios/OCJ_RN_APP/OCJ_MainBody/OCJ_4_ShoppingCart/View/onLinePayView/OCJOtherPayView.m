//
//  OCJOtherPayView.m
//  OCJ
//
//  Created by OCJ on 2017/5/5.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJOtherPayView.h"
#import <objc/runtime.h>

static char actionKey1; ///< handler暂存地址

@interface OCJOtherPayView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,copy)   NSString * ocjStr_title;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * bankCardArrays;
@property (nonatomic,assign) NSIndexPath * index;
@property (nonatomic, strong) OCJOtherPayModel *ocjModel_selected;///<选中的支付方式

@end

@implementation OCJOtherPayView

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (NSDictionary * dic in self.bankCardArrays) {
            OCJOtherPayModel * model = [[OCJOtherPayModel alloc]init];
            model.ocjStr_id          = [dic objectForKey:@"id"];
            model.ocjStr_title       = [dic objectForKey:@"title"];
          model.ocjStr_imageUrl      = [dic objectForKey:@"iocnUrl"];
          model.ocjStr_activity      = [dic objectForKey:@"eventContent"];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

+ (void)ocj_popPayViewWithTitle:(NSString *)title bankCardArrays:(NSMutableArray *)array completion:(OCJOtherPayViewHandler)handler{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    
    OCJOtherPayView * payView = [[OCJOtherPayView alloc]initWithFrame:window.bounds];
    payView.ocjStr_title = title;
    payView.bankCardArrays = array;
    [window addSubview:payView];
    
    objc_setAssociatedObject(payView, &actionKey1, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:payView action:@selector(ocj_dismissView) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWSHHFromHexString:@"333333"];
    button.alpha = 0.6;
    [payView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(payView);
    }];

    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = [payView ocj_TableViewHeader];
    tableView.tableFooterView = [payView ocj_TableViewFooter];
    tableView.scrollEnabled = NO;
    tableView.delegate = payView;
    tableView.dataSource = payView;
    [payView addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(payView.mas_left);
        make.right.mas_equalTo(payView.mas_right);
        make.bottom.mas_equalTo(payView);
        make.height.mas_equalTo(payView.dataArray.count * 44 + 125);
    }];
    
}
- (void)ocj_dismissView{
  OCJOtherPayViewHandler handler = objc_getAssociatedObject(self, &actionKey1);
  if (handler) {
    handler(self.ocjModel_selected);//传输选择地址数据
  }
    [self removeFromSuperview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"WSHHOtherPayCellIdentifier";
    OCJOtherPayCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[OCJOtherPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    OCJOtherPayModel *model  = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//之前选中的取消选择
    OCJOtherPayCell * cell  =[tableView cellForRowAtIndexPath:self.index];
    OCJOtherPayModel * model = [self.dataArray objectAtIndex:self.index.row];
    model.ocjBool_isSelected = NO;
    [cell setModel:model];
    self.index = indexPath;

    //
    OCJOtherPayCell * currentCell  =[tableView cellForRowAtIndexPath:indexPath];
    self.ocjModel_selected = (OCJOtherPayModel *)[self.dataArray objectAtIndex:indexPath.row];
    self.ocjModel_selected.ocjBool_isSelected = YES;
    [currentCell setModel:self.ocjModel_selected];
  
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = [self ocj_TableViewHeader];
        _tableView.tableFooterView = [self ocj_TableViewFooter];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (UIView *)ocj_TableViewHeader{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    headerView.backgroundColor = [UIColor whiteColor];

    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [headerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView);
        make.right.mas_equalTo(headerView);
        make.bottom.mas_equalTo(headerView);
        make.height.mas_equalTo(0.5);
    }];
    
    OCJBaseLabel * ocjLab_tip = [[OCJBaseLabel alloc]init];
    ocjLab_tip.text = @"其他在线支付方式";
    ocjLab_tip.font = [UIFont systemFontOfSize:14];
    ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    [headerView addSubview:ocjLab_tip];
    
    [ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView).offset(40);
        make.left.mas_equalTo(headerView.mas_left).offset(20);
    }];
    
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"icon_clear"] forState:UIControlStateNormal];
    [headerView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(ocj_removeView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ocjLab_tip);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(headerView.mas_right).offset(-15);
    }];
    
    return headerView;
}
- (void)ocj_removeView{
  OCJOtherPayViewHandler handler = objc_getAssociatedObject(self, &actionKey1);
  if (handler) {
    handler(self.ocjModel_selected);//传输选择地址数据
  }
    [self removeFromSuperview];
}
- (UIView *)ocj_TableViewFooter{
    UIView * fooerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45)];
    fooerView.backgroundColor = [UIColor whiteColor];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(ocj_dismissView) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = [UIColor colorWSHHFromHexString:@"E5290D"];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [fooerView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(fooerView.mas_left);
        make.right.mas_equalTo(fooerView.mas_right);
        make.bottom.mas_equalTo(fooerView.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    return fooerView;
}
@end





@interface OCJOtherPayCell()

@property (nonatomic,strong) UIImageView * ocjImage_log;
@property (nonatomic,strong) OCJBaseLabel     * ocjLab_bank;
@property (nonatomic,strong) UIImageView * ocjImage_sel;
@property (nonatomic,strong) UILabel *ocjLab_activity;///<活动

@end


@implementation OCJOtherPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.ocjImage_log];
        [self.contentView addSubview:self.ocjLab_bank];
        [self.contentView addSubview:self.ocjImage_sel];
      [self.contentView addSubview:self.ocjLab_activity];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}
-(void)updateConstraints{
    [super updateConstraints];
    [self.ocjImage_log mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
    }];

  [self.ocjLab_bank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(18.5);
        make.left.mas_equalTo(self.ocjImage_log.mas_right).offset(15);
    }];
    
    [self.ocjImage_sel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(17);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
  
  [self.ocjLab_activity mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ocjLab_bank.mas_right).offset(10);
    make.right.mas_equalTo(self.ocjImage_sel.mas_left).offset(-10);
    make.centerY.mas_equalTo(self.contentView);
  }];
}
- (void)setModel:(OCJOtherPayModel *)model{
    self.ocjLab_bank.text = model.ocjStr_title;
  self.ocjLab_activity.text = model.ocjStr_activity;
  [self.ocjImage_log ocj_setWebImageWithURLString:model.ocjStr_imageUrl completion:nil];
    if (model.ocjBool_isSelected) {
        [self.ocjImage_sel setImage:[UIImage imageNamed:@"Icon_selected"]];
        self.ocjLab_bank.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    }else{
        [self.ocjImage_sel setImage:nil];
        self.ocjLab_bank.textColor = [UIColor colorWSHHFromHexString:@"999999"];
    }
}
- (UIImageView *)ocjImage_log{
    if (!_ocjImage_log) {
        _ocjImage_log = [[UIImageView alloc]init];
        _ocjImage_log.backgroundColor = [UIColor colorWSHHFromHexString:@"D8D8D8"];
        _ocjImage_log.layer.masksToBounds = YES;
    }
    return _ocjImage_log;
}

- (OCJBaseLabel *)ocjLab_bank{
    if (!_ocjLab_bank) {
        _ocjLab_bank = [[OCJBaseLabel alloc]init];
        _ocjLab_bank.font = [UIFont systemFontOfSize:13];
        _ocjLab_bank.textColor = [UIColor colorWSHHFromHexString:@"999999"];
        _ocjLab_bank.textAlignment = NSTextAlignmentLeft;
    }
    return _ocjLab_bank;
}

- (UIImageView *)ocjImage_sel{
    if (!_ocjImage_sel) {
        _ocjImage_sel = [[UIImageView alloc]init];
        _ocjImage_sel.layer.masksToBounds = YES;
    }
    return _ocjImage_sel;
}

- (UILabel *)ocjLab_activity {
  if (!_ocjLab_activity) {
    _ocjLab_activity = [[UILabel alloc] init];
    _ocjLab_activity.font = [UIFont systemFontOfSize:12];
    _ocjLab_activity.textColor = [UIColor colorWSHHFromHexString:@"#EA543D"];
    _ocjLab_activity.textAlignment = NSTextAlignmentLeft;
  }
  return _ocjLab_activity;
}

@end

@implementation OCJOtherPayModel

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//  if (value && ![value isKindOfClass:[NSNull class]]) {
//    if ([key isEqualToString:@"id"]) {
//      self.ocjStr_id = [value description];
//    }else if ([key isEqualToString:@"title"]) {
//      self.ocjStr_title = [value description];
//    }else if ([key isEqualToString:@"iocnUrl"]) {
//      self.ocjStr_imageUrl = [value description];
//    }else if ([key isEqualToString:@"eventContent"]) {
//      self.ocjStr_activity = [value description];
//    }
//  }
//}

@end
