//
//  OCJVideoDetailCommonTVCell.h
//  OCJ
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_videoLive.h"

@class OCJVideoDetailCommonTVCell;
@protocol  OCJVideoDetailCommonTVCellDelegate <NSObject>

- (void)ocj_minusCartNumWithCell:(OCJVideoDetailCommonTVCell *)cell;

- (void)ocj_plusCartNumWithCell:(OCJVideoDetailCommonTVCell *)cell;

- (void)ocj_addToCartWithCellModel:(OCJResponceModel_VideoDetailDesc *)model;

@end

/**
 视频详情普通cell
 */
@interface OCJVideoDetailCommonTVCell : UITableViewCell

//传入数据
@property (nonatomic, strong) OCJResponceModel_VideoDetailDesc *ocjModel_desc;

@property (nonatomic, strong) UILabel *ocjLab_num;                  ///<选中数量

@property (nonatomic, weak) id<OCJVideoDetailCommonTVCellDelegate>delegate;

@end
