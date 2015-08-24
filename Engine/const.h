//
//  Consts.h
//  Home
//
//  Created by 刘军林 on 14-10-17.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#ifndef Home_const_h
#define Home_const_h

#define APPID @"znjj"

//数据库名
#define DB_FILE_NAME @"excenon.db"

//手势密码存储KEY
#define GESTUREPASSWORD [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:U_BOX_ID],@"GesturePassword"]

#define U_BOX_ID @"box_id"
#define U_TOKEN @"token"
#define U_PAD_ID @"pad_id"
#define U_PASSWORD @"password"

//摄像头选择列
#define VIDEOINDEX @"videoIndexP2P"
#define BOX_ID_VALUE [[NSUserDefaults standardUserDefaults] objectForKey:U_BOX_ID]
#define MGUIDEPAGEVIEW @"guidePageTag3.5.9"

#define S_ENTITY_STATUS_CALLBACK_FAIL @"状态回读失败"
#define S_CONNECT_FAIL_WHETHER_AGAIN @"网络连接失败，是否重新连接"
#define S_DEFINE @"确定"
#define S_CANCEL @"取消"
#define S_VIDEO_MONITOR @"视频监控"
#define S_ALARM_INFORMATION @"报警信息"
#define S_MRJ_LIFE_WISDOM @"Mr.j智慧生活"
#define S_PROMPT @"提示"
#define S_GESTURE_PASSWORD_INPUT_ERRORS @"你已连续5次输错手势，手势解锁已关闭，请重新登入"
#define S_MRJ_SMART_SECURITY @"Mr.j智能安防"
#define S_NOT_BOUND_BOX_GO_MRJ_BOUND @"还未绑定盒子，去往Mr.j平台获取"
#define S_LOADING @"加载中"
#define S_NO_VIDEO_RECORD @"暂无回放视频记录"
#define S_LOAD_SUCCESS @"加载成功"
#define S_SENCE_START_SUCCESS @"情景启动成功!"
#define S_SENCE_START_FAIL @"情景启动失败!"
#define S_SENCE_START_SUCCESS_DELAYING @"启动成功，延时中..."
#define S_DELAY_START_FAIL @"延时启动失败"
#define S_LAST_TIME_DELAY_NO_COMPLETE @"延时启动失败"
#define S_DEVICE @"设备"
#define S_SENCE @"情景"
#define S_REMOTE @"遥控器"
#define S_NETWORK_NO_DETECT_NETWORK_SETTINGS @"当前网络不可用，请检查网络设置"

#define S_FORMAT_ERROR @"输入格式错误，不能输入特殊字符"

#endif
