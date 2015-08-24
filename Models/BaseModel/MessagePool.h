//
//  MessagePool.h
//  Home
//
//  Created by 刘军林 on 14-8-22.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MessagePool;
@protocol MessagePoolDelegate <NSObject>

-(void) handleMessagePool:(MessagePool *)messagePool;

@end

@interface MessagePool : NSObject

@property (nonatomic, strong) NSString *entityId;
@property (assign) int state;
@property (assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) id<MessagePoolDelegate> delegate;

-(id) initEntityId:(NSString *)entity_id didState:(int )state didDelegate:(id<MessagePoolDelegate>)delegate;

-(id) initEntityId:(NSString *)entity_id itemsDelegate:(id<MessagePoolDelegate>)delegate;
@end
