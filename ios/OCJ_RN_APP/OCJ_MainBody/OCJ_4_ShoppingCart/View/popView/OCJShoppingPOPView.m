//
//  OCJShoppingPOPView.m
//  OCJ
//
//  Created by wb_yangyang on 2017/5/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJShoppingPOPView.h"
#import "OCJShoppingPOPViewCell.h"
#import "OCJShoppingPOPCouponCell.h"
#import "OCJHttp_myWalletAPI.h"

#define OCJFIRSTBUYVIEWHEIGHT 310
#define OCJCROSSTAXVIEWHEIGHT [UIScreen mainScreen].bounds.size.height - 224
#define OCJCOUPONVIEWHEIGHT   [UIScreen mainScreen].bounds.size.height - 237

@interface OCJShoppingPOPView ()<UITableViewDelegate, UITableViewDataSource, OCJShoppingPOPCouponCellDelegate>

@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;///<确认按钮

@property (nonatomic, strong) UITableView *ocjTBView_showDetail;///<详细说明的tableView

@property (nonatomic, strong) UIView *ocjView_tbHeader;///<headerView;
@property (nonatomic, strong) OCJBaseButton *ocjBtn_close;///<关闭按钮
@property (nonatomic, strong) OCJBaseLabel *OCJLab_title;///<标题

@property (nonatomic, strong) UIView *ocjView_sectionHeader;///<sectionHeader标题

@property (nonatomic, strong) NSString *ocjStr_title;

@property (nonatomic, assign) CGFloat ocj_totalheight;///<总高度

@property (nonatomic) OCJShoppingPOPViewType popViewType;///<弹出视图类型

@property (nonatomic, strong) NSMutableArray *ocjArr_rowHeight;///<记录跨境税cell高度

@property (nonatomic, strong) UIView *ocjView_mask;///<遮罩视图

@property (nonatomic, strong) OCJShoppingPOPView *popView;

@end

@implementation OCJShoppingPOPView

#pragma mark - 接口方法实现区域（包括setter、getter方法）
#pragma mark - 生命周期方法区域

#pragma mark - 私有方法区域

+ (instancetype)sharedInstance {
    static OCJShoppingPOPView *popView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popView = [[self alloc] init];
    });
    return popView;
}


/**
 添加popView
 */
- (void)ocj_addPOPViewWithType:(OCJShoppingPOPViewType)popType andDictionary:(NSDictionary *)dic {
    self.popViewType = popType;
    self.ocjView_mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.ocjView_mask.backgroundColor = [UIColor colorWSHHFromHexString:@"000000"];
    self.ocjView_mask.alpha = 0.4;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ocj_closePOPView)];
    
    self.ocjStr_title = @"首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明";
    //获取popView真实高度
    CGFloat height = [self ocj_calculatePOPViewHeightWithData:self.ocjStr_title];
    [self ocj_compareTotalHeightWithMAXHeight:height];
    
    self.popView = [[OCJShoppingPOPView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.ocj_totalheight) type:popType data:nil];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT - self.ocj_totalheight, SCREEN_WIDTH, self.ocj_totalheight);
    }];
    [self.ocjView_mask addGestureRecognizer:tap];
    self.ocjView_mask.tag = 1000;
    self.popView.tag = 1001;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.ocjView_mask];
    [window addSubview:self.popView];
}


/**
 初始化
 */
- (instancetype)initWithFrame:(CGRect)frame type:(OCJShoppingPOPViewType)popType data:(NSDictionary *)dataDic {
    self = [super initWithFrame:frame];
    if (self) {
        [self ocj_initHeaderView];
        
        self.popViewType = popType;
        
        self.ocjStr_title = @"首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明首购优惠说明";
        
        //获取视图的整个高度(实际是获取cell的高度数组,初始化时会重置数组，所以再次获取一次)
        self.ocj_totalheight = [self ocj_calculatePOPViewHeightWithData:self.ocjStr_title];
        
        switch (popType) {
            case OCJShoppingPOPViewTypeFirstBuy:{
                [self ocj_addFirstBuyViews];
            }
                break;
            case OCJShoppingPOPViewTypeCrossTax:{
                [self ocj_addCrossTaxViews];
            }
                break;
            case OCJShoppingPOPViewTypeCoupon:{
                [self ocj_addCouponViews];
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

/**
 首购优惠说明
 */
- (void)ocj_addFirstBuyViews {
    [self ocj_addConfirmBtn];
    [self ocj_addTableViewWithType:OCJShoppingPOPViewTypeFirstBuy];
}

/**
 跨境税
 */
- (void)ocj_addCrossTaxViews {
    [self ocj_addConfirmBtn];
    [self ocj_addTableViewWithType:OCJShoppingPOPViewTypeCrossTax];
}

/**
 抵用券
 */
- (void)ocj_addCouponViews {
    [self ocj_addTableViewWithType:OCJShoppingPOPViewTypeCoupon];
}


/**
 顶部视图
 */
- (void)ocj_initHeaderView {
    self.ocjView_tbHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.ocjView_tbHeader.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.ocjView_tbHeader];
    
    self.OCJLab_title = [[OCJBaseLabel alloc] init];
    self.OCJLab_title.text = @"首购优惠说明";
    self.OCJLab_title.textAlignment = NSTextAlignmentCenter;
    self.OCJLab_title.textColor = OCJ_COLOR_DARK_GRAY;
    self.OCJLab_title.font = [UIFont systemFontOfSize:15];
    [self.ocjView_tbHeader addSubview:self.OCJLab_title];
    [self.OCJLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.ocjView_tbHeader);
    }];
    
    self.ocjBtn_close = [[OCJBaseButton alloc] init];
    [self.ocjBtn_close addTarget:self action:@selector(ocj_clickedBtnToClosePOPView) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_tbHeader addSubview:self.ocjBtn_close];
    [self.ocjBtn_close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.ocjView_tbHeader);
        make.width.mas_equalTo(@44);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"icon_close"];
    [self.ocjBtn_close addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.ocjBtn_close);
        make.width.height.mas_equalTo(@15);
    }];
}

/**
 确认按钮
 */
- (void)ocj_addConfirmBtn {
    self.ocjBtn_confirm = [[OCJBaseButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44, SCREEN_WIDTH, 44)];
    [self.ocjBtn_confirm setTitle:@"确定" forState:UIControlStateNormal];
    [self.ocjBtn_confirm setTitleColor:[UIColor colorWSHHFromHexString:@"FEFEFE"] forState:UIControlStateNormal];
    self.ocjBtn_confirm.ocjFont = [UIFont systemFontOfSize:15];
    [self.ocjBtn_confirm ocj_gradientColorWithColors:@[[UIColor colorWSHHFromHexString:@"FF6750"],[UIColor colorWSHHFromHexString:@"E5290D"]] ocj_gradientType:OCJGradientTypeDirectionFromLeftToRight];
    [self.ocjBtn_confirm addTarget:self action:@selector(ocj_clickedBtnToClosePOPView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ocjBtn_confirm];
    
}


/**
 tableView
 */
- (void)ocj_addTableViewWithType:(OCJShoppingPOPViewType)type {
    
    self.ocjTBView_showDetail  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.ocjTBView_showDetail.delegate = self;
    self.ocjTBView_showDetail.dataSource = self;
    self.ocjTBView_showDetail.tableFooterView = [[UIView alloc] init];
    self.ocjTBView_showDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ocjTBView_showDetail.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.ocjTBView_showDetail];
    
    //首购
    if (type == OCJShoppingPOPViewTypeFirstBuy) {
        
        self.ocjBtn_confirm.hidden = NO;
        
        [self.ocjTBView_showDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.ocjView_tbHeader.mas_bottom).offset(0);
            make.bottom.mas_equalTo(self.ocjBtn_confirm.mas_top).offset(0);
        }];
        
        if (self.ocj_totalheight > OCJFIRSTBUYVIEWHEIGHT) {
            self.ocjTBView_showDetail.scrollEnabled = YES;
        }else {
            self.ocjTBView_showDetail.scrollEnabled = NO;
        }
        
    }else if (type == OCJShoppingPOPViewTypeCrossTax) {//跨境税
        
        self.ocjBtn_confirm.hidden = NO;
        
        [self.ocjTBView_showDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.ocjView_tbHeader.mas_bottom).offset(0);
            make.bottom.mas_equalTo(self.ocjBtn_confirm.mas_top).offset(0);
        }];
        
        if (self.ocj_totalheight > OCJCROSSTAXVIEWHEIGHT) {
            self.ocjTBView_showDetail.scrollEnabled = YES;
        }else {
            self.ocjTBView_showDetail.scrollEnabled = NO;
        }
        
    }else if (type == OCJShoppingPOPViewTypeCoupon) {//抵用券
        
        self.ocjBtn_confirm.hidden = YES;
        
        [self.ocjTBView_showDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.ocjView_tbHeader.mas_bottom).offset(0);
            make.bottom.mas_equalTo(self);
        }];
        
        if (self.ocj_totalheight > OCJCOUPONVIEWHEIGHT) {
            self.ocjTBView_showDetail.scrollEnabled = YES;
        }else {
            self.ocjTBView_showDetail.scrollEnabled = NO;
        }
        
    }
}


#pragma mark - 点击按钮、计算高度
/**
 点击按钮关闭视图
 */
- (void)ocj_clickedBtnToClosePOPView {
    
    [UIView animateWithDuration:0.5 animations:^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        for (int i = 0; i < window.subviews.count; i++) {
            [[window viewWithTag:1000] removeFromSuperview];
            if ([[window.subviews objectAtIndex:i] isKindOfClass:[OCJShoppingPOPView class]]) {
                self.popView = [window.subviews objectAtIndex:i];
                self.popView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.ocj_totalheight);
            }
        }
    }completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
    }];
}

/**
 关闭popView
 */
- (void)ocj_closePOPView {
    [UIView animateWithDuration:0.25 animations:^{
        [self.ocjView_mask removeFromSuperview];
        self.popView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.ocj_totalheight);
    } completion:^(BOOL finished) {
        [self.popView removeFromSuperview];
    }];
}

/**
 计算popView总高度
 */
- (CGFloat)ocj_calculatePOPViewHeightWithData:(id)data {
    
    CGFloat viewHeight = 0;
    //TODO:单个cell高度 * 个数
    if (self.popViewType == OCJShoppingPOPViewTypeCoupon) {//抵用券
        //根据类型判断是否展示满足使用条件视图
        if (/* DISABLES CODE */ (0)) {//不展示
            viewHeight = (97 + 15) + 44;
        }else {
            viewHeight = (117 + 15) + 44;
        }
    }else if (self.popViewType == OCJShoppingPOPViewTypeFirstBuy) {//首购
        
        viewHeight = 30 + 44 + 44;
        
        CGFloat height = [self ocj_calculatePOPViewHeightWithString:data] + 30;
        [self.ocjArr_rowHeight addObject:[NSString stringWithFormat:@"%f", height]];
        
        viewHeight += height;
        
    }else if (self.popViewType == OCJShoppingPOPViewTypeCrossTax) {//跨境税
        
        viewHeight = 44 + 44 + 30 * 2;
        
        for (int i = 0; i < 2; i ++) {
            //TODO:分别计算cell高度
            CGFloat height = [self ocj_calculatePOPViewHeightWithString:data] + 30;
            [self.ocjArr_rowHeight addObject:[NSString stringWithFormat:@"%f", height]];
            
            viewHeight += height;
        }
        
    }
    
    return viewHeight;
}

/**
 根据展示内容计算高度
*/
- (CGFloat)ocj_calculatePOPViewHeightWithString:(NSString *)ocjStr_description {
    CGFloat viewHeight = 0;
    
    CGRect rect = [ocjStr_description boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    //高度向上取整
    viewHeight = ceilf(rect.size.height);
    
    return viewHeight;
}


/**
 计算得出的高度与设置的最大高度比较(超出则使用设置的最大高度，否则使用计算出的高度)
 */
- (void)ocj_compareTotalHeightWithMAXHeight:(CGFloat)height {
    if (self.popViewType == OCJShoppingPOPViewTypeFirstBuy) {
        if (height > OCJFIRSTBUYVIEWHEIGHT) {
            self.ocj_totalheight = OCJFIRSTBUYVIEWHEIGHT;
        }else {
            self.ocj_totalheight = height;
        }
    }else if (self.popViewType == OCJShoppingPOPViewTypeCrossTax) {
        if (height > OCJCROSSTAXVIEWHEIGHT) {
            self.ocj_totalheight = OCJCROSSTAXVIEWHEIGHT;
        }else {
            self.ocj_totalheight = height;
        }
    }else if (self.popViewType == OCJShoppingPOPViewTypeCoupon) {
        if (height > OCJCOUPONVIEWHEIGHT) {
            self.ocj_totalheight = OCJCOUPONVIEWHEIGHT;
        }else {
            self.ocj_totalheight = height;
        }
    }
}

- (NSMutableArray *)ocjArr_rowHeight {
    if (!_ocjArr_rowHeight) {
        _ocjArr_rowHeight = [[NSMutableArray alloc] init];
    }
    return _ocjArr_rowHeight;
}


#pragma mark - 协议方法实现区域
#warning 根据传入数据来展示数据
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cellName";
    if (self.popViewType == OCJShoppingPOPViewTypeCoupon) {
        OCJShoppingPOPCouponCell *cell;
        if (!cell) {
            cell  = [[OCJShoppingPOPCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.cellDelegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else {
        OCJShoppingPOPViewCell *cell;
        if (!cell) {
            cell = [[OCJShoppingPOPViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.ocjLab_description.text = self.ocjStr_title;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.popViewType == OCJShoppingPOPViewTypeCoupon) {
        return nil;
    }
    
    self.ocjView_sectionHeader = [[UIView alloc] init];
    OCJBaseLabel *titleLab = [[OCJBaseLabel alloc] init];
    titleLab.text = @"首购优惠说明";
    titleLab.textColor = OCJ_COLOR_DARK;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self.ocjView_sectionHeader addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ocjView_sectionHeader.mas_left).offset(15);
        make.top.bottom.right.mas_equalTo(self.ocjView_sectionHeader);
    }];
    
    return self.ocjView_sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.popViewType == OCJShoppingPOPViewTypeCoupon) {
        return 0.01f;
    }
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.popViewType == OCJShoppingPOPViewTypeCoupon) {
        return 132.0f;
    }else if (self.popViewType == OCJShoppingPOPViewTypeCrossTax) {
        return [self.ocjArr_rowHeight[indexPath.section] integerValue];
    }else {
        return [self.ocjArr_rowHeight[indexPath.row] integerValue];
    }
}

- (void)ocj_clickedCouponCellWithCell:(OCJShoppingPOPCouponCell *)cell andCouponNo:(NSString *)couponNo {
    [OCJHttp_myWalletAPI ocjWallet_exchangeCouponWithCouponNo:couponNo completionHandler:^(OCJBaseResponceModel *responseModel) {
        if ([responseModel.ocjStr_code isEqualToString:@"200"]) {
            cell.ocjImgView_getAlready.hidden = NO;
        }
    }];
    OCJLog(@"cell");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
