//
//  OCJConfirmBtnTVCell.h
//  OCJ
//
//  Created by Ray on 2017/5/25.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^OCJConfirmBtnBlock)();
/**
 确认按钮cell
 */
@interface OCJConfirmBtnTVCell : UITableViewCell

@property (nonatomic, strong) OCJBaseButton *ocjBtn_confirm;///<确认按钮

@property (nonatomic, copy) OCJConfirmBtnBlock ocjConfirmBtnBlock;

@end
