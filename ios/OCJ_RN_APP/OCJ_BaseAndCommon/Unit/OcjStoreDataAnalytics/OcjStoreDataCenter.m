//
//  OcjStoreDataCenter.m
//  OcjStoreDataAnalytics
//
//  Created by apple on 2017/5/18.
//  Copyright © 2017年 ocj. All rights reserved.
//

#import "OcjStoreDataCenter.h"
#import "OcjTrackData.h"
#import "OcjTrackDataDb.h"
#import "OcjJastorRuntimeHelper.h"
#import "OcjHttpEngine.h"

@interface OcjStoreDataCenter()
//这个array用于直接缓存从RN过来的数据
@property(nonatomic,retain) NSMutableArray* trackDataArray;
//这个array用于存放将要存储到数据库中的数据，数据来源于trackDataArray
@property(nonatomic,retain) NSMutableArray* saveToDbTrackDataArray;
//将数据从trackDataArray导入saveToDbTrackDataArray时使用的锁
@property(nonatomic,retain) NSLock* lockTrackDataArray;
//数据库操作时使用的锁
@property(nonatomic,retain) NSLock* lockOperatorDb;
//上一次同步的时间，保留，暂时未在逻辑中使用
@property(nonatomic) NSTimeInterval lastSyncTime;
//标识是否有上传任务，避免上传任务并发
@property(nonatomic) BOOL inProgress;
@end

/*
 暂定满二十条日志或半分钟之后同步一次日志
 */
//定义多长时间上传一次日志
#define COMMIT_DATA_LOOP_TIME 10
//定义达到多少条数据之后上传日志
#define MAX_CACHE_COUNT 10
//网络请求超时时间
#define TIMEOUT_CONNECT 30.0

@implementation OcjStoreDataCenter

-(void) startDataCenter{
    if (self.trackDataArray == nil){
        self.trackDataArray = [[NSMutableArray alloc] init];
        self.saveToDbTrackDataArray = [[NSMutableArray alloc] init];
        self.lockTrackDataArray = [[NSLock alloc] init];
        self.lockOperatorDb = [[NSLock alloc] init];
        self.lastSyncTime = 0;
        self.inProgress = NO;
        [self performSelector:@selector(timerLoop) withObject:self afterDelay:COMMIT_DATA_LOOP_TIME];
        //初始化时先看看有没有需要上传的数据
        [self trigerCommitData];
    }
}
-(void) trackEvent:(NSString *)eventId{
    OcjTrackEventData* eventData = [[OcjTrackEventData alloc] init];
    [eventData setType:OcjEventType_oneParam];
    [eventData setLogTime:[NSDate date]];
    [eventData setEventId:eventId];
    [eventData setSynced:0];
    [self pushTrackData: eventData];
    [self trigerSaveDataToDb];
}
-(void) trackEvent:(NSString *)eventId label:(NSString *)eventLabel{
    OcjTrackEventData* eventData = [[OcjTrackEventData alloc] init];
    [eventData setType:OcjEventType_twoParam];
    [eventData setLogTime:[NSDate date]];
    [eventData setEventId:eventId];
    [eventData setLabel:eventLabel];
    [eventData setSynced:0];
    [self pushTrackData: eventData];
    [self trigerSaveDataToDb];
}
-(void) trackEvent:(NSString *)eventId label:(NSString *)eventLabel parameters:(NSDictionary *)parameters{
    OcjTrackEventData* eventData = [[OcjTrackEventData alloc] init];
    [eventData setType:OcjEventType_threeParam];
    [eventData setLogTime:[NSDate date]];
    [eventData setEventId:eventId];
    [eventData setLabel:eventLabel];
    [eventData setParameters:parameters];
    [eventData setSynced:0];
    [self pushTrackData: eventData];
    [self trigerSaveDataToDb];
}
-(void) trackPageBegin:(NSString *)pageName{
    OcjTrackPageData* pageData = [[OcjTrackPageData alloc] init];
    [pageData setType:OcjEventType_page];
    [pageData setLogTime:[NSDate date]];
    [pageData setStartTime:pageData.logTime];
    [pageData setPageName:pageName];
    [pageData setSynced:0];
    [self pushTrackData: pageData];
}
-(void) trackPageEnd:(NSString *)pageName{
//    for (OcjTrackData* data in self.trackDataArray){
    OcjTrackPageData* pageData = nil;
    //在缓存中倒叙匹配进入页面的数据，匹配到之后这条页面记录就完整了，就可以进入数据库了
    for (long i = self.trackDataArray.count-1;i>=0;i--){
        OcjTrackData* data = self.trackDataArray[i];
        if (data.type == OcjEventType_page && [((OcjTrackPageData*)data).pageName isEqualToString:pageName] && ((OcjTrackPageData*)data).endTime == nil){
            [((OcjTrackPageData*)data) setEndTime:[NSDate date]];
            pageData = ((OcjTrackPageData*)data);
            break;
        }
    }
    if (pageData != nil){
        [self trigerSaveDataToDb];
    }
}
//将数据存入array缓存
-(void) pushTrackData:(OcjTrackData*) data{
    [self.lockTrackDataArray lock];
    [self.trackDataArray addObject:data];
    [self.lockTrackDataArray unlock];
}
//开始向数据库中导入数据
-(void) trigerSaveDataToDb{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self.lockTrackDataArray lock];
        [self.saveToDbTrackDataArray removeAllObjects];
        [self.saveToDbTrackDataArray addObjectsFromArray:self.trackDataArray];
        [self.trackDataArray removeAllObjects];
        //再把未完成的page track加回来，如果太长时间没完成的，也不要了
        NSTimeInterval nowValue = [self current];
        long timeOutValue = 30*60;
        for (long i = self.saveToDbTrackDataArray.count-1;i>=0;i--){
            OcjTrackData* data = self.saveToDbTrackDataArray[i];
            if (data.type == OcjEventType_page && ((OcjTrackPageData*)data).endTime == nil){
                //如果进入页面的时间太长了就不等了，暂定放弃此数据
                if (((OcjTrackPageData*)data).startTime.timeIntervalSince1970 - nowValue < timeOutValue){
                    [self.trackDataArray insertObject:data atIndex:0];
                }
                [self.saveToDbTrackDataArray removeObjectAtIndex:i];
            }
        }
        
        [self.lockOperatorDb lock];
        //将数据存入db中
        OcjTrackDataDb* db = [[OcjTrackDataDb alloc] init];
        [db addTrackData:self.saveToDbTrackDataArray];
        NSInteger unsendTrackDataCount = [db getUnsendTrackDataCount];
        [self.lockOperatorDb unlock];
        
        [self.lockTrackDataArray unlock];
      
        if (unsendTrackDataCount>=MAX_CACHE_COUNT){
            [self trigerCommitData];
        }
    });
}

//开始上传数据的逻辑，这里有数据就上传
-(void) trigerCommitData{
    NSTimeInterval nowDataValue = [self current];
    
    //不考虑这个条件了
    /*
    if (nowDataValue - self.lastSyncTime<COMMIT_DATA_LOOP_TIME){
        NSLog(@"time too short from last commit...");
        return;
    }
     */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        if (self.inProgress){
            return;
        }
        self.inProgress = YES;
        OcjTrackDataDb* db = [[OcjTrackDataDb alloc] init];
        [self.lockOperatorDb lock];
        //从db中取出未上传的日志进行上传
        NSArray* commitTrackDataArray = [db getTrackDataToUpload];
        [self.lockOperatorDb unlock];
        
        if (commitTrackDataArray.count>0){
            if ([self commitDataToServer:commitTrackDataArray]){
                //清掉上传的
                [self.lockOperatorDb lock];
                [db clearUploadTrackData];
                [self.lockOperatorDb unlock];
            }else{
                //置位未成功的数据
                [self.lockOperatorDb lock];
                [db resetUploadTrackData];
                [self.lockOperatorDb unlock];
            }
        }
        
        [self.saveToDbTrackDataArray removeAllObjects];
        self.lastSyncTime = [self current];
        self.inProgress = NO;
    });
}

//使用afterDelay来处理定时操作，也可以使用timer
-(void) timerLoop{
//    NSLog(@"in timerLoop..."); 
    [self trigerCommitData];
    
    [self performSelector:@selector(timerLoop) withObject:self afterDelay:COMMIT_DATA_LOOP_TIME];
}

//上传数据到ocj服务器
-(BOOL) commitDataToServer:(NSArray*) commitArray{
    //==========
    //todo:  传送这些数据到服务器
    NSLog(@"commitDataToServer count : %ld",commitArray.count);
    
    NSMutableString* postDataStr = [[NSMutableString alloc] init];
    [postDataStr appendString:@"{datas=["];
    for (int i = 0;i<commitArray.count;i++){
        OcjTrackData* data = commitArray[i];
        //转成json文本
        if (i > 0){
            [postDataStr appendString:@","];
        }
        NSString* jsonValue = [self convertFromObject:data];
        //todo:不知道数据格式是什么
        [postDataStr appendString:jsonValue];
    }
    [postDataStr appendString:@"]}"];
    NSLog(@"将要上传的数据：%@",postDataStr);
  
  //=============
  
    //TODO:生产环境需要替换地址
    NSString* httpUrl = @"http://10.22.218.164:8001/analysis/click";
  
  
    OcjHttpEngine* httpEngine = [[OcjHttpEngine alloc] init];
//    NSData *postData = [postDataStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSData *postData = [postDataStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSUTF8StringEncoding
    
    NSString *postLength = [NSString stringWithFormat:@"%ld", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setTimeoutInterval:TIMEOUT_CONNECT];
    [request setURL:[NSURL URLWithString:httpUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *respone;
    NSError *err = nil;
    NSData* myReturn =[httpEngine httpPost:request returningResponse:&respone error:(NSError **)&err];
    if(err == nil && myReturn != nil){
        //todo:处理返回值
        NSString* strResult = [[NSString alloc] initWithData:myReturn encoding:NSUTF8StringEncoding];
        NSLog(@"commit data strResult = %@",strResult);
    }else if(err != nil){
        NSLog(@"commitDataToServer failed error=%@",err.description);
        return NO;
    }
  
    /*
     上传结果处理，因中台没做校验
     */
  
    return YES;
}

//获取当前时间
-(NSTimeInterval)current{
    NSDate* date=[NSDate date];
    NSTimeInterval c=[date timeIntervalSince1970];
    return c;
}

//数据对象转json
- (NSString *)convertFromObject:(NSObject*) obj{
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
    NSArray *array =[OcjJastorRuntimeHelper propertyNames:obj.class];//获取所有的属性名称
    for (NSString *key in array) {
        NSObject* valueItem = [obj valueForKey:key];
        if (valueItem != nil && [valueItem isKindOfClass:[NSDate class]]){
            [returnDic setValue:[self getDisplayDate:(NSDate*)valueItem] forKey:key];
        }else{
            [returnDic setValue:[obj valueForKey:key] forKey:key];//从类里面取值然后赋给每个值，取得字典
        }
    }
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:returnDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}

//日期类型转换，否则对象转json时会报错
- (NSString*) getDisplayDate:(NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

@end
