//
//  JZShareView.h
//  东方购物new
//
//  Created by Michael_Zuo on 2017/6/9.
//  Copyright © 2017年 OCJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DanmuModel.h"
typedef NS_ENUM(NSInteger , JZShareType)
{
    JZShareTimeLine = 1, // 朋友圈
    JZShareFrieds,        // 微信好友
    JZShareSina         // 新浪微博
};

@interface JZShareView : UIView

@property (nonatomic,strong)DanmuModel *liveInfoModel;
@end
