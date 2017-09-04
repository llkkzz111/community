//
//  OCJPayTVCell_Bottom.m
//  OCJ
//
//  Created by OCJ on 2017/5/24.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJPayTVCell_Bottom.h"
#import "OCJSelectedView.h"
#import "OCJOtherPayView.h"
#import "WSHHThirdPay.h"


@interface OCJPayTVCell_Bottom ()
@property (nonatomic,strong) UILabel          * ocjLab_tip;
@property (nonatomic,strong) OCJSelectedView  * ocjSel_view;
@property (nonatomic,strong) UIButton         * confirmBut;
@property (nonatomic,strong) UIView           * ocjView_bg;
@property (nonatomic,copy)   NSString         * ocjStr_bankName;
@property (nonatomic,copy)   NSMutableArray   * ocjArr_titles;
@property (nonatomic,copy)   NSArray          * ocjArr_otherBanks;
@property (nonatomic,strong) OCJOtherPayModel * ocjModel_current; ///< 当前选中的Model

@end

@implementation OCJPayTVCell_Bottom
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor colorWSHHFromHexString:@"F9F8F8"];
        [self.contentView addSubview:self.ocjView_bg];
        [self.ocjView_bg addSubview:self.confirmBut];
        [self.ocjView_bg addSubview:self.ocjLab_tip];        
    }
    return self;
}


- (void)ocj_setSelectViewWithTitles:(NSMutableArray *)titles{
  
    ///获取初始值
    if (titles.count <= 0) {
      return;
    }
  
    NSMutableArray * ocjArr_tmp = [NSMutableArray array];
    if (self.ocjArr_titles) {
        [self.ocjArr_titles removeAllObjects];
    }
  
    if (titles.count <= 3) {
      
        for (int i = 0; i< titles.count; i++) {
            NSDictionary * dic = [titles objectAtIndex:i];
            NSString * title = [dic objectForKey:@"title"];
            [ocjArr_tmp addObject:title];
        }
      
    }else if(titles.count >3){
        for (int i = 0; i< titles.count; i++) {
            if (i < 2) {
                NSDictionary * dic = [titles objectAtIndex:i];
                NSString * title = [dic objectForKey:@"title"];
                [ocjArr_tmp addObject:title];
            }else{
                if (i == 2) {
                    [ocjArr_tmp addObject:@"其它支付方式"];
                }
                
                NSDictionary * dic = [titles objectAtIndex:i];
                [self.ocjArr_titles addObject:dic];
                
            }
        }
    }

  
    __weak OCJPayTVCell_Bottom* weakSelf = self;
    NSInteger currentIndex = 0;
    if (self.ocjModel_current.ocjStr_id.length>0) {//获取之前选中的支付方式，呈现选中状态
        for (NSDictionary* dic in titles) {
          if ([[dic[@"id"]description] isEqualToString:self.ocjModel_current.ocjStr_id]) {
              NSInteger index = [titles indexOfObject:dic];
              if (index <2) {
                currentIndex = index;
              }
          }
        }
    }else{
      NSDictionary * dic = [titles objectAtIndex:0];
      OCJOtherPayModel * ocjModel_selected = [[OCJOtherPayModel alloc]init];
      ocjModel_selected.ocjStr_title = [dic objectForKey:@"title"];
      ocjModel_selected.ocjStr_id = [dic objectForKey:@"id"];
      weakSelf.ocjModel_current = ocjModel_selected;
    }
    [self.ocjSel_view removeFromSuperview];
    self.ocjSel_view = [[OCJSelectedView alloc]initWithOnLinePayArray:ocjArr_tmp  andIndex:currentIndex];
    [self.ocjView_bg addSubview:self.ocjSel_view];
    [self ocj_updateConstraints];
  
    self.ocjStr_title = self.ocjModel_onLine.ocjStr_payStyle;
    if ([self.ocjStr_title isEqualToString:@"onlinePay"]) {
        self.ocjLab_tip.text = @"在线支付:";
        [self.confirmBut setTitle:@"确认支付" forState:UIControlStateNormal];

    }else{
        self.ocjLab_tip.text = @"货到付款:";
        [self.confirmBut setTitle:@"确认" forState:UIControlStateNormal];
    }
  
    self.ocjSel_view.ocj_handler = ^(UIButton *currentBtn) {
      
        if (weakSelf.handler) {
            weakSelf.handler(weakSelf.ocjModel_current, @"hide");
        }
      
        if (titles.count>3 && currentBtn.tag == 2) {
            [OCJOtherPayView ocj_popPayViewWithTitle:@"选择在线支付方式" bankCardArrays:weakSelf.ocjArr_titles completion:^(OCJOtherPayModel *ocjModel_selected) {
                NSMutableArray* mArray = [titles mutableCopy];
                if (ocjModel_selected != nil) {
                    weakSelf.ocjModel_current = ocjModel_selected;
                    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:ocjModel_selected.ocjStr_title,@"title",ocjModel_selected.ocjStr_id,@"id",nil];
                    for (NSDictionary* payMethodDic in mArray) {
                        if (![payMethodDic isKindOfClass:[NSDictionary class]]) {
                          continue;
                        }
                    
                        NSString* payTitle = payMethodDic[@"title"];
                        if (payTitle.length==0) {
                          continue;
                        }
                    
                        if ([ocjModel_selected.ocjStr_title isEqualToString:payTitle]) {//调换支付方式位置，并刷新展示视图
                          NSInteger index = [mArray indexOfObject:payMethodDic];
                          [mArray exchangeObjectAtIndex:0 withObjectAtIndex:index];
                          [weakSelf ocj_setSelectViewWithTitles:mArray];
                      
                          break;
                        }
                    }
                }else{
                    [weakSelf ocj_setSelectViewWithTitles:mArray];
                }
            }];
        }else{
            NSDictionary * dic = [titles objectAtIndex:currentBtn.tag];
            OCJOtherPayModel * ocjModel_selected = [[OCJOtherPayModel alloc]init];
            ocjModel_selected.ocjStr_title = [dic objectForKey:@"title"];
            ocjModel_selected.ocjStr_id = [dic objectForKey:@"id"];
            weakSelf.ocjModel_current = ocjModel_selected;
        }
    };

}


-(void)ocj_updateConstraints{
    
    [self.ocjView_bg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.ocjLab_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_bg).offset(10);
        make.top.mas_equalTo(self.ocjView_bg).offset(15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    [self.confirmBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.ocjView_bg).offset(-15);
        make.centerX.mas_equalTo(self.ocjView_bg);
        make.width.mas_equalTo(SCREEN_WIDTH -  40 * 2);
        make.height.mas_equalTo(40);
    }];
    
    [self.ocjSel_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_bg);
        make.right.mas_equalTo(self.ocjView_bg);
        make.top.mas_equalTo(self.ocjLab_tip.mas_bottom).offset(15);
        make.height.mas_equalTo(27);
    }];
}

-(UIView *)ocjView_bg{
    if (!_ocjView_bg) {
        _ocjView_bg = [[UIView alloc]init];
        _ocjView_bg.userInteractionEnabled = YES;
        _ocjView_bg.backgroundColor = [UIColor whiteColor];
    }
    return _ocjView_bg;
}
- (UILabel *)ocjLab_tip{
    if (!_ocjLab_tip) {
        _ocjLab_tip = [[UILabel alloc]init];
        _ocjLab_tip.font = [UIFont systemFontOfSize:14];
        _ocjLab_tip.text = @"货到付款：";
        _ocjLab_tip.textColor = [UIColor colorWSHHFromHexString:@"333333"];
    }
    return _ocjLab_tip;
}
- (UIButton *)confirmBut{
    if (!_confirmBut) {
        _confirmBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBut setTitle:@"确认" forState:UIControlStateNormal];
        _confirmBut.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBut.layer.masksToBounds = YES;
        _confirmBut.layer.cornerRadius = 2;
        _confirmBut.backgroundColor = [UIColor colorWSHHFromHexString:@"E5290D"];
        [_confirmBut addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBut;
}

- (void)confirmAction:(id)sender{
    if (self.handler) {
        self.handler(self.ocjModel_current, @"YES");
    }
}

- (NSMutableArray *)ocjArr_titles{
    if (!_ocjArr_titles) {
        _ocjArr_titles = [NSMutableArray array];
    }
    return _ocjArr_titles;
}

@end

