//
//  OCJGoodsSpecTVCell.h
//  OCJ
//
//  Created by Ray on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_videoLive.h"

typedef void (^OCJSelectedSpecBlock)(UIButton *button, OCJResponceModel_specDetail *model);

@interface OCJGoodsSpecTVCell : UITableViewCell

- (void)loadCellWithData:(OCJResponceModel_GoodsSpec *)model andCscode:(NSString *)cscode csoff:(NSString *)csoff title:(NSString *)title;

@property (nonatomic, copy) OCJSelectedSpecBlock ocjSelectedSpecBlock;

@end
