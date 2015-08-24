//
//  EntityRemoteDao.m
//  Home
//
//  Created by 刘军林 on 14/11/7.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EntityRemoteDao.h"
#import "DBHelper.h"
#import "BaseModel.h"
#import "EntityRemote.h"
#import "Entity.h"

static EntityRemoteDao *shareEntityRemote = nil;

@implementation EntityRemoteDao

+(EntityRemoteDao *) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareEntityRemote) {
            shareEntityRemote = [[EntityRemoteDao alloc] init];
            [EntityRemoteDao createTable];
        }
    });
    return shareEntityRemote;
}

+(BOOL) createTable
{
    NSString *sql = @"CREATE TABLE if not exists entityRemote (tableid INTEGER PRIMARY KEY, entityId TEXT, brandType INTEGER, entityRemoteName TEXT, entityRemoteIcon INTEGER, entityRemoteHint TEXT, remoteBrandIndex INTEGER, remoteGroupIndex INTEGER,entityRemoteIndex INTEGER, arcPower INTEGER, arcMode INTEGER, arcTemp INTEGER, arcFan INTEGER, arcFanMode INTEGER, roomId TEXT)";
    return [shareEntityRemote executeUpdate:sql];
}

-(BOOL) deleteTable
{
    return 0;
}

-(BOOL) addEntityRemote:(EntityRemote *)entityRemote
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO entityRemote(entityId, brandType, entityRemoteName, entityRemoteIcon, entityRemoteHint, remoteBrandIndex, remoteGroupIndex, entityRemoteIndex, arcPower, arcMode, arcTemp, arcFan, arcFanMode, roomId) VALUES ('%@', %d, '%@', %d, '%@', %d, %d, %d, %d, %d, %d, %d, %d, '%@')",entityRemote.entityId, entityRemote.brandType, entityRemote.entityRemoteName, entityRemote.entityRemoteIcon, entityRemote.entityRemoteHint, entityRemote.remoteBrandIndex, entityRemote.remoteGroupIndex, entityRemote.entityRemoteIndex, entityRemote.arcPower, entityRemote.arcMode, entityRemote.arcTemp, entityRemote.arcFan, entityRemote.arcFanMode, entityRemote.roomId];
    return [self executeUpdate:sql];
}

-(BOOL) updateEntityRemote:(EntityRemote *)entityRemote
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE entityRemote SET entityRemoteName = '%@', entityRemoteIcon = %d, entityRemoteHint = '%@', arcPower = %d, arcMode = %d, arcTemp = %d, arcFan = %d, arcFanMode = %d, roomId = %@ WHERE entityId = '%@' AND entityRemoteIndex = %d AND brandType = %d", entityRemote.entityRemoteName, entityRemote.entityRemoteIcon, entityRemote.entityRemoteHint, entityRemote.arcPower, entityRemote.arcMode, entityRemote.arcTemp, entityRemote.arcFan, entityRemote.arcFanMode,entityRemote.roomId, entityRemote.entityId, entityRemote.entityRemoteIndex, entityRemote.brandType];
    return [self executeUpdate:sql];
}

-(BOOL) removeEntityRemote:(EntityRemote *)entityRemote
{
    NSString *sql = [NSString stringWithFormat:@"delete from entityRemote where entityId = '%@' AND entityRemoteIndex = %d",entityRemote.entityId,entityRemote.entityRemoteIndex];
    return [self executeUpdate:sql];
}

-(BOOL) removeEntityRemoteForEntity:(Entity *)entity
{
    NSString *sql = [NSString stringWithFormat:@"delete from entityRemote where entityId = '%@'",entity.entityID];
    return [self executeUpdate:sql];
}

-(NSMutableArray *) findByEntityRemote:(EntityRemote *)entityRemote
{
    NSString *sql = [NSString stringWithFormat:@"select * from entityRemote where entityId = '%@' AND entityRemoteIndex = %d AND brandType = %d",entityRemote.entityId, entityRemote.entityRemoteIndex, entityRemote.brandType];
    return [self executeQuery:sql];
}

-(NSMutableArray *) findByEntity:(Entity *)entity
{
    NSString *sql = [NSString stringWithFormat:@"select * from entityRemote where entityId = '%@'",entity.entityID];
    return [self executeQuery:sql];
}

-(BaseDao*) objectForSet:(FMResultSet *)set
{
    EntityRemote *entityRemote = [[EntityRemote alloc] init];
    entityRemote.entityId = [set stringForColumn:@"entityId"];
    entityRemote.brandType = [set intForColumn:@"brandType"];
    entityRemote.entityRemoteName = [set stringForColumn:@"entityRemoteName"];
    entityRemote.entityRemoteIcon = [set intForColumn:@"entityRemoteIcon"];
    entityRemote.entityRemoteHint = [set stringForColumn:@"entityRemoteHint"];
    entityRemote.remoteBrandIndex = [set intForColumn:@"remoteBrandIndex"];
    entityRemote.remoteGroupIndex = [set intForColumn:@"remoteGroupIndex"];
    entityRemote.entityRemoteIndex = [set intForColumn:@"entityRemoteIndex"];
    
    entityRemote.arcPower = [set intForColumn:@"arcPower"];
    entityRemote.arcMode = [set intForColumn:@"arcMode"];
    entityRemote.arcTemp = [set intForColumn:@"arcTemp"];
    entityRemote.arcFan = [set intForColumn:@"arcFan"];
    entityRemote.arcFanMode = [set intForColumn:@"arcFanMode"];
    
    entityRemote.roomId = [set stringForColumn:@"roomId"];
    
    return entityRemote;
}

@end
