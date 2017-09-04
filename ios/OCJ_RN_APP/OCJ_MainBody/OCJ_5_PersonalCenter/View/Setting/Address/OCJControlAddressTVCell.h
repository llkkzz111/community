//
//  OCJControlAddressTVCell.h
//  OCJ
//
//  Created by Ray on 2017/5/31.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResModel_addressControl.h"

@class OCJControlAddressTVCell;
@protocol OCJControlAddressTVCellDelegate <NSObject>

- (void)ocj_setDefaultAddress:(OCJAddressModel_listDesc *)model;

- (void)ocj_deleteAddress:(OCJAddressModel_listDesc *)model;

- (void)ocj_editAddress:(OCJAddressModel_listDesc *)model;

@end

@interface OCJControlAddressTVCell : UITableViewCell

@property (nonatomic, strong) OCJAddressModel_listDesc *ocjModel_address;

@property (nonatomic, weak) id<OCJControlAddressTVCellDelegate>delegate;

@end
