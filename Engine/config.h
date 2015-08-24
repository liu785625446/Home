//
//  config.h
//  Home
//
//  Created by 刘军林 on 14-7-16.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//
#import "const.h"

#ifndef Home_config_h
#define Home_config_h

////智能控制类
//#define SWITCH_TYPE 5
//
////安防类
//#define SECURITY_TYPE 6 

//面板开关 2路
#define PANEL_SWITCH_2 8

#define PANEL_SWITCH_1 9

//面板开关 3路
#define PANEL_SWITCH_3 1

//窗帘
#define CURTAIN_SWITCH 2

//插座
#define SOCKET_SWITCH 0

#define AP_TYPE 700

//遥控 红外
#define REMOTE_INFRARED 3

//遥控 RF
#define REMOTE_RF 51502

//门磁
#define MAGNETIC 4

//红外探测
#define INFRARED_PROBE 5

//红外探测信息
#define INFRARED_INFO 633010

//燃气探测
#define GAS_DETECTION 6

//SMKEN 烟感
#define SMKEN 7

//监控cell
#define MONITORCELL 9999

//视频监控
#define MONITOR 8888

/**
 情景启动类型
 */
typedef enum : NSUInteger {
    SENCE_TYPE_DELAY = 0, //延时
    SENCE_TYPE_TIMING,    //定时
    SENCE_TYPE_CYCLE,     //周期
}SenceType;

//alert类型
enum{
    ALERTSENCE = 1000,      //情景
    ALERTMRJ,               //授权
    ALERTGESTURE,           //手势密码
    ALERTUPDATE,            //更新
    ALERTNETWORKERROR,      //网络错误提示
    ALERTREBINDING,         //验证失败，重新绑定
};

#define AUTO_LOGIN @"AUTO_LOGIN"
enum {
    AUTO_LOGIN_OPEN = 1000, //自动登录开启
    AUTO_LOGIN_CLOSE,       //自动登录关闭
};

#endif
