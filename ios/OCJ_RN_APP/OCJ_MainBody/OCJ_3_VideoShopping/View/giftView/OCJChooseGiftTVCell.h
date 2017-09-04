//
//  OCJChooseGiftTVCell.h
//  OCJ
//
//  Created by Ray on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_videoLive.h"

typedef void (^OCJSelectedGiftBlock)(BOOL isSelected, NSString *str);

@interface OCJChooseGiftTVCell : UITableViewCell

- (void)ocj_loadData:(OCJResponceModel_giftDesc *)model title:(NSString *)title;

@property (nonatomic, strong) UILabel *ocjLab_name;         ///<赠品名称
@property (nonatomic, copy) OCJSelectedGiftBlock ocjSelectedGiftBlock;

@end
