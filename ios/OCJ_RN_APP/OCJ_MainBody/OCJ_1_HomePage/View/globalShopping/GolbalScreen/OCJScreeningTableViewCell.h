//
//  OCJScreeningTableViewCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/13.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCJScreeningTableViewCell : UITableViewCell

- (void)ocj_setShowtitle:(NSString *)title;

- (void)ocj_showIsCellSelected:(BOOL)selected;
@end
