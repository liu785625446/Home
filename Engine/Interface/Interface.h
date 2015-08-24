//
//  Interface.h
//  Home
//
//  Created by 刘军林 on 14-1-16.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "AsyncSocket.h"
#import "FMDatabase.h"
#import "AsyncUdpSocket.h"

#define MASTER @"master"

typedef void (^CallBackBlock) (void);
typedef void (^CallBackBlockErr) (NSError *result, NSString *errInfo);
typedef void (^CallBackParamBlock) (NSString *code);

@class Interface;
static Interface *interface = nil;
static int number = 0;

@interface Interface : NSObject<AsyncSocketDelegate>
{
    NSTimer *tcp_timer;
    NSTimer *udp_timer;
    NSTimer *timerHeartbeat;
    NSTimer *forwardingTimerHeartbeat;  //转发心跳包
    
    NSMutableData *tempdata;
    NSString *rsaPassword;
    
//    连接成功
    CallBackParamBlock connectSuccess;
    
//    链接失败
    CallBackBlockErr connectFail;
    
//    绑定udp
    CallBackParamBlock UDPBindBlock;
    
//    登入验证
    CallBackParamBlock loginBlock;
    
//    数据同步
    CallBackParamBlock synchronousBlock;
    
//    设备控制，开关类
    CallBackParamBlock switchDeviceBlock;
    
//    设备控制，开关类帧
    CallBackParamBlock switchDeviceFrameBlock;
    
//    等待设备添加
    CallBackParamBlock deviceAddBlock;
    
//    设备编辑
    CallBackParamBlock deviceEditBlock;
    
//    移动红外设备添加
    CallBackParamBlock addRemoteBlock;
    
//    红外设备控制
    CallBackParamBlock switchRemoteBlock;
    
//    遥控编辑
    CallBackParamBlock eidtRemoteBlock;
    
//    添加修改情景
    CallBackParamBlock editSenceBlock;
    
//    添加修改情景设备
    CallBackParamBlock editSenceDeviceBlock;
    
//    删除情景
    CallBackParamBlock deleteSenceBlock;
    
//    情景启动
    CallBackParamBlock senceStartBlock;
    
//    提醒电话添加
    CallBackParamBlock contactPeopleBlock;
    
//    联动设备添加修改
    CallBackParamBlock linkDeviceEditBlock;
    
//    联动设备删除
    CallBackParamBlock linkDeviceDeleteBlock;
    
//    搜索摄像头
    CallBackParamBlock searchMonitorListBlock;
    
//    添加摄像头
    CallBackParamBlock addMonitorBlock;
    
//    联动开关
    CallBackParamBlock linkSwitchBlock;
    
//    wifi列表
    CallBackParamBlock wifiListBlock;
    
//    删除摄像头
    CallBackParamBlock deleteMonitorBlock;
    
//    wifi编辑
    CallBackParamBlock wifiEditBlock;
    
//    通知数据更新
    CallBackParamBlock noticeBlock;
    
//    获取设备版本数组
    CallBackParamBlock getDeviceVersionBlock;
    
//    获取情景版本数组
    CallBackParamBlock getSenceVersionBlock;
    
//    获取视频版本数组
    CallBackParamBlock getCameraInfosVersionBlock;
    
//    获取设备数组
    CallBackParamBlock getDeviceArrayBlock;
    
//    获取设备路
    CallBackParamBlock getEntityLineBlock;
    
//    获取红外设备
    CallBackParamBlock getInfraredBlock;
    
//    获取联动设备
    CallBackParamBlock getEntityLinkBlock;
    
//    获取报警提醒电话
    CallBackParamBlock getAlarmphoneBlock;
    
//    编辑设备路
    CallBackParamBlock editDeviceLineBlock;
    
//    删除设备
    CallBackParamBlock deleteDeviceBlock;
    
//    获取情景数组
    CallBackParamBlock getSenceArrayBlock;
    
//    获取情景设备
    CallBackParamBlock getSenceEntityBlock;
    
//    获取视频
    CallBackParamBlock getCameraInfosBlock;
    
//    获取红外报警信息
    CallBackParamBlock getAlarmInfosBlock;
    
//    读取设备状态
    CallBackParamBlock getDeviceStatusBlock;
    
//    设备反向控制
    CallBackParamBlock getDeviceReverseControlBlock;
    
//    添加房间
    CallBackParamBlock addRoomsBlock;
    
//    修改房间
    CallBackParamBlock updateRoomsBlock;
    
//    获取服务器房间
    CallBackParamBlock getRoomsListBlock;
    
//    删除房间
    CallBackParamBlock deleteRoomsBlock;
    
//    获取音乐列表
    CallBackParamBlock getMusicListBlock;

//    获取情景音乐
    CallBackParamBlock getSenceMusicBlock;
    
//    情景音乐播放
    CallBackParamBlock senceMusicingBlock;
    
//    获取设备版本属性
    CallBackParamBlock getEntityAttributaBlock;
    
//    新遥控匹配搜索
    CallBackParamBlock newRemoteMatchSearchBlock;
    
    BOOL isConnection;
}

@property (nonatomic, strong) AsyncSocket *tcp_socket;
@property (nonatomic, strong) AsyncUdpSocket *udp_socket;
@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) NSString *connectIp;
@property (nonatomic, strong) NSString *connectType;

@property (assign) BOOL isNetwork; //网络连接失败
@property (assign) BOOL isConnection; //连接失败断线中

@property (nonatomic, strong) UIViewController *currentController;

@property (assign) int failSecond;

/**
 *  POST请求
 *
 *  @param baseURL 本机地址
 *  @param url     URL
 *  @param dic     参数字典
 */
+(void) POST:(NSString *)baseURL
         url:(NSString *)url
  parameters:(NSDictionary *)dic
     success:(void (^)(NSURLSessionDataTask *, id)) success
     failure:(void (^)(NSURLSessionDataTask *, NSError *)) failure;

/**
 *  生成Interface单列
 *
 *  @param controller 在controller视图控制器创建
 *
 *  @return 单列对象
 */
+(Interface *)shareInterface:(UIViewController *)controller;

/**
 *  UDP绑定
 *
 *  @param success 绑定成功回调函数
 */
-(void) bindUDPService:(CallBackParamBlock) success;

/**
 *  创建TCP链接
 *
 *  @param ip          链接IP
 *  @param connectType 链接类型
 *  @param Success     链接成功回调
 *  @param fail        链接失败回调
 */
-(void) connectService:(NSString *)ip
        didConnectType:(NSString *)connectType
            didSuccess:(CallBackParamBlock)Success
                  Fail:(CallBackBlockErr)fail;

/**
 *  sqlite初始化函数
 */
-(void) initSqlite;

/**
 *  设置回调广播帧
 *
 *  @param block 回调函数
 */
-(void) setSwitchBlock:(CallBackParamBlock)block;

-(void) setSenceMusiceBlock:(CallBackParamBlock)block;

/**
 *  socket发送函数
 *
 *  @param methodCode 消息类型编码
 *  @param msg        消息数据
 *  @param block      socket接受数据回调函数
 */
-(void) writeFormatDataAction:(NSString *)methodCode
                       didMsg:(NSString *)msg
                  didCallBack:(void (^) (NSString *))block;

/**
 *  通知数据更新函数
 *
 *  @param block 数据更新回调
 */
-(void) noticeSynchronization:(CallBackParamBlock)block;
@end
