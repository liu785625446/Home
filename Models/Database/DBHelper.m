//
//  DBHelper.m
//  Home
//
//  Created by 刘军林 on 14/11/17.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "DBHelper.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

static DBHelper *shareDBHelper = nil;

@implementation DBHelper

@synthesize db_queue;

+(DBHelper *) shareDBHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDBHelper = [[DBHelper alloc] init];
        [shareDBHelper initDB];
    });
    
    return shareDBHelper;
}

-(void) initDB
{
    NSString *dbFilePath = [DBHelper applicationDocumentsDirectoryFile:DB_FILE_NAME];
    db_queue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    
    NSString *configTablePath = [[NSBundle mainBundle] pathForResource:@"DBConfig" ofType:@"plist"];
    NSDictionary *configTable = [[NSDictionary alloc] initWithContentsOfFile:configTablePath];
    NSNumber *dbConfigVersion = [configTable objectForKey:@"DB_VERSION"];
    
    if (dbConfigVersion == nil) {
        dbConfigVersion = [NSNumber numberWithInt:0];
    }
    
    int versionNumber = [self dbVersionNumber];
    if ([dbConfigVersion intValue] != versionNumber) {
        
        NSArray *deleteArray = @[@"DROP TABLE cameraInfos",@"DROP TABLE alarmInfos",@"DROP TABLE entity",@"DROP TABLE entityLine",@"DROP TABLE entityRemote",@"DROP TABLE rooms",@"DROP TABLE sence",@"DROP TABLE senceEntity"];
        for (NSString *deleteStr in deleteArray) {
            [db_queue inDatabase:^(FMDatabase *db) {
                [db executeUpdate:deleteStr];
                NSLog(@"版本更新删除表");
            }];
        }
        
        NSString *usql = [NSString stringWithFormat:@"update DBVersionInfo set version_number = %d",[dbConfigVersion intValue]];
        [db_queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:usql];
        }];
    }
}

//-(FMDatabase *) db
//{
//    NSString *dbFilePath = [DBHelper applicationDocumentsDirectoryFile:DB_FILE_NAME];
//    db = [FMDatabase databaseWithPath:dbFilePath];
//    if (![db open]) {
//        NSLog(@"数据库打开失败!");
//        return nil;
//    }
//    return db;
//
//}

-(int) dbVersionNumber
{
    __block int versionNumber = -1;
    NSString *sql = @"CREATE TABLE if not exists DBVersionInfo (version_number int)";
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];

    [db_queue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:sql]) {
            NSString *selectSql = @"select version_number from DBVersionInfo";
            FMResultSet *set = [db executeQuery:selectSql];
            while ([set next]) {
                versionNumber = [set intForColumn:@"version_number"];
                [array addObject:[NSNumber numberWithInt:versionNumber]];
            }
        }
    }];
    if ([array count] == 0) {
        NSString *addSql = [NSString stringWithFormat:@"INSERT INTO DBVersionInfo(version_number) VALUES (%d)",versionNumber];
        [db_queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:addSql];
        }];
    }

    
    return versionNumber;
}

+(NSString *) applicationDocumentsDirectoryFile:(NSString *)fileName
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:fileName];
    return path;
}

@end
