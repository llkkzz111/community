//
//  OCJSharePopView.m
//  OCJ
//
//  Created by Ray on 2017/6/12.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import "OCJSharePopView.h"
#import "WSHHThirdPartyLogin.h"
#import "APOpenAPI.h"
#import "WXApi.h"

@interface OCJSharePopView ()

@property (nonatomic, strong) UIView *ocjView_bg;       ///<背景
@property (nonatomic, strong) UIView *ocjView_container;///<底部容器view
@property (nonatomic, strong) NSDictionary *ocjDic_share;

@end

@implementation OCJSharePopView

+ (instancetype)sharedInstance {
  static OCJSharePopView *ocjSharedView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    ocjSharedView = [[self alloc] init];
  });
  return ocjSharedView;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    if (![APOpenAPI registerApp:@"2015022600032698"]) {
      OCJLog(@"注册失败");
    }
  }
  return self;
}

- (void)ocj_setShareContent:(NSDictionary *)shareDic {
  self.ocjDic_share = shareDic;
  [self ocj_setSelf];
}

- (void)ocj_setSelf {
  
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  OCJSharePopView *shareView = [OCJSharePopView sharedInstance];
  shareView.frame = window.bounds;
  shareView.userInteractionEnabled = YES;
  shareView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
  shareView.alpha = 1;
  [window addSubview:shareView];
  
    CGFloat shareViewHeight = SCREEN_WIDTH / 2.0 - 20;
    //背景
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:shareView action:@selector(ocj_closeAction)];
  [shareView addGestureRecognizer:tap];
    //底部显示商品信息view
    shareView.ocjView_container = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, shareViewHeight)];
    shareView.ocjView_container.backgroundColor = OCJ_COLOR_BACKGROUND;
    [shareView addSubview:shareView.ocjView_container];
    
    [UIView animateWithDuration:0.5f animations:^{
        shareView.ocjView_container.frame = CGRectMake(0, SCREEN_HEIGHT - shareViewHeight, SCREEN_WIDTH, shareViewHeight);
    }];
    [shareView ocj_addViews];
}

- (void)ocj_addViews {
    //分享标题
    UILabel *ocjLab_title = [[UILabel alloc] init];
    ocjLab_title.text = @"分享到";
    ocjLab_title.font = [UIFont systemFontOfSize:15];
    ocjLab_title.textColor = OCJ_COLOR_DARK;
    ocjLab_title.textAlignment = NSTextAlignmentCenter;
    [self.ocjView_container addSubview:ocjLab_title];
    [ocjLab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ocjView_container);
        make.top.mas_equalTo(self.ocjView_container.mas_top).offset(15);
    }];
    //关闭按钮
    UIButton *ocjBtn_close = [[UIButton alloc] init];
    [ocjBtn_close setImage:[UIImage imageNamed:@"icon_clear"] forState:UIControlStateNormal];
    [ocjBtn_close addTarget:self action:@selector(ocj_closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.ocjView_container addSubview:ocjBtn_close];
    [ocjBtn_close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.ocjView_container);
        make.width.height.mas_equalTo(@40);
    }];
    //
//    NSArray *ocjArr_share = @[@"微信",@"朋友圈",@"QQ好友",@"QQ空间",@"微博"];
//    NSArray *ocjArr_image = @[@"Icon_wechat_",@"Icon_discover_",@"share_qq",@"share_qqzone",@"Icon_weibo_"];
    NSMutableArray *ocjArr_share = [NSMutableArray array];
    NSMutableArray *ocjArr_image = [NSMutableArray array];
    if ([WXApi isWXAppSupportApi]) {
        [ocjArr_share addObject:@"微信"];
        [ocjArr_image addObject:@"Icon_wechat_"];
    
        [ocjArr_share addObject:@"朋友圈"];
        [ocjArr_image addObject:@"Icon_discover_"];
    }

  
    if ([WeiboSDK isCanShareInWeiboAPP]) {
        [ocjArr_share addObject:@"微博"];
        [ocjArr_image addObject:@"Icon_weibo_"];
    }


    if (ocjArr_share.count>0) {
      CGFloat viewWidth = SCREEN_WIDTH / 5;
      CGFloat viewHeight = 80;
      for (int i = 0; i < ocjArr_share.count; i++) {
        NSString* shareTitle = ocjArr_share[i];

        UIView *ocjView_share = [[UIView alloc] init];
        ocjView_share.backgroundColor = OCJ_COLOR_BACKGROUND;
        [self.ocjView_container addSubview:ocjView_share];
        [ocjView_share mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(self.ocjView_container.mas_left).offset(viewWidth * i);
          make.top.mas_equalTo(ocjLab_title.mas_bottom).offset(15);
          make.width.mas_equalTo(viewWidth);
          make.height.mas_equalTo(viewHeight);
        }];
        
        //btn
        UIButton *ocjBtn_share = [[UIButton alloc] init];
        [ocjBtn_share setImage:[UIImage imageNamed:ocjArr_image[i]] forState:UIControlStateNormal];

        if ([shareTitle isEqualToString:@"微信"]) {
          
          ocjBtn_share.tag = 0;
        }else if ([shareTitle isEqualToString:@"朋友圈"]){
          
          ocjBtn_share.tag = 1;
        }else if ([shareTitle isEqualToString:@"微博"]){
          
          ocjBtn_share.tag = 2;
        }
        
        [ocjBtn_share addTarget:self action:@selector(ocjShareAction:) forControlEvents:UIControlEventTouchUpInside];
        [ocjView_share addSubview:ocjBtn_share];
        [ocjBtn_share mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(ocjView_share).offset(0);
          make.centerX.mas_equalTo(ocjView_share);
          make.width.height.mas_equalTo(@50);
        }];
        
        //label
        UILabel *ocjLab_share = [[UILabel alloc] init];
        ocjLab_share.text = shareTitle;
        ocjLab_share.font = [UIFont systemFontOfSize:15];
        ocjLab_share.textColor = OCJ_COLOR_DARK;
        ocjLab_share.textAlignment = NSTextAlignmentCenter;
        [ocjView_share addSubview:ocjLab_share];
        [ocjLab_share mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerX.mas_equalTo(ocjView_share);
          make.top.mas_equalTo(ocjBtn_share.mas_bottom).offset(5);
        }];
      }
    }else {
      
      UILabel* tipLabel = [[UILabel alloc]init];
      tipLabel.text = @"目前您没有可用分享平台～";
      tipLabel.font = [UIFont systemFontOfSize:25];
      tipLabel.textColor = OCJ_COLOR_DARK_GRAY;
      tipLabel.textAlignment = NSTextAlignmentCenter;
      [self.ocjView_container addSubview:tipLabel];
      [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ocjLab_title.mas_bottom);
        make.right.left.mas_equalTo(self.ocjView_container);
        make.height.mas_equalTo(@80);
      }];

    }

}

- (void)ocjShareAction:(UIButton *)ocjBtn {
  
    switch (ocjBtn.tag) {
        case 0:{//微信
            [[WSHHWXLogin sharedInstance] wshhShareToWXWithText:[self.ocjDic_share objectForKey:@"text"] image:[self.ocjDic_share objectForKey:@"image"] title:[self.ocjDic_share objectForKey:@"title"] url:[self.ocjDic_share objectForKey:@"url"] type:WSHHWXShareTypeSession resultBlock:^(BaseResp *resp, enum WXErrCode errCode) {
                
            }];
        }
            break;
        case 1:{//朋友圈
            [[WSHHWXLogin sharedInstance] wshhShareToWXWithText:[self.ocjDic_share objectForKey:@"text"] image:[self.ocjDic_share objectForKey:@"image"] title:[self.ocjDic_share objectForKey:@"title"] url:[self.ocjDic_share objectForKey:@"url"] type:WSHHWXShareTypeTimeline resultBlock:^(BaseResp *resp, enum WXErrCode errCode) {
                
            }];
        }
            break;
        case 2:{//微博
          
          NSString* text = [self.ocjDic_share objectForKey:@"text"];
          if (text.length==0) {
            text = [self.ocjDic_share objectForKey:@"title"];
          }
          
          [[WSHHWeiboLogin sharedInstance] wshhShareSinaWeiboWithText:text image:[self.ocjDic_share objectForKey:@"image"] webUrl:[self.ocjDic_share objectForKey:@"url"]];
        }
            break;
        case 5:{//支付宝
          if ([APOpenAPI isAPAppInstalled]) {
            //  创建消息载体 APMediaMessage 对象
            APMediaMessage *message = [[APMediaMessage alloc] init];
            message.title = @"蛤蛤蛤哈哈";
            message.desc = @"东方购物分享，东方购物分享";
            //  创建文本类型的消息对象
            APShareWebObject *textObj = [[APShareWebObject alloc] init];
            textObj.wepageUrl = @"http://www.baisu.com";
            //  回填 APMediaMessage 的消息对象
            message.mediaObject = textObj;
            
            //  创建发送请求对象
            APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
            //  填充消息载体对象
            request.message = message;
            //  分享场景，0为分享到好友，1为分享到生活圈；支付宝9.9.5版本至当前版本，分享入口已合并，scene参数并没有被使用，用户会在跳转进支付宝后选择分享场景（好友、动态、圈子等），但为保证老版本上无问题，建议还是照常传入。
            request.scene = 1;
            //  发送请求，返回接口调用结果，用户操作行为结果通过接收响应消息获得
            BOOL result = [APOpenAPI sendReq:request];
            if (!result) {
              //失败处理....
              OCJLog(@"hahah");
            }else {
              OCJLog(@"ooooooo");
            }
          }else {
            [WSHHAlert wshh_showHudWithTitle:@"您的设备没有安装支付宝客户端，请选择其他分享途径" andHideDelay:2.0];
          }
          
          //            [[WSHHQQSDKCall sharedInstance] wshhShareQQWithTitle:[self.ocjDic_share objectForKey:@"title"] url:[self.ocjDic_share objectForKey:@"url"] description:[self.ocjDic_share objectForKey:@"description"] previewImageUrl:[self.ocjDic_share objectForKey:@"previewImageUrl"] type:WSHHEnumQQShareQFriends];
        }break;
        case 3:{//QQ
          [[WSHHQQSDKCall sharedInstance] wshhShareQQWithTitle:[self.ocjDic_share objectForKey:@"title"] url:[self.ocjDic_share objectForKey:@"url"] description:[self.ocjDic_share objectForKey:@"text"] previewImageUrl:[self.ocjDic_share objectForKey:@"image"] type:WSHHEnumQQShareQFriends];
        }break;
        case 4:{//QQ空间
            [[WSHHQQSDKCall sharedInstance] wshhShareQQWithTitle:[self.ocjDic_share objectForKey:@"title"] url:[self.ocjDic_share objectForKey:@"url"] description:[self.ocjDic_share objectForKey:@"text"] previewImageUrl:[self.ocjDic_share objectForKey:@"image"] type:WSHHEnumQQShareQZone];
        }break;
            
            
        default:
            break;
    }
}

/**
 关闭popview
 */
- (void)ocj_closeAction {
    self.ocjView_bg.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.ocjView_container.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH / 2.0 - 20);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
