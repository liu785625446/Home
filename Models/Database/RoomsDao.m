//
//  RoomsDao.m
//  Home
//
//  Created by 刘军林 on 15/5/28.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "RoomsDao.h"
#import "Rooms.h"
#import "FMDatabase.h"

static RoomsDao *shareRoomsDao = nil;

@implementation RoomsDao

+(RoomsDao *) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareRoomsDao) {
            shareRoomsDao = [[RoomsDao alloc] init];
            [RoomsDao createTable];
        }
    });
    return shareRoomsDao;
}

+(BOOL) createTable
{
    NSString *sql = @"CREATE TABLE if not exists rooms (roomId TEXT, roomName TEXT, boxId TEXT)";
    return [shareRoomsDao executeUpdate:sql];
}

-(BOOL) addRooms:(Rooms *)room
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO rooms (roomId, roomName, boxId) VALUES ('%@', '%@', '%@')",room.roomId, room.roomName, BOX_ID_VALUE];
    return [self executeUpdate:sql];
}

-(BOOL) updateRooms:(Rooms *)room
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE rooms SET roomId = '%@', roomName = '%@', boxId = '%@' WHERE boxId = '%@' AND roomId = '%@'",room.roomId, room.roomName, room.boxId, room.boxId, room.roomId];
    return [self executeUpdate:sql];
}

-(NSMutableArray *) findAll
{
    NSString *sql = [NSString stringWithFormat:@"select * from rooms where boxId = '%@'", BOX_ID_VALUE];
    return [self executeQuery:sql];
}

-(BOOL) deleteAll
{
    NSString *sql = [NSString stringWithFormat:@"delete from rooms where boxId = '%@'",BOX_ID_VALUE];
    return [self executeUpdate:sql];
}

-(NSMutableArray *) findAllRoomsForRoom:(Rooms *)rooms
{
    NSString *sql = [NSString stringWithFormat:@"select * from rooms where boxId = '%@' AND roomId = '%@'", BOX_ID_VALUE,rooms.roomId];
    return [self executeQuery:sql];
}

-(NSMutableArray *) findByKey:(NSString *)key
{
    NSString *sql = @"";
    if ([key isEqualToString:@""]) {
        sql = [NSString stringWithFormat:@"select * from rooms where boxId = '%@'", BOX_ID_VALUE];
    }else{
        sql = [NSString stringWithFormat:@"select * from rooms where %@ AND boxId = '%@'",key, BOX_ID_VALUE];
    }
    return [self executeQuery:sql];
}

-(BOOL) deleteRooms:(Rooms *)room
{
    NSString *sql = [NSString stringWithFormat:@"delete from rooms where boxId = '%@' AND roomId = '%@'",BOX_ID_VALUE, room.roomId];
    return [self executeUpdate:sql];
}

-(BaseModel *) objectForSet:(FMResultSet *)set
{
    Rooms *room = [[Rooms alloc] init];
    room.roomId = [set stringForColumn:@"roomId"];
    room.boxId = [set stringForColumn:@"boxId"];
    room.roomName = [set stringForColumn:@"roomName"];
    
    return room;
}

@end
