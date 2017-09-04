//
//  WSHHDownloadDelegate.h
//  WSHH-VideoDownload
//
//  Created by LZB on 2017/4/12.
//  Copyright © 2017年 LZB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSHHHttpRequest.h"

@protocol WSHHDownloadDelegate <NSObject>

@optional

- (void) startDownload:(WSHHHttpRequest *)requestl;

- (void)updateCellProgress:(WSHHHttpRequest *)request;

- (void)finishedDownload:(WSHHHttpRequest *)request;

- (void)allowNextRequest;

@end
