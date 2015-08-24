//
//  MRoomSelectViewController.h
//  Home
//
//  Created by 刘军林 on 15/5/29.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewController.h"

@class BaseModel;

@interface MRoomSelectViewController : MBaseTableViewController

@property (nonatomic, strong) NSMutableArray *roomList;
@property (nonatomic, strong) BaseModel *baseModel;

//@property (nonatomic,)

-(IBAction)doneAction:(id)sender;

@end
