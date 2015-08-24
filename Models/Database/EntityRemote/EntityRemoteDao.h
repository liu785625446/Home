//
//  EntityRemoteDao.h
//  Home
//
//  Created by 刘军林 on 14/11/7.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseDao.h"

@class EntityRemote;
@class Entity;

@interface EntityRemoteDao : BaseDao

/**
 *  单例方式实例化自身对象
 *
 *  @return 返回实例对象
 */
+(EntityRemoteDao *) shareInstance;

-(BOOL) createTable;
-(BOOL)  deleteTable;

-(BOOL) addEntityRemote:(EntityRemote *)entityRemote;
-(BOOL) updateEntityRemote:(EntityRemote *)entityRemote;
-(BOOL) removeEntityRemote:(EntityRemote *)entityRemote;
-(NSMutableArray *) findAll;
-(NSMutableArray *) findByKey:(NSString *)Key;
-(NSMutableArray *) findByEntityRemote:(EntityRemote *)entityRemote;
-(NSMutableArray *) findByEntity:(Entity *)entity;

-(BOOL) removeEntityRemoteForEntity:(Entity *)entity;
@end
