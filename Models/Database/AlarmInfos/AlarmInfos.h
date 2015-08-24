//
//  AlarmInfos.h
//  Home
//
//  Created by 刘军林 on 14-10-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseModel.h"
#import "FMDatabase.h"


@interface AlarmInfos : BaseModel

@property (assign, nonatomic) int tableid;                  //表ID，系统默认增加值
@property (strong, nonatomic) NSString *entityId;           //报警设备ID
@property (strong, nonatomic) NSString *entityName;         //设备名称
@property (assign, nonatomic) int entityIcon;               //设备图标
@property (strong, nonatomic) NSString *entityType;         //设备类型
@property (assign, nonatomic) long long alarmTime;                //报警时间
@property (assign, nonatomic) int state;                    //报警状态
@property (assign, nonatomic) int readState;                //未读状态
@property (strong, nonatomic) NSString *boxId;              //盒子ID
@property (assign) int alarmIndex;

@end
