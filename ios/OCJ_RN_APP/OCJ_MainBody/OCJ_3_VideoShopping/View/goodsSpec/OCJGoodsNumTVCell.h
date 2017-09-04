//
//  OCJGoodsNumTVCell.h
//  OCJ
//
//  Created by Ray on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_videoLive.h"

/**
 数量cell
 */
@class OCJGoodsNumTVCell;
@protocol OCJGoodsNumTVCellDelegate <NSObject>

- (void)ocj_minusCartNumWithCell:(NSInteger )num andMinNum:(BOOL)minNum;

- (void)ocj_plusCartNumWithCell:(NSInteger )num andOverLimit:(BOOL)overLimit;

@end

@interface OCJGoodsNumTVCell : UITableViewCell

@property (nonatomic, strong) OCJResponceModel_Spec *ocjModel_spec;
@property (nonatomic, assign) NSInteger ocjInt_buyNum;  ///<购买数量

@property (nonatomic, weak) id<OCJGoodsNumTVCellDelegate>delegate;

@end
