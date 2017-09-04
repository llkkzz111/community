//
//  OcjSqllite3.h
// 数据库工具类

#import <Foundation/Foundation.h>
#include <sqlite3.h>

@interface OcjSqllite3 : NSObject {
	@private
	sqlite3*  _sqlite;
	NSMutableArray* _columnMeta;
	NSMutableArray* _rows;
	NSUInteger _rowSize;
	NSUInteger _columnSize;
}
-(id) initWithName:(NSString*)path;
-(void)reset;
//total row
- (NSUInteger)rowCount;
- (NSUInteger)columnCount;
- (NSMutableArray*)getRows;
- (NSMutableArray*)getRow:(NSUInteger)rowindex ;


- (NSString*)getStringById:(NSUInteger)columnindex Row:(NSMutableArray*)row;
- (NSString*)getStringByName:(NSString*)columnname Row:(NSMutableArray*)row;
- (double)getDoubleByName:(NSString*)columnname Row:(NSMutableArray*)row;
- (NSUInteger)getIntById:(NSUInteger)columnindex Row:(NSMutableArray*)row;
- (NSUInteger)getIntByName:(NSString*)columnname Row:(NSMutableArray*)row;
- (long long)getLongById:(NSUInteger)columnindex Row:(NSMutableArray*)row;
- (long long)getLongByName:(NSString*)columnname Row:(NSMutableArray*)row;

- (NSTimeInterval)getTimeIntervalByName:(NSString*)columnname Row:(NSMutableArray*)row;




- (NSUInteger)str2Idx:(NSString*)col;

- (bool)query:(const char*)sql;
- (bool)update:(const char*)sql;
- (NSUInteger)save:(const char*)sql;

-(bool)isTableExist:(NSString*)tablename sql:(NSString*)test;
-(bool)isTableExist:(NSString*)tablename;

@end
