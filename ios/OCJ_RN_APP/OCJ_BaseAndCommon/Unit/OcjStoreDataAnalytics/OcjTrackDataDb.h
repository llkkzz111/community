//
//  OcjTrackDataDb.h
//


#import <Foundation/Foundation.h>

@interface OcjTrackDataDb : NSObject

-(void) createTable;
//向数据库中存入统计数据
-(void) addTrackData:(NSArray*) trackDataArray;
//从数据库中获取缓存数据，此时置位synced为1
-(NSArray*) getTrackDataToUpload;
//获取未上传的记录数，及synced为0的记录数
-(NSInteger)getUnsendTrackDataCount;
//清除synced为1的数据，调用此方法说明已经上传成功了
-(void) clearUploadTrackData;
//充值synced为1的数据到0，说明上传数据失败了
-(void) resetUploadTrackData;
@end
