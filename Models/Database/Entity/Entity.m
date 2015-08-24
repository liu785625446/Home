//
//  Entity.m
//  Home
//
//  Created by 刘军林 on 14-7-16.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "Entity.h"

@implementation Entity

@synthesize tableid;
@synthesize boxId;
@synthesize entityID;
@synthesize entityName;
@synthesize state;
@synthesize power;
@synthesize link;
@synthesize icon;
@synthesize entityType;
@synthesize delState;
@synthesize syncNum;
@synthesize roomId;

@synthesize entitySignal;

@synthesize alerterVoice;
@synthesize alerterVoiceNo;
@synthesize userCustomContent;
@synthesize attributeMark;
@synthesize deviceRemark;

//extern
@synthesize switchState;
@synthesize isLeftAnimation;
@synthesize isMiddleAnimation;
@synthesize isRightAnimation;
@synthesize isShowPanelList;
@synthesize panelList;

-(id) init
{
    self = [super init];
    if (self) {
        tableid = 0;
        boxId = @"";
        entityID = @"";
        entityName = @"";
        state = -1;
        power = 0;
        link = 0;
        icon = 0;
        entityType = @"";
        delState = 0;
        syncNum = 0;
        switchState = 0;
        entitySignal = @"";
        roomId = @"";
        
        alerterVoice = @"";
        alerterVoiceNo = @"";
        userCustomContent = @"";
        attributeMark = @"";
        deviceRemark = @"";
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"\n Entity: \n { boxId = %@ \n entityID = %@ \n entityName = %@ \n state = %d \n power = %d \n link = %d \n icon = %d \n entityType = %@ \n delState = %d \n syncNum = %d \n switchState = %d \n entitySignal = %@ \n roomId = %@ \n  alerterVoice = %@ \n alerterVoice = %@ \n userCustomContent = %@\n attributeMark = %@\n deviceRemark = %@\n }\n ", self.boxId, self.entityID, self.entityName, self.state, self.power, self.link, self.icon, self.entityType, self.delState, self.syncNum, self.switchState, self.entitySignal, self.roomId, self.alerterVoice, self.alerterVoiceNo, self.userCustomContent, self.attributeMark, self.deviceRemark];
}

@end
