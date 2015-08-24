//
//  SenceListViewController.h
//  Home
//
//  Created by 刘军林 on 14-8-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//


#import "MBaseTableViewController.h"
#import "SenceProcess.h"

@interface SenceListViewController : MBaseTableViewController

@property (nonatomic, strong) NSMutableArray *sence_list;
@property (nonatomic, strong) SenceProcess *senceProcess;

@property (assign) int currentIndex;

@end
