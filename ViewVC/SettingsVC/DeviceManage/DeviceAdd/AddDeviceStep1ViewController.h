//
//  AddDeviceStep1ViewController.h
//  Home
//
//  Created by 刘军林 on 14-8-1.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBaseViewController.h"
@class SettingsViewController;

@interface AddDeviceStep1ViewController : MBaseViewController

@property (assign) int deviceType;
@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (nonatomic, strong) SettingsViewController *settingDelegate;
@property (nonatomic, strong) NSString * entityType;

-(IBAction)nextStepAction:(id)sender;
@end
