//
//  WSHHDownloadManager.m
//  WSHH-VideoDownload
//
//  Created by LZB on 2017/4/12.
//  Copyright © 2017年 LZB. All rights reserved.
//

#import "WSHHDownloadManager.h"

static WSHHDownloadManager *sharedDownloadManager = nil;

@interface WSHHDownloadManager ()<UIAlertViewDelegate>

/** 本地临时文件夹文件的个数 */
@property (nonatomic, assign) NSInteger wshhInt_count;

/** 已下载完成的文件列表（文件对象）*/
@property (strong) NSMutableArray *wshhArr_finishedList;

/** 正在下载的文件列表(ASIHttpRequest对象)*/
@property (strong) NSMutableArray *wshhArr_downloadingList;

/** 未下载完成的临时文件数组（文件对象)*/
@property (strong) NSMutableArray *wshhArr_fileList;

/** 下载的文件model */
@property (nonatomic, strong) WSHHDownloadFileModel *fileInfo;

@end

@implementation WSHHDownloadManager

+ (WSHHDownloadManager *)sharedDownloadManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDownloadManager = [[self alloc] init];
    });
    return sharedDownloadManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * max = [userDefaults valueForKey:KMaxRequestCount];
        if (max == nil) {
            [userDefaults setObject:@"3" forKey:KMaxRequestCount];
            max = @"3";
        }
        [userDefaults synchronize];
        _wshhInt_maxCount = [max integerValue];
        _wshhArr_fileList = [[NSMutableArray alloc] init];
        _wshhArr_downloadingList = [[NSMutableArray alloc] init];
        _wshhArr_finishedList = [[NSMutableArray alloc] init];
        _wshhInt_count = 0;
        //TODO:如果只有一个文件夹(不区分已完成和未完成)
        [self loadFinishedFiles];
        [self loadTempFiles];
    }
    return self;
}

- (void)cleanLastInfo {
    for (WSHHHttpRequest *request in _wshhArr_downloadingList) {
        if ([request isExecuting]) {
            [request cancel];
        }
    }
    [self saveFinishedFile];
    [_wshhArr_downloadingList removeAllObjects];
    [_wshhArr_fileList removeAllObjects];
    [_wshhArr_finishedList removeAllObjects];
}

#pragma mark - 创建一个下载任务
- (void)wshh_downloadFileUrl:(NSString *)url fileName:(NSString *)name fileImage:(UIImage *)image andSaveFilePath:(NSString *)path {
    //TODO:只需要在存储文件路径取数据对比(不区分临时文件和已下载文件)
    //
    _fileInfo = [[WSHHDownloadFileModel alloc] init];
    if (!name) {
        name = [url lastPathComponent];
    }
    _fileInfo.wshhStr_fileName = name;
    _fileInfo.wshhStr_fileUrl = url;
    
    NSDate *myDate = [NSDate date];
    _fileInfo.wshhStr_time = [WSHHCommon wshh_dateToString:myDate];
    _fileInfo.wshhStr_fileType = [name pathExtension];
    
    _fileInfo.wshhImage_fileImage = image;
    _fileInfo.wshhDownloadState = WSHHDownloading;
    _fileInfo.wshhError = NO;
    _fileInfo.wshhStr_tempPath = WSHHTEMP_PATH(name);
    if ([WSHHCommon isExistFile:WSHHFILE_PATH(name)]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该文件已下载，是否重新下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
        return;
    }
    //存在临时文件夹里
    NSString *tempFilePath = [WSHHTEMP_PATH(name) stringByAppendingString:@".plist"];
    if ([WSHHCommon isExistFile:tempFilePath]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该文件已下载，是否重新下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
        return;
    }
    
    //如果不存在文件和临时文件，则是新的下载
    [self.wshhArr_fileList addObject:_fileInfo];
    //开始下载
    [self startLoad];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件成功添加到下载队列" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [alert dismissWithClickedButtonIndex:0 animated:YES];
//        });
    return;
}

#pragma mark - 下载开始
- (void)beginRequest:(WSHHDownloadFileModel *)fileInfo isBeginDownload:(BOOL)isBeginDown {
    for(WSHHHttpRequest *tempRequest in self.wshhArr_downloadingList) {
        /**
         * 注意这里判读是否是同一下载的方法，asihttprequest有三种url： url，originalurl，redirectURL
         * 经过实践，应该使用originalurl,就是最先获得到的原下载地址
         **/
        if([[[tempRequest.wshhUrl_url absoluteString] lastPathComponent] isEqualToString:[fileInfo.wshhStr_fileUrl lastPathComponent]]) {
            if ([tempRequest isExecuting] && isBeginDown) {
                return;
            } else if ([tempRequest isExecuting] && !isBeginDown) {
                [tempRequest setWshhDic_userInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];
                [tempRequest cancel];
                [self.downloadDelegate updateCellProgress:tempRequest];
                return;
            }
        }
    }
    
    [self saveDownloadFile:fileInfo];
    
    // 按照获取的文件名获取临时文件的大小，即已下载的大小
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *fileData = [fileManager contentsAtPath:fileInfo.wshhStr_tempPath];
    NSInteger receivedDataLength = [fileData length];
    fileInfo.wshhStr_fileReceivedSize = [NSString stringWithFormat:@"%zd", receivedDataLength];
    
    NSLog(@"start down:已经下载：%@",fileInfo.wshhStr_fileReceivedSize);
    WSHHHttpRequest *midRequest = [[WSHHHttpRequest alloc] initWSHHWithUrl:[NSURL URLWithString:fileInfo.wshhStr_fileUrl]];
    midRequest.wshhStr_downloadDestinationPath = WSHHFILE_PATH(fileInfo.wshhStr_fileName);
    midRequest.wshhStr_downloadTemporaryPath = fileInfo.wshhStr_tempPath;
    midRequest.delegate = self;
    [midRequest setWshhDic_userInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
    if (isBeginDown) {
        [midRequest startAsynchronous];
    }
    
    // 如果文件重复下载或暂停、继续，则把队列中的请求删除，重新添加
    BOOL exit = NO;
    for (WSHHHttpRequest *tempRequest in self.wshhArr_downloadingList) {
        if([[[tempRequest.wshhUrl_url absoluteString] lastPathComponent] isEqualToString:[fileInfo.wshhStr_fileUrl lastPathComponent]]) {
            [self.wshhArr_downloadingList replaceObjectAtIndex:[_wshhArr_downloadingList indexOfObject:tempRequest] withObject:midRequest];
            exit = YES;
            break;
        }
    }
    
    if (!exit) { [self.wshhArr_downloadingList addObject:midRequest]; }
    [self.downloadDelegate updateCellProgress:midRequest];
}

#pragma mark - 存储下载信息到plist文件
- (void)saveDownloadFile:(WSHHDownloadFileModel *)fileinfo {
    NSData *imagedata = UIImagePNGRepresentation(fileinfo.wshhImage_fileImage);
    NSDictionary *fileDic = [NSDictionary dictionaryWithObjectsAndKeys:fileinfo.wshhStr_fileName,@"filename",
                             fileinfo.wshhStr_fileUrl,@"fileurl",
                             fileinfo.wshhStr_time,@"time",
                             fileinfo.wshhStr_fileSize,@"filesize",
                             fileinfo.wshhStr_fileReceivedSize,@"filerecievesize",
                             imagedata,@"fileimage",nil];
    
    NSString *plistPath = [fileinfo.wshhStr_tempPath stringByAppendingPathExtension:@"plist"];
//    NSLog(@"dic = %@", fileDic);
    if (![fileDic writeToFile:plistPath atomically:YES]) {
        NSLog(@"write plist fail2");
    }
}

#pragma mark - 自动处理下载状态的算法
/*下载状态的逻辑是这样的：三种状态，下载中，等待下载，停止下载
 
 当超过最大下载数时，继续添加的下载会进入等待状态，当同时下载数少于最大限制时会自动开始下载等待状态的任务。
 可以主动切换下载状态
 所有任务以添加时间排序。
 */

- (void)startLoad {
    NSInteger num = 0;
    NSInteger max = _wshhInt_maxCount;
    for (WSHHDownloadFileModel *file in _wshhArr_fileList) {
        if (!file.wshhError) {
            if (file.wshhDownloadState == WSHHDownloading) {
                if (num >= max) {
                    file.wshhDownloadState = WSHHDownloadWating;
                }else {
                    num++;
                }
            }
        }
    }
    if (num < max) {
        for (WSHHDownloadFileModel *file in _wshhArr_fileList) {
            if (!file.wshhError) {
                if (file.wshhDownloadState == WSHHDownloadWating) {
                    num++;
                    if (num > max) {
                        break;
                    }
                    file.wshhDownloadState = WSHHDownloading;
                }
            }
        }
    }
    for (WSHHDownloadFileModel *file in _wshhArr_fileList) {
        if (!file.wshhError) {
            if (file.wshhDownloadState == WSHHDownloading) {
                [self beginRequest:file isBeginDownload:YES];
                file.wshhDate_startTime = [NSDate date];
            }else {
                [self beginRequest:file isBeginDownload:NO];
            }
        }
    }
    self.wshhInt_count = [_wshhArr_fileList count];
}

#pragma mark - 恢复下载
- (void)resumeRequest:(WSHHHttpRequest *)request {
    NSInteger max = _wshhInt_maxCount;
    WSHHDownloadFileModel *fileInfo = [request.wshhDic_userInfo objectForKey:@"File"];
    NSInteger downloadingCount = 0;
    NSInteger indexMax = -1;
    for (WSHHDownloadFileModel *file in _wshhArr_fileList) {
        if (file.wshhDownloadState == WSHHDownloading) {
            downloadingCount++;
            if (downloadingCount == max) {
                indexMax = [_wshhArr_fileList indexOfObject:file];
            }
        }
    }
    //此时下载中数目是否是最大，并获得最大时的位置的index
    //只恢复达到最大下载数目之前的下载，之后的不恢复下载
    if (downloadingCount == max) {
        WSHHDownloadFileModel *file = [_wshhArr_fileList objectAtIndex:indexMax];
        if (file.wshhDownloadState == WSHHDownloading) {
            file.wshhDownloadState = WSHHDownloadWating;
        }
    }
    //中止一个进程使其进入等待
    for (WSHHDownloadFileModel *file in _wshhArr_fileList) {
        if ([file.wshhStr_fileName isEqualToString:fileInfo.wshhStr_fileName]) {
            file.wshhDownloadState = WSHHDownloading;
            file.wshhError = NO;
        }
    }
    //重新开始此下载
    [self startLoad];
    
}

#pragma mark - 暂停下载
- (void)stopRequest:(WSHHHttpRequest *)request {
    NSInteger max = _wshhInt_maxCount;
    if ([request isExecuting]) {
        [request cancel];
    }
    //找到具体的任务，改变其状态
    WSHHDownloadFileModel *fileInfo = [request.wshhDic_userInfo objectForKey:@"File"];
    for (WSHHDownloadFileModel *file in _wshhArr_fileList) {
        if ([file.wshhStr_fileName isEqualToString:file.wshhStr_fileName]) {
            file.wshhDownloadState = WSHHDownloadStop;
            break;
        }
    }
    //暂停一个下载后查看是否超过最大下载数，没有超过则恢复其他下载(不超过最大下载数额)
    NSInteger downloadingCount = 0;
    for (WSHHDownloadFileModel *file in _wshhArr_fileList) {
        if (file.wshhDownloadState == WSHHDownloading) {
            downloadingCount++;
        }
    }
    if (downloadingCount < max) {
        for (WSHHDownloadFileModel *file in _wshhArr_fileList) {
            if (file.wshhDownloadState == WSHHDownloadWating) {
                file.wshhDownloadState = WSHHDownloading;
                break;
            }
        }
    }
    [self startLoad];
}

#pragma mark - 删除下载
- (void)delegateRequest:(WSHHHttpRequest *)request {
    BOOL isExcuting = NO;
    if ([request isExecuting]) {
        [request cancel];
        isExcuting = YES;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    WSHHDownloadFileModel *fileInfo = (WSHHDownloadFileModel *)[request.wshhDic_userInfo objectForKey:@"File"];
    NSString *path = fileInfo.wshhStr_tempPath;
    
    NSString *configPath = [NSString stringWithFormat:@"%@.plist", path];
    [fileManager removeItemAtPath:path error:&error];
    [fileManager removeItemAtPath:configPath error:&error];
    
    if (!error) {
        NSLog(@"delete = %@", [error description]);
    }
    
    //搜索删除的是哪一个
    NSInteger deleteIndex = -1;
    for (WSHHDownloadFileModel *file in _wshhArr_fileList) {
        if ([file.wshhStr_fileName isEqualToString:fileInfo.wshhStr_fileName]) {
            deleteIndex = [_wshhArr_fileList indexOfObject:file];
            break;
        }
    }
    if (deleteIndex != NSNotFound) {
        [_wshhArr_fileList removeObjectAtIndex:deleteIndex];
    }
    [_wshhArr_downloadingList removeObject:request];
    
    if (isExcuting) {
        [self startLoad];
    }
    self.wshhInt_count = [_wshhArr_fileList count];
}

#pragma mark - 从这里获取上次未完成下载的信息
/** 将本地的未下载完成的临时文件加载到正在下载列表里，但是不接着开始下载 */
- (void)loadTempFiles {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:WSHHTEMP_FOLDER error:&error];
    if (!error) {
        NSLog(@"%@", [error description]);
    }
    NSMutableArray *fileArr = [[NSMutableArray alloc] init];
    for (NSString *file in fileList) {
        NSString *fileType = [file pathExtension];
        if ([fileType isEqualToString:@"plist"]) {
            [fileArr addObject:[self getTempFile:WSHHTEMP_PATH(file)]];
        }
    }
    
    NSArray *arr = [self sortByTime:(NSArray *)fileArr];
    [_wshhArr_fileList addObjectsFromArray:arr];
    [self startLoad];
}

- (WSHHDownloadFileModel *)getTempFile:(NSString *)path {
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    WSHHDownloadFileModel *file = [[WSHHDownloadFileModel alloc] init];
    file.wshhStr_fileName = [dic objectForKey:@"filename"];
    file.wshhStr_fileType = [file.wshhStr_fileName pathExtension];
    file.wshhStr_fileUrl = [dic objectForKey:@"fileurl"];
    file.wshhStr_fileSize = [dic objectForKey:@"filesize"];
    file.wshhStr_fileReceivedSize = [dic objectForKey:@"filerecievesize"];
    
    file.wshhStr_tempPath = WSHHTEMP_PATH(file.wshhStr_fileName);
    file.wshhStr_time = [dic objectForKey:@"time"];
    file.wshhImage_fileImage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];
    file.wshhDownloadState = WSHHDownloadStop;
    file.wshhError = NO;
    
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:file.wshhStr_tempPath];
    NSInteger receivedDataLength = [fileData length];
    file.wshhStr_fileReceivedSize = [NSString stringWithFormat:@"%zd", receivedDataLength];
    return file;
}

//按时间排序
- (NSArray *)sortByTime:(NSArray *)array {
    NSArray *sortArr = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WSHHDownloadFileModel *file1 = (WSHHDownloadFileModel *)obj1;
        WSHHDownloadFileModel *file2 = (WSHHDownloadFileModel *)obj2;
        NSDate *date1 = [WSHHCommon wshh_makeDate:file1.wshhStr_time];
        NSDate *date2 = [WSHHCommon wshh_makeDate:file2.wshhStr_time];
        if ([[date1 earlierDate:date2]isEqualToDate:date2]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([[date1 earlierDate:date2]isEqualToDate:date1]) {
            return (NSComparisonResult)NSOrderedAscending;
        }else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    return sortArr;
}

#pragma mark - 已完成的下载任务处理
//将本地已下载完成的文件加载到已下载列表里
- (void)loadFinishedFiles {
    if ([[NSFileManager defaultManager] fileExistsAtPath:WSHHPLIST_PATH]) {
        NSMutableArray *finishArr = [[NSMutableArray alloc] initWithContentsOfFile:WSHHPLIST_PATH];
        for (NSDictionary *dic in finishArr) {
            WSHHDownloadFileModel *file = [[WSHHDownloadFileModel alloc] init];
            file.wshhStr_fileName = [dic objectForKey:@"filename"];
            file.wshhStr_fileType = [file.wshhStr_fileName pathExtension];
            file.wshhStr_fileSize = [dic objectForKey:@"filesize"];
            file.wshhStr_time = [dic objectForKey:@"time"];
            file.wshhImage_fileImage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];
            [_wshhArr_finishedList addObject:file];
        }
    }
}

//保存已下载完成的文件
- (void)saveFinishedFile {
    if (_wshhArr_finishedList == nil) {
        return;
    }
    NSMutableArray *finishedInfo = [[NSMutableArray alloc] init];
    
    for (WSHHDownloadFileModel *fileInfo in _wshhArr_finishedList) {
        NSData *imageData = UIImagePNGRepresentation(fileInfo.wshhImage_fileImage);
        NSDictionary *fileDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 fileInfo.wshhStr_fileName,@"filename",
                                 fileInfo.wshhStr_time,@"time",
                                 fileInfo.wshhStr_fileSize,@"filesize",
                                 imageData,@"fileimage", nil];
        [finishedInfo addObject:fileDic];
    }
    if (![finishedInfo writeToFile:WSHHPLIST_PATH atomically:YES]) {
        NSLog(@"write plist fail1");
    }
}

//删除选中的已下载文件
- (void)deleateFinishiedFile:(WSHHDownloadFileModel *)selectmodel {
    [_wshhArr_finishedList removeObject:selectmodel];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = WSHHFILE_PATH(selectmodel.wshhStr_fileName);
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    [self saveFinishedFile];
}

#pragma mark - ASIHttpRequestDelegate
//出错，如果是等待超时，则继续下载
- (void)requestFailed:(WSHHHttpRequest *)request {
    NSError *error = [request error];
    NSLog(@"ASIHttpRequest出错了!%@",error);
    if (error.code == 4) {
        return;
    }
    if ([request isExecuting]) {
        [request cancel];
    }
    
    WSHHDownloadFileModel *fileInfo = [request.wshhDic_userInfo objectForKey:@"File"];
    fileInfo.wshhDownloadState = WSHHDownloadStop;
    fileInfo.wshhError = YES;
    for (WSHHDownloadFileModel *file in _wshhArr_fileList) {
        if ([file.wshhStr_fileName isEqualToString:fileInfo.wshhStr_fileName]) {
            file.wshhDownloadState = WSHHDownloadStop;
            file.wshhError = YES;
        }
    }
    [self.downloadDelegate updateCellProgress:request];
}

- (void)requestStarted:(WSHHHttpRequest *)request {
    NSLog(@"请求开始!!!");
}

- (void)request:(WSHHHttpRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseheaders {
    NSLog(@"收到回复!!!");
    
    WSHHDownloadFileModel *fileInfo = [request.wshhDic_userInfo objectForKey:@"File"];
    fileInfo.wshhisFirstReceived = YES;
    
    NSString *len = [responseheaders objectForKey:@"Content-Length"];
    // 这个信息头，首次收到的为总大小，那么后来续传时收到的大小肯定小于或等于首次的值，则忽略
    if ([fileInfo.wshhStr_fileSize longLongValue] > [len longLongValue]) {
        return;
    }
    
    fileInfo.wshhStr_fileSize = [NSString stringWithFormat:@"%lld", [len longLongValue]];
    [self saveDownloadFile:fileInfo];
}

- (void)request:(WSHHHttpRequest *)request didReceiveBytes:(long long)bytes {
    WSHHDownloadFileModel *fileInfo = [request.wshhDic_userInfo objectForKey:@"File"];
//    NSLog(@"%@,%lld",fileInfo.wshhStr_fileReceivedSize,bytes);
    
    if (fileInfo.wshhisFirstReceived) {
        fileInfo.wshhisFirstReceived = NO;
        fileInfo.wshhStr_fileReceivedSize = [NSString stringWithFormat:@"%lld", bytes];
    }else if (!fileInfo.wshhisFirstReceived) {
        fileInfo.wshhStr_fileReceivedSize = [NSString stringWithFormat:@"%lld", [fileInfo.wshhStr_fileReceivedSize longLongValue] + bytes];
    }
    NSUInteger receiveSize = [fileInfo.wshhStr_fileReceivedSize longLongValue];
    NSUInteger expectedSize = [fileInfo.wshhStr_fileSize longLongValue];
    
    //每秒下载速度
    NSTimeInterval downloadTime = -1 * [fileInfo.wshhDate_startTime timeIntervalSinceNow];
    CGFloat speed = (CGFloat)receiveSize / (CGFloat)downloadTime;
    if (speed == 0) {
        return;
    }
    
    CGFloat speedSec = [WSHHCommon calculateFileSizeInUnit:(unsigned long long)speed];
    NSString *unit = [WSHHCommon calculateUnit:(unsigned long long)speed];
    NSString *speedStr = [NSString stringWithFormat:@"%.2f%@/s", speedSec, unit];
    fileInfo.wshhStr_speed = speedStr;
    
    //剩余下载时间
    NSMutableString *remainingTimeStr = [[NSMutableString alloc] init];
    //剩余未下载的文件总长度
    NSUInteger remainingConteneLength = expectedSize - receiveSize;
    CGFloat remainingTime = (CGFloat)(remainingConteneLength / speed);
    NSInteger hours = remainingTime / 3600;
    NSInteger minutes = (remainingTime - hours * 3600 ) / 60;
    CGFloat seconds = remainingTime - hours * 3600 - minutes * 60;
    
    if (hours > 0) {
        [remainingTimeStr appendFormat:@"%zd小时 ", hours];
    }
    if (minutes > 0) {
        [remainingTimeStr appendFormat:@"%zd分 ", minutes];
    }
    if (seconds > 0) {
        [remainingTimeStr appendFormat:@"%.1f秒", seconds];
    }
    fileInfo.wshhStr_remainingTime = remainingTimeStr;
    
    if ([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:)]) {
        [self.downloadDelegate updateCellProgress:request];
    }
    
}

//将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉，然后向已下载列表里添加该文件对象
- (void)requestFinished:(WSHHHttpRequest *)request {
    WSHHDownloadFileModel *fileInfo = (WSHHDownloadFileModel *)[request.wshhDic_userInfo objectForKey:@"File"];
    [_wshhArr_finishedList addObject:fileInfo];
    NSString *configPath = [fileInfo.wshhStr_tempPath stringByAppendingString:@".plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    //如果存在临时文件的配置文件
    if ([fileManager fileExistsAtPath:configPath]) {
        [fileManager removeItemAtPath:configPath error:&error];
        if (!error) {
            NSLog(@"%@",[error description]);
        }
    }
    [_wshhArr_fileList removeObject:fileInfo];
    [_wshhArr_downloadingList removeObject:request];
    [self saveFinishedFile];
    [self startLoad];
    
    if ([self.downloadDelegate respondsToSelector:@selector(finishedDownload:)]) {
        [self.downloadDelegate finishedDownload:request];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //确定
    if (buttonIndex == 1) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSInteger deleteIndex = -1;
        NSString *path = WSHHFILE_PATH(_fileInfo.wshhStr_fileName);
        //已经下载过该文件
        if ([WSHHCommon isExistFile:path]) {
            for (WSHHDownloadFileModel *file in [self.wshhArr_finishedList mutableCopy]) {
                if ([file.wshhStr_fileName isEqualToString:_fileInfo.wshhStr_fileName]) {
                    //删除文件
                    [self deleateFinishiedFile:file];
                }
            }
        }else {//如果是正在下载中，则重新下载
            for (WSHHHttpRequest *request in [self.wshhArr_downloadingList mutableCopy]) {
                WSHHDownloadFileModel *fileModel = [request.wshhDic_userInfo objectForKey:@"File"];
                if ([fileModel.wshhStr_fileName isEqualToString:_fileInfo.wshhStr_fileName]) {
                    if ([request isExecuting]) {
                        [request cancel];
                    }
                    deleteIndex = [_wshhArr_downloadingList indexOfObject:request];
                    break;
                }
            }
            [_wshhArr_downloadingList removeObjectAtIndex:deleteIndex];
            
            for (WSHHDownloadFileModel *file in [self.wshhArr_fileList mutableCopy]) {
                if ([file.wshhStr_fileName isEqualToString:_fileInfo.wshhStr_fileName]) {
                    deleteIndex = [_wshhArr_fileList indexOfObject:file];
                    break;
                }
            }
            [_wshhArr_fileList removeObjectAtIndex:deleteIndex];
            
            
            NSString *tempFilePath = [_fileInfo.wshhStr_tempPath stringByAppendingString:@".plist"];
            if ([WSHHCommon isExistFile:tempFilePath]) {
                if (![fileManager removeItemAtPath:tempFilePath error:&error]) {
                    NSLog(@"删除临时文件出错:%@",[error localizedDescription]);
                }
            }
            //存在于临时文件夹里
            if ([WSHHCommon isExistFile:_fileInfo.wshhStr_tempPath]) {
                if (![fileManager removeItemAtPath:_fileInfo.wshhStr_tempPath error:&error]) {
                    NSLog(@"删除临时文件出错:%@",[error localizedDescription]);
                }
            }
        }
        
        self.fileInfo.wshhStr_fileReceivedSize = [WSHHCommon wshh_getFileSizeString:@"0"];
        [self.wshhArr_fileList addObject:_fileInfo];
        [self startLoad];
    }
}

#pragma mark - setter
- (void)setWshhInt_maxCount:(NSInteger)wshhInt_maxCount {
    _wshhInt_maxCount = wshhInt_maxCount;
    [[NSUserDefaults standardUserDefaults] setValue:@(wshhInt_maxCount) forKey:KMaxRequestCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[WSHHDownloadManager sharedDownloadManager] startLoad];
}


@end
