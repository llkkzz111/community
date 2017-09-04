//
//  WSHHThirdPartyLogin.m
//  OCJ
//
//  Created by 吴志伟 on 2017/4/26.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "WSHHThirdPartyLogin.h"
#import "UPPaymentControl.h"
#import "APOpenAPI.h"

#pragma mark - 第三方配制文件区域

//微博开放应用
////抢先版
//NSString* const wshhThirdPatryWeibo_AppKey = @"2754685504"; ///< 微博开放应用key
//NSString* const wshhThirdPatryWeibo_RedirectURL = @"http://m.ocj.com.cn/main/index.jsp";///< 微博回调链接地址
//NSString* const wshhThirdPatryWeibo_scope = @"email,direct_messages_read,direct_messages_write,friendships_groups_read,friendships_groups_write,statuses_to_me_read,follow_app_official_microblog,invitation_write";///< 微博的scope

//正式版

 NSString* const wshhThirdPatryWeibo_AppKey = @"3028957123"; ///< 微博开放应用key
 NSString* const wshhThirdPatryWeibo_RedirectURL = @"http://www.ocj.com.cn/main/index.jsp";///< 微博回调链接地址
 NSString* const wshhThirdPatryWeibo_scope = @"email,direct_messages_read,direct_messages_write,friendships_groups_read,friendships_groups_write,statuses_to_me_read,follow_app_official_microblog,invitation_write";///< 微博的scope


//QQ开放应用key
NSString* const wshhThirdPatryQQ_AppID =  @"100846439";///< 正式版
//NSString* const wshhThirdPatryQQ_AppID =  @"1106275068";///< 抢先版

@implementation WSHHThirdPartyLogin

+ (void)wshh_settingThirdParty{
  //调试时打开
  //    [WeiboSDK enableDebugMode:YES];
  
  [WeiboSDK registerApp:wshhThirdPatryWeibo_AppKey];
  [[WSHHQQSDKCall sharedInstance] wshh_setTencentAppID:wshhThirdPatryQQ_AppID];
}

+ (void)wshh_thirdPartyLoginWithType:(WSHHEnumThirdPartyLoginType)loginType andSignStr:(NSString*)signStr block:(wshhThirdPartyLoginBlock)loginBlock {
  switch (loginType) {
    case WSHHEnumThirdPartyQQ:{
      
      WSHHQQSDKCall *qq = [WSHHQQSDKCall sharedInstance];
      [qq wshhQQLogin];
      qq.gotoLinkingVCBlock = ^(id data) {
        loginBlock(data);
      };
    }break;
    case WSHHEnumThirdPartyWX:{
      
      [[WSHHWXLogin sharedInstance] wshhWXLoginCompletionHandler:^(id data) {
        loginBlock(data);
      }];
    }break;
    case WSHHEnumThirdPartyWeibo:{
      
      [[WSHHWeiboLogin sharedInstance] wshhWeiboLoginWithRedirectURL:wshhThirdPatryWeibo_RedirectURL scope:wshhThirdPatryWeibo_scope completionHandler:^(id data) {
        loginBlock(data);
      }];
      
    }
      break;
    case WSHHEnumThirdPartyAlipay:{
      [[WSHHAlipayLogin sharedInstance] wshhAlipayLoginWithSignStr:signStr completionHandler:^(id data) {
        loginBlock(data);
      }];
    }break;
      
      
    default:
      break;
  }
}

+ (BOOL)wshh_thirdPartyIsInstalledWithType:(WSHHEnumThirdPartyLoginType)type {
  switch (type) {
    case WSHHEnumThirdPartyQQ:
      if ([TencentOAuth iphoneQQInstalled]) {
        return YES;
      }else {
        return NO;
      }
      break;
    case WSHHEnumThirdPartyWX:
      if ([WXApi isWXAppInstalled]) {
        return YES;
      }else {
        return NO;
      }
      break;
    case WSHHEnumThirdPartyWeibo:
      if ([WeiboSDK isWeiboAppInstalled]) {
        return YES;
      }else {
        return NO;
      }
      break;
    case WSHHEnumThirdPartyAlipay:{
      NSURL *alipayUrl = [NSURL URLWithString:@"alipay:"];
      if (![[UIApplication sharedApplication] canOpenURL:alipayUrl]) {
        return NO;
      }else {
        return YES;
      }
    }break;
      
    default:
      break;
  }
  return NO;
}

+ (void)wshh_ThirdPartyShareWithShareType:(WSHHEnumShareType)shareType text:(NSString *)shareText title:(NSString *)shareTitle previewImageUrl:(NSString *)shareImageUrl url:(NSString *)shareUrl description:(NSString *)shareDescription {
  
  switch (shareType) {
    case WSHHEnumShareTypeQZone:
      [[WSHHQQSDKCall sharedInstance] wshhShareQQWithTitle:shareTitle url:shareUrl description:shareDescription previewImageUrl:shareImageUrl type:WSHHEnumQQShareQZone];
      break;
    case WSHHEnumShareTypeQFriend:
      [[WSHHQQSDKCall sharedInstance] wshhShareQQWithTitle:shareTitle url:shareUrl description:shareDescription previewImageUrl:shareImageUrl type:WSHHEnumQQShareQFriends];
      break;
    case WSHHEnumShareTypeWXSession:{
      
      [[WSHHWXLogin sharedInstance] wshhShareToWXWithText:shareText image:shareImageUrl title:shareTitle url:shareUrl type:WSHHWXShareTypeSession resultBlock:^(BaseResp *resp, enum WXErrCode errCode) {
        /*  WXSuccess           = 0,    成功
         WXErrCodeCommon     = -1,  普通错误类型
         WXErrCodeUserCancel = -2,    用户点击取消并返回
         WXErrCodeSentFail   = -3,   发送失败
         WXErrCodeAuthDeny   = -4,    授权失败
         WXErrCodeUnsupport  = -5,   微信不支持 */
        OCJLog(@"errcode = %d", errCode);
      }];
      
    }break;
    case WSHHEnumShareTypeWXTimeLine:
      [[WSHHWXLogin sharedInstance] wshhShareToWXWithText:shareText image:shareImageUrl title:shareTitle url:shareUrl type:WSHHWXShareTypeTimeline resultBlock:^(BaseResp *resp, enum WXErrCode errCode) {
        
        
      }];
      break;
    case WSHHEnumShareTypeWeibo:
      [[WSHHWeiboLogin sharedInstance] wshhShareSinaWeiboWithText:shareText image:shareImageUrl webUrl:shareUrl];
      break;
      
    default:
      break;
  }
}

@end
