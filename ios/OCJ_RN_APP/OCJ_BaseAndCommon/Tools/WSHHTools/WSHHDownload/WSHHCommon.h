//
//  WSHHCommon.h
//  WSHH-VideoDownload
//
//  Created by LZB on 2017/4/12.
//  Copyright © 2017年 LZB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 下载文件的总文件夹 */
#define WSHHBASE    @"WSHHDownload"
/** 完整文件路径 */
#define WSHHTARGET  @"WSHHCacheList"
/** 临时文件夹名称 */
#define WSHHTEMP    @"WSHHTemp"

/** 缓存主目录 */
#define WSHHCACHES_DIRECTORY    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

/** 临时文件夹路径 */
#define WSHHTEMP_FOLDER         [NSString stringWithFormat:@"%@/%@/%@",WSHHCACHES_DIRECTORY,WSHHBASE,WSHHTEMP]

/** 临时文件的路径 */
#define WSHHTEMP_PATH(name)     [NSString stringWithFormat:@"%@/%@",[WSHHCommon createFolder:WSHHTEMP_FOLDER],name]

/** 下载文件夹路径 */
#define WSHHFILE_FOLDER         [NSString stringWithFormat:@"%@/%@/%@",WSHHCACHES_DIRECTORY,WSHHBASE,WSHHTARGET]

/** 下载文件的路径 */
#define WSHHFILE_PATH(name)     [NSString stringWithFormat:@"%@/%@",[WSHHCommon createFolder:WSHHFILE_FOLDER],name]

/** 文件信息的Plist路径 */
#define WSHHPLIST_PATH          [NSString stringWithFormat:@"%@/%@/FinishedPlist.plist",WSHHCACHES_DIRECTORY,WSHHBASE]

@interface WSHHCommon : NSObject

/** 将文件大小转换成M单位或者B单位 */
+ (NSString *)wshh_getFileSizeString:(NSString *)size;

/** 将文件大小转化成不带单位的数字 */
+ (float)wshh_getFileSizeNumber:(NSString *)size;

/** 字符串转化成日期 */
+ (NSDate *)wshh_makeDate:(NSString *)birthday;

/** 日期格式化成字符串 */
+ (NSString *)wshh_dateToString:(NSDate *)date;

/** 检查文件名是否存在 */
+ (BOOL)isExistFile:(NSString *)fileName;

/** 创建文件夹 */
+ (NSString *)createFolder:(NSString *)path;

+ (CGFloat)calculateFileSizeInUnit:(unsigned long long)contentLength;

+ (NSString *)calculateUnit:(unsigned long long)contentLength;

@end
