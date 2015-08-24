//
//  MessagePool.m
//  Home
//
//  Created by 刘军林 on 14-8-22.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MessagePool.h"

@implementation MessagePool

-(id) initEntityId:(NSString *)entity_id didState:(int )state didDelegate:(id<MessagePoolDelegate>)delegate
{
    if (self = [super init]) {
        _entityId = entity_id;
        _state = state;
        _timeInterval = [[NSDate date] timeIntervalSince1970];
        _delegate = delegate;
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return self;
}

-(id) initEntityId:(NSString *)entity_id itemsDelegate:(id<MessagePoolDelegate>)delegate
{
    if (self = [super init]) {
        _entityId = entity_id;
        _timeInterval = [[NSDate date] timeIntervalSince1970];
        _delegate = delegate;
        _timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return self;
}

-(void) timerAction
{
    [_delegate handleMessagePool:self];
}

@end
