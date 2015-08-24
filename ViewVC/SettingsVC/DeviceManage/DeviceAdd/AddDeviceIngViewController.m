//
//  AddDeviceIngViewController.m
//  Home
//
//  Created by 刘军林 on 14-8-1.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AddDeviceIngViewController.h"
#import "Interface.h"
#import "Tool.h"
#import "SettingsViewController.h"
#import "config.h"
#import "EntityProcess.h"

@interface AddDeviceIngViewController ()

@end

@implementation AddDeviceIngViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isAdd = YES;
    _entityProcess = [[EntityProcess alloc] init];
    if (_devictType == CURTAIN_SWITCH) {
        [_img setImage:[UIImage imageNamed:@"chuanglianStep2.png"]];
    }else if (_devictType == REMOTE_INFRARED) {
        [_img setImage:[UIImage imageNamed:@"hongwaiyaokongStep2.png"]];
    }else if (_devictType == MAGNETIC) {
        [_img setImage:[UIImage imageNamed:@"menciStep2.png"]];
    }else if (_devictType == PANEL_SWITCH_3) {
        [_img setImage:[UIImage imageNamed:@"sanlumianbanStep2.png"]];
    }else if (_devictType == PANEL_SWITCH_2) {
        [_img setImage:[UIImage imageNamed:@"erlumianbanStep2.png"]];
    }else if (_devictType == PANEL_SWITCH_1) {
        [_img setImage:[UIImage imageNamed:@"yilumianbanStep2.png"]];
    }
    else if (_devictType == SOCKET_SWITCH) {
        [_img setImage:[UIImage imageNamed:@"zhinengchazuoStep2.png"]];
    }else if (_devictType == INFRARED_PROBE) {
        [_img setImage:[UIImage imageNamed:@"hongwaitanceStep2.png"]];
    }else if (_devictType == GAS_DETECTION) {
        [_img setImage:[UIImage imageNamed:@"keranqititanceqiStep2.png"]];
    }else if (_devictType == SMKEN) {
        [_img setImage:[UIImage imageNamed:@"yangantanceqiStep2.png"]];
    }else if (_devictType == REMOTE_RF) {
        [_img setImage:[UIImage imageNamed:@"yaokongqiStep2.png"]];
    }
    _img.contentMode = UIViewContentModeScaleAspectFit;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                              target:self
                                            selector:@selector(timerAction)
                                            userInfo:nil
                                             repeats:YES];
    
    NSString *msg = [NSString stringWithFormat:@"%@&%d",_entityType,_devictType];
    
    [[Interface shareInterface:nil] writeFormatDataAction:@"3"
                                                    didMsg:msg
                                               didCallBack:^(NSString *msg){
                                                   
                                                   [_timer invalidate];
                                                   _timer = nil;

                                                   if (_isAdd) {
                                                       _isAdd = NO;
                                                       NSArray *array = [msg componentsSeparatedByString:@"@"];
                                                       if ([array count] > 1) {
                                                           [self showSuccessHUD:@"设备添加成功!"];
                                                           [self.navigationController popToViewController:_settingDelegate
                                                                                                 animated:YES];
                                                       }else{
                                                           [self showFailHUD:@"设备添加超时!"];
                                                           [self.navigationController popToViewController:_settingDelegate
                                                                                                 animated:YES];
                                                       }
                                                   }
                                                   
                                               }];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

-(void) timerAction
{
    static int i=1;
    if (i==6) {
        i=1;
    }
    [_loadingImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"linkloadingicon00%d",i]]];
    i++;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
