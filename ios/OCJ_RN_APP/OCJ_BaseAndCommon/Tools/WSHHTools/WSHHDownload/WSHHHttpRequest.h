//
//  WSHHHttpRequest.h
//  WSHH-VideoDownload
//
//  Created by LZB on 2017/4/12.
//  Copyright © 2017年 LZB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASIHTTPRequest/ASIHTTPRequest.h>

@class WSHHHttpRequest;

@protocol WSHhHttpRequestDelegate <NSObject>
/** 请求失败 */
- (void)requestFailed:(WSHHHttpRequest *)request;
/** 请求开始 */
- (void)requestStarted:(WSHHHttpRequest *)request;
/** 收到反馈 */
- (void)request:(WSHHHttpRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseheaders;
/** 收到返回byte数据 */
- (void)request:(WSHHHttpRequest *)request didReceiveBytes:(long long)bytes;
/** 请求完成 */
- (void)requestFinished:(WSHHHttpRequest *)request;

@optional
- (void)request:(WSHHHttpRequest *)request willRedirectToUrl:(NSURL *)newUrl;

@end

@interface WSHHHttpRequest : NSObject

@property (nonatomic, weak) id<WSHhHttpRequestDelegate> delegate;

@property (nonatomic, strong) NSURL *wshhUrl_url;

@property (nonatomic, strong) NSURL *wshhUrl_originalUrl;

@property (nonatomic, strong) NSDictionary *wshhDic_userInfo;

@property (nonatomic,assign) NSInteger wshhInt_tag;
/** 最终保存路径 */
@property (nonatomic, strong) NSString *wshhStr_downloadDestinationPath;
/** 临时路径 */
@property (nonatomic, strong) NSString *wshhStr_downloadTemporaryPath;

@property (nonatomic, strong, readonly) NSError *error;

- (instancetype)initWSHHWithUrl:(NSURL *)url;

- (void)startAsynchronous;

- (BOOL)isFinished;

- (BOOL)isExecuting;

- (void)cancel;

@end
