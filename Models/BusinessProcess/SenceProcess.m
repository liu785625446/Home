//
//  SenceProcess.m
//  Home
//
//  Created by 刘军林 on 14/11/13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "SenceProcess.h"
#import "SenceDao.h"
#import "Interface.h"
#import "Sence.h"

#define SENCE 2

@implementation SenceProcess

-(id) init
{
    if (self = [super init]) {
        _senceDao = [SenceDao shareInstance];
        lock = [[NSLock alloc] init];
    }
    return self;
}

-(void) synchronousSence:(void (^)(void))success didFail:(void (^)(void))fail
{
    NSString *msg = [NSString stringWithFormat:@"%@&%d",BOX_ID_VALUE, SENCE];
    [[Interface shareInterface:nil] writeFormatDataAction:@"60" didMsg:msg didCallBack:^(NSString *code){
        if (code) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *tempArray = [code componentsSeparatedByString:@"&"];
                if ([tempArray count] == 3) {
                    NSString *senceArrayStr = [tempArray objectAtIndex:2];
                    NSArray *senceArray = [senceArrayStr componentsSeparatedByString:@","];
                    
                    NSString *deleteStr = @"";
                    NSMutableArray *updateArray = [[NSMutableArray alloc] initWithCapacity:0];
                    
                    for (NSString *senceStr in senceArray) {
                        NSArray *versionArray = [senceStr componentsSeparatedByString:@"@"];
                        if ([versionArray count] == 2) {
                            NSString *senceIndex = [versionArray objectAtIndex:0];
                            NSString *syncNum = [versionArray objectAtIndex:1];
                            
                            //                        删除条件
                            if ([deleteStr isEqualToString:@""]) {
                                deleteStr = [NSString stringWithFormat:@"senceIndex != '%@'",senceIndex];
                            }else{
                                deleteStr = [NSString stringWithFormat:@"%@ AND senceIndex != '%@'",deleteStr, senceIndex];
                            }
                            
                            //                        添加修改条件
                            NSString *updateStr = [NSString stringWithFormat:@"senceIndex = '%@' AND syncNum = %@",senceIndex, syncNum];
                            if ([[_senceDao findByKey:updateStr] count] == 0) {
                                [updateArray addObject:senceIndex];
                            }
                        }
                    }
                    
                    NSLog(@"deleteStr:%@",deleteStr);
                    //                删除情景
                    NSMutableArray *deleteArray = [_senceDao findByKey:deleteStr];
                    for (Sence *sence in deleteArray) {
                        [self removeSence:sence];
                    }
                    
                    NSLog(@"updateArray:%@",updateArray);
                    //                添加修改情景
                    NSString *addStr = @"";
                    for (int i=0 ; i<[updateArray count] ; i++) {
                        if ([addStr isEqualToString:@""]) {
                            addStr = [updateArray objectAtIndex:i];
                        }else {
                            addStr = [NSString stringWithFormat:@"%@&%@",addStr, [updateArray objectAtIndex:i]];
                        }
                        
                        if ((i/10 > 0 && i%10 == 0) || i==[updateArray count]-1 ) {
                            [lock lock];
                            [[Interface shareInterface:nil] writeFormatDataAction:@"66" didMsg:addStr didCallBack:^(NSString *code){
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                    if (code) {
                                        NSArray *tempArray = [code componentsSeparatedByString:@","];
                                        if ([tempArray count] > 1) {
                                            for (NSString *senceStr in tempArray) {
                                                NSArray *senceArray = [senceStr componentsSeparatedByString:@"@"];
                                                if ([senceArray count] == 11) {
                                                    Sence *sence = [[Sence alloc] init];
                                                    sence.senceIndex = [[senceArray objectAtIndex:0] intValue];
                                                    sence.senceName = [senceArray objectAtIndex:1];
                                                    sence.senceIcon = [[senceArray objectAtIndex:2] intValue];
                                                    sence.senceType = [[senceArray objectAtIndex:3] intValue];
                                                    sence.senceDate = [[senceArray objectAtIndex:4] longLongValue];
                                                    sence.senceTime = [[senceArray objectAtIndex:5] longLongValue];
                                                    sence.senceWeek = [[senceArray objectAtIndex:6] intValue];
                                                    sence.delayTime = [[senceArray objectAtIndex:7] intValue];
                                                    sence.createTime = [[senceArray objectAtIndex:8] longLongValue];
                                                    sence.lastStartTime = [[senceArray objectAtIndex:9] longLongValue];
                                                    sence.syncNum = [[senceArray objectAtIndex:10] intValue];
                                                    
                                                    if ([_senceDao findBySence:sence]) {
                                                        [_senceDao updateSence:sence];
                                                    }else{
                                                        [_senceDao addSence:sence];
                                                    }
                                                }
                                            }
                                            
                                            [lock unlock];
                                        }else {
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

-(NSMutableArray *)findAllSence
{
   return [_senceDao findAll];
}

-(BOOL) removeSence:(Sence *)sence
{
    return [_senceDao removeSence:sence];
}

@end
