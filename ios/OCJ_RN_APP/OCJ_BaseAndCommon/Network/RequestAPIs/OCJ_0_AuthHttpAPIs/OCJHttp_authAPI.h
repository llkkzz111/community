//
//  OCJHttp_authAPI.h
//  OCJ
//
//  Created by yangyang on 2017/4/21.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCJNetWorkCenter.h"
#import "OCJResponceModel_auth.h"

// 定义验证码的使用用途上下文
static NSString* OCJSMSPurpose_MobileLogin = @"mobile_login_context";///< 无密码快速登录
static NSString* OCJSMSPurpose_TVUserBindingMobile = @"tvuser_login_context";///< 电视用户固话登录绑定手机
static NSString* OCJSMSPurpose_SetPassword = @"retrieve_password_context"; ///< 设置密码
static NSString* OCJSMSPurpose_QuickSignUp = @"quick_register_context"; ///< 快速注册
static NSString* OCJSMSPurpose_EmailUserBindingMobile = @"emailuser_sms_context";///< 邮箱用户登录后绑定手机

/**
 注册登录模块接口类
 */
@interface OCJHttp_authAPI : NSObject

#pragma mark - 通用
/**
 用户类型判断

 @param account 输入账户名
 @param handler 回调block
 */
+(void)ocjAuth_checkUserTypeWithAccount:(NSString*)account
                      completionHandler:(OCJHttpResponseHander)handler;


/**
 普通登录(用户信息和密码登录)
 
 @param login_id 用户loginID
 @param password 密码
 @param info 第三方用户信息
 @param handler 回调block
 */
+ (void)ocjAuth_loginWithID:(NSString *)login_id
                   password:(NSString *)password
             thirdPartyInfo:(NSString*)info
          completionHandler:(OCJHttpResponseHander)handler;


/**
 发送手机验证码
 
 @param mobile 手机号码
 @param purpose 验证码用途
 @param internetID 用户网络ID（邮箱用户登录后绑定手机时必传）
 @param handler 回调block
 */
+ (void)ocjAuth_SendSmscodeWithMobile:(NSString *)mobile
                              purpose:(NSString *)purpose
                           internetID:(NSString*)internetID
                    completionHandler:(OCJHttpResponseHander)handler;

/**
 设置密码
 
 @param new_pwd 新密码
 @param old_pwd 旧密码（选填，修改密码时必填）
 @param handler 回调block
 */
+ (void)ocjAuth_setPasswordNewPassword:(NSString *)new_pwd
                           oldPassword:(NSString*)old_pwd
                     completionHandler:(OCJHttpResponseHander)handler;


/**
 检测登录

 @param accessToken 登录凭证
 @param handler 回调block
 */
+ (void)ocjAuth_chechToken:(NSString*)accessToken completionHandler:(OCJHttpResponseHander)handler;

/**
 自动登录(token登录)
 @param handler 回调block
 */
+ (void)ocjAuth_automaticLoginCompletionHandler:(OCJHttpResponseHander)handler;


/**
 访客登录
 @param params 访客参数
 @param handler 回调block
 */
+ (void)ocjAuth_guestLoginWithParameters:(NSDictionary*)params
                       completionHandler:(OCJHttpResponseHander)handler;


/**
 退出登录接口
 
 @param handler 回调block
 */
+ (void)ocjAuth_LoginOutCompletionHandler:(OCJHttpResponseHander)handler;



/**
 检验app版本

 @param appVersion app版本
 @param handler 
 */
+(void)ocjAuth_checkAppVersionCompletionHandler:(OCJHttpResponseHander)handler;


#pragma mark - 登录

#pragma mark - =====新媒体邮箱登录

/**
 会员登录成功后，未绑定手机的用户，添加手机绑定
 
 @param mobile 手机号码
 @param verify_code 验证码
 @param handler 回调block
 */
+ (void)ocjAuth_bindingMobileWithMobile:(NSString *)mobile
                             verifyCode:(NSString *)verify_code
                      completionHandler:(OCJHttpResponseHander)handler;


#pragma mark - =====新媒体手机登录
/**
 手机验证码快速登录
 
 @param mobile 手机号码
 @param verify_code 验证码
 @param info 第三方用户信息
 @param handler 回调block
 */
+ (void)ocjAuth_smscodeLoginWithMobile:(NSString *)mobile
                            verifyCode:(NSString *)verify_code
                               purpose:(NSString *)purpose
                        thirdPartyInfo:(NSString*)info
                     completionHandler:(OCJHttpResponseHander)handler;

#pragma mark - =====电视用户手机登录
/**
 电视用户手机登录接口
 
 @param mobileNum 手机号
 @param verifyCode 验证码
 @param customName 用户名
 @param custNo 用户编号
 @param internetID 用户网络编号
 @param info 第三方用户信息
 */
+ (void)ocjAuth_loginWithMobileNum:(NSString*)mobileNum
                        verifyCode:(NSString*)verifyCode
                        customName:(NSString*)customName
                            custNo:(NSString*)custNo
                        internetID:(NSString*)internetID
                    thirdPartyInfo:(NSString*)info
                 completionHandler:(OCJHttpResponseHander)handler;

#pragma mark - =====电视用户固话登录
/**
 TV用户信息验证
 
 @param telephone 电话号码
 @param name 会员姓名
 @param handler 回调block
 */
+ (void)ocjAuth_verifyTVUserWithTelephone:(NSString *)telephone
                                     name:(NSString *)name
                        completionHandler:(OCJHttpResponseHander)handler;

/**
 会员最近购买过的商品混淆列表
 
 @param memberID 会员id
 @param handler 回调block
 */
+ (void)ocjAuth_checkHistoryGoodsWithMemberID:(NSString *)memberID
                            completionHandler:(OCJHttpResponseHander)handler;

/**
 安全校验(固话会员登录)
 
 @param memberID 会员id
 @param custName 会员名称
 @param hist_receivers 最近收货人姓名
 @param hist_address 最近收货人地址
 @param hist_items 最近购买商品
 @param info 第三方用户信息
 @param handler 回调block
 */
+ (void)ocjAuth_securityCheckWithMemberID:(NSString *)memberID
                                 custName:(NSString*)custName
                                 telPhone:(NSString*)telPhone
                         historyReceivers:(NSString *)hist_receivers
                           historyAddress:(NSString *)hist_address
                             historyItems:(NSString *)hist_items
                           thirdPartyInfo:(NSString*)info
                        completionHandler:(OCJHttpResponseHander)handler;


/**
 电视固话用户首次登录后绑定手机

 @param mobile 手机号码
 @param verifyCode 验证码
 @param custName 用户姓名
 @param custNo 用户编号
 @param internetID 用户网络编号
 @param password 密码
 @param handler 回调block
 */
+ (void)ocjAuth_TVUserBindingMobile:(NSString*)mobile
                         verifyCode:(NSString*)verifyCode
                           custName:(NSString*)custName
                             custNo:(NSString*)custNo
                         internetID:(NSString*)internetID
                           password:(NSString*)password
                  completionHandler:(OCJHttpResponseHander)handler;

#pragma mark - 注册
/**
 根据手机号码和验证码一步注册，注册完即登录成功
 
 @param mobile 手机号码
 @param verifyCode 验证码
 @param New_pwd 登录密码
 @param internetID 用户网络编号
 @param companyCode 分公司编号
 @param info 第三方用户信息
 @param handler 回调block
 */
+ (void)ocjAuth_registerWithMobile:(NSString *)mobile
                        verifyCode:(NSString *)verifyCode
                            newPwd:(NSString *)New_pwd
                        internetID:(NSString*)internetID
                       companyCode:(NSString*)companyCode
                    thirdPartyInfo:(NSString*)info
                 completionHandler:(OCJHttpResponseHander)handler;

#pragma mark - 找回密码

/**
 向邮箱发送找回密码链接
 
 @param email 邮箱地址
 @param handler 回调block
 */
+ (void)ocjAuth_sendEmailCodeWithEmail:(NSString *)email
                     completionHandler:(OCJHttpResponseHander)handler;



#pragma mark - 第三方登录模块

/**
 获取支付宝跳转凭证

 @param handler 回调block
 */
+ (void)ocjAuth_thirdParty_getAlipaySecertCompletionHandler:(OCJHttpResponseHander)handler;


/**
 获取支付宝用户唯一ID

 @param code 支付宝客户端返回的安全码
 @param handler 回调block
 */
+ (void)ocjAuth_thirdParty_getAlipayOpenIDWithCode:(NSString*)code
                                 completionHandler:(OCJHttpResponseHander)handler;


/**
 获取微信用户唯一ID
 
 @param code 微信客户端返回的安全码
 @param handler 回调block
 */
+ (void)ocjAuth_thirdParty_getWechatOpenIDWithCode:(NSString*)code
                                 completionHandler:(OCJHttpResponseHander)handler;


/**
 获取微博用户唯一ID
 
 @param code 微博客户端返回的安全码
 @param handler 回调block
 */
+ (void)ocjAuth_thirdParty_getWeiboOpenIDWithCode:(NSString*)code
                                completionHandler:(OCJHttpResponseHander)handler;


/**
 获取QQ用户唯一ID
 
 @param code QQ客户端返回的安全码
 @param handler 回调block
 */
+ (void)ocjAuth_thirdParty_getQQOpenIDWithCode:(NSString*)code
                             completionHandler:(OCJHttpResponseHander)handler;


#pragma mark - 地区设置
/**
获取省份名称
*/
+ (void)ocjAuth_checkProvniceNameWithCompletionHandler:(OCJHttpResponseHander)handler;




#pragma mark - **暂未使用
/**
 手机验证码准确性检查接口
 
 @param mobile 手机号码
 @param verify_code 验证码
 @param purpose 验证码用途
 @param handler 回调block
 */
+ (void)ocjAuth_checkSmscodeWithMobile:(NSString *)mobile
                            verifyCode:(NSString *)verify_code
                               purpose:(NSString *)purpose
                     completionhandler:(OCJHttpResponseHander)handler;

@end
