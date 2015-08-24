//
//  SenceDao.m
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SenceDao.h"
#import "FMDatabase.h"
#import "DBHelper.h"
#import "Sence.h"

static SenceDao *shareSenceDao = nil;

@implementation SenceDao

+(SenceDao *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareSenceDao) {
            shareSenceDao = [[SenceDao alloc] init];
            [SenceDao createTable];
        }
    });
    return shareSenceDao;
}

+(BOOL) createTable
{
    NSString *sql = @"CREATE TABLE if not exists sence (tableid INTEGER PRIMARY KEY, senceName TEXT, senceIcon INTEGER, senceType INTEGER, delayTime INTEGER, senceDate long, senceTime long, senceWeek INTEGER, lastStartTime long, createTime long, senceIndex INTEGER, boxId TEXT, syncNum INTEGER)";
    return [shareSenceDao executeUpdate:sql];
}

-(BOOL) addSence:(Sence *)sence
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO sence(senceName, senceIcon, senceType, delayTime, senceDate, senceTime, senceWeek, lastStartTime, createTime, senceIndex, boxId, syncNum) VALUES ('%@', %d, %d, %d, %lld, %lld, %d, %lld, %lld, %d, '%@', %d)",sence.senceName, sence.senceIcon, sence.senceType, sence.delayTime, sence.senceDate, sence.senceTime, sence.senceWeek, sence.lastStartTime, sence.createTime, sence.senceIndex, BOX_ID_VALUE, sence.syncNum];
    return [self executeUpdate:sql];
}

-(BOOL) updateSence:(Sence *)sence
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE sence SET senceName = '%@', senceIcon = %d, senceType = %d, delayTime = %d, senceDate = %lld, senceTime = %lld, senceWeek = %d, lastStartTime = %lld, createTime = %lld, senceIndex = %d, boxId = '%@', syncNum = %d where senceIndex = %d AND boxId = '%@'",sence.senceName, sence.senceIcon, sence.senceType, sence.delayTime, sence.senceDate, sence.senceTime, sence.senceWeek, sence.lastStartTime, sence.createTime, sence.senceIndex, BOX_ID_VALUE, sence.syncNum, sence.senceIndex, BOX_ID_VALUE];
    return [self executeUpdate:sql];
}

-(BOOL) removeSence:(Sence *)sence
{
    NSString *sql = [NSString stringWithFormat:@"delete from sence where boxId = '%@' AND senceIndex = %d",BOX_ID_VALUE, sence.senceIndex];
    return [self executeUpdate:sql];
}

-(NSMutableArray *)findAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from sence where boxId = '%@'",BOX_ID_VALUE];
    return [self executeQuery:sql];
}

-(NSMutableArray *) findByKey:(NSString *)key
{
    NSString *sql = @"";
    if ([key isEqualToString:@""]) {
        sql = [NSString stringWithFormat:@"select * from sence where boxId = '%@'", BOX_ID_VALUE];
    }else{
        sql = [NSString stringWithFormat:@"select * from sence where %@ AND boxId = '%@'",key, BOX_ID_VALUE];
    }
    return [self executeQuery:sql];
}

-(Sence *) findBySence:(Sence *)sence
{
    NSString *sql = [NSString stringWithFormat:@"select * from sence where senceIndex = %d AND boxId = '%@'",sence.senceIndex, BOX_ID_VALUE];
    
    NSMutableArray *sence_list = [self executeQuery:sql];
    
    if ([sence_list count] > 0) {
        return [sence_list objectAtIndex:0];
    }
    return nil;
}

-(BaseModel *) objectForSet:(FMResultSet *)set
{
    Sence *sence = [[Sence alloc] init];
    sence.tableid = [set intForColumn:@"tableid"];
    sence.senceName = [set stringForColumn:@"senceName"];
    sence.senceIcon = [set intForColumn:@"senceIcon"];
    sence.senceType = [set intForColumn:@"senceType"];
    sence.delayTime = [set intForColumn:@"delayTime"];
    sence.senceDate = [set longLongIntForColumn:@"senceDate"];
    sence.senceTime = [set longLongIntForColumn:@"senceTime"];
    sence.senceWeek = [set intForColumn:@"senceWeek"];
    sence.lastStartTime = [set longLongIntForColumn:@"lastStartTime"];
    sence.createTime = [set longLongIntForColumn:@"createTime"];
    sence.senceIndex = [set intForColumn:@"senceIndex"];
    sence.boxId = [set stringForColumn:@"boxId"];
    sence.syncNum = [set intForColumn:@"syncNum"];
    
    sence.createTime = sence.createTime / 1000;
    sence.senceDate = sence.senceDate / 1000;
    sence.senceTime = sence.senceTime / 1000;
    sence.lastStartTime = sence.lastStartTime / 1000;
    return sence;
}

@end
