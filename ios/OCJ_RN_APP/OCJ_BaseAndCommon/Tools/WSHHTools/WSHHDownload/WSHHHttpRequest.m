//
//  WSHHHttpRequest.m
//  WSHH-VideoDownload
//
//  Created by LZB on 2017/4/12.
//  Copyright © 2017年 LZB. All rights reserved.
//

#import "WSHHHttpRequest.h"

@interface WSHHHttpRequest ()<ASIHTTPRequestDelegate, ASIProgressDelegate> {
    ASIHTTPRequest *_realRequest;
}

@end

@implementation WSHHHttpRequest

- (instancetype)initWSHHWithUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        _wshhUrl_url = url;
        _realRequest = [[ASIHTTPRequest alloc] initWithURL:url];
        _realRequest.delegate = self;
        [_realRequest setDownloadProgressDelegate:self];
        [_realRequest setNumberOfTimesToRetryOnTimeout:2];
        //支持断点续传
        [_realRequest setAllowResumeForFileDownloads:YES];
        //超时
        [_realRequest setTimeOutSeconds:30.0f];
    }
    return self;
}

- (void)setWshhDic_userInfo:(NSDictionary *)wshhDic_userInfo {
    _wshhDic_userInfo = wshhDic_userInfo;
}

- (void)setWshhInt_tag:(NSInteger)wshhInt_tag {
    _wshhInt_tag = wshhInt_tag;
}

- (NSURL *)wshhUrl_originalUrl {
    return _realRequest.originalURL;
}

- (NSError *)error {
    return _realRequest.error;
}

- (BOOL)isFinished {
    return _realRequest.isFinished;
}

- (BOOL)isExecuting {
    return [_realRequest isExecuting];
}

- (void)cancel {
    [_realRequest clearDelegatesAndCancel];
}

- (void)setWshhStr_downloadDestinationPath:(NSString *)wshhStr_downloadDestinationPath {
    _wshhStr_downloadDestinationPath = wshhStr_downloadDestinationPath;
    [_realRequest setDownloadDestinationPath:_wshhStr_downloadDestinationPath];
}

- (void)setWshhStr_downloadTemporaryPath:(NSString *)wshhStr_downloadTemporaryPath {
    _wshhStr_downloadTemporaryPath = wshhStr_downloadTemporaryPath;
    [_realRequest setTemporaryFileDownloadPath:_wshhStr_downloadTemporaryPath];
}

- (void)startAsynchronous {
    [_realRequest startAsynchronous];
}

#pragma mark - ASIHttpDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(requestStarted:)]) {
        [self.delegate requestStarted:self];
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeader
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(request:didReceiveResponseHeaders:)]) {
        [self.delegate request:self didReceiveResponseHeaders:responseHeader];
    }
}

- (void)request:(WSHHHttpRequest *)request didReceiveBytes:(long long)bytes
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(request:didReceiveBytes:)]) {
        [self.delegate request:self didReceiveBytes:bytes];
    }
}
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(request:willRedirectToURL:)]) {
        [self.delegate request:self willRedirectToUrl:newURL];
    }
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(requestFinished:)]) {
        [self.delegate requestFinished:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(requestFailed:)]) {
        [self.delegate requestFailed:self];
    }
}

//全部暂停的时候 request并不retain它们的代理，所以已经释放了代理，而之后request完成了，这将会引起崩溃。
//大多数情况下，如果你的代理即将被释放，你一定也希望取消所有request，因为你已经不再关心它们的返回情况了，所以得在ZFHttpRequest这个类的dealloc里面加上一个[request clearDelegatesAndCancel];
- (void)dealloc {
    NSLog(@"%@ 释放了", _realRequest);
    [_realRequest clearDelegatesAndCancel];
}

@end
