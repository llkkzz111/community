//
//  OcjSqllite3.m


#import "OcjSqllite3.h"

@implementation OcjSqllite3

-(id) initWithName:(NSString*)path{
	if((self=[super init	])){
		_rowSize=0;
		_columnSize=0;
		_columnMeta=[[NSMutableArray alloc] init];
		_rows=[[NSMutableArray alloc] init];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		//NSString * dbPath=[documentsDirectory  stringByAppendingString:path];
		NSString * dbPath=[NSString stringWithFormat:@"%s/%s",[documentsDirectory UTF8String],[path UTF8String]];
		NSInteger  ret=sqlite3_open([dbPath UTF8String],&_sqlite);
		if(ret==SQLITE_OK){
			return self;
		}
	}
	return self;

}


- (void)dealloc{
//	[_rows release];
//	[_columnMeta release];
	if(_sqlite!=nil){
		sqlite3_close(_sqlite);
	}
//	[super dealloc];
}

// reset the
-(void)reset{
//	NSLog(@"reset sqlite");
	_rowSize=_columnSize=0;
	// release the rows
	
	[_rows removeAllObjects];
	/*for(NSString* s in _columnMeta){
		[s release];
	}*/
	[_columnMeta removeAllObjects];
	
}
//total row
- (NSUInteger)rowCount{
	return _rowSize;
}

- (NSUInteger)columnCount{
	return _columnSize;
}
- (NSMutableArray*)getRows{
	return _rows;
}
- (NSMutableArray*)getRow:(NSUInteger)rowindex{
	if(rowindex<[_rows count]){
		return [_rows objectAtIndex:rowindex];
	}
	return nil;
}

- (NSString*)getStringById:(NSUInteger)columnindex Row:(NSMutableArray*)row{
	if(row!=nil&&columnindex<_columnSize){
		return [row objectAtIndex:columnindex];
	}
	return nil;
}
- (NSString*)getStringByName:(NSString*)columnname Row:(NSMutableArray*)row{
	NSUInteger idx=[self str2Idx:columnname];
	if(idx>=0&&idx<_columnSize){
		return [self getStringById:idx	Row:row];
	}
	return nil;
}
- (double)getDoubleByName:(NSString*)columnname Row:(NSMutableArray*)row
{
	NSUInteger idx=[self str2Idx:columnname];
	if(idx>=0&&idx<_columnSize){
		return [[row objectAtIndex:idx] doubleValue];
	}
	return 0;
}
- (NSUInteger)getIntById:(NSUInteger)columnindex Row:(NSMutableArray*)row{
	NSString* col=[self getStringById:columnindex Row:row];
	if(col==nil){
		return -1;
	}else{
		return [ col intValue];
	}
}

- (NSUInteger)getIntByName:(NSString*)columnname Row:(NSMutableArray*)row{
	NSString * col=[self getStringByName:columnname Row:row];
	if(col==nil){
		return 0;
	}else{
		return [col intValue];
	}
	//return [self getInt:<#(NSString *)columnname#> Row:<#(NSMutableArray *)row#>
}

- (long long)getLongById:(NSUInteger)columnindex Row:(NSMutableArray*)row
{
	if(row!=nil&&columnindex<_columnSize){
        @try {
            return [[row objectAtIndex:columnindex] longLongValue];
        }
        @catch (NSException *exception) {
            return 0;
        }
        @finally {
            
        }
	}
	return 0;
}

- (long long)getLongByName:(NSString*)columnname Row:(NSMutableArray*)row
{
	NSUInteger idx=[self str2Idx:columnname];
	if(idx>=0&&idx<_columnSize){
        @try {
            return [[row objectAtIndex:idx] longLongValue];
        }
        @catch (NSException *exception) {
            return 0;
        }
        @finally {
            
        }
	}
	return 0;
}

- (NSTimeInterval)getTimeIntervalByName:(NSString*)columnname Row:(NSMutableArray*)row{
	NSString * col=[self getStringByName:columnname Row:row];
	if(col==nil){
		return 0.0f;
	}else{
		return [col doubleValue];
	}
	

}


- (NSUInteger)str2Idx:(NSString*)col{

	for(int i=0;i<_columnSize;i++){
		if([col isEqualToString: [_columnMeta objectAtIndex:i]]){
			return i;
		}  
	}
	return -1;
}


- (bool)query:(const char*)sql{
	[self reset];
	char ** result;
	char * errmsg;
	int rowSize,columnSize;
//	NSLog(@"sqlite.query: %s",sql);
	int ret=sqlite3_get_table(_sqlite,sql, &result, &rowSize, &columnSize, &errmsg);
	_rowSize=rowSize;
	_columnSize=columnSize;
	bool isSucceed=false;
	
	if(ret==SQLITE_OK){
		isSucceed=true;
		//Testing
//		NSLog(@"rowsize:%d ",_rowSize);
		
		// fill the column meta
		//_columnMeta=[NSMutableArray arrayWithCapacity:_columnSize];
		// (_rowSize+1)*_columnSize, that means
        //NSString * msg=[[NSString alloc] init];
        NSMutableString * log=[[NSMutableString alloc] init];
        [log appendString:@"\n"];
		for(int i=0;i<_columnSize;i++){
			NSMutableString * column=[NSMutableString stringWithCString:result[i]];
			[_columnMeta addObject:column];
            //msg 
			//NSLog(@"col:%d idx:%d :%@",i,i,column );
            [log appendString:column];
            [log appendString:@"\t"];
		}
        [log appendString:@"\n"];
        [log appendString:@"------------------------------------------------------------------\n"];	
		// file the rows
		//_rows=[NSMutableArray arrayWithCapacity:_rowSize];
		for(int j=1;j<_rowSize+1;j++){
			NSMutableArray * row=[NSMutableArray arrayWithCapacity:_columnSize];
			for(int i=0;i<_columnSize;i++){
				char * cl=result[j*_columnSize+i];
				if(cl!=nil){
					NSMutableString* col=[NSMutableString stringWithCString:result[j*_columnSize+i] encoding:NSUTF8StringEncoding];
					//NSLog(@"[row:%d col:%d] :%@",j,i,col);
                    [log appendString:col];
                    [log appendString:@"\t"];
					[row addObject:col];
				}else{
					[row addObject:@""];
				}
			}
			[_rows addObject:row];
            [log appendString:@"\n\n"];
		}
		[log appendString:@"------------------------------------------------------------------\n"];	
        
//        NSLog(@"%@",log);
//        [log release];
        
	}
    
	
	sqlite3_free_table(result);
	return true;
}



- (bool)update:(const char*)sql{
	bool isSucceed=false;
	char  *errmsg;
	int ret=sqlite3_exec(_sqlite, sql,0,0,&errmsg);
//	NSLog(@"sqlite.update :%s",sql);
	if(ret==SQLITE_OK){
		
		isSucceed=true;
	}else{
		NSLog(@"%d,%s",ret,errmsg);
		sqlite3_free(errmsg);
	}
	//NSLog(@"%s",errmsg);
	return isSucceed;
}
- (NSUInteger)save:(const char*)sql{
	bool ret=[self update:sql];
	if(ret==true){
		return sqlite3_last_insert_rowid(_sqlite);
	}else{
		return -1;
	}

}


-(bool)isTableExist:(NSString*)tablename sql:(NSString*)test{
		
	[self reset];
	bool ret=false;
	NSString * sql=[NSString stringWithFormat:test ,[tablename UTF8String]];
	char ** result;
	char * errmsg;
	int rowSize,columnSize;
//	NSLog(@"sqlite.query: %s",[sql UTF8String]);
	int res=sqlite3_get_table(_sqlite,[sql UTF8String], &result, &rowSize, &columnSize, &errmsg);
	
	if(res==SQLITE_OK){
		if(columnSize==0){
			ret=false;
			//	[self update:[NSString stringWithFormat:@"drop table %s",[tablename UTF8String]]];
		}else{
			ret=true;
		}
	}
	//[self reset];
	
	return ret;
	
}

-(bool)isTableExist:(NSString*)tablename{
    
	[self reset];
	bool ret=false;
//	NSString * sql=[NSString stringWithFormat:@"select * from %s" ,[tablename UTF8String]];
	NSString * sql=[NSString stringWithFormat:@"SELECT * FROM sqlite_master WHERE type='table' AND name= '%s'" ,[tablename UTF8String]];
//    SELECT count(*) FROM sqlite_master WHERE type='table' AND name='tableName';
	char ** result;
	char * errmsg;
	int rowSize,columnSize;
//	NSLog(@"sqlite.query: %s",[sql UTF8String]);
	int res=sqlite3_get_table(_sqlite,[sql UTF8String], &result, &rowSize, &columnSize, &errmsg);
	
	if(res==SQLITE_OK){
		if(columnSize==0){
			ret=false;
			//	[self update:[NSString stringWithFormat:@"drop table %s",[tablename UTF8String]]];
		}else{
			ret=true;
		}
	}
	//[self reset];
	
	return ret;
	
}
@end
