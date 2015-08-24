//
//  RoomsProcess.h
//  Home
//
//  Created by 刘军林 on 15/5/28.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Interface.h"

@class RoomsDao;
@class Rooms;

@interface RoomsProcess : NSObject
{
    NSLock *lock;
}

@property (nonatomic, strong) RoomsDao *roomsDao;

-(void) synchronousRooms:(void (^) (NSMutableArray *))success didFail:(void (^)(void))fail;

-(void) addRooms:(NSString *)roomName success:(CallBackBlock)success fail:(CallBackBlockErr)fail;

-(void) deleteRooms:(NSString *)roomId success:(CallBackBlock)success fail:(CallBackBlockErr)fail;

-(void) updateRooms:(Rooms *)room success:(CallBackBlock)success fail:(CallBackBlockErr)fail;

-(NSMutableArray *) findAll;

-(BOOL) deleteAll;

@end
