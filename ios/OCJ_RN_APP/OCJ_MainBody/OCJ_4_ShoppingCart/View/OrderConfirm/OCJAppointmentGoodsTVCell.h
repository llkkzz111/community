//
//  OCJAppointmentGoodsTVCell.h
//  OCJ_RN_APP
//
//  Created by Ray on 2017/6/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_confirmOrder.h"

/**
 预约填写订单商品信息cell
 */
@interface OCJAppointmentGoodsTVCell : UITableViewCell

- (void)ocj_loadDataWithDictionary:(OCJResponceModel_orderDetail *)model giftViewHeight:(NSInteger)viewHeight;

@end
