//
//  OCJOtherPayView.h
//  OCJ
//
//  Created by OCJ on 2017/5/5.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OCJOtherPayModel;
typedef void(^OCJOtherPayViewHandler) (OCJOtherPayModel* ocjModel_selected);///< 其它支付方式回调block

@interface OCJOtherPayView : UIView
/**
 其它支付方式弹出视图
 
 @param title   优惠信息
 @param array   银行卡信息  格式如下
 @param handler 选择的银行卡信息回调block
 **/
 
+ (void)ocj_popPayViewWithTitle:(NSString *)title bankCardArrays:(NSMutableArray *)array completion:(OCJOtherPayViewHandler)handler;

@end

@class OCJOtherPayModel;

@interface OCJOtherPayCell : UITableViewCell

@property (nonatomic,strong) OCJOtherPayModel * model;

@end

@interface OCJOtherPayModel : NSObject

@property (nonatomic,assign) BOOL       ocjBool_isSelected;
@property (nonatomic,copy)   NSString * ocjStr_title;   ///<支付方式名称
@property (nonatomic,copy)   NSString * ocjStr_id;      ///<支付方式id
@property (nonatomic,copy)   NSString * ocjStr_imageUrl;///<缩略图
@property (nonatomic,copy)   NSString * ocjStr_activity;///<活动

@end
