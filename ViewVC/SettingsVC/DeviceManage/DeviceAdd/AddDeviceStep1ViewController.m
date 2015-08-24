//
//  AddDeviceStep1ViewController.m
//  Home
//
//  Created by 刘军林 on 14-8-1.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "AddDeviceStep1ViewController.h"
#import "AddDeviceIngViewController.h"
#import "config.h"

@interface AddDeviceStep1ViewController ()

@end

@implementation AddDeviceStep1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_deviceType == CURTAIN_SWITCH) {
        [_img setImage:[UIImage imageNamed:@"chuanglianStep1.png"]];
    }else if (_deviceType == REMOTE_INFRARED) {
        [_img setImage:[UIImage imageNamed:@"hongwaiyaokongStep1.png"]];
    }else if (_deviceType == MAGNETIC) {
        [_img setImage:[UIImage imageNamed:@"menciStep1.png"]];
    }else if (_deviceType == PANEL_SWITCH_3) {
        [_img setImage:[UIImage imageNamed:@"sanlumianbanStep1.png"]];
    }else if (_deviceType == PANEL_SWITCH_2) {
        [_img setImage:[UIImage imageNamed:@"erlumianbanStep1.png"]];
    }else if (_deviceType == PANEL_SWITCH_1) {
        [_img setImage:[UIImage imageNamed:@"yilumianbanStep1.png"]];
    }
    else if (_deviceType == SOCKET_SWITCH) {
        [_img setImage:[UIImage imageNamed:@"zhinengchazuoStep1.png"]];
    }else if (_deviceType == INFRARED_PROBE) {
        [_img setImage:[UIImage imageNamed:@"hongwaitanceStep1.png"]];
    }else if (_deviceType == GAS_DETECTION) {
        [_img setImage:[UIImage imageNamed:@"keranqititanceqiStep1.png"]];
    }else if (_deviceType == SMKEN) {
        [_img setImage:[UIImage imageNamed:@"yangantanceqiStep1.png"]];
    }else if (_deviceType == REMOTE_RF) {
        [_img setImage:[UIImage imageNamed:@"yaokongqiStep1.png"]];
    }
    
    _img.contentMode = UIViewContentModeScaleAspectFit;
    NSLog(@"width:%f, height:%f",_img.frame.size.width, _img.frame.size.height);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Action
-(IBAction)nextStepAction:(id)sender
{
    [self performSegueWithIdentifier:@"StepIng" sender:nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"StepIng"]) {
        AddDeviceIngViewController *loadIng = segue.destinationViewController;
        loadIng.devictType = _deviceType;
        loadIng.settingDelegate = _settingDelegate;
        loadIng.entityType = _entityType;
    }
}

@end
