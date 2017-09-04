//
//  OCJResponceModel_auth.h
//  OCJ
//
//  Created by wb_yangyang on 2017/5/14.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJBaseResponceModel.h"

@interface OCJResponceModel_auth : OCJBaseResponceModel
@end

/**
 用户类型判断-接口响应model
 */
@interface OCJAuthModel_CheckID: OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_userType; ///< 用户类型 （0-不能识别 1-已注册过用户名 2-邮箱的用户 3-已注册过的手机用户 4-未添加过手机的电视用户 5-未添加过的电视用户）
@property (nonatomic,copy) NSString* ocjStr_internetID; ///< 用户编号
@property (nonatomic,copy) NSString* ocjStr_custName; ///< 用户姓名

@end

/**
 发送验证码-接口响应model
 */
@interface OCJAuthModel_SendSms : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_internetID; ///< 用户昵称

@end


/**
 TV用户信息验证-接口响应model
 */
@interface OCJAuthModel_VerifyTVUser : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_memberID; ///< 用户编号
@property (nonatomic,copy) NSString* ocjStr_mobile; ///< 用户手机号

@end


/*
 登录成功之后返回的数据Model
 */
@interface OCJAuthModel_login: OCJBaseResponceModel

@property (nonatomic,copy) NSString * ocjStr_accessToken;      ///< 登录凭证
@property (nonatomic,copy) NSString * ocjStr_custName;   ///< 用户姓名
@property (nonatomic,copy) NSString * ocjStr_custNo;   ///< 用户编号
@property (nonatomic,copy) NSString* ocjStr_mobile; ///< 用户手机号
@property (nonatomic,copy) NSString* ocjStr_internetId; ///< 用户网络编号

@end

/**
 会员购买记录混淆列表-接口响应model
 */
@interface OCJAuthModel_HistoryGoods: OCJBaseResponceModel

@property (nonatomic,copy) NSArray * ocjArr_items;             ///< 购买商品列表

@end



#pragma mark - 第三方登录模块

/**
 获取支付宝跳转凭证-接口响应model
 */
@interface OCJAuthModel_AlipaySecret : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_secret; ///< 支付宝登录跳转秘钥

@end

/**
 第三方登录-接口响应model
 */
@interface OCJAuthModel_thirdPartyLogin : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_associateState; ///< 第三方绑定状态 （0-未绑定 1-已绑定）

@property (nonatomic,copy) NSString* ocjStr_userMessage;///< 第三方用户信息

@property (nonatomic,copy) NSString* ocjStr_accessToken;///< 登录凭证

@end


/**
 检测token-接口响应model
 */
@interface OCJAuthModel_checkToken : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_isVisitor;///< 是否是访客 1-访客 0-会员
@property (nonatomic,copy) NSString* ocjStr_isLogined;///< 是否登录 1-登录 0-未登录
@property (nonatomic,copy) NSString* ocjStr_custNo;///< 用户编号

@end

/**
 检测app版本-接口响应model
 */
@interface OCJAuthModel_checkVersion : OCJBaseResponceModel

@property (nonatomic,copy) NSString* ocjStr_isNeedUpdate;///< 是否需要更新 0-不需要 1-需要
@property (nonatomic,copy) NSString* ocjStr_jumpUrl;///< 跳转链接
@property (nonatomic,copy) NSString* ocjStr_updateMessage;///< 更新信息
@property (nonatomic,copy) NSString* ocjStr_prompt_comment;///< 评价开关

@end
