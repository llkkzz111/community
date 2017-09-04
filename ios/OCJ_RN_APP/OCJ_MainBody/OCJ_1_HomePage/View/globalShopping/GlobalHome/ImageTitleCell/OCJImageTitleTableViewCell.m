
//
//  OCJImageTitleTableViewCell.m
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJImageTitleTableViewCell.h"
#import "OCJShoppingGlobalCollectionCell.h"
#import "UIImage+WSHHExtension.h"
#import <UIImageView+WebCache.h>


@interface OCJImageTitleTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView    *ocjCollention;
@property (nonatomic,strong) UIImageView         *ocjImage_title;
@property (nonatomic,strong) UIImageView         *ocjImg_triangleImg;
@property (nonatomic,strong) UIView         *ocjView_gap;

@property (nonatomic,strong) NSMutableArray     *ocjArray_collectionData;
@property (nonatomic,strong) NSMutableArray     *ocjArray_HeaderData;

@property (nonatomic,strong) UIButton       *ocjBtn_Title;
@end


@implementation OCJImageTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setFrame:(CGRect)frame{
//    frame.origin.y += 10;
//    frame.size.height -= 10;
//    [super setFrame:frame];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.ocjCollention registerClass:[OCJShoppingGlobalCollectionCell class] forCellWithReuseIdentifier:@"OCJShoppingGlobalCollectionCell"];
      [self.ocjCollention registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews
{
    [self addSubview:self.ocjView_gap];
    [self.ocjView_gap mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(0);
      make.top.mas_equalTo(0);
      make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10));
    }];
  
    [self addSubview:self.ocjImage_title];
    [self.ocjImage_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*100/375));
    }];
  
    [self.ocjImage_title addSubview:self.ocjImg_triangleImg];
    [self.ocjImg_triangleImg mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(_ocjImage_title.mas_centerX);
      make.bottom.mas_equalTo(_ocjImage_title.mas_bottom);
      make.size.mas_equalTo(CGSizeMake(20, 10));
    }];
  
    [self addSubview:self.ocjCollention];
    [self.ocjCollention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ocjImage_title.mas_bottom);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    
    [self addSubview:self.ocjBtn_Title];
    [self.ocjBtn_Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*100/375));
    }];
}

- (void)ocj_setShowTitleDataWithArray:(NSArray *)array
{
    [self.ocjArray_HeaderData removeAllObjects];
    [self.ocjArray_HeaderData addObjectsFromArray:array];
  
    if (array.count>0) {
        OCJGSModel_Package10* model = [array firstObject];
      __weak __typeof(self) weakSelf = self;
      UIImage* placeHolderImage = [UIImage imageWSHHWithColor:[UIColor colorWSHHFromHexString:@"#ededed"]];
      
      [self.ocjImage_title sd_setImageWithURL:[NSURL URLWithString:[model.ocjStr_imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:placeHolderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (weakSelf.backImageSize) {
          CGSize size = image.size;
          
          size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*size.height*1.0/size.width);
          
          [weakSelf.ocjImage_title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
          }];
          
          [weakSelf.ocjBtn_Title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(size.width, size.height+10));
          }];
          
          weakSelf.backImageSize(size);
        }
      }];
    }
}

- (void)ocj_setShowCollectionDataWithArray:(NSArray *)array
{
    [self.ocjArray_collectionData removeAllObjects];
    [self.ocjArray_collectionData addObjectsFromArray:array];
    [self.ocjCollention reloadData];
}

-(void)ocj_mianButtonPressed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalImageTitlePressed:At:)]) {
        if ([self.ocjArray_HeaderData count] > 0) {
            OCJGSModel_Package10* model = [self.ocjArray_HeaderData objectAtIndex:0];
            [self.delegate ocj_golbalImageTitlePressed:model At:self];
        }
    }
}

#pragma mark - getter
- (UICollectionView *)ocjCollention
{
    if (!_ocjCollention) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
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

- (NSMutableArray *)ocjArray_HeaderData{
    if (!_ocjArray_HeaderData) {
        _ocjArray_HeaderData = [[NSMutableArray alloc] init];
    }
    return _ocjArray_HeaderData;
}

- (UIImageView *)ocjImage_title
{
    if (!_ocjImage_title) {
        _ocjImage_title =[[UIImageView alloc] initWithFrame:CGRectZero];
        [_ocjImage_title setBackgroundColor:[UIColor blackColor]];
        [_ocjImage_title setImage:[UIImage imageNamed:@"icon_integralIcondetails_bg"]];
      _ocjImage_title.clipsToBounds =  YES;
        _ocjImage_title.contentMode = UIViewContentModeScaleAspectFill;
      
        _ocjImg_triangleImg =[[UIImageView alloc] initWithFrame:CGRectZero];
        [_ocjImg_triangleImg setBackgroundColor:[UIColor clearColor]];
        [_ocjImg_triangleImg setImage:[UIImage imageNamed:@"icon_top_"]];
    }
    return _ocjImage_title;
}

- (UIView *)ocjView_gap
{
  if (!_ocjView_gap) {
    _ocjView_gap = [[UIView alloc] init];
    [_ocjView_gap setBackgroundColor:[UIColor colorWSHHFromHexString:@"#EDEDED"]];
  }
  return _ocjView_gap;
}

- (UIButton *)ocjBtn_Title
{
    if (!_ocjBtn_Title) {
        _ocjBtn_Title = [[UIButton alloc] init];
        [_ocjBtn_Title setBackgroundColor:[UIColor clearColor]];
        [_ocjBtn_Title addTarget:self action:@selector(ocj_mianButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocjBtn_Title;
}

/**
 查看更多
 */
- (void)ocj_checkMoreAction {
  
//  OCJLog(@"查看更多");
//  OCJGSModel_Package42* model = [[OCJGSModel_Package42 alloc]init];
//  if (self.ocjArray_collectionData.count>0) {
//    model = [self.ocjArray_collectionData objectAtIndex:0];
//  }
//
  if ([self.ocjArray_HeaderData count] > 0) {
    OCJGSModel_Package10* model = [self.ocjArray_HeaderData objectAtIndex:0];
//    [self.delegate ocj_golbalImageTitlePressed:model At:self];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalViewMorePressed:At:)]) {
      [self.delegate ocj_golbalViewMorePressed:model At:self];
    }
  }
  
  
//  if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_golbalImageTitlePressed:At:)]) {
//    if ([self.ocjArray_HeaderData count] > 0) {
//      OCJGSModel_Package10* model = [self.ocjArray_HeaderData objectAtIndex:0];
//      [self.delegate ocj_golbalImageTitlePressed:model At:self];
//    }
//  }
  
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
  return self.ocjArray_collectionData.count==0?0:self.ocjArray_collectionData.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
  
  if (indexPath.item == self.ocjArray_collectionData.count) {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    UIButton * ocjBtn_more = [UIButton buttonWithType:UIButtonTypeCustom];
    [ocjBtn_more setImage:[UIImage imageNamed:@"icon_footer"] forState:UIControlStateNormal];
    [ocjBtn_more addTarget:self action:@selector(ocj_checkMoreAction) forControlEvents:UIControlEventTouchUpInside];
//    ocjBtn_more.imageEdgeInsets = UIEdgeInsetsMake(6, 2, 6, 2);
    [cell.contentView addSubview:ocjBtn_more];
    [ocjBtn_more mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.width.mas_equalTo(15);
//      make.height.mas_equalTo(80);
//      make.centerX.mas_equalTo(cell);
//      make.centerY.mas_equalTo(cell);
      make.edges.equalTo(cell.contentView);
      
    }];
    
    return cell;
  }else{
    OCJShoppingGlobalCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OCJShoppingGlobalCollectionCell" forIndexPath:indexPath];
    OCJGSModel_Package42* model = [self.ocjArray_collectionData objectAtIndex:indexPath.row];
    [cell ocj_setViewDataWith:model];
    
    return cell;
  }
  
  return nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.item == self.ocjArray_collectionData.count) {
    return CGSizeMake(50, 179);
  }
    return CGSizeMake(110, 179);
}

-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
  if (indexPath.item == self.ocjArray_collectionData.count) {
    OCJLog(@"查看更多");
  }else {
    OCJGSModel_Package42* model = [self.ocjArray_collectionData objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocj_globalSixPackagePressed:)]) {
      [self.delegate ocj_globalSixPackagePressed:model];
    }
  }
    
}
@end
