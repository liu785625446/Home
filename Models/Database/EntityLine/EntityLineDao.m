//
//  EntityLineDao.m
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EntityLineDao.h"
#import "BaseModel.h"
#import "Entity.h"
#import "DBHelper.h"
#import "EntityLine.h"

static EntityLineDao *shareEntityLineDao = nil;

@implementation EntityLineDao
@synthesize list;

+(EntityLineDao *) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareEntityLineDao) {
            shareEntityLineDao = [[EntityLineDao alloc] init];
            [EntityLineDao createTable];
        }
    });
    return shareEntityLineDao;
}

+(BOOL) createTable
{
    NSString *sql = @"CREATE TABLE  if not exists entityLine (tableid INTEGER PRIMARY KEY, boxId TEXT, entityID TEXT, entityLineNum TEXT, entityLineName TEXT, state INTEGER, icon INTEGER, tempValue INTEGER, enabled INTEGER, entitySignal TEXT, roomId TEXT, entityType TEXT)";
    return [shareEntityLineDao executeUpdate: sql];
}

-(BOOL) addEntityLine:(EntityLine *)entityLine
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO entityLine(boxId,entityID,entityLineNum,entityLineName,state,icon,tempValue,enabled,entitySignal,roomId, entityType) VALUES ('%@','%@','%@','%@',%d,%d,%d,%d,'%@', '%@', '%@')",BOX_ID_VALUE,entityLine.entityID,entityLine.entityLineNum,entityLine.entityLineName,entityLine.state,entityLine.icon,0,entityLine.enabled, entityLine.entitySignal, entityLine.roomId, entityLine.entityType];
    return [self executeUpdate:sql];
}

-(BOOL) updateEntityLine:(EntityLine *)entityLine
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE entityLine SET entityLineName = '%@', state = %d,icon = %d, tempValue = %d, enabled = %d, entitySignal = '%@', roomId = '%@', entityType = '%@' WHERE entityID = '%@' AND entityLineNum = '%@' AND boxId = '%@'",entityLine.entityLineName,entityLine.state,entityLine.icon,entityLine.tempValue,entityLine.enabled,entityLine.entitySignal,entityLine.roomId, entityLine.entityType,entityLine.entityID,entityLine.entityLineNum,BOX_ID_VALUE];
   return [self executeUpdate:sql];
}

-(BOOL) removeEntityLineForEntity:(Entity *)entity
{
    NSString *sql = [NSString stringWithFormat:@"delete from entityLine where entityID = '%@'",entity.entityID];
    return [self executeUpdate:sql];
}

-(NSMutableArray *) findAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from entityLine where boxId = '%@'",BOX_ID_VALUE];
    return [self executeQuery:sql];
}

-(NSMutableArray *) findByEntity:(Entity *)entity;
{
    NSString *sql = [NSString stringWithFormat:@"select * from entityLine where entityID = '%@' AND boxId = '%@'",entity.entityID,BOX_ID_VALUE];
    return [self executeQuery:sql];
}

-(NSMutableArray *) findByEntityLine:(EntityLine *)entityLine
{
    NSString *sql = [NSString stringWithFormat:@"select * from entityLine where entityID = '%@' AND entityLineNum = '%@' AND boxId = '%@'",entityLine.entityID,entityLine.entityLineNum,BOX_ID_VALUE];
    return [self executeQuery:sql];
}

-(BaseModel *) objectForSet:(FMResultSet *)set
{
    EntityLine *entityLine = [[EntityLine alloc] init];
    entityLine.boxId = [set stringForColumn:@"boxId"];
    entityLine.entityID = [set stringForColumn:@"entityID"];
    entityLine.entityLineNum = [set stringForColumn:@"entityLineNum"];
    entityLine.entityLineName = [set stringForColumn:@"entityLineName"];
    entityLine.state = [set intForColumn:@"state"];
    entityLine.icon = [set intForColumn:@"icon"];
    entityLine.tempValue = [set intForColumn:@"tempValue"];
    entityLine.enabled = [set intForColumn:@"enabled"];
    entityLine.entitySignal = [set stringForColumn:@"entitySignal"];
    entityLine.entityType = [set stringForColumn:@"entityType"];
    entityLine.roomId = [set stringForColumn:@"roomId"];
    return entityLine;
}

@end
