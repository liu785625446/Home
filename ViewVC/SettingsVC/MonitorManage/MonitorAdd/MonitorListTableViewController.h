//
//  MonitorListTableViewController.h
//  Home
//
//  Created by 刘军林 on 14-9-4.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonitorCell.h"
#import "MBaseTableViewController.h"

@class CamerainfosProcess;

@interface MonitorListTableViewController : MBaseTableViewController <MonitorCellDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *monitorList;
@property (nonatomic, strong) NSMutableArray *bindMonitorList;
@property (nonatomic, strong) NSString *monitorNum;

@property (nonatomic, strong) CamerainfosProcess *camerainfosProcess;

@end
