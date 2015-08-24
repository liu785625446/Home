//
//  GesturePasswordSettingsViewController.h
//  Home
//
//  Created by 刘军林 on 14-10-15.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"

@interface GesturePasswordSettingsViewController : UIViewController <ResetDelegate, GesturePasswordDelegate>

@property (nonatomic, strong) GesturePasswordView *gesturePasswordView;
@property (nonatomic, strong) NSString *previousString;

//修改手势密码，验证成功YES，否则NO
@property (nonatomic, assign) BOOL isRetes;

-(IBAction)popAction:(id) sender;
@end
