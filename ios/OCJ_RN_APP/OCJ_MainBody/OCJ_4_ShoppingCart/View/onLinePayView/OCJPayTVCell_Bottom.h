//
//  OCJPayTVCell_Bottom.h
//  OCJ
//
//  Created by OCJ on 2017/5/24.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJOtherPayView.h"
#import "OCJHttp_onLinePayAPI.h"

typedef void (^OCJPayHandler)(OCJOtherPayModel * bankCardModel, NSString *ocjStr_hide);///< 回调block

/**
 底部Cell
 */
@interface OCJPayTVCell_Bottom : UITableViewCell

@property (nonatomic,strong) OCJModel_onLinePay * ocjModel_onLine;
@property (nonatomic,copy) OCJPayHandler handler;
@property (nonatomic,strong) NSString * ocjStr_title;

- (void)ocj_setSelectViewWithTitles:(NSMutableArray *)titles;
@end
