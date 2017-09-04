//
//  OCJManageAddressCell.h
//  OCJ
//
//  Created by Ray on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResModel_addressControl.h"

@class OCJManageAddressCell;
@protocol OCJManageAddressCellDelegate <NSObject>

- (void)ocj_editAddress:(OCJAddressModel_listDesc *)model;

@end

@interface OCJManageAddressCell : UITableViewCell

@property (nonatomic, strong) UIButton *ocjbtn_modify;///<修改地址按钮(未使用，已隐藏)
@property (nonatomic, strong) UIView *ocjView_modify; ///<修改地址

/**
 设置cell内容
 
 @param model 数据源
 @param edit 是否可编辑
 */
- (void)loadData:(OCJAddressModel_listDesc *)model canEdit:(BOOL)edit ;

@property (nonatomic, weak) id<OCJManageAddressCellDelegate>delegate;

@end
