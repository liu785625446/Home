//
//  AlarmInfosProcess.m
//  Home
//
//  Created by 刘军林 on 14/11/25.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AlarmInfosProcess.h"
#import "AlarmInfosDao.h"
#import "Interface.h"
#import "AlarmInfos.h"

@implementation AlarmInfosProcess

-(id) init
{
    if (self = [super init]) {
        _alarmInfosDao = [AlarmInfosDao shareInstance];
    }
    return self;
}

-(void) synchronousAlarmInfos:(void (^)(void))success didFail:(void (^)(void))fail
{
    NSString *msg = [NSString stringWithFormat:@"%@&%d&%d",BOX_ID_VALUE, 0, 10];
    [[Interface shareInterface:nil] writeFormatDataAction:@"69" didMsg:msg didCallBack:^(NSString *code){
        if (code) {
            NSArray *tempArray = [code componentsSeparatedByString:@","];
            for (NSString *tempStr in tempArray) {
                NSArray *alarmInfoArray = [tempStr componentsSeparatedByString:@"@"];
                if ([alarmInfoArray count] == 7) {
                    AlarmInfos *alarmInfos = [[AlarmInfos alloc] init];
                    alarmInfos.alarmIndex = [[alarmInfoArray objectAtIndex:0] intValue];
                    alarmInfos.entityId = [alarmInfoArray objectAtIndex:1];
                    alarmInfos.entityName = [alarmInfoArray objectAtIndex:2];
                    alarmInfos.entityType = [alarmInfoArray objectAtIndex:3];
                    alarmInfos.entityIcon = [[alarmInfoArray objectAtIndex:4] intValue];
                    alarmInfos.alarmTime = [[alarmInfoArray objectAtIndex:5] longLongValue];
                    alarmInfos.state = [[alarmInfoArray objectAtIndex:6] intValue];
                    alarmInfos.readState = 1;
                    
                    if (![_alarmInfosDao findByAlarmInfos:alarmInfos]) {
                        NSLog(@"%d",[_alarmInfosDao addAlarmInfos:alarmInfos]);
                    }
                }
            }
            success();
        }else {
            fail();
        }
    }];
}

-(NSMutableArray *) findAllAlarmInfos
{
    return [_alarmInfosDao findAll];
}

-(AlarmInfos *) findByAlarmInfos:(AlarmInfos *)alarmInfos
{
    return [_alarmInfosDao findByAlarmInfos:alarmInfos];
}

-(BOOL) logoReadAlarmInfos
{
    return [_alarmInfosDao logoReadAlarmInfos];
}

-(BOOL) logoReadAlarmInfosForId:(int )alarmIndex
{
    return [_alarmInfosDao logoReadAlarmInfosForId:alarmIndex];
}

-(NSMutableArray *) findUnReadAlarmInfos
{
    return [_alarmInfosDao findUnReadAlarmInfos];
}

@end
