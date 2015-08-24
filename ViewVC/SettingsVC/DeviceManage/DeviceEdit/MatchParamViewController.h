//
//  MatchParamViewController.h
//  Home
//
//  Created by 刘军林 on 14-8-8.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBaseViewController.h"
#import "DeviceEditViewController.h"
#import "DeviceManageTableViewController.h"

@interface MatchParamViewController : MBaseViewController

@property (nonatomic, weak) DeviceManageTableViewController *deviceManageDelegate;
@property (nonatomic, weak) DeviceEditViewController *deviceEditDelegate;

@property (nonatomic, strong) IBOutlet UIButton *matchBut;
@property (nonatomic, strong) IBOutlet UILabel *info;

@property (nonatomic, strong) NSString *patternAmount;
@property (assign) int remoteType;
@property (nonatomic, strong) NSString *entity_id;
@property (assign) int remoteBrandIndex;
@property (nonatomic, strong) NSString *remoteName;

-(IBAction)matchAction:(id)sender;

@end
