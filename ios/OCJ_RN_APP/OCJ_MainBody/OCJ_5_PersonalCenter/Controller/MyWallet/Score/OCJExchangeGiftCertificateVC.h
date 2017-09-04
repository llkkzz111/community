//
//  OCJExchangeGiftCertificateVC.h
//  OCJ
//
//  Created by Ray on 2017/5/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseVC.h"

typedef void (^OCJExchangeScoreBlock)();
/**
 兑换礼券页面
 */
@interface OCJExchangeGiftCertificateVC : OCJBaseVC

@property (nonatomic, copy) OCJExchangeScoreBlock ocjExchangeScoreBlock;

@end
