//
//  JZMessageModel.h
//  JZMSGApi
//
//  Created by wangcliff on 16/12/26.
//  Copyright © 2016年 jz. All rights reserved.
//  信息model

#import <Foundation/Foundation.h>
@interface JZMessageModel : NSObject
@property (nonatomic, strong) NSString *roomid;//必填  (直接获取的)房间号必须是十位数
@property (nonatomic, strong) NSString *token;//必填 固定的32位
@property (nonatomic, strong) NSString *time;//必填  当前时间
@property (nonatomic, strong) NSString *is_app;//必填 如果是app为1否则为0 (ios为1)
@property (nonatomic, strong) NSString *userid;//必填 (直接获取的)用户id
@property (nonatomic, strong) NSString *accountType;//必填 (直接获取的)0可以发聊天信息 1不可以发送聊天信息
@property (nonatomic, strong) NSString *powerLevel;//必填 等级,(获取用户的)等级
@property (nonatomic, strong) NSString *message;//选填 发送信息的内容
@property (nonatomic, strong) NSString *msgType;//必填 消息类型就是上面的几种
@property (nonatomic, strong) NSString *username;//必填 (直接获取的)用户名
@property (nonatomic, strong) NSString *direction;//选填 大礼物方向(发送大礼物时用到,其他消息可以不添加或者@""或者[NSNull null])
@property (nonatomic, strong) NSString *thumbImage;//选填 用户头像(发送小礼物用到,其他可以不添加或者@""或者[NSNull null])
- (instancetype)initWithAttributes:(NSDictionary *)attributes ;
@end
