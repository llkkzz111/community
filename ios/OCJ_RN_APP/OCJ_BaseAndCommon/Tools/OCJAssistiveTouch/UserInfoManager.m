//
//  UserInfoManager.m
//  NovelApp
//
//  Created by 杨川 on 16/12/7.
//  Copyright © 2016年 杨川. All rights reserved.
//

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

#import <UserNotifications/UserNotifications.h>
#import "UserInfoManager.h"
#import "EaseSDKHelper.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "TransferAccountsExtModel.h"
#import "ChatSendRedModel.h"
#import "NSDate+Category.h"
#import "CalendarDate.h"
#import "ChatExtShareDataModel.h"
#import "ContactsModel.h"
#import "PublicPersonalHomepageModel.h"
static UserInfoManager *sharedInstance = nil;
static NSString *cacheUser = @"userInfo";
static NSString *cacheLoginState = @"loginState";
static NSString *cachePwd = @"userPwd";
@interface UserInfoManager()<CLLocationManagerDelegate>{
    id _locationManagerBlock;
    BOOL _isPlacemark;
}
@property(strong, nonatomic) NSMutableArray *delegates;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
/**
 *定位
 */
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
@implementation UserInfoManager
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserInfoManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark -- 添加环信代理
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
        [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
        [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
        [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageDidSuccess:) name:EaseSendMessageSuccess object:nil];
    }
    return self;
}
#pragma mark -- 删除环信代理
- (void)dealloc{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].callManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EaseSendMessageSuccess object:nil];
}
- (void)setLocationCity:(NSString *)locationCity{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (locationCity) {
        NSString *key = nil;
        if (self.isLogin) {
            key = [NSString stringWithFormat:@"%@_locationCity_key",self.userInfo.cid];
        }else{
            key = [NSString stringWithFormat:@"locationCity_key"];
        }
        [userDefaults setObject:locationCity forKey:key];
        [userDefaults synchronize];
    }
}
- (BOOL)isOpenCurrentVersion{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *version = [userDefault objectForKey:@"isOpenCurrentVersion"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (version && [version isKindOfClass:[NSString class]] && [currentVersion isKindOfClass:[NSString class]] && [version isEqualToString:currentVersion]) {
        _isOpenCurrentVersion = YES;
    }else{
        [userDefault setObject:currentVersion forKey:@"isOpenCurrentVersion"];
        [userDefault synchronize];
        _isOpenCurrentVersion = NO;
    }
    return _isOpenCurrentVersion;
}
- (NSString *)loginEMName{
    NSString *name = [UserInfoManager loginEMNameWithUserid:self.userInfo.cid];
    return name;
}
+ (NSString *)loginEMNameWithUserid:(NSString *) userid{
    return [NSString stringWithFormat:@"%@_%@",BASE_CRERATE_HX,userid];;
}
- (NSString *)locationCity{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *locationCity = nil;
    NSString *key = nil;
    if (self.isLogin) {
        key = [NSString stringWithFormat:@"%@_locationCity_key",self.userInfo.cid];
    }else{
        key = [NSString stringWithFormat:@"locationCity_key"];
    }
    if ([userDefaults objectForKey:key] && [[userDefaults objectForKey:key] isKindOfClass:[NSString class]]) {
        locationCity = [userDefaults objectForKey:key];
    }
    return locationCity;
}
#pragma mark -- 是否完善档案
- (BOOL)isFinishPer{
    UserInfoModel *userInfo = self.userInfo;
    if (userInfo.is_Interest && [userInfo.is_Interest floatValue] > 0) {
        return YES;
    }
    return NO;
}
#pragma mark -- 懒加载定位
- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        if ([CLLocationManager locationServicesEnabled]) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            if ([[[UIDevice currentDevice]systemVersion] doubleValue] >= 8.0)
            {
                // 设置定位权限仅iOS8以上有意义,而且iOS8以上必须添加此行代码
                [self.locationManager requestWhenInUseAuthorization];//前台定位
                // [self.locationManager requestAlwaysAuthorization];//前后台同时定位
            }
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 5.0f;
        }
    }
    return _locationManager;
}
#pragma mark -- 懒加载代理数组
- (NSMutableArray *)delegates{
    if (!_delegates) {
        _delegates = [[NSMutableArray alloc] init];
    }
    return _delegates;
}
#pragma mark -- 登录 储存用户信息
- (UserInfoModel *)loginUserInfo:(NSDictionary *)user{
    UserInfoModel *userInfo = [self cacheUserInfo:user];
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(userLoginSuccessWithUserInfo:)]) {
            [delegate userLoginSuccessWithUserInfo:userInfo];
        }
//        if ([delegate respondsToSelector:@selector(userLoginStateWithFlag:)]) {
//            [delegate userLoginStateWithFlag:YES];
//        }
    }
    
    return userInfo;
}
#pragma mark -- 刷新用户信息
- (UserInfoModel *__nullable)updateUserInfo:(NSDictionary *)user{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[self.userInfo toDictionary]];
    [dic addEntriesFromDictionary:user];
    UserInfoModel *userInfo = [self cacheUserInfo:dic];
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(userLoginUserInfoUpdate:)]) {
            [delegate userLoginUserInfoUpdate:userInfo];
        }
    }
    return userInfo;
}

#pragma mark -- 缓存企业主信息
- (PublicPersonalHomepageModel *__nullable)cacheCompanyInfo:(NSDictionary *_Nullable) info{
    PublicPersonalHomepageModel *model = [[PublicPersonalHomepageModel alloc] initWithDictionary:info error:nil];
    NSString *key = [NSString stringWithFormat:@"%@_cacheCompanyInfo",self.userInfo.cid];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:info forKey:key];
    [userDefault synchronize];
    return model;
}

- (PublicPersonalHomepageModel *)companyInfo{
     NSString *key = [NSString stringWithFormat:@"%@_cacheCompanyInfo",self.userInfo.cid];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [userDefault objectForKey:key];
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        return [[PublicPersonalHomepageModel alloc] initWithDictionary:data error:nil];
    }
    return nil;
}



#pragma mark -- 根据核伙人等级返回图片
+ (UIImage *)imageMedalWithLevel:(NSString *) level{
    NSString *imgName = @"";
    if ([level isEqualToString:@"1"]) {
        imgName = @"核伙人_金牌";
    }else if ([level isEqualToString:@"2"]){
        imgName = @"核伙人_银牌";
    }else if ([level isEqualToString:@"3"]){
        imgName = @"核伙人_铜牌";
    }else if ([level isEqualToString:@"4"]){
        imgName = @"普通核伙人_勋章";
    }else{
        return nil;
    }
    return [UIImage imageNamed:imgName];
}

#pragma mark -- 退出登录
- (void)outLoginCompletion: (void (^ __nullable)(BOOL isSuccess,NSString * _Nullable error))completion{
    __block id __blockCompletion = completion;
    k_WeakSelf;
    [HTTPManager httpLoginOutWithRequestFinish:^(id result) {
        __weakSelf.isLogin = NO;
        for (id<UserInfoManagerDelegate> delegate in __weakSelf.delegates) {
            if ([delegate respondsToSelector:@selector(userLoginStateWithFlag:)]) {
                [delegate userLoginStateWithFlag:NO];
            }
        }
        if (__blockCompletion) {
            ((void (^ __nullable)(BOOL isSuccess,NSString * _Nullable error))__blockCompletion)(YES,result);
        }
    } withRequestProgressBlock:^(NSProgress *progress) {
        
    } withRequestFailure:^(id result) {
        if (__blockCompletion) {
            ((void (^ __nullable)(BOOL isSuccess,NSString * _Nullable error))__blockCompletion)(NO,result);
        }
    }];
}


#pragma mark -- 开始定位 定位一次
- (void)locationManagerWithPlacemark:(BOOL) isPlacemark Completion: (void (^ __nullable)(BOOL isSuccess,CLLocationCoordinate2D coordinate,NSArray<CLPlacemark *> *_Nullable placemarks,NSString * _Nullable error))completion{
    if ([CLLocationManager locationServicesEnabled]) {
        _isPlacemark = isPlacemark;
        _locationManagerBlock = completion;
        [self.locationManager stopUpdatingLocation];
        [self.locationManager startUpdatingLocation];
        [HttpNetworkRequest startAnimating];
    }else{
        if (completion) {
            ((void (^ __nullable)(BOOL isSuccess,CLLocationCoordinate2D coordinate,NSArray<CLPlacemark *> *_Nullable placemarks,NSString * _Nullable error))completion)(NO,self.coordinate,nil,@"没有打开定位服务");
        }
        
    }
    
}

#pragma mark -- locationManager 定位代理
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self.locationManager stopUpdatingLocation];
    [HttpNetworkRequest stopAnimating];
    if (_locationManagerBlock) {
        ((void (^ __nullable)(BOOL isSuccess,CLLocationCoordinate2D coordinate,NSArray<CLPlacemark *> *_Nullable placemarks,NSString * _Nullable error))_locationManagerBlock)(NO,self.coordinate,nil,@"定位失败");
        _locationManagerBlock = nil;
    }
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
            [delegate locationManager:manager didFailWithError:error];
        }
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [HttpNetworkRequest stopAnimating];
    k_WeakSelf;
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = locations.lastObject;
    
    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
//    NSDictionary *testdic = BMKConvertBaiduCoorFrom(currentLocation.coordinate,BMK_COORDTYPE_COMMON);
//    //转换GPS坐标至百度坐标
//    testdic = BMKConvertBaiduCoorFrom(currentLocation.coordinate,BMK_COORDTYPE_GPS);
    
    self.coordinate = currentLocation.coordinate;//CLLocationCoordinate2DMake([[testdic objectForKey:@"x"] floatValue], [[testdic objectForKey:@"y"] floatValue]);
    
    if (_isPlacemark) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (_locationManagerBlock) {
                if (error) {
                    ((void (^ __nullable)(BOOL isSuccess,CLLocationCoordinate2D coordinate,NSArray<CLPlacemark *> *_Nullable placemarks,NSString * _Nullable error))_locationManagerBlock)(NO,__weakSelf.coordinate,placemarks,error.localizedDescription);
                }else{
                   ((void (^ __nullable)(BOOL isSuccess,CLLocationCoordinate2D coordinate,NSArray<CLPlacemark *> *_Nullable placemarks,NSString * _Nullable error))_locationManagerBlock)(YES,__weakSelf.coordinate,placemarks,@"定位成功");
                }
                _locationManagerBlock = nil;
            }
        }];
    }else{
        if (_locationManagerBlock) {
            ((void (^ __nullable)(BOOL isSuccess,CLLocationCoordinate2D coordinate,NSArray<CLPlacemark *> *_Nullable placemarks,NSString * _Nullable error))_locationManagerBlock)(YES,__weakSelf.coordinate,nil,@"定位成功");
            _locationManagerBlock = nil;
        }
        
    }
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(locationManager:didUpdateLocations:)]) {
            [delegate locationManager:manager didUpdateLocations:locations];
        }
    }
}


#pragma mark -- 发送退出登录通知
- (void)outLoginNotification{
    self.isLogin = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:switchToLoginVC object:nil];
}


#pragma mark -- 设置代理
- (void)setDelegate:(id<UserInfoManagerDelegate>)delegate{
    if (delegate) {
        [self.delegates addObject:delegate];
    }
}
#pragma mark -- 删除代理 当试图控制器被释放的时候 必须删除代理
- (void)removeManagerDelegate:(id<UserInfoManagerDelegate>)delegate{
    if (delegate) {
        [self.delegates removeObject:delegate];
    }
}
#pragma mark -- 设置登录状态 是否登录
- (void)setIsLogin:(BOOL)isLogin{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithBool:isLogin] forKey:cacheLoginState];
    [userDefault synchronize];
    
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(userLoginStateWithFlag:)]) {
            [delegate userLoginStateWithFlag:isLogin];
        }
    }
    
    if (isLogin == YES) {//获取档案信息
        [HTTPManager httpGetPersonalInfoWithRequestFinish:^(UserInfoModel *userInfo) {
            
        } withRequestProgressBlock:^(NSProgress *progress) {
            
        } withRequestFailure:^(id result) {
            
        }];
        
        if ([[UserInfoManager sharedInstance].userInfo.verify_entrepreneur isEqualToString:@"1"]) {
            //缓存企业主信息
            [HTTPManager httpGetPersonalHomepageInfoWithId:nil withType:0 withRequestFinish:^(id result) {
                
            } withRequestProgressBlock:^(NSProgress *progress) {
                
            } withRequestFailure:^(id result) {
                
            }];
        }
        
    }
    
}

- (BOOL)isRedAlert{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"isRedAlert_%@",self.userInfo.cid];
    NSNumber *value = [userDefault objectForKey:key];
    if (!value || ![value isKindOfClass:[NSNumber class]]) {
        [userDefault setObject:[NSNumber numberWithBool:NO] forKey:key];
        [userDefault synchronize];
        return YES;
    }
    return [value boolValue];
}

#pragma mark -- 获取登录状态 是否登录
- (BOOL)isLogin{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [[userDefault objectForKey:cacheLoginState] boolValue];
}
#pragma mark -- 储存登录密码
- (void)setPassword:(NSString *)password{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:password forKey:cachePwd];
    [userDefault synchronize];
}
#pragma mark -- 获取登录密码
- (NSString *)password{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:cachePwd];
}

#pragma mark -- 缓存 user信息  返回 model类
- (UserInfoModel *)cacheUserInfo:(NSDictionary *)user{
    UserInfoModel *userInfo = [[UserInfoModel alloc] initWithDictionary:user error:nil];
    if (userInfo.cavatar.length > 0) {
        //字条串是否包含有某字符串
        if (([userInfo.cavatar rangeOfString:BASE_URL_IMAGE].location == NSNotFound)) {
            //不包含
            userInfo.cavatar = [NSString stringWithFormat:@"%@%@",BASE_URL_IMAGE,userInfo.cavatar];//拼接完整的URL
        }
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[userInfo toDictionary] forKey:cacheUser];
    [userDefault synchronize];
    return userInfo;
}
#pragma mark -- 读取登录的用户信息
- (UserInfoModel *)userInfo{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *user = [userDefault objectForKey:cacheUser];
    if ([user isKindOfClass:[NSDictionary class]]) {
        return [[UserInfoModel alloc] initWithDictionary:user error:nil];
    }
    return [[UserInfoModel alloc] init];
}




#pragma mark -- 统计未读消息数
- (NSInteger)upUnreadMessageCount{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    return unreadCount;
}

#pragma mark -- 从服务器获取推送属性
- (void)asyncPushOptions
{
//    [[EMClient sharedClient] getPushNotificationOptionsFromServerWithCompletion:^(EMPushOptions *aOptions, EMError *aError) {
//        
//    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = nil;
//        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
//    });
}

#pragma mark -- 获取用户所有群组
- (void)asyncGroupFromServer
{
//    k_WeakSelf;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient].groupManager getJoinedGroups];
//        EMError *error = nil;
        [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:0 pageSize:-1 completion:^(NSArray *aList, EMError *aError) {
            
        }];
//        if (!error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //刷新group
//            });
//        }
    });
}

#pragma mark -- 获取所有会话，如果内存中不存在会从DB中加载
- (void)asyncConversationFromDB
{
//    k_WeakSelf;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:nil];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新会话列表
        });
    });
}

#pragma mark - EMClientDelegate

#pragma mark -- 网络状态变化回调
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(connectionStateDidChange:)]) {
            [delegate connectionStateDidChange:aConnectionState];
        }
    }
}
#pragma mark -- 自动登录完成时的回调
- (void)autoLoginDidCompleteWithError:(EMError *)error
{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(autoLoginDidCompleteWithError:)]) {
            [delegate autoLoginDidCompleteWithError:error];
        }
    }
    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"自动登录失败，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        alertView.tag = 100;
//        [alertView show];
    } else if([[EMClient sharedClient] isConnected]){
//        UIView *view = self.mainVC.view;
//        [MBProgressHUD showHUDAddedTo:view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL flag = [[EMClient sharedClient] migrateDatabaseToLatestSDK];
            if (flag) {
                [self asyncGroupFromServer];
                [self asyncConversationFromDB];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideAllHUDsForView:view animated:YES];
            });
        });
    }
}
#pragma mark -- 当前登录账号在其它设备登录时会接收到此回调
- (void)userAccountDidLoginFromOtherDevice
{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(userAccountDidLoginFromOtherDevice)]) {
            [delegate userAccountDidLoginFromOtherDevice];
        }
    }
}
#pragma mark -- 当前登录账号已经被从服务器端删除时会收到该回调
- (void)userAccountDidRemoveFromServer
{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(userAccountDidRemoveFromServer)]) {
            [delegate userAccountDidRemoveFromServer];
        }
    }
}
#pragma mark -- 服务被禁用
- (void)userDidForbidByServer
{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(userDidForbidByServer)]) {
            [delegate userDidForbidByServer];
        }
    }
}

#pragma mark -- 会话列表发生变化 <EMConversation>
- (void)conversationListDidUpdate:(NSArray *)aConversationList{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(conversationListDidUpdate:)]) {
            [delegate conversationListDidUpdate:aConversationList];
        }
    }
}

#pragma mark -- 收到消息 <EMMessage>
- (void)messagesDidReceive:(NSArray *)aMessages{
    
    for (EMMessage *message in aMessages) {
        [self showNotificationWithMessage:message];//将消息本地推送
    }
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(messagesDidReceive:)]) {
            [delegate messagesDidReceive:aMessages];
        }
    }
}
#pragma mark -- 消息发送成功 EMMessage
- (void)sendMessageDidSuccess:(NSNotification *) notification{
    EMMessage *message = notification.object;
    if ([message isKindOfClass:[EMMessage class]]) {
        for (id<UserInfoManagerDelegate> delegate in self.delegates) {
            if (delegate && [delegate respondsToSelector:@selector(sendMessageDidSuccess:)]) {
                [delegate sendMessageDidSuccess:message];
            }
        }
    }
    
}
#pragma mark -- 离开群组回调
- (void)didLeaveGroup:(EMGroup *)aGroup reason:(EMGroupLeaveReason)aReason{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(didLeaveGroup:reason:)]) {
            [delegate didLeaveGroup:aGroup reason:aReason];
        }
    }
}
#pragma mark -- 群组的群主收到用户的入群申请 ，群的类型是EMGroupStylePublicJoinNeedApproval  aGroup     群组实例  aUsername 申请者  aReason    申请者的附属信息
- (void)joinGroupRequestDidReceive:(EMGroup *)aGroup user:(NSString *)aUsername reason:(NSString *)aReason{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(joinGroupRequestDidReceive:user:reason:)]) {
            [delegate joinGroupRequestDidReceive:aGroup user:aUsername reason:aReason];
        }
    }
}
#pragma mark -- SDK自动同意了用户A的加B入群邀请后，用户B接收到该回调，需要设置EMOptions的isAutoAcceptGroupInvitation为YES  aGroup    群组实例  aInviter  邀请者  aMessage  邀请消息
- (void)didJoinGroup:(EMGroup *)aGroup inviter:(NSString *)aInviter message:(NSString *)aMessage{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(didJoinGroup:inviter:message:)]) {
            [delegate didJoinGroup:aGroup inviter:aInviter message:aMessage];
        }
    }
}
#pragma mark -- 群主拒绝用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval aGroupId    群组ID  aReason     拒绝理由
- (void)joinGroupRequestDidDecline:(NSString *)aGroupId reason:(NSString *)aReason{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(joinGroupRequestDidDecline:reason:)]) {
            [delegate joinGroupRequestDidDecline:aGroupId reason:aReason];
        }
    }
}
#pragma mark -- 群主同意用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval  aGroup   通过申请的群组
- (void)joinGroupRequestDidApprove:(EMGroup *)aGroup{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(joinGroupRequestDidApprove:)]) {
            [delegate joinGroupRequestDidApprove:aGroup];
        }
    }
}
#pragma mark -- 用户A邀请用户B入群,用户B接收到该回调  aGroupId    群组ID  aInviter    邀请者  aMessage    邀请信息
- (void)groupInvitationDidReceive:(NSString *)aGroupId inviter:(NSString *)aInviter message:(NSString *)aMessage{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(groupInvitationDidReceive:inviter:message:)]) {
            [delegate groupInvitationDidReceive:aGroupId inviter:aInviter message:aMessage];
        }
    }
}

#pragma mark -- 用户B同意用户A的加好友请求后，用户A会收到这个回调  aUsername   用户B
- (void)friendRequestDidApproveByUser:(NSString *)aUsername{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(friendRequestDidApproveByUser:)]) {
            [delegate friendRequestDidApproveByUser:aUsername];
        }
    }
}
#pragma mark -- 用户B拒绝用户A的加好友请求后，用户A会收到这个回调 aUsername   用户B
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(friendRequestDidDeclineByUser:)]) {
            [delegate friendRequestDidDeclineByUser:aUsername];
        }
    }
}
#pragma mark -- 用户B删除与用户A的好友关系后，用户A会收到这个回调   aUsername   用户B
- (void)friendshipDidRemoveByUser:(NSString *)aUsername{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(friendshipDidRemoveByUser:)]) {
            [delegate friendshipDidRemoveByUser:aUsername];
        }
    }
}
#pragma mark -- 用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调  aUsername   用户好友关系的另一方
- (void)friendshipDidAddByUser:(NSString *)aUsername{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(friendshipDidAddByUser:)]) {
            [delegate friendshipDidAddByUser:aUsername];
        }
    }
}
#pragma mark -- 用户B申请加A为好友后，用户A会收到这个回调  aUsername   用户B   aMessage    好友邀请信息
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(friendRequestDidReceiveFromUser:message:)]) {
            [delegate friendRequestDidReceiveFromUser:aUsername message:aMessage];
        }
    }
}
#pragma mark -- 有用户加入聊天室  aChatroom    加入的聊天室   aUsername    加入者
- (void)userDidJoinChatroom:(EMChatroom *)aChatroom user:(NSString *)aUsername{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(userDidJoinChatroom:user:)]) {
            [delegate userDidJoinChatroom:aChatroom user:aUsername];
        }
    }
}
#pragma mark -- 有用户离开聊天室  aChatroom    离开的聊天室   aUsername    离开者
- (void)userDidLeaveChatroom:(EMChatroom *)aChatroom user:(NSString *)aUsername{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(userDidLeaveChatroom:user:)]) {
            [delegate userDidLeaveChatroom:aChatroom user:aUsername];
        }
    }
}
#pragma mark -- 被踢出聊天室  aChatroom    被踢出的聊天室    aReason      被踢出聊天室的原因
- (void)didDismissFromChatroom:(EMChatroom *)aChatroom reason:(EMChatroomBeKickedReason)aReason{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(didDismissFromChatroom:reason:)]) {
            [delegate didDismissFromChatroom:aChatroom reason:aReason];
        }
    }
}


#pragma mark -- 用户A拨打用户B，用户B会收到这个回调
- (void)callDidReceive:(EMCallSession *)aSession{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(callDidReceive:)]) {
            [delegate callDidReceive:aSession];
        }
    }
}

#pragma mark -- 通话通道建立完成，用户A和用户B都会收到这个回调
- (void)callDidConnect:(EMCallSession *)aSession{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(callDidConnect:)]) {
            [delegate callDidConnect:aSession];
        }
    }
}

#pragma mark -- 用户B同意用户A拨打的通话后，用户A会收到这个回调
- (void)callDidAccept:(EMCallSession *)aSession{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(callDidAccept:)]) {
            [delegate callDidAccept:aSession];
        }
    }
}

#pragma mark --  1. 用户A或用户B结束通话后，对方会收到该回调   2. 通话出现错误，双方都会收到该回调
- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(callDidEnd:reason:error:)]) {
            [delegate callDidEnd:aSession reason:aReason error:aError];
        }
    }
}

#pragma mark -- 用户A和用户B正在通话中，用户A中断或者继续数据流传输时，用户B会收到该回调
- (void)callStateDidChange:(EMCallSession *)aSession
                      type:(EMCallStreamingStatus)aType{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(callStateDidChange:type:)]) {
            [delegate callStateDidChange:aSession type:aType];
        }
    }
}

#pragma mark -- 用户A和用户B正在通话中，用户A的网络状态出现不稳定，用户A会收到该回调
- (void)callNetworkDidChange:(EMCallSession *)aSession
                      status:(EMCallNetworkStatus)aStatus{
    for (id<UserInfoManagerDelegate> delegate in self.delegates) {
        if (delegate && [delegate respondsToSelector:@selector(callNetworkDidChange:status:)]) {
            [delegate callNetworkDidChange:aSession status:aStatus];
        }
    }
}





#pragma mark -- 登录环信账号  设置是否自动登录  设置是否自动同意群邀请  设置是否自动同意好友邀请
- (void)loginHyAccount:(NSString *) account withPassword:(NSString *) password withCompletion: (void (^ __nullable)(UserInfoModel * _Nullable userInfo,BOOL isSuccess,NSString *message))completion{
//    //登录成功
//    if (completion) {
//        completion([UserInfoManager sharedInstance].userInfo,YES,@"聊天服务器登录成功");
//    }
//    return;
    
    [HttpNetworkRequest startAnimating];
    NSString *username = [UserInfoManager loginEMNameWithUserid:account];
    NSString *emPwd = account;//[HttpNetworkRequest md5_32_bit:@"123456"];
    //异步登录账号
    k_WeakSelf;
    __block id __blockCompletion = completion;
    [[EMClient sharedClient] registerWithUsername:username password:emPwd completion:^(NSString *aUsername, EMError *error) {
        NSLog(@"err:%@",error.errorDescription);
        [[EMClient sharedClient] loginWithUsername:username password:emPwd completion:^(NSString *aUsername, EMError *aError) {
            [__weakSelf showError:aError withCompletion:__blockCompletion];
        }];
        
    }];
    
    
}

- (void)showError:(EMError *) error withCompletion: (void (^ __nullable)(UserInfoModel * _Nullable userInfo,BOOL isSuccess,NSString *message))completion{
    if (!error) {
        [self setUserHYWithCompletion:completion];
    } else {
        [HttpNetworkRequest stopAnimating];
        switch (error.code)
        {
                
            case EMErrorNetworkUnavailable:
                if (completion) {
                    completion([UserInfoManager sharedInstance].userInfo,NO,@"网络链接失败");
                }
                break;
            case EMErrorServerNotReachable:
                if (completion) {
                    completion([UserInfoManager sharedInstance].userInfo,NO,@"服务器未连接");
                }
                break;
            case EMErrorUserAuthenticationFailed:
                if (completion) {
                    completion([UserInfoManager sharedInstance].userInfo,NO,error.errorDescription);
                }
                break;
            case EMErrorServerTimeout:
                if (completion) {
                    completion([UserInfoManager sharedInstance].userInfo,NO,@"连接到服务器超时");
                }
                break;
            case EMErrorServerServingForbidden:
                if (completion) {
                    completion([UserInfoManager sharedInstance].userInfo,NO,@"获取DNS设置失败");
                }
                break;
            default:
                if (completion) {
                    completion([UserInfoManager sharedInstance].userInfo,NO,error.errorDescription);
                }
                break;
        }
    }
}

- (void)setUserHYWithCompletion: (void (^ __nullable)(UserInfoModel * _Nullable userInfo,BOOL isSuccess,NSString *message))completion{
    //设置是否自动登录
    [[EMClient sharedClient].options setIsAutoLogin:YES];
    //设置是否自动同意群邀请
    [[EMClient sharedClient].options setIsAutoAcceptGroupInvitation:YES];
    //设置是否自动同意好友邀请
    [[EMClient sharedClient].options setIsAutoAcceptFriendInvitation:YES];
    //登录成功 设置推送昵称
    NSString *nickName = [UserInfoManager sharedInstance].userInfo.cnick;
    [[EMClient sharedClient] getPushNotificationOptionsFromServerWithCompletion:^(EMPushOptions *aOptions, EMError *aError) {
        
        EMPushOptions *options = [[EMClient sharedClient] pushOptions];
        options.displayName = nickName;
        options.noDisturbStatus = EMPushNoDisturbStatusClose;//关闭免打扰
        [[EMClient sharedClient] updatePushNotificationOptionsToServerWithCompletion:^(EMError *aError) {
            
            
            
            
        }];
        
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] migrateDatabaseToLatestSDK];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UserInfoManager sharedInstance] asyncGroupFromServer];
            [[UserInfoManager sharedInstance] asyncConversationFromDB];
            [[UserInfoManager sharedInstance] asyncPushOptions];
            [HttpNetworkRequest stopAnimating];
            [UserInfoManager sharedInstance].isLogin = YES;
            //登录成功
            if (completion) {
                completion([UserInfoManager sharedInstance].userInfo,YES,@"聊天服务器登录成功");
            }
            
        });
    });
    
}


#pragma mark -- 当前会话最后消息的时间
- (NSString *)lastMessageTimeForConversationModel:(EMConversation *)conversationModel{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel latestMessage];;
    if (lastMessage) {
//        double timeInterval = lastMessage.timestamp ;
//        if(timeInterval > 140000000000) {
//            timeInterval = timeInterval / 1000;
//        }
//        latestMessageTime = [self stringDateInterval:timeInterval];
        latestMessageTime = [self messageTimeForEMMessage:lastMessage];
    }
    return latestMessageTime;
}

#pragma mark -- 获取当前消息的时间
- (NSString *__nullable)messageTimeForEMMessage:(EMMessage *_Nullable) message{
    NSString *latestMessageTime = @"";
    if (message) {
        NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
        
        latestMessageTime = [messageDate formattedTime];
//        double timeInterval = message.timestamp ;
//        if(timeInterval > 140000000000) {
//            timeInterval = timeInterval / 1000;
//        }
//        latestMessageTime = [self stringDateInterval:timeInterval];
    }
    return latestMessageTime;
}


#pragma mark -- 当前会话单聊最后消息的时间
- (NSString *)lastMessageTimeForConversation:(NSString *) conversationChatter{
    EMConversation *conversation = [self getSingleChatConversation:conversationChatter];
    return [self lastMessageTimeForConversationModel:conversation];
}


- (NSString *)lastMessageTitleForConversationModel:(EMConversation *)conversationModel
{
    EMMessage *lastMessage = [conversationModel latestMessage];
    return [self messageContent:lastMessage];
}

#pragma mark -- 获取消息时间字符串 ：昨天、上午9:00 下午19:00
- (NSString *__nullable)stringDateInterval:(NSTimeInterval) interval{
    NSDate *date = [NSDate dateWithTimeIntervalue:interval];
    return date.minuteDescription;
}

#pragma mark -- 发送者用户类型
- (NSString *__nullable)messageUserType:(EMMessage *_Nullable) message{
    if (![message isKindOfClass:[EMMessage class]]) {
        return @"";
    }
    ChatExtModel *extModel = [[ChatExtModel alloc] initWithDictionary:message.ext error:nil];
    return extModel.extUserType;
}

#pragma mark -- 消息类型
+ (NSString *__nullable)messageType:(EMMessage *_Nullable) message{
    if (![message isKindOfClass:[EMMessage class]]) {
        return @"";
    }
    ChatExtModel *extModel = [[ChatExtModel alloc] initWithDictionary:message.ext error:nil];
    return extModel.extType;
}

#pragma mark -- 返回message的内容
- (NSString *__nullable)messageContent:(EMMessage *) message{
    if (![message isKindOfClass:[EMMessage class]]) {
        return @"";
    }
    EaseMessageModel *messageModel = [[EaseMessageModel alloc] initWithMessage:message];
    NSString *latestMessageTitle = @"";
    ChatExtModel *extModel = [[ChatExtModel alloc] initWithDictionary:message.ext error:nil];
    if (message) {
        NSInteger extType = [[UserInfoManager messageType:message] integerValue];
        if ([extModel.extIsReaddel isEqualToString:@"1" ] &&  !messageModel.isMessageRead && !messageModel.isSender) {
            return @"即阅即焚消息";
        }
        if (extType == 0) {//默认环信消息
            EMMessageBody *messageBody = message.body;
            switch (messageBody.type) {
                case EMMessageBodyTypeImage:{
                    latestMessageTitle = @"[图片]";
                } break;
                case EMMessageBodyTypeText:{
                    NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                                convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                    latestMessageTitle = didReceiveText;
                } break;
                case EMMessageBodyTypeVoice:{
                    latestMessageTitle = @"[语音]";
                } break;
                case EMMessageBodyTypeLocation: {
                    latestMessageTitle = @"[定位]";
                } break;
                case EMMessageBodyTypeVideo: {
                    latestMessageTitle = @"[视频]";
                } break;
                case EMMessageBodyTypeFile: {
                    latestMessageTitle = @"[文件]";
                } break;
                default: {
                } break;
            }
        }else if (extType == 1){//红包消息
//            ChatSendRedModel *extModel = [[ChatSendRedModel alloc] initWithDictionary:message.ext error:nil];
            if (messageModel.isSender) {
                latestMessageTitle = @"[您发了一个红包]";
            }else{
//                NSString *price = extModel.extPrice;
                latestMessageTitle = [NSString stringWithFormat:@"[您收到了一个红包]"];
            }
            
        }else if (extType == 2){//群红包
            if (messageModel.isSender) {
                latestMessageTitle = @"[您发了一个红包]";
            }else{
                latestMessageTitle = @"[有一个红包消息]";
            }
            
        }else if (extType == 3){//转账
//            TransferAccountsExtModel *extModel = [[TransferAccountsExtModel alloc] initWithDictionary:message.ext error:nil];
            if (messageModel.isSender) {
                latestMessageTitle = @"[转账成功]";
            }else{
//                NSString *price = extModel.extPrice;
                latestMessageTitle = [NSString stringWithFormat:@"[您收到了一笔转账]"];
            }
            
        }else if (extType == 4){
            if (messageModel.isSender) {
                latestMessageTitle = @"[您发了一个红包]";
            }else{
                latestMessageTitle = @"[有一个红包消息]";
            }
        }else if (extType == 5){
            ChatExtShareDataModel *shareModel = [[ChatExtShareDataModel alloc] initWithDictionary:extModel.extData error:nil];
            if (messageModel.isSender) {
                latestMessageTitle = [NSString stringWithFormat:@"%@(分享消息)",shareModel.title];
            }else{
                latestMessageTitle = [NSString stringWithFormat:@"%@(分享消息)",shareModel.title];
            }
        }else if (extType == 6){
            //            ChatExtShareDataModel *shareModel = [[ChatExtShareDataModel alloc] initWithDictionary:message.ext error:nil];
            ContactsModel *contactsModel = [[ContactsModel alloc] initWithDictionary:extModel.extData error:nil];
            if (messageModel.isSender) {
                latestMessageTitle = [NSString stringWithFormat:@"[%@的个人名片]",contactsModel.f_rename];
            }else{
                latestMessageTitle = [NSString stringWithFormat:@"[%@的个人名片]",contactsModel.f_rename];
            }
        }
        //0默认环信消息 1单聊赠送红包  2群红包   3转账  4单聊塞红包 5分享 6个人名片..其它待定....
        
    }
    
    if (!messageModel.isSender && (messageModel.messageType == EMChatTypeGroupChat || messageModel.messageType == EMChatTypeChatRoom)) {//群聊
        //追加名称
        if (extModel.extNickName) {
            latestMessageTitle = [NSString stringWithFormat:@"%@:%@",extModel.extNickName,latestMessageTitle];
        }
        
    }
    return latestMessageTitle;
}


#pragma mark -- 当前会话最后消息的内容
- (NSString *__nullable)lastMessageTitleForConversation:(NSString * _Nullable) conversationChatter{
    EMConversation *conversation = [self getSingleChatConversation:conversationChatter];
    return [self lastMessageTitleForConversationModel:conversation];
}



#pragma mark -- 获取单聊会话
- (EMConversation *__nullable)getSingleChatConversation:(NSString * _Nullable) conversationChatter{
    return [[EMClient sharedClient].chatManager getConversation:conversationChatter type:EMConversationTypeChat createIfNotExist:YES];
}
#pragma mark -- 获取群聊会话
- (EMConversation *__nullable)getGroupChatConversation:(NSString * _Nullable) conversationChatter{
    return [[EMClient sharedClient].chatManager getConversation:conversationChatter type:EMConversationTypeGroupChat createIfNotExist:YES];
}
#pragma mark -- 发送消息 群聊
- (void)sendGroupMessage:(NSString *_Nullable) message withChatConversation:(NSString *_Nullable) conversationChatter withChatExt:(ChatExtModel *_Nullable) extModel withProgress:(void (^ __nullable)(CGFloat progress)) progressBlock withCompletion: (void (^ __nullable)(EMMessage * _Nullable message,BOOL isSuccess,NSString * _Nullable error))completion{
    EMChatType type = EMChatTypeGroupChat;
    EMConversation *conversation = [self getSingleChatConversation:conversationChatter];
    EMMessage *emMessage = [EaseSDKHelper sendTextMessage:message to:conversation.conversationId messageType:type messageExt:[extModel toDictionary]];
    [self sendMessage:emMessage withConversation:conversation withProgress:progressBlock withCompletion:completion];
}
#pragma mark -- 发送消息单聊
- (void)sendSingleMessage:(NSString *_Nullable) message withChatConversation:(NSString *_Nullable) conversationChatter withChatExt:(ChatExtModel *_Nullable) extModel withProgress:(void (^ __nullable)(CGFloat progress)) progressBlock withCompletion: (void (^ __nullable)(EMMessage * _Nullable message,BOOL isSuccess,NSString * _Nullable error))completion{
    EMChatType type = EMChatTypeChat;
    EMConversation *conversation = [self getSingleChatConversation:conversationChatter];
    EMMessage *emMessage = [EaseSDKHelper sendTextMessage:message to:conversation.conversationId messageType:type messageExt:[extModel toDictionary]];
    [self sendMessage:emMessage withConversation:conversation withProgress:progressBlock withCompletion:completion];
}

#pragma mark -- 发送消息
- (void)sendMessage:(EMMessage *_Nullable) message withConversation:(EMConversation *_Nullable) conversation withProgress:(void (^ __nullable)(CGFloat progress)) progressBlock withCompletion: (void (^ __nullable)(EMMessage * _Nullable message,BOOL isSuccess,NSString * _Nullable error))completion{
    if (conversation.type == EMConversationTypeGroupChat){
        message.chatType = EMChatTypeGroupChat;
    }
    else if (conversation.type == EMConversationTypeChatRoom){
        message.chatType = EMChatTypeChatRoom;
    }
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        if (progressBlock) {
            progressBlock(progress);
        }
    } completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EaseSendMessageSuccess object:aMessage];
            if (completion) {
                completion(aMessage,YES,@"发送成功");
            }
        }
        else {
            if (completion) {
                completion(aMessage,NO,aError.errorDescription);
            }
        }
    }];
}


#pragma mark -- 添加好友
- (void)addContactConversationChatter:(NSString *_Nullable) conversationChatter withMessage:(NSString *_Nullable) message withCompletion: (void (^ __nullable)(BOOL isSuccess,NSString * _Nullable error))completion{
    NSString *userid = [UserInfoManager loginEMNameWithUserid:conversationChatter];
    [[EMClient sharedClient].contactManager addContact:userid message:message completion:^(NSString *aUsername, EMError *aError) {
        if (aError) {
            if (completion) {
                completion(NO,aError.errorDescription);
            }
        }else{
            if (completion) {
                completion(YES,@"好友请求已发送");
            }
        }
    }];
    
}

#pragma mark -- 将消息本地推送
- (void)showNotificationWithMessage:(EMMessage *_Nullable) message{
    BOOL stateBackground = [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground;
    if (stateBackground) {//后台运行，三分钟之内 没有断开长连接 必须用本地推送,因为离线推送 必须断开长连接以后
        EMPushOptions *options = [[EMClient sharedClient] pushOptions];
        NSString *alertBody = nil;
        
        if (options.displayStyle == EMPushDisplayStyleMessageSummary) {//显示消息内容
            alertBody = [self messageContent:message];
            
        }else{
            alertBody = @"您有一条新消息";
        }
        
        
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
        BOOL playSound = NO;
        if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
            self.lastPlaySoundDate = [NSDate date];
            playSound = YES;
        }
        
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
        [userInfo setObject:message.conversationId forKey:kConversationChatter];
        
        //发送本地推送
        if(NSClassFromString(@"UNUserNotificationCenter")) {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            if (playSound) {
                content.sound = [UNNotificationSound defaultSound];
            }
            content.body =alertBody;
            content.userInfo = userInfo;
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
        }
        else {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate date]; //触发通知的时间
            notification.alertBody = alertBody;
            notification.alertAction = NSLocalizedString(@"open", @"Open");
            notification.timeZone = [NSTimeZone defaultTimeZone];
            if (playSound) {
                notification.soundName = UILocalNotificationDefaultSoundName;
            }
            notification.userInfo = userInfo;
            
            //发送通知
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        
        
    }
    
}




@end
