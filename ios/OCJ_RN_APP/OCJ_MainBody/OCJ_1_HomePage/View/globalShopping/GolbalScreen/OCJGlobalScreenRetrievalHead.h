//
//  OCJGlobalScreenRetrievalHead.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OCJGlobalScreenRetrievalHeadDelegate <NSObject>

- (void)ocj_onScreenRetrievalHeadPressed:(NSInteger)tag;

@end

@interface OCJGlobalScreenRetrievalHead : UIView
@property (nonatomic,assign) NSInteger  ocjInt_viewTag;
@property (nonatomic ,weak) id<OCJGlobalScreenRetrievalHeadDelegate> delegate;

/**headview的标题和右侧副标题
 title：标题
 subtitle：副标题
 */
- (void)ocj_setShowTitle:(NSString *)title SubTitle:(NSString *)subtitle;
/**
 head下的cell是否显示
 */
- (void)ocj_IsShowDetail:(BOOL)show;
@end
