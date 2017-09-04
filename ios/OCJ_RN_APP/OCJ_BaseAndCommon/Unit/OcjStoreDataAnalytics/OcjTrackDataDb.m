//  OcjTrackDataDb.m

#import "OcjTrackDataDb.h"
#import "OcjTrackData.h"
#import "OcjSqllite3.h"
#import "OcjStoreDataCenter.h"

#define kDbName @"OcjTrackData.db"

@implementation OcjTrackDataDb

- (id)init{
	if(self=[super init]){
        [self createTable];
	}
	return self;
}

- (void)dealloc{
	
}

-(void) createTable
{
	OcjSqllite3* sqlite3=nil;
	@try {
		sqlite3=[[OcjSqllite3 alloc] initWithName:kDbName];

        if ([sqlite3 isTableExist:@"tab_track_data"])
            return;
        [sqlite3 update:"drop table tab_track_data"];

        [sqlite3 update:"create table tab_track_data (id INTEGER PRIMARY KEY,type,synced,logTime,SyncTime,eventId,label,parameters,pageName,startTime,endTime)"];
    }
	@catch (NSException * e) {
		NSLog(@"exception:%@",[e description]);
	}
	@finally {
	}
}

-(void) addTrackData:(NSArray*) trackDataArray{
    OcjSqllite3* sqlite3=nil;
    sqlite3=[[OcjSqllite3 alloc] initWithName:kDbName];
    
    NSString* sql = nil;
    for (OcjTrackData* data in trackDataArray){
        [sqlite3 reset];
        if ([data isKindOfClass:[OcjTrackEventData class]]){
            OcjTrackEventData* eventData = (OcjTrackEventData*)data;
            
            if (data.type == OcjEventType_oneParam){
                sql = [[NSString alloc] initWithFormat:@"insert into tab_track_data(type,synced,logTime,eventId) values(%ld,%ld,%f,\"%@\")",eventData.type,eventData.synced,eventData.logTime.timeIntervalSince1970,eventData.eventId];
            }else if (data.type == OcjEventType_twoParam){
                sql = [[NSString alloc] initWithFormat:@"insert into tab_track_data(type,synced,logTime,eventId,label) values(%ld,%ld,%f,\"%@\",\"%@\")",eventData.type,eventData.synced,eventData.logTime.timeIntervalSince1970,eventData.eventId,eventData.label];
            }else if (data.type == OcjEventType_threeParam){
                sql = [[NSString alloc] initWithFormat:@"insert into tab_track_data(type,synced,logTime,eventId,label,parameters) values(%ld,%ld,%f,\"%@\",\"%@\",\"%@\")",eventData.type,eventData.synced,eventData.logTime.timeIntervalSince1970,eventData.eventId,eventData.label,[self getStrFromDict:eventData.parameters]];
            }
        }else if ([data isKindOfClass:[OcjTrackPageData class]]){
            OcjTrackPageData* pageData = (OcjTrackPageData*)data;
            sql = [[NSString alloc] initWithFormat:@"insert into tab_track_data(type,synced,logTime,pageName,startTime,endTime) values(%ld,%ld,%f,\"%@\",%f,%f)",pageData.type,pageData.synced,pageData.logTime.timeIntervalSince1970,pageData.pageName,pageData.startTime.timeIntervalSince1970,pageData.endTime.timeIntervalSince1970];
        }
      
        if ([sqlite3 update:[sql UTF8String]]){
            NSLog(@"addTrackData update success...");
        }else{
            NSLog(@"addTrackData update failed...");
        }
    }
}

-(NSArray*) getTrackDataToUpload{
    OcjSqllite3* sqlite3=nil;
    sqlite3=[[OcjSqllite3 alloc] initWithName:kDbName];
    
    [sqlite3 reset];
    NSString* sql = @"update tab_track_data set synced=1";
    
//    NSLog(@"%@",sql);
    char sqlChar[512];
    strcpy(sqlChar,(char *)[sql UTF8String]);
    [sqlite3 update:sqlChar];
    
    sql = @"select id,type,synced,logTime,SyncTime,eventId,label,parameters,pageName,startTime,endTime from tab_track_data where synced=1";
    
    strcpy(sqlChar,(char *)[sql UTF8String]);
    [sqlite3 query:sqlChar];
    
//    NSLog(@"rowCount:%ld",[sqlite3 rowCount]);
//    NSLog(@"columnCount:%ld",[sqlite3 columnCount]);
    
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[sqlite3 rowCount];i++)
    {
        NSMutableArray* row=[sqlite3 getRow:i];
        NSInteger type = [sqlite3 getIntByName:@"type" Row:row];
        OcjTrackData* data = nil;
        if (type == OcjEventType_page){
            data = [[OcjTrackPageData alloc] init];
        }else{
            data = [[OcjTrackEventData alloc] init];
        }
        [data setType:type];
        [data setSynced:[sqlite3 getIntByName:@"synced" Row:row]];
        [data setLogTime:[[NSDate alloc] initWithTimeIntervalSince1970:[sqlite3 getDoubleByName:@"logTime" Row:row]]];
        if (type == OcjEventType_page){
            [((OcjTrackPageData*)data) setPageName:[sqlite3 getStringByName:@"pageName" Row:row]];
            [((OcjTrackPageData*)data) setStartTime:[[NSDate alloc] initWithTimeIntervalSince1970:[sqlite3 getDoubleByName:@"startTime" Row:row]]];
            [((OcjTrackPageData*)data) setEndTime:[[NSDate alloc] initWithTimeIntervalSince1970:[sqlite3 getDoubleByName:@"endTime" Row:row]]];
        }else{
            [((OcjTrackEventData*)data) setEventId:[sqlite3 getStringByName:@"eventId" Row:row]];
            if (data.type == OcjEventType_twoParam || data.type == OcjEventType_threeParam){
                [((OcjTrackEventData*)data) setLabel:[sqlite3 getStringByName:@"label" Row:row]];
            }
            if (data.type == OcjEventType_threeParam){
                [((OcjTrackEventData*)data) setParameters:[self getDictFromStr:[sqlite3 getStringByName:@"parameters" Row:row]]];
            }
        }
        [resultArray addObject:data];
    }
    
    return resultArray;
}
-(NSInteger)getUnsendTrackDataCount
{
    NSInteger trackDataCount = 0;
    OcjSqllite3* sqlite3=nil;
    sqlite3=[[OcjSqllite3 alloc] initWithName:kDbName];
    
    [sqlite3 reset];
    
    NSString* sql = sql = @"select count(*) as trackDataCount from tab_track_data where synced=0";

    char sqlChar[128];
    strcpy(sqlChar,(char *)[sql UTF8String]);
    [sqlite3 query:sqlChar];
    
//    NSLog(@"rowCount:%ld",[sqlite3 rowCount]);
//    NSLog(@"columnCount:%ld",[sqlite3 columnCount]);
    for(int i=0;i<[sqlite3 rowCount];i++){
        NSMutableArray* row=[sqlite3 getRow:i];
        
        trackDataCount = [sqlite3 getIntByName:@"trackDataCount" Row:row];
        break;
    }
    
    return trackDataCount;
}

-(void) clearUploadTrackData{
    OcjSqllite3* sqlite3=nil;
    sqlite3=[[OcjSqllite3 alloc] initWithName:kDbName];
    
    NSString* sql = @"delete from tab_track_data where synced=1";
    
    char sqlChar[256];
    strcpy(sqlChar,(char *)[sql UTF8String]);
    [sqlite3 reset];
    [sqlite3 update:sqlChar];
}

-(void) resetUploadTrackData{
    OcjSqllite3* sqlite3=nil;
    sqlite3=[[OcjSqllite3 alloc] initWithName:kDbName];
    
    NSString* sql = @"update tab_track_data set synced=0 where synced=1";
    
    char sqlChar[256];
    strcpy(sqlChar,(char *)[sql UTF8String]);
    [sqlite3 reset];
    [sqlite3 update:sqlChar];
}

//参数存储，先使用字符串拼接的方式，也可以直接存入json
#define ITEM_SPLIT @"`$"
#define KEY_VALUE_SPLIT @"`&"
-(NSString*) getStrFromDict:(NSDictionary*) dict{
    if (dict == nil)
        return nil;
    NSMutableString* resultStr = [[NSMutableString alloc] init];
    for(int i = 0;i<dict.allKeys.count;i++){
        NSString* key = dict.allKeys[i];
        NSString* value = [dict valueForKey:key];
        if (i>0){
            [resultStr appendString:@","];
        }
        [resultStr appendFormat:@"%@%@%@",key,KEY_VALUE_SPLIT,value];
    }
    return resultStr;
}

-(NSMutableDictionary*) getDictFromStr:(NSString*) str{
    if (str == nil)
        return nil;
    NSMutableDictionary* dictResult = nil;
    NSMutableArray* itemArray = [[NSMutableArray alloc] init];
    [self getStrArrayByStr:str :itemArray :ITEM_SPLIT];
    if (itemArray.count>0){
        dictResult = [[NSMutableDictionary alloc] init];
        for (NSString* splitStr in itemArray){
            NSMutableArray* keyValueArray = [[NSMutableArray alloc] init];
            [self getStrArrayByStr:splitStr :keyValueArray :KEY_VALUE_SPLIT];
            if (keyValueArray.count == 2){
                [dictResult setObject:keyValueArray[1] forKey:keyValueArray[0]];
            }
        }
    }
    return dictResult;
}


-(void)getStrArrayByStr:(NSString*)message : (NSMutableArray*)array :(NSString*)split
{
    NSRange range=[message rangeOfString: split];
    if (range.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            NSString *str=[message substringFromIndex:range.location+split.length];
            if (str != nil && str != [NSNull null] && [str length]>0)
            {
                [self getStrArrayByStr:str :array :split];
            }
            else
            {
                return;
            }
        }else {
            [array addObject:@""];
            NSString *str=[message substringFromIndex:range.location+split.length];
            if (str != nil && str != [NSNull null] && [str length]>0)
            {
                [self getStrArrayByStr:str :array :split];
            }
            else
            {
                return;
            }
        }
    } else if (message != nil) {
        [array addObject:message];
    }
}


@end
