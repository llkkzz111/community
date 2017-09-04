//
//  OCJMoreVideoTVCell.h
//  OCJ
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OCJMoreVideoBlock)(NSString *ocjStr_contentCode);

/**
 更多视频cell
 */
@interface OCJMoreVideoTVCell : UITableViewCell

@property (nonatomic, strong) NSArray *ocjArr_data;///<数据
@property (nonatomic, strong) UICollectionView *ocjCollectionView;///<collectionView
@property (nonatomic, copy) OCJMoreVideoBlock ocjMoreVideoBlock;

@end
