//
//  GesturePasswordViewController.h
//  Home
//
//  Created by 刘军林 on 14-10-14.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MBaseTableViewController.h"
#import "TentacleView.h"

@interface GesturePasswordViewController : MBaseTableViewController<UIAlertViewDelegate>

@property (nonatomic, assign) BOOL isGesturePassword;

@property (nonatomic, strong) UISwitch *current_switch;

@property (nonatomic, assign) GestureStyle style;

-(IBAction)gestureSwitch:(id)sender;

@end
