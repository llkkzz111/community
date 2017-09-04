//
//  OCJChooseGiftView.m
//  OCJ
//
//  Created by Ray on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJChooseGiftView.h"
#import "OCJChooseGiftTVCell.h"

@interface OCJChooseGiftView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *ocjView_bg;               ///<背景
@property (nonatomic, strong) UIView *ocjView_container;        ///<显示商品信息view

@property (nonatomic, strong) UIView *ocjView_head;             ///<头部view
@property (nonatomic, strong) UILabel *ocjLab_gift;             ///<赠品

@property (nonatomic, strong) OCJBaseTableView *ocjTBView_gift; ///<tableView
@property (nonatomic, strong) UIView *ocjView_bottom;           ///<底部view
@property (nonatomic, strong) UILabel *ocjLab_alreadyGet;       ///<已领取
@property (nonatomic, strong) UIButton *ocjBtn_confirm;         ///<确认按钮

@property (nonatomic, strong) NSArray *ocjArr_giftDesc;         ///<赠品数组
@property (nonatomic, strong) NSString *ocjStr_giftTitle;       ///<选中的商品名称

@property (nonatomic, strong) NSDictionary *ocjDic_data;        ///<
@property (nonatomic, strong) NSMutableArray *ocjArr_isSelected;///<

@end

@implementation OCJChooseGiftView

- (NSMutableArray *)ocjArr_isSelected {
    if (!_ocjArr_isSelected) {
        _ocjArr_isSelected = [[NSMutableArray alloc] init];
    }
    return _ocjArr_isSelected;
}

- (instancetype)initWithGiftTitle:(NSString *)ocjStr_title array:(NSArray *)ocjArr_gift {
    self = [super init];
    if (self) {
        /*
        self.ocjStr_selectedGift = @"Panasonic/松下 F-CM339C纳米落地电风扇水离子自然风静音家用";
        NSArray *tempArr = @[@"YES",@"NO",@"NO"];
        [self.ocjArr_isSelected addObjectsFromArray:tempArr];
         */
        
        self.ocjStr_giftTitle = ocjStr_title;
        self.ocjArr_giftDesc = ocjArr_gift;
        
        [self ocj_setSelf];
    }
    return self;
}

- (void)ocj_setSelf {
    //背景
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_closeAction)];
    
    self.ocjView_bg = [[UIView alloc] init];
    self.ocjView_bg.backgroundColor = [UIColor colorWSHHFromHexString:@"000000"];
    self.ocjView_bg.alpha = 0.4;
    [self.ocjView_bg addGestureRecognizer:tap];
    [self addSubview:self.ocjView_bg];
    [self.ocjView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
    //底部显示商品信息view
    self.ocjView_container = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 2 / 3.0)];
    self.ocjView_container.backgroundColor = OCJ_COLOR_BACKGROUND;
    [self addSubview:self.ocjView_container];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.ocjView_container.frame = CGRectMake(0, SCREEN_HEIGHT / 3.0, SCREEN_WIDTH, SCREEN_HEIGHT * 2 / 3.0);
    }];
    [self ocj_addHeadView];
    [self ocj_addBottomView];
    [self ocj_addTableView];
}

/**
 顶部视图
 */
- (void)ocj_addHeadView {
    self.ocjView_head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    self.ocjView_head.backgroundColor = OCJ_COLOR_BACKGROUND;
    [self.ocjView_container addSubview:self.ocjView_head];
    //领取赠品
    UILabel *ocjLab_title = [[UILabel alloc] init];
    ocjLab_title.text = @"领取赠品";
    ocjLab_title.font = [UIFont systemFontOfSize:15];
    ocjLab_title.textColor = OCJ_COLOR_DARK;
    ocjLab_title.textAlignment = NSTextAlignmentCenter;
    [self.ocjView_head addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjView_head.mas_top).offset(20);
        make.centerX.mas_equalTo(self.ocjView_head);
    }];
    //关闭按钮
    UIButton *ocjBtn_close = [[UIButton alloc] init];
    [ocjBtn_close setImage:[UIImage imageNamed:@"icon_clear"] forState:UIControlStateNormal];
    [ocjBtn_close addTarget:self action:@selector(ocj_closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_head addSubview:ocjBtn_close];
    [ocjBtn_close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.ocjView_head);
        make.width.height.mas_equalTo(@40);
    }];
    //赠品
    UILabel *ocjLab_getGift = [[UILabel alloc] init];
    ocjLab_getGift.text = @"可领1件赠品";
    ocjLab_getGift.font = [UIFont systemFontOfSize:13];
    ocjLab_getGift.textColor = OCJ_COLOR_DARK_GRAY;
    ocjLab_getGift.textAlignment = NSTextAlignmentLeft;
    [self.ocjView_head addSubview:ocjLab_getGift];
    [ocjLab_getGift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_head.mas_left).offset(15);
        make.top.mas_equalTo(ocjLab_title.mas_bottom).offset(30);
    }];
    /*
    //已选赠品
    self.ocjLab_gift = [[UILabel alloc] init];
    OCJResponceModel_giftDesc *model = self.ocjArr_giftDesc[self.ocjInt_index];
    self.ocjStr_selectedGift = model.ocjStr_itemName;
    self.ocjLab_gift.text = [NSString stringWithFormat:@"已选赠品：%@", self.ocjStr_selectedGift];
    self.ocjLab_gift.font = [UIFont systemFontOfSize:12];
    self.ocjLab_gift.textColor = OCJ_COLOR_LIGHT_GRAY;
    self.ocjLab_gift.numberOfLines = 2;
    self.ocjLab_gift.textAlignment = NSTextAlignmentLeft;
    [self.ocjView_head addSubview:self.ocjLab_gift];
    [self.ocjLab_gift mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_head.mas_left).offset(15);
        make.top.mas_equalTo(ocjLab_getGift.mas_bottom).offset(3);
        make.right.mas_equalTo(self.ocjView_head.mas_right).offset(-15);
    }];
     */
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self.ocjView_head addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_head.mas_left).offset(15);
        make.right.mas_equalTo(self.ocjView_head.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.ocjView_head);
        make.height.mas_equalTo(@0.5);
    }];
}

/**
 底部确定视图
 */
- (void)ocj_addBottomView {
    self.ocjView_bottom = [[UIView alloc] init];
    self.ocjView_bottom.backgroundColor = OCJ_COLOR_BACKGROUND;
    [self.ocjView_container addSubview:self.ocjView_bottom];
    [self.ocjView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.ocjView_container);
        make.height.mas_equalTo(@60);
    }];
    //确认按钮
    self.ocjBtn_confirm= [[UIButton alloc] init];
    [self.ocjBtn_confirm setTitle:@"确定" forState:UIControlStateNormal];
    [self.ocjBtn_confirm setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    self.ocjBtn_confirm.titleLabel.font = [UIFont systemFontOfSize:15];
    self.ocjBtn_confirm.backgroundColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    [self.ocjBtn_confirm addTarget:self action:@selector(ocj_clickedConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_bottom addSubview:self.ocjBtn_confirm];
    [self.ocjBtn_confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.ocjView_bottom);
    }];
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self.ocjView_bottom addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_bottom.mas_left).offset(0);
        make.right.mas_equalTo(self.ocjView_bottom.mas_right).offset(0);
        make.top.mas_equalTo(self.ocjView_bottom.mas_top).offset(0);
        make.height.mas_equalTo(@0.5);
    }];
}

- (void)ocj_addTableView {
    self.ocjTBView_gift = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 135, SCREEN_WIDTH, SCREEN_HEIGHT * 2 / 3.0 - 195) style:UITableViewStylePlain];
    self.ocjTBView_gift.delegate = self;
    self.ocjTBView_gift.dataSource = self;
    self.ocjTBView_gift.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.ocjView_container addSubview:self.ocjTBView_gift];
}

#pragma mark _ UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ocjArr_giftDesc.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak OCJChooseGiftView *weakSelf = self;
    OCJChooseGiftTVCell *cell = [[OCJChooseGiftTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJChooseGiftTVCell"];
    [cell ocj_loadData:self.ocjArr_giftDesc[indexPath.row] title:self.ocjStr_giftTitle];
    cell.ocjSelectedGiftBlock = ^(BOOL isSelected, NSString *str) {
        weakSelf.ocjStr_giftTitle = str;
        [self.ocjTBView_gift reloadData];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - 点击确认按钮
- (void)ocj_clickedConfirmBtn {
    OCJLog(@"确定");
    if (self.ocjSelectGiftBlock) {
        self.ocjSelectGiftBlock(self.ocjStr_giftTitle);
    }
    [self ocj_closeAction];
}

- (void)ocj_closeAction {
    self.ocjView_bg.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.ocjView_container.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 2 / 3.0);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
