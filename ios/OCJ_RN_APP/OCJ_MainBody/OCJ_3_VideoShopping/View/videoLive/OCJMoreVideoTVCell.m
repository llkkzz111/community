//
//  OCJMoreVideoTVCell.m
//  OCJ
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJMoreVideoTVCell.h"
#import "OCJMoreVideoCollectionCell.h"

@interface OCJMoreVideoTVCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation OCJMoreVideoTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self ocj_addViews];
    }
    return self;
}

- (void)ocj_addViews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    flowLayout.minimumLineSpacing = 10;//行间距(最小值)
    flowLayout.minimumInteritemSpacing = 10;//item间距(最小值)
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置section的边距
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 0);
    flowLayout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 5);
    
    self.ocjCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.ocjCollectionView.scrollEnabled = NO;
    self.ocjCollectionView.delegate = self;
    self.ocjCollectionView.dataSource = self;
    self.ocjCollectionView.backgroundColor = OCJ_COLOR_BACKGROUND;
    self.ocjCollectionView.showsVerticalScrollIndicator = NO;
    self.ocjCollectionView.alwaysBounceVertical = YES;
    
    [self.ocjCollectionView registerClass:[OCJMoreVideoCollectionCell class] forCellWithReuseIdentifier:@"OCJMoreVideoCollectionCell"];
    [self addSubview:self.ocjCollectionView];
    [self.ocjCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
}

#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ocjArr_data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OCJMoreVideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OCJMoreVideoCollectionCell" forIndexPath:indexPath];
    cell.ocjModel_desc = self.ocjArr_data[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 40)/2, 170);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 5, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //跳转页面
    OCJResponceModel_VideoDetailDesc *model = self.ocjArr_data[indexPath.row];
  if (self.ocjMoreVideoBlock) {
    self.ocjMoreVideoBlock(model.ocjStr_contentCode);
  }
    OCJLog(@"id = %@, item_code = %@", model.ocjStr_id, model.ocjStr_contentCode);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
