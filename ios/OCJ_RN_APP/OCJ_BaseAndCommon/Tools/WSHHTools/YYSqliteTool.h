//
//  YYSqliteTool.h
//  threeEyes
//
//  Created by yangyang on 16/6/6.
//  Copyright © 2016年 FX. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface YYSqliteTool : NSObject

/**
 *  创建数据库(默认存到沙盒的document中)
 *
 *  @param dbName 数据库名称
 *
 *  @return 成功返回句柄，失败返回NULL
 */
+(sqlite3*)yy_sqlite_createDataBaseWithName:(NSString*)dbName;



/**
 打开数据库

 @param dbPath 数据库路径
 @return 成功返回句柄，失败返回NULL
 */
+(sqlite3*)yy_openSqliteFromPath:(NSString*)dbPath;

/**
 *  从Sql文件中导入表
 *
 *  @param tableName 表名
 *  @param db    数据库名
 */
+(void)yy_sqlite_createTableWithName:(NSString *)tableName fromSQLFileName:(NSString*)sqlFileName byDataBase:(sqlite3 *)db;


/**
 创建表单

 @param tableName 表名
 @param sqlStr sql语句
 @param db 数据库名称
 */
+(void)yy_creatTableWithName:(NSString*)tableName sqlStr:(NSString*)sqlStr toDB:(sqlite3 *)db;


/**
 删除表

 @param tableName 表名
 @param db 数据库名
 */
+(void)yy_dropTableName:(NSString*)tableName fromDB:(sqlite3 *)db;

/**
 *  查询数据
 *
 *  @param keys      需要查询的键
 *  @param tableName 表名
 *  @param db    数据库名
 *
 *  @return @[@{key:value},...]
 */
+(NSArray*)yy_sqlite_fetchDataWithKeys:(NSArray*)keys byTable:(NSString*)tableName byDataBase:(sqlite3 *)db;

/**
 *  特定条件查询数据
 *
 *  @param keys       需要查询的键
 *  @param predicates 查询条件数组@[@"id=5","name='张三'"]
 *  @param tableName  表名
 *  @param db     数据库名
 *
 *  @return @[@{key:value},...]
 */
+(NSArray*)yy_sqlite_fetchDataWithKeys:(NSArray*)keys byPredicate:(NSArray*)predicates byTable:(NSString*)tableName byDataBase:(sqlite3 *)db;


/**
 插入数据

 @param db 数据库名
 @param tableName 表名
 @param titles 列名集
 @param values 值集
 */
+(void)yy_insertElementToDb:(sqlite3 *)db table:(NSString*)tableName titles:(NSArray<NSString*> *)titles values:(NSArray*)values;
@end
