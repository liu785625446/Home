//
//  DeviceManageTableViewController.h
//  Home
//
//  Created by 刘军林 on 14-7-28.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityProcess.h"
#import "MBaseTableViewController.h"

@interface DeviceManageTableViewController : MBaseTableViewController

@property (nonatomic, strong) NSMutableArray *device_list;
@property (nonatomic, strong) EntityProcess *entityProcess;

@end
