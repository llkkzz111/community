//
//  OCJContactMeTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OCJContactMeBlock)(NSString *ocjStr_contact);

@interface OCJContactMeTVCell : UITableViewCell

@property (nonatomic, copy) OCJContactMeBlock ocjContactMeBlock;

@end
