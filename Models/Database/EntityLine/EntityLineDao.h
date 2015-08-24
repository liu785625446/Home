//
//  EntityLineDao.h
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseDao.h"

@class Entity;
@class EntityLine;

@interface EntityLineDao : BaseDao

@property (strong, nonatomic) NSMutableArray *list;

/**
 *  单例方式实例化自身对象
 *
 *  @return 返回实例对象
 */
+(EntityLineDao *) shareInstance;

-(BOOL) createTable;
-(BOOL) deleteTable;

-(BOOL) addEntityLine:(EntityLine *)entityLine;
-(BOOL) updateEntityLine:(EntityLine *)entityLine;
-(BOOL) removeEntityLine:(EntityLine *) entityLine;
-(NSMutableArray *) findAll;
-(NSMutableArray *) findById:(NSString *)Id;
-(BOOL) removeEntityLineForEntity:(Entity *)entity;
-(NSMutableArray *) findByEntity:(Entity *)entity;
-(NSMutableArray *) findByEntityLine:(EntityLine *)entityLine;
@end
