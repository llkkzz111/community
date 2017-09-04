//
//  WSHHCommon.m
//  WSHH-VideoDownload
//
//  Created by LZB on 2017/4/12.
//  Copyright © 2017年 LZB. All rights reserved.
//

#import "WSHHCommon.h"
#import "WSHHDownloadFileModel.h"

@implementation WSHHCommon

+ (NSString *)wshh_getFileSizeString:(NSString *)size {
    if ([size floatValue] >= 1024*1024) {//大于1M，则转化成M单位的字符串
        
        return [NSString stringWithFormat:@"%1.2fM", [size floatValue] / 1024 / 1024];
        
    }else if ([size floatValue] >= 1024 && [size floatValue] < 1024*1024) {//不足1M,但是超过了1KB，则转化成KB单位
        
        return [NSString stringWithFormat:@"%1.2fK",[size floatValue]/1024];
        
    }else {//小于1k，则转化成B单位
        
        return [NSString stringWithFormat:@"%1.2fB",[size floatValue]];
    }
}

+ (float)wshh_getFileSizeNumber:(NSString *)size {
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000) {//是M单位的字符串
    
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
        
    }else if(indexK<1000) {//是K单位的字符串
    
        return [[size substringToIndex:indexK] floatValue]*1024;
        
    }else if(indexB<1000) {//是B单位的字符串
    
        return [[size substringToIndex:indexB] floatValue];
        
    }else {//没有任何单位的数字字符串
    
        return [size floatValue];
    }
}

+ (BOOL)isExistFile:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+ (NSDate *)wshh_makeDate:(NSString *)birthday {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:birthday];
    return date;
}

+ (NSString *)wshh_dateToString:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [df stringFromDate:date];
    return datestr;
}

+ (NSString *)createFolder:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if(!error) {
            NSLog(@"%@",[error description]);
        }
    }
    return path;
}

+ (CGFloat)calculateFileSizeInUnit:(unsigned long long)contentLength {
    if (contentLength >= pow(1024, 3)) {
        return (CGFloat) (contentLength / (CGFloat)pow(1024, 3));
    }
    else if (contentLength >= pow(1024, 2)) {
        return (CGFloat) (contentLength / (CGFloat)pow(1024, 2));
    }
    else if (contentLength >= 1024) {
        return (CGFloat) (contentLength / (CGFloat)1024);
    }
    else {
        return (CGFloat) (contentLength);
    }
}

+ (NSString *)calculateUnit:(unsigned long long)contentLength {
    if(contentLength >= pow(1024, 3)) {
        return @"GB";
    }
    else if(contentLength >= pow(1024, 2)) {
        return @"MB";
    }
    else if(contentLength >= 1024) {
        return @"KB";
    }
    else { return @"B";
    }
}

@end
