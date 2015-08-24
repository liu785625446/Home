//
//  AlarmInfosDao.h
//  Home
//
//  Created by 刘军林 on 14/11/6.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseDao.h"

@class AlarmInfos;

@interface AlarmInfosDao : BaseDao

@property (strong, nonatomic) NSMutableArray *list;

/**
 *  单例方式实例化自身对象
 *
 *  @return 返回实例对象
 */
+(AlarmInfosDao *) shareInstance;

-(BOOL) addAlarmInfos:(AlarmInfos *)alarmInfo;

-(NSMutableArray *) findAll;

-(AlarmInfos *) findByAlarmInfos:(AlarmInfos *)alarmInfos;
-(NSMutableArray *) findUnReadAlarmInfos;
-(BOOL) logoReadAlarmInfos;
-(BOOL) logoReadAlarmInfosForId:(int )alarmIndex;
@end
