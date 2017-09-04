//
//  OCJEditAddressTVCell.h
//  OCJ
//
//  Created by OCJ on 2017/5/17.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface OCJEditAddressTVCell : UITableViewCell

@property (nonatomic,strong) OCJBaseLabel     * ocjLab_tip;
@property (nonatomic,strong) OCJBaseTextField * ocjTF_input;

@end

@interface OCJEditAddressSelectedTVCell : OCJEditAddressTVCell
@property (nonatomic,strong) OCJBaseLabel     * ocjLab_cityLabel;

@end

@interface OCJEditBottomTVCell : UITableViewCell

typedef void(^OCJSwitchHandler)(BOOL isOn);

@property (nonatomic,strong) UISwitch     * ocjSwitch;
@property (nonatomic,copy) OCJSwitchHandler switchHandler ;

@end

@interface OCJEditMiddleTVCell : OCJEditAddressTVCell

@property (nonatomic,strong) OCJBaseTextView     * ocjTV_city;
@property (nonatomic,strong) OCJBaseLabel        * ocjLab_placeholder;
//@property (nonatomic,strong) NSString            * ocjStr_placeholder;

- (void)ocj_showplaceholder:(BOOL)isshow;
@end
