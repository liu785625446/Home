//
//  SenceEntityDao.m
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SenceEntityDao.h"
#import "FMDatabase.h"
#import "SenceEntity.h"
#import "Sence.h"
#import "DBHelper.h"
#import "Entity.h"
#import "EntityRemote.h"
#import "EntityLine.h"

static SenceEntityDao *shareSenceEntityDao = nil;

@implementation SenceEntityDao

+(SenceEntityDao *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareSenceEntityDao) {
            shareSenceEntityDao = [[SenceEntityDao alloc] init];
            [SenceEntityDao createTable];
        }
    });
    
    return shareSenceEntityDao;
}

+(BOOL) createTable
{
    NSString *sql = @"CREATE TABLE if not exists senceEntity(tableid INTEGER PRIMARY KEY, senceIndex INTEGER, entityId TEXT, entityLineNum INTEGER, entityRemoteIndex INTEGER, state INTEGER, arcPower INTEGER, arcMode INTEGER, arcTemp INTEGER, arcFan INTEGER, arcFanMode INTEGER, boxId TEXT, senceEntityIndex INTEGER)";
    return [shareSenceEntityDao executeUpdate:sql];
}

-(BOOL) addSenceEntity:(SenceEntity *)senceEntity
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO senceEntity(senceIndex, entityId, entityLineNum, entityRemoteIndex, state, arcPower, arcMode, arcTemp, arcFan, arcFanMode, boxId, senceEntityIndex) VALUES (%d, '%@', %d, %d, %d, %d, %d, %d, %d, %d, '%@', %d)",senceEntity.senceIndex, senceEntity.entityId, senceEntity.entityLineNum, senceEntity.entityRemoteIndex, senceEntity.state, senceEntity.arcPower, senceEntity.arcMode, senceEntity.arcTemp, senceEntity.arcFan, senceEntity.arcFanMode, senceEntity.boxId, senceEntity.senceEntityIndex];
    return [self executeUpdate:sql];
}

-(BOOL) updateSenceEntity:(SenceEntity *)senceEntity
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE senceEntity SET state = %d, arcPower = %d, arcMode = %d, arcTemp = %d, arcFan = %d, arcFanMode = %d where entityId = '%@' AND boxId = '%@' AND senceIndex = %d",senceEntity.state, senceEntity.arcPower, senceEntity.arcMode, senceEntity.arcTemp, senceEntity.arcFan, senceEntity.arcFanMode, senceEntity.entityId, BOX_ID_VALUE, senceEntity.senceIndex];
    return [self executeUpdate:sql];
}

-(BOOL) removeSenceEntity:(SenceEntity *)senceEntity
{
    NSString *sql = [NSString stringWithFormat:@"delete from senceEntity where boxId = '%@' AND entityId = '%@' AND senceIndex = %d",senceEntity.boxId, senceEntity.entityId, senceEntity.senceIndex];
    return [self executeUpdate:sql];
}

-(BOOL) removeAllForSence:(Sence *)sence
{
    NSString *sql = [NSString stringWithFormat:@"delete from senceEntity where boxId = '%@' AND senceIndex = %d",BOX_ID_VALUE, sence.senceIndex];
    return [self executeUpdate:sql];
}

-(BOOL) removeSenceEntityForBaseModel:(BaseModel *)baseModel
{
    NSString *sql = @"";
    if ([baseModel isKindOfClass:[Entity class]]) {
        Entity *entity = (Entity *)baseModel;
        sql = [NSString stringWithFormat:@"delete from senceEntity where boxId = '%@' AND entityId = '%@'", BOX_ID_VALUE, entity.entityID];
    }else if ([baseModel isKindOfClass:[EntityRemote class]]) {
        EntityRemote *entityRemote = (EntityRemote *)baseModel;
        sql = [NSString stringWithFormat:@"delete from senceEntity where boxId = '%@' AND entityId = '%@' AND entityRemoteIndex = %d",BOX_ID_VALUE, entityRemote.entityId, entityRemote.entityRemoteIndex];
    }else if ([baseModel isKindOfClass:[EntityLine class]]) {
        EntityLine *entityLine = (EntityLine *)baseModel;
        sql = [NSString stringWithFormat:@"delete from senceEntity where boxId = '%@' AND entityId = '%@' AND entityLineNum = %@", BOX_ID_VALUE, entityLine.entityID, entityLine.entityLineNum];
    }
    return [self executeUpdate:sql];
}

-(NSMutableArray *) findSenceEntityForSence:(Sence *)sence
{
    NSString *sql = [NSString stringWithFormat:@"select * from senceEntity where boxId = '%@' AND senceIndex = %d",BOX_ID_VALUE, sence.senceIndex];
    return [self executeQuery:sql];
}

-(NSMutableArray *) findAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from senceEntity where boxId = '%@'",BOX_ID_VALUE];
    return [self executeQuery:sql];
}

-(BaseModel *) objectForSet:(FMResultSet *)set
{
    SenceEntity *senceEntity = [[SenceEntity alloc] init];
    senceEntity.tableid = [set intForColumn:@"tableid"];
    senceEntity.senceIndex = [set intForColumn:@"senceIndex"];
    senceEntity.entityId = [set stringForColumn:@"entityId"];
    senceEntity.entityLineNum = [set intForColumn:@"entityLineNum"];
    senceEntity.entityRemoteIndex = [set intForColumn:@"entityRemoteIndex"];
    senceEntity.state = [set intForColumn:@"state"];
    senceEntity.arcPower = [set intForColumn:@"arcPower"];
    senceEntity.arcMode = [set intForColumn:@"arcMode"];
    senceEntity.arcTemp = [set intForColumn:@"arcTemp"];
    senceEntity.arcFan = [set intForColumn:@"arcFan"];
    senceEntity.arcFanMode = [set intForColumn:@"arcFanMode"];
    senceEntity.boxId = [set stringForColumn:@"boxId"];
    senceEntity.senceEntityIndex = [set intForColumn:@"senceEntityIndex"];
    return senceEntity;
}

@end
