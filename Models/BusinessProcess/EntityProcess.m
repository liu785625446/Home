//
//  ViewControllerProcess.m
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EntityProcess.h"
#import "Interface.h"
#import "EntityDao.h"
#import "Entity.h"
#import "config.h"
#import "EntityRemoteProcess.h"
#import "EntityLineProcess.h"
#import "EntityLinkProcess.h"
#import "EntityRemote.h"
#import "SenceEntityProcess.h"
#import "DeviceResource.h"

#define ENTITY 1

@implementation EntityProcess

@synthesize device_list;

-(id) init
{
    if (self = [super init]) {
        
        lock = [[NSLock alloc] init];
        synLock = [[NSLock alloc] init];
        
        device_list = [[NSMutableArray alloc] initWithCapacity:0];
        _entityDao = [EntityDao shareInstance];
        _entityLineProcess = [[EntityLineProcess alloc] init];
        _entityRemoteProcess = [[EntityRemoteProcess alloc] init];
        _entityLinkProcess = [[EntityLinkProcess alloc] init];
        _senceEntityProcess = [[SenceEntityProcess alloc] init];
    }
    return self;
}

-(void) synchronousEntity:(void (^)(void))success didFail:(void (^)(void))fail
{
    synchronousNum = 3;
    synchronousSuccess = success;
//    同步设备数据
    NSString *msg = [NSString stringWithFormat:@"%@&%d",BOX_ID_VALUE,ENTITY];
    NSMutableArray *entityLineArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *infraredArray = [[NSMutableArray alloc] initWithCapacity:0];
    [[Interface shareInterface:nil] writeFormatDataAction:@"60" didMsg:msg didCallBack:^(NSString *code){
        
        if (code) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *array = [code componentsSeparatedByString:@"&"];
                if ([array count] == 3) {
                    NSString *deviceVersion = [array objectAtIndex:2];
                    NSArray *deviceVersionArray = [deviceVersion componentsSeparatedByString:@","];
                    
                    NSString *deleteStr = @"";
                    NSMutableArray *updateArray = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSString *device in deviceVersionArray) {
                        NSArray *tempArr = [device componentsSeparatedByString:@"@"];
                        if ([tempArr count] == 2) {
                            NSString *entityID = [tempArr objectAtIndex:0];
                            NSString *syncNum = [tempArr objectAtIndex:1];
                            
                            //                        删除条件
                            if ([deleteStr isEqualToString:@""]) {
                                deleteStr = [NSString stringWithFormat:@"entityID != '%@'",entityID];
                            }else {
                                deleteStr = [NSString stringWithFormat:@"%@ AND entityID != '%@'",deleteStr,entityID];
                            }
                            
                            //                        添加修改条件
                            NSString *updateStr = [NSString stringWithFormat:@"entityID = '%@' AND syncNum = %@",entityID,syncNum];
                            if ([[_entityDao findByKey:updateStr] count] == 0) {
                                [updateArray addObject:entityID];
                            }
                        }
                    }
                    
                    //                删除设备
                    NSMutableArray *deleteArray = [_entityDao findByKey:deleteStr];
                    for (Entity *entity in deleteArray) {
                        [self removeEntity:entity];
                    }
                    //                添加修改设备
                    NSString *addStr = @"";
                    for (int i=0 ; i<[updateArray count] ; i++) {

                        if ([addStr isEqualToString:@""]) {
                            addStr = [updateArray objectAtIndex:i];
                        }else{
                            addStr = [NSString stringWithFormat:@"%@&%@",addStr,[updateArray objectAtIndex:i]];
                        }
                        //                    分页天假修改数据 10条一页
                        if ((i/10 > 0 && i%10 == 0) || i == [updateArray count] - 1) {
                            
                            [lock lock];
                            [[Interface shareInterface:nil] writeFormatDataAction:@"61" didMsg:addStr didCallBack:^(NSString *code){
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        if (code) {
                                            NSArray *array = [code componentsSeparatedByString:@","];
                                            if ([array count] > 1) {
                                                for (NSString *entityStr in array) {
                                                    NSArray *entityArray = [entityStr componentsSeparatedByString:@"@"];
                                                    if ([entityArray count] == 10) {
                                                        Entity *entity = [[Entity alloc] init];
                                                        entity.entityID = [entityArray objectAtIndex:0];
                                                        entity.entityName = [entityArray objectAtIndex:1];
                                                        entity.entityType = [entityArray objectAtIndex:2];
                                                        entity.icon = [[entityArray objectAtIndex:3] intValue];
                                                        entity.link = [[entityArray objectAtIndex:4] intValue];
                                                        entity.power = [[entityArray objectAtIndex:5] intValue];
                                                        entity.state = [[entityArray objectAtIndex:6] intValue];
                                                        entity.delState = [[entityArray objectAtIndex:7] intValue];
                                                        entity.roomId = [entityArray objectAtIndex:8];
                                                        entity.syncNum = [[entityArray objectAtIndex:9] intValue];
                                                        
                                                        if ([entity.entityName isEqualToString:@""]) {
                                                            entity.entityName = [DeviceResource getDeviceDefaultName:[entity.entityType intValue]];
                                                        }
                                                        
                                                        if (entity.icon == 0) {
                                                            entity.icon = [[DeviceResource getDeviceDefaultImg:[entity.entityType intValue]] intValue];
                                                        }
                                                        
                                                        NSLog(@"p_addEntityOtherAttribute_____BEGIN_____%@",entity.entityID);
                                                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                            [self p_addEntityOtherAttribute:entity];
                                                        });
                                                        
//                                                        if ([_entityDao findByEntity:entity]) {
//                                                            [_entityDao updateEntity:entity];
//                                                        }else{
//                                                            [_entityDao addEntity:entity];
//                                                        }
                                                        
                                                        //                                        添加多路设备路
                                                        if ([entity.entityType intValue] == PANEL_SWITCH_3  || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
                                                            [entityLineArray addObject:entity.entityID];
                                                        }
                                                        
                                                        //                                        添加红外设备id
                                                        if ([entity.entityType intValue] == REMOTE_INFRARED) {
                                                            [infraredArray addObject:entity.entityID];
                                                        }
                                                    }
                                                }
                                                [lock unlock];
                                            }else{
                                                [lock unlock];
                                            }
                                        }else{
                                            [lock unlock];
                                        }
                                    });
                            }];
                            [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
                            [lock unlock];
                            addStr = @"";
                        }
                    }
//                    同步多路设备
                    [_entityLineProcess synchronousEntityLine:entityLineArray didSuccess:^{
                        [self synchronousNumHandle];
                    }didFail:^{
                        
                    }];
                    
//                    同步红外设备
                    [_entityRemoteProcess synchronousEntityRemote:infraredArray didSuccess:^{
                        [self synchronousNumHandle];
                    }didFail:^{
                        
                    }];
                    [self synchronousNumHandle];
                }else{
                    fail();
                }
            });
        }else {
            fail();
        }
    }];
}

//获取设备其他属性
-(void)p_addEntityOtherAttribute:(Entity *)entity
{
    [synLock lock];
    [[Interface shareInterface:nil] writeFormatDataAction:@"35" didMsg:entity.entityID didCallBack:^(NSString *code) {
        NSArray *array = [code componentsSeparatedByString:@"&"];
        if ([array count] == 7) {
            entity.alerterVoice = [NSString stringWithFormat:@"%@",[array objectAtIndex:2]];
            entity.alerterVoiceNo = [NSString stringWithFormat:@"%@",[array objectAtIndex:3]];
            entity.userCustomContent = [NSString stringWithFormat:@"%@",[array objectAtIndex:4]];
            entity.attributeMark = [NSString stringWithFormat:@"%@",[array objectAtIndex:5]];
            entity.deviceRemark = [NSString stringWithFormat:@"%@",[array objectAtIndex:6]];
        }
        if ([_entityDao findByEntity:entity]) {
            [_entityDao updateEntity:entity];
        }else {
            [_entityDao addEntity:entity];
        }
        NSLog(@"p_addEntityOtherAttribute______END___%@",entity.entityID);
        [synLock unlock];
    }];
    [synLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

-(BOOL) removeEntity:(Entity *)entity
{
    [_entityDao removeEntity:entity];

//    删除情景设备下的设备
//    [_senceEntityProcess removeSenceEntityForBaseModel:entity];
    
    //                        删除设备下的多路设备
    if ([entity.entityType intValue] == PANEL_SWITCH_3  || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
            [_entityLineProcess removeEntityLIneForEntity:entity];
    }

    //                        删除设备下的红外电器设备
    if ([entity.entityType intValue] == REMOTE_INFRARED) {
        [_entityRemoteProcess removeEntityRemoteForEntity:entity];
    }
    
    if ([entity.entityType intValue] == MAGNETIC || [entity.entityType intValue] == INFRARED_PROBE || [entity.entityType intValue] == SMKEN) {
        [_entityLinkProcess synchronousEntityLink:entity didSuccess:^{
            
        }didFail:^{
            
        }];
    }
    return YES;
}

-(void) synchronousNumHandle
{
    synchronousNum --;
    if (synchronousNum == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            synchronousSuccess();
        });
    }
}

-(void) refreshDeviceBoradcastData
{
    [[Interface shareInterface:nil] writeFormatDataAction:@"7"
                                                   didMsg:@"0"
                                              didCallBack:^(NSString *code){
                                                   NSLog(@"设备广播数据刷新:%@",code);
                                               }];
}

-(void) editDeviceLineMsg:(NSString *)msg success:(CallBackParamBlock)success fail:(CallBackBlockErr)fail
{
    [[Interface shareInterface:nil] writeFormatDataAction:@"5" didMsg:msg didCallBack:^(NSString *code) {
        if (![code isEqualToString:@"1"]) {
            NSArray *tempArray = [code componentsSeparatedByString:@","];
            if ([tempArray count] >= 3) {
                NSString *boxId = [tempArray objectAtIndex:0];
                NSString *entityStr = [tempArray objectAtIndex:1];
                NSString *entityLineStr = [tempArray objectAtIndex:2];
                
                if ([self addEntityForStr:[NSString stringWithFormat:@"%@@%@",boxId,entityStr]]) {
                    if([_entityLineProcess addEntityLineForStr:entityLineStr]) {
                        success(@"");
                    }else{
                        fail(nil,nil);
                    }
                }else{
                    fail(nil,nil);
                }
            }else{
                fail(nil,nil);
            }
        }else{
            fail(nil,nil);
        }
    }];
}

-(void) editDeviceMsg:(NSString *)msg success:(CallBackParamBlock)success fail:(CallBackBlockErr)fail
{
    [[Interface shareInterface:nil] writeFormatDataAction:@"4" didMsg:msg didCallBack:^(NSString *code) {
        if (code) {
            if ([self addEntityForStr:code]) {
                success(@"");
            }else {
                fail(nil,nil);
            }
        }else{
            fail(nil,nil);
        }
    }];
}

-(BOOL) updateEntity:(Entity *)entity
{
    return [_entityDao updateEntity:entity];
}

-(Entity *)findEntityForEntity:(Entity *)entity
{
    return [_entityDao findByEntity:entity];
}

/**
 *  返回可以在主页控制的设备
 *
 *  @return 设备列表
 */
-(NSMutableArray*) findCanControlEntity
{
    NSMutableArray *entityArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tempArray = [_entityDao findAll];
    
    for (Entity *entity in tempArray) {
        if ([entity.entityType intValue] == PANEL_SWITCH_3  || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
            entity.panelList = [_entityLineProcess findEntityLineForEntity:entity];
            [entityArray addObjectsFromArray:entity.panelList];
            
        }else if ([entity.entityType intValue] == CURTAIN_SWITCH || [entity.entityType intValue] == SOCKET_SWITCH || [entity.entityType intValue] == MAGNETIC || [entity.entityType intValue] == INFRARED_PROBE || [entity.entityType intValue] == SMKEN){
            
            [entityArray addObject:entity];

        }else if ([entity.entityType intValue] == REMOTE_INFRARED) {
            [entityArray addObjectsFromArray:[_entityRemoteProcess findRemoteForEntity:entity]];
        }
    }
    return entityArray;
}

-(NSMutableArray *) findAPEntity
{
    NSMutableArray *entityArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tempArray = [_entityDao findAll];
    
    for (Entity *entity in tempArray) {
        if ([entity.entityType intValue] == 700) {
            [entityArray addObject:entity];
        }
    }
    return entityArray;
}

-(NSMutableArray *)findIsLinkEntity
{
   return [_entityDao findIsLinkEntity];
}

/**
 *  返回可以设置情景的设备
 *
 *  @return 设备列表
 */
-(NSMutableArray *) findCanSetSenceEntity
{
    NSMutableArray *entityArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tempArray = [_entityDao findAll];
    
    for (Entity *entity in tempArray) {
        if ([entity.entityType intValue] == PANEL_SWITCH_3  || [entity.entityType intValue] == PANEL_SWITCH_2 || [entity.entityType intValue] == PANEL_SWITCH_1) {
            [entityArray addObjectsFromArray:[_entityLineProcess findEntityLineForEntity:entity]];
        }else if ([entity.entityType intValue] == CURTAIN_SWITCH || [entity.entityType intValue] == SOCKET_SWITCH || [entity.entityType intValue] == MAGNETIC || [entity.entityType intValue] == INFRARED_PROBE || [entity.entityType intValue] == SMKEN){
            [entityArray addObject:entity];
        }else if ([entity.entityType intValue] == REMOTE_INFRARED) {
            
            NSMutableArray *array = [_entityRemoteProcess findRemoteForEntity:entity];
            for (EntityRemote *entityRemote in array) {
                if (entityRemote.brandType == 1) {
                    [entityArray addObject:entityRemote];
                }
            }
        }
    }
    return entityArray;
}

-(NSMutableArray *)findAllEntity
{
    return [_entityDao findAll];
}

-(BOOL) addEntityForStr:(NSString *)msg
{
    Entity *entity = [[Entity alloc] init];
    
    NSArray *tempArray = [msg componentsSeparatedByString:@"@"];
    if ([tempArray count] == 11) {
        entity.boxId = [tempArray objectAtIndex:0];
        entity.entityID = [tempArray objectAtIndex:1];
        entity.entityName = [tempArray objectAtIndex:2];
        entity.entityType = [tempArray objectAtIndex:3];
        entity.icon = [[tempArray objectAtIndex:4] intValue];
        entity.link = [[tempArray objectAtIndex:5] intValue];
        entity.power = [[tempArray objectAtIndex:6] intValue];
        entity.state = [[tempArray objectAtIndex:7] intValue];
        entity.delState = [[tempArray objectAtIndex:8] intValue];
        entity.roomId = [tempArray objectAtIndex:9];
        entity.syncNum = [[tempArray objectAtIndex:10] intValue];
        
        if ([entity.entityName isEqualToString:@""]) {
            entity.entityName = [DeviceResource getDeviceDefaultName:[entity.entityType intValue]];
        }
        
        if (entity.icon == 0) {
            entity.icon = [[DeviceResource getDeviceDefaultImg:[entity.entityType intValue]] intValue];
        }
        
        if ([_entityDao findByEntity:entity]) {
            [_entityDao updateEntity:entity];
        }else{
            [_entityDao updateEntity:entity];
        }
        return YES;
    }
    return NO;
}

@end
