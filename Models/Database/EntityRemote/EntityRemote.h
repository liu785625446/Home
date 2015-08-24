//
//  EntityRemote.h
//  Home
//
//  Created by 刘军林 on 14-7-30.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "BaseModel.h"

@interface EntityRemote : BaseModel

@property (assign) int tableid;                                     //表ID，系统默认增加值
@property (nonatomic, strong) NSString *entityId;                   //设备ID
@property (assign) int brandType;                                   //设备品牌
@property (nonatomic,strong) NSString *entityRemoteName;            //设备名称
@property (assign) int entityRemoteIcon;                            //设备图标
@property (nonatomic, strong) NSString *entityRemoteHint;           //设备备注
@property (assign) int remoteBrandIndex;                            //设备品牌序号
@property (assign) int remoteGroupIndex;                            //码组序号
@property (assign) int entityRemoteIndex;                           //数据序号

//空调值
@property (assign) int arcPower;
@property (assign) int arcMode;
@property (assign) int arcTemp;
@property (assign) int arcFan;
@property (assign) int arcFanMode;

@property (nonatomic, strong) NSString *roomId;                     //房间号

//数据库之外的，红外电量
@property (assign) int power;

@end
