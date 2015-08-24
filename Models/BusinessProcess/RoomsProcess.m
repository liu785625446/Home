//
//  RoomsProcess.m
//  Home
//
//  Created by 刘军林 on 15/5/28.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "RoomsProcess.h"
#import "RoomsDao.h"
#import "Interface.h"
#import "Rooms.h"

@implementation RoomsProcess

-(id) init
{
    if (self = [super init]) {
        _roomsDao = [RoomsDao shareInstance];
        lock = [[NSLock alloc] init];
    }
    return self;
}

-(void) synchronousRooms:(void (^)(NSMutableArray *))success didFail:(void (^)(void))fail
{
    NSString *msg = [NSString stringWithFormat:@"%@&%@",BOX_ID_VALUE, @"4"];
    [[Interface shareInterface:nil] writeFormatDataAction:@"60" didMsg:msg didCallBack:^(NSString *code) {
        printf("房间刷新\n");
        NSMutableArray *roomsList = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray *array = [code componentsSeparatedByString:@"&"];
        NSString *roomsStr = [array objectAtIndex:[array count]-1];
        NSArray *roomsArray = [roomsStr componentsSeparatedByString:@","];
        NSString *deleteRoomStr = @"";
        for (NSString *tempStr in roomsArray) {
            NSArray *roomItems = [tempStr componentsSeparatedByString:@"@"];
            if ([roomItems count] == 2) {
                Rooms *rooms = [[Rooms alloc] init];
                rooms.roomId = [roomItems objectAtIndex:0];
                rooms.roomName = [roomItems objectAtIndex:1];
                rooms.boxId = BOX_ID_VALUE;
                [roomsList addObject:rooms];
                
                NSMutableArray *storeList = [_roomsDao findAllRoomsForRoom:rooms];
                if ([storeList count] > 0) { //不变或者修改
                    Rooms *storeRoom = [storeList objectAtIndex:0];
                    if (![storeRoom.roomName isEqualToString:rooms.roomName]) { //修改
                        storeRoom.roomName = rooms.roomName;
                        [_roomsDao updateRooms:storeRoom];
                    }
                }else{ //添加
                    [_roomsDao addRooms:rooms];
                }
                
                if ([deleteRoomStr isEqualToString:@""]) {
                    deleteRoomStr = [NSString stringWithFormat:@"roomId != '%@'",rooms.roomId];
                }else {
                    deleteRoomStr = [NSString stringWithFormat:@"%@ AND roomId != '%@'",deleteRoomStr,rooms.roomId];
                }
            }
        }
        if (![deleteRoomStr isEqualToString:@""]) {
            NSMutableArray *deleteArray = [_roomsDao findByKey:deleteRoomStr];
            for (Rooms *rooms in deleteArray) {
                [_roomsDao deleteRooms:rooms];
            }
        }

        success(roomsList);
    }];
}

-(void) addRooms:(NSString *)roomName success:(CallBackBlock)success fail:(CallBackBlockErr)fail
{
    [[Interface shareInterface:nil] writeFormatDataAction:@"30" didMsg:roomName didCallBack:^(NSString *code) {
        if ([code isEqualToString:@"1"]) {
            fail(nil,nil);
        }else{
            success();
        }
    }];
}

-(void) deleteRooms:(NSString *)roomId success:(CallBackBlock)success fail:(CallBackBlockErr)fail
{
    [[Interface shareInterface:nil] writeFormatDataAction:@"32" didMsg:roomId didCallBack:^(NSString *code) {
        
        if ([code isEqualToString:@"1"]) {
            fail(nil,nil);
        }else{
            success();
        }
    }];
}

-(void) updateRooms:(Rooms *)room success:(CallBackBlock)success fail:(CallBackBlockErr)fail
{
    NSString *msg = [NSString stringWithFormat:@"%@&%@",room.roomId, room.roomName];
    [[Interface shareInterface:nil] writeFormatDataAction:@"31" didMsg:msg didCallBack:^(NSString *code) {
        if ([code isEqualToString:@"1"]) {
            fail(nil,nil);
        }else{
            success();
        }
    }];
}

-(NSMutableArray *) findAll
{
    return [_roomsDao findAll];
}

-(BOOL) deleteAll
{
    return [_roomsDao deleteAll];
}

@end
