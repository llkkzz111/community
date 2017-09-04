//
//  OCJVipAreaCell.m
//  OCJ
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJVipAreaCell.h"
#import "UIImageView+WebCache.h"

@interface OCJVipAreaCell (){
    UIView *backView;
    OCJBaseLabel *ocjLab_headTitle;
    UIImageView *ocjImageView_brandIcon;
    OCJBaseLabel *ocjLab_brandTitle;
    OCJBaseLabel *ocjLab_brandDescription;
}

@end

@implementation OCJVipAreaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

+ (CGFloat)ocj_getCellHeight{
    CGFloat goodWidth = ([UIScreen mainScreen].bounds.size.width - 50)/3.0;
    
    return  85*0.5 + 1 + 10 + 61*0.5 + goodWidth + 50 + 32 +15;
}

#pragma mark 头部视图
- (void)setupSubViews{
    backView = [[UIView alloc] init];
    [self.contentView addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    ocjLab_headTitle = [[OCJBaseLabel alloc]init];
    ocjLab_headTitle.textColor = [UIColor colorWSHHFromHexString:@"#B3792C"];
    ocjLab_headTitle.font = [UIFont systemFontOfSize:16];
    ocjLab_headTitle.textAlignment = NSTextAlignmentCenter;
    ocjLab_headTitle.text = @"·品牌推荐·";
    [backView addSubview:ocjLab_headTitle];
    [ocjLab_headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(backView);
        make.height.equalTo(@(85*0.5));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [backView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWSHHFromHexString:@"#DDDDDD"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.height.equalTo(@1);
        make.top.equalTo(ocjLab_headTitle.mas_bottom);
    }];
    
// 头像 标题 详情
    ocjImageView_brandIcon = [[UIImageView alloc]init];
    ocjImageView_brandIcon.contentMode = UIViewContentModeScaleAspectFit;
    ocjImageView_brandIcon.backgroundColor = [UIColor clearColor];
    [backView addSubview:ocjImageView_brandIcon];
    [ocjImageView_brandIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.width.height.equalTo(@(61*0.5));
    }];
    
    ocjLab_brandTitle = [[OCJBaseLabel alloc] init];
    ocjLab_brandTitle.textColor = [UIColor colorWSHHFromHexString:@"#333333"];
    ocjLab_brandTitle.font = [UIFont systemFontOfSize:13];
    [backView addSubview:ocjLab_brandTitle];
    [ocjLab_brandTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ocjImageView_brandIcon.mas_right).offset(10);
        make.top.equalTo(ocjImageView_brandIcon.mas_top).offset(-1);
    }];
    
    ocjLab_brandDescription = [[OCJBaseLabel alloc] init];
    ocjLab_brandDescription.textColor = [UIColor colorWSHHFromHexString:@"#666666"];
    ocjLab_brandDescription.font = [UIFont systemFontOfSize:11];
    [backView addSubview:ocjLab_brandDescription];
    [ocjLab_brandDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ocjImageView_brandIcon.mas_right).offset(10);
        make.bottom.equalTo(ocjImageView_brandIcon.mas_bottom).offset(1);
    }];
   
}

- (void)ocj_setupGoodViewWithGoods:(NSArray<OCJVIPModel_BrandItem*>*)goods{
    CGFloat goodWidth = ([UIScreen mainScreen].bounds.size.width - 50)/3.0;
    
    for (NSInteger i=0; i<3; i++) {
        UIView* view = [self.contentView viewWithTag:100+i];
        [view removeFromSuperview];//先移除后添加
        
        if (goods.count>i) {
            OCJVIPModel_BrandItem* brandItem = goods[i];
            if (![brandItem isKindOfClass:[OCJVIPModel_BrandItem class]]) {
                continue;
            }
            
            CGFloat leftMargin = 10 + 15*i +goodWidth*i;
            
            //商品背景视图
            UIView *goodBackView = [[UIView alloc] init];
            goodBackView.tag = i+100;//视图标识码
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ocj_clickGoodView:)];
            [goodBackView addGestureRecognizer:tap];
            [self.contentView addSubview:goodBackView];
            [goodBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(leftMargin);
                make.top.equalTo(ocjImageView_brandIcon.mas_bottom).offset(10);
                make.bottom.equalTo(backView);
                make.width.equalTo(@(goodWidth));
            }];
            
            //内部控件
            UIImageView* goodImage = [[UIImageView alloc]init];
            [goodImage ocj_setWebImageWithURLString:brandItem.ocjStr_imageUrl completion:nil];
            [goodBackView addSubview:goodImage];
            [goodImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(goodBackView);
                make.height.equalTo(@(goodWidth));
            }];
            
            OCJBaseLabel* goodTitleLab = [[OCJBaseLabel alloc] init];
            goodTitleLab.text = brandItem.ocjStr_title;
            goodTitleLab.textColor = [UIColor colorWSHHFromHexString:@"#333333"];
            goodTitleLab.font = [UIFont systemFontOfSize:12];
            [goodBackView addSubview:goodTitleLab];
            [goodTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(goodImage);
                make.top.equalTo(goodImage.mas_bottom).offset(10);
                make.height.equalTo(@20);
            }];
            
            OCJBaseLabel* goodSubTitleLab = [[OCJBaseLabel alloc] init];
            goodSubTitleLab.text = brandItem.ocjStr_description;
            goodSubTitleLab.textColor = [UIColor colorWSHHFromHexString:@"#333333"];
            goodSubTitleLab.font = [UIFont systemFontOfSize:12];
            [goodBackView addSubview:goodSubTitleLab];
            [goodSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(goodImage);
                make.top.equalTo(goodTitleLab.mas_bottom);
                make.height.equalTo(@20);
            }];
            
            OCJBaseLabel* goodPricePrefixLab = [[OCJBaseLabel alloc] init];
            goodPricePrefixLab.text = @"¥ ";
            goodPricePrefixLab.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
            goodPricePrefixLab.font = [UIFont systemFontOfSize:12];
            [goodBackView addSubview:goodPricePrefixLab];
            [goodPricePrefixLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(goodBackView);
                make.top.equalTo(goodSubTitleLab.mas_bottom).offset(15);
                make.height.equalTo(@15);
            }];
            
            OCJBaseLabel* goodPriceLab = [[OCJBaseLabel alloc] init];
            goodPriceLab.text = brandItem.ocjStr_price;
            goodPriceLab.textColor = [UIColor colorWSHHFromHexString:@"#E5290D"];
            goodPriceLab.font = [UIFont boldSystemFontOfSize:15];
            [goodBackView addSubview:goodPriceLab];
            [goodPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(goodPricePrefixLab.mas_right);
                make.top.equalTo(goodSubTitleLab.mas_bottom).offset(10);
                make.height.equalTo(@22);
            }];
        }
        
        
    }
}

-(void)ocj_clickGoodView:(UITapGestureRecognizer*)sender{
    UIView* goodView = sender.view;
    
    if ([self.ocjDelegate respondsToSelector:@selector(ocj_vipAreaCell:clickGoodIndex:)]) {
        [self.ocjDelegate ocj_vipAreaCell:self clickGoodIndex:goodView.tag];
    }
}

#pragma mark 页面赋值
- (void)setOcjModel_brandDetail:(OCJVIPModel_BrandDetail *)ocjModel_brandDetail{
    _ocjModel_brandDetail = ocjModel_brandDetail;
    
    ocjLab_brandTitle.text = ocjModel_brandDetail.ocjStr_brandName;
    ocjLab_brandDescription.text = ocjModel_brandDetail.ocjStr_brandDescription;
//    [ocjImageView_brandIcon ocj_setWebImageWithURLString:ocjModel_brandDetail.ocjStr_brandIconUrl];
    [ocjImageView_brandIcon sd_setImageWithURL:[NSURL URLWithString:ocjModel_brandDetail.ocjStr_brandIconUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached completed:nil];
    
    [self ocj_setupGoodViewWithGoods:ocjModel_brandDetail.ocjArr_brandItems];
}


@end
