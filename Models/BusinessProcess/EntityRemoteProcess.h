//
//  EntityRemoteProcess.h
//  Home
//
//  Created by 刘军林 on 14/11/11.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Interface.h"

@class Entity;
@class EntityRemoteDao;
@class EntityRemote;
@class SenceEntityProcess;

@interface EntityRemoteProcess : NSObject

@property (nonatomic, strong) EntityRemoteDao *entityRemoteDao;
@property (nonatomic, strong) SenceEntityProcess *senceEntityProcess;

/**
 *  同步多个设备的红外
 *
 *  @param array   需要同步的设备ID数组
 *  @param success 成功block
 *  @param fail    失败block
 *
 *  @return
 */
-(int) synchronousEntityRemote:(NSMutableArray *)array didSuccess:(void (^) (void))success didFail:(void (^) (void))fail;

/**
 *  返回红外设备的移动设备
 *
 *  @param entity 设备
 *
 *  @return 移动设备数组
 */
-(NSMutableArray *)findRemoteForEntity:(Entity *)entity;

-(void) editEntityRemoteMsg:(NSString *)msg success:(CallBackParamBlock)success fail:(CallBackBlockErr)fail;

-(EntityRemote *) findRemoteForEntityRemote:(EntityRemote *)entityRemote;
-(void) updateEntityRemote:(EntityRemote *)entityRemote;

-(void) removeEntityRemote:(EntityRemote *)entityRemote;
-(void) removeEntityRemoteForEntity:(Entity *)entity;
-(void) addEntityRemote:(NSString *)msg;
@end
