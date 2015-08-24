//
//  MMonitorViewController.m
//  Home
//
//  Created by 刘军林 on 15/4/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MMonitorViewController.h"
#import "MInitConnectView.h"
#import "Tool.h"
#import "AHReach.h"
#import "MainClass.h"
#import "MGuidePageView.h"
#import "MVerificationView.h"
#import "GesturePasswordView.h"
#import "CamerainfosProcess.h"
#import "Camerainfos.h"
#import "MMonitorCell.h"
#import "MonitorVideo.h"
#import "DateView.h"
#import "EntityProcess.h"
#import "SenceProcess.h"
#import "AlarmInfosProcess.h"
#import "MTopWarnView.h"
#import "MBackMonitorViewController.h"

@interface MMonitorViewController ()<MInitConnectViewDelegate,UIAlertViewDelegate,MGuidePageViewDelegate,GesturePasswordDelegate,VerificationDelegate,MVerificationViewDelegate,MonitorVideoDelegate,DateViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

//@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topMonitor;

@property (nonatomic, strong) MInitConnectView *m_initConnectView;
@property (nonatomic, strong) MVerificationView *m_verificationView;
@property (nonatomic, strong) GesturePasswordView *gesturePwdView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MainClass *m_mainClass;

@property (nonatomic, strong) CamerainfosProcess *camerainfosProcess;
@property (nonatomic, strong) EntityProcess *entityProcess;
@property (nonatomic, strong) SenceProcess *senceProcess;
@property (nonatomic, strong) AlarmInfosProcess *alarmInfosProcess;

@property (nonatomic, strong) Camerainfos *backPlayCamerainfo;

@property (nonatomic, strong) MonitorVideo *monitorImg;
@property (nonatomic, strong) DateView *dateView;
@property (nonatomic, strong) DateView *timeView;
@property (nonatomic, strong) NSMutableArray *monitorBackList;

@property (nonatomic, strong) Camerainfos *currentCameratinfo;

@end

@implementation MMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _window = [self getWindow];
    _m_mainClass = [[MainClass alloc] initWithDelegate:self];
    _camerainfosProcess = [[CamerainfosProcess alloc] init];
    
    _entityProcess = [[EntityProcess alloc] init];
    _senceProcess = [[SenceProcess alloc] init];
    _alarmInfosProcess = [[AlarmInfosProcess alloc] init];
    
//    初始化加载视图
    _m_initConnectView = [[[NSBundle mainBundle] loadNibNamed:@"MInitConnectView" owner:self options:nil] objectAtIndex:0];
    _m_initConnectView.delegate = self;
    [_window addSubview:_m_initConnectView];
    
//    检测绑定盒子
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkBindBox];
    });
    
    _monitorBackList = [[NSMutableArray alloc] initWithCapacity:0];
//    _dateView = [[DateView alloc] initWithFrame:CGRectMake(0, self.baseRect.size.height, self.baseRect.size.width, DATEHEIGHT) DidStyle:DATE];
//    _dateView.delegate = self;
//    _dateView.datePicker.maximumDate = [NSDate date];
//    [_window addSubview:_dateView];
    
//    _timeView = [[DateView alloc] initWithFrame:CGRectMake(0, self.baseRect.size.height, self.baseRect.size.width, DATEHEIGHT) DidStyle:CUSTOM];
//    _timeView.pickerView.delegate = self;
//    _timeView.pickerView.dataSource = self;
//    _timeView.delegate = self;
//    [_window addSubview:_timeView];
//    版本更新
    [Tool getUpdate:self];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.title = @"监控";
    if (_monitorImg) {
        _monitorImg.delegate = self;
    }
    if (!_m_initConnectView) {
        [self syncMonitorData];
    }
}

-(void) netStatusChangesAction:(AHReach *)ahReach
{
    if (BOX_ID_VALUE) {
        [_m_mainClass requestConnectBox:^(NSString *code) {
            //code 身份认证返回状态&服务端程序版本号&房间数据库版本&设备数据库版本&情景数据库版本&摄像头数据库版本
            
            [_m_initConnectView removeInitConnectView];
            _m_initConnectView = nil;
            [self syncMonitorData];
            
        } Fail:^(NSError *result, NSString *errInfo) {
            if (_m_initConnectView) {
                if (errInfo) {
                    [self showMyAlert:errInfo delegate:self cancelButtonTitle:nil otherButtonTitles:S_DEFINE tag:ALERTNETWORKERROR];
                }else {
                    [self showMyAlert:S_CONNECT_FAIL_WHETHER_AGAIN delegate:self cancelButtonTitle:S_CANCEL otherButtonTitles:S_DEFINE tag:ALERTNETWORKERROR];
                }
            }
        }];
    }
//    [MTopWarnView addTopNetworkText:@"网络连接失败，请查看网络设置"];
    
    if (ahReach.isReachableViaWiFi || ahReach.isReachableViaWWAN) {
        [Interface  shareInterface:nil].isNetwork = YES;
    }else{
        [Interface shareInterface:nil].isNetwork = NO;
    }
}

#pragma mark Action
#pragma mark 检测绑定的盒子
-(void) checkBindBox
{
    if (!BOX_ID_VALUE) {
        [self showMyAlert:S_NOT_BOUND_BOX_GO_MRJ_BOUND
                 delegate:self
        cancelButtonTitle:nil
        otherButtonTitles:S_DEFINE
                      tag:ALERTMRJ];
    }
}

#pragma mark 同步摄像头数据
-(void) syncMonitorData
{
    self.baseArray = [_camerainfosProcess findAllCameraInfos];
    [self.baseTableView reloadData];
    [_camerainfosProcess synchronousCamerainfos:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.baseArray = [_camerainfosProcess findAllCameraInfos];
            [self.baseTableView reloadData];
            [self loadMonitorVideo];
        });
    } didFail:^{
        
    }];
}

-(void) syncAnotherData
{
    [_entityProcess synchronousEntity:^{
        [_alarmInfosProcess synchronousAlarmInfos:^{
            
        } didFail:^{
            
        }];
    } didFail:^{
        
    }];
}

-(void) loadMonitorVideo
{
    if (!_monitorImg) {
        _monitorImg = [MonitorVideo shareMonitorVideo];
        _monitorImg.translatesAutoresizingMaskIntoConstraints = NO;
        _monitorImg.delegate = self;
        
        _monitorImg.monitorRight = [NSLayoutConstraint constraintWithItem:_monitorImg attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:self.baseRect.size.width];
        [_monitorImg addConstraint:_monitorImg.monitorRight];
        
        _monitorImg.monitorHeight = [NSLayoutConstraint constraintWithItem:_monitorImg attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:[self getMonitorHeight]];
        [_monitorImg addConstraint:_monitorImg.monitorHeight];
        
        for (int i=0 ; i<[self.baseArray count] ; i++) {
            Camerainfos *camerinfo = [self.baseArray objectAtIndex:i];
            [self.monitorImg contentmonitorP2P:camerinfo.cameraNum];
        }
    }else {
        for (int i=0 ; i<[self.baseArray count] ; i++) {
            Camerainfos *camerinfo = [self.baseArray objectAtIndex:i];
            [self.monitorImg contentmonitorP2P:camerinfo.cameraNum];
        }
    }
}

-(void) openMonitorVideo:(NSInteger)index
{
    self.topMonitor.constant = [self getMonitorHeight];
    [[NSNotificationCenter defaultCenter] postNotificationName:MONITOR_OPEN_NOTIFIER object:nil];

    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar];
    _monitorImg.backgroundColor = [UIColor blackColor];

    [_monitorImg removeFromSuperview];
    [_window addSubview:_monitorImg];
    
    _monitorImg.monitorTop = [NSLayoutConstraint constraintWithItem:_monitorImg attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_window attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
    [_window addConstraint:_monitorImg.monitorTop];
    
    _monitorImg.monitorLeft = [NSLayoutConstraint constraintWithItem:_monitorImg attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_window attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];
    [_window addConstraint:_monitorImg.monitorLeft];
    
    Camerainfos *camerainfo = [self.baseArray objectAtIndex:index];
    _currentCameratinfo = camerainfo;
    [self.baseTableView reloadData];
    [_monitorImg starMonitorViewP2P:camerainfo.cameraNum];
}

-(void) openBackPlayAction
{
    self.topMonitor.constant = [self getMonitorHeight];
    [[NSNotificationCenter defaultCenter] postNotificationName:MONITOR_OPEN_NOTIFIER object:nil];
    [[[[UIApplication sharedApplication] delegate] window] setWindowLevel:UIWindowLevelStatusBar];
    _monitorImg.backgroundColor = [UIColor blackColor];
    
    [_monitorImg removeFromSuperview];
    [_window addSubview:_monitorImg];
    
    _monitorImg.monitorTop = [NSLayoutConstraint constraintWithItem:_monitorImg attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_window attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
    [_window addConstraint:_monitorImg.monitorTop];
    
    _monitorImg.monitorLeft = [NSLayoutConstraint constraintWithItem:_monitorImg attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_window attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];
    [_window addConstraint:_monitorImg.monitorLeft];
}

-(IBAction) openBackMonitlrListAction:(id)sender
{
    UIButton *but = (UIButton *)sender;
    Camerainfos *camerainfo = [self.baseArray objectAtIndex:but.tag];
    [self performSegueWithIdentifier:@"PlayBackMonitor" sender:camerainfo];
    
    
//    _backPlayCamerainfo = camerainfo;
//    _currentCameratinfo = camerainfo;
//    [_monitorImg searchSDRecordFileList:camerainfo.cameraNum date:nil];
}

-(float) getMonitorHeight
{
    float scale = (float)9 / 16;
    return scale * self.baseRect.size.width;
}

#pragma mark 验证界面
-(void) LoadverificationView
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:AUTO_LOGIN] integerValue] != AUTO_LOGIN_OPEN) {
        if ([user objectForKey:GESTUREPASSWORD]) {
            _gesturePwdView = [[GesturePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds didStyle:Verify];
            _gesturePwdView.tentacleView.rerificationDelegate = self;
            _gesturePwdView.tentacleView.style = Verify;
            [_gesturePwdView setGesturePasswordDelegate:self];
            [_gesturePwdView.forgetButton setHidden:YES];
            [_window addSubview:_gesturePwdView];
        }else{
            _m_verificationView = [[[NSBundle mainBundle] loadNibNamed:@"MVerificationView"
                                                                 owner:self
                                                               options:nil] objectAtIndex:0];
            _m_verificationView.delegate = self;
            [_window addSubview:_m_verificationView];
            [Tool customAddAutoLayoutSub:_m_verificationView didSupView:_window];
        }
    }
}

#pragma mark - 
#pragma mark UITableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseArray count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cellidentifier = @"MMonitorCellIdentifier";
    MMonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    
    Camerainfos *camerainfos = [self.baseArray objectAtIndex:indexPath.row];
    cell.backPlayBut.tag = indexPath.row;
    [cell setCamerainfos:camerainfos];
    
    if (camerainfos == _currentCameratinfo) {
        cell.selectWidth.constant = 10;
        cell.selectImg.hidden = NO;
        cell.separatorInset = UIEdgeInsetsMake(0, 85, 0, 0);
    }else{
        cell.selectWidth.constant = 10;
        cell.selectImg.hidden = YES;
        cell.separatorInset = UIEdgeInsetsMake(0, 85, 0, 0);
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkConnectionStatus]) {
        return ;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self openMonitorVideo:indexPath.row];
}

//#pragma mark UIPickerDateDelegate
//-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return [_monitorBackList count];
//}
//
//-(UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
//    NSString *strTime = [NSString stringWithFormat:@"%@",[_monitorBackList objectAtIndex:row]];
//    label.text = [self getTimeFormatStr:strTime];
//    return label;
//}
//
//-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//}

#pragma mark DateViewDelegate
-(void) canelAction:(DateView *)dateView
{
    [_timeView dateViewHideAction];
}

-(void) doneAction:(DateView *)dateView
{
    NSString *str = [_monitorBackList objectAtIndex:[_timeView.pickerView selectedRowInComponent:0]];
    [_monitorImg openBackPlayMonitor:_backPlayCamerainfo.cameraNum RecordFile:str];
}

#pragma mark UIAlertViewDelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALERTMRJ) { //智慧生活授权盒子
        if ([Tool canOpenURL:@"FIS://"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"FIS://Type=Box&AppKey=smarthome"]];
        }
        
    }else if (alertView.tag == ALERTUPDATE) { //版本更新
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://box.360fis.com/file/ios/Home.plist"]];
        }
    }else if (alertView.tag == ALERTNETWORKERROR) { //连接失败
        if (buttonIndex == 0) {
            abort();
        }
    }else if (alertView.tag == ALERTREBINDING) {
        if ([Tool canOpenURL:@"FIS://"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"FIS://Type=Box&AppKey=smarthome"]];
        }
    }
}

#pragma mark MInitConnectViewDelegate
-(void) mInitContentComplete:(MInitConnectView *)connectView
{
    _m_initConnectView = nil;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:MGUIDEPAGEVIEW] isEqualToString:MGUIDEPAGEVIEW]) {
        [self LoadverificationView];
    }else{
        MGuidePageView *guidePageView = [[MGuidePageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        guidePageView.delegate = self;
        [_window addSubview:guidePageView];
    }
}

#pragma mark MGuidePageViewDelegate
-(void) mGuidePageViewComplete:(MGuidePageView *)m_guidePageView
{
    [m_guidePageView removeFromSuperview];
    [self LoadverificationView];
}

#pragma mark MVerificationViewDelegate
-(void) mVerificationViewComplete:(MVerificationView *)verification
{
    [_m_verificationView removeFromSuperview];
}

-(BOOL) verification:(NSString *)result
{
    static int errorCount = 5;
    errorCount --;
    
    if (errorCount == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:GESTUREPASSWORD];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:S_PROMPT message:S_GESTURE_PASSWORD_INPUT_ERRORS delegate:self cancelButtonTitle:S_DEFINE otherButtonTitles:nil];
        alert.tag = ALERTGESTURE;
        [alert show];
        return NO;
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *gesturePassword = [user objectForKey:GESTUREPASSWORD];
    
    if ([[Tool md5:result] isEqualToString:gesturePassword]) {
        
        [_gesturePwdView removeFromSuperview];
        return YES;
    }else {
        [_gesturePwdView.state setTextColor:[UIColor redColor]];
        [_gesturePwdView.state setText:[NSString stringWithFormat:@"密码错误,还可以再输入%d次",errorCount]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_gesturePwdView.tentacleView enterArgin];
            });
        });
        return NO;
    }
}

-(void) change
{
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_gesturePwdView removeFromSuperview];
        _m_verificationView = [[[NSBundle mainBundle] loadNibNamed:@"MVerificationView"
                                                             owner:self
                                                           options:nil] objectAtIndex:0];
        _m_verificationView.delegate = self;
        [_window addSubview:_m_verificationView];
        [Tool customAddAutoLayoutSub:_m_verificationView didSupView:_window];
    } completion:nil];
}

#pragma mark MonitorVideoDelegate
-(void) searchSDCardRecordFileList:(NSMutableArray *)recordList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([recordList count] > 0) {
            [self hideMyHUD];
            _monitorBackList = recordList;
            [_timeView.pickerView reloadAllComponents];
            [_timeView.pickerView selectRow:3 inComponent:0 animated:YES];
            [_timeView dateViewShowAction];
        }else{
            [self showFailHUD:@"无回放记录"];
        }

    });
}

-(void) doubleTapAction
{
    float startX1 = (self.baseRect.size.height - self.baseRect.size.width) / 2;
    if (_monitorImg.frame.size.height > [self getMonitorHeight] + 5) { //横屏切竖屏
        if (_monitorImg.frame.size.height != [self getMonitorHeight]) {
            _monitorImg.transform = CGAffineTransformMakeRotation(0);
            _monitorImg.closeBut.hidden = NO;
            
            _monitorImg.monitorHeight.constant = [self getMonitorHeight];
            _monitorImg.monitorTop.constant = 0;
            _monitorImg.monitorLeft.constant = 0;
            _monitorImg.monitorRight.constant = self.baseRect.size.width;
        }
    }else{
        
        _monitorImg.transform = CGAffineTransformMakeRotation(M_PI / 2);
        _monitorImg.closeBut.hidden = YES;
        
        _monitorImg.monitorHeight.constant = self.baseRect.size.width;
        _monitorImg.monitorRight.constant = self.baseRect.size.height;
        if([Tool getVersion] >= 8.0)
        {
            _monitorImg.monitorTop.constant = startX1;
            _monitorImg.monitorLeft.constant = -startX1;
        }else{
            _monitorImg.monitorTop.constant = 0;
            _monitorImg.monitorLeft.constant = 0;
        }
    }
}

-(void) closeMonitorAction
{
    self.topMonitor.constant = 64;
    _currentCameratinfo = nil;
    [self.baseTableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:MONITOR_CLOSE_NOTIFIER object:nil];

    [_window setWindowLevel:UIWindowLevelNormal];
    [_monitorImg removeFromSuperview];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Camerainfos *camerinfo = (Camerainfos *)sender;
    if ([segue.identifier isEqualToString:@"PlayBackMonitor"]) {
        if (_monitorImg.isOpenMonitor) {
            [_monitorImg closeMonitorP2PAction];
        }
        _monitorImg = nil;
        MBackMonitorViewController *backMonitor = segue.destinationViewController;
        backMonitor.camerainfos = camerinfo;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
