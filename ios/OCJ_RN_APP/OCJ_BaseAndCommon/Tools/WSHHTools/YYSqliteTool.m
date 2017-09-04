//
//  YYSqliteTool.m
//  threeEyes
//
//  Created by yangyang on 16/6/6.
//  Copyright © 2016年 FX. All rights reserved.
//

#import "YYSqliteTool.h"


@implementation YYSqliteTool

+(sqlite3*)yy_sqlite_createDataBaseWithName:(NSString *)dbName{
    
    //生成数据库文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* databaseFilePath = [documentsDirectory stringByAppendingPathComponent:dbName];
    NSLog(@"数据库地址：%@",databaseFilePath);
    
    //打开或创建数据库
    sqlite3 *database;
    if (sqlite3_open([databaseFilePath UTF8String] , &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
        return NULL;
    }else{
        
        return database;
    }
}

+(sqlite3*)yy_openSqliteFromPath:(NSString*)dbPath{
    
    //打开或创建数据库
    sqlite3 *database;
    if (sqlite3_open([dbPath UTF8String] , &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
        return NULL;
    }else{
        
        return database;
    }
}

+(void)yy_sqlite_createTableWithName:(NSString *)tableName fromSQLFileName:(NSString*)sqlFileName byDataBase:(sqlite3 *)db{
    
    BOOL isHasThisTable = [self yy_checkTableName:tableName inDataBase:db];
    if (isHasThisTable) {
        //表已经存在的情况下直接返回数据库
        return;
    }
    //    //创建数据库表
    NSError* error;
    NSString* sqlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:sqlFileName ofType:@"sql"] encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error:%@",error.description);
        return;
    }else{
        //        FXLog(@"string:%@",sqlString);
        //        return;
    }
    
    char *errorMsg;
    if (sqlite3_exec(db,[sqlString UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"创建数据库表错误: %s", errorMsg);
        return;
    }else{
        NSLog(@"%@表创建完成",tableName);
    }
    
}

+(NSArray *)yy_sqlite_fetchDataWithKeys:(NSArray *)keys byTable:(NSString *)tableName byDataBase:(sqlite3 *)db{
    
    NSMutableArray* mArray = [NSMutableArray array];
    //执行查询
    NSString* keysString = [keys componentsJoinedByString:@","];
    NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@",keysString,tableName];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        //依次读取数据库表格中相应的内容
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
            //获得数据
            for (int i=0; i<keys.count; i++) {
                NSString* key = keys[i];
                
                char *rowData = (char *)sqlite3_column_text(statement, i);
                NSString* rowString = [NSString stringWithUTF8String:rowData];
                
                [mDic setObject:rowString forKey:key];
            }
            [mArray addObject:[mDic copy]];
        }
        sqlite3_finalize(statement);
    }
    
    return [mArray copy];
}

+(NSArray *)yy_sqlite_fetchDataWithKeys:(NSArray *)keys byPredicate:(NSArray *)predicates byTable:(NSString *)tableName byDataBase:(sqlite3 *)db{
    
    NSMutableArray* mArray = [NSMutableArray array];
    //执行查询
    NSString* keysString = [keys componentsJoinedByString:@","];
    NSString* predicateString = [predicates componentsJoinedByString:@" AND "];
    NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@",keysString,tableName,predicateString];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        //依次读取数据库表格中相应的内容
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary* mDic = [NSMutableDictionary dictionary];
            //获得数据
            for (int i=0; i<keys.count; i++) {
                NSString* key = keys[i];
                
                char *rowData = (char *)sqlite3_column_text(statement, i);
                NSString* rowString = [NSString stringWithUTF8String:rowData];
                
                [mDic setObject:rowString forKey:key];
            }
            [mArray addObject:[mDic copy]];
        }
        sqlite3_finalize(statement);
    }
    
    //关闭数据库
//    sqlite3_close(db);
    return [mArray copy];
}

+(void)yy_insertElementToDb:(sqlite3 *)db table:(NSString*)tableName titles:(NSArray<NSString*> *)titles values:(NSArray*)values{
    
    NSString* titleStr = [titles componentsJoinedByString:@","];
    NSMutableArray* newValues = [NSMutableArray array];
    for (NSObject* obj in values) {
        NSString* objStr = [NSString stringWithFormat:@"'%@'",[obj description]];
        [newValues addObject:objStr];
    }
    NSString* valueStr = [newValues componentsJoinedByString:@","];
    NSString* sqlStr = [NSString stringWithFormat:@"insert into \"%@\" (%@) values (%@)",tableName,titleStr,valueStr];
 
    sqlite3_stmt *statement;
    int insertResult = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &statement, nil);
    if (insertResult != SQLITE_OK) {
        NSAssert(0, @"数据存储失败:%d",insertResult);
    }else{
        sqlite3_step(statement);
        NSLog(@"数据插入成功");
    }
    
}

+(void)yy_creatTableWithName:(NSString*)tableName sqlStr:(NSString*)sqlStr toDB:(sqlite3 *)db{
    
    if ([self yy_checkTableName:tableName inDataBase:db]) {
        return;
    }
    
    char *errorMsg;
    if (sqlite3_exec(db,[sqlStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"创建数据库表错误: %s", errorMsg);
    }else{
        NSLog(@"%@表创建完成",tableName);
    }
    
    
}

+(void)yy_dropTableName:(NSString*)tableName fromDB:(sqlite3 *)db{

    NSString *sqlStr = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
    char *errorMsg;
    if (sqlite3_exec(db,[sqlStr UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"删除数据库表错误: %s", errorMsg);
    }else{
        NSLog(@"%@表删除完成",tableName);
    }
}

+(BOOL)yy_checkTableName:(NSString *)name inDataBase:(sqlite3*)db{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",name];
    const char *sql_stmt = [sql UTF8String];
    
    char ** dbResult;
    int row,column;
    char *err;
    
    int b = sqlite3_get_table(db,sql_stmt,&dbResult,&row,&column,&err);
    if (b == SQLITE_OK) {

        return YES;
    }else{
        return NO;
    }
    
}

@end
