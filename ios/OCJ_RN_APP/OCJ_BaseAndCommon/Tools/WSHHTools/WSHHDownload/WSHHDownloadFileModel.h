//
//  WSHHDownloadFileModel.h
//  WSHH-VideoDownload
//
//  Created by LZB on 2017/4/12.
//  Copyright © 2017年 LZB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WSHHDownloadState) {
    WSHHDownloading,    //正在下载
    WSHHDownloadWating, //等待下载
    WSHHDownloadStop    //停止下载
};

@interface WSHHDownloadFileModel : NSObject

/** 文件名 */
@property (nonatomic, strong) NSString *wshhStr_fileName;
/** 文件总长度 */
@property (nonatomic, strong) NSString *wshhStr_fileSize;
/** 文件类型 */
@property (nonatomic, strong) NSString *wshhStr_fileType;
/** 是否是第一次接收数据，如果是则不累加第一次返回的数据长度，之后累加 */
@property (nonatomic, assign) BOOL wshhisFirstReceived;
/** 已经接收的文件长度 */
@property (nonatomic, strong) NSString *wshhStr_fileReceivedSize;
/** 接收的数据 */
@property (nonatomic, strong) NSMutableData *wshhData_fileReceived;
/** 下载文件的url */
@property (nonatomic, strong) NSString *wshhStr_fileUrl;
/** 下载时间 */
@property (nonatomic, strong) NSString *wshhStr_time;
/** 临时文件路径 */
@property (nonatomic, strong) NSString *wshhStr_tempPath;
/** 下载速度 */
@property (nonatomic, strong) NSString *wshhStr_speed;
/** 开始下载的时间 */
@property (nonatomic, strong) NSDate *wshhDate_startTime;
/** 剩余下载时间 */
@property (nonatomic, strong) NSString *wshhStr_remainingTime;


@property (nonatomic, assign) WSHHDownloadState wshhDownloadState;
/** 是否下载出错 */
@property (nonatomic, assign) BOOL wshhError;

@property (nonatomic, strong) NSString *wshhStr_MD5;
/** 文件的附属图片 */
@property (nonatomic, strong) UIImage *wshhImage_fileImage;

@end
