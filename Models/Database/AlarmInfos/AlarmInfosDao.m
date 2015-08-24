//
//  AlarmInfosDao.m
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AlarmInfosDao.h"
#import "AlarmInfos.h"

static AlarmInfosDao *shareAlarmInfosDao = nil;

@implementation AlarmInfosDao

@synthesize list;

+(AlarmInfosDao *) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareAlarmInfosDao) {
            shareAlarmInfosDao = [[AlarmInfosDao alloc] init];
            [AlarmInfosDao createTable];
        }
    });
    return shareAlarmInfosDao;
}

+(BOOL) createTable
{
    NSString *sql = @"CREATE TABLE if not exists alarmInfos (tableid INTEGER PRIMARY KEY, entityId TEXT, entityName TEXT, entityIcon INTEGER, entityType TEXT, alarmTime long, state INTEGER, readState INTEGER, boxId TEXT, alarmIndex INTEGER)";
    return [shareAlarmInfosDao executeUpdate:sql];
}

-(BOOL) addAlarmInfos:(AlarmInfos *)alarmInfos
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO alarmInfos (entityId, entityName, entityIcon, entityType, alarmTime, state, readState, boxId, alarmIndex) VALUES ('%@', '%@', %d, '%@', %lld, %d, %d, '%@', %d)", alarmInfos.entityId, alarmInfos.entityName, alarmInfos.entityIcon, alarmInfos.entityType, alarmInfos.alarmTime, alarmInfos.state, alarmInfos.readState, BOX_ID_VALUE, alarmInfos.alarmIndex];
    return [self executeUpdate:sql];
}

-(NSMutableArray *) findAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from alarmInfos where boxId = '%@'",BOX_ID_VALUE];
    return [self executeQuery:sql];
}

-(AlarmInfos *) findByAlarmInfos:(AlarmInfos *)alarmInfos
{
    NSString *sql = [NSString stringWithFormat:@"select * from alarmInfos where boxId = '%@' AND alarmIndex = %d",BOX_ID_VALUE, alarmInfos.alarmIndex];
    NSMutableArray *alarmInfo_list = [self executeQuery:sql];
    if ([alarmInfo_list count] > 0) {
        return [alarmInfo_list objectAtIndex:0];
    }
    return nil;
}

-(BOOL) logoReadAlarmInfos
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE alarmInfos SET readState = 0 WHERE boxId = '%@'",BOX_ID_VALUE];
    return [self executeUpdate:sql];
}

-(BOOL) logoReadAlarmInfosForId:(int )alarmIndex
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE alarmInfos SET readState = 0 WHERE boxId = '%@' AND alarmIndex = %d",BOX_ID_VALUE, alarmIndex];
    return [self executeUpdate:sql];
}

-(NSMutableArray *) findUnReadAlarmInfos
{
    NSString *sql = [NSString stringWithFormat:@"select * from alarmInfos where boxId = '%@' AND readState = 1",BOX_ID_VALUE];
    return [self executeQuery:sql];
}

-(BaseModel *) objectForSet:(FMResultSet *)set
{
    AlarmInfos *alarmInfos = [[AlarmInfos alloc] init];
    alarmInfos.entityId = [set stringForColumn:@"entityId"];
    alarmInfos.entityName = [set stringForColumn:@"entityName"];
    alarmInfos.entityIcon = [set intForColumn:@"entityIcon"];
    alarmInfos.entityType = [set stringForColumn:@"entityType"];
    alarmInfos.alarmTime = [set longLongIntForColumn:@"alarmTime"];
    alarmInfos.state = [set intForColumn:@"state"];
    alarmInfos.readState = [set intForColumn:@"readState"];
    alarmInfos.boxId = [set stringForColumn:@"boxId"];
    alarmInfos.alarmIndex = [set intForColumn:@"alarmIndex"];
    return alarmInfos;
}

@end
