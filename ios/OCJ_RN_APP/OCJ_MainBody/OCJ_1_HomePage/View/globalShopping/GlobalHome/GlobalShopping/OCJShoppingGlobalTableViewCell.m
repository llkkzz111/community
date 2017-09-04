//
//  OCJShoppingGlobalTableViewCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJShoppingGlobalTableViewCell.h"
#import "OCJShoppingGlobalCollectionCell.h"

@interface OCJShoppingGlobalTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView    *ocjCollention;
@property (nonatomic,strong) NSMutableArray     *ocjArray_collectionData;

@end

@implementation OCJShoppingGlobalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.ocjCollention registerClass:[OCJShoppingGlobalCollectionCell class] forCellWithReuseIdentifier:@"OCJShoppingGlobalCollectionCell"];
      
        [self.ocjCollention registerClass:[OCJShoppingGlobalTableViewFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:@"OCJShoppingGlobalTableViewFooterViewIdentifier"];
      
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_setShowDataWithArray:(NSArray *)array
{
    [self.ocjArray_collectionData removeAllObjects];
    [self.ocjArray_collectionData addObjectsFromArray:array];
    [self.ocjCollention reloadData];
}

- (void)ocj_addViews
{

    [self addSubview:self.ocjCollention];
    [self.ocjCollention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
}

#pragma mark - getter
- (UICollectionView *)ocjCollention
{
    if (!_ocjCollention) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.footerReferenceSize = CGSizeMake(41, 222.5);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _ocjCollention = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _ocjCollention.delegate = self;
        _ocjCollention.dataSource = self;
        [_ocjCollention setBackgroundColor:[UIColor whiteColor]];
    }
    return _ocjCollention;
}

- (NSMutableArray *)ocjArray_collectionData
{
    if (!_ocjArray_collectionData) {
        _ocjArray_collectionData = [[NSMutableArray alloc] init];
    }
    return _ocjArray_collectionData;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
  if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
    OCJShoppingGlobalTableViewFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"OCJShoppingGlobalTableViewFooterViewIdentifier"forIndexPath:indexPath];
    
    [footerView.ocjBtn_more addTarget:self action:@selector(ocj_setGlobalShopingMore) forControlEvents:UIControlEventTouchUpInside];

    return footerView;
  }
  return nil;
}

-(void)ocj_setGlobalShopingMore
{
  if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_200ShoppingAllOverWorld:)]) {
    [self.delegate ocj_200ShoppingAllOverWorld:[self.ocjArray_collectionData objectAtIndex:0]];
  }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.ocjArray_collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    OCJShoppingGlobalCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OCJShoppingGlobalCollectionCell" forIndexPath:indexPath];
    OCJGSModel_Package42* model = [self.ocjArray_collectionData objectAtIndex:indexPath.row];
    [cell ocj_setViewDataWith:model];
    return cell;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(110, 179);
}

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalShoppingPressed:At:)]) {
        [self.delegate ocj_golbalShoppingPressed:self.ocjArray_collectionData[indexPath.row] At:self];
    }
    
}

@end

@implementation OCJShoppingGlobalTableViewFooterView

- (instancetype)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor whiteColor];
    self.ocjBtn_more = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ocjBtn_more setImage:[UIImage imageNamed:@"icon_footer"] forState:UIControlStateNormal];
    [self addSubview:self.ocjBtn_more];
    [self.ocjBtn_more mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self);
    }];
  }
  return self;
}

@end
