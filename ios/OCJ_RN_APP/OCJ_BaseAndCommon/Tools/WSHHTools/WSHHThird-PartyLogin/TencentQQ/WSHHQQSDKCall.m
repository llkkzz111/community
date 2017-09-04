//
//  WSHHQQSDKCall.m
//  OCJ
//
//  Created by LZB on 2017/4/18.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "WSHHQQSDKCall.h"

@interface WSHHQQSDKCall ()

@property (nonatomic, retain) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) NSArray *permissionArray;

@end

@implementation WSHHQQSDKCall

+ (instancetype)sharedInstance {
    static WSHHQQSDKCall *wshh_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wshh_instance = [[self alloc] init];
    });
    return wshh_instance;
}

- (void)wshh_setTencentAppID:(NSString*)appID{
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appID andDelegate:self];
}

- (void)wshhQQLogin {
    
    _permissionArray = [NSMutableArray arrayWithObjects: kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
    _tencentOAuth.redirectURI = @"http://OCJLoginVC";
    
    [_tencentOAuth setAuthShareType:AuthShareType_QQ];
    [_tencentOAuth authorize:_permissionArray inSafari:NO];
}

- (void)wshhShareQQWithTitle:(NSString *)shareTitle url:(NSString *)shareUrl description:(NSString *)shareDescription previewImageUrl:(NSString *)sharePreviewImageUrl type:(WSHHEnumTQQShareType)shareType {
    
    if (![QQApiInterface isQQInstalled]) {
        [WSHHAlert wshh_showHudWithTitle:@"您的设备没有安装QQ客户端，请选择其他分享途径" andHideDelay:2];
        return;
    }
    
    QQApiNewsObject *newsObj;
    
    if ([sharePreviewImageUrl hasPrefix:@"http"]) {//图片url链接
        newsObj = [QQApiNewsObject
                   objectWithURL:[NSURL URLWithString:shareUrl]
                   title:shareTitle
                   description:shareDescription
                   previewImageURL:[NSURL URLWithString:sharePreviewImageUrl]];
    }else {//图片
        newsObj = [QQApiNewsObject
                   objectWithURL:[NSURL URLWithString:shareUrl]
                   title:shareTitle
                   description:shareDescription
                   previewImageData:UIImagePNGRepresentation([UIImage imageNamed:sharePreviewImageUrl])];
    }
    //分享到QQ或TIM，必须指定
    newsObj.shareDestType = [self getShareType];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //    req.type = ESENDMESSAGETOQQREQTYPE;
    
    if (shareType == WSHHEnumQQShareQZone) {//分享到QQ空间
        [QQApiInterface SendReqToQZone:req];
    }else if (shareType == WSHHEnumQQShareQFriends) {//分享到QQ好友
        [QQApiInterface sendReq:req];
    }
    
}

- (ShareDestType)getShareType
{
    BOOL flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sdkSwitchFlag"] boolValue];
    return flag? ShareDestTypeTIM :ShareDestTypeQQ;
}

- (void)tencentDidLogin {
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]) {
        /*
        BOOL info =  [_tencentOAuth getUserInfo];
        if (info) {
            OCJLog(@"YYYYYY");
        }else {
            OCJLog(@"NNNNNN");
        }
        OCJLog(@"token = %@", _tencentOAuth.accessToken);
         */
        if (self.gotoLinkingVCBlock) {
            self.gotoLinkingVCBlock(_tencentOAuth.accessToken);
        }
    }
}
- (void)tencentDidNotLogin:(BOOL)cancelled {
    OCJLog(@"NotLogin");
}

- (void)tencentDidNotNetWork {
    OCJLog(@"无网络链接");
}

- (void)getUserInfoResponse:(APIResponse *)response {
    if (response.jsonResponse) {
        //figureurl qq空间头像
        //figureurl_qq_2 qq头像
        //gender 性别
        //nickname 昵称
        //province 省份
        //city 城市
        
    }
}

//- (TencentAuthShareType)getAuthType {
//    BOOL flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sdkSwitchFlag"] boolValue];
//    return flag? AuthShareType_TIM :AuthShareType_QQ;
//}

@end
