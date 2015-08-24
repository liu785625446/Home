//
//  HBaseViewController.m
//  Home
//
//  Created by 刘军林 on 15/4/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseViewController.h"
#import "SVProgressHUD.h"
#import "AHReach.h"
#import "MonitorVideo.h"
#import "Interface.h"

@interface MBaseViewController ()
{
    
}

@property (nonatomic, assign) BOOL isHUD;
@property (nonatomic, strong) NSArray *reachs;
@end

@implementation MBaseViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    _baseRect = [UIScreen mainScreen].bounds;
    
    if (toolbar == nil) {
        UIToolbar *tool= [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.view.bounds.size.width,
                                                                     38.0f)];
        tool.barStyle = UIBarStyleDefault;
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignkeyBoard)];
        [doneBarItem setTintColor:[UIColor grayColor]];
        [tool setItems:[NSArray arrayWithObjects:spaceBarItem, doneBarItem, nil]];
        toolbar=tool;
    }
    
    AHReach *ahReach = [AHReach reachForDefaultHost];
    [ahReach startUpdatingWithBlock:^(AHReach *reach){
        [self netStatusChangesAction:reach];
    }];
    _reachs = [NSArray arrayWithObjects:ahReach, nil];
    self.tabBarController.automaticallyAdjustsScrollViewInsets = NO;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_topMonitor) {
        if ([MonitorVideo shareMonitorVideo].isOpenMonitor) {
            [self monitorOpenNotifier];
        }else{
            [self monitorCloseNotifier];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(monitorOpenNotifier) name:MONITOR_OPEN_NOTIFIER  object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(monitorCloseNotifier) name:MONITOR_CLOSE_NOTIFIER object:nil];
    }
}

-(void) monitorOpenNotifier
{
    _topMonitor.constant = [self getMonitorHeight];
    [self monitorRefresh];
}

-(void) monitorCloseNotifier
{
    _topMonitor.constant = 64;
    [self monitorRefresh];
}

-(void) monitorRefresh
{
    
}

-(BOOL) checkConnectionStatus
{
    if (![Interface shareInterface:nil].isConnection) {
        [MTopWarnView addTopWarnText:S_NETWORK_NO_DETECT_NETWORK_SETTINGS view:self.view];
        return YES;
    }else{
        return NO;
    }
}

-(float) getMonitorHeight
{
    float scale = (float)9 / 16;
    return scale * self.baseRect.size.width;
}


-(void) netStatusChangesAction:(AHReach *)ahReach
{
    
}

-(void) resignkeyBoard
{
    
}

-(void) showMyHUD:(NSString *)msg
{
    _isHUD = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(10);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isHUD) {
                [self showFailHUD:@"连接失败!"];
            }
        });
    });
    [SVProgressHUD showWithStatus:msg maskType:SVProgressHUDMaskTypeBlack];
}

-(void) showSuccessHUD:(NSString *)msg
{
    _isHUD = NO;
    [SVProgressHUD dismissWithSuccess:msg afterDelay:1.0];
}

-(void) showFailHUD:(NSString *)msg
{
    _isHUD = NO;
    [SVProgressHUD dismissWithError:msg afterDelay:1.0];
}

-(void) hideMyHUD
{
    _isHUD = NO;
    [SVProgressHUD dismiss];
}

-(UIWindow *) getWindow
{
    return [[[UIApplication sharedApplication] delegate] window];
}

-(void) showMyAlert:(NSString *)msg delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:otherTitle tag:(int)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:S_PROMPT
                                                    message:msg
                                                   delegate:delegate
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:otherTitle, nil];
    if (tag) {
        alert.tag = tag;
    }
    [alert show];
}

@end
