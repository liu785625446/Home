//
//  EntityLinkDao.h
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseDao.h"

@class Entity;
@class EntityLink;

@interface EntityLinkDao : BaseDao

@property (strong, nonatomic) NSMutableArray *list;

/**
 *  单例方式实例化自身对象
 *
 *  @return 返回实例对象
 */
+(EntityLinkDao *) shareInstance;

-(BOOL) createTable;
-(BOOL) deleteTable;

-(BOOL) addEntityLink:(EntityLink *)entityLink;
-(BOOL) removeByEntity:(EntityLink *)entityLink;

-(NSMutableArray *) findByEntity:(Entity *)entity;
@end
