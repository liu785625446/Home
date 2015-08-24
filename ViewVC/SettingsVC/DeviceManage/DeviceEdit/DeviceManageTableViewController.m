//
//  DeviceManageTableViewController.m
//  Home
//
//  Created by 刘军林 on 14-7-28.
//  Copyright (c) 2014年 刘军林. All rights reserved.
//

#import "DeviceManageTableViewController.h"
#import "Interface.h"
#import "Entity.h"
#import "AddDeviceCell.h"
#import "DeviceEditViewController.h"
#import "const.h"

@interface DeviceManageTableViewController ()

@end

@implementation DeviceManageTableViewController

@synthesize device_list;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _entityProcess = [[EntityProcess alloc] init];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.device_list = [_entityProcess findAllEntity];
    [self.baseTableView reloadData];
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
    return [device_list count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 65, 0, 0)];
    }
    AddDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddDeviceCell"
                                                          forIndexPath:indexPath];
    Entity *entity = [device_list objectAtIndex:indexPath.row];
    [cell setEntity:entity];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    Entity *entity = [device_list objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EditDevice" sender:entity];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditDevice"]) {
        DeviceEditViewController *deviceEdit = segue.destinationViewController;
        deviceEdit.entity = sender;
        deviceEdit.deviceManageDelegate = self;
    }
}

@end
