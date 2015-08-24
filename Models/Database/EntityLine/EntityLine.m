//
//  EntityLine.m
//  Home
//
//  Created by 刘军林 on 14-9-12.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EntityLine.h"

@implementation EntityLine

@synthesize tableid;
@synthesize boxId;
@synthesize entityID;
@synthesize entityLineName;
@synthesize entityLineNum;
@synthesize state;
@synthesize icon;
@synthesize tempValue;
@synthesize enabled;

@synthesize entityType;
@synthesize roomId;

@synthesize entitySignal;

@synthesize switchState;
@synthesize isAnimation;

-(id) init
{
    if (self = [super init]) {
        self.tableid = 0;
        self.boxId = @"";
        self.entityID = @"";
        self.entityLineNum = @"";
        self.entityLineName = @"";
        self.state = 0;
        self.switchState = self.state;
        self.icon = 0;
        self.tempValue = 0;
        self.enabled = 0;
        self.entitySignal = @"";
        self.entityType = @"0";
        self.roomId = @"1";
    }
    return self;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"boxId:%@    entityID:%@     entityLineNum:%@    entityLineName:%@   state:%d, isAnimation:%d, roomId:%@, entityType:%@",self.boxId, self.entityID, self.entityLineNum, self.entityLineName, state, self.isAnimation, self.roomId, self.entityType];
}

@end
