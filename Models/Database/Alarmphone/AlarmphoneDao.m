//
//  AlarmphoneDao.m
//  Home
//
//  Created by 刘军林 on 14/11/11.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AlarmphoneDao.h"
#import "DBHelper.h"
#import "BaseModel.h"
#import "Alarmphone.h"

static AlarmphoneDao *shareAlarmphoneDao = nil;

@implementation AlarmphoneDao

+(AlarmphoneDao *) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareAlarmphoneDao) {
            shareAlarmphoneDao = [[AlarmphoneDao alloc] init];
            [AlarmphoneDao createTable];
        }
    });
    return shareAlarmphoneDao;
}

+(int) createTable
{
    NSString *sql = @"CREATE TABLE  if not exists alarmPhone (tableid INTEGER PRIMARY KEY, contactName TEXT, contactNum TEXT, phoneIndex INTEGER, boxId TEXT)";
    [shareAlarmphoneDao executeUpdate:sql];
    return 0;
}

-(BOOL) addAlarmphone:(Alarmphone *)alarmphone
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO alarmPhone(contactName,contactNum,phoneIndex,boxId) VALUES ('%@', '%@', %d, '%@')",alarmphone.contactName, alarmphone.contactNum, 0, BOX_ID_VALUE];
    return [self executeUpdate:sql];
}

-(NSMutableArray *) findAllAlarmphone
{
    NSString *sql = [NSString stringWithFormat:@"select * from alarmPhone where boxId = '%@'",BOX_ID_VALUE];
    return [self executeQuery:sql];
}

-(BOOL) removeAlarmphone:(Alarmphone *)alarmphone
{
    NSString *sql = [NSString stringWithFormat:@"delete from alarmPhone where boxId = '%@' AND contactNum = '%@' AND contactName = '%@'",BOX_ID_VALUE,alarmphone.contactNum, alarmphone.contactName];
    return [self executeUpdate:sql];
}

-(BOOL) removeAllAlarmphone
{
    NSString *sql = [NSString stringWithFormat:@"delete from alarmPhone where boxId = '%@'",BOX_ID_VALUE];
    return [self executeUpdate:sql];;
}

-(BaseModel *) objectForSet:(FMResultSet *)set
{
    Alarmphone *alarmphone = [[Alarmphone alloc] init];
    alarmphone.contactName = [set stringForColumn:@"contactName"];
    alarmphone.contactNum = [set stringForColumn:@"contactNum"];
    alarmphone.boxId = [set stringForColumn:@"boxId"];
    return alarmphone;
}

@end
