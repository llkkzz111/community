//
//  ActivityTableViewCell.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/14.
//  Copyright © 2017年 jz. All rights reserved.
//  活动列表cell

#import <UIKit/UIKit.h>
@class JZLiveRecord;
@interface ActivityTableViewCell : UITableViewCell
@property (nonatomic, strong) JZLiveRecord *record;
@property (nonatomic, weak) UIButton *playBtn;
@end
