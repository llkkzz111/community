//
//  OCJChooseGiftView.h
//  OCJ
//
//  Created by Ray on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_videoLive.h"

typedef void (^OCJSelectGiftBlock)(NSString *ocjStr_name);

/**
 选择赠品view
 */
@interface OCJChooseGiftView : UIView

- (instancetype)initWithGiftTitle:(NSString *)ocjStr_title array:(NSArray *)ocjArr_gift;

@property (nonatomic, copy) OCJSelectGiftBlock ocjSelectGiftBlock;

@end
