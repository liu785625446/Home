//
//  APAddDeviceViewController.h
//  Home
//
//  Created by 刘军林 on 15/6/26.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "SettingsViewController.h"

@interface APAddDeviceViewController : MBaseTableViewController

@property (nonatomic, assign) int deviceType;
@property (nonatomic, strong) SettingsViewController *settingDelegate;
@property (nonatomic, strong) NSMutableArray *apList;

@end
