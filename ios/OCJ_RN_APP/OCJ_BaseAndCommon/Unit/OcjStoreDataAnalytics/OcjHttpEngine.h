//
//  NgHttpEngine.h
//  BelinkSNS
//
//  Created by  on 13-3-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//  网络引擎

#import <Foundation/Foundation.h>
#import "OCJNetWorkCenter.h"

#define USE_HTTPS 1

@interface OcjHttpEngine : NSObject{
    NSURLConnection* connection;
    NSString* sendData;
    NSMutableData * receiveData;
    NSString* httpUrl;
    NSString* responseCenter;
    Boolean isExecute;
    NSInteger receiveContentLength;
    NSError* errorRet;
    NSURLResponse* responseRet;
    BOOL finished;
}

@property (nonatomic,retain) NSURLConnection * connection;
@property (nonatomic,retain) NSString * sendData;
@property (nonatomic,retain) NSMutableData * receiveData;
@property (nonatomic,retain) NSString * httpUrl;
@property (nonatomic,retain) NSString* responseCenter;
@property (nonatomic) Boolean isExecute;
@property (nonatomic) NSInteger receiveContentLength;

-(void) reset;

-(nullable NSData *) httpGet:(NSMutableURLRequest*) request returningResponse:(NSURLResponse * _Nullable * _Nullable)response error:(NSError **)error;

-(nullable NSData *) httpPost:(NSMutableURLRequest*) request returningResponse:(NSURLResponse * _Nullable * _Nullable)response error:(NSError **)error;

+(NSString*) changeUrlToHttps:(NSString*) urlStr;

/**
 中台埋点接口

 @param trackData 发给中台的数据
 @param handler
 */
+ (void)ocjTrackData:(NSDictionary *)trackData completionHandler:(OCJHttpResponseHander)handler;


@end
