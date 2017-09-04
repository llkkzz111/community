//
//  TextfeildViewController.h
//  JZLiveDemo
//
//  Created by wangcliff on 17/2/15.
//  Copyright © 2017年 jz. All rights reserved.
//  修改昵称

#import <UIKit/UIKit.h>
@class JZCustomer;
@protocol TextfeildViewDelagate <NSObject>
-(void)changePersonalInfor:(JZCustomer *)changeInfo;
@optional
-(void)changeActivityTopic:(NSString *)topic;
@end
@interface TextfeildViewController : UIViewController
@property (nonatomic, strong) NSString *textTitleString;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *hobby;
@property (nonatomic, assign) BOOL isRevise;
@property (nonatomic, weak) id<TextfeildViewDelagate> delegate;
@end
