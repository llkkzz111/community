//
//  OCJMoreRecomScrollView.h
//  OCJ
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponseModel_videoLive.h"

@class OCJMoreRecomScrollView;
@protocol OCJMoreRecomScrollViewDelegate <NSObject>

- (void)ocj_tappedViewToGoodsDetail:(OCJResponceModel_VideoDetailDesc *)model;

- (void)ocj_seeMoreAction;

@end

@interface OCJMoreRecomScrollView : UIView

@property (nonatomic, strong) NSArray *ocjArr_data;///<数据

@property (nonatomic, weak) id<OCJMoreRecomScrollViewDelegate>delegate;

@end
