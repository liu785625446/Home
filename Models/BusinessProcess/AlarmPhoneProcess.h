//
//  AlarmPhoneProcess.h
//  Home
//
//  Created by 刘军林 on 14/11/11.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlarmphoneDao;

@interface AlarmPhoneProcess : NSObject

@property (nonatomic, strong) AlarmphoneDao *alarmphoneDao;

/**
 *  同步短信报警号码
 *
 *  @param success 成功block
 *  @param fail    失败block
 */
-(void) synchronousAlarmPhone:(void (^)(int))success didFail:(void (^)(void))fail;

/**
 *  查询所有短信报警号码
 *
 *  @return 短信报警号码数组
 */
-(NSMutableArray *) findAllAlarmphone;
@end
