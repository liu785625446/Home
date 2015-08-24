//
//  Entity.h
//  Home
//
//  Created by 刘军林 on 14-7-16.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "BaseModel.h"

@interface Entity : BaseModel

@property (assign, nonatomic) int tableid;                  //表ID，系统默认增加值
@property (strong, nonatomic) NSString *boxId;
@property (strong, nonatomic) NSString *entityID;           //设备ID
@property (strong, nonatomic) NSString *entityName;         //设备名称
@property (assign, nonatomic) int state;                    //控制状态
@property (assign, nonatomic) int power;                    //设备电量
@property (assign, nonatomic) int link;                     //是否联动 
@property (assign, nonatomic) int icon;                     //设备默认图标
@property (strong, nonatomic) NSString *entityType;         //设备类型 参阅EntityCode
@property (assign, nonatomic) int delState;                 //手动删除状态，0无状态，1已在网络中删除
@property (assign, nonatomic) int syncNum;                  //版本号
@property (strong, nonatomic) NSString *roomId;             //房间ID

@property (strong, nonatomic) NSString *entitySignal;

@property (assign, nonatomic) int switchState;

//次版本新加参数
@property (nonatomic, strong) NSString *alerterVoice;         //自定义报警语音状态 0:系统默认，1：使用自定义主意内容，2：选择系统铃声
@property (nonatomic, strong) NSString *alerterVoiceNo;       //报警铃声序号
@property (nonatomic, strong) NSString *userCustomContent;    //用户自定义内容
@property (nonatomic, strong) NSString *attributeMark;        //属性标签
@property (nonatomic, strong) NSString *deviceRemark;         //设备备注

//extern 动画，另外两个是窗帘的
@property (assign) BOOL isLeftAnimation;
@property (assign) BOOL isMiddleAnimation;
@property (assign) BOOL isRightAnimation;

@property (assign) BOOL isAnimation;

//多路面板 多路面板才会用到
@property (assign) BOOL isShowPanelList;
//面板路列表 多路面板才会用到
@property (nonatomic, strong) NSMutableArray *panelList;
@end
