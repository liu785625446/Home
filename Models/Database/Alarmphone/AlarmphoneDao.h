//
//  AlarmphoneDao.h
//  Home
//
//  Created by 刘军林 on 14/11/11.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseDao.h"

@class AlarmphoneDao;
@class Alarmphone;

@interface AlarmphoneDao : BaseDao

/**
 *  单例方式实例化自身对象
 *
 *  @return 返回实例对象
 */
+(AlarmphoneDao *) shareInstance;


-(BOOL) addAlarmphone:(Alarmphone *)alarmphone;

-(NSMutableArray *) findAllAlarmphone;

-(BOOL) removeAlarmphone:(Alarmphone *)alarmphone;

-(BOOL) removeAllAlarmphone;

@end

