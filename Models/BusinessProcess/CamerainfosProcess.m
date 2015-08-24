//
//  CamerainfosProcess.m
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "CamerainfosProcess.h"
#import "CamerainfosDao.h"
#import "Interface.h"
#import "FMDatabase.h"
#import "Camerainfos.h"

#define CAMERAINFOS 3

@implementation CamerainfosProcess

-(id) init
{
    if (self = [super init]) {
        _camerainfosDao = [CamerainfosDao shareInstance];
        
        lock = [[NSLock alloc] init];
    }
    return self;
}

-(void) synchronousCamerainfos:(void (^)(void))success didFail:(void (^)(void))fail
{
    NSString *msg = [NSString stringWithFormat:@"%@&%d",BOX_ID_VALUE, CAMERAINFOS];
    [[Interface shareInterface:nil] writeFormatDataAction:@"60" didMsg:msg didCallBack:^(NSString *code){
        if (code) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *tempArray = [code componentsSeparatedByString:@"&"];
                if ([tempArray count] == 3) {
                    NSString *arrayStr = [tempArray objectAtIndex:2];
                    NSArray *array = [arrayStr componentsSeparatedByString:@","];
                    
                    NSString *deleteStr = @"";
                    NSMutableArray *updateArray = [[NSMutableArray alloc] initWithCapacity:0];
                    
                    for (NSString *cameraInfosStr in array) {
                        NSArray *cameraInfosArray = [cameraInfosStr componentsSeparatedByString:@"@"];
                        if ([cameraInfosArray count] == 2) {
                            NSString *cameraNum = [cameraInfosArray objectAtIndex:0];
                            NSString *syncNum = [cameraInfosArray objectAtIndex:1];
                            
                            //                        删除条件
                            if ([deleteStr isEqualToString:@""]) {
                                deleteStr = [NSString stringWithFormat:@"cameraNum != '%@'",cameraNum];
                            }else{
                                deleteStr = [NSString stringWithFormat:@"%@ AND cameraNum != '%@'",deleteStr, cameraNum];
                            }
                            
                            //                        添加修改条件
                            NSString *updateStr = [NSString stringWithFormat:@"cameraNum = '%@' AND syncNum = '%@'", cameraNum, syncNum];
                            if ([[_camerainfosDao findByKey:updateStr] count] == 0) {
                                [updateArray addObject:cameraNum];
                            }
                        }
                    }
                    
                    //                删除情景
                    NSMutableArray *deleteArray = [_camerainfosDao findByKey:deleteStr];
                    for (Camerainfos *cameraInfo in deleteArray) {
                        [self removeCamerainfos:cameraInfo];
                    }
                    
                    //                添加修改情景
                    NSString *addStr = @"";
                    for (int i=0 ; i<[updateArray count] ; i++) {
                        if ([addStr isEqualToString:@""]) {
                            addStr = [updateArray objectAtIndex:i];
                        }else {
                            addStr = [NSString stringWithFormat:@"%@&%@",addStr, [updateArray objectAtIndex:i]];
                        }
                        
                        if ((i/10 > 0 && i%10 == 0) || i==[updateArray count] - 1) {
//                            [condition lock];
                            printf("\nlock\n");
                            [lock lock];
                            [[Interface shareInterface:nil] writeFormatDataAction:@"68" didMsg:addStr didCallBack:^(NSString *code){
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    if (code) {
                                        NSArray *tempArray = [code componentsSeparatedByString:@","];
                                        if ([tempArray count] > 1) {
                                            for (NSString *camerainfoStr in tempArray) {
                                                NSArray *camerainfoArray = [camerainfoStr componentsSeparatedByString:@"@"];
                                                if ([camerainfoArray count] == 7) {
                                                    Camerainfos *cameraInfos = [[Camerainfos alloc] init];
                                                    cameraInfos.cameraNum = [camerainfoArray objectAtIndex:0];
                                                    cameraInfos.cameraName = [camerainfoArray objectAtIndex:1];
                                                    cameraInfos.cameraState = [[camerainfoArray objectAtIndex:2] intValue];
                                                    cameraInfos.wifiName = [camerainfoArray objectAtIndex:3];
                                                    cameraInfos.wifiPass = [camerainfoArray objectAtIndex:4];
                                                    cameraInfos.roomId = [camerainfoArray objectAtIndex:5];
                                                    cameraInfos.boxId = BOX_ID_VALUE;
                                                    
                                                    if ([_camerainfosDao findByCamerainfos:cameraInfos]) {
                                                        [_camerainfosDao updateCamerainfos:cameraInfos];
                                                    }else {
                                                        [_camerainfosDao addCamerainfos:cameraInfos];
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
                    success();
                }else{
                    fail();
                }
            });
        }else{
            fail();
        }
    }];
}

-(NSMutableArray *) findAllCameraInfos
{
    return [_camerainfosDao findAll];
}

-(Camerainfos *) findCameraInfosForId:(NSString *)cameraId
{
    NSArray *array = [_camerainfosDao findById:cameraId];
    if ([array count] > 0) {
        return [array objectAtIndex:0];
    }else{
        return nil;
    }
}

-(BOOL) removeCamerainfos:(Camerainfos *)camerainfos
{
    return [_camerainfosDao removeCamerainfos:camerainfos];
}

@end
