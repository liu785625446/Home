//
//  MBackMonitorViewController.h
//  Home
//
//  Created by 刘军林 on 15/6/18.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "Camerainfos.h"

@interface MBackMonitorViewController : MBaseTableViewController

@property (nonatomic, strong) Camerainfos *camerainfos;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIWindow *window;

@end
