//
//  AlarmInfos.m
//  Home
//
//  Created by 刘军林 on 14-10-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AlarmInfos.h"
#import "FMDatabase.h"

@implementation AlarmInfos

@synthesize tableid;
@synthesize entityId;
@synthesize entityName;
@synthesize entityIcon;
@synthesize entityType;
@synthesize alarmTime;
@synthesize state;
@synthesize readState;
@synthesize boxId;
@synthesize alarmIndex;

-(id) init
{
    if (self = [super init]) {
        tableid = 0;
        entityId = @"";
        entityName = @"";
        entityIcon = 0;
        entityType = @"";
        alarmTime = 0;
        state = 0;
        readState = 0;
        boxId = @"";
    }
    return self;
}
@end
