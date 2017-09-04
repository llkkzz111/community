//
//  OCJGlobalScreenRetrievalButtonView.h
//  OCJ
//
//  Created by zhangyongbing on 2017/6/10.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OCJGlobalScreenRetrievalButtonViewDelegate <NSObject>

- (void)ocj_onScreenRetrievalButtonPressed:(NSInteger)tag;

@end

@interface OCJGlobalScreenRetrievalButtonView : UIView
@property (nonatomic ,weak) id<OCJGlobalScreenRetrievalButtonViewDelegate> delegate;
@property (nonatomic ,assign) NSInteger     ocjInt_btnViewTag;
/**设置按钮显示
 title ：按钮显示
 */
- (void)ocj_setTitl:(NSString *)title;
/**设置是否被选中
 selected ：是否选中
 */
- (void)ocj_setButtonSelected:(BOOL)selected;
@end
