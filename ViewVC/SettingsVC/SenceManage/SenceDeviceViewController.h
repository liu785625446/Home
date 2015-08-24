//
//  SenceDeviceViewController.h
//  Home
//
//  Created by 刘军林 on 14-8-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "SenceAirEditViewController.h"
#import "AddSenceViewController.h"
#import "Sence.h"

@class EntityProcess;
@class EntityRemoteProcess;

@interface SenceDeviceViewController : MBaseTableViewController <SenceAirEditDelegate>

@property (nonatomic, strong) AddSenceViewController *senceDelegate;

@property (nonatomic, strong) EntityProcess *entityProcess;
@property (nonatomic, strong) EntityRemoteProcess *entityRemoteProcess;

@property (nonatomic, strong) Sence *sence;
@property (nonatomic, strong) NSMutableArray *device_list;

@property (nonatomic, strong) NSMutableArray *selectDevice_list;

@property (assign) int currentIndex;

-(IBAction)deviceSwitchAction:(id)sender;

@end
