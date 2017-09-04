//
//  JZShareView.m
//  东方购物new
//
//  Created by Michael_Zuo on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "JZShareView.h"
//#import "UMSocialUIManager.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <JZLiveSDK/JZLiveSDK.h>
#import "JZTools.h"
#import "WSHHThirdPartyLogin.h"
@interface JZShareView()

@property (nonatomic,strong)UIButton *weixin;
@property (nonatomic,strong)UIButton *friendsCircle;
@property (nonatomic,strong)UIButton *sina;
@end


@implementation JZShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *coverView = [[UIButton alloc] init];
        coverView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        coverView.backgroundColor = background01GRAY;
        [coverView addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coverView];
        
        UIView *shareView = [[UIView alloc] init];
        shareView.backgroundColor = tableViewBackColor;
        shareView.frame = CGRectMake(10, frame.size.height-70-60, frame.size.width-20, 70);
        shareView.layer.cornerRadius = 3;
        shareView.clipsToBounds = YES;
        [self addSubview:shareView];
        
        UIButton *concalView = [[UIButton alloc] init];
        concalView.frame = CGRectMake(10, frame.size.height-50, frame.size.width-20, 40);
        concalView.backgroundColor = [UIColor whiteColor];
        [concalView.titleLabel setFont:[UIFont systemFontOfSize:FONTSIZE38]];
        [concalView setTitle:@"取消" forState:UIControlStateNormal];
        [concalView setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        concalView.titleLabel.contentMode = UIViewContentModeCenter;
        [concalView addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
        concalView.layer.cornerRadius = 3;
        concalView.clipsToBounds = YES;
        [self addSubview:concalView];
        
        self.weixin = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-170)/4, 10, 50, 50)];
        self.weixin.backgroundColor = [UIColor greenColor];
        self.weixin.layer.cornerRadius = 25;
        self.weixin.clipsToBounds = YES;
        self.weixin.tag = 472;
        [self.weixin setImage:[UIImage imageNamed:@"JZ_Btn_wechat_p"] forState:UIControlStateNormal];
        [self.weixin addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:self.weixin];
        
        self.friendsCircle = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.weixin.frame)+(frame.size.width-170)/4, 10, 50, 50)];
        self.friendsCircle.backgroundColor = [UIColor purpleColor];
        self.friendsCircle.layer.cornerRadius = 25;
        self.friendsCircle.clipsToBounds = YES;
        self.friendsCircle.tag = 471;
        [self.friendsCircle setImage:[UIImage imageNamed:@"JZ_Btn_pengyouquan_p"] forState:UIControlStateNormal];
        [self.friendsCircle addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:self.friendsCircle];
        
        self.sina = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.friendsCircle.frame)+(frame.size.width-170)/4, 10, 50, 50)];
        self.sina.backgroundColor = [UIColor purpleColor];
        self.sina.layer.cornerRadius = 25;
        self.sina.clipsToBounds = YES;
        self.sina.tag = 473;
        [self.sina setImage:[UIImage imageNamed:@"JZ_Btn_weibo_p"] forState:UIControlStateNormal];
        [self.sina addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:self.sina];
        
        [self updateUI];
        
    }
    return self;
}
- (void)updateUI
{
  [WXApi registerApp:@"wx6013c8f57b63e8f5"];
    if (![WXApi isWXAppInstalled])
    {
        self.weixin.frame = CGRectZero;
        self.friendsCircle.frame = CGRectZero;
        [UIView animateWithDuration:0.3f animations:^{
            self.sina.frame = CGRectMake((self.bounds.size.width-50)/2, 10, 50, 50);
        }];
        
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
//移除view
-(void)removeSelf{
    [self removeFromSuperview];
}
//分享
- (void)share:(UIButton *)button
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(creatShareMessageObject:)])
//    {
        [self removeFromSuperview];
        switch (button.tag)
        {
            case 471:[self shareWithType:JZShareTimeLine];
                break;
            case 472:[self shareWithType:JZShareFrieds];
                break;
            case 473:[self shareWithType:JZShareSina];
                break;
                default:
                break;
        }
        
//    }
    
}

/**
 分享
 */
- (void)shareWithType:(JZShareType)type
{
    switch (type) {
        case JZShareTimeLine: // 朋友圈
        {
            SendMessageToWXReq *req = [self WXMessageReq];
            req.scene = WXSceneTimeline;
            [WXApi sendReq:req];
        }
            
            break;
        case JZShareFrieds:   // 微信好友
        {
          SendMessageToWXReq *req = [self WXMessageReq];
          req.scene = WXSceneSession;
          [WXApi sendReq:req];
        }
            
            break;
        case JZShareSina:    // 新浪微博
        {
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = @"http://www.ocj.com.cn/main/index.jsp";
            authRequest.scope = @"all";
            WBMessageObject * message = [self messageToShare];
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
            request.userInfo = @{@"ShareMessageFrom": @"ShareView",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            [WeiboSDK sendRequest:request];
        }
            break;
        default:
            break;
    }
    
   
    
    
}
- (SendMessageToWXReq *)WXMessageReq
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [HDUtil check:self.liveInfoModel.share_title];
    message.description = [HDUtil check:self.liveInfoModel.share_content];
    NSString * shareImageStr = [HDUtil returnAllStrWithStr:self.liveInfoModel.share_pic];
    NSData* photoImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageStr]];
    if (shareImageStr.length) {
        [message setThumbImage:[UIImage imageWithData:photoImageData]];
    }else{
        [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
    }
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [HDUtil returnAllStrWithStr:self.liveInfoModel.share_url];
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    return req;
}

/**
 微博分享对象

 @return
 */
- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
//    message.text = [NSString stringWithFormat:@"精选商品为您推荐：%@,货号:%@.http://m.ocj.com.cn/detail/%@",self.shareModel.item_name,self.shareModel.item_code,self.shareModel.item_code];
    NSString * shareImageStr = [HDUtil returnAllStrWithStr:self.liveInfoModel.share_pic];
     message.text = [NSString stringWithFormat:@"%@: %@%@",
                     [HDUtil check:self.liveInfoModel.share_title],
                     [HDUtil check:self.liveInfoModel.share_content],
                     [HDUtil check:self.liveInfoModel.share_url]
                     ];
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageStr]];
    message.imageObject = image;
    
    return message;
}
@end
