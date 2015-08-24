//
//  EntityLink.m
//  Home
//
//  Created by 刘军林 on 14-8-28.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EntityLink.h"

@implementation EntityLink

@synthesize tableid;
@synthesize safeEntityId;
@synthesize entityId;
@synthesize entityLineNum;
@synthesize state;
@synthesize entityLinkIndex;

-(id) init
{
    if (self = [super init]) {
        self.tableid = 0;
        self.safeEntityId = @"";
        self.entityId = @"";
        self.entityLineNum = 0;
        self.state = 0;
        self.entityLinkIndex = 0;
    }
    return self;
}
@end
