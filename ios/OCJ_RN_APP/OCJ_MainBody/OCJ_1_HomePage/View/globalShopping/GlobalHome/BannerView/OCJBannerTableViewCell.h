//
//  OCJBannerTableViewCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_GlobalShopping.h"

@protocol OCJBannerTableViewCellDelegate <NSObject>

- (void)ocj_golbalHeadBannerPressed:(OCJGSModel_Package2*)model;

@end

@interface OCJBannerTableViewCell : UITableViewCell

@property (nonatomic ,weak) id<OCJBannerTableViewCellDelegate> delegate;

- (void)ocj_setBannerArray:(NSArray *)array;

@end
