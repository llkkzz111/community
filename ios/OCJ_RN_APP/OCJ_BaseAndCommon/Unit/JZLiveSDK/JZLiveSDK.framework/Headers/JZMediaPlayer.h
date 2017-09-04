//
//  JZMediaPlayer.h
//  JZMSGApi
//
//  Created by wangcliff on 16/12/29.
//  Copyright © 2016年 jz. All rights reserved.
//  播放器

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JZCustomer;
@class JZLiveRecord;
@class JZMainView;
@protocol JZMediaPlayerDelegate <NSObject>
@required
- (void)closeMediaPlayer;//关闭播放器
- (void)showPersonalInfo:(JZCustomer *)user;//创建个人信息view
- (void)showVoteRankView;//展示投票排行榜
- (void)showShareView;//展示分享view
- (void)showLiveEndView:(NSInteger)maxOnlineNumber;//展示直播结束界面
- (void)showSelectedLoginView;//显示选择登陆页面
- (void)enterRechargeView;//进入充值页面
- (void)showAdvertisementSelectView;//显示广告选择view
- (void)showAdvertisementSelectListView;//临时加的显示广告选择view
- (void)showActivityRulesView;//显示活动规则view
//- (BOOL)payGift:(NSInteger)money;//礼物支付(返回支付是否成功,成功yes,失败no)
@end

@interface JZMediaPlayer : NSObject
@property (nonatomic, weak) id<JZMediaPlayerDelegate> delegate;
@property (nonatomic, strong) JZCustomer *user;//用户自己信息
@property (nonatomic, strong) JZCustomer *host;//主播信息
@property (nonatomic, strong) JZLiveRecord *record;//活动信息
@property (nonatomic, assign) BOOL enableMessage;//私信开关,默认是关的
@property (nonatomic, assign) BOOL isHiddenShareButton;//隐藏分享按钮(默认为no显示分享按钮,隐藏为yes)

//sdk内部属性(只读,使用sdk不需要操作)
@property (nonatomic, readonly) BOOL isLiving;//直播状态
@property (nonatomic, weak) JZMainView *mainFunctionView;//UI界面view
@property (nonatomic, strong) NSArray *productArray;//商品数据

+ (JZMediaPlayer *)getInstance:(NSInteger)displayMode;//选择实例模式(播放器模板默认0,0有横竖屏,1只有竖屏)
- (BOOL)judgeActivityState;//判断活动是否可以播放
- (void)initSocket;//初始化即时通讯
- (void)initMediaPlayerConfiguration;//初始化播放器配置
- (UIView *)previewMediaPlayerView;//显示view
- (void)JZMediaPlayerConnectServer;//从服务器拉流
- (void)hideInteractionView;//隐藏交互view只留显示媒体view和退出按钮
- (void)showInteractionView;//展示交互view
- (void)callUserInPublicChat;//在公共聊天区@某人
- (void)sendPrivateChatMessage;//给某人发私信

//版本特有的(不可以随便调用)
- (void)openProductWebView:(NSString *)urlString;//展示商品
//- (void)replaceShoppingCartPicture:(NSString *)imageUrl buttonTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(CGFloat)font;
- (void)replaceShoppingCartPicture:(BOOL)isNetworkImage imageString:(NSString *)imageUrl buttonTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(CGFloat)font;//修改购物车图片,isNetworkImage为yes是网络图片,为no是本地图片
- (void)destroySDKMediaPlayer;//销毁播放器
- (void)hiddenShareButton:(BOOL)isHidden;//分享按钮可见性(isHidden:yes隐藏,no显示)
@end
