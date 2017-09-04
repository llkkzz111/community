//
//  JZCustomer.h
//  Huanji2
//
//  Created by cliff on 15/2/22.
//  Copyright (c) 2015年 cliff. All rights reserved.
//  用户model

#import <Foundation/Foundation.h>
@interface JZCustomer : NSObject
@property (nonatomic) NSInteger id;

//private basic info
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *eid;
@property (nonatomic, strong) NSString *iosEid;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *iosDeviceToken;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *oldPassword;
@property (nonatomic, strong) NSString *password;
@property (nonatomic,strong)  NSString *birthday;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *hobby;
@property (nonatomic, strong) NSString *career;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *externalID;
//private extend info
@property (nonatomic) NSInteger score;//积分 根据积分 显示
@property (nonatomic, strong) NSString *position;
@property (nonatomic) NSInteger belongCompanyID;
@property (nonatomic) NSInteger valid;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic) NSInteger powerLevel;
@property (nonatomic) NSInteger isFocus;

//room info
@property (nonatomic, strong) NSString* pic2;//房间封面
@property (nonatomic, strong) NSString* pushVideoUrl;
@property (nonatomic, strong) NSString* pic1;
@property (nonatomic) NSInteger isHost;
@property (nonatomic, strong) NSString *belongUnit;
@property (nonatomic, strong) NSString *roomNo;//房间id  只有host的用户 才有房间roomno
@property (nonatomic, strong) NSString *defaultPay;
@property (nonatomic, strong) NSString *hostTag;//customized tag, optional
@property (nonatomic)         NSInteger onlineNum;// the number of online fans
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *accountType;//是否禁言 0 可以发聊天信息 1 不可以发送聊天信息

@property (nonatomic)         NSInteger fansNum;
@property (nonatomic)         NSInteger focusNum;
@property (nonatomic)         NSInteger sendGiftValue;
@property (nonatomic)         NSInteger receiveGiftValue;
@property (nonatomic)         NSInteger publish;//是否正在直播,0未直播,1直播中,2转码中
@property (nonatomic)         NSInteger myMoney;
@property (nonatomic)         NSInteger streamStatus;//是否禁播
@property (nonatomic)         NSInteger videoDirection;//播放视频的方向
@property (nonatomic)         NSInteger isTester;//是不是测试账号
@property (nonatomic)         NSInteger timeTotal;
@property (nonatomic)         NSInteger ownTime;

//新增
@property (nonatomic, strong) NSString *adImage;//广告图片
@property (nonatomic)         NSInteger isInBlackList;
+(NSString*)getCode;
+(void)setCode:(NSString*) code;

+ (JZCustomer *)getUserdataInstance;
- (void)updateWithDictionaryRepresentation:(NSDictionary *)attributes;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
-(void) resetUserData;

@end
