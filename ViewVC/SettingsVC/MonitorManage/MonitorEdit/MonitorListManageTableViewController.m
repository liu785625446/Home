//
//  MonitorListManageTableViewController.m
//  Home
//
//  Created by 刘军林 on 14-9-4.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "MonitorListManageTableViewController.h"
#import "FMDatabase.h"
#import "Camerainfos.h"
#import "Interface.h"
#import "MonitorManageCell.h"
#import "MonitorSettingsViewController.h"
#import "CamerainfosProcess.h"

@interface MonitorListManageTableViewController ()

@end

@implementation MonitorListManageTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _camerainfosProcess = [[CamerainfosProcess alloc] init];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _monitorList = [_camerainfosProcess findAllCameraInfos];
    [self.baseTableView reloadData];
    [_camerainfosProcess synchronousCamerainfos:^{
        _monitorList = [_camerainfosProcess findAllCameraInfos];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baseTableView reloadData];
        });
    } didFail:^{
        
    }];
}

#pragma mark Action
-(IBAction)monitorSettingAction:(id)sender
{
    if ([self checkConnectionStatus]) {
        return;
    }
    UIButton *but = (UIButton *)sender;
    Camerainfos *cameraInfo = [_monitorList objectAtIndex:but.tag];
    [self performSegueWithIdentifier:@"MonitorEdit" sender:cameraInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_monitorList count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MonitorManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorManageCell" forIndexPath:indexPath];
    Camerainfos *camerainfo = [_monitorList objectAtIndex:indexPath.row];
    cell.monitorBut.tag = indexPath.row;
    [cell setCamerainfo:camerainfo];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"table select");
    if ([self checkConnectionStatus]) {
        return;
    }
    Camerainfos *cameraInfo = [_monitorList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"MonitorEdit" sender:cameraInfo];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MonitorEdit"]) {
        MonitorSettingsViewController *monitorSet = segue.destinationViewController;
        monitorSet.camerainfo = sender;
    }
}

@end
