//
//  RemoteAddSuccessViewController.m
//  Home
//
//  Created by 刘军林 on 14-7-31.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "RemoteAddSuccessViewController.h"

@interface RemoteAddSuccessViewController ()

@end

@implementation RemoteAddSuccessViewController

@synthesize continuanceBut;
@synthesize deviceManageBut;

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
    
    self.continuanceBut.normalColor = [UIColor blueColor];
    self.continuanceBut.selectColor = [UIColor whiteColor];
    self.continuanceBut.selectTitleColor = [UIColor whiteColor];
    self.continuanceBut.normalTitleColor = [UIColor blueColor];
    
    self.deviceManageBut.normalColor = [UIColor blueColor];
    self.deviceManageBut.selectColor = [UIColor whiteColor];
    self.deviceManageBut.selectTitleColor = [UIColor whiteColor];
    self.deviceManageBut.normalTitleColor = [UIColor blueColor];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark Action
-(IBAction)continuanceAddAction:(id)sender
{
    [self.navigationController popToViewController:_deviceEditDelegate animated:YES];
}

-(IBAction)deviceManageAction:(id)sender
{
    [self.navigationController popToViewController:_devicemanageDelegate animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
