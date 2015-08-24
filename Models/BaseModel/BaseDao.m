//
//  BaseDao.m
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseDao.h"
#import "DBHelper.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@implementation BaseDao

-(id) init {
    if (self = [super init]) {
        _dbHelper = [DBHelper shareDBHelper];
    }
    return self;
}

-(BOOL) executeUpdate:(NSString *)sql
{
    __block BOOL isSuccess;
    
    [_dbHelper.db_queue inDatabase:^(FMDatabase *db) {
       isSuccess = [db executeUpdate:sql];
    }];
    
    
    return isSuccess;
}

-(NSMutableArray *) executeQuery:(NSString *)sql
{
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
    [_dbHelper.db_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:sql];
        while ([set next]) {
            [list addObject:[self objectForSet:set]];
        }
    }];
    return list;
}

@end
