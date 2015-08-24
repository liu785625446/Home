//
//  EntityRemote.m
//  Home
//
//  Created by 刘军林 on 14-7-30.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EntityRemote.h"

@implementation EntityRemote

@synthesize tableid;
@synthesize entityId;
@synthesize brandType;
@synthesize entityRemoteName;
@synthesize entityRemoteIcon;
@synthesize entityRemoteHint;
@synthesize remoteBrandIndex;
@synthesize remoteGroupIndex;
@synthesize entityRemoteIndex;

@synthesize arcFan;
@synthesize arcMode;
@synthesize arcPower;
@synthesize arcTemp;
@synthesize arcFanMode;

@synthesize roomId;

-(id) init
{
    self = [super init];
    if (self) {
        tableid = 0;
        entityId = @"";
        brandType = 0;
        entityRemoteName = @"";
        entityRemoteIcon = 0;
        entityRemoteHint = 0;
        remoteGroupIndex = 0;
        remoteBrandIndex = 0;
        entityRemoteIndex = 0;
        
        arcTemp = 26;
        arcPower = 0;
        arcMode = 0;
        arcFan = 0;
        arcFanMode = 0;
        
        roomId = @"1";
    }
    return self;
}
@end
