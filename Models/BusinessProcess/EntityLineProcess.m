//
//  EntityLineProcess.m
//  Home
//
//  Created by 刘军林 on 14/11/11.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "EntityLineProcess.h"
#import "EntityLineDao.h"
#import "Interface.h"
#import "EntityLine.h"
#import "SenceEntityProcess.h"
#import "DeviceResource.h"

@implementation EntityLineProcess

-(id) init
{
    if (self = [super init]) {
        _entityLineDao = [EntityLineDao shareInstance];
        _senceEntityProcess = [[SenceEntityProcess alloc] init];
    }
    return self;
}

-(int) synchronousEntityLine:(NSMutableArray *)array didSuccess:(void (^)(void))success didFail:(void (^)(void))fail
{
    NSString *entityIdStr = @"";
//    没有同步数据
    if ([array count] == 0) {
        success();
    }
    
    for (int i=0 ; i<[array count] ; i++) {
        if ([entityIdStr isEqualToString:@""]) {
            entityIdStr = [array objectAtIndex:i];
        }else{
            entityIdStr = [NSString stringWithFormat:@"%@&%@",entityIdStr,[array objectAtIndex:i]];
        }
        
        if ((i/10 > 0 && i%10 == 0) || i == [array count] - 1) {
            [[Interface shareInterface:nil] writeFormatDataAction:@"62" didMsg:entityIdStr didCallBack:^(NSString *code){
                NSArray *tempArray = [code componentsSeparatedByString:@","];
                if ([tempArray count] > 0) {
                    for (NSString *entityLineStr in tempArray) {
                        NSArray *entityLineArray = [entityLineStr componentsSeparatedByString:@"@"];
                        if ([entityLineArray count] == 7) {
                            EntityLine *entityLine = [[EntityLine alloc] init];
                            entityLine.entityID = [entityLineArray objectAtIndex:0];
                            entityLine.entityLineNum = [entityLineArray objectAtIndex:1];
                            entityLine.entityLineName = [entityLineArray objectAtIndex:2];
                            entityLine.state = [[entityLineArray objectAtIndex:3] intValue];
                            entityLine.icon = [[entityLineArray objectAtIndex:4] intValue];
                            entityLine.enabled = [[entityLineArray objectAtIndex:5] intValue];
                            entityLine.roomId = [entityLineArray objectAtIndex:6];
                            if (entityLine.icon == 0) {
                                entityLine.icon = [[DeviceResource getDeviceDefaultImg:1] intValue];
                            }
                            
                            if ([entityLine.entityLineName isEqualToString:@""]) {
                                entityLine.entityLineName = [DeviceResource getDeviceDefaultName:1];
                            }
                            
                            if ([[_entityLineDao findByEntityLine:entityLine] count] > 0) {
                                [_entityLineDao updateEntityLine:entityLine];
                            }else{
                                [_entityLineDao addEntityLine:entityLine];
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

-(BOOL) updateEntityLine:(EntityLine *)entityLine
{
    return [_entityLineDao updateEntityLine:entityLine];
}

-(NSMutableArray *) findEntityLineForEntity:(Entity *)entity
{
    return [_entityLineDao findByEntity:entity];
}

-(void) removeEntityLIneForEntity:(Entity *)entity
{
    [_entityLineDao removeEntityLineForEntity:entity];
//    NSMutableArray *array = [_entityLineDao findByEntity:entity];
//    for (EntityLine *entityLine in array) {
//        [_senceEntityProcess removeSenceEntityForBaseModel:entityLine];
//    }
}

-(BOOL) addEntityLineForStr:(NSString *)msg
{
    NSArray *entityLineArray = [msg componentsSeparatedByString:@"@"];
    if ([entityLineArray count] == 7) {
        EntityLine *entityLine = [[EntityLine alloc] init];
        entityLine.entityID = [entityLineArray objectAtIndex:0];
        entityLine.entityLineNum = [entityLineArray objectAtIndex:1];
        entityLine.entityLineName = [entityLineArray objectAtIndex:2];
        entityLine.state = [[entityLineArray objectAtIndex:3] intValue];
        entityLine.icon = [[entityLineArray objectAtIndex:4] intValue];
        entityLine.enabled = [[entityLineArray objectAtIndex:5] intValue];
        entityLine.roomId = [entityLineArray objectAtIndex:6];
        
        if (entityLine.icon == 0) {
            entityLine.icon = [[DeviceResource getDeviceDefaultImg:1] intValue];
        }
        
        if ([entityLine.entityLineName isEqualToString:@""]) {
            entityLine.entityLineName = [DeviceResource getDeviceDefaultName:1];
        }
        
        if ([[_entityLineDao findByEntityLine:entityLine] count] > 0) {
            [_entityLineDao updateEntityLine:entityLine];
        }else{
            [_entityLineDao addEntityLine:entityLine];
        }
        return YES;
    }
    return NO;
}

@end
