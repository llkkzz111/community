//
//  OCJOtherCView.m
//  OCJ
//
//  Created by OCJ on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJOtherCView.h"
#import "OCJPayCVCell.h"

@interface OCJOtherCView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableDictionary * cellDic;  

@end


@implementation OCJOtherCView

static NSString* cellIdentify = @"online";
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate   = self;
        self.backgroundColor = [UIColor colorWSHHFromHexString:@"f1f1f1"];
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[OCJPayCVCell class]  forCellWithReuseIdentifier:cellIdentify];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSArray* items = [self visibleCells];
    float off_x = self.contentOffset.x;
    for (UIView* view in items) {
        float verSep_x = off_x + (SCREEN_WIDTH-view.frame.size.width)/2.0;
        float distance = view.frame.origin.x - verSep_x;
        if (fabsf(distance) <= SCREEN_WIDTH - (SCREEN_WIDTH-view.frame.size.width)/2.0 ) {
            CGRect frame = view.frame;
            frame.origin.y = fabsf(distance)/(float)view.frame.size.width*46;//46>>代表变形cell
            frame.size.height += (view.frame.origin.y - frame.origin.y)*(1+ 22.5/46.0);
            view.frame = frame;
        }
    }
}

- (NSMutableArray *)ocjArr_dataSource{
    if (!_ocjArr_dataSource) {
        _ocjArr_dataSource = [NSMutableArray array];
    }
    return _ocjArr_dataSource;
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset{
    CGFloat pageSize = SCREEN_WIDTH-35;
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ocjArr_dataSource.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OCJPayCVCell * cell = (OCJPayCVCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
  
    OCJModel_onLinePay * model = (OCJModel_onLinePay *)[self.ocjArr_dataSource objectAtIndex:indexPath.row];
    cell.ocjModel_onLine = model;
    cell.ocjStr_page = [NSString stringWithFormat:@"%ld/%ld",(indexPath.row + 1),self.ocjArr_dataSource.count];
  
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(SCREEN_WIDTH - 40 , self.mj_h);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
  [self endEditing:YES];
}

#pragma mark - 
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

@end
