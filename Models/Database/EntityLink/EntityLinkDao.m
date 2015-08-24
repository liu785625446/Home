//
//  EntityLinkDao.m
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EntityLinkDao.h"
#import "DBHelper.h"
#import "BaseModel.h"
#import "EntityLink.h"
#import "Entity.h"

static EntityLinkDao *shareEntityLinkDao = nil;

@implementation EntityLinkDao
+(EntityLinkDao *) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareEntityLinkDao) {
            shareEntityLinkDao = [[EntityLinkDao alloc] init];
            [EntityLinkDao createTable];
        }
    });
    return shareEntityLinkDao;
}

+(int) createTable
{
    NSString *sql = @"CREATE TABLE if not exists entityLink (tableid INTEGER PRIMARY KEY, safeEntityId TEXT, entityId TEXT, entityLineNum INTEGER,  state INTEGER, entityLinkIndex INTEGER)";
    return [shareEntityLinkDao executeUpdate:sql];
}

-(BOOL) removeByEntity:(Entity *)entity
{
    NSString *sql = [NSString stringWithFormat:@"delete from entityLink where safeEntityId = '%@'",entity.entityID];
    return [self executeUpdate:sql];
}


-(BOOL) addEntityLink:(EntityLink *)entityLink
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO entityLink(safeEntityId, entityId, entityLineNum, state, entityLinkIndex) VALUES ('%@', '%@', %d, %d, %d)",entityLink.safeEntityId, entityLink.entityId, entityLink.entityLineNum,entityLink.state, entityLink.entityLinkIndex];
    return [self executeUpdate:sql];
}

-(NSMutableArray *) findByEntity:(Entity *)entity
{
    NSString *sql = [NSString stringWithFormat:@"select * from entityLink where safeEntityId = '%@'",entity.entityID];
    return [self executeQuery: sql];
}

-(BaseModel *) objectForSet:(FMResultSet *)set
{
    EntityLink *entityLink = [[EntityLink alloc] init];
    entityLink.safeEntityId = [set stringForColumn:@"safeEntityId"];
    entityLink.entityId = [set stringForColumn:@"entityId"];
    entityLink.entityLineNum = [set intForColumn:@"entityLineNum"];
    entityLink.state = [set intForColumn:@"state"];
    entityLink.entityLinkIndex = [set intForColumn:@"entityLinkIndex"];
    return entityLink;
}

@end
