//
//  OCJMoreRecommendView.h
//  OCJ
//
//  Created by Ray on 2017/5/19.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 更多推荐
 */
@interface OCJMoreRecommendView : UIView

@property (nonatomic, strong) UIImageView *ocjImgView;     ///<预览图
@property (nonatomic, strong) UILabel *ocjLab_sellPrice;   ///<售价
@property (nonatomic, strong) UILabel *ocjLab_marketPrice; ///<市场价
@property (nonatomic, strong) UILabel *ocjLab_buyer;       ///<已售数量
@property (nonatomic, strong) UILabel *ocjLab_discount;    ///<折扣
@property (nonatomic, strong) UILabel *ocjLab_name;        ///<商品名称

@end
