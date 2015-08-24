//
//  Sence.h
//  Home
//
//  Created by 刘军林 on 14-8-13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseModel.h"
#import "FMDatabase.h"

#define SUNDAY 0x40
#define MONDAY 0x01
#define TUESDAY 0x02
#define WEDNESDAY 0x04
#define THURSDAY 0x08
#define FRIDAY 0x10
#define SATURDAY 0x20


@interface Sence : BaseModel

@property (assign) int tableid;
@property (nonatomic, strong) NSString *senceName;
@property (assign) int senceIcon;
//情景类型
@property (assign) int senceType;
//情景延时启动时间
@property (assign) int delayTime;
//情景日期
@property (assign) long long senceDate;
//情景时间
@property (assign) long long senceTime;
//情景周
@property (assign) int senceWeek;
//最后一次启动时间
@property (assign) long long lastStartTime;
//情景创建时间
@property (assign) long long createTime;
//情景序号
@property (assign) int senceIndex;
//盒子身份码
@property (nonatomic, strong) NSString *boxId;
//同步序号
@property (assign) int syncNum;

@property (nonatomic, strong) NSString *senceMusic;

//情景设备
@property (nonatomic, strong) NSMutableArray *senceEntityList;

-(Sence *)getSence:(FMResultSet *)set;

-(NSString *) getWeekStr;

@end
