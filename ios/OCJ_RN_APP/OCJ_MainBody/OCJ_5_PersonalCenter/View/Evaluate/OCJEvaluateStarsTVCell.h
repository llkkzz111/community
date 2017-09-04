//
//  OCJEvaluateStarsTVCell.h
//  OCJ
//
//  Created by Ray on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 评分cell
 */
@class OCJEvaluateStarsTVCell;
@protocol OCJEvaluateStarsTVCellDelegate <NSObject>

- (void)ocj_getEvaluateStarLevelWithCell:(OCJEvaluateStarsTVCell *)cell andLevel:(NSInteger)level;

@end

@interface OCJEvaluateStarsTVCell : UITableViewCell

@property (nonatomic, strong) OCJBaseLabel *ocjLab_title;///<评价类型
@property (nonatomic, strong) OCJBaseLabel *ocjLab_evaluate;///<评价等级
@property (nonatomic, strong) UIView *ocjView_line;///线

@property (nonatomic, weak) id<OCJEvaluateStarsTVCellDelegate>delegate;

- (void)ocj_setHighlightedImagePlace:(NSInteger)rate;

@end
