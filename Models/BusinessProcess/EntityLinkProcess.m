//
//  EntityProcess.m
//  Home
//
//  Created by 刘军林 on 14/11/11.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EntityLinkProcess.h"
#import "EntityLinkDao.h"
#import "Entity.h"
#import "Interface.h"
#import "EntityLink.h"

@class Entity;

@implementation EntityLinkProcess

-(id) init
{
    if (self = [super init]) {
        _entityLinkDao = [EntityLinkDao shareInstance];
    }
    return self;
}

-(void) synchronousEntityLink:(Entity *)entity didSuccess:(void (^)(void))success didFail:(void (^)(void))fail
{
//    删除当前设备的所有联动设备
    [_entityLinkDao removeByEntity:entity];
    
    NSString *msg = [NSString stringWithFormat:@"%@",entity.entityID];
    [[Interface shareInterface:nil] writeFormatDataAction:@"64" didMsg:msg didCallBack:^(NSString *code){
        if (code) {
            NSLog(@"code:%@",code);
            NSArray *tempArray = [code componentsSeparatedByString:@","];
            NSString *entityId = @"";
            if ([tempArray count] > 2) {
                entityId = [tempArray objectAtIndex:1];
            }
            for (NSString *entityLinkStr in tempArray) {
                NSArray *entityLinkArray = [entityLinkStr componentsSeparatedByString:@"@"];
                if ([entityLinkArray count] == 4) {
                    EntityLink *entityLink = [[EntityLink alloc] init];
                    entityLink.entityId = [entityLinkArray objectAtIndex:0];
                    entityLink.safeEntityId = entityId;
                    entityLink.entityLineNum = [[entityLinkArray objectAtIndex:1] intValue];
                    entityLink.state = [[entityLinkArray objectAtIndex:2] intValue];
                    entityLink.entityLinkIndex = [[entityLinkArray objectAtIndex:3] intValue];
                    [_entityLinkDao addEntityLink:entityLink];
                }
            }
            success();
        }else {
            fail();
        }
    }];
}

-(void) addEntityLinkForStr:(NSString *)msg
{
    if (msg) {
        NSArray *tempArray = [msg componentsSeparatedByString:@","];
        NSString *entityId = @"";
        if ([tempArray count] > 2) {
            entityId = [tempArray objectAtIndex:1];
        }
        for (NSString *entityLinkStr in tempArray) {
            NSArray *entityLinkArray = [entityLinkStr componentsSeparatedByString:@"@"];
            if ([entityLinkArray count] == 4) {
                EntityLink *entityLink = [[EntityLink alloc] init];
                entityLink.entityId = [entityLinkArray objectAtIndex:0];
                entityLink.safeEntityId = entityId;
                entityLink.entityLineNum = [[entityLinkArray objectAtIndex:1] intValue];
                entityLink.state = [[entityLinkArray objectAtIndex:2] intValue];
                entityLink.entityLinkIndex = [[entityLinkArray objectAtIndex:3] intValue];
                [_entityLinkDao addEntityLink:entityLink];
            }
        }
    }
}

-(NSMutableArray *) findEntityLinkForEntity:(Entity *)entity
{
    return [_entityLinkDao findByEntity:entity];
}

@end
