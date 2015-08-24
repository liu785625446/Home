//
//  EntityProcess.h
//  Home
//
//  Created by 刘军林 on 14/11/11.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Entity;
@class EntityLinkDao;

@interface EntityLinkProcess : NSObject

@property (nonatomic, strong) EntityLinkDao *entityLinkDao;

/**
 *  同步设备联动设备
 *
 *  @param entity 联动设备
 *  @param success 成功block
 *  @param fail    失败block
 */
-(void) synchronousEntityLink:(Entity *)entity didSuccess:(void (^)(void))success didFail:(void (^)(void))fail;

-(void) addEntityLinkForStr:(NSString *)msg;

-(NSMutableArray *) findEntityLinkForEntity:(Entity *)entity;
@end
