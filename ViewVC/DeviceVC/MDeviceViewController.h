//
//  MDeviceViewController.h
//  Home
//
//  Created by 刘军林 on 15/4/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "MHorizontalSlidingView.h"

@interface MDeviceViewController : MBaseViewController

@property (nonatomic, strong) NSMutableArray *roomArray;
@property (nonatomic, strong) NSMutableArray *room_device_array;
@property (nonatomic, strong) NSMutableArray *device_type_array;
@property (nonatomic, strong) NSMutableArray *runArray;
@property (nonatomic, strong) IBOutlet MHorizontalSlidingView *slidingView;

@property (nonatomic, strong) NSMutableArray *baseDeviceList;

@property (nonatomic, assign) NSInteger currentTableTag;
@property (nonatomic, strong) UITableView *currentTable;

@property (nonatomic, assign) NSInteger runCurrentRow;

@property (nonatomic, assign) BOOL tapTimer;

@end
