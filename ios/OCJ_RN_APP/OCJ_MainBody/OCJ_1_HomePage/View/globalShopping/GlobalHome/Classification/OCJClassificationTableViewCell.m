//
//  OCJClassificationTableViewCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJClassificationTableViewCell.h"
#import "OCJClassificationCollectionCell.h"

@interface OCJClassificationTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView    *ocjCollention;
@property (nonatomic,strong) NSMutableArray     *ocjArray_collectionData;
@property (nonatomic,strong) UIView             * ocjView_footer;
@end

@implementation OCJClassificationTableViewCell

- (void)ocj_setShowDataWithArray:(NSArray *)array{
    [self.ocjArray_collectionData removeAllObjects];
    [self.ocjArray_collectionData addObjectsFromArray:array];
//    OCJGSModel_Package4* model = self.ocjArray_collectionData.lastObject;//
    [self.ocjCollention reloadData];
}

- (void)setFrame:(CGRect)frame{
    frame.origin.y += 5;
    frame.size.height -= 5;
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.ocjCollention registerClass:[OCJClassificationCollectionCell class] forCellWithReuseIdentifier:@"OCJClassificationCollectionCell"];
        [self ocj_addViews];
    }
    return self;
}
- (void)ocj_addViews{
    [self addSubview:self.ocjCollention];
    [self.ocjCollention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
}

- (UICollectionView *)ocjCollention{
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

- (NSMutableArray *)ocjArray_collectionData{
    if (!_ocjArray_collectionData) {
        _ocjArray_collectionData = [[NSMutableArray alloc] init];
    }
    return _ocjArray_collectionData;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;{
    return self.ocjArray_collectionData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    OCJClassificationCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OCJClassificationCollectionCell" forIndexPath:indexPath];
    OCJGSModel_Package4* model =  [self.ocjArray_collectionData objectAtIndex:indexPath.row];
    [cell ocj_setViewDataWith:model];
    return cell;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(79, 104);
}

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    OCJGSModel_Package4*  model = [self.ocjArray_collectionData objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalClassificationPressed:At:)]) {
        [self.delegate ocj_golbalClassificationPressed:model At:self];
    }

}

@end



