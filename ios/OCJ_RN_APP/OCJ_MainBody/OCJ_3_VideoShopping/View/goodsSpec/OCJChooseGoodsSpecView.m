//
//  OCJChooseGoodsSpecView.m
//  OCJ
//
//  Created by Ray on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJChooseGoodsSpecView.h"
#import "OCJGoodsSpecTVCell.h"
#import "OCJGoodsNumTVCell.h"
#import "OCJGoodsGiftsTVCell.h"
#import "OCJGoodsColorTVCell.h"
#import "OCJChooseGiftView.h"
#import "OCJHttp_videoLiveAPI.h"

@interface OCJChooseGoodsSpecView ()<UITableViewDelegate, UITableViewDataSource, OCJGoodsNumTVCellDelegate>

@property (nonatomic) OCJEnumGoodsSpec ocjEnumGoodsSpec;        ///<类型
@property (nonatomic, strong) NSString *ocjStr_itemCode;        ///<商品编号

@property (nonatomic, strong) UIView *ocjView_bg;               ///<背景
@property (nonatomic, strong) UIView *ocjView_container;        ///<显示商品信息view
@property (nonatomic, strong) UIImageView *ocjImgView_goods;    ///<预览图
@property (nonatomic, strong) OCJBaseLabel *ocjLab_name;        ///<商品名称
@property (nonatomic, strong) OCJBaseLabel *ocjLab_sellPrice;   ///<售价
@property (nonatomic, strong) OCJBaseLabel *ocjLab_marketPrice; ///<市场价
@property (nonatomic, strong) OCJBaseLabel *ocjLab_reduce;      ///<优惠多少

@property (nonatomic, strong) UIView *ocjView_head;             ///<
@property (nonatomic, strong) UIButton *ocjBtn_close;           ///<关闭按钮
@property (nonatomic, strong) OCJBaseTableView *ocjTBView_spec; ///<tableView

@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;    ///<确认按钮
@property (nonatomic, strong) NSMutableArray *ocjArr_cellHeight;///<记录cell高度数组

@property (nonatomic, strong) OCJResponceModel_Spec *ocjModel_spec;///<model
@property (nonatomic, strong) OCJResponceModel_specDetail *ocjModel_specSize; ///<选中尺寸model
@property (nonatomic, strong) OCJResponceModel_specDetail *ocjModel_specColor;///<选中颜色model

@property (nonatomic, strong) NSMutableDictionary *ocjDic_goods;///<选中商品信息
@property (nonatomic, strong) NSString *ocjStr_imageUrl;        ///<预览图地址
@property (nonatomic, assign) BOOL ocjBool_haveSize;            ///<是否可选尺寸
@property (nonatomic, assign) BOOL ocjBool_haveColor;           ///<是否可选颜色
@property (nonatomic, assign) BOOL ocjBool_colorSize;           ///<只有颜色尺寸一栏

@property (nonatomic, assign) NSInteger ocjInt_nums;            ///<可选赠品数量
@property (nonatomic, strong) NSMutableArray *ocjArr_gift;      ///<可选赠品数组
@property (nonatomic, strong) NSArray *ocjArr_selectGift;       ///<赠品数组

@end

@implementation OCJChooseGoodsSpecView

- (NSMutableDictionary *)ocjDic_goods {
    if (!_ocjDic_goods) {
        _ocjDic_goods = [NSMutableDictionary dictionary];
    }
    return _ocjDic_goods;
}

- (NSMutableArray *)ocjArr_cellHeight {
    if (!_ocjArr_cellHeight) {
        _ocjArr_cellHeight = [[NSMutableArray alloc] init];
    }
    return _ocjArr_cellHeight;
}

- (NSMutableArray *)ocjArr_gift {
    if (!_ocjArr_gift) {
        _ocjArr_gift = [[NSMutableArray alloc] init];
    }
    return _ocjArr_gift;
}

- (instancetype)initWithEnumType:(OCJEnumGoodsSpec)enumType andItemCode:(NSString *)ocjStr_itemCode {
    self = [super init];
    if (self) {
        self.ocjBool_haveSize = YES;
        self.ocjBool_haveColor = YES;
        self.ocjBool_colorSize = NO;
        self.ocjEnumGoodsSpec = enumType;
        self.ocjStr_itemCode = ocjStr_itemCode;
        [self ocj_requestGoodsSpec];
        
    }
    return self;
}

/**
 请求详情数据
 */
- (void)ocj_requestGoodsSpec {
    //商品编号
    //self.ocjStr_itemCode
    [OCJHttp_videoLiveAPI OCJVideoLive_getGoodsDetailWithItemCode:self.ocjStr_itemCode orderno:@"1" dmnid:@"1" isPufa:@"1" isBone:@"0" mediaChannel:@"1" sourceUrl:@"http://localhost:9091" completionHandler:^(OCJBaseResponceModel *responseModel) {
        
        self.ocjModel_spec = (OCJResponceModel_Spec *)responseModel;
        if (![self.ocjModel_spec.ocjStr_code isEqualToString:@"200"]) {
            [self removeFromSuperview];
            return;
        }
        //根据不同返回数据加载页面
        [self ocj_dealwithLoadType];
    }];
    //换货时不可以可以更换赠品
    if (self.ocjEnumGoodsSpec == OCJEnumGoodsSpecAddToCart) {
        [OCJHttp_videoLiveAPI OCJVideoLive_getGiftListWithItemCode:self.ocjStr_itemCode completionHandler:^(OCJBaseResponceModel *responseModel) {
            OCJResponceModel_giftList *model = (OCJResponceModel_giftList *)responseModel;
            if (model.ocjArr_list.count > 0) {
                self.ocjArr_selectGift = model.ocjArr_list;
                NSDictionary *dic = @{@"title":@"还有赠品未选择，请选择赠品",
                                      @"hasGet":@"NO"};
                [self.ocjArr_gift addObject:dic];
                [self.ocjTBView_spec reloadData];
            }
        }];
    }else if (self.ocjEnumGoodsSpec == OCJEnumGoodsSpecExchange) {
        
    }
}

/**
 根据不同返回数据加载页面
 */
- (void)ocj_dealwithLoadType {
//    [self.ocjModel_spec.ocjModel_goodsSpec.ocjArr_size removeAllObjects];
//    [self.ocjModel_spec.ocjModel_goodsSpec.ocjArr_color removeAllObjects];
    
    NSArray *tempColorSizeArr = self.ocjModel_spec.ocjModel_goodsSpec.ocjArr_colorSize;
    if (tempColorSizeArr.count > 0) {
        self.ocjBool_colorSize = YES;
        CGFloat ocjFloat_cellHeight = [self ocj_getCellHeightWitHArry:tempColorSizeArr];
        [self.ocjArr_cellHeight addObject:[NSString stringWithFormat:@"%f", ocjFloat_cellHeight]];
        
    }else {
      NSArray *tempSizeArr = self.ocjModel_spec.ocjModel_goodsSpec.ocjArr_size;
      NSArray *tempColorArr = self.ocjModel_spec.ocjModel_goodsSpec.ocjArr_color;
      
      OCJResponceModel_specDetail *sizeModel;
      if (tempSizeArr.count > 0) {
        sizeModel = tempSizeArr[0];
      }
      OCJResponceModel_specDetail *colorModel;
      if (tempColorArr.count > 0) {
        colorModel = tempColorArr[0];
      }
      
      //没有尺寸
      if (!(tempSizeArr.count > 0) || [sizeModel.ocjStr_hiddenWu isEqualToString:@"Y"]) {
        self.ocjBool_haveSize = NO;
      }
      OCJLog(@"count = %ld", self.ocjModel_spec.ocjModel_goodsSpec.ocjArr_color.count);
      //没有颜色
      if (!(tempColorArr.count > 0) || [colorModel.ocjStr_hiddenWu isEqualToString:@"Y"]) {
        self.ocjBool_haveColor = NO;
      }
      //没有规格可选，直接加入购物车
      if (!self.ocjBool_haveSize && !self.ocjBool_haveColor) {
        //
        if (self.ocjEnumGoodsSpec == OCJEnumGoodsSpecAddToCart) {
          NSString *ocjStr_unitcode = [self.ocjModel_spec.ocjDic_goodsDetail objectForKey:@"unit_code"];
          [self ocj_addTocartWithItemCode:self.ocjStr_itemCode unitCode:ocjStr_unitcode num:@"1"];
          [self removeFromSuperview];
          return ;
        }
      }
      //计算尺寸、颜色cell高度
      if (self.ocjBool_haveSize) {
        CGFloat ocjFloat_cellHeight = [self ocj_getCellHeightWitHArry:tempSizeArr];
        [self.ocjArr_cellHeight addObject:[NSString stringWithFormat:@"%f", ocjFloat_cellHeight]];
      }
      if (self.ocjBool_haveColor) {
        CGFloat ocjFloat_cellHeight2 = [self ocj_getCellHeightWitHArry:tempColorArr];
        [self.ocjArr_cellHeight addObject:[NSString stringWithFormat:@"%f", ocjFloat_cellHeight2]];
      }
    }
    
    //预览图url
    self.ocjStr_imageUrl = [self.ocjModel_spec.ocjDic_goodsDetail objectForKey:@"shareImg"];
    //请求数据成功加载界面
    if ([self.ocjModel_spec.ocjStr_code isEqualToString:@"200"]) {
        [self ocj_setSelf];
    }
}

- (void)ocj_sizeOrColor {
  
}

/**
 初始化界面
 */
- (void)ocj_setSelf {
    self.ocjModel_specSize = [[OCJResponceModel_specDetail alloc] init];
    self.ocjModel_specColor = [[OCJResponceModel_specDetail alloc] init];
    self.ocjInt_nums = 1;
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
    
    [UIView animateWithDuration:0.25f animations:^{
        self.ocjView_container.frame = CGRectMake(0, SCREEN_HEIGHT / 3.0, SCREEN_WIDTH, SCREEN_HEIGHT * 2 / 3.0);
    }];
    
    [self ocj_addHeadViews];
    [self ocj_addConfirmBtn];
    [self ocj_addTableView];
}

/**
 headView
 */
- (void)ocj_addHeadViews {
    self.ocjView_head = [[UIView alloc] init];
    self.ocjView_head.backgroundColor = OCJ_COLOR_BACKGROUND;
    [self.ocjView_container addSubview:self.ocjView_head];
    [self.ocjView_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.ocjView_container);
        make.height.mas_equalTo(@95);
    }];
    //imageView
    self.ocjImgView_goods = [[UIImageView alloc] init];
    [self.ocjImgView_goods ocj_setWebImageWithURLString:self.ocjStr_imageUrl completion:nil];
    self.ocjImgView_goods.backgroundColor = [UIColor purpleColor];
    [self.ocjView_head addSubview:self.ocjImgView_goods];
    [self.ocjImgView_goods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_head.mas_left).offset(15);
        make.bottom.mas_equalTo(self.ocjView_head.mas_bottom).offset(-15);
        make.width.height.mas_equalTo(@105);
    }];
    //关闭按钮
    self.ocjBtn_close = [[UIButton alloc] init];
    [self.ocjBtn_close setImage:[UIImage imageNamed:@"icon_clear"] forState:UIControlStateNormal];
    [self.ocjBtn_close addTarget:self action:@selector(ocj_closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_head addSubview:self.ocjBtn_close];
    [self.ocjBtn_close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.ocjView_head);
        make.width.height.mas_equalTo(@40);
    }];
    //商品名称
    self.ocjLab_name = [[OCJBaseLabel alloc] init];
    NSString *ocjStr_name = [self.ocjModel_spec.ocjDic_goodsDetail objectForKey:@"item_name"];
    self.ocjLab_name.text = ocjStr_name;
    self.ocjLab_name.font = [UIFont systemFontOfSize:14];
    self.ocjLab_name.textColor = OCJ_COLOR_DARK;
    self.ocjLab_name.textAlignment = NSTextAlignmentLeft;
    self.ocjLab_name.numberOfLines = 2;
    [self.ocjView_head addSubview:self.ocjLab_name];
    [self.ocjLab_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjImgView_goods.mas_right).offset(10);
        make.top.mas_equalTo(self.ocjView_head.mas_top).offset(5);
        make.right.mas_equalTo(self.ocjBtn_close.mas_left).offset(0);
    }];
    
    NSString *ocjStr_sellPrice = [self.ocjModel_spec.ocjDic_goodsDetail objectForKey:@"sale_price"];
    NSString *ocjStr_marketPrice = [self.ocjModel_spec.ocjDic_goodsDetail objectForKey:@"cust_price"];
    CGFloat ocjFloat_reduce = [ocjStr_marketPrice floatValue] - [ocjStr_sellPrice floatValue];
    NSString *ocjStr_reduce = [self ocj_deleteFloatValueString:ocjFloat_reduce];
    //优惠
    self.ocjLab_reduce = [[OCJBaseLabel alloc] init];
    self.ocjLab_reduce.text = [NSString stringWithFormat:@"比直播便宜￥%@", ocjStr_reduce];
    self.ocjLab_reduce.textColor = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_reduce.font = [UIFont systemFontOfSize:12];
    self.ocjLab_reduce.textAlignment = NSTextAlignmentLeft;
    [self.ocjView_head addSubview:self.ocjLab_reduce];
    [self.ocjLab_reduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_name);
        make.bottom.mas_equalTo(self.ocjView_head.mas_bottom).offset(-5);
    }];
    //抢先价label
    OCJBaseLabel *ocjLab_price = [[OCJBaseLabel alloc] init];
    ocjLab_price.text = @"抢先价";
    ocjLab_price.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    ocjLab_price.font = [UIFont systemFontOfSize:13];
    ocjLab_price.textAlignment = NSTextAlignmentLeft;
    [self.ocjView_head addSubview:ocjLab_price];
    [ocjLab_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_name);
        make.bottom.mas_equalTo(self.ocjLab_reduce.mas_top).offset(-2);
    }];
    //售价
    self.ocjLab_sellPrice = [[OCJBaseLabel alloc] init];
    self.ocjLab_sellPrice.text = [NSString stringWithFormat:@"￥%@", ocjStr_sellPrice];
    self.ocjLab_sellPrice.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
    self.ocjLab_sellPrice.font = [UIFont systemFontOfSize:18];
    self.ocjLab_sellPrice.textAlignment = NSTextAlignmentLeft;
    [self.ocjView_head addSubview:self.ocjLab_sellPrice];
    [self.ocjLab_sellPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ocjLab_price.mas_right).offset(2);
        make.bottom.mas_equalTo(ocjLab_price);
    }];
    //市场价
    self.ocjLab_marketPrice = [[OCJBaseLabel alloc] init];
    self.ocjLab_marketPrice.text = [NSString stringWithFormat:@"￥%@", ocjStr_marketPrice];
    self.ocjLab_marketPrice.font = [UIFont systemFontOfSize:11];
    self.ocjLab_marketPrice.textColor  = OCJ_COLOR_DARK_GRAY;
    self.ocjLab_marketPrice.textAlignment = NSTextAlignmentLeft;
    [self.ocjView_head addSubview:self.ocjLab_marketPrice];
    [self.ocjLab_marketPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjLab_sellPrice.mas_right).offset(2);
        make.bottom.mas_equalTo(self.ocjLab_sellPrice);
    }];
    //line
    UIView *ocjView_line = [[UIView alloc] init];
    ocjView_line.backgroundColor = OCJ_COLOR_DARK_GRAY;
    [self.ocjView_head addSubview:ocjView_line];
    [ocjView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.ocjLab_marketPrice);
        make.centerY.mas_equalTo(self.ocjLab_marketPrice);
        make.height.mas_equalTo(@1);
    }];
    //bottomLine
    UIView *ocjView_bottomLine = [[UIView alloc] init];
    ocjView_bottomLine.backgroundColor = [UIColor colorWSHHFromHexString:@"DDDDDD"];
    [self.ocjView_head addSubview:ocjView_bottomLine];
    [ocjView_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.ocjView_head);
        make.height.mas_equalTo(@0.5);
    }];
  if (!([ocjStr_marketPrice floatValue] > 0)) {
    self.ocjLab_marketPrice.hidden = YES;
    self.ocjLab_reduce.hidden = YES;
    ocjView_line.hidden = YES;
  }else {
    self.ocjLab_marketPrice.hidden = NO;
    self.ocjLab_reduce.hidden = NO;
    ocjView_line.hidden = NO;
  }
}

/**
 确认按钮
 */
- (void)ocj_addConfirmBtn {
    self.ocjBtn_confirm = [[OCJBaseButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 2 / 3.0 - 45, SCREEN_WIDTH, 45)];
    [self.ocjBtn_confirm setTitle:@"确 定" forState:UIControlStateNormal];
    [self.ocjBtn_confirm ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6048"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [self.ocjBtn_confirm setTitleColor:[UIColor colorWSHHFromHexString:@"FFFFFF"] forState:UIControlStateNormal];
    self.ocjBtn_confirm.ocjFont = [UIFont systemFontOfSize:17];
    self.ocjBtn_confirm.layer.cornerRadius = 2;
    [self.ocjBtn_confirm addTarget:self action:@selector(ocj_clickedConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_container addSubview:self.ocjBtn_confirm];
}

/**
 tableView
 */
- (void)ocj_addTableView {
    self.ocjTBView_spec = [[OCJBaseTableView alloc] initWithFrame:CGRectMake(0, 95, SCREEN_WIDTH, SCREEN_HEIGHT * 2 / 3.0 - 140) style:UITableViewStyleGrouped];
    self.ocjTBView_spec.backgroundColor = OCJ_COLOR_BACKGROUND;
    self.ocjTBView_spec.delegate = self;
    self.ocjTBView_spec.dataSource = self;
    self.ocjTBView_spec.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.ocjView_container addSubview:self.ocjTBView_spec];
}

/**
 计算规格cell高度
 */
- (CGFloat)ocj_getCellHeightWitHArry:(NSArray *)dataArr {
    
    UIButton *ocjBtn_last;
    __block NSInteger row = 1;
    __block CGFloat labWidth,labHeight,totalRowWidth = 30,totalHeight = 30 + 24,horSpace = 20,verSpace = 15;
    
    for (int i = 0; i < dataArr.count; i++) {
        OCJResponceModel_specDetail *detailModel = dataArr[i];
        
        UIButton *ocjBtn_spec = [[UIButton alloc] init];
        
        CGRect receSize = [self ocj_calculateLabelRectWithString:detailModel.ocjStr_name font:14];
        labWidth = ceilf(receSize.size.width) + 8;
        labHeight = ceilf(receSize.size.height) + 6;
        
        if (!ocjBtn_last) {
            totalRowWidth += labWidth;
            totalHeight += labHeight;
        }else {
            totalRowWidth += horSpace + labWidth;
            if (totalRowWidth > SCREEN_WIDTH - 30) {
                totalHeight += verSpace + labHeight;
            }else {
            }
        }
        if (totalRowWidth > SCREEN_WIDTH - 30) {
            row += 1;
            totalRowWidth = 30 + labWidth;
        }
        ocjBtn_last = ocjBtn_spec;
    }
    return totalHeight;
}

/**
 根据文字内容跟字体大小计算宽高
 */
- (CGRect)ocj_calculateLabelRectWithString:(NSString *)ocjStr font:(NSInteger)font {
    CGRect rect = [ocjStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect;
}

/**
 去掉floatValue小数点后面的00
 */
- (NSString *)ocj_deleteFloatValueString:(CGFloat)floatValue {
    NSString *ocjStr_float = [NSString stringWithFormat:@"%f", floatValue];
    NSString *ocjStr_new = [NSString stringWithFormat:@"%@", @(ocjStr_float.floatValue)];
    
    return ocjStr_new;
}

/**
 尺寸cell
 */
- (OCJGoodsSpecTVCell *)ocj_loadSpecTVCellWithTitle:(NSString *)title {
    OCJGoodsSpecTVCell *cell = [[OCJGoodsSpecTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJGoodsSpecTVCell"];
    [cell loadCellWithData:self.ocjModel_spec.ocjModel_goodsSpec andCscode:self.ocjModel_specSize.ocjStr_cscode csoff:self.ocjModel_specColor.ocjStr_csoff title:title];
    cell.ocjSelectedSpecBlock = ^(UIButton *button, OCJResponceModel_specDetail *model) {
        
        self.ocjModel_specSize = model;
        [self.ocjTBView_spec reloadData];
    };
    return cell;
}

/**
 颜色cell
 */
- (OCJGoodsColorTVCell *)ocj_loadColorTVCellWithTitle:(NSString *)title {
    OCJGoodsColorTVCell *cell = [[OCJGoodsColorTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJGoodsColorTVCell"];
    [cell loadCellWithData:self.ocjModel_spec.ocjModel_goodsSpec andCscode:self.ocjModel_specColor.ocjStr_cscode csoff:self.ocjModel_specSize.ocjStr_csoff title:title];
    cell.ocjSelectedSpecBlock = ^(UIButton *button, OCJResponceModel_specDetail *model) {
        
        self.ocjModel_specColor = model;
        self.ocjStr_imageUrl = model.ocjStr_imgUrl;
        [self.ocjTBView_spec reloadData];
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.ocjEnumGoodsSpec == OCJEnumGoodsSpecAddToCart) {
        if (self.ocjArr_gift.count > 0) {
            return self.ocjArr_cellHeight.count + 2;
        }
        return self.ocjArr_cellHeight.count + 1;
    }else {
        return self.ocjArr_cellHeight.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.ocjArr_gift.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ocjBool_colorSize) {
        if (indexPath.section == 0) {
            OCJGoodsColorTVCell *cell = [self ocj_loadColorTVCellWithTitle:@"规格"];
            return cell;
        }
    }else {
        if (self.ocjBool_haveSize && self.ocjArr_cellHeight.count == 1) {//只有尺寸
            if (indexPath.section == 0) {
                OCJGoodsSpecTVCell *cell = [self ocj_loadSpecTVCellWithTitle:@"尺寸"];
                return cell;
            }
        }else if (self.ocjBool_haveColor && self.ocjArr_cellHeight.count == 1) {//只有颜色
            if (indexPath.section == 0) {
                OCJGoodsColorTVCell *cell = [self ocj_loadColorTVCellWithTitle:@"颜色"];
                return cell;
            }
        }else {//有颜色和尺寸
            if (indexPath.section == 0) {
                OCJGoodsSpecTVCell *cell = [self ocj_loadSpecTVCellWithTitle:@"尺寸"];
                return cell;
            }else if (indexPath.section == 1) {
                OCJGoodsColorTVCell *cell = [self ocj_loadColorTVCellWithTitle:@"颜色"];
                return cell;
            }
        }
    }
    
    if (indexPath.section == self.ocjArr_cellHeight.count) {
        OCJGoodsNumTVCell *cell = [[OCJGoodsNumTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJGoodsNumTVCell"];
        cell.ocjInt_buyNum = self.ocjInt_nums;
        cell.ocjModel_spec = self.ocjModel_spec;
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == self.ocjArr_cellHeight.count + 1) {
        OCJGoodsGiftsTVCell *cell = [[OCJGoodsGiftsTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OCJGoodsGiftsTVCell"];
        NSDictionary *dic = self.ocjArr_gift[indexPath.row];
        [cell ocj_loadCellNameWithHasGetGift:[dic objectForKey:@"hasGet"] name:[dic objectForKey:@"title"]];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = OCJ_COLOR_BACKGROUND;
        UILabel *ocjLab_title = [[UILabel alloc] init];
        ocjLab_title.text = @"赠品";
        ocjLab_title.textColor = OCJ_COLOR_DARK;
        ocjLab_title.font = [UIFont systemFontOfSize:14];
        ocjLab_title.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:ocjLab_title];
        [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headerView.mas_left).offset(15);
            make.bottom.mas_equalTo(headerView);
        }];
        //提示
        UILabel *ocjLab_gift = [[UILabel alloc] init];
        ocjLab_gift.text = [NSString stringWithFormat:@"（可领取%ld件赠品）", self.ocjInt_nums];
        ocjLab_gift.textColor = [UIColor colorWSHHFromHexString:@"#2A2A2A"];
        ocjLab_gift.textAlignment = NSTextAlignmentLeft;
        ocjLab_gift.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:ocjLab_gift];
        [ocjLab_gift mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ocjLab_title.mas_right).offset(0);
            make.bottom.mas_equalTo(headerView);
        }];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 35;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 35;
    }else if (indexPath.section == 3) {
        return 35;
    }else {
        for (int i = 0; i < self.ocjArr_cellHeight.count; i++) {
            if (indexPath.section == i) {
                return [self.ocjArr_cellHeight[i] integerValue];
            }
        }
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        NSDictionary *selectDic = self.ocjArr_gift[indexPath.row];
        OCJChooseGiftView *view = [[OCJChooseGiftView alloc] initWithGiftTitle:[selectDic objectForKey:@"title"] array:self.ocjArr_selectGift];
        view.ocjSelectGiftBlock = ^(NSString *ocjStr_name) {
            OCJLog(@"name = %@", ocjStr_name);
            NSString *newStr = [NSString stringWithFormat:@"商品%ld %@", indexPath.row + 1, ocjStr_name];
            if (ocjStr_name.length > 0) {
                NSDictionary *dic = @{@"title":newStr,
                                      @"hasGet":@"YES"};
                [self.ocjArr_gift replaceObjectAtIndex:indexPath.row withObject:dic];
                [self.ocjTBView_spec reloadData];
            }
            
        };
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(window);
        }];
    }
}

/**
 加数量
 */
- (void)ocj_plusCartNumWithCell:(NSInteger)num andOverLimit:(BOOL)overLimit {
    OCJLog(@"num = %ld", num);
    self.ocjInt_nums = num;
    [self.ocjDic_goods setValue:@(num) forKey:@"num"];
  if (self.ocjArr_gift.count > 0) {
    if (!overLimit) {
      NSDictionary *dic = @{@"title":@"还有赠品未选择，请选择赠品",
                            @"hasGet":@"NO"};
      [self.ocjArr_gift addObject:dic];
      [self.ocjTBView_spec reloadData];
    }
  }
  
}

/**
 减数量
 */
- (void)ocj_minusCartNumWithCell:(NSInteger)num andMinNum:(BOOL)minNum {
    OCJLog(@"num = %ld", num);
    self.ocjInt_nums = num;
    [self.ocjDic_goods setValue:@(num) forKey:@"num"];
    if (!minNum) {
        [self.ocjArr_gift removeLastObject];
        [self.ocjTBView_spec reloadData];
    }
}

/**
 点击确认按钮(加入购物车)
 */
- (void)ocj_clickedConfirmBtn {
    NSString *ocjStr_unitcode;
    if (self.ocjBool_colorSize) {//颜色尺寸
        ocjStr_unitcode = self.ocjModel_specColor.ocjStr_cscode;
        if ([ocjStr_unitcode isEqualToString:@""]) {
            [OCJProgressHUD ocj_showHudWithTitle:@"请选择规格" andHideDelay:2.0];
            return;
        }
    }else {//颜色或尺寸
        NSString *ocjStr_sizecode = self.ocjModel_specSize.ocjStr_cscode;
        NSString *ocjStr_colorcode = self.ocjModel_specColor.ocjStr_cscode;
        if ([ocjStr_sizecode isEqualToString:@""] && self.ocjBool_haveSize) {
            [OCJProgressHUD ocj_showHudWithTitle:@"请选择尺寸" andHideDelay:2.0];
            return;
        }
        if ([ocjStr_colorcode isEqualToString:@""] && self.ocjBool_haveColor) {
            [OCJProgressHUD ocj_showHudWithTitle:@"请选择颜色" andHideDelay:2.0];
            return;
        }
        
        //选择的商品规格编号
      if (self.ocjBool_haveSize && self.ocjBool_haveColor) {
        ocjStr_unitcode = [NSString stringWithFormat:@"%@:%@", ocjStr_sizecode, ocjStr_colorcode];
      }else if (self.ocjBool_haveSize && !self.ocjBool_haveColor) {
        ocjStr_unitcode = [NSString stringWithFormat:@"%@:001", ocjStr_sizecode];
      }else if (!self.ocjBool_haveSize && self.ocjBool_haveColor) {
        ocjStr_unitcode = [NSString stringWithFormat:@"001:%@", ocjStr_colorcode];
      }
      
    }
    
    
    if (self.ocjEnumGoodsSpec == OCJEnumGoodsSpecAddToCart) {//加入购物车
        //TODO:更换参数
      [self ocj_addTocartWithItemCode:self.ocjStr_itemCode unitCode:ocjStr_unitcode num:[self.ocjDic_goods objectForKey:@"num"]];
    }else if (self.ocjEnumGoodsSpec == OCJEnumGoodsSpecExchange) {//换货
      if (self.ocjConfirmBlock) {
        self.ocjConfirmBlock( ocjStr_unitcode,self.ocjModel_specSize.ocjStr_name, self.ocjModel_specColor);
        [self ocj_closeAction];
      }
    }
  
}

- (void)ocj_addTocartWithItemCode:(NSString *)itemCode unitCode:(NSString *)unitCode num:(NSString *)num {
    NSMutableArray *ocjArr_giftItem = [[NSMutableArray alloc] init];
    NSMutableArray *ocjArr_giftUnitcode = [[NSMutableArray alloc] init];
    //筛选选中的赠品，以数组形式传递
    if (self.ocjArr_gift.count > 0) {
        for (int i = 0; i < self.ocjArr_gift.count; i++) {
            NSDictionary *dic = self.ocjArr_gift[i];
            NSString *ocjStr_name = [dic objectForKey:@"title"];
            for (int i = 0; i < self.ocjArr_selectGift.count; i++) {
                OCJResponceModel_giftDesc *model = self.ocjArr_selectGift[i];
                if ([ocjStr_name containsString:model.ocjStr_itemCode]) {
                    [ocjArr_giftItem addObject:model.ocjStr_itemCode];
                    [ocjArr_giftUnitcode addObject:model.ocjStr_unitCode];
                }
            }
        }
    }
  
    [OcjStoreDataAnalytics trackEvent:@"AP1706A048" label:nil parameters:@{@"type":@"加入购物车",@"itemcode":self.ocjStr_itemCode,@"pID":@"AP1706A048"}];
  
    [OCJHttp_videoLiveAPI OCJVideoLive_addToCartWithItemCode:itemCode num:num unitCode:unitCode giftItemCode:ocjArr_giftItem giftUnitCode:ocjArr_giftUnitcode giftPromoNos:@[] giftPromoSeqs:@[] shopNo:@"" mediaChannel:@"" sourceUrl:@"http://localhost:9091" completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            [OCJProgressHUD ocj_showHudWithTitle:@"加入购物车成功" andHideDelay:2.0];
          if (self.ocjConfirmBlock) {
            self.ocjConfirmBlock(unitCode, num, self.ocjModel_specColor);
          }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self ocj_closeAction];
            });
        }else {
            [OCJProgressHUD ocj_showHudWithTitle:responseModel.ocjStr_message andHideDelay:2.0];
        }
    }];
}

/**
 关闭弹窗
 */
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
