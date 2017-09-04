//
//  OCJBannerScrView.m
//  OCJ
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBannerScrView.h"
//#import "ZYBannerView.h"
#import "OCJVipBannerCell.h"
#import "OCJVipBannerCell2.h"
#import "OCJVipBannerCell3.h"
#import "OCJVipBannerCell4.h"
#import "OCJVipBannerCell5.h"

#define BannerCellID @"BannerCellID"
#define BannerCellID2 @"BannerCellID2"
#define BannerCellID3 @"BannerCellID3"
#define BannerCellID4 @"BannerCellID4"
#define BannerCellID5 @"BannerCellID5"

@interface OCJBannerScrView () <UICollectionViewDelegate, UICollectionViewDataSource>{
    UIView *lineView;
}

/////<ZYBannerViewDataSource>
//@property (nonatomic, strong) ZYBannerView *bannerView;
@property (nonatomic, weak) UICollectionView *bannerCollectionView;

@property (nonatomic, strong) UIView *pageNumView;

@property (nonatomic, strong) MASConstraint *leftCons;
@property (nonatomic, assign) CGFloat space;

@end

@implementation OCJBannerScrView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupBannerView];
        [self setupPageControl];
    }
    return self;
}

- (void)setupBannerView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWidth = SCREEN_WIDTH - 60; //item宽度
    CGFloat extendWidth = 25; //item漏出的宽度
    CGFloat minimumLineSpacing = (SCREEN_WIDTH - itemWidth - extendWidth)/2.0;
    CGFloat maginSapcing = SCREEN_WIDTH - minimumLineSpacing -itemWidth - extendWidth;
    layout.itemSize = CGSizeMake(itemWidth, 375*0.5);
    layout.minimumLineSpacing = minimumLineSpacing;
    layout.sectionInset       = UIEdgeInsetsMake(0,maginSapcing,0,maginSapcing);
  self.space = maginSapcing;
    
    UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.contentView addSubview:colView];
    colView.backgroundColor = [UIColor whiteColor];
    colView.decelerationRate = UIScrollViewDecelerationRateFast;
    colView.showsHorizontalScrollIndicator = NO;
    self.bannerCollectionView = colView;
    [colView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets = UIEdgeInsetsMake(10, 0, 45*0.5, 0);
    }];
    
    [colView registerClass:[OCJVipBannerCell class] forCellWithReuseIdentifier:BannerCellID];
    [colView registerClass:[OCJVipBannerCell2 class] forCellWithReuseIdentifier:BannerCellID2];
    [colView registerClass:[OCJVipBannerCell3 class] forCellWithReuseIdentifier:BannerCellID3];
    [colView registerClass:[OCJVipBannerCell4 class] forCellWithReuseIdentifier:BannerCellID4];
    [colView registerClass:[OCJVipBannerCell5 class] forCellWithReuseIdentifier:BannerCellID5];
    
    colView.delegate = self;
    colView.dataSource = self;
}

- (void)setupPageControl{
    lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWSHHFromHexString:@"#DDDDDD"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(125*0.5);
        make.right.offset(-125*0.5);
        make.top.equalTo(self.bannerCollectionView.mas_bottom).offset(11);
        make.height.equalTo(@1);
    }];
    
    self.pageNumView = [[UIView alloc] init];
    [lineView addSubview:self.pageNumView];
    [self.pageNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        self.leftCons = make.left.equalTo(lineView);
        make.height.equalTo(@2.5);
        make.width.equalTo(lineView).multipliedBy(1/5.0);
    }];
    self.pageNumView.layer.cornerRadius = 2.5*0.5;
    self.pageNumView.layer.masksToBounds = YES;
    self.pageNumView.backgroundColor = [UIColor colorWSHHFromHexString:@"#CCA571"];
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset{
    CGFloat itemWidth = SCREEN_WIDTH - 60; //item宽度
    CGFloat extendWidth = 20; //item漏出的宽度
    CGFloat minimumLineSpacing = (SCREEN_WIDTH - itemWidth - extendWidth*2)/2.0;
  
    CGFloat pageSize = SCREEN_WIDTH - minimumLineSpacing - extendWidth*2;
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
  CGFloat adjust;
  if (page == 1) {
    targetX = targetX - 4;
  }else {
    adjust = self.space + itemWidth * page - minimumLineSpacing * page;
    targetX = targetX + ceilf((targetX - adjust)/5) - 1;
    
  }
  
    return CGPointMake(targetX , offset.y);
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
            OCJVipBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BannerCellID forIndexPath:indexPath];
            return cell;
        }else if (indexPath.row == 1){
            OCJVipBannerCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:BannerCellID2 forIndexPath:indexPath];
            return cell2;
        }else if (indexPath.row == 2){
            OCJVipBannerCell3 *cell3 = [collectionView dequeueReusableCellWithReuseIdentifier:BannerCellID3 forIndexPath:indexPath];
            return cell3;
        }else if (indexPath.row == 3){
            OCJVipBannerCell4 *cell4 = [collectionView dequeueReusableCellWithReuseIdentifier:BannerCellID4 forIndexPath:indexPath];
            return cell4;
        }else if (indexPath.row == 4){
            OCJVipBannerCell5 *cell5 = [collectionView dequeueReusableCellWithReuseIdentifier:BannerCellID5 forIndexPath:indexPath];
            return cell5;
    }
    return nil;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        CGFloat xOffset = scrollView.contentOffset.x;
        CGFloat scrWidth = self.bannerCollectionView.contentSize.width-[UIScreen mainScreen].bounds.size.width;
        CGFloat pageWidth = lineView.frame.size.width - self.pageNumView.frame.size.width;
        
        self.leftCons.offset(pageWidth*(xOffset/scrWidth));
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}



/*
- (void)setupBannerView{
    self.bannerView = [[ZYBannerView alloc] init];
//    self.bannerView.showFooter = YES;
    [self.contentView addSubview:self.bannerView];
    self.bannerView.dataSource = self;
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

// 返回Banner需要显示Item(View)的个数
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner
{
    return 3;
}

// 返回Banner在不同的index所要显示的View
- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    UIView *backView = [[UIView alloc] init];
    
    if (index%2) {
        backView.backgroundColor = [UIColor blueColor];
    }else{
        backView.backgroundColor = [UIColor redColor];
    }
    
    return backView;
}
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
