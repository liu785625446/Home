//
//  EntityDao.m
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EntityDao.h"
#import "DBHelper.h"
#import "BaseModel.h"
#import "Entity.h"
#import "const.h"
#import "config.h"
#import "EntityLineDao.h"
#import "FMDatabaseQueue.h"

static EntityDao *shareEntityDao = nil;

@implementation EntityDao

@synthesize list;

+(EntityDao *) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareEntityDao) {
            shareEntityDao = [[EntityDao alloc] init];
            [EntityDao createTable];
        }
    });
    return shareEntityDao;
}

+(int) createTable
{
    NSString *sql = @"CREATE TABLE  if not exists entity (tableid INTEGER PRIMARY KEY,entityID TEXT,entityName TEXT, state INTEGER,power INTEGER,link INTEGER,icon INTEGER,entityType TEXT,delstate INTEGER, syncNum INTEGER,boxId TEXT, entitySignal TEXT, roomId TEXT, alerterVoice TEXT, alerterVoiceNo TEXT, userCustomContent TEXT, attributeMark TEXT, deviceRemark TEXT)";
    [shareEntityDao executeUpdate:sql];
    return 0;
}

-(BOOL) addEntity:(Entity *)entity
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO entity(entityID, entityName,entityType,icon,link,power,state,delState,syncNum,boxId, entitySignal,roomId, alerterVoice, alerterVoiceNo, userCustomContent, attributeMark, deviceRemark) VALUES ('%@','%@','%@',%d,%d,%d,%d,%d,%d,'%@','%@', '%@', '%@', '%@', '%@', '%@', '%@')",entity.entityID,entity.entityName,entity.entityType,entity.icon,entity.link,entity.power,entity.state,entity.delState,entity.syncNum,BOX_ID_VALUE,entity.entitySignal,entity.roomId, entity.alerterVoice, entity.alerterVoiceNo, entity.userCustomContent, entity.attributeMark, entity.deviceRemark];
    return [self executeUpdate:sql];
}

-(BOOL) updateEntity:(Entity *)entity
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE entity SET entityName = '%@', icon = %d, link = %d, power = %d, state = %d, delState = %d, syncNum = %d, entitySignal = '%@', roomId = '%@', alerterVoice = '%@', alerterVoiceNo = '%@', userCustomContent = '%@', attributeMark = '%@', deviceRemark = '%@' WHERE entityID = '%@' AND boxId = '%@'",entity.entityName,entity.icon,entity.link,entity.power,entity.state,entity.delState, entity.syncNum,entity.entitySignal,entity.roomId,entity.alerterVoice, entity.alerterVoiceNo, entity.userCustomContent, entity.attributeMark, entity.deviceRemark , entity.entityID,BOX_ID_VALUE];
    return [self executeUpdate:sql];
}

-(BOOL) removeEntity:(Entity *)entity
{
    NSString *sql = [NSString stringWithFormat:@"delete from entity where entityID = '%@' AND boxId = '%@'",entity.entityID,BOX_ID_VALUE];
    return [self executeUpdate:sql];
}

-(NSMutableArray *) findByKey:(NSString *)Key
{
    NSString *sql = @"";
    if ([Key isEqualToString:@""]) {
        sql = [NSString stringWithFormat:@"select * from entity where boxId = '%@'",BOX_ID_VALUE];
    }else{
        sql = [NSString stringWithFormat:@"select * from entity where %@ AND boxId = '%@'",Key,BOX_ID_VALUE];
    }
    return [self executeQuery:sql];
}

-(Entity *) findByEntity:(Entity *)entity
{
    NSString *sql = [NSString stringWithFormat:@"select * from entity where entityID = '%@' AND boxId = '%@'",entity.entityID,BOX_ID_VALUE];

    NSMutableArray *entity_list = [self executeQuery:sql];
    if ([entity_list count] > 0) {
        return [entity_list objectAtIndex:0];
    }
    return nil;
}

-(NSMutableArray *) findAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from entity where boxId = '%@'",BOX_ID_VALUE];
    return [self executeQuery:sql];
}

-(NSMutableArray *) findIsLinkEntity
{
    NSString *sql = [NSString stringWithFormat:@"select * from entity where boxId = '%@'",BOX_ID_VALUE];
    
    NSMutableArray *entity_list = [[NSMutableArray alloc] initWithCapacity:0];
    
    __unsafe_unretained EntityDao *vc = self;
    
    NSMutableArray *temp = [self executeQuery:sql];
    
    for (Entity *entity in temp) {
        if ([entity.entityType intValue] == SOCKET_SWITCH || [entity.entityType intValue] == CURTAIN_SWITCH) {
            [entity_list addObject:entity];
        }else if ([entity.entityType intValue] == PANEL_SWITCH_3  || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
            EntityLineDao *entityLineDao = [EntityLineDao shareInstance];
            [entity_list addObjectsFromArray:[entityLineDao findByEntity:entity]];
        }
    }
    return entity_list;
}

-(BaseModel*) objectForSet:(FMResultSet *)set
{
    Entity *entity = [[Entity alloc] init];
    entity.tableid = [set intForColumn:@"tableid"];
    entity.boxId = [set stringForColumn:@"boxId"];
    entity.entityID = [set stringForColumn:@"entityID"];
    entity.entityName = [set stringForColumn:@"entityName"];
    entity.state = [set intForColumn:@"state"];
    entity.switchState = entity.state;
    entity.power = [set intForColumn:@"power"];
    entity.link = [set intForColumn:@"link"];
    entity.icon = [set intForColumn:@"icon"];
    entity.entityType = [set stringForColumn:@"entityType"];
    entity.delState = [set intForColumn:@"delState"];
    entity.syncNum = [set intForColumn:@"syncNum"];
    entity.entitySignal = [set stringForColumn:@"entitySignal"];
    entity.roomId = [set stringForColumn:@"roomId"];
    entity.alerterVoice = [set stringForColumn:@"alerterVoice"];
    entity.alerterVoiceNo = [set stringForColumn:@"alerterVoiceNo"];
    entity.userCustomContent = [set stringForColumn:@"userCustomContent"];
    entity.attributeMark = [set stringForColumn:@"attributeMark"];
    entity.deviceRemark = [set stringForColumn:@"deviceRemark"];
    
    return entity;
}

@end
