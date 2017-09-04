//
//  OCJVideoComingTVCell.h
//  OCJ
//
//  Created by Ray on 2017/6/11.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_videoLive.h"

/**
 即将播出cell
 */
@class OCJVideoComingTVCell;
@protocol OCJVideoComingTVCellDelegate <NSObject>

- (void)ocj_addToCartWithCellModel:(OCJResponceModel_VideoDetailDesc *)model;

@end

@interface OCJVideoComingTVCell : UITableViewCell

//传入数据
@property (nonatomic, strong) OCJResponceModel_VideoDetailDesc *ocjModel_desc;

@property (nonatomic, weak) id<OCJVideoComingTVCellDelegate>delegate;

@end
