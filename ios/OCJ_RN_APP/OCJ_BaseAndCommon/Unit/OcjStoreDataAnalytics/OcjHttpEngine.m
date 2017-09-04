//
//  OcjHttpEngine.m
//  BelinkSNS
//
//  Created by  on 13-3-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "OcjHttpEngine.h"
#import <CoreFoundation/CFString.h>
#import <UIKit/UIApplication.h>

NSString* const OCJURLPath_TrackData = @"http://10.22.218.164:8001/analysis/click"; ///< 获取省份名称信息

@implementation OcjHttpEngine

@synthesize connection;
@synthesize sendData;
@synthesize receiveData;
@synthesize httpUrl;
@synthesize responseCenter;
@synthesize isExecute;
@synthesize receiveContentLength;


- (id)init
{
    self = [super init];
    if (self) {
        isExecute = NO;
    }
    
    return self;
}

-(void)dealloc{
    [self reset];
}

-(void) reset{
    return;
    
    responseCenter = nil;
}
- (NSString *)URLEncodedString:(NSString*)url
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)url,
                                                                                                    (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                                    NULL,
                                                                                                    kCFStringEncodingUTF8));
    return encodedString;
}
-(nullable NSData *) httpGet:(NSMutableURLRequest*) request returningResponse:(NSURLResponse * _Nullable * _Nullable)response error:(NSError **)error{
    //连接发送请求
    finished = NO;
    
    responseRet = *response;
    errorRet = *error;
    
    NSURL* url = request.URL;
    
    
    receiveData = [[NSMutableData alloc] init];
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection == nil)
        return nil;
    
    NSLog(@"http get request return yes");
    //NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //堵塞线程，等待结束
    while(!finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return receiveData;
}

-(nullable NSData *) httpPost:(NSMutableURLRequest*) request returningResponse:(NSURLResponse * _Nullable * _Nullable)response error:(NSError **)error
{
    //连接发送请求
    finished = NO;
    
    errorRet = *error;
    responseRet = *response;
    
    receiveData = [[NSMutableData alloc] init];
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(connection == nil)
        return nil;
    //堵塞线程，等待结束
    while(!finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return receiveData;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response  {
    NSLog(@"接收完响应:%@",response);
    
    if (responseRet != nil){
        responseRet = response;
    }
    
    NSHTTPURLResponse * httpResponse;
    NSString * contentTypeHeader;
    
    httpResponse = (NSHTTPURLResponse *) response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    if (httpResponse.statusCode / 100 != 2){
        //error
    }else{
        //        for (int i =0 ;i<httpResponse.allHeaderFields.count;i++)
        //        {
        NSEnumerator* nums = [httpResponse.allHeaderFields keyEnumerator];
        //        nums
        id thing;
        while (thing = [nums nextObject]) {
            NSLog(@"I found %@",thing);
        }
        
        NSEnumerator* objects = [httpResponse.allHeaderFields objectEnumerator];
        while (thing = [objects nextObject]) {
            NSLog(@"I found %@",thing);
        }
        
        //        }
        
        
        contentTypeHeader = [httpResponse.allHeaderFields objectForKey:@"Content-Type"];
        if (contentTypeHeader == nil) {
            //            [self.delegate onLog:@"No Content-type"];
            
        } else {
            //            contentType=contentTypeHeader;
            //            [self.delegate onLog:@"response ok"];
            
        }
        NSString* length=[httpResponse.allHeaderFields objectForKey:@"Content-Length"];
        if(length!=nil)
            receiveContentLength=[self s2i:length];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  {
    NSLog(@"接收数据");
    [receiveData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  {
    NSLog(@"数据接收错误:%@",error);
    errorRet = error;
    
    finished = YES;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection  {
    NSLog(@"连接完成:%@,length = [%d]",connection,[receiveData length]);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSString* response=[[NSString alloc] initWithBytes:[receiveData bytes] length:[receiveData length] encoding:enc];
    
    NSLog(@"%@",response);
    //发送给解析程序
    
    errorRet = nil;
    [self reset];
    finished = YES;
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
   if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
   {
      // 不管证书是否有效都使用
      [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
   }
   else
   {
      [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
   }
}


-(NSString*)i2s:(NSUInteger)i{
    char buf[30];
    memset(buf,0,30);
    sprintf(buf, "%d",i);
    NSString *ret=[NSString stringWithCString:buf];
    
    return ret;
}

-(NSInteger)s2i:(NSString*)s{
    return [s intValue];
}

+(NSString*) changeUrlToHttps:(NSString*) urlStr{
    NSMutableString* resultStr = [[NSMutableString alloc] init];
    
    NSRange range = [urlStr rangeOfString:@"https://"];
    if (range.length>0){
        return urlStr;
    }
    range = [urlStr rangeOfString:@"http://"];
    if (range.length==0){
        return urlStr;
    }
    [resultStr appendString:@"https://"];
    NSString* addressUrl = [urlStr substringFromIndex:(range.location+range.length)];
    range = [addressUrl rangeOfString:@"/"];
    
    NSString* domainUrl = [addressUrl substringToIndex:(range.location+range.length)];
    
    NSRange portRange = [addressUrl rangeOfString:@":"];
    if (portRange.length == 0){
        [resultStr appendString:[domainUrl substringToIndex:range.location]];
        [resultStr appendString:@":443/"];
    }else{
        [resultStr appendString:[domainUrl substringToIndex:portRange.location]];
        [resultStr appendString:@":443/"];
    }
    [resultStr appendString:[addressUrl substringFromIndex:(range.location+range.length)]];
    
    NSLog(@"changeUrlToHttps url: %@",resultStr);
    return resultStr;
}





@end
