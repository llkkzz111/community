//
//  JZPrivateChatMsg.h
//  JZLiveSDK
//
//  Created by wangcliff on 17/1/5.
//  Copyright © 2017年 jz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZPrivateChatMsg : NSObject
@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger otherID;
@property (nonatomic, strong) NSString *message;
@property (nonatomic) NSInteger date;
@property (nonatomic) NSInteger userID;
@property (nonatomic) NSInteger unReadNum;
@property (nonatomic, strong) NSString *userPic1;//头像
@property (nonatomic, strong) NSString *nickname;//
@property (nonatomic, strong) NSString *sex;//
@property (nonatomic) NSInteger powerLevel;//


@property (nonatomic, strong) NSString *otherUserPic1;//对方头像
@property (nonatomic, strong) NSString *otherNickname;//
@property (nonatomic, strong) NSString *otherSex;//
@property (nonatomic) NSInteger otherPowerLevel;//

- (instancetype)initWithAttributes:(NSDictionary *)attributes ;
@end
