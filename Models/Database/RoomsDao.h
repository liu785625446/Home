//
//  RoomsDao.h
//  Home
//
//  Created by 刘军林 on 15/5/28.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "BaseDao.h"

@class Rooms;

@interface RoomsDao : BaseDao

+(RoomsDao *) shareInstance;

-(BOOL) addRooms:(Rooms *)room;

-(BOOL) updateRooms:(Rooms *)room;

-(NSMutableArray *) findAll;
-(NSMutableArray *) findAllRoomsForRoom:(Rooms *)rooms;
-(NSMutableArray *) findByKey:(NSString *)key;
-(BOOL) deleteAll;

-(BOOL) deleteRooms:(Rooms *)room;

@end
