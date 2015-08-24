//
//  EntityLine.h
//  Home
//
//  Created by 刘军林 on 14-9-12.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "BaseModel.h"

@interface EntityLine : BaseModel

@property (assign) int tableid;                                 //表ID，系统默认增加
@property (nonatomic, strong) NSString *boxId;                  //盒子ID
@property (nonatomic, strong) NSString *entityID;               //设备ID
@property (nonatomic, strong) NSString *entityLineNum;          //设备对应路编号
@property (nonatomic, strong) NSString *entityLineName;         //设备名称
@property (assign) int state;                                   //控制状态
@property (assign) int icon;                                    //设备默认图标

@property (nonatomic, strong) NSString *entityType;
@property (nonatomic, strong) NSString *roomId;

@property (assign) int tempValue;                               //临时存储 用于用户需求，非数据结构
@property (assign) int enabled;                                 //是否启用      0启用     1停用

@property (nonatomic, strong) NSString *entitySignal;

@property (assign) int switchState;
@property (nonatomic , assign) BOOL isAnimation;

@end
