//
//  Rooms.m
//  Home
//
//  Created by 刘军林 on 15/5/28.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "Rooms.h"

@implementation Rooms

@synthesize boxId;
@synthesize roomId;
@synthesize roomName;

@synthesize isOpen;
@synthesize currentStartRow;
@synthesize roomDeviceList;

-(id) init
{
    if (self = [super init]) {
        boxId = @"";
        roomId = @"";
        roomName = @"";
        isOpen = NO;
        
        currentStartRow = -1;
        roomDeviceList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Rooms: { \n roomId:%@  \n roomName:%@ \n } \n",self.roomId, self.roomName];
}

@end
