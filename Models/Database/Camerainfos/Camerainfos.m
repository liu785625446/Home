//
//  Camerainfos.m
//  Home
//
//  Created by 刘军林 on 14-9-4.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "Camerainfos.h"
#import "FMDatabase.h"

@implementation Camerainfos

@synthesize cameraIndex;
@synthesize cameraNum;
@synthesize cameraState;
@synthesize cameraName;
@synthesize wifiName;
@synthesize wifiPass;
@synthesize boxId;
@synthesize syncNum;
@synthesize roomId;

-(id) init
{
    if (self = [super init]) {
        self.cameraIndex = 0;
        self.cameraNum = @"";
        self.cameraState = 0;
        self.cameraName = @"";
        self.wifiName = @"";
        self.wifiPass = @"";
        self.boxId = @"";
        self.syncNum = 0;
        self.roomId = @"";
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"cameraIndex:%d   cameraNum:%@   cameraState:%d    cameraName:%@    wifiName:%@    wifiPass:%@    boxId:%@", self.cameraIndex, self.cameraNum, self.cameraState, self.cameraName, self.wifiName, self.wifiPass, self.boxId];
}

@end
