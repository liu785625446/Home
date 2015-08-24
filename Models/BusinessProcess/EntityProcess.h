//
//  ViewControllerProcess.h
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libkern/OSAtomic.h>
#import "Interface.h"

@class Entity;
@class EntityDao;
@class EntityLineProcess;
@class EntityRemoteProcess;
@class EntityLinkProcess;
@class SenceEntityProcess;

typedef void (^CallBackBlock) (void);

@interface EntityProcess : NSObject{
    
    NSLock *lock;
    
    NSLock *synLock;

    int synchronousNum;
    CallBackBlock synchronousSuccess;
}

@property (nonatomic, strong) NSMutableArray *device_list;
@property (nonatomic, strong) EntityDao *entityDao;

@property (nonatomic, strong) EntityLineProcess *entityLineProcess;
@property (nonatomic, strong) EntityRemoteProcess *entityRemoteProcess;
@property (nonatomic, strong) EntityLinkProcess *entityLinkProcess;
@property (nonatomic, strong) SenceEntityProcess *senceEntityProcess;

/**
 *  同步设备数据
 *
 *  @param success 成功block
 *  @param fail    失败block
 */
-(void) synchronousEntity:(void (^) (void))success didFail:(void (^) (void))fail;

//刷新设备状态
-(void) refreshDeviceBoradcastData;

//编辑多路设备
-(void) editDeviceLineMsg:(NSString *)msg success:(CallBackParamBlock)success fail:(CallBackBlockErr)fail;

//编辑设备
-(void) editDeviceMsg:(NSString *)msg success:(CallBackParamBlock)success  fail:(CallBackBlockErr)fail;

/**
 *  返回可以在主页控制的设备
 *
 *  @return 设备列表
 */
-(NSMutableArray*) findCanControlEntity;

-(BOOL) updateEntity:(Entity *)entity;

-(NSMutableArray *) findCanSetSenceEntity;
/**
 *  返回当前BOXID下所有设备
 *
 *  @return 设备列表
 */
-(NSMutableArray *)findAllEntity;

-(NSMutableArray *) findAPEntity;

-(NSMutableArray *)findIsLinkEntity;

/**
 *  删除设备
 *
 *  @param entity 需要删除的设备
 */
-(BOOL) removeEntity:(Entity *)entity;

/**
 *  查询当前设备数据库版本
 *
 *  @param entity 当前设备
 *
 *  @return 数据库版本
 */
-(Entity *)findEntityForEntity:(Entity *)entity;

/**
 *  通过字符串添加设备
 *
 *  @param msg @@@@@@@模式，十个
 *
 *  @return 
 */
-(BOOL) addEntityForStr:(NSString *)msg;

@end
