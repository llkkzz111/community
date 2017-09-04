//
//  OCJSubMoreVideoTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/12.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_videoLive.h"

typedef void (^OCJSubMoreVideoBlock)(NSString *ocjStr_contentCode);

@interface OCJSubMoreVideoTVCell : UITableViewCell

@property (nonatomic, strong) NSArray *ocjArr_data;///<数据model
@property (nonatomic, copy) OCJSubMoreVideoBlock ocjSubMoreVideoBlock;

@end
