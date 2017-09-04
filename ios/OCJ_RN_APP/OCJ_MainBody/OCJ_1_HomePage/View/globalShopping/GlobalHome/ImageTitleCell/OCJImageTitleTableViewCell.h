//
//  OCJImageTitleTableViewCell.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/7.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCJResponceModel_GlobalShopping.h"

@class OCJImageTitleTableViewCell;
@protocol OCJImageTitleTableViewCellDelegate <NSObject>

/**
 全球购第五模块点击事件
 */
- (void)ocj_golbalImageTitlePressed:(OCJGSModel_Package10 *)model At:(OCJImageTitleTableViewCell *)cell;


/**
 全球购第六模块商品点击事件

 */
- (void)ocj_globalSixPackagePressed:(OCJGSModel_Package42*)model;

/**
 全球购第六模块更多按钮点击事件
 */
- (void)ocj_golbalViewMorePressed:(OCJGSModel_Package10 *)model At:(OCJImageTitleTableViewCell *)cell;

@end

@interface OCJImageTitleTableViewCell : UITableViewCell

@property (nonatomic ,weak) id<OCJImageTitleTableViewCellDelegate> delegate;
@property (nonatomic, copy) void(^backImageSize)(CGSize imageSize);


- (void)ocj_setShowTitleDataWithArray:(NSArray *)array;
- (void)ocj_setShowCollectionDataWithArray:(NSArray *)array;



@end
