//
//  OCJRNLiveStepOneTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/7/11.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OCJChangeVideoUrlBlock)(NSString *ocjStr_url);

@interface OCJRNLiveStepOneTVCell : UITableViewCell

@property (nonatomic, strong) NSArray *ocjArr_video;       ///<
@property (nonatomic, copy) OCJChangeVideoUrlBlock ocjChangeVideoUrlBlock;///<

@end
