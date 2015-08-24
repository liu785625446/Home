//
//  EntityRemoteProcess.m
//  Home
//
//  Created by 刘军林 on 14/11/11.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EntityRemoteProcess.h"
#import "EntityRemote.h"
#import "EntityRemoteDao.h"
#import "Interface.h"
#import "SenceEntityProcess.h"
#import "EntityProcess.h"
#import "Entity.h"
#import "DeviceResource.h"

@implementation EntityRemoteProcess

-(id) init
{
    if (self = [super init]) {
        _entityRemoteDao = [EntityRemoteDao shareInstance];
        _senceEntityProcess = [[SenceEntityProcess alloc] init];
    }
    return self;
}

-(int) synchronousEntityRemote:(NSMutableArray *)array didSuccess:(void (^)(void))success didFail:(void (^)(void))fail
{
    NSLog(@"Array:%@",array);
    NSString *entityIdStr = @"";
    if ([array count] == 0) {
        success();
    }
    for (int i=0 ; i<[array count] ; i++) {
        if ([entityIdStr isEqualToString:@""]) {
            entityIdStr = [array objectAtIndex:i];
        }else {
            entityIdStr = [NSString stringWithFormat:@"%@&%@",entityIdStr,[array objectAtIndex:i]];
        }
        if ((i/3 > 0 && i%3 ==0) || i == [array count] - 1) {
            [[Interface shareInterface:nil] writeFormatDataAction:@"63" didMsg:entityIdStr didCallBack:^(NSString *code){
                NSArray *tempArray = [code componentsSeparatedByString:@","];
                if ([tempArray count] > 0) {
                    for (NSString *remoteStr in tempArray) {
                        NSArray *remoteArray = [remoteStr componentsSeparatedByString:@"@"];
                        if ([remoteArray count] == 13) {
                            EntityRemote *entityRemote = [[EntityRemote alloc] init];
                            entityRemote.entityId = [remoteArray objectAtIndex:0];
                            entityRemote.entityRemoteIndex = [[remoteArray objectAtIndex:1] intValue];
                            entityRemote.brandType = [[remoteArray objectAtIndex:2] intValue];
                            entityRemote.remoteBrandIndex = [[remoteArray objectAtIndex:3] intValue];
                            entityRemote.remoteGroupIndex = [[remoteArray objectAtIndex:4] intValue];
                            entityRemote.entityRemoteName = [remoteArray objectAtIndex:5];
                            entityRemote.entityRemoteIcon = [[remoteArray objectAtIndex:6] intValue];
                            entityRemote.arcTemp = [[remoteArray objectAtIndex:7] intValue];
                            entityRemote.arcPower = [[remoteArray objectAtIndex:8] intValue];
                            entityRemote.arcMode = [[remoteArray objectAtIndex:9] intValue];
                            entityRemote.arcFan = [[remoteArray objectAtIndex:10] intValue];
                            entityRemote.arcFanMode = [[remoteArray objectAtIndex:11] intValue];
                            entityRemote.entityRemoteHint = @"";
                            entityRemote.roomId = [remoteArray objectAtIndex:12];
                            
                            if (entityRemote.brandType == 0) {
                                if (entityRemote.entityRemoteIcon == 0) {
                                    entityRemote.entityRemoteIcon = 26;
                                }
                            }else if(entityRemote.brandType == 1){
                                if (entityRemote.entityRemoteIcon == 0) {
                                    entityRemote.entityRemoteIcon = 24;
                                }
                            }
                            
                            if ([[_entityRemoteDao findByEntityRemote:entityRemote] count] > 0 ) {
                                [_entityRemoteDao updateEntityRemote:entityRemote];
                            }else{
                                [_entityRemoteDao addEntityRemote:entityRemote];
                            }
                            
                            
                        }
                    }
                    success();
                }else{
                    success();
                }
            }];
        }
    }
    return 0;
}

-(NSMutableArray *)findRemoteForEntity:(Entity *)entity
{
    NSMutableArray *array = [_entityRemoteDao findByEntity:entity];
    EntityProcess *entityProcess = [[EntityProcess alloc] init];
    entity = [entityProcess findEntityForEntity:entity];
    for (EntityRemote *entityRemote in array) {
        entityRemote.power = entity.power;
    }
    return array;
}

-(EntityRemote *) findRemoteForEntityRemote:(EntityRemote *)entityRemote
{
    if ([[_entityRemoteDao findByEntityRemote:entityRemote] count] > 0) {
        EntityRemote *entityRemoteReturn = [[_entityRemoteDao findByEntityRemote:entityRemote] objectAtIndex:0];
        EntityProcess *entityProcess = [[EntityProcess alloc] init];
        Entity *entity = [[Entity alloc] init];
        entity.entityID = entityRemote.entityId;
        entity = [entityProcess findEntityForEntity:entity];
        entityRemoteReturn.power = entity.power;
        return entityRemoteReturn;
    }
    return nil;
}

-(void) editEntityRemoteMsg:(NSString *)msg success:(CallBackParamBlock)success fail:(CallBackBlockErr)fail
{
    [[Interface shareInterface:nil] writeFormatDataAction:@"10" didMsg:msg didCallBack:^(NSString *code) {
        if (![code isEqualToString:@"1"]) {
            NSArray *array = [code componentsSeparatedByString:@","];
            if ([array count] ==3) {
                if ([[array objectAtIndex:1] intValue] == 0) { //修改
                    NSString *entityRemoteStr = [array objectAtIndex:2];
                    [self addEntityRemote:entityRemoteStr];
                    success(@"");
                }else if([[array objectAtIndex:1] intValue] == 1){// 删除
                    success(@"");
                }else{
                    fail(nil,nil);
                }
            }else
            {
                fail(nil,nil);
            }
        }else{
            fail(nil,nil);
        }
    }];
}

-(void) updateEntityRemote:(EntityRemote *)entityRemote
{
    [_entityRemoteDao updateEntityRemote:entityRemote];
}

-(void) removeEntityRemote:(EntityRemote *)entityRemote
{
    [_entityRemoteDao removeEntityRemote:entityRemote];
//    [_senceEntityProcess removeSenceEntityForBaseModel:entityRemote];
}

-(void) removeEntityRemoteForEntity:(Entity *)entity
{
    NSMutableArray *array = [_entityRemoteDao findByEntity:entity];
    for (EntityRemote *entityRemote in array) {
        [self removeEntityRemote:entityRemote];
    }
}

-(void) addEntityRemote:(NSString *)msg
{
    NSArray *remoteArray = [msg componentsSeparatedByString:@"@"];
    if ([remoteArray count] == 13) {
        EntityRemote *entityRemote = [[EntityRemote alloc] init];
        entityRemote.entityId = [remoteArray objectAtIndex:0];
        entityRemote.entityRemoteIndex = [[remoteArray objectAtIndex:1] intValue];
        entityRemote.brandType = [[remoteArray objectAtIndex:2] intValue];
        entityRemote.remoteBrandIndex = [[remoteArray objectAtIndex:3] intValue];
        entityRemote.remoteGroupIndex = [[remoteArray objectAtIndex:4] intValue];
        entityRemote.entityRemoteName = [remoteArray objectAtIndex:5];
        entityRemote.entityRemoteIcon = [[remoteArray objectAtIndex:6] intValue];
        entityRemote.arcTemp = [[remoteArray objectAtIndex:7] intValue];
        entityRemote.arcPower = [[remoteArray objectAtIndex:8] intValue];
        entityRemote.arcMode = [[remoteArray objectAtIndex:9] intValue];
        entityRemote.arcFan = [[remoteArray objectAtIndex:10] intValue];
        entityRemote.arcFanMode = [[remoteArray objectAtIndex:11] intValue];
        entityRemote.entityRemoteHint = @"";
        entityRemote.roomId = [remoteArray objectAtIndex:12];
        
        if ([[_entityRemoteDao findByEntityRemote:entityRemote] count] > 0 ) {
            [_entityRemoteDao updateEntityRemote:entityRemote];
        }else{
            [_entityRemoteDao addEntityRemote:entityRemote];
        }
    }
}

@end
