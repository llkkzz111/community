//
//  OCJGlobalScreenTransverseCollectionCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/8.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJ_GlobalShoppingHttpAPI.h"

@interface OCJGlobalScreenTransverseCollectionCell : UICollectionViewCell
/**设置数据方法
 dictionary ：商品字典（接口返回）
 */
- (void)ocj_setViewDataWith:(OCJGSModel_Package44 *)model;

@end
