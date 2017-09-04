//
//  OCJSugFeedBackTVCell.h
//  OCJ
//
//  Created by OCJ on 2017/5/23.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 意见反馈UITableViewCell
 */
@interface OCJSugFeedBackTVCell : UITableViewCell

@property (nonatomic,assign) BOOL ocjBool_showLine;        ///< 底部分割线
@property (nonatomic,strong) OCJBaseLabel * ocjLab_title;  ///< 标题

@end
