//
//  SenceEntity.h
//  Home
//
//  Created by 刘军林 on 14-8-13.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseModel.h"
#import "FMDatabase.h"

@interface SenceEntity : BaseModel

@property (assign) int tableid;
//情景ID
@property (assign) int senceIndex;
//联动设备ID
@property (nonatomic, strong) NSString *entityId;
//设备对应路
@property (assign) int entityLineNum;
@property (assign) int entityRemoteIndex;
@property (assign) int state;
//空调键值
//电源
@property (assign) int arcPower;
//模式
@property (assign) int arcMode;
//温度
@property (assign) int arcTemp;
//风力
@property (assign) int arcFan;
//风力模式
@property (assign) int arcFanMode;
//盒子身份码
@property (nonatomic, strong) NSString *boxId;
//情景设备序号
@property (assign) int senceEntityIndex;

-(SenceEntity *)getSenceEntity:(FMResultSet *)set;
@end
