//
//  Alarmphone.m
//  Home
//
//  Created by 刘军林 on 14-8-26.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "Alarmphone.h"
#import "FMDatabase.h"

@implementation Alarmphone

@synthesize contactName;
@synthesize contactNum;
@synthesize phoneIndex;
@synthesize boxId;

-(id) init
{
    if (self = [super init]) {
        contactName = @"";
        contactNum = @"";
        phoneIndex = 0;
        boxId = @"";
    }
    return self;
}
@end
