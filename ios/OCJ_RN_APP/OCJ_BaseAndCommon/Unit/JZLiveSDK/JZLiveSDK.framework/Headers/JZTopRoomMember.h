//
//  JZTopRoomMember.h
//  waka
//
//  Created by cliff on 16/7/27.
//  Copyright © 2016年 JBS. All rights reserved.
//  粉丝model(直播间粉丝头像)

#import <Foundation/Foundation.h>

@interface JZTopRoomMember : NSObject
@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic) NSInteger powerLevel;
@property (nonatomic, strong) NSString* pic1;
- (instancetype)initWithAttributes:(NSArray *)memberValueArr;
@end
