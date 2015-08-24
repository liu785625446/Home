//
//  MBaseTableViewController.h
//  Home
//
//  Created by 刘军林 on 15/4/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseViewController.h"



@interface MBaseTableViewController : MBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *baseTableView;
@property (nonatomic, strong) NSMutableArray *baseArray;

-(float) getMonitorHeight;

@end
