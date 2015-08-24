//
//  HBaseViewController.h
//  Home
//
//  Created by 刘军林 on 15/4/20.
//  Copyright (c) 2015年 刘军林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast+UIView.h"
#import "MTopWarnView.h"
@class AHReach;

#define MONITOR_OPEN_NOTIFIER @"monitor_open_notifier"
#define MONITOR_CLOSE_NOTIFIER @"monitor_close_notifier"

@interface MBaseViewController : UIViewController
{
    UIToolbar *toolbar;
}

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topMonitor;

@property (nonatomic, assign) CGRect baseRect;

-(void) resignkeyBoard;

-(void) netStatusChangesAction:(AHReach *)ahReach;
-(void) showMyHUD:(NSString *)msg;
-(void) showFailHUD:(NSString *)msg;
-(void) showSuccessHUD:(NSString *)msg;
-(void) hideMyHUD;
-(UIWindow *) getWindow;
-(void) showMyAlert:(NSString *)msg
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelTitle
  otherButtonTitles:otherTitle
                tag:(int)tag;

-(void) monitorRefresh;

-(BOOL) checkConnectionStatus;

@end
