//
//  EntityLineProcess.h
//  Home
//
//  Created by 刘军林 on 14/11/11.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EntityLineDao;
@class Entity;
@class SenceEntityProcess;
@class EntityLine;

@interface EntityLineProcess : NSObject

@property (nonatomic, strong) EntityLineDao *entityLineDao;
@property (nonatomic, strong) SenceEntityProcess *senceEntityProcess;
/**
 *  同步多个设备的多路设备
 *
 *  @param array   设备ID数组
 *  @param success 同步成功block
 *  @param fail    失败block
 *
 *  @return
 */
-(int) synchronousEntityLine:(NSMutableArray *)array didSuccess:(void (^) (void))success didFail:(void (^) (void))fail;

-(BOOL) updateEntityLine:(EntityLine *)entityLine;
/**
 *  返回设备多路
 *
 *  @param entity 多路设备
 *
 *  @return 设备多路数组
 */
-(NSMutableArray *) findEntityLineForEntity:(Entity *)entity;
-(BOOL) addEntityLineForStr:(NSString *)msg;
-(void) removeEntityLIneForEntity:(Entity *)entity;
@end
