//
//  MRemoteBrandViewController.h
//  Home
//
//  Created by 刘军林 on 15/8/7.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewController.h"

@class MNewDeviceType;

@interface MNewRemoteBrandViewController : MBaseTableViewController

@property (nonatomic, strong) MNewDeviceType *deviceType;
@property (nonatomic, strong) NSString *entityId;

@end
