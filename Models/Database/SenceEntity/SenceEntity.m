//
//  SenceEntity.m
//  Home
//
//  Created by 刘军林 on 14-8-13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SenceEntity.h"

@implementation SenceEntity

@synthesize tableid;
@synthesize senceIndex;
@synthesize entityId;

@synthesize entityLineNum;
@synthesize entityRemoteIndex;
@synthesize state;

@synthesize arcPower;
@synthesize arcMode;
@synthesize arcTemp;
@synthesize arcFan;
@synthesize arcFanMode;
@synthesize boxId;
@synthesize senceEntityIndex;

-(id) init
{
    self = [super init];
    if (self) {
        self.tableid = 0;
        self.senceIndex = 0;
        self.entityId = @"";
        self.entityLineNum = 0;
        self.entityRemoteIndex = 0;
        self.state = 0;
        self.arcPower = 0;
        self.arcMode = 0;
        self.arcTemp = 0;
        self.arcFan = 0;
        self.arcFanMode = 0;
        self.boxId = @"";
        self.senceEntityIndex = -1;
    }
    return self;
}

-(SenceEntity *) getSenceEntity:(FMResultSet *)set
{
    self.tableid = [set intForColumn:@"tableid"];
    self.senceIndex = [set intForColumn:@"senceIndex"];
    self.entityId = [set stringForColumn:@"entityId"];
    self.entityLineNum = [set intForColumn:@"entityLineNum"];
    self.entityRemoteIndex = [set intForColumn:@"entityRemoteIndex"];
    self.state = [set intForColumn:@"state"];
    self.arcPower = [set intForColumn:@"arcPower"];
    self.arcMode = [set intForColumn:@"arcMode"];
    self.arcTemp = [set intForColumn:@"arcTemp"];
    self.arcFan = [set intForColumn:@"arcFan"];
    self.arcFanMode = [set intForColumn:@"arcFanMode"];
    self.boxId = [set stringForColumn:@"boxId"];
    self.senceEntityIndex = [set intForColumn:@"senceEntityIndex"];
    return self;
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"tableid:%d  senceIndex:%d  entityId:%@  entityLineNum:%d  entityremoteIndex:%d  state:%d  arcPower:%d  arcMode:%d  arcTemp:%d  arcFan:%d  arcFanMode:%d  boxId:%@  senceEntityIndex:%d",self.tableid, self.senceIndex, self.entityId, self.entityLineNum, self.entityRemoteIndex, self.state, self.arcPower, self.arcMode, self.arcTemp, self.arcFan, self.arcFanMode, self.boxId, self.senceEntityIndex];
}

@end
