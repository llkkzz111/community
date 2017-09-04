//
//  OCJOnTheNewTableViewCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJOnTheNewTableViewCell.h"
#import "OCJOnTheNewCollectionCell.h"
#import "OCJOnTheNewButtonViwe.h"

@interface OCJOnTheNewTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,OOCJOnTheNewButtonViweDelegate>
@property (nonatomic,strong) UICollectionView    *ocjCollention;
@property (nonatomic,strong) UILabel             *ocjLab_title;
@property (nonatomic,strong) UIView              *ocjView_gap;
@property (nonatomic,strong) UIView              *ocjView_gapSec;
@property (nonatomic,strong) UIView              *ocjView_Classify;

@property (nonatomic,strong) NSMutableArray     *ocjArray_collectionData;
@property (nonatomic,strong) NSMutableArray     *ocjArray_subData;

@end

@implementation OCJOnTheNewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.ocjCollention registerClass:[OCJOnTheNewCollectionCell class] forCellWithReuseIdentifier:@"OCJOnTheNewCollectionCell"];
        [self ocj_addSubView];
    }
    return self;
}

- (void)ocj_addSubView
{
    [self addSubview:self.ocjCollention];
    [self.ocjCollention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.size.height.mas_equalTo(150);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    
    [self addSubview:self.ocjView_gapSec];
    [self.ocjView_gapSec mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.ocjCollention.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
    }];
  self.ocjView_gapSec.hidden = YES;
    
    [self addSubview:self.ocjView_Classify];
    [self.ocjView_Classify mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjView_gapSec.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
  
}

- (void)ocj_setShowCollectionDataWithArray:(NSArray *)array
{
    [self.ocjArray_collectionData removeAllObjects];
    [self.ocjArray_collectionData addObjectsFromArray:array];
    [self.ocjCollention reloadData];
}

- (void)ocj_setShowSubDataWithArray:(NSArray *)array
{
    for (UIView *view in [self.ocjView_Classify subviews]) {
        if ([view isKindOfClass:[OCJOnTheNewButtonViwe class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self.ocjArray_subData removeAllObjects];
    [self.ocjArray_subData addObjectsFromArray:array];
    
    for (int i = 0; i < [array count]; i++) {
        OCJOnTheNewButtonViwe *view = [[OCJOnTheNewButtonViwe alloc] init];
        [self.ocjView_Classify addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(self.ocjView_Classify).offset(i*SCREEN_WIDTH/3);
          make.top.mas_equalTo(self.ocjView_Classify);
          make.width.mas_equalTo(SCREEN_WIDTH/3);
          make.bottom.mas_equalTo(self.ocjView_Classify);
        }];
        view.delegate = self;
        view.ocjInt_btnViewTag = 1000+i;
      
        OCJGSModel_Package14 * model = [self.ocjArray_subData objectAtIndex:i];
        [view ocj_setViewDataWith:model];
    }
}

#pragma mark - getter
- (UICollectionView *)ocjCollention
{
    if (!_ocjCollention) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
       layout.footerReferenceSize = CGSizeMake(41, 205+SCREEN_WIDTH/3 - 53.5);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _ocjCollention = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _ocjCollention.delegate = self;
        _ocjCollention.dataSource = self;
        [_ocjCollention setBackgroundColor:[UIColor whiteColor]];
    }
    return _ocjCollention;
}

- (UIView *)ocjView_Classify
{
    if (!_ocjView_Classify) {
        _ocjView_Classify = [[UIView alloc] init];
        [_ocjView_Classify setBackgroundColor:[UIColor whiteColor]];
    }
    return _ocjView_Classify;
}

- (UIView *)ocjView_gap
{
    if (!_ocjView_gap) {
        _ocjView_gap = [[UIView alloc] init];
        [_ocjView_gap setBackgroundColor:[UIColor colorWSHHFromHexString:@"DDDDDD"]];
    }
    return _ocjView_gap;
}

- (UIView *)ocjView_gapSec
{
    if (!_ocjView_gapSec) {
        _ocjView_gapSec = [[UIView alloc] init];
        [_ocjView_gapSec setBackgroundColor:[UIColor colorWSHHFromHexString:@"DDDDDD"]];
    }
    return _ocjView_gapSec;
}

- (NSMutableArray *)ocjArray_collectionData
{
    if (!_ocjArray_collectionData) {
        _ocjArray_collectionData = [[NSMutableArray alloc] init];
    }
    return _ocjArray_collectionData;
}

- (NSMutableArray *)ocjArray_subData{
    if (!_ocjArray_subData) {
        _ocjArray_subData = [[NSMutableArray alloc] init];
    }
    return _ocjArray_subData;
}

#pragma mark - 协议方法实现区域
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.ocjArray_collectionData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    OCJOnTheNewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OCJOnTheNewCollectionCell" forIndexPath:indexPath];
    OCJGSModel_Package43* model = [self.ocjArray_collectionData objectAtIndex:indexPath.row];
    [cell ocj_setViewDataWith:model];
  
    return cell;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(340, 150);
}

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    if ( [self.delegate respondsToSelector:@selector(ocj_golbaltheNewPressed:At:)]) {
        [self.delegate ocj_golbaltheNewPressed:self.ocjArray_collectionData[indexPath.row] At:self];
    }
    
}

- (void)ocj_onTheNewButtonPressed:(NSInteger)tag
{
    if ( [self.delegate respondsToSelector:@selector(ocj_globalReplenishmentItemPressed:)]) {
        [self.delegate ocj_globalReplenishmentItemPressed:self.ocjArray_subData[tag -1000]];
    }
}


@end
