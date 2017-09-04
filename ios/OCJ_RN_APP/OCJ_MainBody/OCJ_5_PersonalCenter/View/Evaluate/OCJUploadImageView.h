//
//  OCJUploadImageView.h
//  OCJ
//
//  Created by Ray on 2017/6/6.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 上传图片view
 */
typedef void(^OCJUploadImageBlock)(CGFloat viewHeight);

@interface OCJUploadImageView : UIView

@property (nonatomic, assign) CGFloat totalHeight;///<总高度
@property (nonatomic, strong) NSMutableArray *ocjArr_image;///<上传的图片数组(预览大图使用)
@property (nonatomic, strong) NSMutableArray *ocjArr_imageData;///<图片data数组(上传后台使用)

@property (nonatomic, copy) OCJUploadImageBlock ocjUploadImageBlock;

- (void)ocj_addUploadImageViewsWithImageArr:(NSArray *)ocjArr_image dataArr:(NSArray *)ocjArr_data;

@end
