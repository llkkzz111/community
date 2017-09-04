//
//  WSHHDownloadManager.h
//  WSHH-VideoDownload
//
//  Created by LZB on 2017/4/12.
//  Copyright © 2017年 LZB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSHHDownloadFileModel.h"
#import "WSHHHttpRequest.h"
#import "WSHHDownloadDelegate.h"
#import "WSHHCommon.h"

#define KMaxRequestCount @"KMaxRequestCount"

@interface WSHHDownloadManager : NSObject<WSHhHttpRequestDelegate>

/** 下载列表的delegate */
@property (nonatomic, weak) id<WSHHDownloadDelegate> downloadDelegate;
/** 最大并发下载数 */
@property (nonatomic, assign) NSInteger wshhInt_maxCount;
/** 已下载完成的文件列表(文件对象) */
@property (atomic, strong, readonly) NSMutableArray *wshhArr_finishedList;
/** 未下载完成的文件列表(ASIHttpRequest对象) */
@property (atomic, strong, readonly) NSMutableArray *wshhArr_downloadingList;
/** 未下载完成的临时文件数组(文件对象) */
@property (atomic, strong, readonly) NSMutableArray *wshhArr_fileList;
/** 下载的文件model */
@property (nonatomic, strong, readonly) WSHHDownloadFileModel *fileInfo;

//单例
+ (WSHHDownloadManager *)sharedDownloadManager;

/** 清除所有下载请求 */
- (void)clearAllRequests;

/** 清除所有下载完的文件 */
- (void)clearAllFinished;

/** 恢复下载 */
- (void)resumeRequest:(WSHHHttpRequest *)request;

/** 删除选中的下载请求 */
- (void)delegateRequest:(WSHHHttpRequest *)request;

/** 停止选中的下载 */
- (void)stopRequest:(WSHHHttpRequest *)request;

/** 保存下载完成的文件信息到plist */
- (void)saveFinishedFile;

/** 删除某个下载完成的文件 */
- (void)deleateFinishiedFile:(WSHHDownloadFileModel *)selectmodel;

/** 下载视频时调用 */
- (void)wshh_downloadFileUrl:(NSString *)url fileName:(NSString *)name fileImage:(UIImage *)image andSaveFilePath:(NSString *)path;

/** 开始任务 */
- (void)startLoad;

@end
