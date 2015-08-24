//
//  MonitorVideo.h
//  Home
//
//  Created by 刘军林 on 14-9-3.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Camerainfos.h"
#import "AHReach.h"
#import "Reachability.h"

#import "PPPP_API.h"
#import "PPPPChannelManagement.h"
#import "ImageNotifyProtocol.h"
#import "SearchCameraResultProtocol.h"
#import "SearchDVS.h"
#import "ParamNotifyProtocol.h"
#import "MyAudioSession.h"
#import "Tool.h"
#import "MonitorVideoDelegate.h"
#import "PlaybackProtocol.h"

@class WFSearchResult;

#define MONITOR_HOST "ipcam.360fis.com"
#define MONITOR_HOST_PORT 6605

#define MONITORBACK @"monitorBack"
#define K_MAX_OFFSET_OF_MONITOR_FOR_MOVING 70

#define STATUS_UNKNOWN_TEXT @"摄像头状态未知"
#define STATUS_CONNECTING_TEXT @"摄像头连接中..."
#define STATUS_CONNECT_FAILED_TEXT @"摄像头连接失败"
#define STATUS_DISCONNECTED_TEXT @"摄像头连接断开"
#define STATUS_INVALID_TEXT @"摄像头ID无效"
#define STATUS_NOT_ONLINE_TEXT @"摄像头不在线"
#define STATUS_CONNECT_TIMEOUT_TEXT @"连接超时"
#define STATUS_INVALID_USERPWD_TEXT @"用户名或密码错误"
#define STATUS_CONNECTING_SUCCESS @"摄像头连接成功"

enum {
    newMonitor = 0,
    oldMonitor
};

@interface MonitorVideo : UIImageView < ImageNotifyProtocol, SearchCameraResultProtocol, ParamNotifyProtocol, SDCardRecordFileSearchProtocol,PlaybackProtocol>
{
    long realHandle;
    long historyHandle;  //播放回放
    
//    声音播放类
    NSTimer *timerPlay;
    NSTimer *backTimerPlay;
    NSMutableData *videoBuffer;
    
    int videoRGB565Length;
    int videoWidth;
    int videoHeight;
    CGPoint oldPoint;
    
    int new_old;
    
    unsigned short moveTime;                    //总移动时间
    unsigned short moveIngTime;                 //已移动的时间
    BOOL isMoveing;                             //是否移动了
    unsigned short noMonitorTime;
    BOOL isShowActivity;
    NSTimer *monitorMoveTimer;                  //摄像头移动得定时器
    int offset;                                 //偏移量
    
    BOOL isMoveTimerStart;
    
    CGPoint beginPoint;
    
    BOOL isAudio;                               //声音打开状态
    int flip;
    
    NSString *currentRecordFile;
    
    
}

@property (nonatomic, strong) NSLayoutConstraint *monitorTop;
@property (nonatomic, strong) NSLayoutConstraint *monitorLeft;
@property (nonatomic, strong) NSLayoutConstraint *monitorRight;
@property (nonatomic, strong) NSLayoutConstraint *monitorHeight;

@property (nonatomic, assign) BOOL isOpenMonitor;

//是否可以拖动
@property (nonatomic, assign) BOOL isPanges;

@property (nonatomic, strong) UIImageView *moveImg;
@property (nonatomic, strong) UILabel *isWifiLib;
@property (nonatomic, strong) NSArray *reachs;
@property (nonatomic, strong) UILabel *loadLab;
@property (nonatomic, strong) UIButton *closeBut;
@property (nonatomic, strong) UIButton *audioBut;
@property (nonatomic, strong) UIButton *reversalBut;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIActivityIndicatorView *loadActivity;
@property (nonatomic, strong) UIButton *backBut;

@property (nonatomic, strong) UIImageView *moveDirection;
@property (nonatomic, strong) NSLayoutConstraint *moveDirection_X;
@property (nonatomic, strong) NSLayoutConstraint *moveDirection_Y;

//摄像头状态
@property (nonatomic, strong) NSMutableDictionary *p2p_MonitorStatus;

@property (nonatomic, strong) NSString *setWifiDid;

//已启动的视频
@property (nonatomic, strong) NSMutableArray *startMonitor_list;

@property (assign) int p2p_dataLeng;
@property (assign) BOOL isOpen;
@property (nonatomic, strong) NSTimer *p2p_timer;
@property (assign) NSInteger p2p_timeInterval;

@property CPPPPChannelManagement *m_PPPPChannelMgt;

@property (assign) BOOL isMonitor;
@property (nonatomic, strong) Camerainfos *camerainfo;
@property (nonatomic, weak) id<MonitorVideoDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *wifi_list;
@property (nonatomic, strong) NSString *current_wifi;

@property (nonatomic, strong) NSMutableArray *recordFile_list;

@property (nonatomic, assign) BOOL isNetwork;

+(MonitorVideo *) shareMonitorVideo;

-(void) closeMonitorP2PAction;

-(void) starMonitorViewP2P:(NSString *)mCameraID;
-(void) contentmonitorP2P:(NSString *)mCameraID;

-(void) startCurrentWifiSearch:(NSString *)SSID;
-(void) startWifiListSearch:(NSString *)SSID;

-(void) setWifi:(WFSearchResult *)wf didWifi:(NSString *)wifi didPwd:(NSString *)pwd;

-(void) searchSDRecordFileList:(NSString *)SSID pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;
-(void) openBackPlayMonitor:(NSString *)SSID RecordFile:(NSString *)recordFile;
-(void) closeBackPlayMonitor:(NSString *)SSID;

-(void) rebootDeviceCamersId:(NSString *)camersId;

-(void) stopAll;
@end
