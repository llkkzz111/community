//
//  OCJPlaceholderTextView.h
//  OCJ
//
//  Created by OCJ on 2017/5/24.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 自定义输入框
 */
@interface OCJPlaceholderTextView : UITextView

@property(copy,nonatomic)   NSString *placeholder;
@property(strong,nonatomic) UIColor *placeholderColor;
@property(strong,nonatomic) UIFont * placeholderFont;


@property(strong,nonatomic) NSIndexPath * indexPath;

//最大长度设置
@property(assign,nonatomic) NSInteger maxTextLength;

//更新高度的时候
@property(assign,nonatomic) float updateHeight;

@property(strong,nonatomic)  UILabel *PlaceholderLabel;

- (void)resetPlaceHolderFrame;

-(void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void(^)(OCJPlaceholderTextView*))limit;
-(void)addTextViewBeginEvent:(void(^)(OCJPlaceholderTextView*text))begin;
-(void)addTextViewEndEvent:(void(^)(OCJPlaceholderTextView*text))End;

@end
