//
//  EntityDao.h
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDao.h"

@class Entity;

@interface EntityDao : BaseDao

@property (strong, nonatomic) NSMutableArray *list;

/**
 *  单例方式实例化自身对象
 *
 *  @return 返回实例对象
 */
+(EntityDao *) shareInstance;

/**
 *  添加设备到数据库
 *
 *  @param Entity 设备
 *
 *  @return
 */
-(BOOL) addEntity:(Entity *)entity;

/**
 *  修改设备
 *
 *  @param entity 设备
 *
 *  @return
 */
-(BOOL) updateEntity:(Entity *)entity;

/**
 *  删除设备
 *
 *  @param entity 设备
 *
 *  @return
 */
-(BOOL) removeEntity:(Entity *)entity;

/**
 *  查询获取当前boxID下所有的设备
 *
 *  @return 设备列表
 */
-(NSMutableArray *) findAll;

/**
 *  根据条件字符串查询获取设备
 *
 *  @param Key 条件字符串
 *
 *  @return 设备列表
 */
-(NSMutableArray *) findByKey:(NSString *)Key;

/**
 *  查询获取设备的数据库版本
 *
 *  @param entity 设备
 *
 *  @return 数据库版本设备
 */
-(Entity *) findByEntity:(Entity *)entity;

/**
 *  查询返回当前boxID下的可联动设备
 *
 *  @return 联动设备列表
 */
-(NSMutableArray *) findIsLinkEntity;
@end
