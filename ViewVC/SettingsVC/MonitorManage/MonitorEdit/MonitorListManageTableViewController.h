//
//  MonitorListManageTableViewController.h
//  Home
//
//  Created by 刘军林 on 14-9-4.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBaseTableViewController.h"

@class CamerainfosProcess;

@interface MonitorListManageTableViewController : MBaseTableViewController

@property (nonatomic, strong) NSMutableArray *monitorList;

@property (nonatomic, strong) CamerainfosProcess *camerainfosProcess;

-(IBAction)monitorSettingAction:(id)sender;
@end
