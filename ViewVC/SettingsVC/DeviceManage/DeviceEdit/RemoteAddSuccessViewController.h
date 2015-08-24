//
//  RemoteAddSuccessViewController.h
//  Home
//
//  Created by 刘军林 on 14-7-31.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@class DeviceManageTableViewController;
@class DeviceEditViewController;

@interface RemoteAddSuccessViewController : UIViewController

@property (nonatomic, strong) IBOutlet CustomButton *continuanceBut;
@property (nonatomic, strong) IBOutlet CustomButton *deviceManageBut;

@property (nonatomic, weak) DeviceManageTableViewController *devicemanageDelegate;
@property (nonatomic, weak) DeviceEditViewController *deviceEditDelegate;

-(IBAction)continuanceAddAction:(id)sender;
-(IBAction)deviceManageAction:(id)sender;

@end
