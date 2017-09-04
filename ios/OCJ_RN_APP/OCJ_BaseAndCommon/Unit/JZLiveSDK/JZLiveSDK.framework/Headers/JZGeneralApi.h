//
//  JZGeneralApi.h
//  JZMSGApi
//
//  Created by wangcliff on 16/12/29.
//  Copyright © 2016年 jz. All rights reserved.
//  网络接口

#import <Foundation/Foundation.h>
@class JZCustomer;
@class JZLiveRecord;
@class JZOrder;
@class JZAuthentication;
@interface JZGeneralApi : NSObject
/*！@brief 注册app
 *  @discusstion 在application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 中调用
 *  @param appKey 叽喳官网后台注册生成的appkey
 *  @param secretKey 叽喳官网后台注册生成的appsecretKey
 */
+ (void)registerApp:(NSString *)appKey secretKey:(NSString *)secretKey;

/*！@brief 设置登录状态
 *  @discusstion 登录时设置为YES,退出时设置为NO
 *  @param flag YES为登录,NO为未登录
 */
+ (void)setLoginStatus:(BOOL)flag;

/*！@brief 获取登录状态
 *  @discusstion 验证是否登录
 *  @return YES为登录,NO为未登录
 */
+ (BOOL)getLoginStatus;

/*! @brief 获取房间在线观众数
 * @discusstion 实时变化的,可以直观的看到主播的在线观众
 * @param roomid 主播的房间号
 * @return 成功返回(NSInteger)num，失败返回error。
 */
//NSDictionary *params = @{@"roomid":_record.roomNo};
+ (NSURLSessionDataTask *)getViewersNumWithBlock:(NSDictionary *)params returnBlock:(void (^)(NSInteger num, NSError *error))block;

/*! @brief 获取房间观众列表，根据powerlevel大小排序
 * @discusstion 实时变化的,点击观众头像可以获取观众信息
 * @param roomid 主播的房间号
 * @return 成功返回(NSArray *)Viewers，失败返回error。
 */
//NSDictionary *params = @{@"roomid":_record.roomNo};
+ (NSURLSessionDataTask *)getTopFansWithBlock:(NSDictionary *)params returnBlock:(void (^)(NSArray *Viewers, NSError *error))block;

/*! @brief 获取礼物信息
 * @discusstion 在拉流端发送礼物前需要获取礼物图片及价格等
 * @param userID 根据userID请求礼物图片。
 * @return 成功返回(NSArray *)products，失败返回error。
 */
//NSDictionary* params = @{@"userID":[NSString stringWithFormat:@"%lu",(long)_user.userID]};
+ (NSURLSessionDataTask *)getProductsWithBlock:(NSDictionary *)params completeHandler:(void (^)(NSArray *products, NSError *error))block;

/*! @brief 获取用户详细信息
 * @discusstion 获取用户的详细信息
 * @param hostID 想获取的用户ID
 * @param userID 这个userID是用于判断用户是否已经关注上面这个hostID
 * @param accountType 账户类型,ios端为@"ios",为了与安卓和web区别
 * @param start 活动起始页码,一般为@"0"。
 * @param offset 每页的活动数量。
 * @param isTester 0为普通用户，1为测试用户。
 * @return 成功返回:想要的用户信息(JZCustomer *)user, (NSArray *)records用户活动, (NSInteger)allcounts用户活动总条数，失败返回error。
 */
//NSDictionary *params = @{@"hostID":[NSString stringWithFormat:@"%lu",(long)_host.id],@"userID":[NSString stringWithFormat:@"%lu",(long)_user.id],@"accountType":@"ios",@"start":@"0",@"offset":@"50",@"isTester":[NSString stringWithFormat:@"%ld",(long)_host.isTester]};
+ (NSURLSessionDataTask *)getDetailUserBlock:(NSDictionary *)params getDetailBlock:(void (^)(JZCustomer *user,NSArray *records, NSInteger allcounts, NSError *error))block;

/*! @brief 发送礼物扣除费用
 * @discusstion 获取用户的详细信息
 * @param activityID 当前的活动ID
 * @param toUserID 被送礼物的用户id
 * @param fromUserID 送礼物的用户id
 * @param giftValue 礼物的价值
 * @param giftID 发送的礼物id,特殊:购买视频id为"4",giftName为"付费视频"
 * @param giftName 发送的礼物的名字
 * @return 成功返回:flag为YES，失败返回flag为no,error。
 */
//NSDictionary *params = @{@"activityID":[NSString stringWithFormat:@"%ld",(long)block.record.activityID], @"toUserID":[NSString stringWithFormat:@"%lu",(long)block.host.id], @"fromUserID":[NSString stringWithFormat:@"%lu",(long)usercustomer.id], @"giftValue":[NSString stringWithFormat:@"%d",giftPrice*block.giftcount], @"giftID":[NSString stringWithFormat:@"%d",giftId], @"giftName":giftName};
+ (NSURLSessionDataTask *)addGiftRecordWithBlock:(NSDictionary *)params  returnBlock:(void (^)(BOOL flag, NSError *error))block;

/*! @brief 手机账号自动登录
 * @discusstion 验证用户的账号和密码,获取用户的信息
 * @param user 当前的活动ID(user.mobile和password必填,iosEid和iosDeviceToken暂时可以为空以后也是必填)
 * @return 成功返回:user(用户的个人信息)，失败返回error。
 */
//JZCustomer *user = [[JZCustomer alloc]init];
//user.password = pwd;
//user.mobile = mobile;
//user.iosEid = idfv;//设备的唯一标识符
//user.iosDeviceToken = deviceToken;//推送信息时用到
+ (NSURLSessionDataTask *)autoLoginWithBlock:(JZCustomer *)user getDetailBlock:(void (^)(NSObject *user, NSError *error))block;

/*! @brief 手机登录验证接口
 * @discusstion 验证用户的账号和密码(与上面区别是不返回个人信息),并且将账号和密码进行加密存储了,在
 userinfo_cache目录的myinfo文件里
 * @param user 当前的活动ID(user.mobile和password必填,iosEid和iosDeviceToken暂时可以为空以后也是必填)
 * @return 成功返回:error为nil，失败返回error。
 */
//JZCustomer *user = [[JZCustomer alloc]init];
//user.password = pwd;
//user.mobile = mobile;
//user.iosEid = idfv;//设备的唯一标识符
//user.iosDeviceToken = deviceToken;//推送信息时用到
+ (NSURLSessionDataTask *)loginWithBlock:(JZCustomer *)user getDetailBlock:(void (^)(NSObject *user, NSError *error))block;

/*! @brief 第三方登陆
 * @discusstion 通过友盟获取第三方的信息,传递给这个接口返回用户的信息
 * @param uid 第三方的用户ID
 * @param loginType 登录类型微信、微博
 * @param nickname 第三方的用户名字
 * @param city 第三方的用户的城市(没有可以为空)
 * @param pic1 第三方的用户的头像(没有可以为空)
 * @param sex 第三方的用户的性别
 * @return 成功返回:user(用户信息)，失败返回error。
 */
//NSDictionary * params = @{@"uid":authresponse.uid,@"loginType":@"weixin",@"nickname":userinfo.name,@"city":@"",@"pic1":userinfo.iconurl,@"sex":userinfo.gender};
+ (NSURLSessionDataTask *)thirdPrtyLoginWithBlock:(NSDictionary *) params  getDetailBlock:(void (^)(JZCustomer *user, NSError *error))block;

/*! @brief 手机注册接口
 * @discusstion 用户注册账号
 * @param user 注册时输入的信息
 * @return 成功返回:user(用户信息)，失败返回error。
 */
//JZCustomer *user = [[JZCustomer alloc]init];
//user.nickname = _nameField.text;
//user.mobile = _telphoneField.text;
//user.password = _passwordField.text;
//user.iosEid = idfv;//设备的唯一标识符
//user.iosDeviceToken = deviceToken;//推送信息时用到
+ (NSURLSessionDataTask *)regWithBlock:(JZCustomer *)user getDetailBlock:(void (^)(JZCustomer *user, NSError *error))block;

/*! @brief 获取验证码接口（注册时）
 * @discusstion 手机号注册账号时湖区验证码
 * @param mobile 注册时的手机号
 * @return 成功返回flag为YES，code为验证码,失败返回error。
 */
+ (NSURLSessionDataTask *)bindWithBlock:(NSString*)mobile getDetailBlock:(void (^)(BOOL flag, NSString *code,  NSError *error))block;

/*! @brief 获取验证码接口(找回密码时)
 * @param mobile 手机号
 * @return 成功返回flag为YES，code为验证码,失败返回error。
 */
+ (NSURLSessionDataTask *)getVerifiedCodeBlock:(NSString*)mobile getDetailBlock:(void (^)(BOOL flag, NSString *code,  NSError *error))block;

/*! @brief 修改密码接口(需要知道原密码)
 * @param user 用户的手机号,旧密码和新密码
 * @return 成功返回flag为YES，msg,失败返回error。
 */
//JZCustomer *user = [[JZCustomer alloc] init];
//user.mobile = _telphoneField.text;
//user.oldPassword = _oldPasswordField.text;
//user.newPassword = _newPasswordField.text;
+ (NSURLSessionDataTask *)changePwdBlock:(JZCustomer *)user getDetailBlock:(void (^)(BOOL flag, NSString *msg,  NSError *error))block ;

/*! @brief 重置密码接口(不需要知道原密码,但要获取验证码)
 * @param mparam 手机号和新密码
 * @return 成功返回flag为YES，msg,失败返回error。
 */
//JZCustomer *user = [[JZCustomer alloc] init];
//user.mobile = _phoneField.text;
//user.password = _newlyPWField.text;
+ (NSURLSessionDataTask *)resetPwdBlock:(JZCustomer *)user getDetailBlock:(void (^)(BOOL flag, NSString *msg,  NSError *error))block ;

//添加充值记录
/*! @brief 添加充值记录
 * @discusstion 用户购买货币时,钱会先到苹果那里,苹果扣除30%费用,所以需要有充值记录
 * @param userID 用户ID
 * @param nickname 用户昵称
 * @param mobile 用户手机
 * @param activityTitle 活动标题
 * @param activityID 暂时没用
 * @param paidDate 支付时间(就是当前时间)
 * @param payType 支付方式(这里是应用内支付)
 * @param status 支付状态，0为未完成，1为完成
 * @param paidFee 购买成品的价格
 * @param orderTime 下单时间(也是当前时间)
 * @param productType 固定的:充值为1,购买视频为4
 * @param purpose 目的(充值:recharge)
 * @return 成功返回:order，失败返回error。
 */
//NSDictionary *params = @{@"userID":[NSString stringWithFormat:@"%lu",[Customer getUserdataInstance].id],
//@"nickname":[Customer getUserdataInstance].nickname,
//@"mobile":[Customer getUserdataInstance].mobile,
//@"activityTitle":_productName,
//@"activityID":_productPrice,
//@"paidDate":nowTime,
//@"payType":@"inappApplepay",
//@"status":@"1",
//@"paidFee":_productPrice,
//@"orderTime":nowTime,
//@"productType":@"1",
//@"purpose":@"recharge"
//};
+ (NSURLSessionDataTask *)addOrderWithBlock:(NSDictionary*) condParams completeHandler:(void (^)(JZOrder *order, NSError *error))block;

/*! @brief 更新用户信息
 * @discusstion 用于修改用户的个人信息,修改名字只用更改名字,修改头像只用改头像
 * @param user 用户新的信息
 * @return 成功返回:user(用户信息)，失败返回error。
 */
//JZCustomer *user = [JZCustomer getUserdataInstance];
//user.nickname = _nameField.text;修改名字
+ (NSURLSessionDataTask *)updateUserWithBlock:(JZCustomer *)user getDetailBlock:(void (^)(JZCustomer *user, NSError *error))block;

/*! @brief 关注或取消关注其他人
 * @discusstion 通过友盟获取第三方的信息,传递给这个接口返回用户的信息
 * @param userID 用户自己的id
 * @param otherID 想关注的人的id
 * @param isFocus 关注为1,取消关注为0
 * @return 成功返回:flag为YES，失败返回error。
 */
//NSDictionary *params = @{@"userID":ownId,@"otherID":_otherId,@"isFocus":@"1"};
+ (NSURLSessionDataTask *)focusOtherWithBlock:(NSDictionary *)params  returnBlock:(void (^)(BOOL flag, NSError *error))block;

/*! @brief 举报接口
 * @discusstion 通过用户举报及时处理不当用户,保障直播平台的合法性
 * @param userID 用户id
 * @param content 举报内容
 * @return 成功返回flag为YES，失败返回error。
 */
//NSDictionary *params = @{@"userID":ownId,@"content":@"直播内容有羞羞画面"};
+ (NSURLSessionDataTask *)reportWithBlock:(NSDictionary *)params  returnBlock:(void (^)(BOOL flag, NSError *error))block;

//发送好友私信信息接口
/*! @brief 私信发送接口
 * @discusstion 私信给指定用户(就像发短信)
 * @param userID 用户id
 * @param otherID 指定对象id
 * @param message 发送信息内容
 * @return 成功返回flag为YES，失败返回error。
 */
//NSDictionary *params = @{@"userID":userID,
//@"otherID":otherID,
//@"message":chatString
//};
+ (NSURLSessionDataTask *)sendPrivateMsgWithBlock:(NSDictionary *)params  returnBlock:(void (^)(BOOL flag, NSError *error))block;

/*! @brief 私信轮寻查询接口(获取好友列表接口)
 * @discusstion 获取私信好友或者非好友的信息列表
 * @param userID 用户id
 * @param isFriend为1是好友列表 为0是非好友列表
 * @return 成功返回msgs，失败返回error。
 */
//NSDictionary *params = @{@"userID":userID,@"isFriend":@"1"};
+ (NSURLSessionDataTask *)getChatmsgsWithBlock :(NSDictionary*) params  getDetailBlock:(void (^)(NSArray *msgs, NSError *error))block;

/*! @brief 私信中获取聊天信息列表接口
 * @discusstion 获取两人私信对话的详细记录
 * @param userID 用户id
 * @param otherID 私信中好友或非好友的id
 * @return 成功返回详细聊天信息msgs，失败返回error。
 */
//NSDictionary *params = @{@"userID":userID, @"otherID":otherID};
+ (NSURLSessionDataTask *)getOtherChatmsgsWithBlock :(NSDictionary*) params  getDetailBlock:(void (^)(NSArray *msgs, NSError *error))block;

/*! @brief 私信中忽略未读信息接口
 * @discusstion 将私信中未读信息变为已读信息
 * @param userID 用户id
 * @param otherID 私信中好友或非好友的id
 * @return 成功返回flag为YES，失败返回error。
 */
//NSDictionary *params = @{@"userID":userID, @"otherID":otherID};
+ (NSURLSessionDataTask *)updateUnreadMsgWithBlock:(NSDictionary *)params  returnBlock:(void (^)(BOOL flag, NSError *error))block;

/*! @brief 获取送礼用户排行列表信息
 * @discusstion 获取主播的 送礼用户排行列表信息
 * @param toUserID 主播id
 * @param start 开始页面
 * @param offset 每页多少条信息
 * @return 成功返回records，失败返回error。
 */
//NSDictionary *params = @{@"toUserID":[NSString stringWithFormat:@"%lu", (long)_host.id],@"start":@"0",@"offset":@"100"};
+ (NSURLSessionDataTask *)getGiftRecordsWithBlock:(NSDictionary *)params  returnBlock:(void (^)(NSArray* records, NSInteger allcounts, NSError *error))block;

/*! @brief 获取用户的粉丝接口
 * @discusstion 获取用户粉丝详细信息
 * @param userID 某个用户id
 * @param pageNum 开始页面
 * @param offset 每页多少条信息
 * @return 成功返回records，失败返回error。
 */
//NSDictionary* params =@{@"userID":userID, @"pageNum":@"0", @"offset":@"50"};
+ (NSURLSessionDataTask *)getFansWithBlock:(NSDictionary *)params  returnBlock:(void (^)(NSArray* records, NSInteger allcounts, NSError *error))block;

/*! @brief 获取关注,最热,预告列表接口,还有支付过的视频列表
 * @discusstion orderType:latest，hotest, predict, user, paid五种类型
 * @param orderType hotest所有用户活动的最热排序,latest所有用户活动的最新排序;predict所有用户的所用预告活动;paid某个用户的支付过的活动列表(必须传入uid);user用户自己的列表(必须传入uid)
 * @param uid 用户自己的id,(当orderType为user或者paid必须传入,为hotest或latest不传入)
 * @param start 开始页面
 * @param offset 每页多少条信息
 * @param isTester 1为测试用户,0为普通用户
 * @return 成功返回records（数据），allcounts（返回的数据共多少条）失败返回error。
 */
//NSDictionary *params = @{@"orderType":@"hotest",@"start":@"0", @"offset":@"50",@"isTester":@"1"};
//NSDictionary *params = @{@"orderType":@"user",@"uid":userId,@"start":@"0",@"offset":@"50",@"isTester":@"1"};
+ (NSURLSessionDataTask *)getKindsRecordsWithBlock:(NSDictionary *)params  returnBlock:(void (^)(NSArray* records, NSInteger allcounts, NSError *error))block;

/*! @brief 获取某个用户关注哪些用户的接口
 * @discusstion 获取用户关注的详细信息
 * @param userID 某个用户id
 * @param pageNum 开始页面
 * @param offset 每页多少条信息
 * @return 成功返回records，失败返回error。
 */
//NSDictionary* params = @{@"userID":userid, @"pageNum":@"0", @"offset":@"50"};
+ (NSURLSessionDataTask *)getFocusWithBlock:(NSDictionary *)params  returnBlock:(void (^)(NSArray* records, NSInteger allcounts, NSError *error))block;

/*! @brief 搜索用户接口
 * @param nickname 将要搜索的用户昵称
 * @param start 开始页面
 * @param offset 每页多少条信息
 * @return 成功返回user，allcounts(一共多少条)失败返回error。
 */
//NSDictionary * params = @{@"nickname":_search.text,@"start":@"0", @"offset":@"50"};
+ (NSURLSessionDataTask *)filterHostsWithBlock:(NSDictionary*) params getHostBlock:(void (^)(NSArray *user, NSInteger allcounts, NSError *error))block;

/*! 编辑活动
 * @discusstion 用户直播是常见的活动详情(活动封面,标题,内容,时间,类型,直播的模式)
 * @param action //创建时传入insert, 修改活动信息时传入update
 * @param id //id是活动的唯一id,action是insert时 不需要传入,action 是update时 必须传入
 * @param userID //主播用户的id
 * @param iconURL //活动封面
 * @param title //标题
 * @param content //活动内容
 * @param stream //流名称 生成逻辑=手机号+roomNo
 * @param app //固定值
 * @param domain //固定值
 * @param roomNo //十位随机数字
 * @param planStartTime //开始时间 整数 秒为单位
 * @param videoDirection //是否提供白板
 * @param activityType //活动类型 0 公开 1 付费 2 密码查看 3私人
 * @param payFee //付费的金额
 * @param code //密码
 * @param shopEnable //是否提供购物
 * @param wenjuanEnable //是否提供问卷调查
 * @param baibanEnable //是否提供白板
 * @param type //直播类型
 * @return 成功返回flag为YES,失败返回error。
 */
//NSDictionary *params = @{
//@"id":[NSString stringWithFormat:@"%ld", (long)_record.activityID],
//@"action":@"update",
//@"userID":[NSString stringWithFormat:@"%ld", (long)_record.userID],
//@"iconURL":_record.iconURL,
//@"title":_record.title,
//@"content":_record.content,
//@"stream":_record.stream,
//@"app":@"livevideo",
//@"domain":@"flive.51star.com",
//@"roomNo":_record.roomNo,
//@"planStartTime":[NSString stringWithFormat:@"%ld", (long)timeStamp],
//@"videoDirection":[NSString stringWithFormat:@"%ld", (long)_record.videoDirection],
//@"activityType":[NSString stringWithFormat:@"%ld", (long)_record.activityType],
//@"payFee":[NSString stringWithFormat:@"%ld", (long)_record.payFee],
//@"code":_record.code,
//@"shopEnable":@"0",
//@"wenjuanEnable":@"0",
//@"baibanEnable":@"0",
//@"type":_record.type};
+ (NSURLSessionDataTask *)editActivityRecordWithBlock:(NSDictionary *)params returnBlock:(void (^)(BOOL flag, NSError *error))block;

/*! @brief 获取活动类型
 * @discusstion 确定该活动是属于哪一种类型(财经,教育,运动.....)
 * @param token 为大于等于6位数的数字如666666
 * @return 成功返回resultStr(活动id), 失败返回error。
 */
//NSDictionary * params = @{@"token":@"1234567"};
+(NSURLSessionDataTask *)getActivityCategoryWithBlock:(NSDictionary *)params returnBlock:(void (^)(NSArray *types, NSError *error))block;

/*! @brief 添加预约
 * @discusstion 预约某个活动
 * @param activityID 活动ID
 * @param userID 用户ID
 * @param token 为大于等于6位数的数字如666666
 * @return 成功返回resultStr(活动id), 失败返回error。
 */
//NSDictionary *params = @{@"activityID":[NSString stringWithFormat:@"%ld" ,(long)_record.activityID],@"userID":userid, @"token":@"11111111"};
+ (NSURLSessionDataTask *)addAppointmentRecordWithBlock:(NSDictionary *)params  returnBlock:(void (^)(NSInteger resultStr, NSError *error))block;

/*! @brief 获取预约记录
 * @discusstion 自己预约的所有活动记录
 * @param userID 用户ID
 * @param start 开始页面
 * @param offset 每页多少条信息
 * @param token 为大于等于6位数的数字如666666
 * @return 成功返回records(预约的活动信息), 失败返回error。
 */
//NSDictionary *params = @{@"userID":userId,@"start":@"0",@"offset":@"50",@"token":@"11111111"};
+ (NSURLSessionDataTask *)getAppointmentRecordsWithBlock:(NSDictionary *)params returnBlock:(void (^)(NSArray *records, NSInteger allcounts, NSError *error))block;

/*! @brief 删除预约
 * @discusstion 取消某个活动预约
 * @param activityID 活动ID
 * @param userID 用户ID
 * @param token 为大于等于6位数的数字如666666
 * @return 成功返回flag为YES, 失败返回error。
 */
//NSDictionary *params = @{@"activityID":[NSString stringWithFormat:@"%ld" ,(long)_record.activityID],@"userID":userid, @"token":@"11111111"};
+ (NSURLSessionDataTask *)deleteAppointmentRecordWithBlock:(NSDictionary *)params returnBlock:(void (^)(BOOL flag, NSError *error))block;

/*! @brief 获取某个活动记录的详细内容
 * @discusstion 当修改活动信息时需要先获取活动的信息
 * @param activityID 活动ID
 * @param userID 用户ID
 * @param token 为大于等于6位数的数字如666666
 * @return 成功返回record(活动的详细信息), 失败返回error。
 */
//NSDictionary *params = @{@"activityID":[NSString stringWithFormat:@"%ld" ,(long)_record.activityID],@"userID":userid, @"token":@"11111111"};
+ (NSURLSessionDataTask *)getOneActivityRecordWithBlock:(NSDictionary *)params returnBlock:(void (^)(JZLiveRecord *record, NSError *error))block;

/*! @brief 获取广告
 * @discusstion 主页面上边的轮播广告
 * @param start 开始页面
 * @param offset 每页多少条信息
 * @param token 为大于等于6位数的数字如666666
 * @return 成功返回advertisements(广告内容), 失败返回error。
 */
//NSDictionary *params = @{@"start":@"0",@"offset":@"10", @"token":@"11111111"};
+ (NSURLSessionDataTask *)getAdvertisementsWithBlock:(NSDictionary *)params returnBlock:(void (^)(NSArray* advertisements, NSError *error))block;

/*! @brief 更改用户的头像到服务器
 * @discusstion 更改用户的名片调用此接口
 * @param theImagePath 封面的路径
 * @param id 用户id
 * @param operate 为"1"固定的
 * @return 成功返回user(用户信息), 失败返回error。
 */
//NSDictionary *params = @{@"id":userid],@"operate":@"1"};
+ (void)uploadUserHeadImageToServer:(NSString*)theImagePath mParams:(NSDictionary *)params completeHandler:(void(^)(JZCustomer *user, NSError *error))handler;

/*! @brief 更改用户的名片到服务器
 * @discusstion 更改用户的头像或名片调用此接口
 * @param theImagePath 封面的路径
 * @param id 用户id
 * @param operate 为"1"固定的
 * @return 成功返回user(用户信息), 失败返回error。
 */
//NSDictionary *params = @{@"id":userid],@"operate":@"1"};
+ (void)uploadUserImageToServer:(NSString*)theImagePath mParams:(NSDictionary *)params completeHandler:(void(^)(JZCustomer *user, NSError *error))handler;

/*! @brief 更改活动封面到服务器
 * @discusstion 修改活动时更改封面调用此接口
 * @param theImagePath 封面的路径
 * @param action 传入update
 * @param id 活动的唯一id 必须传入
 * @param userID //主播用户的id
 * @param iconURL //活动封面
 * @param title //标题
 * @param content //活动内容
 * @param stream //流名称 生成逻辑=手机号+roomNo
 * @param app //固定值
 * @param domain //固定值
 * @param roomNo //十位随机数字
 * @param planStartTime //开始时间 整数 秒为单位
 * @param videoDirection //是否提供白板
 * @param activityType //活动类型 0 公开 1 付费 2 密码查看 3私人
 * @param payFee //付费的金额
 * @param code //密码
 * @param shopEnable //是否提供购物
 * @param wenjuanEnable //是否提供问卷调查
 * @param baibanEnable //是否提供白板
 * @param type //直播类型
 * @return 成功返回activityID(活动id), 失败返回error。
 */
+ (void)uploadActivityImageToServer:(NSString*)theImagePath mParams:(NSDictionary*)params completeHandler:(void(^)(NSInteger activityID, NSError *error))handler;

/*! @brief 判断此活动是否支付
 * @discusstion 观看当前活动视频时,判断是否已经支付
 * @param userID 用户自己的id
 * @param activityID 准备观看的活动activityID
 * @param token 为大于等于6位数的数字如666666
 * @return 成功返回flag为YES, 失败返回flag为no,error。
 */
//NSDictionary *params = @{@"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"activityID":[NSString stringWithFormat:@"%ld",(long)record.activityID],@"token":@"11111111"};
+ (NSURLSessionDataTask *)judgeActivityIsPaid:(NSDictionary *)params returnBlock:(void (^)(BOOL flag, NSError *error))block;

/*! @brief 获取用户money
 * @discusstion 获取用户的余额 : 余额 = 总金额 - 话费金额;用户支付前调用
 * @param userID 用户的id
 * @param token 为大于等于6位数的数字如666666
 * @return 成功返回myMoney(总金额),sendGiftValue(花费金额), 失败返回flag为no,error。
 */
//NSDictionary *params = @{@"userID":[NSString stringWithFormat:@"%lu",(long)[JZCustomer getUserdataInstance].id],@"token":@"11111111"};
+ (NSURLSessionDataTask *)getUserMoney:(NSDictionary *)params returnBlock:(void (^)(NSInteger myMoney, NSInteger sendGiftValue, NSError *error))block;

/*! @brief 对单个设备发送推送消息
 * @discusstion 发送推送消息
 * @param deviceToken 设备的唯一码
 * @param title 推送消息的标题
 * @param expireTime 有效时间
 * @return 成功返回flag为yes, 失败返回flag为no或error。
 */
// NSDictionary *params = @{@"deviceToken":@"b5c3ab085d970420634fd0ff48e0b90d98b37b0c8dd2b69e031432a408e84eb3",@"title":@"测试推送接口",@"expireTime":nextDateString};
+ (NSURLSessionDataTask *)sendUnicastPushMessage:(NSDictionary *)params returnBlock:(void (^)(BOOL flag, NSError *error))block;

/*! @brief 对多个设备发送推送消息
 * @discusstion 发送推送消息
 * @param deviceToken 设备的唯一码
 * @param title 推送消息的标题
 * @param expireTime 有效时间
 * @return 成功返回flag为yes, 失败返回flag为no或error。
 */
// NSDictionary *params = @{@"deviceToken":@"128c95844541f9784a7f50aabb77464d5e75e2bdb6fdfe3db2dc3ed6cf7665b5,b5c3ab085d970420634fd0ff48e0b90d98b37b0c8dd2b69e031432a408e84eb3",@"title":@"测试推送接口",@"expireTime":nextDateString};
+ (NSURLSessionDataTask *)sendListcastPushMessage:(NSDictionary *)params returnBlock:(void (^)(BOOL flag, NSError *error))block;

/*! @brief 对所有设备发送推送消息
 * @discusstion 发送推送消息
 * @param deviceToken 所有就不需要了
 * @param title 推送消息的标题
 * @param expireTime 有效时间
 * @return 成功返回flag为yes, 失败返回flag为no或error。
 */
// NSDictionary *params = @{@"deviceToken":@"",@"title":@"测试推送接口",@"expireTime":nextDateString};
+ (NSURLSessionDataTask *)sendBroadcastPushMessage:(NSDictionary *)params returnBlock:(void (^)(BOOL flag, NSError *error))block;


/*! @brief 获取 预约某个活动的所用用户 的iosDevicetoken
 * @discusstion 发送推送消息
 * @param deviceToken 所有就不需要了
 * @param title 推送消息的标题
 * @param expireTime 有效时间
 * @return 成功返回flag为yes, 失败返回flag为no或error。
 */
// NSDictionary *params = @{@"deviceToken":@"",@"title":@"测试推送接口",@"expireTime":nextDateString};
+ (NSURLSessionDataTask *)getAppointmentUsersIosDeviceToken:(NSDictionary *)params returnBlock:(void (^)(NSArray *appointmentUsers, NSError *error))block;

/*! @brief 添加观看记录
 * @discusstion 每次观看直播或回放就调用
 * @param userID 用户自己的id
 * @param activityID 活动ID
 * @param lastTime 计算整段视频最后观看的时间(直播就是拿现在的时间减去主播开始的时间)
 * @return 成功返回flag为yes, 失败返回flag为no或error。
 */
// NSDictionary *params = @{@"userID":userid,@"activityID":[NSString stringWithFormat:@"%ld" ,(long)_record.activityID],@"lastTime":@"0"};
+ (NSURLSessionDataTask *)addWatchRecord:(NSDictionary *)params returnBlock:(void (^)(BOOL flag, NSError *error))block;

/*! @brief 获取某个活动的最后观看时间
 * @discusstion 每次观看直播或回放就调用
 * @param userID 用户自己的id
 * @param activityID 活动ID
 * @param token 为大于等于6位数的数字如666666
 * @return 成功返回lasttime, 失败返回lasttime为0或error。
 */
// NSDictionary *params = @{@"userID":userid,@"activityID":[NSString stringWithFormat:@"%ld" ,(long)_record.activityID],@"token":@"66666666"};
+ (NSURLSessionDataTask *)getWatchRecordListTime:(NSDictionary *)params returnBlock:(void (^)(NSInteger lastTime, NSError *error))block;

/*! @brief 获取观看记录
 * @discusstion 获取自己的观看记录就调用
 * @param pageNum 页码(哪一页)
 * @param offset 跨度(每一页多少条)
 * @param userID 用户自己的id
 * @return 成功返回records,allcounts 失败返回allcounts为-1或error。
 */
// NSDictionary *params = @{@"pageNum":@"0", @"offset":@"50", @"userID":userid};
+ (NSURLSessionDataTask *)getWatchRecord:(NSDictionary *)params returnBlock:(void (^)(NSArray *records, NSInteger allcounts, NSError *error))block;

/*! @brief 主播添加禁言用户(在主播活动中,该用户无法发送聊天信息)
 * @discusstion 主播直播时点击用户就会显示用户详细信息,里面的禁言按钮点击就调用该接口
 * @param userID 用户的id
 * @param hostID 主播自己的id
 * @param operate 为1是禁言, 2是取消禁言
 * @return 成功返回flag为yes, 失败返回flag为no或error。
 */
// NSDictionary *params = @{@"userID":userid,@"hostID":hostId,@"operate":@"1"};
+ (NSURLSessionDataTask *)addShutUpUser:(NSDictionary *)params returnBlock:(void (^)(BOOL flag, NSError *error))block;

/*! @brief 提交认证信息(个人认证)
 * @discusstion 个人认证提交时调用
 * @param image 图片
 * @param cardURL 如果第一次认证为空,第二次将上次的url获取
 * @param authType 0 未认证；1 为个人；2 为企业
 * @param realName 名字
 * @param cardNo 证件号
 * @param introduction 介绍
 * @return 成功返回flag为yes, 失败返回flag为no或error。
 */
// NSDictionary *params = @{@"userID":[NSString stringWithFormat:@"%ld",(long)[JZCustomer getUserdataInstance].id],@"image":path, @"cardURL":@"", @"authType":@"1", @"realName":_nameField.text, @"cardNo":_idNumberField.text, @"introduction":@""};
+ (void)submitAuthentication:(NSDictionary *)params completeHandler:(void (^)(BOOL flag, NSError *error))handler;

//获取用户的认证信息
/*! @brief 获取用户的认证信息(实名认证)
 * @discusstion 点击实名认证判断是否认证通过,及未通过获取cardURL
 * @param userID 用户id
 * @return 成功返回userAuthenticationaInfo(包含用户的认证信息), 失败返回error。
 */
// NSDictionary *params = @{@"userID":userid};
+ (NSURLSessionDataTask *)getAuthenticationInfo:(NSDictionary *)params returnBlock:(void (^)(JZAuthentication *userAuthenticationaInfo, NSError *error))block;

/*! @brief 获取主播房间主播推广的商品列表
 * @discusstion 播放器和直播器内使用(用于主播推广自己的商品,打开以webview形式显示)
 * @param activityID 活动ID
 * @param pageNum 页码（0为第一页）
 * @param offset 每页数量
 * @return 成功返回flag为yes, 失败返回flag为no或error。
 */
// NSDictionary *params = @{@"activityID":[NSString stringWithFormat:@"%ld", (long)_record.activityID], @"pageNum":@"0", @"offset":@"50"};
+ (NSURLSessionDataTask *)getRecordProductList:(NSDictionary *)params returnBlock:(void (^)(NSArray *products, NSError *error))block;

/*! @brief 获取直播间系统发送的消息
 * @discusstion 也就是直播间的系统公告
 * @param userID 1
 * @return 成功返回systemicMessage, 失败返回error。
 */
// NSDictionary *params = @{@"userID":userid};
+ (NSURLSessionDataTask *)getSystemicMessage:(NSDictionary *)params returnBlock:(void (^)(NSObject *systemicMessage, NSError *error))block;
@end
