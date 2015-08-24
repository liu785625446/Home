//
//  Interface.m
//  Home
//
//  Created by 刘军林 on 14-1-16.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "Interface.h"
#import "AsyncUdpSocket.h"
#import "Tool.h"
#import "AFAppDotNetAPIClient.h"
#import "CRSA.h"
#import "GTMBase64.h"
#import "URL.h"
#import "aes1.h"

@implementation Interface
@synthesize currentController;
@synthesize db;
@synthesize isConnection;

+(Interface*) shareInterface:(UIViewController *)controller
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (interface == nil) {
            interface = [[Interface alloc] init];
            interface.failSecond = 0;
        }
    });
    if (controller) {
        interface.currentController = controller;
    }
    return interface;
}

#pragma mark 绑定广播
-(void) bindUDPService:(CallBackParamBlock)success
{
    _udp_socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [_udp_socket enableBroadcast:YES error:nil];
    [_udp_socket bindToPort:UDP_PORT  error:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(udp_timerAction)
                                   userInfo:nil
                                    repeats:YES];
    
    UDPBindBlock = success;
}

#pragma mark TCP服务器连接
-(void) connectService:(NSString *)ip
        didConnectType:(NSString *)connectType
            didSuccess:(CallBackParamBlock)Success
                  Fail:(CallBackBlockErr)fail
{
    NSError *error = nil;
    _connectType = connectType;
    _connectIp = ip;
    connectSuccess = Success;
    connectFail = fail;
    
    int port;
    if ([connectType isEqualToString:@"200"]) {
        port = PORT200;
    }else {
        port = PORT404;
    }
    
    printf("%s\n", "tcp连接");

//    检测链接，如果链接上了先断开
    if (_tcp_socket) {
        if (![_tcp_socket isDisconnected]) {
            [_tcp_socket disconnect];
            return;
        }
    }
    
    _tcp_socket = [[AsyncSocket alloc] initWithDelegate:self];
    if ([_tcp_socket connectToHost:_connectIp onPort:port withTimeout:5 error:&error]) {
        
//        定时器接收tcp数据
        if (tcp_timer) {
            [tcp_timer invalidate];
            tcp_timer = nil;
        }
        tcp_timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(tcp_timerAction)
                                                   userInfo:nil
                                                    repeats:YES];
        
        if ([connectType isEqualToString:@"200"]) { //直连
            
            if (timerHeartbeat) {
                [timerHeartbeat invalidate];
                timerHeartbeat = nil;
            }
            timerHeartbeat = [NSTimer scheduledTimerWithTimeInterval:10
                                                              target:self
                                                            selector:@selector(sendHeartbeat)
                                                            userInfo:nil
                                                             repeats:YES];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *msgStr = [NSString stringWithFormat:@"$$%d$%@$%@&%@",number++,@"0",BOX_ID_VALUE,[user objectForKey:U_PAD_ID]];
            [self sendAuthenticateData:msgStr];
            
        }else { //转发
            
            if (forwardingTimerHeartbeat) {
                [forwardingTimerHeartbeat invalidate];
                forwardingTimerHeartbeat = nil;
            }
            forwardingTimerHeartbeat = [NSTimer scheduledTimerWithTimeInterval:5
                                                                        target:self
                                                                      selector:@selector(forwardingHeartBeatAction)
                                                                      userInfo:nil
                                                                       repeats:YES];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *bodyStr = [NSString stringWithFormat:@"{'boxId':'%@','token':'%@','padId':'%@'}",BOX_ID_VALUE,[user objectForKey:U_TOKEN],[user objectForKey:U_PAD_ID]];
            
            [self sendAuthenticateData:bodyStr];
        }
    }else {
        connectFail(error,nil);
    }
}

#pragma mark 定时接受socket信息
-(void) tcp_timerAction
{
    [_tcp_socket readDataWithTimeout:-1 tag:0];
}

-(void) udp_timerAction
{
    [_udp_socket receiveWithTimeout:-1 tag:0];
}

-(void) sendHeartbeat
{
    [self sendData:@"$$EXCENON@MRJ"];
}

//转发心跳包
-(void) forwardingHeartBeatAction
{
    NSLog(@"中转心跳包");
    [_tcp_socket writeData:[@"#@" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:5 tag:0];
}
                                        
#pragma mark -
#pragma mark AsyncSocketDelegate
-(BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString *msg = [[NSString alloc] initWithData:data
                                          encoding:NSUTF8StringEncoding];
    UDPBindBlock(msg);
    return YES;
}

-(void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [_tcp_socket readDataWithTimeout:-1 tag:0];
}

-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    Byte *startByte = NULL;
    
    //    合包测试
    //    static int datesize = 0;
    //    if (datesize == 0) {
    //        datesize ++;
    //        tempdata = [[NSMutableData alloc] initWithData:data];
    //        return;
    //    }else{
    //        [tempdata appendData:data];
    //        data = tempdata;
    //        datesize = 0;
    //    }
//    NSLog(@"data is %@ and length:%d", data ,[data length]);
    self.failSecond = 0;
    for (int i=0 ; i<= [data length]; ) {
        
        //        NSLog(@"i:%d------------length:%d",i,[data length]);
        startByte = [self dataToByte:data didFrom:i didTo:i+5];
        NSData *startData = [[NSData alloc] initWithBytes:startByte length:5];
        
        NSString *start = [[NSString alloc] initWithData:startData encoding:NSUTF8StringEncoding];
//        检测分包
        Byte *endTempByte = NULL;
        endTempByte = [self dataToByte:data didFrom:data.length-3 didTo:data.length];
        NSData *endTempData = [[NSData alloc] initWithBytes:endTempByte length:3];
        NSString *endTemp = [[NSString alloc] initWithData:endTempData encoding:NSUTF8StringEncoding];

        if (![endTemp isEqualToString:@"end"]) {
            free(startByte);
            free(endTempByte);
            return;
        }
        
        if ([start isEqualToString:@"start"]) {
            
            i=i+5;
            Byte *lengByte = [self dataToByte:data didFrom:i didTo:i+4];
            i=i+4;
            int leng = [self byteToInt:lengByte];
            
            Byte *endByta = [self dataToByte:data didFrom:i+leng-3 didTo:i+leng];
            NSData *endData = [[NSData alloc] initWithBytes:endByta length:3];
            NSString *endStr = [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
            if ([endStr isEqualToString:@"end"]) {
                
                Byte *textByte = [self dataToByte:data
                                          didFrom:i
                                            didTo:i+leng-3];
                i = i + leng;
                NSString *textStr = [self getTextInfo:textByte
                                             password:rsaPassword
                                                 leng:leng-3];
                NSLog(@"收到服务器数据:%@",textStr);
                [self readDataFormatHandle:textStr];
                free(textByte);
            }else{
                i = i+leng;
            }
            
            free(lengByte);
            free(endByta);
        }else{
            free(endTempByte);
            free(startByte);
            break;
        }
        free(endTempByte);
        free(startByte);
    }
}

-(void) readDataFormatHandle:(NSString *)msg
{
    NSArray *array = [msg componentsSeparatedByString:@"$$"];
    if ([array count] == 1) { //转发服务器发来的数据
        
        NSString *msg = [array objectAtIndex:0];
        if ([msg isEqualToString:@"{\"return\":\"true\"}\n"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [self writeFormatDataAction:@"0" didMsg:[NSString stringWithFormat:@"%@&%@",BOX_ID_VALUE, [user objectForKey:U_PAD_ID]] didCallBack:nil];
            timerHeartbeat = [NSTimer scheduledTimerWithTimeInterval:10
                                                              target:self
                                                            selector:@selector(sendHeartbeat)
                                                            userInfo:nil
                                                             repeats:YES];
        }
        
    }else if ([array count] > 1) { //服务器$$0$0$0数据格式处理
        
        for (int i=1 ; i<[array count] ; i++) {
            
            NSString *str = [array objectAtIndex:i];
            if ([str isEqualToString:@"EXCENON@MRJ"]) { //心跳包数据
                continue;
            }
            
            NSArray *arr = [str componentsSeparatedByString:@"$"];
            
            if([arr count] == 3){
                
//                方法序号
                NSString *code = [arr objectAtIndex:1];
                NSString *msg = [arr objectAtIndex:2]; //身份认证返回状态&服务端程序版本号&房间数据库版本&设备数据库版本&情景数据库版本&摄像头数据库版本
                
                switch ([code intValue]) {
                    case 0: //身份验证
                    {
                        NSArray *tempArray = [msg componentsSeparatedByString:@"&"];
                        NSString *tempMsg = [tempArray objectAtIndex:0];
                        
                        if ([tempMsg isEqualToString:@"1"] || [tempMsg isEqualToString:@"0"]) { //登入成功，0和1为是否为主控设备
                            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                            [user setObject:tempMsg forKey:MASTER];
                            [user synchronize];
                            self.isConnection= YES;
                            connectSuccess(msg);
                        }else{
                            if ([tempMsg isEqualToString:@"403"]) {
                                connectFail(nil, @"无权限登入");
                            }else if ([tempMsg isEqualToString:@"409"]) {
                                connectFail(nil, @"连接数已满");
                            }else {
                                connectFail(nil,nil);
                            }
                        }
                    }
                        break;
                        
                    case 1: //同步数据
                    {
                        synchronousBlock(msg);
                    }
                        break;
                        
                    case 2: //验证登入
                    {
                        loginBlock(msg);
                    }
                        break;
                        
                    case 3: //开始等待设备添加
                    {
                        deviceAddBlock(msg);
                    }
                        break;
                        
                    case 4: //编辑设备
                    {
                        deviceEditBlock(msg);
                    }
                        break;
                        
                    case 5: //编辑设备路
                    {
                        editDeviceLineBlock(msg);
                    }
                        break;
                        
                    case 6: //控制设备，开关类
                    {
                        switchDeviceBlock(msg);
                    }
                        break;
                        
                    case 7: //读取设备状态
                    {
                        getDeviceStatusBlock(msg);
                    }
                        break;
                        
                    case 8: //移动红外设备添加
                    {
                        addRemoteBlock(msg);
                    }
                        break;
                        
                    case 9: //移动红外设备控制
                    {
                        switchRemoteBlock(msg);
                    }
                        break;
                        
                    case 10: //遥控编辑
                    {
                        eidtRemoteBlock(msg);
                    }
                        break;
                        
                    case 11: //添加修改情景
                    {
                        editSenceBlock(msg);
                    }
                        break;
                        
                    case 12: //删除情景
                    {
                        deleteSenceBlock(msg);
                    }
                        break;
                        
                    case 13: //添加修改情景设备
                    {
                        editSenceDeviceBlock(msg);
                    }
                        break;
                        
                    case 15: //启动情景
                    {
                        senceStartBlock(msg);
                    }
                        break;
                        
                    case 16: //删除设备
                    {
                        deleteDeviceBlock(msg);
                    }
                        break;
                        
                    case 17: //添加短信接收号码
                    {
                        contactPeopleBlock(msg);
                    }
                        break;
                        
                    case 18: //联动设备添加修改
                    {
                        linkDeviceEditBlock(msg);
                    }
                        break;
                        
                    case 19: //删除联动设备
                    {
                        linkDeviceDeleteBlock(msg);
                    }
                        break;
                        
                    case 20: //添加摄像头
                    {
                        addMonitorBlock(msg);
                    }
                        break;
                        
                    case 21: //搜索摄像头
                    {
                        searchMonitorListBlock(msg);
                    }
                        break;
                        
                    case 22: //wifi连接
                    {
                        wifiEditBlock(msg);
                    }
                        break;
                        
                    case 23: //联动开关
                    {
                        linkSwitchBlock(msg);
                    }
                        break;
                        
                    case 24: //wifi列表
                    {
                        wifiListBlock(msg);
                    }
                        break;
                        
                    case 25: //删除摄像头
                    {
                        deleteMonitorBlock(msg);
                    }
                        break;
                        
                    case 30: //添加房间
                    {
                        addRoomsBlock(msg);
                    }
                        break;
                        
                    case 31: //修改房间
                    {
                        updateRoomsBlock(msg);
                    }
                        break;
                    
                    case 32: //删除房间
                    {
                        deleteRoomsBlock(msg);
                    }
                        break;
                        
                    case 33:
                    {
                        getMusicListBlock(msg);
                    }
                        break;
                        
                    case 34:
                    {
                        getSenceMusicBlock(msg);
                    }
                        break;
                        
                    case 35:
                    {
                        getEntityAttributaBlock(msg);
                    }
                        break;
                        
                    case 36:
                    {
                        newRemoteMatchSearchBlock(msg);
                    }
                        break;
                    
                    case 60: //获取设备版本
                    {
                        NSArray *array = [msg componentsSeparatedByString:@"&"];
                        if ([array count] >= 3) {
                            NSString *type = [array objectAtIndex:1];
                            if ([type isEqualToString:@"1"]) {
                                getDeviceVersionBlock(msg);
                            }else if ([type isEqualToString:@"2"]) {
                                getSenceVersionBlock(msg);
                            }else if ([type isEqualToString:@"3"]) {
                                getCameraInfosVersionBlock(msg);
                            }else if ([type isEqualToString:@"4"]) {
                                getRoomsListBlock(msg);
                            }
                        }
                    }
                        break;
                        
                    case 61: //获取设备数组
                    {
                        if (getDeviceArrayBlock) {
                            getDeviceArrayBlock(msg);
                        }
                    }
                        break;
                        
                    case 62: //获取设备路
                    {
                        if (getEntityLineBlock) {
                            getEntityLineBlock(msg);
                        }
                    }
                        break;
                        
                    case 63: //获取红外设备
                    {
                        if (getInfraredBlock) {
                            getInfraredBlock(msg);
                        }
                    }
                        break;
                        
                    case 64: //获取联动设备
                    {
                        if (getEntityLinkBlock) {
                            getEntityLinkBlock(msg);
                        }
                    }
                        break;
                        
                    case 65: //获取报警电话
                    {
                        if (getAlarmphoneBlock) {
                            getAlarmphoneBlock(msg);
                        }
                    }
                        break;
                        
                    case 66: //获取情景数组
                    {
                        if (getSenceArrayBlock) {
                            getSenceArrayBlock(msg);
                        }
                    }
                        break;
                        
                    case 67: //获取情景设备
                    {
                        if (getSenceEntityBlock) {
                            getSenceEntityBlock(msg);
                        }
                    }
                        break;
                        
                    case 68: //获取视频设备
                    {
                        if (getCameraInfosBlock) {
                            getCameraInfosBlock(msg);
                        }
                    }
                        break;
                        
                    case 69: //获取红外报警信息
                    {
                        if (getAlarmInfosBlock) {
                            getAlarmInfosBlock(msg);
                        }
                    }
                        break;
                        
                    case 71: //获取设备反向控制
                    {
                        if (getDeviceReverseControlBlock) {
                            getDeviceReverseControlBlock(msg);
                        }
                    }
                        
                    case 90: //控制设备，开关类 帧
                    {
                        if (switchDeviceFrameBlock) {
                            switchDeviceFrameBlock(msg);
                        }
                    }
                        break;
                        
                    case 89: //音乐
                    {
                        if (senceMusicingBlock) {
                            senceMusicingBlock(msg);
                        }
                    }
                        
                    case 88: //通知数据更新
                    {
                        if (noticeBlock) {
                            noticeBlock(msg);
                        }
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
}

-(NSTimeInterval) onSocket:(AsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    return 5;
}

-(NSTimeInterval) onSocket:(AsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    return 5;
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    printf("error:%s",[[err description] cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void) onSocketDidDisconnect:(AsyncSocket *)sock
{
    printf("%s\n","断线重连");
    self.failSecond ++;
    if (self.failSecond  >= 3) {
        self.failSecond = 0;
        connectFail(nil,nil);
        return;
    }
    self.isConnection = NO;
    if (_isNetwork) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self connectService:_connectIp
                      didConnectType:_connectType
                          didSuccess:connectSuccess
                                Fail:connectFail
                 ];
            });
        });
    }
}

#pragma mark -
#pragma mark util
//设置开关类回调广播帧
-(void) setSwitchBlock:(CallBackParamBlock)block
{
    switchDeviceFrameBlock = block;
}

-(void) setSenceMusiceBlock:(CallBackParamBlock)block
{
    senceMusicingBlock = block;
}

#pragma mark - 通知数据更新
-(void) noticeSynchronization:(CallBackParamBlock)block
{
    noticeBlock = block;
}

//数据格式化
-(void) writeFormatDataAction:(NSString *)methodCode didMsg:(NSString *)msg didCallBack:(void (^) (NSString *))block
{
    if ([methodCode isEqualToString:@"1"]) {
        synchronousBlock = block;
    }else if ([methodCode isEqualToString:@"2"]) {
        loginBlock = block;
    }else if ([methodCode isEqualToString:@"3"]) {
        deviceAddBlock = block;
    }else if ([methodCode isEqualToString:@"4"]) {
        deviceEditBlock = block;
    }else if ([methodCode isEqualToString:@"5"]) {
        editDeviceLineBlock = block;
    }else if ([methodCode isEqualToString:@"6"]) {
        switchDeviceBlock = block;
    }else if ([methodCode isEqualToString:@"7"]) {
        getDeviceStatusBlock = block;
    }else if ([methodCode isEqualToString:@"8"]) {
        addRemoteBlock = block;
    }else if ([methodCode isEqualToString:@"9"]) {
        switchRemoteBlock = block;
    }else if ([methodCode isEqualToString:@"10"]) {
        eidtRemoteBlock = block;
    }else if ([methodCode isEqualToString:@"11"]) {
        editSenceBlock = block;
    }else if ([methodCode isEqualToString:@"12"]) {
        deleteSenceBlock = block;
    }else if ([methodCode isEqualToString:@"13"]) {
        editSenceDeviceBlock = block;
    }else if ([methodCode isEqualToString:@"15"]) {
        senceStartBlock = block;
    }else if ([methodCode isEqualToString:@"16"]) {
        deleteDeviceBlock = block;
    }else if ([methodCode isEqualToString:@"17"]) {
        contactPeopleBlock = block;
    }else if ([methodCode isEqualToString:@"18"]) {
        linkDeviceEditBlock = block;
    }else if ([methodCode isEqualToString:@"19"]) {
        linkDeviceDeleteBlock = block;
    }else if ([methodCode isEqualToString:@"20"]) {
        addMonitorBlock = block;
    }else if ([methodCode isEqualToString:@"21"]) {
        searchMonitorListBlock = block;
    }else if ([methodCode isEqualToString:@"22"]) {
        wifiEditBlock = block;
    }else if ([methodCode isEqualToString:@"23"]) {
        linkSwitchBlock = block;
    }else if ([methodCode isEqualToString:@"24"]) {
        wifiListBlock = block;
    }else if ([methodCode isEqualToString:@"25"]) {
        deleteMonitorBlock = block;
    }else if ([methodCode isEqualToString:@"30"]) {
        addRoomsBlock = block;
    }else if ([methodCode isEqualToString:@"31"]) {
        updateRoomsBlock = block;
    }else if ([methodCode isEqualToString:@"32"]) {
        deleteRoomsBlock = block;
    }else if ([methodCode isEqualToString:@"33"]) {
        getMusicListBlock = block;
    }else if ([methodCode isEqualToString:@"34"]) {
        getSenceMusicBlock = block;
    }else if ([methodCode isEqualToString:@"35"]) {
        getEntityAttributaBlock = block;
    }else if ([methodCode isEqualToString:@"36"]) {
        newRemoteMatchSearchBlock = block;
    }
    else if ([methodCode isEqualToString:@"60"]) {
        
        NSArray *array = [msg componentsSeparatedByString:@"&"];
        if ([array count] == 2) {
            NSString *type = [array objectAtIndex:1];
            if ([type isEqualToString:@"1"]) {
                getDeviceVersionBlock = block;
            }else if ([type isEqualToString:@"2"]) {
                getSenceVersionBlock = block;
            }else if ([type isEqualToString:@"3"]) {
                getCameraInfosVersionBlock = block;
            }else if ([type isEqualToString:@"4"]) {
                getRoomsListBlock = block;
            }
        }
        
    }else if ([methodCode isEqualToString:@"61"]) {
        getDeviceArrayBlock = block;
    }else if ([methodCode isEqualToString:@"62"]) {
        getEntityLineBlock = block;
    }else if ([methodCode isEqualToString:@"63"]) {
        getInfraredBlock = block;
    }else if ([methodCode isEqualToString:@"64"]) {
        getEntityLinkBlock = block;
    }else if ([methodCode isEqualToString:@"65"]) {
        getAlarmphoneBlock = block;
    }else if ([methodCode isEqualToString:@"66"]) {
        getSenceArrayBlock = block;
    }else if ([methodCode isEqualToString:@"67"]) {
        getSenceEntityBlock = block;
    }else if ([methodCode isEqualToString:@"68"]) {
        getCameraInfosBlock = block;
    }else if ([methodCode isEqualToString:@"69"]) {
        getAlarmInfosBlock = block;
    }else if ([methodCode isEqualToString:@"71"]) {
        getDeviceReverseControlBlock = block;
    }
    NSString *msgStr = [NSString stringWithFormat:@"$$%d$%@$%@",number++,methodCode,msg];
    NSLog(@"发送数据:%@",msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendData:msgStr];
    });
}

//发送认证数据  第一次发送认证信息需要加上rsa密码，以后就用这个密码
-(void) sendAuthenticateData:(NSString *)bodyStr
{
//    AES密码
    NSData *keyData = [@"1A2B3C4D5E6F010203040506A7B8C9D0" dataUsingEncoding:NSUTF8StringEncoding];
    rsaPassword = @"1A2B3C4D5E6F010203040506A7B8C9D0";
    
//    RSA加密AES密码
    NSString *keyStr = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
    CRSA *m_crsa = [CRSA shareInstance];
    
    NSData *AESPassword;
    if ([_connectType isEqualToString:@"200"]) {
        [m_crsa importRSAKeyWithType:KeyTypeB];
        AESPassword = [m_crsa encryptByRsa:keyStr withKeyType:KeyTypeB];
    }else {
        [m_crsa importRSAKeyWithType:KeyTypeC];
        AESPassword = [m_crsa encryptByRsa:keyStr withKeyType:KeyTypeC];
    }
    
    NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *bodyAES = [bodyData AES256EncryptWithKey:keyData];
    
    NSMutableData *sendData = [[NSMutableData alloc] initWithCapacity:0];
    if ([_connectType isEqualToString:@"200"]) {
        [sendData appendData:[@"start" dataUsingEncoding:NSUTF8StringEncoding]];
        [sendData appendData:[@"5" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [sendData appendData:AESPassword];
    [sendData appendData:bodyAES];
    if ([_connectType isEqualToString:@"200"]) {
        [sendData appendData:[@"end" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [_tcp_socket writeData:sendData withTimeout:5 tag:0];
    [_tcp_socket readDataWithTimeout:-1 tag:0];
}

//发送数据
-(void) sendData:(NSString *)bodyStr
{
//    AES密码
    NSData *keyData = [rsaPassword dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *bodyAES = [bodyData AES256EncryptWithKey:keyData];
    
    NSMutableData *sendData = [[NSMutableData alloc] initWithCapacity:0];
    [sendData appendData:[@"start" dataUsingEncoding:NSUTF8StringEncoding]];
    [sendData appendData:[@"5" dataUsingEncoding:NSUTF8StringEncoding]];
    [sendData appendData:bodyAES];
    [sendData appendData:[@"end" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [_tcp_socket writeData:sendData withTimeout:5 tag:0];
    [_tcp_socket readDataWithTimeout:-1 tag:0];
}

//解密
-(NSString *) getTextInfo:(Byte *)byte password:(NSString *)password leng:(int)leng
{
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSData *textData = [[NSData alloc] initWithBytes:byte length:leng];
    NSData *tempText = [textData AES256DecryptWithKey:passwordData];
    return [[NSString alloc] initWithData:tempText encoding:NSUTF8StringEncoding];
}

//data截取成byte
-(Byte *) dataToByte:(NSData *)data didFrom:(int )fromIndex didTo:(int)Toindex
{
    if (fromIndex >= Toindex) {
        return nil;
    }
    Byte *byteDate = (Byte *)[data bytes];
    Byte *byte = (Byte *)malloc(Toindex - fromIndex);
    
    int j = 0;
    for (int i=fromIndex; i<Toindex; i++) {
        byte[j++] = byteDate[i];
    }
    return byte;
}

-(int) byteToInt:(Byte*)byte
{
    int v0 = (byte[3] & 0xFF);
    int v1 = (byte[2] & 0xFF) << 8;
    int v2 = (byte[1] & 0xFF) << 16;
    int v3 = (byte[0] & 0xFF) << 24;
    return v0 + v1 + v2 + v3;
    return v0;
}

+(void) POST:(NSString *)baseURL
         url:(NSString *)url
  parameters:(NSDictionary *)dic
     success:(void (^)(NSURLSessionDataTask *, id))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    AFAppDotNetAPIClient *client = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    client.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [client POST:url
      parameters:dic
         success:^(NSURLSessionDataTask *task, id result) {
             
        id response = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        success(task, response);
             
    }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             failure(task, error);
    }];
}

@end
