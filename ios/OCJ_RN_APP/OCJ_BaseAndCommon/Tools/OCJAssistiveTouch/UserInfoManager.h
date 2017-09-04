//
//  UserInfoManager.h
//  NovelApp
//
//  Created by 杨川 on 16/12/7.
//  Copyright © 2016年 杨川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "EaseConversationModel.h"

static NSString*_Nullable EaseSendMessageSuccess = @"aEaseSendMessageSuccess";//消息发送成功通知

@class UserInfoModel;
@class ChatExtModel;
@class PublicPersonalHomepageModel;
@protocol UserInfoManagerDelegate;

@interface UserInfoManager : NSObject<EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,EMCallManagerDelegate>
/**
 *单例
 */
+ (instancetype _Nullable)sharedInstance;
@property(assign, nonatomic) BOOL isOpenCurrentVersion;//当前版本是否第一次进入app
@property(copy, nonatomic) NSString *loginEMName;//登录环信的帐号的名称
+ (NSString *)loginEMNameWithUserid:(NSString *) userid;
/**
 *用户定位城市
 */
@property(copy, nonatomic) NSString *locationCity;
/**
 *是否完善档案
 */
@property (assign, nonatomic) BOOL isFinishPer;
/**
 *设置代理
 */
@property(strong, nonatomic) id<UserInfoManagerDelegate> _Nullable delegate;
/**
 *当前用户的定位经纬度
 */
@property(assign, nonatomic) CLLocationCoordinate2D coordinate;
/**
 *删除代理 当试图控制器被释放的时候 必须删除代理
 */
- (void)removeManagerDelegate:(id<UserInfoManagerDelegate> _Nullable) delegate;
/**
 *读取登录的用户信息
 */
@property(strong,nonatomic,readonly) UserInfoModel *_Nullable userInfo;
/**
 *设置 获取登录密码
 */
@property(copy,nonatomic) NSString *_Nullable password;

/**
 *登录 储存用户信息
 */
- (UserInfoModel *__nullable)loginUserInfo:(NSDictionary *_Nullable) user;
/**
 *刷新用户信息
 */
- (UserInfoModel *__nullable)updateUserInfo:(NSDictionary *_Nullable) user;
/**
 *缓存企业主信息
 */
- (PublicPersonalHomepageModel *__nullable)cacheCompanyInfo:(NSDictionary *_Nullable) info;
/**
 *读取登录的用户企业信息
 */
@property(strong,nonatomic,readonly) PublicPersonalHomepageModel *_Nullable companyInfo;
/**
 *根据核伙人等级返回图片
 */
+ (UIImage *__nullable)imageMedalWithLevel:(NSString *_Nullable) level;
/**
 *退出登录
 */
- (void)outLoginCompletion: (void (^ __nullable)(BOOL isSuccess,NSString * _Nullable error))completion;
/**
 *isPlacemark 是否返回 CLPlacemark 地理反编码
 *开始定位 定位一次 block返回的时候 会清空block,下次收到值必须重新调用此方法
 */
- (void)locationManagerWithPlacemark:(BOOL) isPlacemark Completion: (void (^ __nullable)(BOOL isSuccess,CLLocationCoordinate2D coordinate,NSArray<CLPlacemark *> *_Nullable placemarks,NSString * _Nullable error))completion;
/**
 *发送退出登录通知
 */
- (void)outLoginNotification;

#pragma mark -- 下面是关于聊天的
/**
 *统计未读消息数
 */
@property(assign, nonatomic) NSInteger upUnreadMessageCount;

/**
 *从服务器获取推送属性
 */
- (void)asyncPushOptions;
/**
 *获取用户所有群组
 */
- (void)asyncGroupFromServer;
/**
 *获取所有会话，如果内存中不存在会从DB中加载
 */
- (void)asyncConversationFromDB;

/**
 *设置 获取登录状态 是否登录
 */
@property(assign,nonatomic) BOOL isLogin;

/**
 *当前用户是否第一次进入红包详情页
 */
@property(assign,nonatomic) BOOL isRedAlert;

/**
 *登录环信账号
 *block userInfo 用户信息
 *block isSuccess 是否成功
 *block message 提示内容
 */
- (void)loginHyAccount:(NSString *_Nullable) account withPassword:(NSString *_Nullable) password withCompletion: (void (^ __nullable)(UserInfoModel * _Nullable userInfo,BOOL isSuccess,NSString * _Nullable message))completion;
/**
 *设置options
 */
- (void)setUserHYWithCompletion: (void (^ __nullable)(UserInfoModel * _Nullable userInfo,BOOL isSuccess,NSString  * _Nullable message))completion;
/**
 *当前会话最后消息的时间
 */
- (NSString *__nullable)lastMessageTimeForConversationModel:(EMConversation *_Nullable)conversationModel;
/**
 *获取当前消息的时间
 */
- (NSString *__nullable)messageTimeForEMMessage:(EMMessage *_Nullable) message;
/**
 *当前会话单聊最后消息的时间
 */
- (NSString *__nullable)lastMessageTimeForConversation:(NSString * _Nullable) conversationChatter;
/**
 *当前会话最后消息的内容
 */
- (NSString *__nullable)lastMessageTitleForConversationModel:(EMConversation *_Nullable)conversationModel;
/**
 *获取消息时间字符串 ：昨天、上午9:00 下午19:00
 */
- (NSString *__nullable)stringDateInterval:(NSTimeInterval) interval;
/**
 *发送者用户类型
 */
- (NSString *__nullable)messageUserType:(EMMessage *_Nullable) message;
/**
 *消息类型
 */
+ (NSString *__nullable)messageType:(EMMessage *_Nullable) message;
/**
 *返回message的内容
 */
- (NSString *__nullable)messageContent:(EMMessage *_Nullable) message;
/**
 *当前会话单聊最后消息的内容
 */
- (NSString *__nullable)lastMessageTitleForConversation:(NSString * _Nullable) conversationChatter;
/**
 *获取单聊会话
 */
- (EMConversation *__nullable)getSingleChatConversation:(NSString * _Nullable) conversationChatter;
/**
 *获取群聊会话
 */
- (EMConversation *__nullable)getGroupChatConversation:(NSString * _Nullable) conversationChatter;
/**
 *发送消息 单聊
 *extModel 扩展字段
 */
- (void)sendSingleMessage:(NSString *_Nullable) message withChatConversation:(NSString *_Nullable) conversationChatter withChatExt:(ChatExtModel *_Nullable) extModel withProgress:(void (^ __nullable)(CGFloat progress)) progressBlock withCompletion: (void (^ __nullable)(EMMessage * _Nullable message,BOOL isSuccess,NSString * _Nullable error))completion;
/**
 *发送消息 群聊
 */
- (void)sendGroupMessage:(NSString *_Nullable) message withChatConversation:(NSString *_Nullable) conversationChatter withChatExt:(ChatExtModel *_Nullable) extModel withProgress:(void (^ __nullable)(CGFloat progress)) progressBlock withCompletion: (void (^ __nullable)(EMMessage * _Nullable message,BOOL isSuccess,NSString * _Nullable error))completion;
/**
 *发送消息
 */
- (void)sendMessage:(EMMessage *_Nullable) message withConversation:(EMConversation *_Nullable) conversation withProgress:(void (^ __nullable)(CGFloat progress)) progressBlock withCompletion: (void (^ __nullable)(EMMessage * _Nullable message,BOOL isSuccess,NSString * _Nullable error))completion;
/**
 *添加好友
 */
- (void)addContactConversationChatter:(NSString *_Nullable) conversationChatter withMessage:(NSString *_Nullable) message withCompletion: (void (^ __nullable)(BOOL isSuccess,NSString * _Nullable error))completion;
/**
 *将消息本地推送
 */
- (void)showNotificationWithMessage:(EMMessage *_Nullable) message;

@end
@protocol UserInfoManagerDelegate <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,EMCallManagerDelegate,CLLocationManagerDelegate>
@optional
/**
 *登录成功
 */
- (void)userLoginSuccessWithUserInfo:(UserInfoModel *_Nullable) userInfo;
/**
 *用户信息发生改变
 */
- (void)userLoginUserInfoUpdate:(UserInfoModel *_Nullable) userInfo;
/**
 *登录状态 发生变化
 */
- (void)userLoginStateWithFlag:(BOOL) isLogin;
/**
 *消息发送成功 EMMessage
 */
- (void)sendMessageDidSuccess:(EMMessage *_Nullable) message;

@end
