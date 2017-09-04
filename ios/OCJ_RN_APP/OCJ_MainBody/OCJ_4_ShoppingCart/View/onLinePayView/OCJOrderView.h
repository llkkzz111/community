//
//  OCJOrderView.h
//  OCJ
//
//  Created by OCJ on 2017/5/22.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 在线支付商品预览View
 */
@interface OCJOrderView : UIView

@property (nonatomic, strong) UIImageView * ocjImgView;          ///<  预览图
- (void) ocj_setImgWithUrl:(NSString *)imgUrl;

@end
