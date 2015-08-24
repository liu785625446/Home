//
//  AlarmInfosProcess.h
//  Home
//
//  Created by 刘军林 on 14/11/25.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlarmInfos;
@class AlarmInfosDao;

@interface AlarmInfosProcess : NSObject

@property (nonatomic, strong) AlarmInfosDao *alarmInfosDao;

-(void) synchronousAlarmInfos:(void (^) (void))success didFail:(void (^) (void))fail;
-(NSMutableArray *) findAllAlarmInfos;
-(AlarmInfos *) findByAlarmInfos:(AlarmInfos *)alarmInfos;
-(NSMutableArray *) findUnReadAlarmInfos;
-(BOOL) logoReadAlarmInfos;
-(BOOL) logoReadAlarmInfosForId:(int )alarmIndex;

@end
