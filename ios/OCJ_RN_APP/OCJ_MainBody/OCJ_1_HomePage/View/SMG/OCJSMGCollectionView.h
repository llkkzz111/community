//
//  OCJSMGCollectionView.h
//  OCJ
//
//  Created by OCJ on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCJSMGCollectionView : UICollectionView

@property (nonatomic,strong) NSArray * ocjArr_dataSource; ///< 数据源

@property (nonatomic)  NSInteger ocjInt_currentPage; ///< 当前停留页面

@end
