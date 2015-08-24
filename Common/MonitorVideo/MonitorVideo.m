//
//  MonitorVideo.m
//  Home
//
//  Created by 刘军林 on 14-9-3.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MonitorVideo.h"
#import "Interface.h"
#import "URL.h"
#import "WFSearchResult.h"

#import "APICommon.h"
#import "PPPPDefine.h"
#import "obj_common.h"
#import "SearchDVS.h"

#define GPS_P2P_MOVE_LEFT 0
#define GPS_P2P_MOVE_RIGHT 1
#define GPS_P2P_MOVE_TOP 2
#define GPS_P2P_MOVE_BOTTOM 3

@interface MonitorVideo ()

@property (nonatomic, strong) NSCondition *m_PPPPChannelMgtCondition;
@property (nonatomic, strong) NSString *cameraID;
@property (nonatomic, assign) BOOL m_bPtzIsUpdown;
@property (nonatomic, assign) BOOL m_bPtzIsLeftRight;

@end

static MonitorVideo *shareInterface;

@implementation MonitorVideo
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isAudio = NO;
        if (!_moveDirection) {
            _moveDirection = [[UIImageView alloc] initWithFrame:CGRectZero];
            _moveDirection.translatesAutoresizingMaskIntoConstraints = NO;
            _moveDirection.hidden = YES;
            [self addSubview:_moveDirection];
            _moveDirection.animationImages = @[[UIImage imageNamed:@"video_ress_01.png"],
                                               [UIImage imageNamed:@"video_ress_02.png"],
                                               [UIImage imageNamed:@"video_ress_03.png"]];
            
            NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:_moveDirection attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30];
            [_moveDirection addConstraint:width];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_moveDirection attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30];
            [_moveDirection addConstraint:height];
            
            _moveDirection_X = [NSLayoutConstraint constraintWithItem:_moveDirection attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];
            [self addConstraint:_moveDirection_X];
            
            _moveDirection_Y = [NSLayoutConstraint constraintWithItem:_moveDirection attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
            [self addConstraint:_moveDirection_Y];
            
            _moveDirection.animationDuration = 0.5;
            _moveDirection.animationRepeatCount = -1;
        }
        
        if (!_loadActivity) {
            _loadActivity = [[UIActivityIndicatorView alloc] init];
            _loadActivity.hidesWhenStopped = YES;
            _loadActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [self addSubview:_loadActivity];
            
            _loadActivity.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_loadActivity attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            [self addConstraint:centerX];
            
            NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_loadActivity attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
            [self addConstraint:centerY];
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_loadActivity attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
            [_loadActivity addConstraint:width];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_loadActivity attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
            [_loadActivity addConstraint:height];
        }
        
        if (!_isWifiLib) {
            _isWifiLib = [[UILabel alloc] initWithFrame:CGRectMake(50, 115, 220, 40)];
            [_isWifiLib setBackgroundColor:[UIColor clearColor]];
            [_isWifiLib setFont:[UIFont systemFontOfSize:12.0f]];
            _isWifiLib.textColor = [UIColor redColor];
            _isWifiLib.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_isWifiLib];
            
            _isWifiLib.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_isWifiLib attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            [self addConstraint:centerX];
            
            NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_isWifiLib attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:25.0f];
            [self addConstraint:centerY];
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_isWifiLib attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220.0f];
            [_isWifiLib addConstraint:width];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_isWifiLib attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40.0f];
            [_isWifiLib addConstraint:height];
        }

        if (!_timeLab) {
            _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 220, 20)];
            _timeLab.backgroundColor = [UIColor clearColor];
            _timeLab.textColor = [UIColor whiteColor];
            _timeLab.font = [UIFont systemFontOfSize:13.0f];
            _timeLab.textAlignment = NSTextAlignmentLeft;
            [self addSubview:_timeLab];
            
            _timeLab.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:_timeLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10.0f];
            [self addConstraint:centerX];
            
            NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:_timeLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:5.0f];
            [self addConstraint:centerY];
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_timeLab attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220.0f];
            [_timeLab addConstraint:width];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_timeLab attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:20.0f];
            [_timeLab addConstraint:height];
        }
        
        if (!_moveImg) {
            _moveImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            [_moveImg setImage:[UIImage imageNamed:@"pan.png"]];
            _moveImg.hidden = YES;
            [self addSubview:_moveImg];
        }
        
        if (!_closeBut) {
            _closeBut = [[UIButton alloc] initWithFrame:CGRectZero];
            [_closeBut setImage:[UIImage imageNamed:@"button_error.png"]
                       forState:UIControlStateHighlighted];
            [_closeBut setImage:[UIImage imageNamed:@"button_error.png"]
                       forState:UIControlStateNormal];
            _closeBut.userInteractionEnabled = YES;
            [_closeBut addTarget:nil
                          action:@selector(closeMonitorP2PAction)
                forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_closeBut];
            
            _closeBut.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_closeBut attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
            [self addConstraint:top];
            
            NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_closeBut attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f];
            [self addConstraint:right];
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_closeBut attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:46];
            [_closeBut addConstraint:width];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_closeBut attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:46];
            [_closeBut addConstraint:height];
        }
        
        if (!_audioBut) {
            _audioBut = [[UIButton alloc] initWithFrame:CGRectZero];
//            [_audioBut setTitle:@"声音" forState:UIControlStateNormal];
            
            [_audioBut setImage:[UIImage imageNamed:@"icon_vedio_v.png"]
                       forState:UIControlStateNormal];
            [_audioBut setImage:[UIImage imageNamed:@"icon_vedio_vj.png"]
                       forState:UIControlStateSelected];
            
            _audioBut.userInteractionEnabled = YES;
            [_audioBut addTarget:self action:@selector(starAudio:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_audioBut];
            _audioBut.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_audioBut attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:55];
            [self addConstraint:top];
            
            NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_audioBut attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.f];
            [self addConstraint:right];
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_audioBut attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:46];
            [_audioBut addConstraint:width];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_audioBut attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:46];
            [_audioBut addConstraint:height];
        }
        
        if (!_reversalBut) {
            _reversalBut = [[UIButton alloc] initWithFrame:CGRectZero];
//            [_reversalBut setTitle:@"反转" forState:UIControlStateNormal];
            [_reversalBut setImage:[UIImage imageNamed:@"icon_vedio_r.png"]
                       forState:UIControlStateNormal];
            _reversalBut.userInteractionEnabled = YES;
            [_reversalBut addTarget:self action:@selector(mirrorImage) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_reversalBut];
            _reversalBut.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_reversalBut attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:120];
            [self addConstraint:top];
            
            NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_reversalBut attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.f];
            [self addConstraint:right];
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_reversalBut attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:46];
            [_reversalBut addConstraint:width];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_reversalBut attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:46];
            [_reversalBut addConstraint:height];
        }
        
        if (!_backBut) {
            _backBut = [[UIButton alloc] initWithFrame:CGRectZero];
            [_backBut setImage:[UIImage imageNamed:@"button_back1.png"]
                      forState:UIControlStateNormal];
            [_backBut setImage:[UIImage imageNamed:@"button_back1.png"]
                      forState:UIControlStateHighlighted];
            _backBut.userInteractionEnabled = YES;
            [_backBut addTarget:nil
                         action:@selector(backMonitor)
               forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_backBut];
            
            _backBut.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_backBut attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];
            [self addConstraint:left];
            
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_backBut attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
            [self addConstraint:top];
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:_backBut attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:68.f];
            [_backBut addConstraint:width];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:_backBut attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:42.f];
            [_backBut addConstraint:height];
            
            _backBut.hidden = YES;
        }
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:panGes];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTap];
        [panGes requireGestureRecognizerToFail:doubleTap];
        
        AHReach *reach = [AHReach reachForDefaultHost];
        [reach startUpdatingWithBlock:^(AHReach *reach){
            [self setIsWifiText:self.isWifiLib WithReach:reach];
        }];
        [self setIsWifiText:self.isWifiLib WithReach:reach];
        self.reachs = [NSArray arrayWithObjects:reach, nil];
        isMoveTimerStart = NO;
        
        [self setImage:[UIImage imageNamed:@"pic_vedio.png"]];
        self.userInteractionEnabled = YES;
        [self Initialize];
        
        _isOpen = NO;
//        _isNetwork = YES;
    }
    return self;
}

+(MonitorVideo *) shareMonitorVideo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shareInterface) {
            shareInterface = [[MonitorVideo alloc] initWithFrame:CGRectZero];
        }
    });
    shareInterface.audioBut.hidden = NO;
    shareInterface.reversalBut.hidden = NO;
    shareInterface.isPanges = YES;
    return shareInterface;
}

//视频关闭
-(void) closeMonitorP2PAction
{
    _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
    _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
    _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
//    _m_PPPPChannelMgt->
    if (currentRecordFile) {
        _m_PPPPChannelMgt -> PPPPStopPlayback((char *)[currentRecordFile UTF8String]);
        
        NSLog(@"关闭回放");
    }
    
    self.audioBut.selected = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImage:[UIImage imageNamed:@"pic_vedio.png"]];
    });
//    [self stopAll];
    _cameraID = nil;
    self.isOpenMonitor = NO;
    if ([delegate respondsToSelector:@selector(closeMonitorAction)]) {
        [delegate closeMonitorAction];
    }
}

//打开视频声音
-(void) starAudio:(id)sender
{
    if (isAudio) {
        _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
        _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
    }else{
        _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
        _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
    }
    isAudio = !isAudio;
    UIButton *but = (UIButton *)sender;
    but.selected = isAudio;
}

-(void) mirrorImage
{
    switch (flip) {
        case 0:
            flip = 3;
            break;
        case 1:
            flip = 0;
            break;
        case 2:
            flip = 3;
            break;
        case 3:
            flip = 0;
            break;
        default:
            break;
    }
    
    _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5,flip);
    NSLog(@"*****************************%d",flip);
}

-(void) Initialize
{
    _m_PPPPChannelMgt = new CPPPPChannelManagement();
    _m_PPPPChannelMgt -> pCameraViewController = self;
    _m_bPtzIsLeftRight = NO;
    _m_bPtzIsUpdown = NO;
//    InitAudioSession();
    //    EBGBEMBMKGJMGAJPEIGIFKEGHBMCHMJHCKBMBHGFBJNOLCOLCIEBHFOCCHKKJIKPBNMHLHCPPFMFADDFIINOIABFMH
    //    BJHJAABPPKMBDNMABCDGEMALHMNECFNCDBAFBBGAALMMLPLHDLAMCAOECIKBMMOAAFJOLBDHLMNCEFCGMPIEMMFJJBKDBBHMAFCJHABDIEKE
    PPPP_Initialize((char *)[@"BJHJAABPPKMBDNMABCDGEMALHMNECFNCDBAFBBGAALMMLPLHDLAMCAOECIKBMMOAAFJOLBDHLMNCEFCGMPIEMMFJJBKDBBHMAFCJHABDIEKE" UTF8String]);
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
    
    _startMonitor_list = [[NSMutableArray alloc] initWithCapacity:0];
    _p2p_MonitorStatus = [[NSMutableDictionary alloc] initWithCapacity:0];
}

-(void) stopAll
{
    _m_PPPPChannelMgt -> StopAll();
    
    [_p2p_timer invalidate];
    _p2p_timer = nil;
}

-(void) contentmonitorP2P:(NSString *)mCameraID
{
    [_p2p_MonitorStatus setValue:@"" forKey:mCameraID];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_m_PPPPChannelMgtCondition lock];
        if (_m_PPPPChannelMgt == NULL) {
            [_m_PPPPChannelMgtCondition unlock];
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadActivity startAnimating];
            self.image = [UIImage imageNamed:@"pic_vedio.png"];
        });
        
        [self performSelector:@selector(startPPPP:) withObject:mCameraID];
        [_m_PPPPChannelMgtCondition unlock];
    });
}

-(void) starMonitorViewP2P:(NSString *)mCameraID
{
    self.isOpenMonitor = YES;
    if (_cameraID) {
        _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
    }
    if (currentRecordFile) {
        _m_PPPPChannelMgt -> PPPPStopPlayback((char *)[currentRecordFile UTF8String]);
    }
    _cameraID = mCameraID;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_loadActivity stopAnimating];
        [self.loadActivity startAnimating];
        
        NSString *status = [_p2p_MonitorStatus objectForKey:mCameraID];
        if ([status isEqualToString:STATUS_CONNECTING_SUCCESS] || [status isEqualToString:STATUS_CONNECTING_TEXT]) {
            if ([status isEqualToString:STATUS_CONNECTING_TEXT]) {
                _isWifiLib.textColor = [UIColor grayColor];
                _isWifiLib.text = status;
            }else{
                _isWifiLib.text = @"";
            }
        }else{
            [self.loadActivity stopAnimating];
            _isWifiLib.textColor = [UIColor redColor];
            _isWifiLib.text= status;
        }
    });
    [_startMonitor_list addObject:mCameraID];
    if (_m_PPPPChannelMgt != NULL) {
        if (_m_PPPPChannelMgt->StartPPPPLivestream([mCameraID UTF8String], 10, self) == 0) {
            _m_PPPPChannelMgt -> StopPPPPAudio([mCameraID UTF8String]);
            _m_PPPPChannelMgt -> StopPPPPLivestream([mCameraID UTF8String]);
        }
        _m_PPPPChannelMgt -> GetCGI([mCameraID UTF8String], CGI_IEGET_CAM_PARAMS);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _p2p_dataLeng = 0;
        if (_p2p_timer) {
            [_p2p_timer invalidate];
            _p2p_timer = nil;
        }
        _p2p_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerActionP2P) userInfo:nil repeats:YES];
    });
}

-(void) searchSDRecordFileList:(NSString *)SSID pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    _recordFile_list = [[NSMutableArray alloc] initWithCapacity:0];
    _m_PPPPChannelMgt -> SetSDCardSearchDelegate((char *)[SSID UTF8String], self);
    _m_PPPPChannelMgt -> PPPPGetSDCardRecordFileList((char *)[SSID UTF8String], pageIndex , pageSize);
}

-(void) openBackPlayMonitor:(NSString *)SSID RecordFile:(NSString *)recordFile
{
    _m_PPPPChannelMgt -> SetPlaybackDelegate((char *)[SSID UTF8String], self);
    if (currentRecordFile) {
        _m_PPPPChannelMgt -> PPPPStopPlayback((char *)[currentRecordFile UTF8String]);
    }
    _m_PPPPChannelMgt->StopPPPPLivestream((char *)[SSID UTF8String]);
    currentRecordFile = recordFile;
    _m_PPPPChannelMgt -> PPPPStartPlayback((char *)[SSID UTF8String], (char *)[recordFile UTF8String], 0);
    _cameraID = SSID;
    
    if (!self.isOpenMonitor) {
        [delegate openBackPlayAction];
    }
    self.isOpenMonitor = YES;
}

-(void) closeBackPlayMonitor:(NSString *)SSID
{
    _m_PPPPChannelMgt -> PPPPStopPlayback((char *)[SSID UTF8String]);
}

-(void) rebootDeviceCamersId:(NSString *)camersId
{
    _m_PPPPChannelMgt -> PPPPSetSystemParams((char *)[camersId UTF8String], MSG_TYPE_REBOOT_DEVICE, NULL, 0);
}

-(void) startCurrentWifiSearch:(NSString *)SSID
{
    _m_PPPPChannelMgt ->SetWifiParamDelegate((char *)[SSID UTF8String], self);
    _m_PPPPChannelMgt -> PPPPSetSystemParams((char *)[SSID UTF8String], MSG_TYPE_GET_PARAMS, nil, 0);
    _wifi_list = [[NSMutableArray alloc] initWithCapacity:0];
}

-(void) startWifiListSearch:(NSString *)SSID
{
    _m_PPPPChannelMgt ->SetWifiParamDelegate((char *)[SSID UTF8String], self);
    _m_PPPPChannelMgt -> PPPPSetSystemParams((char *)[SSID UTF8String], MSG_TYPE_WIFI_SCAN, nil, 0);
}

-(void) setWifi:(WFSearchResult *)wf didWifi:(NSString *)wifi didPwd:(NSString *)pwd
{
    char a = ' ';
    _setWifiDid = wf.strDID;
    _m_PPPPChannelMgt -> SetWifi((char *)[wf.strDID UTF8String], 1, (char *)[wf.strSSID UTF8String], wf.channel, wf.mode, wf.security, 0, 0, 0, &a , &a, &a, &a, 0, 0, 0, 0, (char *)[pwd UTF8String]);
}

-(void) WifiScanResult:(NSString *)strDID ssid:(NSString *)strSSID mac:(NSString *)strMac security:(NSInteger)security db0:(NSInteger)db0 db1:(NSInteger)db1 mode:(NSInteger)mode channel:(NSInteger)channel bEnd:(NSInteger)bEnd
{
    WFSearchResult *searchResult = [[WFSearchResult alloc] init];
    searchResult.strDID = strDID;
    searchResult.strSSID = strSSID;
    searchResult.strMac = strMac;
    searchResult.security = security;
    searchResult.db0 = db0;
    searchResult.db1 = db1;
    searchResult.mode = mode;
    searchResult.channel = channel;

    if (![_wifi_list containsObject:searchResult]) {
        [_wifi_list addObject:searchResult];
    }
    
    if (bEnd  == 1) {
        if ([delegate respondsToSelector:@selector(connectWifiList)]) {
            [delegate connectWifiList];
        }
    }
}

-(void) setWifiCanResult:(NSString *) strDiD type:(NSInteger)type len:(NSInteger)len
{
    [self rebootDeviceCamersId:_setWifiDid];
}

-(void) WifiParams:(NSString *)strDID enable:(NSInteger)enable ssid:(NSString *)strSSID channel:(NSInteger)channel mode:(NSInteger)mode authtype:(NSInteger)authtype encryp:(NSInteger)encryp keyformat:(NSInteger)keyformat defkey:(NSInteger)defkey strKey1:(NSString *)strKey1 strKey2:(NSString *)strKey2 strKey3:(NSString *)strKey3 strKey4:(NSString *)strKey4 key1_bits:(NSInteger)key1_bits key2_bits:(NSInteger)key2_bits key3_bits:(NSInteger)key3_bits key4_bits:(NSInteger)key4_bits wpa_psk:(NSString *)wpa_psk
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([delegate respondsToSelector:@selector(connectCurrentWifi)]) {
            _current_wifi = strSSID;
            [delegate connectCurrentWifi];
        }
    });
}

-(void) timerActionP2P{
    if (_p2p_timeInterval < 100000) {
        return;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_p2p_timeInterval];
    //    NSLog(@"data:%@",date);
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    [dateFor setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateStr = [dateFor stringFromDate:date];
//    NSLog(@"dateStr:%@",dateStr);
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeLab.text = [NSString stringWithFormat:@"%@ %dkb/s",dateStr, _p2p_dataLeng / 1024];
        _p2p_dataLeng = 0;
    });
}

-(void) startPPPP:(NSString *)camID
{
    _m_PPPPChannelMgt->Start([camID UTF8String], [@"admin" UTF8String], [@"888888" UTF8String]);
}

-(void) refreshImage:(UIImage *)image {
    if (image != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadActivity stopAnimating];
            self.image = image;
            _isWifiLib.text = @"";
        });
    }
}

#pragma mark -
#pragma mark SDCardRecordFileSearchProtocol
-(void) SDCardRecordFileSearchResult:(NSString *)strFileName fileSize:(NSInteger)fileSize bEnd:(BOOL)bEnd
{
    if (bEnd) {
        [delegate searchSDCardRecordFileList:_recordFile_list];
    }else{
        [_recordFile_list addObject:strFileName];
    }
}

#pragma mark -
#pragma mark ImageNotifyProtocol
-(void) ImageNotify:(UIImage *)image timestamp:(NSInteger)timestamp DID:(NSString *)did
{
    [self performSelector:@selector(refreshImage:) withObject:image];
}

-(void) YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did
{
    NSLog(@"%d",timestamp);
    _p2p_timeInterval = timestamp;
    if ([did isEqualToString:_cameraID]) {
        UIImage *image = [APICommon YUV420ToImage:yuv width:width height:height];
        [self performSelector:@selector(refreshImage:) withObject:image];
    }
}

#pragma mark -
#pragma mark ParamNotifyProtocol
-(void) ParamNotify:(int)paramType params:(void *)params
{
    if (paramType == CGI_IEGET_CAM_PARAMS) {
        PSTRU_CAMERA_PARAM param = (PSTRU_CAMERA_PARAM)params;
        flip = param->flip;
    }
    NSLog(@"paramNotify");
}

-(void) connectStatus:(NSString *)ssdid didStatus:(NSString *) statusStr
{
    [_p2p_MonitorStatus setObject:statusStr forKey:ssdid];
    if ([delegate respondsToSelector:@selector(connectStatusChange:didSSID:)]) {
        [delegate connectStatusChange:statusStr didSSID:ssdid];
    }
}

//PPPPStatusDelegate
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSString* strPPPPStatus;
    if (!_isNetwork) {
        _isOpen = NO;
        return;
    }
    switch (status) {
        case PPPP_STATUS_UNKNOWN:
        {
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(startPPPP:) withObject:strDID];
                if ([strDID isEqualToString:_cameraID]) {
                    _isWifiLib.textColor = [UIColor redColor];
                    _isWifiLib.text = STATUS_UNKNOWN_TEXT;
                }
            });
            [self connectStatus:strDID didStatus:STATUS_UNKNOWN_TEXT];
        }
            break;
        case PPPP_STATUS_CONNECTING:
        {
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([strDID isEqualToString:_cameraID]) {
                    _isWifiLib.textColor = [UIColor grayColor];
                    _isWifiLib.text = STATUS_CONNECTING_TEXT;
                    [_loadActivity startAnimating];
                 }
            });
            
            [self connectStatus:strDID didStatus:STATUS_CONNECTING_TEXT];
        }
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
        {
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(startPPPP:) withObject:strDID];
                if ([strDID isEqualToString:_cameraID]) {

                    _isWifiLib.textColor = [UIColor redColor];
                    _isWifiLib.text = STATUS_CONNECT_FAILED_TEXT;
                }
            });
            [self connectStatus:strDID didStatus:STATUS_CONNECT_FAILED_TEXT];
        }

            break;
        case PPPP_STATUS_DISCONNECT:
        {
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(startPPPP:) withObject:strDID];
                if ([strDID isEqualToString:_cameraID]) {
                    _isWifiLib.textColor = [UIColor redColor];
                    _isWifiLib.text = STATUS_DISCONNECTED_TEXT;
                }

            });
            [self connectStatus:strDID didStatus:STATUS_DISCONNECTED_TEXT];
        }

            break;
        case PPPP_STATUS_INVALID_ID:
        {
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(startPPPP:) withObject:strDID];
                 if ([strDID isEqualToString:_cameraID]) {
                     _isWifiLib.textColor = [UIColor redColor];
                     _isWifiLib.text = STATUS_INVALID_TEXT;
                 }
            });
            [self connectStatus:strDID didStatus:STATUS_INVALID_TEXT];
        }

            break;
        case PPPP_STATUS_ON_LINE:
        {
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            if (_cameraID) {
                [self starMonitorViewP2P:_cameraID];
            }
            [self connectStatus:strDID didStatus:STATUS_CONNECTING_SUCCESS];
        }
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
        {
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(startPPPP:) withObject:strDID];
                if ([strDID isEqualToString:_cameraID]) {
                    _isWifiLib.textColor = [UIColor redColor];
                    _isWifiLib.text = STATUS_NOT_ONLINE_TEXT;
                    [_loadActivity stopAnimating];
                }
            });
            [self connectStatus:strDID didStatus:STATUS_NOT_ONLINE_TEXT];
        }

            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
        {
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(startPPPP:) withObject:strDID];
                if ([strDID isEqualToString:_cameraID]) {
                    _isWifiLib.textColor = [UIColor redColor];
                    _isWifiLib.text = STATUS_CONNECT_TIMEOUT_TEXT;
                }
            });
            [self connectStatus:strDID didStatus:STATUS_CONNECT_TIMEOUT_TEXT];
        }

            break;
        case PPPP_STATUS_INVALID_USER_PWD:
        {
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([strDID isEqualToString:_cameraID]) {
                    _isWifiLib.textColor = [UIColor redColor];
                    _isWifiLib.text = STATUS_INVALID_USERPWD_TEXT;
                }
            });
            [self connectStatus:strDID didStatus:STATUS_INVALID_USERPWD_TEXT];
        }

            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    NSLog(@"PPPPStatus  %@",strPPPPStatus);
}

-(void) H264Data:(Byte *)h264Frame length:(int)length type:(int)type timestamp:(NSInteger)timestamp
{
    _p2p_timeInterval = timestamp;
    _p2p_dataLeng += length;
}

-(void) setIsWifiText:(UILabel *)isWifiLab WithReach:(AHReach *)reach
{
    if ([reach isReachableViaWiFi]) {
        [isWifiLab setText:@""];
        self.loadLab.hidden = NO;
        _isNetwork = YES;
    }else if ([reach isReachableViaWWAN]){
        _isWifiLib.textColor = [UIColor redColor];
        [isWifiLab setText:@"当前为移动网络，可能会产生意外流量!"];
        self.loadLab.hidden = YES;
        _isNetwork = YES;
    }else{
        _isNetwork = NO;
        _isWifiLib.textColor = [UIColor redColor];
        [isWifiLab setText:@"当前网络连接失败，请查看网络设置!"];
        self.loadLab.hidden = YES;
//        self.image = [UIImage imageNamed:@"monitor.png"];
    }
}

-(void) backMonitor
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MONITORBACK object:nil];
}

-(void) handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (!_isPanges) {
        return;
    }
    if (gestureRecognizer.state == 0) {
        
    }else if (gestureRecognizer.state == 1) {
        self.moveImg.hidden = NO;
        beginPoint = [gestureRecognizer locationInView:self];
        self.moveImg.frame = CGRectMake(beginPoint.x - 50, beginPoint.y - 50 - 30 , 100, 100);
        
    }else if (gestureRecognizer.state == 2){
        CGPoint currPoint = [gestureRecognizer locationInView:self];
        if (currPoint.y > self.frame.size.height) {
            return;
        }
        self.moveImg.frame = CGRectMake(currPoint.x - 50, currPoint.y - 50 - 30 , 100, 100);
    }else if (gestureRecognizer.state == 3){
        
        [Tool soundAction];
        self.moveImg.hidden = YES;
        CGPoint currPoint = [gestureRecognizer locationInView:self];
        const int EVENT_PTZ = 1;
        int curr_event = EVENT_PTZ;
        
        int x1 = beginPoint.x;
        int y1 = beginPoint.y;
        int x2 = currPoint.x;
        int y2 = currPoint.y;
        
        int view_width = self.monitorRight.constant;
        int _width1 = 0;
        int _width2 = view_width  ;
        
        if(x1 >= _width1 && x1 <= _width2)
        {
            curr_event = EVENT_PTZ;
        }
        else
        {
            return;
        }
        
        const int MIN_X_LEN = 60;
        const int MIN_Y_LEN = 60;
        
        int len = (x1 > x2) ? (x1 - x2) : (x2 - x1) ;
        BOOL b_x_ok = (len >= MIN_X_LEN ) ? YES : NO ;
        len = (y1 > y2) ? (y1 - y2) : (y2 - y1) ;
        BOOL b_y_ok = (len > MIN_Y_LEN) ? YES : NO;
        
        BOOL bUp = NO;
        BOOL bDown = NO;
        BOOL bLeft = NO;
        BOOL bRight = NO;
        
        bDown = (y1 > y2) ? NO : YES;
        bUp = !bDown;
        bRight = (x1 > x2) ? NO : YES;
        bLeft = !bRight;
        
        int command = 0;
        
        switch (curr_event)
        {
            case EVENT_PTZ:
            {
                
                if (b_x_ok == YES)
                {
                    if (bLeft == NO)
                    {
                        NSLog(@"left");
                        command = CMD_PTZ_RIGHT;
                        [self moveAnimation:GPS_P2P_MOVE_TOP];
                    }
                    else
                    {
                        NSLog(@"right");

                        
                        command = CMD_PTZ_LEFT;
                        //command = CMD_PTZ_RIGHT;
                        [self moveAnimation:GPS_P2P_MOVE_LEFT];
                        //command = CMD_PTZ_LEFT;
                    }
                    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], command);
                }
                
                if (b_y_ok == YES)
                {
                    
                    if (bUp == NO)
                    {
                        NSLog(@"up");
                        command = CMD_PTZ_DOWN;
                        [self moveAnimation:GPS_P2P_MOVE_RIGHT];
                        
                    }
                    else
                    {
                        NSLog(@"down");
                        command = CMD_PTZ_UP;
                        [self moveAnimation:GPS_P2P_MOVE_BOTTOM];
                    }
                    
                    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], command);
                }
            }
                break;
            default:
                break;
        }
    }else if (gestureRecognizer.state == 4 ){
        
    }else if (gestureRecognizer.state == 5) {
        
    }else if (gestureRecognizer.state == 6) {
        
    }
}

-(void) moveAnimation:(int)marked
{
//    if (new_old == newMonitor) { //实时视频
        self.moveDirection.hidden = NO;
        //    [self stopMoveDirection];
        [self.moveDirection startAnimating];
        
        NSLog(@"width:%f,height:%f",self.frame.size.width,self.frame.size.height);
        
        float height = self.frame.size.height;
        float width = self.frame.size.width;

        if (height > width) {
            float temp = height;
            height = width;
            width = temp;
        }
        
        if (marked == GPS_P2P_MOVE_LEFT) {
            _moveDirection_X.constant = 0;
            _moveDirection_Y.constant = (height-30)/2;
            self.moveDirection.transform = CGAffineTransformMakeRotation(-M_PI);
        }else if (marked == GPS_P2P_MOVE_RIGHT) {
            _moveDirection_X.constant = (width - 30)/2;
            _moveDirection_Y.constant = height - 30;
            self.moveDirection.transform = CGAffineTransformMakeRotation(M_PI/2);
        }else if (marked == GPS_P2P_MOVE_BOTTOM) {
            _moveDirection_X.constant = (width - 30)/2;
            _moveDirection_Y.constant = 0;
            self.moveDirection.transform = CGAffineTransformMakeRotation(-M_PI/2);
        }else if (marked == GPS_P2P_MOVE_TOP) {
            _moveDirection_X.constant = width - 30;
            _moveDirection_Y.constant = (height - 30)/2;
            self.moveDirection.transform = CGAffineTransformMakeRotation(0);
        }
        [self performSelector:@selector(stopMoveDirection) withObject:nil afterDelay:2+moveTime];
//    }
}

-(void) stopMoveDirection
{
    self.moveDirection.hidden = YES;
    [self.moveDirection stopAnimating];
}

-(void) handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [delegate doubleTapAction];
}

@end
