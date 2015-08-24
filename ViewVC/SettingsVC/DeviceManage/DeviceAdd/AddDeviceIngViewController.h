//
//  AddDeviceIngViewController.h
//  Home
//
//  Created by 刘军林 on 14-8-1.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBaseViewController.h"

@class SettingsViewController;
@class EntityProcess;

@interface AddDeviceIngViewController : MBaseViewController

@property (assign) int devictType;
@property (nonatomic, assign) NSString *entityType;
@property (assign) NSTimer *timer;
@property (nonatomic, strong) IBOutlet UIImageView *loadingImg;
@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (nonatomic, strong) EntityProcess *entityProcess;
@property (nonatomic, strong) SettingsViewController *settingDelegate;

@property (nonatomic, assign) BOOL isAdd;

@end
