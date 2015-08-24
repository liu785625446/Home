//
//  MonitorSettingsViewController.h
//  Home
//
//  Created by 刘军林 on 14-9-24.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Camerainfos.h"
#import "MonitorEidtCell.h"
#import "MBaseTableViewController.h"
#import "MonitorVideoDelegate.h"
@class CamerainfosProcess;
@class WFSearchResult;

@interface MonitorSettingsViewController : MBaseTableViewController <UITextFieldDelegate, UIAlertViewDelegate,MonitorVideoDelegate>

@property (nonatomic, strong) UITextField *currentText;
@property (nonatomic, strong) MonitorQualityCell *currentCell;
@property (nonatomic, strong) IBOutlet UISwitch *wifiSwitch;

@property (nonatomic, strong) Camerainfos *camerainfo;
@property (nonatomic, strong) NSMutableArray *wifi_list;
@property (nonatomic, strong) NSString *current_wifi_ssid;

@property (nonatomic, strong) WFSearchResult *currentWF;

@property (nonatomic, strong) CamerainfosProcess *camerainfosProcess;

@property (assign) BOOL isWifi;

@property (assign) BOOL isContentP2P;


-(IBAction)deleteMonitorAction:(id)sender;

-(IBAction)switchWifiAction:(id)sender;

@end
